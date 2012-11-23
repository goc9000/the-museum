unit adlibu;
interface
uses crt;
type instrument=array[1..15] of byte;
     songa=array[0..64000] of byte;
     virtsong=^songa;
const maxframes=2000;
      b   =$2ae;
      c   =$16b;
      cm  =$181;
      d   =$198;
      dm  =$1b0;
      e   =$1ca;
      f   =$1e5;
      fm  =$202;
      g   =$220;
      gm  =$241;
      a   =$263;
      am  =$287;
      cho:array[0..8] of byte=(0,1,2,8,9,$a,$10,$11,$12);
      ins_vol1=1;
      ins_vol2=2;
      ins_atk1=3;
      ins_atk2=4;
      ins_dek1=5;
      ins_dek2=6;
      ins_sus1=7;
      ins_sus2=8;
      ins_rel1=9;
      ins_rel2=10;
      ins_hrm1=11;
      ins_hrm2=12;
      ins_wav1=13;
      ins_wav2=14;
      ins_conn=15;

      bd_oct=1;
      op_hi_fq=f*2;
      op_hi_oc=7;
      cl_hi_fq=f*2;
      cl_hi_oc=7;

                            {VL1 VL2 AT1 AT2 DC1 DC2 SU1 SU2 RL1 RL2 HM1 HM2 WV1 WV2 CON}
   bass_drum_def:instrument=(  0,  0, 15, 15, 15, 15,  0,  0,  9,  9,  0,  0,  0,  0,  0);
      snared_def:instrument=(  0,  0, 15, 15, 10, 10,  3,  3,  7,  7,  0,  0,  0,  0,  0);
         tombase:instrument=(  0,  0, 15, 15, 15, 15,  0,  0,  8,  8,  0,  0,  0,  0,  0);
     rev_cym_def:instrument=(  0,  0,  1,  1,  9,  9,  1,  1,  4,  4,  1,  1,  1,  1,  1);
   crash_cym_def:instrument=(  0,  0, 15, 15,  7,  7,  3,  3,  3,  3,  1,  1,  1,  1,  1);
  hihat_open_def:instrument=(  0,  0, 15, 15, 15, 15,  3,  3,  6,  6,  1,  1,  1,  1,  1);
hihat_closed_def:instrument=(  0,  0, 15, 15, 15, 15,  3,  3,  9,  9,  1,  1,  1,  1,  1);
           organ:instrument=(  0,  0, 15, 15, 13, 13,  3,  3,  0,  0,  0,  0,  0,  0,  0);
var i,j,k:longint;
    sgvir:virtsong;
    sgadr:word;
    songptr:longint;
    maxptr:longint;
    chmt:array[1..6] of byte;
    chon:array[1..6] of byte;
    chvols:array[1..6,1..2] of integer; {NEGATIVE VALUES TOO, SO THE DIFFERENCE
                                         BETWEEN 1 AND 2 REMAINS CONSTANT IF
                                         ONE SHIFTS PAST A MAX VALUE !}
    gotos:integer;
    lbrow:integer;
    crtimes:integer;
    songtitle:string;
    chfreq:array[1..6] of integer;
    chslf:array[1..6] of integer;
    vibflag,tremflag:integer;
    bass_drum:instrument;
    snared   :instrument;
    rev_cym  :instrument;
    crash_cym:instrument;
   hihat_open:instrument;
 hihat_closed:instrument;
    choct:array[1..6] of integer;
    inses:array[1..15] of instrument;
    insnames:array[1..15] of string;
    crspeed:integer;
    frames,columns:integer;
    bln:char;
    fi:file of char;
