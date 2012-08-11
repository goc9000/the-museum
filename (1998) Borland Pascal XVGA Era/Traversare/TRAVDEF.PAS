unit travdef;
interface
const def1:string='     CCCCCC     '+
                  '    CaaCaaaC    '+
                  '   CaaaCaaaaC   '+
                  '  CCcCcCcCCcCCC '+
                  '  CCcCcCcCCcCCCC'+
                  ' CCCRccCccccRCCC'+
                  '   RAR     RAR  '+
                  '    R       R   ';
       def2:string='C     m CCCC    '+
                   'CCCCC m CaaaC   '+
                   'ccccC mmCaaaC   '+
                   'CCCcC mmCcCcCCC '+
                   'ccccC mmCcCcCCCC'+
                   'CCCCRCCCCcccRCCC'+
                   '   RAR     RAR  '+
                   '    R       R   ';
       def3:string=' CCCCCCCCCCCCCCC'+
                   ' Ccccccccccccccc'+
                   ' CcCCCCCCCCCCCCc'+
                   ' CcCCCCCCCCCCCCC'+
                   ' Ccccccccccccccc'+
                   ' CRCCRCCCCRCCRCC'+
                   ' RARRAR  RARRAR '+
                   '  R  R    R  R  ';
       def4:string='                '+
                   '  CCCC          '+
                   '    C  CCC      '+
                   '   CC CCCC      '+
                   '   CCCCCCCCCCC  '+
                   '  CCRCccccccCRC '+
                   '  CRARcCCCCcRARC'+
                   '    R        R  ';
       def5:string='zzzzzzzcczzzzzzz'+
                   'zzzzzzzcfzzzzzzz'+
                   'zzzzzzzbbbdffzzz'+
                   'zzzzCCzbbzzfzzzz'+
                   'zzzcccCfffCcfczz'+
                   'zzmmRmmmCfcCRzzz'+
                   'zzzRARCmCeCRARzz'+
                   'zzzzRzzzzzzzRzzz';
       def6:string='..........vvvv..'+
                   '........vv..v.v.'+
                   '.......v..v....v'+
                   '......v.....vv.v'+
                   '......v.v..v..v.'+
                   '.....v..v..v....'+
                   '...vv......v.v..'+
                   '..v...v..v..v.v.';
       def7:string='................'+
                   '................'+
                   '................'+
                   '..............k.'+
                   '...........k.kv.'+
                   '..........kMkv..'+
                   '..kk.kk.kkkkv.v.'+
                   '.kkkkkkkkkkkkkkk';
       def8:string='................'+
                   '................'+
                   '.......ee.......'+
                   '.... ..ed..v....'+
                   '.... ..   dvv...'+
                   '...vvvvvvvvvvvvv'+
                   '..cvccvvvvvvv v.'+
                   '..cvvvvvvvvvvv..';
       def9:string='vv..............'+
                   'vvkkkkkkkkkkkkkk'+
                   'vv.k.k.k.k.k.k..'+
                   '                '+
                   '            R  .'+
                   '               .'+
                   '              ..'+
                   '              ..';
       defa:string='......vvvvvvvvvv'+
                   'kkkkkkvvaavvaavv'+
                   'k.k.k.vvaavvaavv'+
                   '                '+
                   '                '+
                   '                '+
                   '                '+
                   '                ';
       defb:string='........... ....'+
                   '.kkkkkkkkkkkkkkk'+
                   '..k.k.k.k k k.k.'+
                   '.               '+
                   '.               '+
                   '.               '+
                   '..              '+
                   '..c.            ';
     q=10;
     v=14;
     u=31;
     t=20;
     w=129;
     r=128;
     e=9;
     zona0:array[1..64] of byte=(0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0);
     zona1:array[1..64] of byte=(2,2,2,2,2,2,2,2,
                                 2,2,2,2,2,2,2,2,
                                 2,2,2,2,2,2,2,2,
                                 2,2,2,2,2,2,2,2,
                                 2,2,2,2,2,2,2,2,
                                 2,2,2,2,2,2,2,2,
                                 2,2,2,2,2,2,2,2,
                                 2,2,2,2,2,2,2,2);
     zona2:array[1..64] of byte=(0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,0,q,0,0,q,0,0,
                                 q,q,q,q,q,q,q,q,
                                 2,2,q,2,2,2,q,2,
                                 q,q,q,q,q,q,q,q,
                                 2,2,q,2,2,2,q,2,
                                 2,2,2,2,2,2,2,2);
     zona3:array[1..64] of byte=(0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,7,7,7,7,7,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0);
     zona4:array[1..64] of byte=(0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,7,7,7,7,7,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,7,7,7,7,7,0,0,
                                 0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0);
     zona5:array[1..64] of byte=(2,2,2,2,2,2,2,2,
                                 2,2,2,2,2,2,2,2,
                                 2,2,q,2,2,q,2,2,
                                 q,q,q,q,q,q,q,q,
                                 0,0,q,0,0,0,q,0,
                                 q,q,q,q,q,q,q,q,
                                 0,0,q,0,0,0,q,0,
                                 0,0,0,0,0,0,0,0);
     zona6:array[1..64] of byte=(6,6,6,6,6,6,6,6,
                                 6,6,6,6,6,6,6,6,
                                 6,6,q,6,6,q,6,6,
                                 q,q,q,q,q,q,q,q,
                                 2,2,q,2,2,2,q,2,
                                 q,q,q,q,q,q,q,q,
                                 2,2,q,2,2,2,q,2,
                                 2,2,2,2,2,2,2,2);
     zona7:array[1..64] of byte=(6,6,6,6,6,6,6,6,
                                 6,6,6,6,6,6,6,6,
                                 6,6,6,6,6,6,6,6,
                                 6,6,6,6,6,6,6,6,
                                 6,6,6,6,6,6,6,6,
                                 6,6,6,6,6,6,6,6,
                                 6,6,6,6,6,6,6,6,
                                 6,6,6,6,6,6,6,6);
     zona8:array[1..64] of byte=(2,2,2,2,2,2,2,2,
                                 2,2,2,2,2,2,2,2,
                                 2,2,q,2,2,q,2,2,
                                 q,q,q,q,q,q,q,q,
                                 6,6,q,6,6,6,q,6,
                                 q,q,q,q,q,q,q,q,
                                 6,6,q,6,6,6,q,6,
                                 6,6,6,6,6,6,6,6);
     om1:  array[1..64] of byte=(0,0,0,w,0,0,0,0,
                                 0,0,w,w,w,0,0,0,
                                 0,0,0,r,0,0,0,0,
                                 0,e,e,e,e,e,0,0,
                                 e,0,e,e,e,0,e,0,
                                 0,r,v,v,v,r,0,0,
                                 0,0,v,0,v,0,0,0,
                                 0,w,w,0,w,w,0,0);
     om2:  array[1..64] of byte=(0,0,w,w,w,0,r,0,
                                 0,0,w,r,w,0,e,0,
                                 0,e,e,e,e,e,0,0,
                                 e,0,e,e,e,0,0,0,
                                 r,0,v,v,v,0,0,0,
                                 0,0,v,0,w,w,0,0,
                                 0,0,w,0,0,0,0,0,
                                 0,w,0,0,0,0,0,0);
     om3:  array[1..64] of byte=(0,0,0,w,0,0,0,0,
                                 0,0,w,w,w,0,0,0,
                                 0,0,0,r,0,0,0,0,
                                 0,e,e,e,e,e,0,0,
                                 e,0,e,e,e,0,e,0,
                                 0,r,v,v,v,r,0,0,
                                 0,v,0,w,0,0,0,0,
                                 w,w,0,0,w,0,0,0);
     om4:  array[1..64] of byte=(0,0,0,w,0,0,0,0,
                                 0,0,w,w,w,0,0,0,
                                 0,0,0,r,0,0,0,0,
                                 0,e,e,e,e,e,0,0,
                                 e,0,e,e,e,0,e,0,
                                 0,r,v,v,v,r,0,0,
                                 0,0,0,w,0,v,0,0,
                                 0,0,w,0,0,w,w,0);
     om5:  array[1..64] of byte=(0,0,0,0,0,0,0,0,
                                 0,0,0,w,0,0,0,0,
                                 0,0,w,w,w,0,0,0,
                                 0,0,0,r,0,0,0,0,
                                 0,e,e,e,e,e,0,0,
                                 e,v,e,e,e,v,e,0,
                                 0,v,v,v,v,v,0,0,
                                 0,0,0,0,0,0,0,0);
     omm:  array[1..64] of byte=(0,0,0,w,0,0,0,0,
                                 r,0,w,w,w,0,r,0,
                                 0,e,0,r,0,e,0,0,
                                 0,0,e,e,e,0,0,0,
                                 0,0,e,e,e,0,0,0,
                                 0,0,v,v,v,0,0,0,
                                 w,v,0,0,0,v,w,0,
                                 0,w,0,0,0,w,0,0);
implementation
begin
end.