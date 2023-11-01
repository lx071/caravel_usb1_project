// This is the unpowered netlist.
module dg_pll (dco,
    enable,
    osc,
    resetb,
    clockp,
    div,
    ext_trim);
 input dco;
 input enable;
 input osc;
 input resetb;
 output [1:0] clockp;
 input [4:0] div;
 input [25:0] ext_trim;

 wire _000_;
 wire _001_;
 wire _002_;
 wire _003_;
 wire _004_;
 wire _005_;
 wire _006_;
 wire _007_;
 wire _008_;
 wire _009_;
 wire _010_;
 wire _011_;
 wire _012_;
 wire _013_;
 wire _014_;
 wire _015_;
 wire _016_;
 wire _017_;
 wire _018_;
 wire _019_;
 wire _020_;
 wire _021_;
 wire _022_;
 wire _023_;
 wire _024_;
 wire _025_;
 wire _026_;
 wire _027_;
 wire _028_;
 wire _029_;
 wire _030_;
 wire _031_;
 wire _032_;
 wire _033_;
 wire _034_;
 wire _035_;
 wire _036_;
 wire _037_;
 wire _038_;
 wire _039_;
 wire _040_;
 wire _041_;
 wire _042_;
 wire _043_;
 wire _044_;
 wire _045_;
 wire _046_;
 wire _047_;
 wire _048_;
 wire _049_;
 wire _050_;
 wire _051_;
 wire _052_;
 wire _053_;
 wire _054_;
 wire _055_;
 wire _056_;
 wire _057_;
 wire _058_;
 wire _059_;
 wire _060_;
 wire _061_;
 wire _062_;
 wire _063_;
 wire _064_;
 wire _065_;
 wire _066_;
 wire _067_;
 wire _068_;
 wire _069_;
 wire _070_;
 wire _071_;
 wire _072_;
 wire _073_;
 wire _074_;
 wire _075_;
 wire _076_;
 wire _077_;
 wire _078_;
 wire _079_;
 wire _080_;
 wire _081_;
 wire _082_;
 wire _083_;
 wire _084_;
 wire _085_;
 wire _086_;
 wire _087_;
 wire _088_;
 wire _089_;
 wire _090_;
 wire _091_;
 wire _092_;
 wire _093_;
 wire _094_;
 wire _095_;
 wire _096_;
 wire _097_;
 wire _098_;
 wire _099_;
 wire _100_;
 wire _101_;
 wire _102_;
 wire _103_;
 wire _104_;
 wire _105_;
 wire _106_;
 wire _107_;
 wire _108_;
 wire _109_;
 wire _110_;
 wire _111_;
 wire _112_;
 wire _113_;
 wire _114_;
 wire _115_;
 wire _116_;
 wire _117_;
 wire _118_;
 wire _119_;
 wire _120_;
 wire _121_;
 wire _122_;
 wire _123_;
 wire _124_;
 wire _125_;
 wire _126_;
 wire _127_;
 wire _128_;
 wire _129_;
 wire _130_;
 wire _131_;
 wire _132_;
 wire _133_;
 wire _134_;
 wire _135_;
 wire _136_;
 wire _137_;
 wire _138_;
 wire _139_;
 wire _140_;
 wire _141_;
 wire _142_;
 wire _143_;
 wire _144_;
 wire _145_;
 wire _146_;
 wire _147_;
 wire _148_;
 wire _149_;
 wire _150_;
 wire _151_;
 wire _152_;
 wire _153_;
 wire _154_;
 wire _155_;
 wire _156_;
 wire _157_;
 wire _158_;
 wire _159_;
 wire _160_;
 wire _161_;
 wire _162_;
 wire _163_;
 wire _164_;
 wire _165_;
 wire _166_;
 wire _167_;
 wire _168_;
 wire _169_;
 wire _170_;
 wire _171_;
 wire _172_;
 wire _173_;
 wire \pll_control.clock ;
 wire \pll_control.count0[0] ;
 wire \pll_control.count0[1] ;
 wire \pll_control.count0[2] ;
 wire \pll_control.count0[3] ;
 wire \pll_control.count0[4] ;
 wire \pll_control.count1[0] ;
 wire \pll_control.count1[1] ;
 wire \pll_control.count1[2] ;
 wire \pll_control.count1[3] ;
 wire \pll_control.count1[4] ;
 wire \pll_control.oscbuf[0] ;
 wire \pll_control.oscbuf[1] ;
 wire \pll_control.oscbuf[2] ;
 wire \pll_control.prep[0] ;
 wire \pll_control.prep[1] ;
 wire \pll_control.prep[2] ;
 wire \pll_control.tint[0] ;
 wire \pll_control.tint[1] ;
 wire \pll_control.tint[2] ;
 wire \pll_control.tint[3] ;
 wire \pll_control.tint[4] ;
 wire \pll_control.tval[0] ;
 wire \pll_control.tval[1] ;
 wire \ringosc.c[0] ;
 wire \ringosc.c[1] ;
 wire \ringosc.dstage[0].id.d0 ;
 wire \ringosc.dstage[0].id.d1 ;
 wire \ringosc.dstage[0].id.d2 ;
 wire \ringosc.dstage[0].id.in ;
 wire \ringosc.dstage[0].id.out ;
 wire \ringosc.dstage[0].id.trim[0] ;
 wire \ringosc.dstage[0].id.trim[1] ;
 wire \ringosc.dstage[0].id.ts ;
 wire \ringosc.dstage[10].id.d0 ;
 wire \ringosc.dstage[10].id.d1 ;
 wire \ringosc.dstage[10].id.d2 ;
 wire \ringosc.dstage[10].id.in ;
 wire \ringosc.dstage[10].id.out ;
 wire \ringosc.dstage[10].id.trim[0] ;
 wire \ringosc.dstage[10].id.trim[1] ;
 wire \ringosc.dstage[10].id.ts ;
 wire \ringosc.dstage[11].id.d0 ;
 wire \ringosc.dstage[11].id.d1 ;
 wire \ringosc.dstage[11].id.d2 ;
 wire \ringosc.dstage[11].id.out ;
 wire \ringosc.dstage[11].id.trim[0] ;
 wire \ringosc.dstage[11].id.trim[1] ;
 wire \ringosc.dstage[11].id.ts ;
 wire \ringosc.dstage[1].id.d0 ;
 wire \ringosc.dstage[1].id.d1 ;
 wire \ringosc.dstage[1].id.d2 ;
 wire \ringosc.dstage[1].id.out ;
 wire \ringosc.dstage[1].id.trim[0] ;
 wire \ringosc.dstage[1].id.trim[1] ;
 wire \ringosc.dstage[1].id.ts ;
 wire \ringosc.dstage[2].id.d0 ;
 wire \ringosc.dstage[2].id.d1 ;
 wire \ringosc.dstage[2].id.d2 ;
 wire \ringosc.dstage[2].id.out ;
 wire \ringosc.dstage[2].id.trim[0] ;
 wire \ringosc.dstage[2].id.trim[1] ;
 wire \ringosc.dstage[2].id.ts ;
 wire \ringosc.dstage[3].id.d0 ;
 wire \ringosc.dstage[3].id.d1 ;
 wire \ringosc.dstage[3].id.d2 ;
 wire \ringosc.dstage[3].id.out ;
 wire \ringosc.dstage[3].id.trim[0] ;
 wire \ringosc.dstage[3].id.trim[1] ;
 wire \ringosc.dstage[3].id.ts ;
 wire \ringosc.dstage[4].id.d0 ;
 wire \ringosc.dstage[4].id.d1 ;
 wire \ringosc.dstage[4].id.d2 ;
 wire \ringosc.dstage[4].id.out ;
 wire \ringosc.dstage[4].id.trim[0] ;
 wire \ringosc.dstage[4].id.trim[1] ;
 wire \ringosc.dstage[4].id.ts ;
 wire \ringosc.dstage[5].id.d0 ;
 wire \ringosc.dstage[5].id.d1 ;
 wire \ringosc.dstage[5].id.d2 ;
 wire \ringosc.dstage[5].id.out ;
 wire \ringosc.dstage[5].id.trim[0] ;
 wire \ringosc.dstage[5].id.trim[1] ;
 wire \ringosc.dstage[5].id.ts ;
 wire \ringosc.dstage[6].id.d0 ;
 wire \ringosc.dstage[6].id.d1 ;
 wire \ringosc.dstage[6].id.d2 ;
 wire \ringosc.dstage[6].id.out ;
 wire \ringosc.dstage[6].id.trim[0] ;
 wire \ringosc.dstage[6].id.trim[1] ;
 wire \ringosc.dstage[6].id.ts ;
 wire \ringosc.dstage[7].id.d0 ;
 wire \ringosc.dstage[7].id.d1 ;
 wire \ringosc.dstage[7].id.d2 ;
 wire \ringosc.dstage[7].id.out ;
 wire \ringosc.dstage[7].id.trim[0] ;
 wire \ringosc.dstage[7].id.trim[1] ;
 wire \ringosc.dstage[7].id.ts ;
 wire \ringosc.dstage[8].id.d0 ;
 wire \ringosc.dstage[8].id.d1 ;
 wire \ringosc.dstage[8].id.d2 ;
 wire \ringosc.dstage[8].id.out ;
 wire \ringosc.dstage[8].id.trim[0] ;
 wire \ringosc.dstage[8].id.trim[1] ;
 wire \ringosc.dstage[8].id.ts ;
 wire \ringosc.dstage[9].id.d0 ;
 wire \ringosc.dstage[9].id.d1 ;
 wire \ringosc.dstage[9].id.d2 ;
 wire \ringosc.dstage[9].id.trim[0] ;
 wire \ringosc.dstage[9].id.trim[1] ;
 wire \ringosc.dstage[9].id.ts ;
 wire \ringosc.iss.ctrl0 ;
 wire \ringosc.iss.d0 ;
 wire \ringosc.iss.d1 ;
 wire \ringosc.iss.d2 ;
 wire \ringosc.iss.one ;
 wire \ringosc.iss.reset ;
 wire \ringosc.iss.trim[0] ;
 wire \ringosc.iss.trim[1] ;

 sky130_fd_sc_hd__decap_8 FILLER_0_10 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_108 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_113 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_123 ();
 sky130_fd_sc_hd__decap_6 FILLER_0_134 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_141 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_166 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_169 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_178 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_18 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_188 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_25 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_29 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_3 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_34 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_51 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_55 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_65 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_79 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_83 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_85 ();
 sky130_fd_sc_hd__decap_4 FILLER_0_96 ();
 sky130_fd_sc_hd__decap_4 FILLER_10_12 ();
 sky130_fd_sc_hd__decap_4 FILLER_10_124 ();
 sky130_fd_sc_hd__decap_4 FILLER_10_135 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_139 ();
 sky130_fd_sc_hd__fill_2 FILLER_10_141 ();
 sky130_fd_sc_hd__decap_6 FILLER_10_150 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_156 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_16 ();
 sky130_fd_sc_hd__decap_4 FILLER_10_178 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_187 ();
 sky130_fd_sc_hd__decap_4 FILLER_10_24 ();
 sky130_fd_sc_hd__fill_2 FILLER_10_29 ();
 sky130_fd_sc_hd__fill_2 FILLER_10_3 ();
 sky130_fd_sc_hd__decap_8 FILLER_10_49 ();
 sky130_fd_sc_hd__decap_4 FILLER_10_61 ();
 sky130_fd_sc_hd__decap_4 FILLER_10_68 ();
 sky130_fd_sc_hd__decap_4 FILLER_10_79 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_83 ();
 sky130_fd_sc_hd__fill_2 FILLER_10_85 ();
 sky130_fd_sc_hd__decap_4 FILLER_10_90 ();
 sky130_fd_sc_hd__decap_4 FILLER_10_99 ();
 sky130_fd_sc_hd__decap_8 FILLER_11_103 ();
 sky130_fd_sc_hd__fill_1 FILLER_11_111 ();
 sky130_fd_sc_hd__fill_2 FILLER_11_113 ();
 sky130_fd_sc_hd__decap_8 FILLER_11_123 ();
 sky130_fd_sc_hd__fill_1 FILLER_11_131 ();
 sky130_fd_sc_hd__decap_4 FILLER_11_153 ();
 sky130_fd_sc_hd__decap_4 FILLER_11_16 ();
 sky130_fd_sc_hd__decap_4 FILLER_11_164 ();
 sky130_fd_sc_hd__decap_8 FILLER_11_169 ();
 sky130_fd_sc_hd__fill_2 FILLER_11_177 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_187 ();
 sky130_fd_sc_hd__decap_4 FILLER_11_27 ();
 sky130_fd_sc_hd__fill_2 FILLER_11_3 ();
 sky130_fd_sc_hd__fill_1 FILLER_11_31 ();
 sky130_fd_sc_hd__decap_4 FILLER_11_35 ();
 sky130_fd_sc_hd__decap_8 FILLER_11_48 ();
 sky130_fd_sc_hd__fill_2 FILLER_11_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_11_66 ();
 sky130_fd_sc_hd__fill_1 FILLER_11_70 ();
 sky130_fd_sc_hd__decap_6 FILLER_11_78 ();
 sky130_fd_sc_hd__fill_1 FILLER_11_84 ();
 sky130_fd_sc_hd__decap_4 FILLER_11_9 ();
 sky130_fd_sc_hd__decap_4 FILLER_12_102 ();
 sky130_fd_sc_hd__decap_4 FILLER_12_110 ();
 sky130_fd_sc_hd__decap_4 FILLER_12_12 ();
 sky130_fd_sc_hd__decap_4 FILLER_12_135 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_139 ();
 sky130_fd_sc_hd__fill_2 FILLER_12_141 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_16 ();
 sky130_fd_sc_hd__decap_4 FILLER_12_164 ();
 sky130_fd_sc_hd__decap_4 FILLER_12_173 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_177 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_187 ();
 sky130_fd_sc_hd__decap_4 FILLER_12_24 ();
 sky130_fd_sc_hd__fill_2 FILLER_12_29 ();
 sky130_fd_sc_hd__fill_2 FILLER_12_3 ();
 sky130_fd_sc_hd__decap_8 FILLER_12_49 ();
 sky130_fd_sc_hd__decap_4 FILLER_12_61 ();
 sky130_fd_sc_hd__decap_4 FILLER_12_68 ();
 sky130_fd_sc_hd__decap_4 FILLER_12_79 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_83 ();
 sky130_fd_sc_hd__fill_2 FILLER_12_85 ();
 sky130_fd_sc_hd__decap_4 FILLER_12_90 ();
 sky130_fd_sc_hd__decap_8 FILLER_13_103 ();
 sky130_fd_sc_hd__fill_1 FILLER_13_111 ();
 sky130_fd_sc_hd__fill_2 FILLER_13_113 ();
 sky130_fd_sc_hd__decap_4 FILLER_13_124 ();
 sky130_fd_sc_hd__decap_4 FILLER_13_135 ();
 sky130_fd_sc_hd__decap_4 FILLER_13_146 ();
 sky130_fd_sc_hd__decap_4 FILLER_13_156 ();
 sky130_fd_sc_hd__decap_4 FILLER_13_16 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_165 ();
 sky130_fd_sc_hd__fill_2 FILLER_13_169 ();
 sky130_fd_sc_hd__decap_4 FILLER_13_178 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_187 ();
 sky130_fd_sc_hd__decap_4 FILLER_13_27 ();
 sky130_fd_sc_hd__fill_2 FILLER_13_3 ();
 sky130_fd_sc_hd__fill_1 FILLER_13_31 ();
 sky130_fd_sc_hd__decap_4 FILLER_13_35 ();
 sky130_fd_sc_hd__decap_8 FILLER_13_48 ();
 sky130_fd_sc_hd__fill_2 FILLER_13_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_13_66 ();
 sky130_fd_sc_hd__fill_1 FILLER_13_70 ();
 sky130_fd_sc_hd__decap_6 FILLER_13_78 ();
 sky130_fd_sc_hd__fill_1 FILLER_13_84 ();
 sky130_fd_sc_hd__decap_4 FILLER_13_9 ();
 sky130_fd_sc_hd__decap_8 FILLER_14_116 ();
 sky130_fd_sc_hd__decap_4 FILLER_14_12 ();
 sky130_fd_sc_hd__fill_1 FILLER_14_124 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_138 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_141 ();
 sky130_fd_sc_hd__decap_8 FILLER_14_148 ();
 sky130_fd_sc_hd__fill_1 FILLER_14_16 ();
 sky130_fd_sc_hd__decap_4 FILLER_14_177 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_188 ();
 sky130_fd_sc_hd__decap_4 FILLER_14_24 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_29 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_3 ();
 sky130_fd_sc_hd__decap_8 FILLER_14_49 ();
 sky130_fd_sc_hd__decap_4 FILLER_14_61 ();
 sky130_fd_sc_hd__decap_4 FILLER_14_68 ();
 sky130_fd_sc_hd__decap_4 FILLER_14_79 ();
 sky130_fd_sc_hd__fill_1 FILLER_14_83 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_85 ();
 sky130_fd_sc_hd__decap_4 FILLER_14_90 ();
 sky130_fd_sc_hd__decap_4 FILLER_14_99 ();
 sky130_fd_sc_hd__decap_4 FILLER_15_10 ();
 sky130_fd_sc_hd__decap_4 FILLER_15_108 ();
 sky130_fd_sc_hd__decap_6 FILLER_15_113 ();
 sky130_fd_sc_hd__decap_4 FILLER_15_127 ();
 sky130_fd_sc_hd__decap_4 FILLER_15_144 ();
 sky130_fd_sc_hd__decap_4 FILLER_15_153 ();
 sky130_fd_sc_hd__decap_6 FILLER_15_162 ();
 sky130_fd_sc_hd__decap_8 FILLER_15_169 ();
 sky130_fd_sc_hd__fill_2 FILLER_15_177 ();
 sky130_fd_sc_hd__decap_4 FILLER_15_186 ();
 sky130_fd_sc_hd__decap_4 FILLER_15_23 ();
 sky130_fd_sc_hd__fill_1 FILLER_15_27 ();
 sky130_fd_sc_hd__fill_2 FILLER_15_3 ();
 sky130_fd_sc_hd__decap_6 FILLER_15_38 ();
 sky130_fd_sc_hd__fill_1 FILLER_15_44 ();
 sky130_fd_sc_hd__fill_2 FILLER_15_54 ();
 sky130_fd_sc_hd__decap_8 FILLER_15_57 ();
 sky130_fd_sc_hd__decap_8 FILLER_15_86 ();
 sky130_fd_sc_hd__fill_1 FILLER_15_94 ();
 sky130_fd_sc_hd__decap_4 FILLER_16_108 ();
 sky130_fd_sc_hd__decap_6 FILLER_16_119 ();
 sky130_fd_sc_hd__fill_2 FILLER_16_138 ();
 sky130_fd_sc_hd__fill_2 FILLER_16_141 ();
 sky130_fd_sc_hd__decap_4 FILLER_16_149 ();
 sky130_fd_sc_hd__decap_8 FILLER_16_158 ();
 sky130_fd_sc_hd__decap_4 FILLER_16_171 ();
 sky130_fd_sc_hd__decap_8 FILLER_16_180 ();
 sky130_fd_sc_hd__fill_2 FILLER_16_188 ();
 sky130_fd_sc_hd__decap_8 FILLER_16_19 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_27 ();
 sky130_fd_sc_hd__fill_2 FILLER_16_29 ();
 sky130_fd_sc_hd__decap_6 FILLER_16_3 ();
 sky130_fd_sc_hd__decap_4 FILLER_16_40 ();
 sky130_fd_sc_hd__decap_4 FILLER_16_48 ();
 sky130_fd_sc_hd__decap_4 FILLER_16_62 ();
 sky130_fd_sc_hd__decap_4 FILLER_16_79 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_83 ();
 sky130_fd_sc_hd__fill_2 FILLER_16_85 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_9 ();
 sky130_fd_sc_hd__decap_4 FILLER_16_97 ();
 sky130_fd_sc_hd__decap_4 FILLER_17_107 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_11 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_111 ();
 sky130_fd_sc_hd__decap_6 FILLER_17_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_119 ();
 sky130_fd_sc_hd__decap_4 FILLER_17_129 ();
 sky130_fd_sc_hd__decap_4 FILLER_17_142 ();
 sky130_fd_sc_hd__decap_4 FILLER_17_151 ();
 sky130_fd_sc_hd__decap_8 FILLER_17_160 ();
 sky130_fd_sc_hd__fill_2 FILLER_17_169 ();
 sky130_fd_sc_hd__decap_4 FILLER_17_176 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_180 ();
 sky130_fd_sc_hd__decap_4 FILLER_17_186 ();
 sky130_fd_sc_hd__decap_8 FILLER_17_20 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_28 ();
 sky130_fd_sc_hd__decap_8 FILLER_17_3 ();
 sky130_fd_sc_hd__decap_4 FILLER_17_39 ();
 sky130_fd_sc_hd__decap_4 FILLER_17_52 ();
 sky130_fd_sc_hd__fill_2 FILLER_17_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_17_67 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_71 ();
 sky130_fd_sc_hd__decap_4 FILLER_17_81 ();
 sky130_fd_sc_hd__decap_4 FILLER_17_95 ();
 sky130_fd_sc_hd__decap_4 FILLER_18_108 ();
 sky130_fd_sc_hd__decap_4 FILLER_18_118 ();
 sky130_fd_sc_hd__decap_4 FILLER_18_135 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_139 ();
 sky130_fd_sc_hd__fill_2 FILLER_18_141 ();
 sky130_fd_sc_hd__decap_4 FILLER_18_148 ();
 sky130_fd_sc_hd__decap_4 FILLER_18_15 ();
 sky130_fd_sc_hd__decap_4 FILLER_18_157 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_161 ();
 sky130_fd_sc_hd__decap_4 FILLER_18_167 ();
 sky130_fd_sc_hd__decap_4 FILLER_18_176 ();
 sky130_fd_sc_hd__decap_4 FILLER_18_185 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_189 ();
 sky130_fd_sc_hd__fill_2 FILLER_18_26 ();
 sky130_fd_sc_hd__decap_4 FILLER_18_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_3 ();
 sky130_fd_sc_hd__decap_4 FILLER_18_41 ();
 sky130_fd_sc_hd__decap_4 FILLER_18_53 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_18_66 ();
 sky130_fd_sc_hd__decap_6 FILLER_18_77 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_83 ();
 sky130_fd_sc_hd__fill_2 FILLER_18_85 ();
 sky130_fd_sc_hd__decap_4 FILLER_18_96 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_109 ();
 sky130_fd_sc_hd__fill_2 FILLER_19_113 ();
 sky130_fd_sc_hd__decap_4 FILLER_19_128 ();
 sky130_fd_sc_hd__decap_4 FILLER_19_139 ();
 sky130_fd_sc_hd__decap_4 FILLER_19_148 ();
 sky130_fd_sc_hd__decap_4 FILLER_19_157 ();
 sky130_fd_sc_hd__decap_8 FILLER_19_16 ();
 sky130_fd_sc_hd__fill_2 FILLER_19_166 ();
 sky130_fd_sc_hd__fill_2 FILLER_19_169 ();
 sky130_ef_sc_hd__decap_12 FILLER_19_176 ();
 sky130_fd_sc_hd__fill_2 FILLER_19_188 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_24 ();
 sky130_fd_sc_hd__decap_4 FILLER_19_3 ();
 sky130_fd_sc_hd__decap_6 FILLER_19_36 ();
 sky130_fd_sc_hd__fill_1 FILLER_19_42 ();
 sky130_fd_sc_hd__decap_4 FILLER_19_52 ();
 sky130_fd_sc_hd__fill_2 FILLER_19_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_19_67 ();
 sky130_fd_sc_hd__decap_6 FILLER_19_78 ();
 sky130_fd_sc_hd__fill_1 FILLER_19_84 ();
 sky130_fd_sc_hd__decap_4 FILLER_19_98 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_110 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_12 ();
 sky130_fd_sc_hd__decap_4 FILLER_1_128 ();
 sky130_fd_sc_hd__decap_4 FILLER_1_141 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_166 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_169 ();
 sky130_fd_sc_hd__decap_4 FILLER_1_178 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_188 ();
 sky130_fd_sc_hd__decap_4 FILLER_1_20 ();
 sky130_fd_sc_hd__decap_4 FILLER_1_27 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_3 ();
 sky130_fd_sc_hd__decap_4 FILLER_1_34 ();
 sky130_fd_sc_hd__decap_4 FILLER_1_51 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_55 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_1_68 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_72 ();
 sky130_fd_sc_hd__decap_4 FILLER_1_8 ();
 sky130_fd_sc_hd__decap_4 FILLER_1_83 ();
 sky130_fd_sc_hd__decap_4 FILLER_1_93 ();
 sky130_fd_sc_hd__decap_4 FILLER_20_10 ();
 sky130_fd_sc_hd__decap_4 FILLER_20_109 ();
 sky130_fd_sc_hd__fill_1 FILLER_20_113 ();
 sky130_fd_sc_hd__decap_4 FILLER_20_121 ();
 sky130_fd_sc_hd__decap_8 FILLER_20_130 ();
 sky130_fd_sc_hd__fill_2 FILLER_20_138 ();
 sky130_fd_sc_hd__fill_2 FILLER_20_141 ();
 sky130_ef_sc_hd__decap_12 FILLER_20_148 ();
 sky130_fd_sc_hd__decap_4 FILLER_20_160 ();
 sky130_fd_sc_hd__fill_1 FILLER_20_164 ();
 sky130_ef_sc_hd__decap_12 FILLER_20_170 ();
 sky130_fd_sc_hd__decap_8 FILLER_20_182 ();
 sky130_fd_sc_hd__decap_6 FILLER_20_22 ();
 sky130_fd_sc_hd__fill_2 FILLER_20_29 ();
 sky130_fd_sc_hd__fill_2 FILLER_20_3 ();
 sky130_fd_sc_hd__decap_4 FILLER_20_39 ();
 sky130_fd_sc_hd__decap_4 FILLER_20_48 ();
 sky130_fd_sc_hd__decap_4 FILLER_20_59 ();
 sky130_fd_sc_hd__decap_4 FILLER_20_70 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_81 ();
 sky130_fd_sc_hd__decap_6 FILLER_20_85 ();
 sky130_fd_sc_hd__fill_1 FILLER_20_91 ();
 sky130_fd_sc_hd__decap_4 FILLER_20_99 ();
 sky130_fd_sc_hd__decap_8 FILLER_21_103 ();
 sky130_fd_sc_hd__fill_1 FILLER_21_111 ();
 sky130_fd_sc_hd__fill_2 FILLER_21_113 ();
 sky130_fd_sc_hd__decap_4 FILLER_21_120 ();
 sky130_fd_sc_hd__decap_4 FILLER_21_129 ();
 sky130_fd_sc_hd__fill_1 FILLER_21_133 ();
 sky130_fd_sc_hd__decap_4 FILLER_21_139 ();
 sky130_fd_sc_hd__decap_4 FILLER_21_14 ();
 sky130_ef_sc_hd__decap_12 FILLER_21_148 ();
 sky130_fd_sc_hd__decap_8 FILLER_21_160 ();
 sky130_ef_sc_hd__decap_12 FILLER_21_169 ();
 sky130_fd_sc_hd__decap_8 FILLER_21_181 ();
 sky130_fd_sc_hd__fill_1 FILLER_21_189 ();
 sky130_fd_sc_hd__decap_6 FILLER_21_26 ();
 sky130_fd_sc_hd__decap_3 FILLER_21_3 ();
 sky130_fd_sc_hd__decap_4 FILLER_21_39 ();
 sky130_fd_sc_hd__decap_6 FILLER_21_50 ();
 sky130_fd_sc_hd__fill_2 FILLER_21_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_21_66 ();
 sky130_fd_sc_hd__decap_4 FILLER_21_76 ();
 sky130_fd_sc_hd__decap_4 FILLER_21_85 ();
 sky130_fd_sc_hd__decap_4 FILLER_21_94 ();
 sky130_fd_sc_hd__fill_1 FILLER_22_103 ();
 sky130_ef_sc_hd__decap_12 FILLER_22_109 ();
 sky130_fd_sc_hd__decap_8 FILLER_22_121 ();
 sky130_fd_sc_hd__fill_2 FILLER_22_129 ();
 sky130_fd_sc_hd__decap_4 FILLER_22_136 ();
 sky130_ef_sc_hd__decap_12 FILLER_22_141 ();
 sky130_fd_sc_hd__decap_4 FILLER_22_15 ();
 sky130_ef_sc_hd__decap_12 FILLER_22_153 ();
 sky130_ef_sc_hd__decap_12 FILLER_22_165 ();
 sky130_ef_sc_hd__decap_12 FILLER_22_177 ();
 sky130_fd_sc_hd__fill_1 FILLER_22_189 ();
 sky130_fd_sc_hd__fill_2 FILLER_22_26 ();
 sky130_fd_sc_hd__decap_4 FILLER_22_29 ();
 sky130_fd_sc_hd__decap_4 FILLER_22_3 ();
 sky130_fd_sc_hd__fill_1 FILLER_22_33 ();
 sky130_fd_sc_hd__decap_4 FILLER_22_41 ();
 sky130_fd_sc_hd__decap_4 FILLER_22_52 ();
 sky130_fd_sc_hd__decap_8 FILLER_22_63 ();
 sky130_fd_sc_hd__fill_1 FILLER_22_7 ();
 sky130_fd_sc_hd__fill_2 FILLER_22_71 ();
 sky130_fd_sc_hd__decap_6 FILLER_22_78 ();
 sky130_fd_sc_hd__fill_2 FILLER_22_85 ();
 sky130_fd_sc_hd__decap_4 FILLER_22_92 ();
 sky130_fd_sc_hd__decap_4 FILLER_22_99 ();
 sky130_fd_sc_hd__decap_8 FILLER_23_104 ();
 sky130_ef_sc_hd__decap_12 FILLER_23_113 ();
 sky130_ef_sc_hd__decap_12 FILLER_23_125 ();
 sky130_ef_sc_hd__decap_12 FILLER_23_137 ();
 sky130_fd_sc_hd__decap_8 FILLER_23_14 ();
 sky130_ef_sc_hd__decap_12 FILLER_23_149 ();
 sky130_fd_sc_hd__decap_6 FILLER_23_161 ();
 sky130_fd_sc_hd__fill_1 FILLER_23_167 ();
 sky130_ef_sc_hd__decap_12 FILLER_23_169 ();
 sky130_fd_sc_hd__decap_8 FILLER_23_181 ();
 sky130_fd_sc_hd__fill_1 FILLER_23_189 ();
 sky130_fd_sc_hd__decap_3 FILLER_23_22 ();
 sky130_fd_sc_hd__decap_4 FILLER_23_3 ();
 sky130_fd_sc_hd__decap_4 FILLER_23_32 ();
 sky130_fd_sc_hd__decap_4 FILLER_23_43 ();
 sky130_fd_sc_hd__decap_3 FILLER_23_53 ();
 sky130_fd_sc_hd__fill_2 FILLER_23_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_23_65 ();
 sky130_fd_sc_hd__decap_4 FILLER_23_74 ();
 sky130_fd_sc_hd__decap_4 FILLER_23_83 ();
 sky130_ef_sc_hd__decap_12 FILLER_23_92 ();
 sky130_ef_sc_hd__decap_12 FILLER_24_104 ();
 sky130_ef_sc_hd__decap_12 FILLER_24_116 ();
 sky130_ef_sc_hd__decap_12 FILLER_24_128 ();
 sky130_fd_sc_hd__decap_4 FILLER_24_13 ();
 sky130_ef_sc_hd__decap_12 FILLER_24_141 ();
 sky130_ef_sc_hd__decap_12 FILLER_24_153 ();
 sky130_ef_sc_hd__decap_12 FILLER_24_165 ();
 sky130_ef_sc_hd__decap_12 FILLER_24_177 ();
 sky130_fd_sc_hd__fill_1 FILLER_24_189 ();
 sky130_fd_sc_hd__decap_4 FILLER_24_24 ();
 sky130_fd_sc_hd__fill_2 FILLER_24_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_24_3 ();
 sky130_fd_sc_hd__decap_6 FILLER_24_38 ();
 sky130_fd_sc_hd__decap_4 FILLER_24_50 ();
 sky130_fd_sc_hd__decap_4 FILLER_24_59 ();
 sky130_fd_sc_hd__decap_8 FILLER_24_68 ();
 sky130_fd_sc_hd__decap_3 FILLER_24_81 ();
 sky130_fd_sc_hd__fill_2 FILLER_24_85 ();
 sky130_ef_sc_hd__decap_12 FILLER_24_92 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_109 ();
 sky130_ef_sc_hd__decap_12 FILLER_25_113 ();
 sky130_ef_sc_hd__decap_12 FILLER_25_125 ();
 sky130_ef_sc_hd__decap_12 FILLER_25_137 ();
 sky130_ef_sc_hd__decap_12 FILLER_25_149 ();
 sky130_fd_sc_hd__decap_6 FILLER_25_161 ();
 sky130_fd_sc_hd__fill_1 FILLER_25_167 ();
 sky130_ef_sc_hd__decap_12 FILLER_25_169 ();
 sky130_fd_sc_hd__decap_6 FILLER_25_18 ();
 sky130_fd_sc_hd__decap_8 FILLER_25_181 ();
 sky130_fd_sc_hd__fill_1 FILLER_25_189 ();
 sky130_fd_sc_hd__fill_1 FILLER_25_24 ();
 sky130_fd_sc_hd__decap_8 FILLER_25_3 ();
 sky130_fd_sc_hd__decap_4 FILLER_25_32 ();
 sky130_fd_sc_hd__decap_4 FILLER_25_42 ();
 sky130_fd_sc_hd__fill_1 FILLER_25_46 ();
 sky130_fd_sc_hd__decap_4 FILLER_25_52 ();
 sky130_fd_sc_hd__fill_2 FILLER_25_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_25_64 ();
 sky130_ef_sc_hd__decap_12 FILLER_25_73 ();
 sky130_ef_sc_hd__decap_12 FILLER_25_85 ();
 sky130_ef_sc_hd__decap_12 FILLER_25_97 ();
 sky130_fd_sc_hd__decap_4 FILLER_26_10 ();
 sky130_ef_sc_hd__decap_12 FILLER_26_109 ();
 sky130_ef_sc_hd__decap_12 FILLER_26_121 ();
 sky130_fd_sc_hd__decap_6 FILLER_26_133 ();
 sky130_fd_sc_hd__fill_1 FILLER_26_139 ();
 sky130_ef_sc_hd__decap_12 FILLER_26_141 ();
 sky130_ef_sc_hd__decap_12 FILLER_26_153 ();
 sky130_ef_sc_hd__decap_12 FILLER_26_165 ();
 sky130_ef_sc_hd__decap_12 FILLER_26_177 ();
 sky130_fd_sc_hd__fill_1 FILLER_26_189 ();
 sky130_fd_sc_hd__decap_6 FILLER_26_21 ();
 sky130_fd_sc_hd__fill_1 FILLER_26_27 ();
 sky130_fd_sc_hd__fill_2 FILLER_26_29 ();
 sky130_fd_sc_hd__fill_2 FILLER_26_3 ();
 sky130_fd_sc_hd__decap_8 FILLER_26_36 ();
 sky130_fd_sc_hd__fill_1 FILLER_26_44 ();
 sky130_fd_sc_hd__decap_4 FILLER_26_50 ();
 sky130_ef_sc_hd__decap_12 FILLER_26_59 ();
 sky130_ef_sc_hd__decap_12 FILLER_26_71 ();
 sky130_fd_sc_hd__fill_1 FILLER_26_83 ();
 sky130_ef_sc_hd__decap_12 FILLER_26_85 ();
 sky130_ef_sc_hd__decap_12 FILLER_26_97 ();
 sky130_fd_sc_hd__decap_3 FILLER_27_109 ();
 sky130_ef_sc_hd__decap_12 FILLER_27_113 ();
 sky130_ef_sc_hd__decap_12 FILLER_27_125 ();
 sky130_fd_sc_hd__decap_3 FILLER_27_137 ();
 sky130_ef_sc_hd__decap_12 FILLER_27_141 ();
 sky130_ef_sc_hd__decap_12 FILLER_27_153 ();
 sky130_fd_sc_hd__decap_3 FILLER_27_165 ();
 sky130_ef_sc_hd__decap_12 FILLER_27_169 ();
 sky130_fd_sc_hd__decap_4 FILLER_27_17 ();
 sky130_fd_sc_hd__decap_8 FILLER_27_181 ();
 sky130_fd_sc_hd__fill_1 FILLER_27_189 ();
 sky130_fd_sc_hd__fill_2 FILLER_27_26 ();
 sky130_fd_sc_hd__fill_2 FILLER_27_29 ();
 sky130_fd_sc_hd__decap_8 FILLER_27_3 ();
 sky130_fd_sc_hd__decap_4 FILLER_27_36 ();
 sky130_fd_sc_hd__decap_8 FILLER_27_45 ();
 sky130_fd_sc_hd__decap_3 FILLER_27_53 ();
 sky130_ef_sc_hd__decap_12 FILLER_27_57 ();
 sky130_ef_sc_hd__decap_12 FILLER_27_69 ();
 sky130_fd_sc_hd__decap_3 FILLER_27_81 ();
 sky130_ef_sc_hd__decap_12 FILLER_27_85 ();
 sky130_ef_sc_hd__decap_12 FILLER_27_97 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_102 ();
 sky130_fd_sc_hd__decap_4 FILLER_2_113 ();
 sky130_fd_sc_hd__decap_4 FILLER_2_12 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_138 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_141 ();
 sky130_fd_sc_hd__decap_4 FILLER_2_150 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_154 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_16 ();
 sky130_fd_sc_hd__decap_4 FILLER_2_176 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_187 ();
 sky130_fd_sc_hd__decap_4 FILLER_2_24 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_29 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_3 ();
 sky130_fd_sc_hd__decap_4 FILLER_2_49 ();
 sky130_fd_sc_hd__decap_4 FILLER_2_74 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_82 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_85 ();
 sky130_fd_sc_hd__decap_6 FILLER_2_96 ();
 sky130_fd_sc_hd__decap_4 FILLER_3_103 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_110 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_113 ();
 sky130_fd_sc_hd__decap_8 FILLER_3_123 ();
 sky130_fd_sc_hd__decap_6 FILLER_3_144 ();
 sky130_fd_sc_hd__decap_8 FILLER_3_159 ();
 sky130_fd_sc_hd__decap_4 FILLER_3_16 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_167 ();
 sky130_fd_sc_hd__decap_4 FILLER_3_169 ();
 sky130_fd_sc_hd__decap_4 FILLER_3_186 ();
 sky130_fd_sc_hd__decap_4 FILLER_3_27 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_3 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_31 ();
 sky130_fd_sc_hd__decap_6 FILLER_3_35 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_54 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_3_66 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_70 ();
 sky130_fd_sc_hd__decap_6 FILLER_3_78 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_84 ();
 sky130_fd_sc_hd__decap_4 FILLER_3_9 ();
 sky130_fd_sc_hd__decap_4 FILLER_4_115 ();
 sky130_fd_sc_hd__decap_4 FILLER_4_12 ();
 sky130_fd_sc_hd__decap_4 FILLER_4_128 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_138 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_141 ();
 sky130_fd_sc_hd__decap_4 FILLER_4_151 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_16 ();
 sky130_fd_sc_hd__decap_4 FILLER_4_176 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_187 ();
 sky130_fd_sc_hd__decap_4 FILLER_4_24 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_29 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_3 ();
 sky130_fd_sc_hd__decap_8 FILLER_4_49 ();
 sky130_fd_sc_hd__decap_4 FILLER_4_61 ();
 sky130_fd_sc_hd__decap_4 FILLER_4_68 ();
 sky130_fd_sc_hd__decap_4 FILLER_4_79 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_83 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_85 ();
 sky130_fd_sc_hd__decap_4 FILLER_4_90 ();
 sky130_fd_sc_hd__decap_8 FILLER_5_103 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_111 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_113 ();
 sky130_fd_sc_hd__decap_4 FILLER_5_136 ();
 sky130_fd_sc_hd__decap_4 FILLER_5_16 ();
 sky130_fd_sc_hd__decap_6 FILLER_5_161 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_167 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_169 ();
 sky130_fd_sc_hd__decap_4 FILLER_5_178 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_188 ();
 sky130_fd_sc_hd__decap_4 FILLER_5_27 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_3 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_31 ();
 sky130_fd_sc_hd__decap_8 FILLER_5_35 ();
 sky130_fd_sc_hd__decap_4 FILLER_5_52 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_5_66 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_70 ();
 sky130_fd_sc_hd__decap_6 FILLER_5_78 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_84 ();
 sky130_fd_sc_hd__decap_4 FILLER_5_9 ();
 sky130_fd_sc_hd__decap_4 FILLER_6_12 ();
 sky130_fd_sc_hd__decap_4 FILLER_6_120 ();
 sky130_fd_sc_hd__decap_6 FILLER_6_133 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_139 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_141 ();
 sky130_fd_sc_hd__decap_4 FILLER_6_150 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_16 ();
 sky130_fd_sc_hd__decap_4 FILLER_6_175 ();
 sky130_fd_sc_hd__decap_4 FILLER_6_186 ();
 sky130_fd_sc_hd__decap_4 FILLER_6_24 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_29 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_3 ();
 sky130_fd_sc_hd__decap_8 FILLER_6_49 ();
 sky130_fd_sc_hd__decap_4 FILLER_6_61 ();
 sky130_fd_sc_hd__decap_4 FILLER_6_68 ();
 sky130_fd_sc_hd__decap_4 FILLER_6_79 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_83 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_85 ();
 sky130_fd_sc_hd__decap_8 FILLER_6_90 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_98 ();
 sky130_fd_sc_hd__decap_4 FILLER_7_103 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_110 ();
 sky130_fd_sc_hd__decap_8 FILLER_7_113 ();
 sky130_fd_sc_hd__decap_4 FILLER_7_142 ();
 sky130_fd_sc_hd__decap_4 FILLER_7_151 ();
 sky130_fd_sc_hd__decap_4 FILLER_7_16 ();
 sky130_fd_sc_hd__decap_4 FILLER_7_163 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_167 ();
 sky130_fd_sc_hd__decap_6 FILLER_7_169 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_188 ();
 sky130_fd_sc_hd__decap_4 FILLER_7_27 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_3 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_31 ();
 sky130_fd_sc_hd__decap_8 FILLER_7_35 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_43 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_54 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_7_66 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_70 ();
 sky130_fd_sc_hd__decap_6 FILLER_7_78 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_84 ();
 sky130_fd_sc_hd__decap_4 FILLER_7_9 ();
 sky130_fd_sc_hd__decap_4 FILLER_8_115 ();
 sky130_fd_sc_hd__decap_4 FILLER_8_12 ();
 sky130_fd_sc_hd__decap_4 FILLER_8_128 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_137 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_141 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_16 ();
 sky130_fd_sc_hd__decap_8 FILLER_8_164 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_172 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_188 ();
 sky130_fd_sc_hd__decap_4 FILLER_8_24 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_29 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_3 ();
 sky130_fd_sc_hd__decap_8 FILLER_8_49 ();
 sky130_fd_sc_hd__decap_4 FILLER_8_61 ();
 sky130_fd_sc_hd__decap_4 FILLER_8_68 ();
 sky130_fd_sc_hd__decap_4 FILLER_8_79 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_83 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_85 ();
 sky130_fd_sc_hd__decap_4 FILLER_8_90 ();
 sky130_fd_sc_hd__decap_8 FILLER_9_103 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_111 ();
 sky130_fd_sc_hd__decap_6 FILLER_9_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_119 ();
 sky130_fd_sc_hd__decap_4 FILLER_9_141 ();
 sky130_fd_sc_hd__decap_4 FILLER_9_16 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_166 ();
 sky130_fd_sc_hd__decap_6 FILLER_9_169 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_175 ();
 sky130_fd_sc_hd__decap_4 FILLER_9_185 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_189 ();
 sky130_fd_sc_hd__decap_4 FILLER_9_27 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_3 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_31 ();
 sky130_fd_sc_hd__decap_8 FILLER_9_35 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_43 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_54 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_57 ();
 sky130_fd_sc_hd__decap_4 FILLER_9_66 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_70 ();
 sky130_fd_sc_hd__decap_6 FILLER_9_78 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_84 ();
 sky130_fd_sc_hd__decap_4 FILLER_9_9 ();
 sky130_fd_sc_hd__decap_3 PHY_0 ();
 sky130_fd_sc_hd__decap_3 PHY_1 ();
 sky130_fd_sc_hd__decap_3 PHY_10 ();
 sky130_fd_sc_hd__decap_3 PHY_11 ();
 sky130_fd_sc_hd__decap_3 PHY_12 ();
 sky130_fd_sc_hd__decap_3 PHY_13 ();
 sky130_fd_sc_hd__decap_3 PHY_14 ();
 sky130_fd_sc_hd__decap_3 PHY_15 ();
 sky130_fd_sc_hd__decap_3 PHY_16 ();
 sky130_fd_sc_hd__decap_3 PHY_17 ();
 sky130_fd_sc_hd__decap_3 PHY_18 ();
 sky130_fd_sc_hd__decap_3 PHY_19 ();
 sky130_fd_sc_hd__decap_3 PHY_2 ();
 sky130_fd_sc_hd__decap_3 PHY_20 ();
 sky130_fd_sc_hd__decap_3 PHY_21 ();
 sky130_fd_sc_hd__decap_3 PHY_22 ();
 sky130_fd_sc_hd__decap_3 PHY_23 ();
 sky130_fd_sc_hd__decap_3 PHY_24 ();
 sky130_fd_sc_hd__decap_3 PHY_25 ();
 sky130_fd_sc_hd__decap_3 PHY_26 ();
 sky130_fd_sc_hd__decap_3 PHY_27 ();
 sky130_fd_sc_hd__decap_3 PHY_28 ();
 sky130_fd_sc_hd__decap_3 PHY_29 ();
 sky130_fd_sc_hd__decap_3 PHY_3 ();
 sky130_fd_sc_hd__decap_3 PHY_30 ();
 sky130_fd_sc_hd__decap_3 PHY_31 ();
 sky130_fd_sc_hd__decap_3 PHY_32 ();
 sky130_fd_sc_hd__decap_3 PHY_33 ();
 sky130_fd_sc_hd__decap_3 PHY_34 ();
 sky130_fd_sc_hd__decap_3 PHY_35 ();
 sky130_fd_sc_hd__decap_3 PHY_36 ();
 sky130_fd_sc_hd__decap_3 PHY_37 ();
 sky130_fd_sc_hd__decap_3 PHY_38 ();
 sky130_fd_sc_hd__decap_3 PHY_39 ();
 sky130_fd_sc_hd__decap_3 PHY_4 ();
 sky130_fd_sc_hd__decap_3 PHY_40 ();
 sky130_fd_sc_hd__decap_3 PHY_41 ();
 sky130_fd_sc_hd__decap_3 PHY_42 ();
 sky130_fd_sc_hd__decap_3 PHY_43 ();
 sky130_fd_sc_hd__decap_3 PHY_44 ();
 sky130_fd_sc_hd__decap_3 PHY_45 ();
 sky130_fd_sc_hd__decap_3 PHY_46 ();
 sky130_fd_sc_hd__decap_3 PHY_47 ();
 sky130_fd_sc_hd__decap_3 PHY_48 ();
 sky130_fd_sc_hd__decap_3 PHY_49 ();
 sky130_fd_sc_hd__decap_3 PHY_5 ();
 sky130_fd_sc_hd__decap_3 PHY_50 ();
 sky130_fd_sc_hd__decap_3 PHY_51 ();
 sky130_fd_sc_hd__decap_3 PHY_52 ();
 sky130_fd_sc_hd__decap_3 PHY_53 ();
 sky130_fd_sc_hd__decap_3 PHY_54 ();
 sky130_fd_sc_hd__decap_3 PHY_55 ();
 sky130_fd_sc_hd__decap_3 PHY_6 ();
 sky130_fd_sc_hd__decap_3 PHY_7 ();
 sky130_fd_sc_hd__decap_3 PHY_8 ();
 sky130_fd_sc_hd__decap_3 PHY_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_100 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_101 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_102 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_103 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_104 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_105 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_106 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_107 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_108 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_109 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_110 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_111 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_112 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_113 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_114 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_115 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_116 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_117 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_118 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_119 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_120 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_121 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_122 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_123 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_124 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_125 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_126 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_127 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_128 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_129 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_130 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_131 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_132 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_133 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_134 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_135 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_136 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_137 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_138 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_139 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_140 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_141 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_142 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_143 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_144 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_145 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_57 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_61 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_64 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_65 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_67 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_68 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_69 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_70 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_71 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_72 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_73 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_74 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_75 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_76 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_77 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_78 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_79 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_80 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_81 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_82 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_83 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_84 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_85 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_86 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_87 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_88 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_89 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_90 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_91 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_92 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_93 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_94 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_95 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_96 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_97 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_98 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_99 ();
 sky130_fd_sc_hd__inv_2 _174_ (.A(\pll_control.tint[0] ),
    .Y(_043_));
 sky130_fd_sc_hd__inv_2 _175_ (.A(div[3]),
    .Y(_044_));
 sky130_fd_sc_hd__inv_2 _176_ (.A(div[2]),
    .Y(_045_));
 sky130_fd_sc_hd__inv_2 _177_ (.A(dco),
    .Y(_046_));
 sky130_fd_sc_hd__xnor2_2 _178_ (.A(\pll_control.oscbuf[1] ),
    .B(\pll_control.oscbuf[2] ),
    .Y(_047_));
 sky130_fd_sc_hd__xor2_2 _179_ (.A(\pll_control.oscbuf[1] ),
    .B(\pll_control.oscbuf[2] ),
    .X(_048_));
 sky130_fd_sc_hd__mux2_1 _180_ (.A0(\pll_control.count0[4] ),
    .A1(\pll_control.count1[4] ),
    .S(_047_),
    .X(_042_));
 sky130_fd_sc_hd__mux2_1 _181_ (.A0(\pll_control.count0[3] ),
    .A1(\pll_control.count1[3] ),
    .S(_047_),
    .X(_041_));
 sky130_fd_sc_hd__mux2_1 _182_ (.A0(\pll_control.count0[2] ),
    .A1(\pll_control.count1[2] ),
    .S(_047_),
    .X(_040_));
 sky130_fd_sc_hd__mux2_1 _183_ (.A0(\pll_control.count0[1] ),
    .A1(\pll_control.count1[1] ),
    .S(_047_),
    .X(_039_));
 sky130_fd_sc_hd__mux2_1 _184_ (.A0(\pll_control.count0[0] ),
    .A1(\pll_control.count1[0] ),
    .S(_047_),
    .X(_038_));
 sky130_fd_sc_hd__mux2_1 _185_ (.A0(\pll_control.prep[1] ),
    .A1(\pll_control.prep[2] ),
    .S(_047_),
    .X(_037_));
 sky130_fd_sc_hd__mux2_1 _186_ (.A0(\pll_control.prep[1] ),
    .A1(\pll_control.prep[0] ),
    .S(_048_),
    .X(_036_));
 sky130_fd_sc_hd__or2_2 _187_ (.A(\pll_control.prep[0] ),
    .B(_048_),
    .X(_035_));
 sky130_fd_sc_hd__and3_2 _188_ (.A(\pll_control.count0[2] ),
    .B(\pll_control.count0[1] ),
    .C(\pll_control.count0[0] ),
    .X(_049_));
 sky130_fd_sc_hd__and2_2 _189_ (.A(\pll_control.count0[3] ),
    .B(_049_),
    .X(_050_));
 sky130_fd_sc_hd__o21a_2 _190_ (.A1(\pll_control.count0[4] ),
    .A2(_050_),
    .B1(_047_),
    .X(_034_));
 sky130_fd_sc_hd__nand2b_2 _191_ (.A_N(\pll_control.count0[4] ),
    .B(_050_),
    .Y(_051_));
 sky130_fd_sc_hd__o211a_2 _192_ (.A1(\pll_control.count0[3] ),
    .A2(_049_),
    .B1(_051_),
    .C1(_047_),
    .X(_033_));
 sky130_fd_sc_hd__nand2_2 _193_ (.A(\pll_control.count0[4] ),
    .B(_050_),
    .Y(_052_));
 sky130_fd_sc_hd__a21oi_2 _194_ (.A1(\pll_control.count0[1] ),
    .A2(\pll_control.count0[0] ),
    .B1(\pll_control.count0[2] ),
    .Y(_053_));
 sky130_fd_sc_hd__or2_2 _195_ (.A(_049_),
    .B(_053_),
    .X(_054_));
 sky130_fd_sc_hd__a21oi_2 _196_ (.A1(_052_),
    .A2(_054_),
    .B1(_048_),
    .Y(_032_));
 sky130_fd_sc_hd__xnor2_2 _197_ (.A(\pll_control.count0[1] ),
    .B(\pll_control.count0[0] ),
    .Y(_055_));
 sky130_fd_sc_hd__a21oi_2 _198_ (.A1(_052_),
    .A2(_055_),
    .B1(_048_),
    .Y(_031_));
 sky130_fd_sc_hd__nand3_2 _199_ (.A(\pll_control.count0[0] ),
    .B(_047_),
    .C(_052_),
    .Y(_030_));
 sky130_fd_sc_hd__nor2_2 _200_ (.A(\pll_control.tint[1] ),
    .B(\pll_control.tint[0] ),
    .Y(_056_));
 sky130_fd_sc_hd__or2_2 _201_ (.A(\pll_control.tint[1] ),
    .B(\pll_control.tint[0] ),
    .X(_057_));
 sky130_fd_sc_hd__nand2_2 _202_ (.A(\pll_control.tint[1] ),
    .B(\pll_control.tint[0] ),
    .Y(_058_));
 sky130_fd_sc_hd__nand2_2 _203_ (.A(_057_),
    .B(_058_),
    .Y(_059_));
 sky130_fd_sc_hd__nand2_2 _204_ (.A(\pll_control.count0[1] ),
    .B(\pll_control.count1[1] ),
    .Y(_060_));
 sky130_fd_sc_hd__xnor2_2 _205_ (.A(\pll_control.count0[1] ),
    .B(\pll_control.count1[1] ),
    .Y(_061_));
 sky130_fd_sc_hd__nand2_2 _206_ (.A(\pll_control.count0[0] ),
    .B(\pll_control.count1[0] ),
    .Y(_062_));
 sky130_fd_sc_hd__xnor2_2 _207_ (.A(_061_),
    .B(_062_),
    .Y(_063_));
 sky130_fd_sc_hd__and2_2 _208_ (.A(div[1]),
    .B(_063_),
    .X(_064_));
 sky130_fd_sc_hd__nor2_2 _209_ (.A(div[1]),
    .B(_063_),
    .Y(_065_));
 sky130_fd_sc_hd__or2_2 _210_ (.A(\pll_control.count0[0] ),
    .B(\pll_control.count1[0] ),
    .X(_066_));
 sky130_fd_sc_hd__nand2_2 _211_ (.A(_062_),
    .B(_066_),
    .Y(_067_));
 sky130_fd_sc_hd__nor2_2 _212_ (.A(div[0]),
    .B(_067_),
    .Y(_068_));
 sky130_fd_sc_hd__nor3_2 _213_ (.A(_064_),
    .B(_065_),
    .C(_068_),
    .Y(_069_));
 sky130_fd_sc_hd__o21ba_2 _214_ (.A1(_065_),
    .A2(_068_),
    .B1_N(_064_),
    .X(_070_));
 sky130_fd_sc_hd__o21a_2 _215_ (.A1(_061_),
    .A2(_062_),
    .B1(_060_),
    .X(_071_));
 sky130_fd_sc_hd__nand2_2 _216_ (.A(\pll_control.count0[2] ),
    .B(\pll_control.count1[2] ),
    .Y(_072_));
 sky130_fd_sc_hd__or2_2 _217_ (.A(\pll_control.count0[2] ),
    .B(\pll_control.count1[2] ),
    .X(_073_));
 sky130_fd_sc_hd__nand2_2 _218_ (.A(_072_),
    .B(_073_),
    .Y(_074_));
 sky130_fd_sc_hd__xor2_2 _219_ (.A(_071_),
    .B(_074_),
    .X(_075_));
 sky130_fd_sc_hd__o211ai_2 _220_ (.A1(_061_),
    .A2(_062_),
    .B1(_072_),
    .C1(_060_),
    .Y(_076_));
 sky130_fd_sc_hd__and2_2 _221_ (.A(\pll_control.count0[3] ),
    .B(\pll_control.count1[3] ),
    .X(_077_));
 sky130_fd_sc_hd__or2_2 _222_ (.A(\pll_control.count0[3] ),
    .B(\pll_control.count1[3] ),
    .X(_078_));
 sky130_fd_sc_hd__nand2b_2 _223_ (.A_N(_077_),
    .B(_078_),
    .Y(_079_));
 sky130_fd_sc_hd__and3_2 _224_ (.A(_073_),
    .B(_076_),
    .C(_079_),
    .X(_080_));
 sky130_fd_sc_hd__a21oi_2 _225_ (.A1(_073_),
    .A2(_076_),
    .B1(_079_),
    .Y(_081_));
 sky130_fd_sc_hd__o32a_2 _226_ (.A1(_044_),
    .A2(_080_),
    .A3(_081_),
    .B1(_045_),
    .B2(_075_),
    .X(_082_));
 sky130_fd_sc_hd__o21a_2 _227_ (.A1(_080_),
    .A2(_081_),
    .B1(_044_),
    .X(_083_));
 sky130_fd_sc_hd__nand2_2 _228_ (.A(_045_),
    .B(_075_),
    .Y(_084_));
 sky130_fd_sc_hd__or4bb_2 _229_ (.A(_070_),
    .B(_083_),
    .C_N(_084_),
    .D_N(_082_),
    .X(_085_));
 sky130_fd_sc_hd__nand2_2 _230_ (.A(\pll_control.count0[4] ),
    .B(\pll_control.count1[4] ),
    .Y(_086_));
 sky130_fd_sc_hd__or2_2 _231_ (.A(\pll_control.count0[4] ),
    .B(\pll_control.count1[4] ),
    .X(_087_));
 sky130_fd_sc_hd__nand2_2 _232_ (.A(_086_),
    .B(_087_),
    .Y(_088_));
 sky130_fd_sc_hd__a31o_2 _233_ (.A1(_073_),
    .A2(_076_),
    .A3(_078_),
    .B1(_077_),
    .X(_089_));
 sky130_fd_sc_hd__a21oi_2 _234_ (.A1(_086_),
    .A2(_087_),
    .B1(_089_),
    .Y(_090_));
 sky130_fd_sc_hd__xor2_2 _235_ (.A(_088_),
    .B(_089_),
    .X(_091_));
 sky130_fd_sc_hd__o2bb2a_2 _236_ (.A1_N(div[4]),
    .A2_N(_091_),
    .B1(_083_),
    .B2(_082_),
    .X(_092_));
 sky130_fd_sc_hd__a21boi_2 _237_ (.A1(_087_),
    .A2(_089_),
    .B1_N(_086_),
    .Y(_093_));
 sky130_fd_sc_hd__o21ai_2 _238_ (.A1(div[4]),
    .A2(_090_),
    .B1(_093_),
    .Y(_094_));
 sky130_fd_sc_hd__a21oi_2 _239_ (.A1(_085_),
    .A2(_092_),
    .B1(_094_),
    .Y(_095_));
 sky130_fd_sc_hd__xnor2_2 _240_ (.A(_043_),
    .B(_095_),
    .Y(_096_));
 sky130_fd_sc_hd__and2_2 _241_ (.A(\pll_control.tval[1] ),
    .B(_095_),
    .X(_097_));
 sky130_fd_sc_hd__xor2_2 _242_ (.A(\pll_control.tval[1] ),
    .B(_095_),
    .X(_098_));
 sky130_fd_sc_hd__a21o_2 _243_ (.A1(\pll_control.tval[0] ),
    .A2(_098_),
    .B1(_097_),
    .X(_099_));
 sky130_fd_sc_hd__a32o_2 _244_ (.A1(_059_),
    .A2(_096_),
    .A3(_099_),
    .B1(_095_),
    .B2(_057_),
    .X(_100_));
 sky130_fd_sc_hd__and2_2 _245_ (.A(\pll_control.tint[2] ),
    .B(_095_),
    .X(_101_));
 sky130_fd_sc_hd__or2_2 _246_ (.A(\pll_control.tint[2] ),
    .B(_095_),
    .X(_102_));
 sky130_fd_sc_hd__nand2b_2 _247_ (.A_N(_101_),
    .B(_102_),
    .Y(_103_));
 sky130_fd_sc_hd__and2b_2 _248_ (.A_N(_103_),
    .B(_100_),
    .X(_104_));
 sky130_fd_sc_hd__xor2_2 _249_ (.A(\pll_control.tint[3] ),
    .B(_095_),
    .X(_105_));
 sky130_fd_sc_hd__a22o_2 _250_ (.A1(div[0]),
    .A2(_067_),
    .B1(_091_),
    .B2(div[4]),
    .X(_106_));
 sky130_fd_sc_hd__and4bb_2 _251_ (.A_N(_083_),
    .B_N(_106_),
    .C(_084_),
    .D(_082_),
    .X(_107_));
 sky130_fd_sc_hd__and4_2 _252_ (.A(\pll_control.prep[1] ),
    .B(\pll_control.prep[2] ),
    .C(\pll_control.prep[0] ),
    .D(_048_),
    .X(_108_));
 sky130_fd_sc_hd__or2_2 _253_ (.A(\pll_control.tint[3] ),
    .B(\pll_control.tint[2] ),
    .X(_109_));
 sky130_fd_sc_hd__nor2_2 _254_ (.A(\pll_control.tint[4] ),
    .B(_109_),
    .Y(_110_));
 sky130_fd_sc_hd__and4bb_2 _255_ (.A_N(\pll_control.tval[1] ),
    .B_N(\pll_control.tval[0] ),
    .C(_056_),
    .D(_110_),
    .X(_111_));
 sky130_fd_sc_hd__nand2_2 _256_ (.A(\pll_control.tint[3] ),
    .B(\pll_control.tint[2] ),
    .Y(_112_));
 sky130_fd_sc_hd__nor2_2 _257_ (.A(_058_),
    .B(_112_),
    .Y(_113_));
 sky130_fd_sc_hd__a41o_2 _258_ (.A1(\pll_control.tint[4] ),
    .A2(\pll_control.tval[1] ),
    .A3(\pll_control.tval[0] ),
    .A4(_113_),
    .B1(_111_),
    .X(_114_));
 sky130_fd_sc_hd__a21bo_2 _259_ (.A1(_098_),
    .A2(_114_),
    .B1_N(_108_),
    .X(_115_));
 sky130_fd_sc_hd__a31o_2 _260_ (.A1(_069_),
    .A2(_095_),
    .A3(_107_),
    .B1(_115_),
    .X(_116_));
 sky130_fd_sc_hd__a221o_2 _261_ (.A1(_104_),
    .A2(_105_),
    .B1(_109_),
    .B2(_095_),
    .C1(_116_),
    .X(_117_));
 sky130_fd_sc_hd__or2_2 _262_ (.A(_095_),
    .B(_115_),
    .X(_118_));
 sky130_fd_sc_hd__xnor2_2 _263_ (.A(\pll_control.tint[4] ),
    .B(_118_),
    .Y(_119_));
 sky130_fd_sc_hd__xnor2_2 _264_ (.A(_117_),
    .B(_119_),
    .Y(_029_));
 sky130_fd_sc_hd__a21oi_2 _265_ (.A1(_100_),
    .A2(_102_),
    .B1(_101_),
    .Y(_120_));
 sky130_fd_sc_hd__xnor2_2 _266_ (.A(_105_),
    .B(_120_),
    .Y(_121_));
 sky130_fd_sc_hd__mux2_1 _267_ (.A0(_121_),
    .A1(\pll_control.tint[3] ),
    .S(_116_),
    .X(_028_));
 sky130_fd_sc_hd__and2b_2 _268_ (.A_N(_100_),
    .B(_103_),
    .X(_122_));
 sky130_fd_sc_hd__or3_2 _269_ (.A(_104_),
    .B(_116_),
    .C(_122_),
    .X(_123_));
 sky130_fd_sc_hd__a21bo_2 _270_ (.A1(\pll_control.tint[2] ),
    .A2(_116_),
    .B1_N(_123_),
    .X(_027_));
 sky130_fd_sc_hd__and3b_2 _271_ (.A_N(_118_),
    .B(_099_),
    .C(_096_),
    .X(_124_));
 sky130_fd_sc_hd__a21oi_2 _272_ (.A1(_096_),
    .A2(_099_),
    .B1(_116_),
    .Y(_125_));
 sky130_fd_sc_hd__a31oi_2 _273_ (.A1(_043_),
    .A2(_095_),
    .A3(_125_),
    .B1(_124_),
    .Y(_126_));
 sky130_fd_sc_hd__xnor2_2 _274_ (.A(\pll_control.tint[1] ),
    .B(_126_),
    .Y(_026_));
 sky130_fd_sc_hd__or2_2 _275_ (.A(_096_),
    .B(_099_),
    .X(_127_));
 sky130_fd_sc_hd__a22o_2 _276_ (.A1(\pll_control.tint[0] ),
    .A2(_116_),
    .B1(_125_),
    .B2(_127_),
    .X(_025_));
 sky130_fd_sc_hd__xor2_2 _277_ (.A(\pll_control.tval[0] ),
    .B(_098_),
    .X(_128_));
 sky130_fd_sc_hd__mux2_1 _278_ (.A0(_128_),
    .A1(\pll_control.tval[1] ),
    .S(_116_),
    .X(_024_));
 sky130_fd_sc_hd__xnor2_2 _279_ (.A(\pll_control.tval[0] ),
    .B(_116_),
    .Y(_023_));
 sky130_fd_sc_hd__a21oi_2 _280_ (.A1(_056_),
    .A2(_110_),
    .B1(dco),
    .Y(_129_));
 sky130_fd_sc_hd__a21o_2 _281_ (.A1(ext_trim[0]),
    .A2(dco),
    .B1(_129_),
    .X(\ringosc.dstage[0].id.trim[0] ));
 sky130_fd_sc_hd__nand2b_2 _282_ (.A_N(\pll_control.tint[2] ),
    .B(\pll_control.tint[3] ),
    .Y(_130_));
 sky130_fd_sc_hd__or2_2 _283_ (.A(\pll_control.tint[4] ),
    .B(_130_),
    .X(_131_));
 sky130_fd_sc_hd__and2b_2 _284_ (.A_N(\pll_control.tint[3] ),
    .B(\pll_control.tint[2] ),
    .X(_132_));
 sky130_fd_sc_hd__nand2b_2 _285_ (.A_N(\pll_control.tint[3] ),
    .B(\pll_control.tint[2] ),
    .Y(_133_));
 sky130_fd_sc_hd__or2_2 _286_ (.A(\pll_control.tint[4] ),
    .B(_133_),
    .X(_134_));
 sky130_fd_sc_hd__o21a_2 _287_ (.A1(\pll_control.tint[4] ),
    .A2(\pll_control.tint[3] ),
    .B1(_046_),
    .X(_135_));
 sky130_fd_sc_hd__and2_2 _288_ (.A(_131_),
    .B(_135_),
    .X(_136_));
 sky130_fd_sc_hd__a21o_2 _289_ (.A1(dco),
    .A2(ext_trim[1]),
    .B1(_136_),
    .X(\ringosc.dstage[1].id.trim[0] ));
 sky130_fd_sc_hd__a21o_2 _290_ (.A1(dco),
    .A2(ext_trim[2]),
    .B1(_135_),
    .X(\ringosc.dstage[2].id.trim[0] ));
 sky130_fd_sc_hd__nand2_2 _291_ (.A(dco),
    .B(ext_trim[3]),
    .Y(_137_));
 sky130_fd_sc_hd__o21ai_2 _292_ (.A1(dco),
    .A2(_110_),
    .B1(_137_),
    .Y(\ringosc.dstage[3].id.trim[0] ));
 sky130_fd_sc_hd__or2_2 _293_ (.A(\pll_control.tint[1] ),
    .B(_131_),
    .X(_138_));
 sky130_fd_sc_hd__a22o_2 _294_ (.A1(dco),
    .A2(ext_trim[4]),
    .B1(_135_),
    .B2(_138_),
    .X(\ringosc.dstage[4].id.trim[0] ));
 sky130_fd_sc_hd__nand2_2 _295_ (.A(\pll_control.tint[1] ),
    .B(_109_),
    .Y(_139_));
 sky130_fd_sc_hd__o22a_2 _296_ (.A1(_058_),
    .A2(_109_),
    .B1(_133_),
    .B2(_057_),
    .X(_140_));
 sky130_fd_sc_hd__or2_2 _297_ (.A(\pll_control.tint[4] ),
    .B(_140_),
    .X(_141_));
 sky130_fd_sc_hd__a21oi_2 _298_ (.A1(_058_),
    .A2(_110_),
    .B1(dco),
    .Y(_142_));
 sky130_fd_sc_hd__and2_2 _299_ (.A(_141_),
    .B(_142_),
    .X(_143_));
 sky130_fd_sc_hd__o21a_2 _300_ (.A1(_059_),
    .A2(_134_),
    .B1(_143_),
    .X(_144_));
 sky130_fd_sc_hd__a21o_2 _301_ (.A1(dco),
    .A2(ext_trim[5]),
    .B1(_144_),
    .X(\ringosc.dstage[5].id.trim[0] ));
 sky130_fd_sc_hd__or2_2 _302_ (.A(\pll_control.tint[4] ),
    .B(dco),
    .X(_145_));
 sky130_fd_sc_hd__o32a_2 _303_ (.A1(\pll_control.tint[1] ),
    .A2(_109_),
    .A3(_145_),
    .B1(_046_),
    .B2(ext_trim[6]),
    .X(\ringosc.dstage[6].id.trim[0] ));
 sky130_fd_sc_hd__o31a_2 _304_ (.A1(\pll_control.tint[4] ),
    .A2(\pll_control.tint[1] ),
    .A3(_112_),
    .B1(_136_),
    .X(_146_));
 sky130_fd_sc_hd__a221o_2 _305_ (.A1(dco),
    .A2(ext_trim[7]),
    .B1(_136_),
    .B2(\pll_control.tint[0] ),
    .C1(_146_),
    .X(\ringosc.dstage[7].id.trim[0] ));
 sky130_fd_sc_hd__a21o_2 _306_ (.A1(dco),
    .A2(ext_trim[8]),
    .B1(_143_),
    .X(\ringosc.dstage[8].id.trim[0] ));
 sky130_fd_sc_hd__or2_2 _307_ (.A(_057_),
    .B(_131_),
    .X(_147_));
 sky130_fd_sc_hd__a22o_2 _308_ (.A1(dco),
    .A2(ext_trim[9]),
    .B1(_135_),
    .B2(_147_),
    .X(\ringosc.dstage[9].id.trim[0] ));
 sky130_fd_sc_hd__a21o_2 _309_ (.A1(dco),
    .A2(ext_trim[10]),
    .B1(_142_),
    .X(\ringosc.dstage[10].id.trim[0] ));
 sky130_fd_sc_hd__or2_2 _310_ (.A(\pll_control.tint[0] ),
    .B(_131_),
    .X(_148_));
 sky130_fd_sc_hd__a32o_2 _311_ (.A1(_135_),
    .A2(_138_),
    .A3(_148_),
    .B1(ext_trim[11]),
    .B2(dco),
    .X(\ringosc.dstage[11].id.trim[0] ));
 sky130_fd_sc_hd__o31a_2 _312_ (.A1(\pll_control.tint[1] ),
    .A2(_043_),
    .A3(_134_),
    .B1(_143_),
    .X(_149_));
 sky130_fd_sc_hd__a21o_2 _313_ (.A1(dco),
    .A2(ext_trim[12]),
    .B1(_149_),
    .X(\ringosc.iss.trim[0] ));
 sky130_fd_sc_hd__a21o_2 _314_ (.A1(dco),
    .A2(ext_trim[13]),
    .B1(_146_),
    .X(\ringosc.dstage[0].id.trim[1] ));
 sky130_fd_sc_hd__or3b_2 _315_ (.A(\pll_control.tint[3] ),
    .B(\pll_control.tint[2] ),
    .C_N(\pll_control.tint[4] ),
    .X(_150_));
 sky130_fd_sc_hd__o211ai_2 _316_ (.A1(\pll_control.tint[1] ),
    .A2(_132_),
    .B1(_139_),
    .C1(\pll_control.tint[4] ),
    .Y(_151_));
 sky130_fd_sc_hd__or3_2 _317_ (.A(\pll_control.tint[1] ),
    .B(_043_),
    .C(_150_),
    .X(_152_));
 sky130_fd_sc_hd__o32a_2 _318_ (.A1(\pll_control.tint[4] ),
    .A2(_058_),
    .A3(_112_),
    .B1(_150_),
    .B2(_057_),
    .X(_153_));
 sky130_fd_sc_hd__or3b_2 _319_ (.A(\pll_control.tint[4] ),
    .B(_112_),
    .C_N(_058_),
    .X(_154_));
 sky130_fd_sc_hd__o21a_2 _320_ (.A1(_058_),
    .A2(_134_),
    .B1(_131_),
    .X(_155_));
 sky130_fd_sc_hd__and3_2 _321_ (.A(_153_),
    .B(_154_),
    .C(_155_),
    .X(_156_));
 sky130_fd_sc_hd__or3b_2 _322_ (.A(_133_),
    .B(\pll_control.tint[4] ),
    .C_N(\pll_control.tint[1] ),
    .X(_157_));
 sky130_fd_sc_hd__o311a_2 _323_ (.A1(\pll_control.tint[4] ),
    .A2(\pll_control.tint[3] ),
    .A3(_059_),
    .B1(_141_),
    .C1(_154_),
    .X(_158_));
 sky130_fd_sc_hd__and3_2 _324_ (.A(_129_),
    .B(_153_),
    .C(_158_),
    .X(_159_));
 sky130_fd_sc_hd__and3_2 _325_ (.A(_151_),
    .B(_152_),
    .C(_153_),
    .X(_160_));
 sky130_fd_sc_hd__and3_2 _326_ (.A(_136_),
    .B(_154_),
    .C(_160_),
    .X(_161_));
 sky130_fd_sc_hd__nand3_2 _327_ (.A(\pll_control.tint[4] ),
    .B(\pll_control.tint[1] ),
    .C(_132_),
    .Y(_162_));
 sky130_fd_sc_hd__or4b_2 _328_ (.A(\pll_control.tint[1] ),
    .B(\pll_control.tint[0] ),
    .C(_130_),
    .D_N(\pll_control.tint[4] ),
    .X(_163_));
 sky130_fd_sc_hd__a32o_2 _329_ (.A1(_161_),
    .A2(_162_),
    .A3(_163_),
    .B1(ext_trim[14]),
    .B2(dco),
    .X(\ringosc.dstage[1].id.trim[1] ));
 sky130_fd_sc_hd__mux2_1 _330_ (.A0(_150_),
    .A1(_151_),
    .S(_059_),
    .X(_164_));
 sky130_fd_sc_hd__a32o_2 _331_ (.A1(_155_),
    .A2(_159_),
    .A3(_164_),
    .B1(ext_trim[15]),
    .B2(dco),
    .X(\ringosc.dstage[2].id.trim[1] ));
 sky130_fd_sc_hd__a22o_2 _332_ (.A1(dco),
    .A2(ext_trim[16]),
    .B1(_144_),
    .B2(_156_),
    .X(\ringosc.dstage[3].id.trim[1] ));
 sky130_fd_sc_hd__nand3_2 _333_ (.A(\pll_control.tint[4] ),
    .B(_058_),
    .C(_132_),
    .Y(_165_));
 sky130_fd_sc_hd__a21o_2 _334_ (.A1(_150_),
    .A2(_157_),
    .B1(_056_),
    .X(_166_));
 sky130_fd_sc_hd__and4_2 _335_ (.A(_131_),
    .B(_153_),
    .C(_154_),
    .D(_165_),
    .X(_167_));
 sky130_fd_sc_hd__a32o_2 _336_ (.A1(_149_),
    .A2(_166_),
    .A3(_167_),
    .B1(ext_trim[17]),
    .B2(dco),
    .X(\ringosc.dstage[4].id.trim[1] ));
 sky130_fd_sc_hd__and3_2 _337_ (.A(_131_),
    .B(_153_),
    .C(_154_),
    .X(_168_));
 sky130_fd_sc_hd__a32o_2 _338_ (.A1(_149_),
    .A2(_166_),
    .A3(_168_),
    .B1(ext_trim[18]),
    .B2(dco),
    .X(\ringosc.dstage[5].id.trim[1] ));
 sky130_fd_sc_hd__a22o_2 _339_ (.A1(dco),
    .A2(ext_trim[19]),
    .B1(_136_),
    .B2(_154_),
    .X(\ringosc.dstage[6].id.trim[1] ));
 sky130_fd_sc_hd__or3b_2 _340_ (.A(\pll_control.tint[1] ),
    .B(_130_),
    .C_N(\pll_control.tint[4] ),
    .X(_169_));
 sky130_fd_sc_hd__a32o_2 _341_ (.A1(_161_),
    .A2(_162_),
    .A3(_169_),
    .B1(ext_trim[20]),
    .B2(dco),
    .X(\ringosc.dstage[7].id.trim[1] ));
 sky130_fd_sc_hd__a32o_2 _342_ (.A1(_152_),
    .A2(_155_),
    .A3(_159_),
    .B1(ext_trim[21]),
    .B2(dco),
    .X(\ringosc.dstage[8].id.trim[1] ));
 sky130_fd_sc_hd__a21o_2 _343_ (.A1(dco),
    .A2(ext_trim[22]),
    .B1(_161_),
    .X(\ringosc.dstage[9].id.trim[1] ));
 sky130_fd_sc_hd__o21a_2 _344_ (.A1(_046_),
    .A2(ext_trim[23]),
    .B1(_145_),
    .X(\ringosc.dstage[10].id.trim[1] ));
 sky130_fd_sc_hd__a21o_2 _345_ (.A1(_134_),
    .A2(_148_),
    .B1(_056_),
    .X(_170_));
 sky130_fd_sc_hd__o21a_2 _346_ (.A1(_058_),
    .A2(_131_),
    .B1(_154_),
    .X(_171_));
 sky130_fd_sc_hd__and4_2 _347_ (.A(_138_),
    .B(_162_),
    .C(_170_),
    .D(_171_),
    .X(_172_));
 sky130_fd_sc_hd__a32o_2 _348_ (.A1(_143_),
    .A2(_160_),
    .A3(_172_),
    .B1(ext_trim[24]),
    .B2(dco),
    .X(\ringosc.dstage[11].id.trim[1] ));
 sky130_fd_sc_hd__o2111a_2 _349_ (.A1(_059_),
    .A2(_150_),
    .B1(_153_),
    .C1(_138_),
    .D1(_143_),
    .X(_173_));
 sky130_fd_sc_hd__a32o_2 _350_ (.A1(_170_),
    .A2(_171_),
    .A3(_173_),
    .B1(ext_trim[25]),
    .B2(dco),
    .X(\ringosc.iss.trim[1] ));
 sky130_fd_sc_hd__nand2_2 _351_ (.A(enable),
    .B(resetb),
    .Y(\ringosc.iss.reset ));
 sky130_fd_sc_hd__nor2_2 _352_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_000_));
 sky130_fd_sc_hd__nor2_2 _353_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_001_));
 sky130_fd_sc_hd__nor2_2 _354_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_002_));
 sky130_fd_sc_hd__nor2_2 _355_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_003_));
 sky130_fd_sc_hd__nor2_2 _356_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_004_));
 sky130_fd_sc_hd__nor2_2 _357_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_005_));
 sky130_fd_sc_hd__nor2_2 _358_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_006_));
 sky130_fd_sc_hd__nor2_2 _359_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_007_));
 sky130_fd_sc_hd__nor2_2 _360_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_008_));
 sky130_fd_sc_hd__nor2_2 _361_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_009_));
 sky130_fd_sc_hd__nor2_2 _362_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_010_));
 sky130_fd_sc_hd__nor2_2 _363_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_011_));
 sky130_fd_sc_hd__nor2_2 _364_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_012_));
 sky130_fd_sc_hd__nor2_2 _365_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_013_));
 sky130_fd_sc_hd__nor2_2 _366_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_014_));
 sky130_fd_sc_hd__nor2_2 _367_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_015_));
 sky130_fd_sc_hd__nor2_2 _368_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_016_));
 sky130_fd_sc_hd__nor2_2 _369_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_017_));
 sky130_fd_sc_hd__nor2_2 _370_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_018_));
 sky130_fd_sc_hd__nor2_2 _371_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_019_));
 sky130_fd_sc_hd__nor2_2 _372_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_020_));
 sky130_fd_sc_hd__nor2_2 _373_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_021_));
 sky130_fd_sc_hd__nor2_2 _374_ (.A(dco),
    .B(\ringosc.iss.reset ),
    .Y(_022_));
 sky130_fd_sc_hd__dfrtp_2 _375_ (.CLK(\pll_control.clock ),
    .D(_023_),
    .RESET_B(_000_),
    .Q(\pll_control.tval[0] ));
 sky130_fd_sc_hd__dfrtp_2 _376_ (.CLK(\pll_control.clock ),
    .D(_024_),
    .RESET_B(_001_),
    .Q(\pll_control.tval[1] ));
 sky130_fd_sc_hd__dfrtp_2 _377_ (.CLK(\pll_control.clock ),
    .D(_025_),
    .RESET_B(_002_),
    .Q(\pll_control.tint[0] ));
 sky130_fd_sc_hd__dfrtp_2 _378_ (.CLK(\pll_control.clock ),
    .D(_026_),
    .RESET_B(_003_),
    .Q(\pll_control.tint[1] ));
 sky130_fd_sc_hd__dfrtp_2 _379_ (.CLK(\pll_control.clock ),
    .D(_027_),
    .RESET_B(_004_),
    .Q(\pll_control.tint[2] ));
 sky130_fd_sc_hd__dfrtp_2 _380_ (.CLK(\pll_control.clock ),
    .D(_028_),
    .RESET_B(_005_),
    .Q(\pll_control.tint[3] ));
 sky130_fd_sc_hd__dfrtp_2 _381_ (.CLK(\pll_control.clock ),
    .D(_029_),
    .RESET_B(_006_),
    .Q(\pll_control.tint[4] ));
 sky130_fd_sc_hd__dfrtp_2 _382_ (.CLK(\pll_control.clock ),
    .D(_030_),
    .RESET_B(_007_),
    .Q(\pll_control.count0[0] ));
 sky130_fd_sc_hd__dfrtp_2 _383_ (.CLK(\pll_control.clock ),
    .D(_031_),
    .RESET_B(_008_),
    .Q(\pll_control.count0[1] ));
 sky130_fd_sc_hd__dfrtp_2 _384_ (.CLK(\pll_control.clock ),
    .D(_032_),
    .RESET_B(_009_),
    .Q(\pll_control.count0[2] ));
 sky130_fd_sc_hd__dfrtp_2 _385_ (.CLK(\pll_control.clock ),
    .D(_033_),
    .RESET_B(_010_),
    .Q(\pll_control.count0[3] ));
 sky130_fd_sc_hd__dfrtp_2 _386_ (.CLK(\pll_control.clock ),
    .D(_034_),
    .RESET_B(_011_),
    .Q(\pll_control.count0[4] ));
 sky130_fd_sc_hd__dfrtp_2 _387_ (.CLK(\pll_control.clock ),
    .D(_035_),
    .RESET_B(_012_),
    .Q(\pll_control.prep[0] ));
 sky130_fd_sc_hd__dfrtp_2 _388_ (.CLK(\pll_control.clock ),
    .D(_036_),
    .RESET_B(_013_),
    .Q(\pll_control.prep[1] ));
 sky130_fd_sc_hd__dfrtp_2 _389_ (.CLK(\pll_control.clock ),
    .D(_037_),
    .RESET_B(_014_),
    .Q(\pll_control.prep[2] ));
 sky130_fd_sc_hd__dfrtp_2 _390_ (.CLK(\pll_control.clock ),
    .D(osc),
    .RESET_B(_015_),
    .Q(\pll_control.oscbuf[0] ));
 sky130_fd_sc_hd__dfrtp_2 _391_ (.CLK(\pll_control.clock ),
    .D(\pll_control.oscbuf[0] ),
    .RESET_B(_016_),
    .Q(\pll_control.oscbuf[1] ));
 sky130_fd_sc_hd__dfrtp_2 _392_ (.CLK(\pll_control.clock ),
    .D(\pll_control.oscbuf[1] ),
    .RESET_B(_017_),
    .Q(\pll_control.oscbuf[2] ));
 sky130_fd_sc_hd__dfrtp_2 _393_ (.CLK(\pll_control.clock ),
    .D(_038_),
    .RESET_B(_018_),
    .Q(\pll_control.count1[0] ));
 sky130_fd_sc_hd__dfrtp_2 _394_ (.CLK(\pll_control.clock ),
    .D(_039_),
    .RESET_B(_019_),
    .Q(\pll_control.count1[1] ));
 sky130_fd_sc_hd__dfrtp_2 _395_ (.CLK(\pll_control.clock ),
    .D(_040_),
    .RESET_B(_020_),
    .Q(\pll_control.count1[2] ));
 sky130_fd_sc_hd__dfrtp_2 _396_ (.CLK(\pll_control.clock ),
    .D(_041_),
    .RESET_B(_021_),
    .Q(\pll_control.count1[3] ));
 sky130_fd_sc_hd__dfrtp_2 _397_ (.CLK(\pll_control.clock ),
    .D(_042_),
    .RESET_B(_022_),
    .Q(\pll_control.count1[4] ));
 sky130_fd_sc_hd__buf_2 _398_ (.A(\pll_control.clock ),
    .X(clockp[0]));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[0].id.delaybuf0  (.A(\ringosc.dstage[0].id.in ),
    .X(\ringosc.dstage[0].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[0].id.delaybuf1  (.A(\ringosc.dstage[0].id.ts ),
    .X(\ringosc.dstage[0].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[0].id.delayen0  (.A(\ringosc.dstage[0].id.d2 ),
    .TE(\ringosc.dstage[0].id.trim[0] ),
    .Z(\ringosc.dstage[0].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[0].id.delayen1  (.A(\ringosc.dstage[0].id.d0 ),
    .TE(\ringosc.dstage[0].id.trim[1] ),
    .Z(\ringosc.dstage[0].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[0].id.delayenb0  (.A(\ringosc.dstage[0].id.ts ),
    .TE_B(\ringosc.dstage[0].id.trim[0] ),
    .Z(\ringosc.dstage[0].id.out ));
 sky130_fd_sc_hd__einvn_2 \ringosc.dstage[0].id.delayenb1  (.A(\ringosc.dstage[0].id.ts ),
    .TE_B(\ringosc.dstage[0].id.trim[1] ),
    .Z(\ringosc.dstage[0].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[0].id.delayint0  (.A(\ringosc.dstage[0].id.d1 ),
    .Y(\ringosc.dstage[0].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[10].id.delaybuf0  (.A(\ringosc.dstage[10].id.in ),
    .X(\ringosc.dstage[10].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[10].id.delaybuf1  (.A(\ringosc.dstage[10].id.ts ),
    .X(\ringosc.dstage[10].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[10].id.delayen0  (.A(\ringosc.dstage[10].id.d2 ),
    .TE(\ringosc.dstage[10].id.trim[0] ),
    .Z(\ringosc.dstage[10].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[10].id.delayen1  (.A(\ringosc.dstage[10].id.d0 ),
    .TE(\ringosc.dstage[10].id.trim[1] ),
    .Z(\ringosc.dstage[10].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[10].id.delayenb0  (.A(\ringosc.dstage[10].id.ts ),
    .TE_B(\ringosc.dstage[10].id.trim[0] ),
    .Z(\ringosc.dstage[10].id.out ));
 sky130_fd_sc_hd__einvn_2 \ringosc.dstage[10].id.delayenb1  (.A(\ringosc.dstage[10].id.ts ),
    .TE_B(\ringosc.dstage[10].id.trim[1] ),
    .Z(\ringosc.dstage[10].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[10].id.delayint0  (.A(\ringosc.dstage[10].id.d1 ),
    .Y(\ringosc.dstage[10].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[11].id.delaybuf0  (.A(\ringosc.dstage[10].id.out ),
    .X(\ringosc.dstage[11].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[11].id.delaybuf1  (.A(\ringosc.dstage[11].id.ts ),
    .X(\ringosc.dstage[11].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[11].id.delayen0  (.A(\ringosc.dstage[11].id.d2 ),
    .TE(\ringosc.dstage[11].id.trim[0] ),
    .Z(\ringosc.dstage[11].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[11].id.delayen1  (.A(\ringosc.dstage[11].id.d0 ),
    .TE(\ringosc.dstage[11].id.trim[1] ),
    .Z(\ringosc.dstage[11].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[11].id.delayenb0  (.A(\ringosc.dstage[11].id.ts ),
    .TE_B(\ringosc.dstage[11].id.trim[0] ),
    .Z(\ringosc.dstage[11].id.out ));
 sky130_fd_sc_hd__einvn_2 \ringosc.dstage[11].id.delayenb1  (.A(\ringosc.dstage[11].id.ts ),
    .TE_B(\ringosc.dstage[11].id.trim[1] ),
    .Z(\ringosc.dstage[11].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[11].id.delayint0  (.A(\ringosc.dstage[11].id.d1 ),
    .Y(\ringosc.dstage[11].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[1].id.delaybuf0  (.A(\ringosc.dstage[0].id.out ),
    .X(\ringosc.dstage[1].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[1].id.delaybuf1  (.A(\ringosc.dstage[1].id.ts ),
    .X(\ringosc.dstage[1].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[1].id.delayen0  (.A(\ringosc.dstage[1].id.d2 ),
    .TE(\ringosc.dstage[1].id.trim[0] ),
    .Z(\ringosc.dstage[1].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[1].id.delayen1  (.A(\ringosc.dstage[1].id.d0 ),
    .TE(\ringosc.dstage[1].id.trim[1] ),
    .Z(\ringosc.dstage[1].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[1].id.delayenb0  (.A(\ringosc.dstage[1].id.ts ),
    .TE_B(\ringosc.dstage[1].id.trim[0] ),
    .Z(\ringosc.dstage[1].id.out ));
 sky130_fd_sc_hd__einvn_2 \ringosc.dstage[1].id.delayenb1  (.A(\ringosc.dstage[1].id.ts ),
    .TE_B(\ringosc.dstage[1].id.trim[1] ),
    .Z(\ringosc.dstage[1].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[1].id.delayint0  (.A(\ringosc.dstage[1].id.d1 ),
    .Y(\ringosc.dstage[1].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[2].id.delaybuf0  (.A(\ringosc.dstage[1].id.out ),
    .X(\ringosc.dstage[2].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[2].id.delaybuf1  (.A(\ringosc.dstage[2].id.ts ),
    .X(\ringosc.dstage[2].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[2].id.delayen0  (.A(\ringosc.dstage[2].id.d2 ),
    .TE(\ringosc.dstage[2].id.trim[0] ),
    .Z(\ringosc.dstage[2].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[2].id.delayen1  (.A(\ringosc.dstage[2].id.d0 ),
    .TE(\ringosc.dstage[2].id.trim[1] ),
    .Z(\ringosc.dstage[2].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[2].id.delayenb0  (.A(\ringosc.dstage[2].id.ts ),
    .TE_B(\ringosc.dstage[2].id.trim[0] ),
    .Z(\ringosc.dstage[2].id.out ));
 sky130_fd_sc_hd__einvn_2 \ringosc.dstage[2].id.delayenb1  (.A(\ringosc.dstage[2].id.ts ),
    .TE_B(\ringosc.dstage[2].id.trim[1] ),
    .Z(\ringosc.dstage[2].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[2].id.delayint0  (.A(\ringosc.dstage[2].id.d1 ),
    .Y(\ringosc.dstage[2].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[3].id.delaybuf0  (.A(\ringosc.dstage[2].id.out ),
    .X(\ringosc.dstage[3].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[3].id.delaybuf1  (.A(\ringosc.dstage[3].id.ts ),
    .X(\ringosc.dstage[3].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[3].id.delayen0  (.A(\ringosc.dstage[3].id.d2 ),
    .TE(\ringosc.dstage[3].id.trim[0] ),
    .Z(\ringosc.dstage[3].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[3].id.delayen1  (.A(\ringosc.dstage[3].id.d0 ),
    .TE(\ringosc.dstage[3].id.trim[1] ),
    .Z(\ringosc.dstage[3].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[3].id.delayenb0  (.A(\ringosc.dstage[3].id.ts ),
    .TE_B(\ringosc.dstage[3].id.trim[0] ),
    .Z(\ringosc.dstage[3].id.out ));
 sky130_fd_sc_hd__einvn_2 \ringosc.dstage[3].id.delayenb1  (.A(\ringosc.dstage[3].id.ts ),
    .TE_B(\ringosc.dstage[3].id.trim[1] ),
    .Z(\ringosc.dstage[3].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[3].id.delayint0  (.A(\ringosc.dstage[3].id.d1 ),
    .Y(\ringosc.dstage[3].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[4].id.delaybuf0  (.A(\ringosc.dstage[3].id.out ),
    .X(\ringosc.dstage[4].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[4].id.delaybuf1  (.A(\ringosc.dstage[4].id.ts ),
    .X(\ringosc.dstage[4].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[4].id.delayen0  (.A(\ringosc.dstage[4].id.d2 ),
    .TE(\ringosc.dstage[4].id.trim[0] ),
    .Z(\ringosc.dstage[4].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[4].id.delayen1  (.A(\ringosc.dstage[4].id.d0 ),
    .TE(\ringosc.dstage[4].id.trim[1] ),
    .Z(\ringosc.dstage[4].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[4].id.delayenb0  (.A(\ringosc.dstage[4].id.ts ),
    .TE_B(\ringosc.dstage[4].id.trim[0] ),
    .Z(\ringosc.dstage[4].id.out ));
 sky130_fd_sc_hd__einvn_2 \ringosc.dstage[4].id.delayenb1  (.A(\ringosc.dstage[4].id.ts ),
    .TE_B(\ringosc.dstage[4].id.trim[1] ),
    .Z(\ringosc.dstage[4].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[4].id.delayint0  (.A(\ringosc.dstage[4].id.d1 ),
    .Y(\ringosc.dstage[4].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[5].id.delaybuf0  (.A(\ringosc.dstage[4].id.out ),
    .X(\ringosc.dstage[5].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[5].id.delaybuf1  (.A(\ringosc.dstage[5].id.ts ),
    .X(\ringosc.dstage[5].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[5].id.delayen0  (.A(\ringosc.dstage[5].id.d2 ),
    .TE(\ringosc.dstage[5].id.trim[0] ),
    .Z(\ringosc.dstage[5].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[5].id.delayen1  (.A(\ringosc.dstage[5].id.d0 ),
    .TE(\ringosc.dstage[5].id.trim[1] ),
    .Z(\ringosc.dstage[5].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[5].id.delayenb0  (.A(\ringosc.dstage[5].id.ts ),
    .TE_B(\ringosc.dstage[5].id.trim[0] ),
    .Z(\ringosc.dstage[5].id.out ));
 sky130_fd_sc_hd__einvn_2 \ringosc.dstage[5].id.delayenb1  (.A(\ringosc.dstage[5].id.ts ),
    .TE_B(\ringosc.dstage[5].id.trim[1] ),
    .Z(\ringosc.dstage[5].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[5].id.delayint0  (.A(\ringosc.dstage[5].id.d1 ),
    .Y(\ringosc.dstage[5].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[6].id.delaybuf0  (.A(\ringosc.dstage[5].id.out ),
    .X(\ringosc.dstage[6].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[6].id.delaybuf1  (.A(\ringosc.dstage[6].id.ts ),
    .X(\ringosc.dstage[6].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[6].id.delayen0  (.A(\ringosc.dstage[6].id.d2 ),
    .TE(\ringosc.dstage[6].id.trim[0] ),
    .Z(\ringosc.dstage[6].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[6].id.delayen1  (.A(\ringosc.dstage[6].id.d0 ),
    .TE(\ringosc.dstage[6].id.trim[1] ),
    .Z(\ringosc.dstage[6].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[6].id.delayenb0  (.A(\ringosc.dstage[6].id.ts ),
    .TE_B(\ringosc.dstage[6].id.trim[0] ),
    .Z(\ringosc.dstage[6].id.out ));
 sky130_fd_sc_hd__einvn_2 \ringosc.dstage[6].id.delayenb1  (.A(\ringosc.dstage[6].id.ts ),
    .TE_B(\ringosc.dstage[6].id.trim[1] ),
    .Z(\ringosc.dstage[6].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[6].id.delayint0  (.A(\ringosc.dstage[6].id.d1 ),
    .Y(\ringosc.dstage[6].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[7].id.delaybuf0  (.A(\ringosc.dstage[6].id.out ),
    .X(\ringosc.dstage[7].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[7].id.delaybuf1  (.A(\ringosc.dstage[7].id.ts ),
    .X(\ringosc.dstage[7].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[7].id.delayen0  (.A(\ringosc.dstage[7].id.d2 ),
    .TE(\ringosc.dstage[7].id.trim[0] ),
    .Z(\ringosc.dstage[7].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[7].id.delayen1  (.A(\ringosc.dstage[7].id.d0 ),
    .TE(\ringosc.dstage[7].id.trim[1] ),
    .Z(\ringosc.dstage[7].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[7].id.delayenb0  (.A(\ringosc.dstage[7].id.ts ),
    .TE_B(\ringosc.dstage[7].id.trim[0] ),
    .Z(\ringosc.dstage[7].id.out ));
 sky130_fd_sc_hd__einvn_2 \ringosc.dstage[7].id.delayenb1  (.A(\ringosc.dstage[7].id.ts ),
    .TE_B(\ringosc.dstage[7].id.trim[1] ),
    .Z(\ringosc.dstage[7].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[7].id.delayint0  (.A(\ringosc.dstage[7].id.d1 ),
    .Y(\ringosc.dstage[7].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[8].id.delaybuf0  (.A(\ringosc.dstage[7].id.out ),
    .X(\ringosc.dstage[8].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[8].id.delaybuf1  (.A(\ringosc.dstage[8].id.ts ),
    .X(\ringosc.dstage[8].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[8].id.delayen0  (.A(\ringosc.dstage[8].id.d2 ),
    .TE(\ringosc.dstage[8].id.trim[0] ),
    .Z(\ringosc.dstage[8].id.out ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[8].id.delayen1  (.A(\ringosc.dstage[8].id.d0 ),
    .TE(\ringosc.dstage[8].id.trim[1] ),
    .Z(\ringosc.dstage[8].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[8].id.delayenb0  (.A(\ringosc.dstage[8].id.ts ),
    .TE_B(\ringosc.dstage[8].id.trim[0] ),
    .Z(\ringosc.dstage[8].id.out ));
 sky130_fd_sc_hd__einvn_2 \ringosc.dstage[8].id.delayenb1  (.A(\ringosc.dstage[8].id.ts ),
    .TE_B(\ringosc.dstage[8].id.trim[1] ),
    .Z(\ringosc.dstage[8].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[8].id.delayint0  (.A(\ringosc.dstage[8].id.d1 ),
    .Y(\ringosc.dstage[8].id.d2 ));
 sky130_fd_sc_hd__clkbuf_2 \ringosc.dstage[9].id.delaybuf0  (.A(\ringosc.dstage[8].id.out ),
    .X(\ringosc.dstage[9].id.ts ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.dstage[9].id.delaybuf1  (.A(\ringosc.dstage[9].id.ts ),
    .X(\ringosc.dstage[9].id.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[9].id.delayen0  (.A(\ringosc.dstage[9].id.d2 ),
    .TE(\ringosc.dstage[9].id.trim[0] ),
    .Z(\ringosc.dstage[10].id.in ));
 sky130_fd_sc_hd__einvp_2 \ringosc.dstage[9].id.delayen1  (.A(\ringosc.dstage[9].id.d0 ),
    .TE(\ringosc.dstage[9].id.trim[1] ),
    .Z(\ringosc.dstage[9].id.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.dstage[9].id.delayenb0  (.A(\ringosc.dstage[9].id.ts ),
    .TE_B(\ringosc.dstage[9].id.trim[0] ),
    .Z(\ringosc.dstage[10].id.in ));
 sky130_fd_sc_hd__einvn_2 \ringosc.dstage[9].id.delayenb1  (.A(\ringosc.dstage[9].id.ts ),
    .TE_B(\ringosc.dstage[9].id.trim[1] ),
    .Z(\ringosc.dstage[9].id.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.dstage[9].id.delayint0  (.A(\ringosc.dstage[9].id.d1 ),
    .Y(\ringosc.dstage[9].id.d2 ));
 sky130_fd_sc_hd__clkinv_2 \ringosc.ibufp00  (.A(\ringosc.dstage[0].id.in ),
    .Y(\ringosc.c[0] ));
 sky130_fd_sc_hd__clkinv_8 \ringosc.ibufp01  (.A(\ringosc.c[0] ),
    .Y(\pll_control.clock ));
 sky130_fd_sc_hd__clkinv_2 \ringosc.ibufp10  (.A(\ringosc.dstage[5].id.out ),
    .Y(\ringosc.c[1] ));
 sky130_fd_sc_hd__clkinv_8 \ringosc.ibufp11  (.A(\ringosc.c[1] ),
    .Y(clockp[1]));
 sky130_fd_sc_hd__conb_1 \ringosc.iss.const1  (.HI(\ringosc.iss.one ));
 sky130_fd_sc_hd__or2_2 \ringosc.iss.ctrlen0  (.A(\ringosc.iss.reset ),
    .B(\ringosc.iss.trim[0] ),
    .X(\ringosc.iss.ctrl0 ));
 sky130_fd_sc_hd__clkbuf_1 \ringosc.iss.delaybuf0  (.A(\ringosc.dstage[11].id.out ),
    .X(\ringosc.iss.d0 ));
 sky130_fd_sc_hd__einvp_2 \ringosc.iss.delayen0  (.A(\ringosc.iss.d2 ),
    .TE(\ringosc.iss.trim[0] ),
    .Z(\ringosc.dstage[0].id.in ));
 sky130_fd_sc_hd__einvp_2 \ringosc.iss.delayen1  (.A(\ringosc.iss.d0 ),
    .TE(\ringosc.iss.trim[1] ),
    .Z(\ringosc.iss.d1 ));
 sky130_fd_sc_hd__einvn_8 \ringosc.iss.delayenb0  (.A(\ringosc.dstage[11].id.out ),
    .TE_B(\ringosc.iss.ctrl0 ),
    .Z(\ringosc.dstage[0].id.in ));
 sky130_fd_sc_hd__einvn_2 \ringosc.iss.delayenb1  (.A(\ringosc.dstage[11].id.out ),
    .TE_B(\ringosc.iss.trim[1] ),
    .Z(\ringosc.iss.d1 ));
 sky130_fd_sc_hd__clkinv_1 \ringosc.iss.delayint0  (.A(\ringosc.iss.d1 ),
    .Y(\ringosc.iss.d2 ));
 sky130_fd_sc_hd__einvp_1 \ringosc.iss.reseten0  (.A(\ringosc.iss.one ),
    .TE(\ringosc.iss.reset ),
    .Z(\ringosc.dstage[0].id.in ));
endmodule