procedure SlideFreqs;
procedure PlayNote(chann:integer);
procedure Bdrum;
procedure Snare;
procedure HHo;
procedure HHc;
procedure BdHHo;
procedure BdHHc;
procedure BdCrh;
procedure BdRev;
procedure Crash;
procedure RevCr;
procedure readframe;
procedure stopfm;
procedure Note(freq,oct,chn:integer;ins:instrument);
procedure Shutup(chn:word);
procedure Config(freq,oct,chn:integer;ins:instrument);
procedure initfm;
procedure initmux;
procedure deinitmux;
procedure Reg(r:byte;v:byte);
implementation
procedure Reg(r:byte;v:byte);
var mi,mj:integer;
begin
port[$388]:=r;
for mi:=1 to 6*2 do mj:=port[$388];
port[$389]:=v;
for mi:=1 to 35*2 do mj:=port[$388];
end;

procedure Shutup(chn:word);
begin
Reg($a0+chn,0);
Reg($b0+chn,0);
chon[chn+1]:=0;
end;

procedure SlideFreQs;
begin
for j:=0 to (columns-1) do
begin
if chfreq[j+1]>chslf[j+1] then dec(chfreq[j+1]);
if chfreq[j+1]<chslf[j+1] then inc(chfreq[j+1]);
if chon[j+1]=1 then
begin
Reg($a0+j,lo(chfreq[j+1]));
Reg($b0+j,(choct[j+1] shl 2)+32+hi(chfreq[j+1]));
end;
if chon[j+1]=0 then
begin
Reg($a0+j,0);
Reg($b0+j,0);
end;
end;
end;

procedure SetChVols(chn:word;cvol1,cvol2:integer);
begin
if (cvol1>-1) and (cvol1<64) then Reg($40+cho[chn],cvol1);
if (cvol2>-1) and (cvol2<64) then Reg($40+cho[chn]+3,cvol2);
if (cvol1<0) then Reg($40+cho[chn],0);
if (cvol2<0) then Reg($40+cho[chn]+3,0);
if (cvol1>63) then Reg($40+cho[chn],63);
if (cvol2>63) then Reg($40+cho[chn]+3,63);
end;

procedure SlideVolTo(chann:integer;slto:integer);
begin
          while (chvols[chann+1,2]<>slto) do
          begin
          if chvols[chann+1,2]<slto then begin
                                       inc(chvols[chann+1,2]);
                                       inc(chvols[chann+1,1]);
                                       end;
          if chvols[chann+1,2]>slto then begin
                                       dec(chvols[chann+1,2]);
                                       dec(chvols[chann+1,1]);
                                       end;
          end;
          SetChVols(chann,chvols[chann+1,1],chvols[chann+1,2]);
          gotoxy(1,1);
          end;

procedure Note(freq,oct,chn:integer;ins:instrument);
begin
chon[chn+1]:=1;
choct[chn+1]:=oct;
chvols[chn+1,1]:=ins[ins_vol1];
chvols[chn+1,2]:=ins[ins_vol2];
chfreq[chn+1]:=freq;
chslf[chn+1]:=freq;
Reg($40+cho[chn],ins[ins_vol1]);
Reg($40+cho[chn]+3,ins[ins_vol2]);
Reg($20+cho[chn],ins[ins_hrm1]);
Reg($20+cho[chn]+3,ins[ins_hrm2]);
Reg($60+cho[chn],(ins[ins_atk1] shl 4)+ins[ins_dek1]);
Reg($60+cho[chn]+3,(ins[ins_atk2] shl 4)+ins[ins_dek2]);
Reg($80+cho[chn],(ins[ins_sus1] shl 4)+ins[ins_rel1]);
Reg($80+cho[chn]+3,(ins[ins_sus2] shl 4)+ins[ins_rel2]);
Reg($a0+chn,lo(freq));
Reg($b0+chn,(oct shl 2)+0+hi(freq));
Reg($b0+chn,(oct shl 2)+32+hi(freq));
Reg($c0+chn,ins[ins_conn]);
Reg($e0+cho[chn],ins[ins_wav1]);
Reg($e0+cho[chn]+3,ins[ins_wav2]);
end;

