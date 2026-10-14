#!/usr/bin/env python3
"""Generate VIETNAMESE_LUNAR_YEAR_INFO rows for lib/holidays/date_calculator/lunar_date.rb.

Dev-only tool, not a runtime dependency of the gem. It computes new moons and
principal solar terms from the JPL DE440s ephemeris with skyfield, converts
them to Vietnamese civil dates and applies the standard lunisolar rules:

  * a month starts on the local date of its new moon
  * the month containing the winter solstice (sun at 270 degrees) is month 11
  * in a year with 13 months between two month 11s, the first month without
    a principal term (sun at a multiple of 30 degrees) is the leap month

Vietnam used UTC+8 until North Vietnam switched to UTC+7 on 1967-08-08. The
South kept UTC+8 until 1975, so the two celebrated Tet 1968 on different
days; the North's UTC+7 is used here from 1967-08-08 on.

Each row is [total days, type of month 1, ..., type of month 12], where the
type is a key of LUNARDAYS_FOR_MONTHTYPE: 1 = 29 days, 2 = 30 days, and 3..6
mean the month is followed by a leap month (3 = 29+29, 4 = 30+29, 5 = 29+30,
6 = 30+30).

Usage:

  python3 -m venv /tmp/lunar-venv
  /tmp/lunar-venv/bin/pip install skyfield
  curl -LO https://ssd.jpl.nasa.gov/ftp/eph/planets/bsp/de440s.bsp
  /tmp/lunar-venv/bin/python script/generate_vietnamese_lunar_table.py \
    de440s.bsp [first_year] [last_year]

The years default to 1900..2049. Rows are printed to stdout in the Ruby
format used by lunar_date.rb. Events within 10 minutes of local midnight are
reported on stderr, since those are the dates most sensitive to the
ephemeris and time zone.
"""

import math
import sys
from datetime import date

from skyfield import almanac
from skyfield.api import load, load_file
from skyfield.framelib import ecliptic_frame

MONTH_TYPE = {(29, 29): 3, (30, 29): 4, (29, 30): 5, (30, 30): 6}
UTC7_FROM_JD = 2439710.5  # 1967-08-08 00:00 UT
JD_TO_ORDINAL = 1721425
NEAR_MIDNIGHT_MINUTES = 10


def zone_hours(jd_ut):
    return 7.0 if jd_ut >= UTC7_FROM_JD else 8.0


def local_date(t):
    jd = t.ut1 + zone_hours(t.ut1) / 24.0
    frac = (jd + 0.5) % 1.0
    margin_minutes = min(frac, 1.0 - frac) * 1440
    return date.fromordinal(int(math.floor(jd + 0.5)) - JD_TO_ORDINAL), margin_minutes


def events(eph, ts, first_year, last_year):
    t0, t1 = ts.utc(first_year - 1, 10, 1), ts.utc(last_year + 2, 3, 1)
    times, phases = almanac.find_discrete(t0, t1, almanac.moon_phases(eph))
    new_moons = [local_date(t) for t, p in zip(times, phases) if p == 0]

    earth, sun = eph['earth'], eph['sun']

    def segment(t):
        lon = earth.at(t).observe(sun).apparent().frame_latlon(ecliptic_frame)[1].degrees
        return (lon // 30).astype(int) % 12

    segment.step_days = 10
    times, segs = almanac.find_discrete(t0, t1, segment)
    terms = [(local_date(t), int(s) * 30) for t, s in zip(times, segs)]
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


def main(argv):
    if len(argv) < 2:
        sys.exit(__doc__)
    first_year = int(argv[2]) if len(argv) > 2 else 1900
    last_year = int(argv[3]) if len(argv) > 3 else 2049

    ts = load.timescale()
    new_moons, terms = events(load_file(argv[1]), ts, first_year, last_year)
    months, labels = label_months(new_moons, terms)
    rows = build_rows(months, labels)

    if first_year == 1900 and rows[1900][0] != date(1900, 1, 31):
        sys.exit('lunar year 1900 must start on SOLAR_START_DATE (1900-01-31)')

    for d, margin in new_moons:
        if margin < NEAR_MIDNIGHT_MINUTES and first_year <= d.year <= last_year:
            print('new moon on %s is %.1f min from local midnight' % (d, margin), file=sys.stderr)
    for (d, margin), lon in terms:
        if margin < NEAR_MIDNIGHT_MINUTES and first_year <= d.year <= last_year:
            print('sun at %d deg on %s is %.1f min from local midnight' % (lon, d, margin), file=sys.stderr)

    for year in range(first_year, last_year + 1):
        print('        [%s].freeze,' % ', '.join(str(v) for v in rows[year][1]))


if __name__ == '__main__':
    main(sys.argv)
