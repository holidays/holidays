# encoding: utf-8
module Holidays
  REGIONS = [:ar, :at, :au, :au_nsw, :au_vic, :au_qld, :au_nt, :au_act, :au_sa, :au_wa, :au_tas, :au_tas_south, :au_qld_cairns, :au_qld_brisbane, :au_tas_north, :au_vic_melbourne, :be_fr, :be_nl, :br, :bg_en, :bg_bg, :ca, :ca_qc, :ca_ab, :ca_sk, :ca_on, :ca_bc, :ca_nb, :ca_mb, :ca_ns, :ca_pe, :ca_nl, :ca_nt, :ca_nu, :ca_yt, :us, :ch_zh, :ch_be, :ch_lu, :ch_ur, :ch_sz, :ch_ow, :ch_nw, :ch_gl, :ch_zg, :ch_fr, :ch_so, :ch_bs, :ch_bl, :ch_sh, :ch_ar, :ch_ai, :ch_sg, :ch_gr, :ch_ag, :ch_tg, :ch_ti, :ch_vd, :ch_ne, :ch_ge, :ch_ju, :ch_vs, :ch, :cl, :cr, :cz, :dk, :de, :de_bw, :de_by, :de_he, :de_nw, :de_rp, :de_sl, :de_sn_sorbian, :de_th_cath, :de_sn, :de_st, :de_by_cath, :de_by_augsburg, :de_bb, :de_mv, :de_th, :ecb_target, :ee, :el, :es_pv, :es_na, :es_an, :es_ib, :es_cm, :es_mu, :es_m, :es_ar, :es_cl, :es_cn, :es_lo, :es_ga, :es_ce, :es_o, :es_ex, :es, :es_ct, :es_v, :es_vc, :federal_reserve, :fedex, :fi, :fr_a, :fr_m, :fr, :gb, :gb_eng, :gb_wls, :gb_eaw, :gb_nir, :je, :gb_jsy, :gg, :gb_gsy, :gb_sct, :gb_con, :im, :gb_iom, :ge, :hr, :hk, :hu, :ie, :is, :it, :kr, :li, :lt, :ma, :mt_mt, :mt_en, :mx, :mx_pue, :nerc, :nl, :lu, :no, :nyse, :nz, :nz_sl, :nz_we, :nz_ak, :nz_nl, :nz_ne, :nz_ot, :nz_ta, :nz_sc, :nz_hb, :nz_mb, :nz_ca, :nz_ch, :nz_wl, :pe, :ph, :pl, :pt, :pt_li, :pt_po, :ro, :rs_cyrl, :rs_la, :ru, :se, :tn, :tr, :us_fl, :us_la, :us_ct, :us_de, :us_gu, :us_hi, :us_in, :us_ky, :us_nj, :us_nc, :us_nd, :us_pr, :us_tn, :us_ms, :us_id, :us_ar, :us_tx, :us_dc, :us_md, :us_va, :us_il, :us_vt, :us_ak, :us_ca, :us_me, :us_ma, :us_al, :us_ga, :us_ne, :us_mo, :us_sc, :us_wv, :us_vi, :us_ut, :us_ri, :us_az, :us_co, :us_mt, :us_nm, :us_ny, :us_oh, :us_pa, :us_mi, :us_mn, :us_nv, :us_or, :us_sd, :us_wa, :us_wi, :us_wy, :us_ia, :us_ks, :us_nh, :us_ok, :united_nations, :ups, :za, :sk, :si, :jp, :ve, :vi, :sg, :my]

  PARENT_REGION_LOOKUP = {:ar=>:ar, :at=>:at, :au=>:au, :au_nsw=>:au, :au_vic=>:au, :au_qld=>:au, :au_nt=>:au, :au_act=>:au, :au_sa=>:au, :au_wa=>:au, :au_tas=>:au, :au_tas_south=>:au, :au_qld_cairns=>:au, :au_qld_brisbane=>:au, :au_tas_north=>:au, :au_vic_melbourne=>:au, :be_fr=>:be_fr, :be_nl=>:be_nl, :br=>:br, :bg_en=>:bg, :bg_bg=>:bg, :ca=>:ca, :ca_qc=>:ca, :ca_ab=>:ca, :ca_sk=>:ca, :ca_on=>:ca, :ca_bc=>:ca, :ca_nb=>:ca, :ca_mb=>:ca, :ca_ns=>:ca, :ca_pe=>:ca, :ca_nl=>:ca, :ca_nt=>:ca, :ca_nu=>:ca, :ca_yt=>:ca, :us=>:us, :ch_zh=>:ch, :ch_be=>:ch, :ch_lu=>:ch, :ch_ur=>:ch, :ch_sz=>:ch, :ch_ow=>:ch, :ch_nw=>:ch, :ch_gl=>:ch, :ch_zg=>:ch, :ch_fr=>:ch, :ch_so=>:ch, :ch_bs=>:ch, :ch_bl=>:ch, :ch_sh=>:ch, :ch_ar=>:ch, :ch_ai=>:ch, :ch_sg=>:ch, :ch_gr=>:ch, :ch_ag=>:ch, :ch_tg=>:ch, :ch_ti=>:ch, :ch_vd=>:ch, :ch_ne=>:ch, :ch_ge=>:ch, :ch_ju=>:ch, :ch_vs=>:ch, :ch=>:ch, :cl=>:cl, :cr=>:cr, :cz=>:cz, :dk=>:dk, :de=>:de, :de_bw=>:de, :de_by=>:de, :de_he=>:de, :de_nw=>:de, :de_rp=>:de, :de_sl=>:de, :de_sn_sorbian=>:de, :de_th_cath=>:de, :de_sn=>:de, :de_st=>:de, :de_by_cath=>:de, :de_by_augsburg=>:de, :de_bb=>:de, :de_mv=>:de, :de_th=>:de, :ecb_target=>:ecb_target, :ee=>:ee, :el=>:el, :es_pv=>:es, :es_na=>:es, :es_an=>:es, :es_ib=>:es, :es_cm=>:es, :es_mu=>:es, :es_m=>:es, :es_ar=>:es, :es_cl=>:es, :es_cn=>:es, :es_lo=>:es, :es_ga=>:es, :es_ce=>:es, :es_o=>:es, :es_ex=>:es, :es=>:es, :es_ct=>:es, :es_v=>:es, :es_vc=>:es, :federal_reserve=>:federal_reserve, :fedex=>:fedex, :fi=>:fi, :fr_a=>:fr, :fr_m=>:fr, :fr=>:fr, :gb=>:gb, :gb_eng=>:gb, :gb_wls=>:gb, :gb_eaw=>:gb, :gb_nir=>:gb, :je=>:gb, :gb_jsy=>:gb, :gg=>:gb, :gb_gsy=>:gb, :gb_sct=>:gb, :gb_con=>:gb, :im=>:gb, :gb_iom=>:gb, :ge=>:ge, :hr=>:hr, :hk=>:hk, :hu=>:hu, :ie=>:ie, :is=>:is, :it=>:it, :kr=>:kr, :li=>:li, :lt=>:lt, :ma=>:ma, :mt_mt=>:mt_mt, :mt_en=>:mt_en, :mx=>:mx, :mx_pue=>:mx, :nerc=>:nerc, :nl=>:nl, :lu=>:lu, :no=>:no, :nyse=>:nyse, :nz=>:nz, :nz_sl=>:nz, :nz_we=>:nz, :nz_ak=>:nz, :nz_nl=>:nz, :nz_ne=>:nz, :nz_ot=>:nz, :nz_ta=>:nz, :nz_sc=>:nz, :nz_hb=>:nz, :nz_mb=>:nz, :nz_ca=>:nz, :nz_ch=>:nz, :nz_wl=>:nz, :pe=>:pe, :ph=>:ph, :pl=>:pl, :pt=>:pt, :pt_li=>:pt, :pt_po=>:pt, :ro=>:ro, :rs_cyrl=>:rs_cyrl, :rs_la=>:rs_la, :ru=>:ru, :se=>:se, :tn=>:tn, :tr=>:tr, :us_fl=>:us, :us_la=>:us, :us_ct=>:us, :us_de=>:us, :us_gu=>:us, :us_hi=>:us, :us_in=>:us, :us_ky=>:us, :us_nj=>:us, :us_nc=>:us, :us_nd=>:us, :us_pr=>:us, :us_tn=>:us, :us_ms=>:us, :us_id=>:us, :us_ar=>:us, :us_tx=>:us, :us_dc=>:us, :us_md=>:us, :us_va=>:us, :us_il=>:us, :us_vt=>:us, :us_ak=>:us, :us_ca=>:us, :us_me=>:us, :us_ma=>:us, :us_al=>:us, :us_ga=>:us, :us_ne=>:us, :us_mo=>:us, :us_sc=>:us, :us_wv=>:us, :us_vi=>:us, :us_ut=>:us, :us_ri=>:us, :us_az=>:us, :us_co=>:us, :us_mt=>:us, :us_nm=>:us, :us_ny=>:us, :us_oh=>:us, :us_pa=>:us, :us_mi=>:us, :us_mn=>:us, :us_nv=>:us, :us_or=>:us, :us_sd=>:us, :us_wa=>:us, :us_wi=>:us, :us_wy=>:us, :us_ia=>:us, :us_ks=>:us, :us_nh=>:us, :us_ok=>:us, :united_nations=>:united_nations, :ups=>:ups, :za=>:za, :sk=>:europe, :si=>:europe, :jp=>:jp, :ve=>:ve, :vi=>:vi, :sg=>:sg, :my=>:my}
end