procedure Config(freq,oct,chn:integer;ins:instrument);
begin
Reg($40+cho[chn],ins[ins_vol1]);
Reg($40+cho[chn]+3,ins[ins_vol2]);
Reg($20+cho[chn],ins[ins_hrm1]);
Reg($20+cho[chn]+3,ins[ins_hrm2]);
Reg($60+cho[chn],(ins[ins_atk1] shl 4)+ins[ins_dek1]);
Reg($60+cho[chn]+3,(ins[ins_atk2] shl 4)+ins[ins_dek2]);
Reg($80+cho[chn],(ins[ins_sus1] shl 4)+ins[ins_rel1]);
Reg($80+cho[chn]+3,(ins[ins_sus2] shl 4)+ins[ins_rel2]);
Reg($a0+chn,lo(freq));
Reg($b0+chn,(oct shl 2)+0+hi(freq));
Reg($c0+chn,ins[ins_conn]);
Reg($e0+cho[chn],ins[ins_wav1]);
Reg($e0+cho[chn]+3,ins[ins_wav2]);
end;

procedure Bdrum;
begin
reg($bd,32);
Config(d,bd_oct,6,bass_drum);
Config(a,3,8,tombase);
reg($bd,128*tremflag+64*tremflag+32+16+4);
end;

procedure BdCrh;
begin
reg($bd,32);
Config(d,bd_oct,6,bass_drum);
Config(a,3,8,tombase);
Config(op_hi_fq,op_hi_oc,7,crash_cym);
reg($bd,128*tremflag+64*tremflag+32+8+16+4);
end;

procedure BdRev;
begin
reg($bd,32);
Config(d,bd_oct,6,bass_drum);
Config(a,3,8,tombase);
Config(op_hi_fq,op_hi_oc,7,rev_cym);
reg($bd,128*tremflag+64*tremflag+32+8+16+4);
end;

procedure Crash;
begin
reg($bd,32);
Config(op_hi_fq,op_hi_oc,7,crash_cym);
reg($bd,128*tremflag+64*tremflag+32+8);
end;

procedure Revcr;
begin
reg($bd,32);
Config(op_hi_fq,op_hi_oc,7,rev_cym);
reg($bd,128*tremflag+64*tremflag+32+8);
end;

procedure HHo;
begin
reg($bd,32);
Config(op_hi_fq,op_hi_oc,7,hihat_open);
reg($bd,128*tremflag+64*tremflag+32+8);
end;

procedure HHc;
begin
reg($bd,32);
Config(cl_hi_fq,cl_hi_oc,7,hihat_closed);
reg($bd,128*tremflag+64*tremflag+32+8);
end;

procedure BdHhc;
begin
reg($bd,32);
Config(d,bd_oct,6,bass_drum);
Config(a,3,8,tombase);
Config(cl_hi_fq,cl_hi_oc,7,hihat_closed);
reg($bd,128*tremflag+64*tremflag+32+8+16+4);
end;

procedure BdHhO;
begin
reg($bd,32);
Config(d,bd_oct,6,bass_drum);
Config(a,3,8,tombase);
Config(op_hi_fq,op_hi_oc,7,hihat_open);
reg($bd,128*tremflag+64*tremflag+32+8+16+4);
end;

procedure Snare;
begin
reg($bd,32);
Config(d,3,6,bass_drum);
Config(0,0,7,snared);
Config(a,3,8,tombase);
reg($bd,128*tremflag+64*tremflag+32+8+4+16);
end;

procedure PlayNote(chann:integer);
var at,dc,su,rl,wv,oc,fq,ch,ins:integer;
    tsngptr:integer;
