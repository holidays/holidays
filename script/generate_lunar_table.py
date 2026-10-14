#!/usr/bin/env python3
"""Generate lunar year rows for lib/holidays/date_calculator/lunar_date.rb.

Dev-only tool, not a runtime dependency of the gem. It computes new moons and
principal solar terms from the JPL DE440s ephemeris with skyfield, converts
them to local civil dates and applies the standard lunisolar rules:

  * a month starts on the local date of its new moon
  * the month containing the winter solstice (sun at 270 degrees) is month 11
  * in a year with 13 months between two month 11s, the first month without
    a principal term (sun at a multiple of 30 degrees) is the leap month

Calendars and the time zone each one is computed for:

  kr  KOREAN_LUNAR_YEAR_INFO: UTC+9. Before 1912 the Korean table follows
      the Chinese reckoning at UTC+8.
  vn  VIETNAMESE_LUNAR_YEAR_INFO: UTC+8 until North Vietnam switched to
      UTC+7 on 1967-08-08. The South kept UTC+8 until 1975, so the two
      celebrated Tet 1968 on different days; the North's UTC+7 is used here.
  cn  CHINESE_LUNAR_YEAR_INFO (cn, hk, sg): UTC+8. The documented source
      for 1901..2099 is the Hong Kong Observatory's Gregorian-Lunar calendar
      conversion tables. Pass --hko DIR (a directory holding T1901e.txt ..
      T2100e.txt from
      https://www.hko.gov.hk/en/gts/time/calendar/text/files/T<year>e.txt)
      to take those years from the HKO tables; the ephemeris fills the
      remaining years. The ephemeris alone differs from HKO in 1914, 1915,
      1916, 1920 (China did not keep UTC+8 before 1929) and in 2057 and 2097
      (new moons within two minutes of midnight). Every such difference is
      reported on stderr.

Each row is [total days, type of month 1, ..., type of month 12], where the
type is a key of LUNARDAYS_FOR_MONTHTYPE: 1 = 29 days, 2 = 30 days, and 3..6
mean the month is followed by a leap month (3 = 29+29, 4 = 30+29, 5 = 29+30,
6 = 30+30).

Usage:

  python3 -m venv /tmp/lunar-venv
  /tmp/lunar-venv/bin/pip install skyfield
  curl -LO https://ssd.jpl.nasa.gov/ftp/eph/planets/bsp/de440s.bsp
  /tmp/lunar-venv/bin/python script/generate_lunar_table.py \
    {kr,vn,cn} de440s.bsp [first_year] [last_year] [--hko DIR]

The years default to 1900..2100. Rows are printed to stdout in the Ruby
format used by lunar_date.rb. Events within 10 minutes of local midnight are
reported on stderr, since those are the dates most sensitive to the
ephemeris and time zone.
"""

import math
import os
import re
import sys
from datetime import date

MONTH_TYPE = {(29, 29): 3, (30, 29): 4, (29, 30): 5, (30, 30): 6}
JD_TO_ORDINAL = 1721425
NEAR_MIDNIGHT_MINUTES = 10
FIRST_YEAR, LAST_YEAR = 1900, 2100

VN_UTC7_FROM_JD = 2439710.5  # 1967-08-08 00:00 UT
KR_UTC9_FROM_JD = 2419402.5  # 1912-01-01 00:00 UT

ZONES = {
    'kr': lambda jd_ut: 9.0 if jd_ut >= KR_UTC9_FROM_JD else 8.0,
    'vn': lambda jd_ut: 7.0 if jd_ut >= VN_UTC7_FROM_JD else 8.0,
    'cn': lambda jd_ut: 8.0,
}

HKO_MONTH_LINE = re.compile(r'(\d{4})/(\d+)/(\d+)\s+(\d+)\w*\s+Lunar [Mm]onth')


def local_date(t, zone):
    jd = t.ut1 + zone(t.ut1) / 24.0
    frac = (jd + 0.5) % 1.0
    margin_minutes = min(frac, 1.0 - frac) * 1440
    return date.fromordinal(int(math.floor(jd + 0.5)) - JD_TO_ORDINAL), margin_minutes