label pufiu;
begin
tsngptr:=songptr;
pufiu:
songptr:=songptr+(chann-1)*4;
fq:=0;
ins:=0;
if (mem[sgadr:songptr]=ord('1')) and (mem[sgadr:songptr+1]=ord(' ')) then Bdrum;
if (mem[sgadr:songptr]=ord('2')) then Snare;
if (mem[sgadr:songptr]=ord('3')) then HHc;
if (mem[sgadr:songptr]=ord('4')) then HHO;
if (mem[sgadr:songptr]=ord('5')) then Crash;
if (mem[sgadr:songptr]=ord('6')) then Revcr;
if (mem[sgadr:songptr]=ord('1')) and (mem[sgadr:songptr+1]=ord('3')) then BdHhc;
if (mem[sgadr:songptr]=ord('1')) and (mem[sgadr:songptr+1]=ord('4')) then BdHHo;
if (mem[sgadr:songptr]=ord('1')) and (mem[sgadr:songptr+1]=ord('5')) then BdCrh;
if (mem[sgadr:songptr]=ord('1')) and (mem[sgadr:songptr+1]=ord('6')) then BdRev;


if (mem[sgadr:songptr]=ord('C')) and (mem[sgadr:songptr+1]=ord(' ')) then fq:=c;
if (mem[sgadr:songptr]=ord('C')) and (mem[sgadr:songptr+1]=ord('#')) then fq:=cm;
if (mem[sgadr:songptr]=ord('D')) and (mem[sgadr:songptr+1]=ord(' ')) then fq:=d;
if (mem[sgadr:songptr]=ord('D')) and (mem[sgadr:songptr+1]=ord('#')) then fq:=dm;
if (mem[sgadr:songptr]=ord('E')) and (mem[sgadr:songptr+1]=ord(' ')) then fq:=e;
if (mem[sgadr:songptr]=ord('F')) and (mem[sgadr:songptr+1]=ord(' ')) then fq:=f;
if (mem[sgadr:songptr]=ord('F')) and (mem[sgadr:songptr+1]=ord('#')) then fq:=fm;
if (mem[sgadr:songptr]=ord('G')) and (mem[sgadr:songptr+1]=ord(' ')) then fq:=g;
if (mem[sgadr:songptr]=ord('G')) and (mem[sgadr:songptr+1]=ord('#')) then fq:=gm;
if (mem[sgadr:songptr]=ord('A')) and (mem[sgadr:songptr+1]=ord(' ')) then fq:=a;
if (mem[sgadr:songptr]=ord('A')) and (mem[sgadr:songptr+1]=ord('#')) then fq:=am;
if (mem[sgadr:songptr]=ord('B')) and (mem[sgadr:songptr+1]=ord(' ')) then fq:=b;
ch:=1;
if (mem[sgadr:songptr]=ord(' ')) then ch:=0;
if fq=0 then ch:=0;
if (mem[sgadr:songptr+2]=ord('0')) then oc:=0;
if (mem[sgadr:songptr+2]=ord('1')) then oc:=1;
if (mem[sgadr:songptr+2]=ord('2')) then oc:=2;
if (mem[sgadr:songptr+2]=ord('3')) then oc:=3;
if (mem[sgadr:songptr+2]=ord('4')) then oc:=4;
if (mem[sgadr:songptr+2]=ord('5')) then oc:=5;
if (mem[sgadr:songptr+2]=ord('6')) then oc:=6;
if (mem[sgadr:songptr+2]=ord('7')) then oc:=7;
if (mem[sgadr:songptr+3]=ord('1')) then ins:=1;
if (mem[sgadr:songptr+3]=ord('2')) then ins:=2;
if (mem[sgadr:songptr+3]=ord('3')) then ins:=3;
if (mem[sgadr:songptr+3]=ord('4')) then ins:=4;
if (mem[sgadr:songptr+3]=ord('5')) then ins:=5;
if (mem[sgadr:songptr+3]=ord('6')) then ins:=6;
if (mem[sgadr:songptr+3]=ord('7')) then ins:=7;
if (mem[sgadr:songptr+3]=ord('8')) then ins:=8;
if (mem[sgadr:songptr+3]=ord('9')) then ins:=9;
if ch=1 then
begin
note(fq,oc,i,inses[ins]);
end;
if       (mem[sgadr:songptr+0]=ord('N'))
     and (mem[sgadr:songptr+1]=ord('T'))
     and (mem[sgadr:songptr+2]=ord('E'))
     and (mem[sgadr:songptr+3]=ord('˜'))
     then begin
          Shutup(chann);
          end;
if       (mem[sgadr:songptr+0]=ord('F'))
     and (mem[sgadr:songptr+1]=ord('R'))
     and (mem[sgadr:songptr+2]=ord('Q'))
     and (mem[sgadr:songptr+3]=24)
     then begin
          chslf[chann+1]:=chfreq[chann+1]+8;
          end;
if       (mem[sgadr:songptr+0]=ord('F'))
     and (mem[sgadr:songptr+1]=ord('R'))
     and (mem[sgadr:songptr+2]=ord('Q'))
     and (mem[sgadr:songptr+3]=25)
     then begin
          chslf[chann+1]:=chfreq[chann+1]-8;
          end;
if       (mem[sgadr:songptr+0]=ord('F'))
     and (mem[sgadr:songptr+1]=ord('R'))
     and (mem[sgadr:songptr+2]=ord('Q'))
     and (mem[sgadr:songptr+3]=156)
     then begin
          chslf[chann+1]:=chfreq[chann+1]+24;
          end;
if       (mem[sgadr:songptr+0]=ord('F'))
     and (mem[sgadr:songptr+1]=ord('R'))
     and (mem[sgadr:songptr+2]=ord('Q'))
     and (mem[sgadr:songptr+3]=157)
     then begin
          chslf[chann+1]:=chfreq[chann+1]-24;
          end;
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('O'))
     and (mem[sgadr:songptr+2]=ord('L'))
     and (mem[sgadr:songptr+3]=24)
     then begin
          if (chvols[chann+1,1]>0) and (chvols[chann+1,2]>0) then
          begin
          dec(chvols[chann+1,1]);
          dec(chvols[chann+1,2]);
          end;
          SetChVols(chann,chvols[chann+1,1],chvols[chann+1,2]);
          end;
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('O'))
     and (mem[sgadr:songptr+2]=ord('L'))
     and (mem[sgadr:songptr+3]=25)
     then begin
          if (chvols[chann+1,1]<63) and (chvols[chann+1,2]<63) then
          begin
          inc(chvols[chann+1,1]);
          inc(chvols[chann+1,2]);
          end;
          SetChVols(chann,chvols[chann+1,1],chvols[chann+1,2]);
          end;
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('O'))
     and (mem[sgadr:songptr+2]=ord('L'))
     and (mem[sgadr:songptr+3]=156)
     then begin
          if (chvols[chann+1,1]>0) and (chvols[chann+1,2]>0) then
          begin
          dec(chvols[chann+1,1]);
          dec(chvols[chann+1,2]);
          end;
          if (chvols[chann+1,1]>0) and (chvols[chann+1,2]>0) then
          begin
          dec(chvols[chann+1,1]);
          dec(chvols[chann+1,2]);
          end;
          if (chvols[chann+1,1]>0) and (chvols[chann+1,2]>0) then
          begin
          dec(chvols[chann+1,1]);
          dec(chvols[chann+1,2]);
          end;
          SetChVols(chann,chvols[chann+1,1],chvols[chann+1,2]);
          end;
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('O'))
     and (mem[sgadr:songptr+2]=ord('L'))
     and (mem[sgadr:songptr+3]=157)
     then begin
          if (chvols[chann+1,1]<63) and (chvols[chann+1,2]<63) then
          begin
          inc(chvols[chann+1,1]);
          inc(chvols[chann+1,2]);
          end;
          if (chvols[chann+1,1]<63) and (chvols[chann+1,2]<63) then
          begin
          inc(chvols[chann+1,1]);
          inc(chvols[chann+1,2]);
          end;
          if (chvols[chann+1,1]<63) and (chvols[chann+1,2]<63) then
          begin
          inc(chvols[chann+1,1]);
          inc(chvols[chann+1,2]);
          end;
          SetChVols(chann,chvols[chann+1,1],chvols[chann+1,2]);
          end;
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('O'))
     and (mem[sgadr:songptr+2]=ord('L'))
     and (mem[sgadr:songptr+3]=ord('0'))
     then SlideVolTo(chann,63-0);
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('O'))
     and (mem[sgadr:songptr+2]=ord('L'))
     and (mem[sgadr:songptr+3]=ord('1'))
     then SlideVolTo(chann,63-11);
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('O'))
     and (mem[sgadr:songptr+2]=ord('L'))
     and (mem[sgadr:songptr+3]=ord('2'))
     then SlideVolTo(chann,63-21);
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('O'))
     and (mem[sgadr:songptr+2]=ord('L'))
     and (mem[sgadr:songptr+3]=ord('3'))
     then SlideVolTo(chann,63-31);
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('O'))
     and (mem[sgadr:songptr+2]=ord('L'))
     and (mem[sgadr:songptr+3]=ord('4'))
     then SlideVolTo(chann,63-39);
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('O'))
     and (mem[sgadr:songptr+2]=ord('L'))
     and (mem[sgadr:songptr+3]=ord('5'))
     then SlideVolTo(chann,63-47);
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('O'))
     and (mem[sgadr:songptr+2]=ord('L'))
     and (mem[sgadr:songptr+3]=ord('6'))
     then SlideVolTo(chann,63-53);
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('O'))
     and (mem[sgadr:songptr+2]=ord('L'))
     and (mem[sgadr:songptr+3]=ord('7'))
     then SlideVolTo(chann,63-57);
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('O'))
     and (mem[sgadr:songptr+2]=ord('L'))
     and (mem[sgadr:songptr+3]=ord('8'))
     then SlideVolTo(chann,63-55);
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('O'))
     and (mem[sgadr:songptr+2]=ord('L'))
     and (mem[sgadr:songptr+3]=ord('9'))
     then SlideVolTo(chann,63-63);