def events(path, zone, first_year, last_year):
    from skyfield import almanac
    from skyfield.api import load, load_file
    from skyfield.framelib import ecliptic_frame

    eph, ts = load_file(path), load.timescale()
    t0, t1 = ts.utc(first_year - 1, 10, 1), ts.utc(last_year + 2, 3, 1)
    times, phases = almanac.find_discrete(t0, t1, almanac.moon_phases(eph))
    new_moons = [local_date(t, zone) for t, p in zip(times, phases) if p == 0]

    earth, sun = eph['earth'], eph['sun']

    def segment(t):
        lon = earth.at(t).observe(sun).apparent().frame_latlon(ecliptic_frame)[1].degrees
        return (lon // 30).astype(int) % 12

    segment.step_days = 10
    times, segs = almanac.find_discrete(t0, t1, segment)
    terms = [(local_date(t, zone), int(s) * 30) for t, s in zip(times, segs)]
    return new_moons, terms


def label_months(new_moons, terms):
    months = []
    for (start, _), (end, _) in zip(new_moons, new_moons[1:]):
        principal = [lon for (d, _), lon in terms if start <= d < end]
        months.append({'start': start, 'len': (end - start).days, 'terms': principal})

    elevens = [i for i, m in enumerate(months) if 270 in m['terms']]
    labels = {}
    for i, j in zip(elevens, elevens[1:]):
        leap = None
        if j - i == 13:
            leap = next(x for x in range(i + 1, j) if not months[x]['terms'])
        num = 11
        labels[i] = (11, False)
        for x in range(i + 1, j):
            if x == leap:
                labels[x] = (num, True)
            else:
                num = num % 12 + 1
                labels[x] = (num, False)
    return months, labels


def build_rows(months, labels):
    rows = {}
    starts = [i for i in sorted(labels) if labels[i] == (1, False)]
    for i, j in zip(starts, starts[1:]):
        lengths = {}
        for x in range(i, j):
            num, leap = labels[x]
            lengths.setdefault(num, [None, None])[1 if leap else 0] = months[x]['len']
        row = [sum(months[x]['len'] for x in range(i, j))]
        for num in range(1, 13):
            normal, leap = lengths[num]
            row.append(MONTH_TYPE[(normal, leap)] if leap else (1 if normal == 29 else 2))
        rows[months[i]['start'].year] = (months[i]['start'], row)
    return rows


def hko_rows(directory):
    """Rows for every lunar year fully covered by the HKO tables in directory."""
    starts = []
    for name in sorted(os.listdir(directory)):
        if not re.fullmatch(r'T\d{4}e\.txt', name):
            continue
        with open(os.path.join(directory, name), encoding='latin-1') as f:
            for line in f:
                m = HKO_MONTH_LINE.match(line)
                if m:
                    starts.append((date(int(m[1]), int(m[2]), int(m[3])), int(m[4])))

    months, labels = [], {}
    for i, ((start, num), (end, _)) in enumerate(zip(starts, starts[1:])):
        months.append({'start': start, 'len': (end - start).days})
        labels[i] = (num, i > 0 and starts[i - 1][1] == num)
    first_one = next(i for i in labels if labels[i] == (1, False))
    return build_rows(months, {i: l for i, l in labels.items() if i >= first_one})


def report_near_midnight(new_moons, terms, first_year, last_year):
    for d, margin in new_moons:
        if margin < NEAR_MIDNIGHT_MINUTES and first_year <= d.year <= last_year:
            print('new moon on %s is %.1f min from local midnight' % (d, margin), file=sys.stderr)
    for (d, margin), lon in terms:
        if margin < NEAR_MIDNIGHT_MINUTES and first_year <= d.year <= last_year:
            print('sun at %d deg on %s is %.1f min from local midnight' % (lon, d, margin), file=sys.stderr)


def parse_args(argv):
    args = list(argv[1:])
    hko = None
    if '--hko' in args:
        i = args.index('--hko')
        hko = args[i + 1]
        del args[i:i + 2]
    if len(args) < 2 or args[0] not in ZONES:
        sys.exit(__doc__)
    first_year = int(args[2]) if len(args) > 2 else FIRST_YEAR
    last_year = int(args[3]) if len(args) > 3 else LAST_YEAR
    return args[0], args[1], first_year, last_year, hko


def main(argv):
    calendar, ephemeris, first_year, last_year, hko = parse_args(argv)

    new_moons, terms = events(ephemeris, ZONES[calendar], first_year, last_year)
    rows = build_rows(*label_months(new_moons, terms))

    if first_year == 1900 and rows[1900][0] != date(1900, 1, 31):
        sys.exit('lunar year 1900 must start on SOLAR_START_DATE (1900-01-31)')

    if calendar == 'cn' and hko:
        for year, (start, row) in hko_rows(hko).items():
            if year in rows and rows[year] != (start, row):
                print('%d: HKO %s differs from ephemeris %s' % (year, row, rows[year][1]), file=sys.stderr)
            rows[year] = (start, row)
    elif calendar == 'cn':
        print('no --hko given: 1901..2099 are ephemeris rows, not HKO rows', file=sys.stderr)

    report_near_midnight(new_moons, terms, first_year, last_year)

    for year in range(first_year, last_year + 1):
        print('        [%s].freeze,' % ', '.join(str(v) for v in rows[year][1]))


if __name__ == '__main__':
    main(sys.argv)