if       (mem[sgadr:songptr+0]=ord('S'))
     and (mem[sgadr:songptr+1]=ord('P'))
     and (mem[sgadr:songptr+2]=ord('D'))
     then crspeed:=mem[sgadr:songptr+3]-48;
if       (mem[sgadr:songptr+0]=ord('S'))
     and (mem[sgadr:songptr+1]=ord('E'))
     and (mem[sgadr:songptr+2]=ord('T'))
     and (mem[sgadr:songptr+3]=153)
     then begin
          lbrow:=tsngptr;
          end;
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('I'))
     and (mem[sgadr:songptr+2]=ord('B'))
     and (mem[sgadr:songptr+3]=154)
     then begin
          vibflag:=1;
          reg($bd,128*tremflag+64*vibflag);
          end;
if       (mem[sgadr:songptr+0]=ord('V'))
     and (mem[sgadr:songptr+1]=ord('I'))
     and (mem[sgadr:songptr+2]=ord('B'))
     and (mem[sgadr:songptr+3]=155)
     then begin
          vibflag:=0;
          reg($bd,128*tremflag+64*vibflag);
          end;
if       (mem[sgadr:songptr+0]=ord('T'))
     and (mem[sgadr:songptr+1]=ord('R'))
     and (mem[sgadr:songptr+2]=ord('M'))
     and (mem[sgadr:songptr+3]=154)
     then begin
          tremflag:=1;
          reg($bd,128*tremflag+64*vibflag);
          end;
if       (mem[sgadr:songptr+0]=ord('T'))
     and (mem[sgadr:songptr+1]=ord('R'))
     and (mem[sgadr:songptr+2]=ord('M'))
     and (mem[sgadr:songptr+3]=155)
     then begin
          tremflag:=0;
          reg($bd,128*tremflag+64*vibflag);
          end;
if       (mem[sgadr:songptr+0]=ord('R'))
     and (mem[sgadr:songptr+1]=ord('E'))
     and (mem[sgadr:songptr+2]=ord('P'))
     and (mem[sgadr:songptr+3]=159)
     then begin
          gotos:=lbrow;
          end;
if       (mem[sgadr:songptr+0]=ord('E'))
     and (mem[sgadr:songptr+1]=ord('N'))
     and (mem[sgadr:songptr+2]=ord('D'))
     then begin
          gotos:=1;
          end;
if       (mem[sgadr:songptr+0]=ord('R'))
     and (mem[sgadr:songptr+1]=ord('E'))
     and (mem[sgadr:songptr+2]=ord('P'))
     and (mem[sgadr:songptr+3]<>159)
     then begin
          if (crtimes<(ord(mem[sgadr:songptr+3])-48)) then
          begin
          inc(crtimes);
          gotos:=lbrow;
          end
          else
          begin
          crtimes:=0;
          end;
          end;
SlideFreQS;
songptr:=tsngptr;
end;

procedure Readframe;
var at,dc,su,rl,wv,oc,fq,ch,ins:integer;
label pufiu;
begin
gotos:=0;
pufiu:
for i:=1 to (columns) do
begin
if chmt[i]=0 then PlayNote(i);
end;
songptr:=songptr+(4*columns);
if gotos>0 then songptr:=gotos;
if songptr>maxptr then songptr:=1;
end;

procedure InitFM;
begin
for i:=0 to $f5 do Reg(i,0);
reg($01,32);
end;

procedure StopFM;
begin
shutup(0);
shutup(1);
shutup(2);
shutup(3);
shutup(4);
shutup(5);
shutup(6);
shutup(7);
shutup(8);
end;

function DetectFM:boolean;
var res:boolean;
    x1,x2:byte;
begin
res:=false;
Reg(4,$60);
delay(10);
Reg(4,$80);
delay(10);
x1:=port[$388];
Reg(2,$FF);
delay(10);
Reg(4,$21);
delay(10);
x2:=port[$388];
Reg(4,$60);
delay(10);
Reg(4,$80);
delay(10);
if ((x1 and $e0)=$00) and ((x2 and $e0)=$c0) then res:=true;
if res=true then
begin
for k:=0 to 245 do Reg(k,0);
Reg(1,32);
end;
DetectFM:=res;
end;

procedure InitMux;
begin
getmem(sgvir,64001);
sgadr:=seg(sgvir^);
vibflag:=0;
tremflag:=0;
reg($bd,0);
for i:=1 to 9 do insnames[i]:='<EMPTY>   ';
for i:=1 to 15 do    bass_drum[i]:=   bass_drum_def[i];
for i:=1 to 15 do       snared[i]:=      snared_def[i];
for i:=1 to 15 do      rev_cym[i]:=     rev_cym_def[i];
for i:=1 to 15 do    crash_cym[i]:=   crash_cym_def[i];
for i:=1 to 15 do   hihat_open[i]:=  hihat_open_def[i];
for i:=1 to 15 do hihat_closed[i]:=hihat_closed_def[i];
insnames[10]:='BASS DRUM ';
insnames[11]:='SNARE     ';
insnames[12]:='OPEN HAT  ';
insnames[13]:='CLOSED HAT';
insnames[14]:='CRASH CYM.';
insnames[15]:='REV. CYM. ';
crspeed:=3;
songtitle:='UNTITLED';
for i:=1 to 6 do chmt[i]:=0;
for i:=1 to 6 do chon[i]:=0;
lbrow:=0;
crtimes:=0;
maxptr:=1+(24*(maxframes-1));
for i:=0 to (maxptr+24) do
begin
mem[sgadr:i]:=ord(' ');
end;
end;

procedure DeInitMux;
begin
FreeMem(sgvir,64001);
end;

begin
end.

{DONT FORGET TO FREEMEM()}


