{$A+ $B- $D- $E+ $F- $G+ $I+ $L- $N+ $O- $P+ $Q- $R- $S- $T- $V+ $X+ $Y-}
{$M 65520,0,400000}
program Astrozap;
uses Crt,Dos,Video,Filez,General,Strings,Keyboard,Logic,xvga,inter_sb,sb_unit,jury_rig,adlibu,clok;
const
      suki=16;
      sake=128;
      startlevel:integer=15;
      lspa:array[1..15,1..6] of byte=(
      (1,0,0,0,0,0),
      (1,2,0,0,0,0),
      (2,2,2,0,0,0),
      (0,2,1,2,0,0),
      (0,1,2,1,0,0),
      (0,1,0,1,2,0),
      (0,1,0,2,1,2),
      (0,1,0,0,2,1),
      (2,1,0,0,2,1),
      (1,1,0,0,2,1),
      (1,1,2,0,2,1),
      (1,1,1,2,2,1),
      (1,1,1,1,2,1),
      (1,1,1,1,1,2),
      (1,1,1,1,1,1));

var
    mnbf:pointer; mnsz:word; mnrt:word;
    s1bf:pointer; s1sz:word; s1rt:word;
    s2bf:pointer; s2sz:word; s2rt:word;
    msync:integer;
    s3bf:pointer; s3sz:word; s3rt:word;
    s4bf:pointer; s4sz:word; s4rt:word;
    s5bf:pointer; s5sz:word; s5rt:word;
    s6bf:pointer; s6sz:word; s6rt:word;
    tanim:integer;
    nodet:byte;
    level:integer;
    lives:integer;
    diff:integer;
    by:byte;
    tanimh:integer;
    x:integer;
    aliens:integer;
    paws,dely:integer;
    score,hi:longint;
    sounds,sbload:integer;
    turbo:integer;
    bcount:integer;
    zek:integer;
    angle:byte;
    bitz:array[1..30,1..5] of integer;
    weap:array[1..30,1..6] of integer;
    node:array[1..40,1..2] of integer;
    star:array[1..40,1..4] of integer;
    enem:array[1..30,1..10] of integer;
    boom:array[1..30,1..5] of integer;
    tm1,tm2,tm3,tm4,tm5,tm6,tm7:word;
    dzaps:integer;
    tzaps:integer;
    czaps:integer;
    sats:integer;
    nodes:integer;
    zaptm:integer;
    cycle:longint;
    alive:integer;
    endl:integer;
    shi:integer;
    fskip:integer;
    killz,scapez:integer;
    cheatpos:integer;
    adl_have:integer;
    xxx:integer;
    muzak:integer;
    ps:longint;
    xtral:integer;
    wai1:word;
    lkh:word;
procedure calcstars;forward;
procedure uninitialise;forward;
procedure savehiscore;forward;
procedure scoreboard;forward;
procedure piece(px,py,pt:integer);forward;
procedure pieced(px,py,pt:integer);forward;
procedure pieceu(px,py,pt:integer);forward;
procedure blast(bx,by,cl:integer);forward;
procedure DrawStars;forward;
procedure Controls;forward;
procedure Putstr(wx,wy:integer;what:string;where:word);forward;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Playmux;
var fft:integer;
begin
fft:=0;
if synctype=2 then fft:=xxx;
if tix>(5+fft) then
begin
xxx:=1-xxx;
if muzak=1 then if adl_have=1 then readframe;
tix:=0;
end;
end;

Procedure Offscreen;
begin
for i:=0 to 319 do
begin
for j:=0 to 199 do
begin
if j mod 2=0 then pixel(i,j,0,vaddr);
if j mod 2=1 then pixel(319-i,j,0,vaddr);
end;
if i mod 10=0 then waitretrace;
if i mod 10=0 then flip(vaddr,vga);
if i mod 10=0 then playmux;
end;
flip(vaddr,vga);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Onscreen;
begin
cls(vaddr,0);
for i:=0 to 319 do
begin
for j:=0 to 199 do
begin
if j mod 2=0 then pixel(i,j,point(i,j,vaddr2),vaddr);
if j mod 2=1 then pixel(319-i,j,point(319-i,j,vaddr2),vaddr);
end;
if i mod 10=0 then waitretrace;
if i mod 10=0 then flip(vaddr,vga);
if i mod 10=0 then playmux;
end;
flip(vaddr,vga);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure StartSB;
var offs:integer;
begin
sbl_have:=1;
if Getvars(sbl_base,sbl_irq,sbl_dma)=false then sbl_have:=0;
if sbl_have=1 then if SbInit(sbl_base,sbl_irq,sbl_dma)=false then sbl_have:=0;
buffersize:=50100;
loadvoc('astrozap.sfx',mnbf,mnsz,mnrt);
offs:=ofs(mnbf^)+7780;
s1bf:=ptr(seg(mnbf^),offs);
s1sz:=7825;
s1rt:=mnrt;
offs:=offs+s1sz;
s2bf:=ptr(seg(mnbf^),offs);
s2sz:=5622;
s2rt:=mnrt;
offs:=offs+s2sz;
s3bf:=ptr(seg(mnbf^),offs);
s3sz:=6687;
s3rt:=mnrt;
offs:=offs+s3sz;
s4bf:=ptr(seg(mnbf^),offs);
s4sz:=11075;
s4rt:=mnrt;
offs:=offs+s4sz;
s5bf:=ptr(seg(mnbf^),offs);
s5sz:=4393;
s5rt:=mnrt;
offs:=offs+s5sz;
s6bf:=ptr(seg(mnbf^),offs);
s6sz:=6644;
s6rt:=mnrt;
offs:=offs+s6sz;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure StopSB;
begin
SB_StopDMA;
SB_DSpReset(sbl_base);
sb_freedmabuffer(mnbf,45000 div $10);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sfx1;
begin
if (sounds=1) and (sbl_have=1) then sb_playdma(mnbf,mnrt,7780);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sfx2;
begin
if (sounds=1) and (sbl_have=1) then sb_playdma(s1bf,s1rt,s1sz);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sfx3;
begin
if (sounds=1) and (sbl_have=1) then sb_playdma(s2bf,s2rt,s2sz);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sfx4;
begin
if (sounds=1) and (sbl_have=1) then sb_playdma(s3bf,s3rt,s3sz);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sfx5;
begin
if (sounds=1) and (sbl_have=1) then sb_playdma(s4bf,s4rt,s4sz);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sfx6;
begin
if (sounds=1) and (sbl_have=1) then sb_playdma(s5bf,s5rt,s5sz);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sfx7;
begin
if (sounds=1) and (sbl_have=1) then sb_playdma(s6bf,s6rt,s6sz);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure CheckPaws;
begin
if dely>0 then dec(dely);
if (key_f3=true) and (dely=0) then
begin
for i:=192 to 199 do xhline(i,0,319,0,vga);
Putstr(136,192,'PAUSED',vga);
dely:=30;
repeat
if dely>0 then dec(dely);
delay(1);
waitretrace;
until ((key_f3=true) and (dely=0));
dely:=10;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure CheckSounds;
begin
if sbload>0 then dec(sbload);
if (key_f5=true) and (sbload=0) then
begin
muzak:=1-muzak;
if muzak=0 then stopfm;
if muzak=1 then songptr:=1;
sbload:=10;
end;
if (key_f4=true) and (sbload=0) then
begin
sounds:=1-sounds;
sbload:=10;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure loadhiscore;
var f:file of byte;
    s:longint;
begin
if not exist('astrozap.hsc') then
begin
hi:=0;
savehiscore;
end;
assign(f,'astrozap.hsc');
reset(f);
s:=filesize(f);
close(f);
if s<7 then
begin
hi:=0;
savehiscore;
end;
assign(f,'astrozap.hsc');
reset(f);
hi:=0;
read(f,by);
hi:=hi+1000000*by;
read(f,by);
hi:=hi+100000*by;
read(f,by);
hi:=hi+10000*by;
read(f,by);
hi:=hi+1000*by;
read(f,by);
hi:=hi+100*by;
read(f,by);
hi:=hi+10*by;
read(f,by);
hi:=hi+by;
close(f);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure LoopCounters;
begin
if score>(ps*100000) then
begin
inc(ps);
inc(sats);
if sats>9 then sats:=9;
xtral:=200;
end;
if xtral>0 then dec(xtral);
if shi>0 then dec(shi);
if zaptm>0 then dec(zaptm);
if endl>0 then inc(endl);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure putdigit(dx,dy:integer;dig:byte);
begin
if dig=0 then putimg8(dx,dy,let_0,vaddr);
if dig=1 then putimg8(dx,dy,let_1,vaddr);
if dig=2 then putimg8(dx,dy,let_2,vaddr);
if dig=3 then putimg8(dx,dy,let_3,vaddr);
if dig=4 then putimg8(dx,dy,let_4,vaddr);
if dig=5 then putimg8(dx,dy,let_5,vaddr);
if dig=6 then putimg8(dx,dy,let_6,vaddr);
if dig=7 then putimg8(dx,dy,let_7,vaddr);
if dig=8 then putimg8(dx,dy,let_8,vaddr);
if dig=9 then putimg8(dx,dy,let_9,vaddr);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function digit(nr:longint;pos:integer):byte;
var divi:longint;
    mi:integer;
label cuku;
begin
if pos=1 then
begin
digit:=nr mod 10;
goto cuku;
end;
divi:=10;
for mi:=1 to pos-2 do divi:=divi*10;
digit:=(nr div divi) mod 10;
cuku:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure scoreboard;
begin
if score>9999999 then score:=9999999;
putimg8(0,0,let_1,vaddr);
putimg8(8,0,let_u,vaddr);
putimg8(16,0,let_p,vaddr);
putimg8(24,0,let_dp,vaddr);
putdigit(32,0,digit(score,7));
putdigit(40,0,digit(score,6));
putdigit(48,0,digit(score,5));
putdigit(56,0,digit(score,4));
putdigit(64,0,digit(score,3));
putdigit(72,0,digit(score,2));
putdigit(80,0,digit(score,1));

putimg8(104,0,let_s,vaddr);
putimg8(112,0,let_h,vaddr);
putimg8(120,0,let_i,vaddr);
putimg8(128,0,let_e,vaddr);
putimg8(136,0,let_l,vaddr);
putimg8(144,0,let_d,vaddr);
putimg8(152,0,let_dp,vaddr);

putimg8(232,0,let_h,vaddr);
putimg8(240,0,let_i,vaddr);
putimg8(248,0,let_dp,vaddr);
putdigit(256,0,digit(hi,8));
putdigit(264,0,digit(hi,7));
putdigit(272,0,digit(hi,6));
putdigit(280,0,digit(hi,5));
putdigit(288,0,digit(hi,4));
putdigit(296,0,digit(hi,3));
putdigit(304,0,digit(hi,2));
putdigit(312,0,digit(hi,1));
for i:=1 to lives do
begin
if i=1 then putimg8s(152+i*8,0,let_sq,vaddr,224);
if i=2 then putimg8s(152+i*8,0,let_sq,vaddr,128);
if i=3 then putimg8s(152+i*8,0,let_sq,vaddr,128);
if i>3 then putimg8s(152+i*8,0,let_sq,vaddr,32);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Initialise;
begin
KeysOn;
songptr:=1;
Randomize;
TextMode(13);
Clrscr;
BlastTextCursor;
if nodet=0 then
begin
StartSB;
if detectFM=true then
begin
adl_have:=1;
initFM;
end;
end;
if nodet=1 then
begin
sbl_have:=0;
adl_have:=0;
end;
Say('Loading...',14);
if tampered then FuckUp('Program corrupted !!');
LoadSong('astrozap.mus');
LoadSpr;
InitGr;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure BreakPrg;
begin
if adl_have=1 then StopFM;
if sbl_have=1 then StopSB;
SprOff;
VrtOff;
KeysOff;
SyncOff;
end;

Procedure Uninitialise;
begin
if adl_have=1 then StopFM;
delay(500);
if sbl_have=1 then StopSB;
delay(500);
VgaOff;
BlastTextCursor;
SprOff;
VrtOff;
VgaOn;
VgaOff;
Textcolor(7);
clrscr;
KeysOff;
SyncOff;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure savehiscore;
var f:file of byte;
    s:longint;
begin
assign(f,'astrozap.hsc');
rewrite(f);
by:=digit(hi,7);
write(f,by);
by:=digit(hi,6);
write(f,by);
by:=digit(hi,5);
write(f,by);
by:=digit(hi,4);
write(f,by);
by:=digit(hi,3);
write(f,by);
by:=digit(hi,2);
write(f,by);
by:=digit(hi,1);
write(f,by);
close(f);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Damage;
begin
if (alive=1) then
begin
if lives=0 then
begin
alive:=0;
if endl=0 then endl:=1;
end;
if shi=0 then
begin
if lives>0 then dec(lives);
shi:=60;
end;
SFX5;
if alive=0 then
begin
pieced(x+4,12,3);
pieced(x+4,12,3);
pieced(x+4,12,5);
pieced(x+4,12,4);
pieced(x+4,12,4);
pieced(x+4,12,4);
pieced(x+4,12,4);
pieced(x+4,12,4);
pieced(x+4,12,4);
end;
pieced(x+4,12,4);
pieced(x+4,12,4);
pieced(x+4,12,4);
if alive=0 then
begin
pieceu(308-x,180,3);
pieceu(308-x,180,3);
pieceu(308-x,180,5);
pieceu(308-x,180,4);
pieceu(308-x,180,4);
pieceu(308-x,180,4);
pieceu(308-x,180,4);
pieceu(308-x,180,4);
pieceu(308-x,180,4);
pieceu(308-x,180,4);
pieceu(308-x,180,4);
end;
pieceu(308-x,180,4);
pieceu(308-x,180,4);
if alive=0 then
begin
blast(x,8,1);
blast(x-2,6,1);
blast(304-x,176,1);
blast(308-x,178,1);
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure blast(bx,by,cl:integer);
label okay;
begin
for k:=1 to 20 do
begin
if boom[k,1]=0 then
begin
boom[k,1]:=1;
boom[k,2]:=bx;
boom[k,3]:=by;
boom[k,4]:=8;
boom[k,5]:=cl;
SFX2;
goto okay;
end;
end;
okay:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure piece(px,py,pt:integer);
label okay,trya;
begin
for k:=1 to 30 do
begin
if bitz[k,1]=0 then
begin
bitz[k,1]:=pt;
bitz[k,2]:=px;
bitz[k,3]:=py;
trya:
bitz[k,4]:=-5+random(11);
bitz[k,5]:=-5+random(11);
if ((abs(bitz[k,4])+abs(bitz[k,5]))<3) then goto trya;
goto okay;
end;
end;
okay:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure pieced(px,py,pt:integer);
label okay,trya;
begin
for k:=1 to 30 do
begin
if bitz[k,1]=0 then
begin
bitz[k,1]:=pt;
bitz[k,2]:=px;
bitz[k,3]:=py;
trya:
bitz[k,4]:=-5+random(11);
bitz[k,5]:=random(6);
if ((abs(bitz[k,4])+abs(bitz[k,5]))<4) then goto trya;
goto okay;
end;
end;
okay:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure pieceu(px,py,pt:integer);
label okay,trya;
begin
for k:=1 to 30 do
begin
if bitz[k,1]=0 then
begin
bitz[k,1]:=pt;
bitz[k,2]:=px;
bitz[k,3]:=py;
trya:
bitz[k,4]:=-5+random(11);
bitz[k,5]:=0-random(6);
if ((abs(bitz[k,4])+abs(bitz[k,5]))<3) then goto trya;
goto okay;
end;
end;
okay:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure nweap(px,py,pt,dr:integer);
label okay,trya;
begin
for k:=1 to 20 do
begin
if weap[k,1]=0 then
begin
if pt=1 then SFX4;
if pt=2 then SFX1;
if pt=3 then SFX6;
if pt=4 then SFX3;
weap[k,1]:=pt;
weap[k,2]:=px;
weap[k,3]:=py;
weap[k,6]:=150;
if dr=0 then
begin
weap[k,4]:=0;
weap[k,5]:=0;
end;
if dr=1 then
begin
weap[k,4]:=0;
weap[k,5]:=-4;
end;
if dr=2 then
begin
weap[k,4]:=0;
weap[k,5]:=4;
end;
if dr=3 then
begin
weap[k,4]:=4;
weap[k,5]:=-4;
end;
if dr=4 then
begin
weap[k,4]:=4;
weap[k,5]:=4;
end;
if dr=5 then
begin
weap[k,4]:=-4;
weap[k,5]:=-4;
end;
if dr=6 then
begin
weap[k,4]:=-4;
weap[k,5]:=4;
end;
if dr=7 then
begin
trya:
weap[k,4]:=-5+random(11);
weap[k,5]:=-5+random(11);
if ((abs(weap[k,4])+abs(weap[k,5]))<6) then goto trya;
end;
if dr=8 then
begin
weap[k,4]:=-4;
weap[k,5]:=0;
end;
if dr=9 then
begin
weap[k,4]:=4;
weap[k,5]:=0;
end;
if dr=13 then
begin
weap[k,4]:=3;
weap[k,5]:=-3;
end;
if dr=14 then
begin
weap[k,4]:=3;
weap[k,5]:=3;
end;
if dr=15 then
begin
weap[k,4]:=-3;
weap[k,5]:=-3;
end;
if dr=16 then
begin
weap[k,4]:=-3;
weap[k,5]:=3;
end;
goto okay;
end;
end;
okay:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Getnodes(a,b,c,d:integer);
  function sgn(a:real):integer;
  begin
       if a>0 then sgn:=+1;
       if a<0 then sgn:=-1;
       if a=0 then sgn:=0;
  end;
var i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;
    count:integer;
begin
     nodes:=0;
     count:=1;
     u:= c - a;
     v:= d - b;
     d1x:= SGN(u);
     d1y:= SGN(v);
     d2x:= SGN(u);
     d2y:= 0;
     m:= ABS(u);
     n := ABS(v);
     IF NOT (M>N) then
     BEGIN
          d2x := 0 ;
          d2y := SGN(v);
          m := ABS(v);
          n := ABS(u);
     END;
     s := m shr 1;
     FOR i := 0 TO m DO
     BEGIN
          dec(count);
          if count=0 then
          begin
          count:=10;
          inc(nodes);
          node[nodes,1]:=a;
          node[nodes,2]:=b;
          end;

          s := s + n;
          IF not (s<m) THEN
          BEGIN
               s := s - m;
               a:= a + d1x;
               b := b + d1y;
          END
          ELSE
          BEGIN
               a := a + d2x;
               b := b + d2y;
          END;
     end;
          inc(nodes);
          node[nodes,1]:=a;
          node[nodes,2]:=b;
if zaptm=20 then
begin
if czaps=2 then inc(dzaps);
if czaps>2 then inc(tzaps);
czaps:=0;
end;
if zaptm>20 then
begin
for j:=1 to nodes do
begin
for i:=1 to 20 do
begin
if (node[j,1]+1>enem[i,2]) and
   (node[j,2]+1>enem[i,3]) and
   (node[j,1]<enem[i,2]+16) and
   (node[j,2]<enem[i,3]+16) then
begin
if (enem[i,1]=1) or (enem[i,1]=4) then
begin
if aliens>0 then dec(aliens);
inc(killz);
inc(czaps);
enem[i,1]:=0;
blast(enem[i,2],enem[i,3],1);
piece(enem[i,2]+4,enem[i,3]+4,1);
piece(enem[i,2]+4,enem[i,3]+4,1);
piece(enem[i,2]+4,enem[i,3]+4,2);
piece(enem[i,2]+4,enem[i,3]+4,2);
piece(enem[i,2]+4,enem[i,3]+4,2);
piece(enem[i,2]+4,enem[i,3]+4,2);
piece(enem[i,2]+4,enem[i,3]+4,2);
piece(enem[i,2]+4,enem[i,3]+4,2);
score:=score+100;
end;
if (enem[i,1]=2) or (enem[i,1]=3) then
begin
inc(killz);
inc(czaps);
score:=score+250;
if aliens>0 then dec(aliens);
enem[i,1]:=0;
blast(enem[i,2],enem[i,3],1);
piece(enem[i,2]+4,enem[i,3]+4,1);
piece(enem[i,2]+4,enem[i,3]+4,6);
piece(enem[i,2]+4,enem[i,3]+4,6);
piece(enem[i,2]+4,enem[i,3]+4,6);
piece(enem[i,2]+4,enem[i,3]+4,6);
piece(enem[i,2]+4,enem[i,3]+4,6);
piece(enem[i,2]+4,enem[i,3]+4,6);
end;
if (enem[i,1]=5) then
begin
if aliens>0 then dec(aliens);
inc(killz);
inc(czaps);
enem[i,1]:=0;
blast(enem[i,2],enem[i,3],1);
piece(enem[i,2]+4,enem[i,3]+4,1);
piece(enem[i,2]+4,enem[i,3]+4,7);
piece(enem[i,2]+4,enem[i,3]+4,7);
piece(enem[i,2]+4,enem[i,3]+4,7);
piece(enem[i,2]+4,enem[i,3]+4,7);
piece(enem[i,2]+4,enem[i,3]+4,7);
piece(enem[i,2]+4,enem[i,3]+4,7);
piece(enem[i,2]+4,enem[i,3]+4,7);
piece(enem[i,2]+4,enem[i,3]+4,7);
piece(enem[i,2]+4,enem[i,3]+4,7);
piece(enem[i,2]+4,enem[i,3]+4,7);
piece(enem[i,2]+4,enem[i,3]+4,8);
piece(enem[i,2]+4,enem[i,3]+4,8);
piece(enem[i,2]+4,enem[i,3]+4,8);
piece(enem[i,2]+4,enem[i,3]+4,8);
score:=score+500;
end;
if (enem[i,1]=6) then
begin
if aliens>0 then dec(aliens);
inc(killz);
inc(czaps);
enem[i,1]:=0;
blast(enem[i,2],enem[i,3],1);
piece(enem[i,2]+4,enem[i,3]+4,1);
piece(enem[i,2]+4,enem[i,3]+4,9);
piece(enem[i,2]+4,enem[i,3]+4,9);
piece(enem[i,2]+4,enem[i,3]+4,9);
piece(enem[i,2]+4,enem[i,3]+4,9);
piece(enem[i,2]+4,enem[i,3]+4,9);
piece(enem[i,2]+4,enem[i,3]+4,9);
piece(enem[i,2]+4,enem[i,3]+4,9);
score:=score+500;
end;
if (enem[i,1]=7) then
begin
if aliens>0 then dec(aliens);
inc(killz);
inc(czaps);
enem[i,1]:=0;
blast(enem[i,2],enem[i,3],1);
piece(enem[i,2]+4,enem[i,3]+4,10);
piece(enem[i,2]+4,enem[i,3]+4,10);
piece(enem[i,2]+4,enem[i,3]+4,10);
piece(enem[i,2]+4,enem[i,3]+4,10);
piece(enem[i,2]+4,enem[i,3]+4,10);
piece(enem[i,2]+4,enem[i,3]+4,10);
piece(enem[i,2]+4,enem[i,3]+4,10);
piece(enem[i,2]+4,enem[i,3]+4,10);
piece(enem[i,2]+4,enem[i,3]+4,10);
piece(enem[i,2]+4,enem[i,3]+4,10);
piece(enem[i,2]+4,enem[i,3]+4,11);
piece(enem[i,2]+4,enem[i,3]+4,11);
piece(enem[i,2]+4,enem[i,3]+4,11);
piece(enem[i,2]+4,enem[i,3]+4,11);
score:=score+1000;
end;
end;
end;
end;
end;
for i:=2 to nodes-2 do
begin
node[i,1]:=node[i,1]-5+random(10);
node[i,2]:=node[i,2]-5+random(10);
end;
END;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure drawnodes;
begin
for i:=1 to nodes-1 do
begin
xline(node[i,1]+0,node[i,2]+1,node[i+1,1]+0,node[i+1,2]+1,200,vaddr);
xline(node[i,1]+0,node[i,2]-1,node[i+1,1]+0,node[i+1,2]-1,200,vaddr);
xline(node[i,1]+1,node[i,2]+0,node[i+1,1]+1,node[i+1,2]+0,200,vaddr);
xline(node[i,1]-1,node[i,2]+0,node[i+1,1]-1,node[i+1,2]+0,200,vaddr);
xline(node[i,1]+0,node[i,2]+0,node[i+1,1]+0,node[i+1,2]+0,192,vaddr);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure delnodes;
begin
for i:=1 to nodes-1 do
begin
xline(node[i,1]+0,node[i,2]+1,node[i+1,1]+0,node[i+1,2]+1,0,vaddr);
xline(node[i,1]+0,node[i,2]-1,node[i+1,1]+0,node[i+1,2]-1,0,vaddr);
xline(node[i,1]+1,node[i,2]+0,node[i+1,1]+1,node[i+1,2]+0,0,vaddr);
xline(node[i,1]-1,node[i,2]+0,node[i+1,1]-1,node[i+1,2]+0,0,vaddr);
xline(node[i,1]+0,node[i,2]+0,node[i+1,1]+0,node[i+1,2]+0,0,vaddr);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure initstars;
begin
for i:=1 to 40 do
begin
star[i,1]:=random(316)+2;
star[i,2]:=random(196)+2;
star[i,3]:=random(3)+1;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure calcbooms;
begin
for i:=1 to 30 do
begin
if boom[i,1]=1 then
begin
if anim mod 4=0 then dec(boom[i,4]);
if (boom[i,5]=1) and (random(10)=0) then blast(boom[i,2]-5+random(11),boom[i,3]-5+random(11),0);
if (boom[i,5]=0) and (boom[i,4]=0) then boom[i,1]:=0;
if (boom[i,5]=1) and (boom[i,4]=0) then boom[i,4]:=255;
if (boom[i,5]=1) and (boom[i,4]=254) then boom[i,1]:=0;
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure drawbooms;
begin
for i:=1 to 30 do
begin
if boom[i,1]=1 then
begin
if boom[i,4]=8 then putimg16(boom[i,2],boom[i,3],boom1,vaddr);
if boom[i,4]=7 then putimg16(boom[i,2],boom[i,3],boom2,vaddr);
if boom[i,4]=6 then putimg16(boom[i,2],boom[i,3],boom3,vaddr);
if boom[i,4]=5 then putimg16(boom[i,2],boom[i,3],boom4,vaddr);
if boom[i,4]=4 then putimg16(boom[i,2],boom[i,3],boom5,vaddr);
if boom[i,4]=3 then putimg16(boom[i,2],boom[i,3],boom6,vaddr);
if boom[i,4]=2 then putimg16(boom[i,2],boom[i,3],boom7,vaddr);
if boom[i,4]=1 then putimg16(boom[i,2],boom[i,3],boom8,vaddr);
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure calcbitz;
begin
for i:=1 to 30 do
begin
if bitz[i,1]>0 then
begin
if bitz[i,4]=-5 then bitz[i,2]:=bitz[i,2]-(2+(anim mod 2));
if bitz[i,4]=-4 then bitz[i,2]:=bitz[i,2]-2;
if bitz[i,4]=-3 then bitz[i,2]:=bitz[i,2]-(1+(anim mod 2));
if bitz[i,4]=-2 then bitz[i,2]:=bitz[i,2]-(1);
if bitz[i,4]=-1 then bitz[i,2]:=bitz[i,2]-(0+(anim mod 2));
if bitz[i,4]=+0 then bitz[i,2]:=bitz[i,2]+0;
if bitz[i,4]=+1 then bitz[i,2]:=bitz[i,2]+(0+(anim mod 2));
if bitz[i,4]=+2 then bitz[i,2]:=bitz[i,2]+(1);
if bitz[i,4]=+3 then bitz[i,2]:=bitz[i,2]+(1+(anim mod 2));
if bitz[i,4]=+4 then bitz[i,2]:=bitz[i,2]+2;
if bitz[i,4]=+5 then bitz[i,2]:=bitz[i,2]+(2+(anim mod 2));
if bitz[i,5]=-5 then bitz[i,3]:=bitz[i,3]-(2+(anim mod 2));
if bitz[i,5]=-4 then bitz[i,3]:=bitz[i,3]-2;
if bitz[i,5]=-3 then bitz[i,3]:=bitz[i,3]-(1+(anim mod 2));
if bitz[i,5]=-2 then bitz[i,3]:=bitz[i,3]-(1);
if bitz[i,5]=-1 then bitz[i,3]:=bitz[i,3]-(0+(anim mod 2));
if bitz[i,5]=+0 then bitz[i,3]:=bitz[i,3]+0;
if bitz[i,5]=+1 then bitz[i,3]:=bitz[i,3]+(0+(anim mod 2));
if bitz[i,5]=+2 then bitz[i,3]:=bitz[i,3]+(1);
if bitz[i,5]=+3 then bitz[i,3]:=bitz[i,3]+(1+(anim mod 2));
if bitz[i,5]=+4 then bitz[i,3]:=bitz[i,3]+2;
if bitz[i,5]=+5 then bitz[i,3]:=bitz[i,3]+(2+(anim mod 2));
if (bitz[i,2]<-4) or (bitz[i,2]>316) or (bitz[i,3]<0) or (bitz[i,3]>192) then
begin
bitz[i,1]:=0;
end;
end;
end;
end;

procedure drawbitz;
begin
for i:=1 to 30 do
begin
animate;
animate;
if bitz[i,1]=1 then
begin
if (animh div 4)=0 then putimg8(bitz[i,2],bitz[i,3],deb11,vaddr);
if (animh div 4)=1 then putimg8(bitz[i,2],bitz[i,3],deb12,vaddr);
if (animh div 4)=2 then putimg8(bitz[i,2],bitz[i,3],deb13,vaddr);
if (animh div 4)=3 then putimg8(bitz[i,2],bitz[i,3],deb14,vaddr);
end;
if bitz[i,1]=2 then
begin
if (animh div 4)=0 then putimg8(bitz[i,2],bitz[i,3],deb21,vaddr);
if (animh div 4)=1 then putimg8(bitz[i,2],bitz[i,3],deb22,vaddr);
if (animh div 4)=2 then putimg8(bitz[i,2],bitz[i,3],deb23,vaddr);
if (animh div 4)=3 then putimg8(bitz[i,2],bitz[i,3],deb24,vaddr);
end;
if bitz[i,1]=3 then
begin
if (animh div 4)=0 then putimg8(bitz[i,2],bitz[i,3],deb31,vaddr);
if (animh div 4)=1 then putimg8(bitz[i,2],bitz[i,3],deb32,vaddr);
if (animh div 4)=2 then putimg8(bitz[i,2],bitz[i,3],deb33,vaddr);
if (animh div 4)=3 then putimg8(bitz[i,2],bitz[i,3],deb34,vaddr);
end;
if bitz[i,1]=4 then
begin
if (animh div 4)=0 then putimg8(bitz[i,2],bitz[i,3],deb41,vaddr);
if (animh div 4)=1 then putimg8(bitz[i,2],bitz[i,3],deb42,vaddr);
if (animh div 4)=2 then putimg8(bitz[i,2],bitz[i,3],deb43,vaddr);
if (animh div 4)=3 then putimg8(bitz[i,2],bitz[i,3],deb44,vaddr);
end;
if bitz[i,1]=5 then
begin
if (animh div 4)=0 then putimg8(bitz[i,2],bitz[i,3],dish1,vaddr);
if (animh div 4)=1 then putimg8(bitz[i,2],bitz[i,3],dish3,vaddr);
if (animh div 4)=2 then putimg8(bitz[i,2],bitz[i,3],dish6,vaddr);
if (animh div 4)=3 then putimg8(bitz[i,2],bitz[i,3],disha,vaddr);
end;
if bitz[i,1]=6 then
begin
if (animh div 4)=0 then putimg8(bitz[i,2],bitz[i,3],deb51,vaddr);
if (animh div 4)=1 then putimg8(bitz[i,2],bitz[i,3],deb52,vaddr);
if (animh div 4)=2 then putimg8(bitz[i,2],bitz[i,3],deb53,vaddr);
if (animh div 4)=3 then putimg8(bitz[i,2],bitz[i,3],deb54,vaddr);
end;
if bitz[i,1]=7 then
begin
if (animh div 4)=0 then putimg8a(bitz[i,2],bitz[i,3],deb41,vaddr,134);
if (animh div 4)=1 then putimg8a(bitz[i,2],bitz[i,3],deb42,vaddr,134);
if (animh div 4)=2 then putimg8a(bitz[i,2],bitz[i,3],deb43,vaddr,134);
if (animh div 4)=3 then putimg8a(bitz[i,2],bitz[i,3],deb44,vaddr,134);
end;
if bitz[i,1]=8 then
begin
if (animh div 4)=0 then putimg8(bitz[i,2],bitz[i,3],deb61,vaddr);
if (animh div 4)=1 then putimg8(bitz[i,2],bitz[i,3],deb62,vaddr);
if (animh div 4)=2 then putimg8(bitz[i,2],bitz[i,3],deb63,vaddr);
if (animh div 4)=3 then putimg8(bitz[i,2],bitz[i,3],deb64,vaddr);
end;
if bitz[i,1]=9 then
begin
if (animh div 4)=0 then putimg8(bitz[i,2],bitz[i,3],phl1,vaddr);
if (animh div 4)=1 then putimg8(bitz[i,2],bitz[i,3],phl2,vaddr);
if (animh div 4)=2 then putimg8(bitz[i,2],bitz[i,3],phl3,vaddr);
if (animh div 4)=3 then putimg8(bitz[i,2],bitz[i,3],phl2,vaddr);
end;
if bitz[i,1]=10 then
begin
if (animh div 4)=0 then putimg8a(bitz[i,2],bitz[i,3],deb41,vaddr,168);
if (animh div 4)=1 then putimg8a(bitz[i,2],bitz[i,3],deb42,vaddr,168);
if (animh div 4)=2 then putimg8a(bitz[i,2],bitz[i,3],deb43,vaddr,168);
if (animh div 4)=3 then putimg8a(bitz[i,2],bitz[i,3],deb44,vaddr,168);
end;
if bitz[i,1]=11 then
begin
if (animh div 4)=0 then putimg8(bitz[i,2],bitz[i,3],deb71,vaddr);
if (animh div 4)=1 then putimg8(bitz[i,2],bitz[i,3],deb72,vaddr);
if (animh div 4)=2 then putimg8(bitz[i,2],bitz[i,3],deb73,vaddr);
if (animh div 4)=3 then putimg8(bitz[i,2],bitz[i,3],deb74,vaddr);
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure calcweaps;
begin
for i:=1 to 30 do
begin
if weap[i,1]>0 then
begin
if weap[i,1]=4 then
begin
if weap[i,6]>0 then dec(weap[i,6]);
if weap[i,6]=0 then
begin
weap[i,1]:=0;
nweap(weap[i,2],weap[i,3],3,7);
nweap(weap[i,2],weap[i,3],3,7);
nweap(weap[i,2],weap[i,3],3,7);
nweap(weap[i,2],weap[i,3],3,7);
blast(weap[i,2]-4,weap[i,3]-4,1);
piece(weap[i,2],weap[i,3],7);
piece(weap[i,2],weap[i,3],7);
piece(weap[i,2],weap[i,3],7);
piece(weap[i,2],weap[i,3],7);
piece(weap[i,2],weap[i,3],7);
piece(weap[i,2],weap[i,3],7);
piece(weap[i,2],weap[i,3],7);
piece(weap[i,2],weap[i,3],7);
end;
end;
if (alive=1) then
if
(  ((weap[i,2]+8)>x) and
   ((weap[i,2])<x+16) and
   ((weap[i,3]+8)>8) and
   ((weap[i,3])<24)       ) or
(  ((weap[i,2]+8)>(304-x)) and
   ((weap[i,2])<(304-x)+16) and
   ((weap[i,3]+8)>184) and
   ((weap[i,3])<200)       ) then
begin
weap[i,1]:=0;
blast(weap[i,2]-4,weap[i,3]-4,0);
Damage;
end;
if weap[i,4]=-5 then weap[i,2]:=weap[i,2]-(2+(anim mod 2));
if weap[i,4]=-4 then weap[i,2]:=weap[i,2]-2;
if weap[i,4]=-3 then weap[i,2]:=weap[i,2]-(1+(anim mod 2));
if weap[i,4]=-2 then weap[i,2]:=weap[i,2]-(1);
if weap[i,4]=-1 then weap[i,2]:=weap[i,2]-(0+(anim mod 2));
if weap[i,4]=+0 then weap[i,2]:=weap[i,2]+0;
if weap[i,4]=+1 then weap[i,2]:=weap[i,2]+(0+(anim mod 2));
if weap[i,4]=+2 then weap[i,2]:=weap[i,2]+(1);
if weap[i,4]=+3 then weap[i,2]:=weap[i,2]+(1+(anim mod 2));
if weap[i,4]=+4 then weap[i,2]:=weap[i,2]+2;
if weap[i,4]=+5 then weap[i,2]:=weap[i,2]+(2+(anim mod 2));

if weap[i,5]=-5 then weap[i,3]:=weap[i,3]-(2+(anim mod 2));
if weap[i,5]=-4 then weap[i,3]:=weap[i,3]-2;
if weap[i,5]=-3 then weap[i,3]:=weap[i,3]-(1+(anim mod 2));
if weap[i,5]=-2 then weap[i,3]:=weap[i,3]-(1);
if weap[i,5]=-1 then weap[i,3]:=weap[i,3]-(0+(anim mod 2));
if weap[i,5]=+0 then weap[i,3]:=weap[i,3]+0;
if weap[i,5]=+1 then weap[i,3]:=weap[i,3]+(0+(anim mod 2));
if weap[i,5]=+2 then weap[i,3]:=weap[i,3]+(1);
if weap[i,5]=+3 then weap[i,3]:=weap[i,3]+(1+(anim mod 2));
if weap[i,5]=+4 then weap[i,3]:=weap[i,3]+2;
if weap[i,5]=+5 then weap[i,3]:=weap[i,3]+(2+(anim mod 2));
if (weap[i,2]<-4) or (weap[i,2]>316) or (weap[i,3]<0) or (weap[i,3]>192) then
begin
weap[i,1]:=0;
end;
end;
end;
end;

procedure drawweaps;
begin
for i:=1 to 30 do
begin
animate;
animate;
if weap[i,1]>0 then
begin
if weap[i,1]=1 then
begin
if (anim div 6)=0 then putimg8(weap[i,2],weap[i,3],pho1,vaddr);
if (anim div 6)=1 then putimg8(weap[i,2],weap[i,3],pho2,vaddr);
if (anim div 6)=2 then putimg8(weap[i,2],weap[i,3],pho3,vaddr);
if (anim div 6)=3 then putimg8(weap[i,2],weap[i,3],pho2,vaddr);
end;
if weap[i,1]=2 then
begin
if (anim div 3)=0 then putimg8(weap[i,2],weap[i,3],bla1,vaddr);
if (anim div 3)=1 then putimg8(weap[i,2],weap[i,3],bla2,vaddr);
if (anim div 3)=2 then putimg8(weap[i,2],weap[i,3],bla3,vaddr);
if (anim div 3)=3 then putimg8(weap[i,2],weap[i,3],bla2,vaddr);
if (anim div 3)=4 then putimg8(weap[i,2],weap[i,3],bla1,vaddr);
if (anim div 3)=5 then putimg8(weap[i,2],weap[i,3],bla2,vaddr);
if (anim div 3)=6 then putimg8(weap[i,2],weap[i,3],bla3,vaddr);
if (anim div 3)=7 then putimg8(weap[i,2],weap[i,3],bla2,vaddr);
end;
if weap[i,1]=3 then
begin
if (anim div 6)=0 then putimg8a(weap[i,2],weap[i,3],phl1,vaddr,0);
if (anim div 6)=1 then putimg8a(weap[i,2],weap[i,3],phl2,vaddr,251);
if (anim div 6)=2 then putimg8a(weap[i,2],weap[i,3],phl3,vaddr,253);
if (anim div 6)=3 then putimg8a(weap[i,2],weap[i,3],phl2,vaddr,251);
end;
if weap[i,1]=4 then
begin
putimg8(weap[i,2],weap[i,3],mine,vaddr);
end;
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure calcenems;
begin
{---------}
for i:=1 to 30 do
begin
animate;
if enem[i,1]>0 then inc(bcount);
if enem[i,1]=1 then
begin
if enem[i,2]<-8 then enem[i,1]:=0;
if enem[i,2]>312 then enem[i,1]:=0;
if (enem[i,5]=-1) and (anim mod 6=0) then dec(enem[i,3]);
if (enem[i,5]=1) and (anim mod 6=0) then inc(enem[i,3]);
if (enem[i,5]=-2) and (anim mod 4=0) then dec(enem[i,3]);
if (enem[i,5]=2) and (anim mod 4=0) then inc(enem[i,3]);
if (enem[i,5]=-3) and (anim mod 2=0) then dec(enem[i,3]);
if (enem[i,5]=3) and (anim mod 2=0) then inc(enem[i,3]);
if (enem[i,5]=-4) and (anim mod 1=0) then dec(enem[i,3]);
if (enem[i,5]=4) and (anim mod 1=0) then inc(enem[i,3]);
if (enem[i,5]=-5) and (anim mod 1=0) then dec(enem[i,3],2);
if (enem[i,5]=5) and (anim mod 1=0) then inc(enem[i,3],2);
if (enem[i,5]=-6) and (anim mod 1=0) then dec(enem[i,3],3);
if (enem[i,5]=6) and (anim mod 1=0) then inc(enem[i,3],3);

if (enem[i,6]=-1) and (anim mod 4=0) then dec(enem[i,2]);
if (enem[i,6]=1) and (anim mod 4=0) then inc(enem[i,2]);
if (enem[i,6]=-2) and (anim mod 2=0) then dec(enem[i,2]);
if (enem[i,6]=2) and (anim mod 2=0) then inc(enem[i,2]);
if (enem[i,6]=-3) and (anim mod 1=0) then dec(enem[i,2]);
if (enem[i,6]=3) and (anim mod 1=0) then inc(enem[i,2]);
if (enem[i,6]=-4) and (anim mod 1=0) then dec(enem[i,2],2);
if (enem[i,6]=4) and (anim mod 1=0) then inc(enem[i,2],2);
if (enem[i,6]=-5) and (anim mod 1=0) then dec(enem[i,2],3);
if (enem[i,6]=5) and (anim mod 1=0) then inc(enem[i,2],3);
if (enem[i,6]=-6) and (anim mod 1=0) then dec(enem[i,2],4);
if (enem[i,6]=6) and (anim mod 1=0) then inc(enem[i,2],4);
if enem[i,2]<-8 then
begin
enem[i,2]:=-8;
enem[i,1]:=0;
end;
if enem[i,2]>311 then
begin
enem[i,2]:=311;
enem[i,1]:=0;
end;
if anim=0 then
if random(2)=0 then
begin
enem[i,7]:=38+random(132);
end;
if anim mod 12=0 then
begin
if enem[i,3]>enem[i,7] then dec(enem[i,5]);
if enem[i,3]<enem[i,7] then inc(enem[i,5]);
end;
if enem[i,3]<30 then
begin
inc(enem[i,5]);
end;
if enem[i,3]>152 then
begin
dec(enem[i,5]);
end;
if enem[i,5]>6 then enem[i,5]:=6;
if enem[i,5]<-6 then enem[i,5]:=-6;
if enem[i,6]>6 then enem[i,6]:=6;
if enem[i,6]<-6 then enem[i,6]:=-6;
if (anim=0) and (enem[i,8]=1)
then
begin
enem[i,8]:=0;
end;
if (anim=15) and (enem[i,8]=1)
then
begin
nweap(enem[i,2]+4,enem[i,3]+2,1,1);
nweap(enem[i,2]+4,enem[i,3]+6,1,2);
end;
if (anim=0) and (enem[i,8]=0)
then
begin
if (random(12)=0) then
begin
enem[i,8]:=1;
end;
end;
if enem[i,8]=1 then enem[i,5]:=enem[i,5] div 2;
if enem[i,1]=0 then inc(scapez);
end;
{---------}
if enem[i,1]=2 then
begin
if (enem[i,6]=1) then dec(enem[i,2],3);
if (enem[i,6]=2) then dec(enem[i,2],3+(anim mod 2));
if enem[i,2]<-8 then
begin
enem[i,1]:=0;
enem[i,2]:=-8;
end;
if (anim=0) and (enem[i,8]=1)
then
begin
enem[i,8]:=0;
end;
if (anim=23) and (enem[i,8]=1) then
begin
nweap(enem[i,2],enem[i,3]+4,1,3);
nweap(enem[i,2],enem[i,3]+4,1,4);
end;
if (anim=0) and (enem[i,8]=0)
then
begin
if (random(3)=0) then enem[i,8]:=1;
end;
if enem[i,8]=1 then enem[i,5]:=enem[i,5] div 2;
if enem[i,1]=0 then inc(scapez);
end;
{---------}
if enem[i,1]=3 then
begin
if (enem[i,6]=1) then inc(enem[i,2],3);
if (enem[i,6]=2) then inc(enem[i,2],3+(anim mod 2));
if enem[i,2]>311 then
begin
enem[i,1]:=0;
enem[i,2]:=311;
end;
if (anim=0) and (enem[i,8]=1)
then
begin
enem[i,8]:=0;
end;
if (anim=23) and (enem[i,8]=1)
then
begin
nweap(enem[i,2]+8,enem[i,3]+4,1,5);
nweap(enem[i,2]+8,enem[i,3]+4,1,6);
end;
if (anim=0) and (enem[i,8]=0)
then
begin
if (random(3)=0) then enem[i,8]:=1;
end;
if enem[i,8]=1 then enem[i,5]:=enem[i,5] div 2;
if enem[i,1]=0 then inc(scapez);
end;
{---------}
if enem[i,1]=4 then
begin
if (enem[i,5]=-1) and (anim mod 6=0) then dec(enem[i,3]);
if (enem[i,5]=1) and (anim mod 6=0) then inc(enem[i,3]);
if (enem[i,5]=-2) and (anim mod 4=0) then dec(enem[i,3]);
if (enem[i,5]=2) and (anim mod 4=0) then inc(enem[i,3]);
if (enem[i,5]=-3) and (anim mod 2=0) then dec(enem[i,3]);
if (enem[i,5]=3) and (anim mod 2=0) then inc(enem[i,3]);
if (enem[i,5]=-4) and (anim mod 1=0) then dec(enem[i,3]);
if (enem[i,5]=4) and (anim mod 1=0) then inc(enem[i,3]);
if (enem[i,5]=-5) and (anim mod 1=0) then dec(enem[i,3],2);
if (enem[i,5]=5) and (anim mod 1=0) then inc(enem[i,3],2);
if (enem[i,5]=-6) and (anim mod 1=0) then dec(enem[i,3],3);
if (enem[i,5]=6) and (anim mod 1=0) then inc(enem[i,3],3);

if (enem[i,6]=-1) and (anim mod 4=0) then dec(enem[i,2]);
if (enem[i,6]=1) and (anim mod 4=0) then inc(enem[i,2]);
if (enem[i,6]=-2) and (anim mod 2=0) then dec(enem[i,2]);
if (enem[i,6]=2) and (anim mod 2=0) then inc(enem[i,2]);
if (enem[i,6]=-3) and (anim mod 1=0) then dec(enem[i,2]);
if (enem[i,6]=3) and (anim mod 1=0) then inc(enem[i,2]);
if (enem[i,6]=-4) and (anim mod 1=0) then dec(enem[i,2],2);
if (enem[i,6]=4) and (anim mod 1=0) then inc(enem[i,2],2);
if (enem[i,6]=-5) and (anim mod 1=0) then dec(enem[i,2],3);
if (enem[i,6]=5) and (anim mod 1=0) then inc(enem[i,2],3);
if (enem[i,6]=-6) and (anim mod 1=0) then dec(enem[i,2],4);
if (enem[i,6]=6) and (anim mod 1=0) then inc(enem[i,2],4);
if enem[i,2]<-8 then
begin
enem[i,2]:=-8;
enem[i,1]:=0;
end;
if enem[i,2]>311 then
begin
enem[i,2]:=311;
enem[i,1]:=0;
end;
if anim=0 then
if random(2)=0 then
begin
enem[i,7]:=38+random(132);
enem[i,9]:=32+random(264);
end;
if anim mod 8=0 then
begin
if enem[i,3]>enem[i,7] then dec(enem[i,5]);
if enem[i,3]<enem[i,7] then inc(enem[i,5]);
if enem[i,2]>enem[i,9] then dec(enem[i,6]);
if enem[i,2]<enem[i,9] then inc(enem[i,6]);
end;
if enem[i,3]<30 then
begin
inc(enem[i,5]);
end;
if enem[i,3]>152 then
begin
dec(enem[i,5]);
end;
if enem[i,5]>6 then enem[i,5]:=6;
if enem[i,5]<-6 then enem[i,5]:=-6;
if enem[i,6]>6 then enem[i,6]:=6;
if enem[i,6]<-6 then enem[i,6]:=-6;
if (anim=0) and (enem[i,8]=1)
then
begin
enem[i,8]:=0;
end;
if (anim=23) and (enem[i,8]=1)
then
begin
nweap(enem[i,2]+4,enem[i,3]+4,1,7);
end;
if (anim=0) and (enem[i,8]=0)
then
begin
if (random(5)=0) then enem[i,8]:=1;
end;
if enem[i,8]=1 then enem[i,5]:=enem[i,5] div 2;
if enem[i,1]=0 then inc(scapez);
end;
{---------}
if enem[i,1]=5 then
begin
if (enem[i,5]=-1) and (anim mod 6=0) then dec(enem[i,3]);
if (enem[i,5]=1) and (anim mod 6=0) then inc(enem[i,3]);
if (enem[i,5]=-2) and (anim mod 4=0) then dec(enem[i,3]);
if (enem[i,5]=2) and (anim mod 4=0) then inc(enem[i,3]);
if (enem[i,5]=-3) and (anim mod 2=0) then dec(enem[i,3]);
if (enem[i,5]=3) and (anim mod 2=0) then inc(enem[i,3]);
if (enem[i,5]=-4) and (anim mod 1=0) then dec(enem[i,3]);
if (enem[i,5]=4) and (anim mod 1=0) then inc(enem[i,3]);
if (enem[i,5]=-5) and (anim mod 1=0) then dec(enem[i,3],2);
if (enem[i,5]=5) and (anim mod 1=0) then inc(enem[i,3],2);
if (enem[i,5]=-6) and (anim mod 1=0) then dec(enem[i,3],3);
if (enem[i,5]=6) and (anim mod 1=0) then inc(enem[i,3],3);

if (enem[i,6]=-1) and (anim mod 4=0) then dec(enem[i,2]);
if (enem[i,6]=1) and (anim mod 4=0) then inc(enem[i,2]);
if (enem[i,6]=-2) and (anim mod 2=0) then dec(enem[i,2]);
if (enem[i,6]=2) and (anim mod 2=0) then inc(enem[i,2]);
if (enem[i,6]=-3) and (anim mod 1=0) then dec(enem[i,2]);
if (enem[i,6]=3) and (anim mod 1=0) then inc(enem[i,2]);
if (enem[i,6]=-4) and (anim mod 1=0) then dec(enem[i,2],2);
if (enem[i,6]=4) and (anim mod 1=0) then inc(enem[i,2],2);
if (enem[i,6]=-5) and (anim mod 1=0) then dec(enem[i,2],3);
if (enem[i,6]=5) and (anim mod 1=0) then inc(enem[i,2],3);
if (enem[i,6]=-6) and (anim mod 1=0) then dec(enem[i,2],4);
if (enem[i,6]=6) and (anim mod 1=0) then inc(enem[i,2],4);
if enem[i,2]<-8 then
begin
enem[i,2]:=-8;
enem[i,1]:=0;
end;
if enem[i,2]>311 then
begin
enem[i,2]:=311;
enem[i,1]:=0;
end;
if anim=0 then
if random(2)=0 then
begin
enem[i,7]:=38+random(132);
end;
if anim mod 2=0 then
begin
if i mod 2=0 then enem[i,9]:=x
               else enem[i,9]:=304-x;
end;
if anim mod 8=0 then
begin
if enem[i,3]>enem[i,7] then dec(enem[i,5]);
if enem[i,3]<enem[i,7] then inc(enem[i,5]);
if enem[i,2]>enem[i,9] then dec(enem[i,6]);
if enem[i,2]<enem[i,9] then inc(enem[i,6]);
end;
if enem[i,3]<24 then
begin
enem[i,3]:=24;
end;
if enem[i,3]>152 then
begin
enem[i,3]:=152;
end;
if enem[i,5]>6 then enem[i,5]:=6;
if enem[i,5]<-6 then enem[i,5]:=-6;
if enem[i,6]>6 then enem[i,6]:=6;
if enem[i,6]<-6 then enem[i,6]:=-6;
if (anim=0) and (enem[i,8]=1)
then
begin
enem[i,8]:=0;
end;
if (anim=15) and (enem[i,8]=1)
then
begin
nweap(enem[i,2]+4,enem[i,3]+4,2,13);
nweap(enem[i,2]+4,enem[i,3]+4,2,14);
nweap(enem[i,2]+4,enem[i,3]+4,2,15);
nweap(enem[i,2]+4,enem[i,3]+4,2,16);
end;
if (anim=0) and (enem[i,8]=0)
then
begin
if (random(16)=0) then enem[i,8]:=1;
end;
if enem[i,8]=1 then
begin
enem[i,5]:=enem[i,5] div 2;
enem[i,6]:=enem[i,6] div 2;
end;
if enem[i,1]=0 then inc(scapez);
end;
{---------}
if enem[i,1]=6 then
begin
if (enem[i,5]=-1) and (anim mod 6=0) then dec(enem[i,3]);
if (enem[i,5]=1) and (anim mod 6=0) then inc(enem[i,3]);
if (enem[i,5]=-2) and (anim mod 4=0) then dec(enem[i,3]);
if (enem[i,5]=2) and (anim mod 4=0) then inc(enem[i,3]);
if (enem[i,5]=-3) and (anim mod 2=0) then dec(enem[i,3]);
if (enem[i,5]=3) and (anim mod 2=0) then inc(enem[i,3]);
if (enem[i,5]=-4) and (anim mod 1=0) then dec(enem[i,3]);
if (enem[i,5]=4) and (anim mod 1=0) then inc(enem[i,3]);
if (enem[i,5]=-5) and (anim mod 1=0) then dec(enem[i,3],2);
if (enem[i,5]=5) and (anim mod 1=0) then inc(enem[i,3],2);
if (enem[i,5]=-6) and (anim mod 1=0) then dec(enem[i,3],3);
if (enem[i,5]=6) and (anim mod 1=0) then inc(enem[i,3],3);

if (enem[i,6]=-1) and (anim mod 4=0) then dec(enem[i,2]);
if (enem[i,6]=1) and (anim mod 4=0) then inc(enem[i,2]);
if (enem[i,6]=-2) and (anim mod 2=0) then dec(enem[i,2]);
if (enem[i,6]=2) and (anim mod 2=0) then inc(enem[i,2]);
if (enem[i,6]=-3) and (anim mod 1=0) then dec(enem[i,2]);
if (enem[i,6]=3) and (anim mod 1=0) then inc(enem[i,2]);
if (enem[i,6]=-4) and (anim mod 1=0) then dec(enem[i,2],2);
if (enem[i,6]=4) and (anim mod 1=0) then inc(enem[i,2],2);
if (enem[i,6]=-5) and (anim mod 1=0) then dec(enem[i,2],3);
if (enem[i,6]=5) and (anim mod 1=0) then inc(enem[i,2],3);
if (enem[i,6]=-6) and (anim mod 1=0) then dec(enem[i,2],4);
if (enem[i,6]=6) and (anim mod 1=0) then inc(enem[i,2],4);
if enem[i,2]<-8 then
begin
enem[i,2]:=-8;
enem[i,1]:=0;
end;
if enem[i,2]>311 then
begin
enem[i,2]:=311;
enem[i,1]:=0;
end;
if anim=0 then
if random(2)=0 then
begin
enem[i,5]:=-6+random(11);
enem[i,6]:=-6+random(11);
end;
if enem[i,3]<24 then
begin
enem[i,3]:=24;
end;
if enem[i,3]>152 then
begin
enem[i,3]:=152;
end;
if enem[i,5]>6 then enem[i,5]:=6;
if enem[i,5]<-6 then enem[i,5]:=-6;
if enem[i,6]>6 then enem[i,6]:=6;
if enem[i,6]<-6 then enem[i,6]:=-6;
if (anim=0) and (enem[i,8]=1)
then
begin
enem[i,8]:=0;
end;
if (anim=15) and (enem[i,8]=1)
then
begin
nweap(enem[i,2]+4,enem[i,3]+4,3,7);
nweap(enem[i,2]+4,enem[i,3]+4,3,7);
nweap(enem[i,2]+4,enem[i,3]+4,3,7);
end;
if (anim=0) and (enem[i,8]=0)
then
begin
if (random(8)=0) then enem[i,8]:=1;
end;
if enem[i,1]=0 then inc(scapez);
end;
{---------}
if enem[i,1]=7 then
begin
if (enem[i,5]=-1) and (anim mod 6=0) then dec(enem[i,3]);
if (enem[i,5]=1) and (anim mod 6=0) then inc(enem[i,3]);
if (enem[i,5]=-2) and (anim mod 4=0) then dec(enem[i,3]);
if (enem[i,5]=2) and (anim mod 4=0) then inc(enem[i,3]);
if (enem[i,5]=-3) and (anim mod 2=0) then dec(enem[i,3]);
if (enem[i,5]=3) and (anim mod 2=0) then inc(enem[i,3]);
if (enem[i,5]=-4) and (anim mod 1=0) then dec(enem[i,3]);
if (enem[i,5]=4) and (anim mod 1=0) then inc(enem[i,3]);
if (enem[i,5]=-5) and (anim mod 1=0) then dec(enem[i,3],2);
if (enem[i,5]=5) and (anim mod 1=0) then inc(enem[i,3],2);
if (enem[i,5]=-6) and (anim mod 1=0) then dec(enem[i,3],3);
if (enem[i,5]=6) and (anim mod 1=0) then inc(enem[i,3],3);

if (enem[i,6]=-1) and (anim mod 4=0) then dec(enem[i,2]);
if (enem[i,6]=1) and (anim mod 4=0) then inc(enem[i,2]);
if (enem[i,6]=-2) and (anim mod 2=0) then dec(enem[i,2]);
if (enem[i,6]=2) and (anim mod 2=0) then inc(enem[i,2]);
if (enem[i,6]=-3) and (anim mod 1=0) then dec(enem[i,2]);
if (enem[i,6]=3) and (anim mod 1=0) then inc(enem[i,2]);
if (enem[i,6]=-4) and (anim mod 1=0) then dec(enem[i,2],2);
if (enem[i,6]=4) and (anim mod 1=0) then inc(enem[i,2],2);
if (enem[i,6]=-5) and (anim mod 1=0) then dec(enem[i,2],3);
if (enem[i,6]=5) and (anim mod 1=0) then inc(enem[i,2],3);
if (enem[i,6]=-6) and (anim mod 1=0) then dec(enem[i,2],4);
if (enem[i,6]=6) and (anim mod 1=0) then inc(enem[i,2],4);
if enem[i,2]<-8 then
begin
enem[i,2]:=-8;
enem[i,1]:=0;
end;
if enem[i,2]>311 then
begin
enem[i,2]:=311;
enem[i,1]:=0;
end;
if anim=0 then
if random(2)=0 then
begin
enem[i,7]:=38+random(132);
end;

if anim mod 8=0 then
begin
if enem[i,3]>enem[i,7] then dec(enem[i,5]);
if enem[i,3]<enem[i,7] then inc(enem[i,5]);
end;
if enem[i,3]<24 then
begin
enem[i,3]:=24;
end;
if enem[i,3]>152 then
begin
enem[i,3]:=152;
end;
if enem[i,5]>6 then enem[i,5]:=6;
if enem[i,5]<-6 then enem[i,5]:=-6;
if enem[i,6]>6 then enem[i,6]:=6;
if enem[i,6]<-6 then enem[i,6]:=-6;
if (anim=0) and (enem[i,8]=1)
then
begin
enem[i,8]:=0;
end;
if (anim=23) and (enem[i,8]=1)
then
begin
nweap(enem[i,2]+5,enem[i,3]+7,4,0);
end;
if (anim=0) and (enem[i,8]=0)
then
begin
if (random(16)=0) then enem[i,8]:=1;
end;
if enem[i,1]=0 then inc(scapez);
end;

end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure drawenems;
begin
for i:=1 to 30 do
begin
animate;
if enem[i,1]=1 then
begin
if enem[i,8]=0
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],met1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],met2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],met3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],met4,vaddr);
end;
if enem[i,8]=1
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],mfr1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],mfr2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],mfr3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],mfr4,vaddr);
end;
end;
if enem[i,1]=2 then
begin
if enem[i,8]=0
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],wrl1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],wrl2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],wrl3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],wrl4,vaddr);
end;
if enem[i,8]=1
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],wlf1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],wlf2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],wlf3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],wlf4,vaddr);
end;
end;
if enem[i,1]=3 then
begin
if enem[i,8]=0
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],wrr1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],wrr2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],wrr3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],wrr4,vaddr);
end;
if enem[i,8]=1
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],wrf1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],wrf2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],wrf3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],wrf4,vaddr);
end;
end;
if enem[i,1]=4 then
begin
if enem[i,8]=0
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],orb1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],orb2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],orb3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],orb4,vaddr);
end;
if enem[i,8]=1
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],orf1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],orf2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],orf3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],orf4,vaddr);
end;
end;
if enem[i,1]=5 then
begin
if enem[i,8]=0
then
begin
if anim div 4=0 then putimg16(enem[i,2],enem[i,3],sli1,vaddr);
if anim div 4=1 then putimg16(enem[i,2],enem[i,3],sli2,vaddr);
if anim div 4=2 then putimg16(enem[i,2],enem[i,3],sli3,vaddr);
if anim div 4=3 then putimg16(enem[i,2],enem[i,3],sli1,vaddr);
if anim div 4=4 then putimg16(enem[i,2],enem[i,3],sli2,vaddr);
if anim div 4=5 then putimg16(enem[i,2],enem[i,3],sli3,vaddr);
end;
if enem[i,8]=1
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],slf1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],slf2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],slf3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],slf4,vaddr);
end;
end;
if enem[i,1]=6 then
begin
if enem[i,8]=0
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],ooz1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],ooz2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],ooz3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],ooz4,vaddr);
end;
if enem[i,8]=1
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],ozf1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],ozf2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],ozf3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],ozf4,vaddr);
end;
end;
if enem[i,1]=7 then
begin
if enem[i,8]=0
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],han1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],han2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],han3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],han4,vaddr);
end;
if enem[i,8]=1
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],hnf1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],hnf2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],hnf3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],hnf4,vaddr);
end;
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure drawenems2;
begin
for i:=1 to 30 do
begin
animate;
if enem[i,1]=5 then
begin
if enem[i,8]=1
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],slf1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],slf2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],slf3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],slf4,vaddr);
end;
end;
if enem[i,1]=6 then
begin
if enem[i,8]=1
then
begin
if anim div 6=0 then putimg16(enem[i,2],enem[i,3],ozf1,vaddr);
if anim div 6=1 then putimg16(enem[i,2],enem[i,3],ozf2,vaddr);
if anim div 6=2 then putimg16(enem[i,2],enem[i,3],ozf3,vaddr);
if anim div 6=3 then putimg16(enem[i,2],enem[i,3],ozf4,vaddr);
end;
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure spawne1;{CYMBALOID}
label okay;
var ak:integer;
begin
for i:=1 to 30 do
begin
if enem[i,1]=0 then
begin
ak:=random(2);
enem[i,1]:=1;
if ak=0 then enem[i,2]:=-7;
if ak=1 then enem[i,2]:=312;
enem[i,3]:=8+random(176);
enem[i,4]:=random(3)+1;
enem[i,5]:=0;
if ak=0 then enem[i,6]:=2+random(3);
if ak=1 then enem[i,6]:=0-(2+random(3));
enem[i,7]:=38+random(132);
enem[i,8]:=0;
goto okay;
end;
end;
okay:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure spawne2;{SPACEWORM}
label okay,okay2;
var ak:integer;
begin
ak:=random(2);
if ak=0 then
begin
for i:=1 to 30 do
begin
if enem[i,1]=0 then
begin
enem[i,1]:=2;
enem[i,2]:=312;
enem[i,3]:=24+random(136);
enem[i,4]:=random(3)+1;
enem[i,5]:=0;
enem[i,6]:=1+random(2);
enem[i,8]:=0;
goto okay;
end;
end;
okay:
end;
if ak=1 then
begin
for i:=1 to 30 do
begin
if enem[i,1]=0 then
begin
enem[i,1]:=3;
enem[i,2]:=-8;
enem[i,3]:=24+random(136);
enem[i,4]:=random(3)+1;
enem[i,5]:=0;
enem[i,6]:=1+random(2);
enem[i,8]:=0;
goto okay2;
end;
end;
okay2:
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure spawne3;{ORBITROID}
label okay;
var ak:integer;
begin
for i:=1 to 30 do
begin
if enem[i,1]=0 then
begin
ak:=random(2);
enem[i,1]:=4;
if ak=0 then enem[i,2]:=-7;
if ak=1 then enem[i,2]:=312;
enem[i,3]:=8+random(176);
enem[i,4]:=random(3)+1;
enem[i,5]:=0;
if ak=0 then enem[i,6]:=1+random(3);
if ak=1 then enem[i,6]:=0-(1+random(3));
enem[i,7]:=38+random(132);
enem[i,8]:=0;
enem[i,9]:=32+random(264);
goto okay;
end;
end;
okay:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure spawne4;{ROTABLADE}
label okay;
var ak:integer;
begin
for i:=1 to 30 do
begin
if enem[i,1]=0 then
begin
ak:=random(2);
enem[i,1]:=5;
if ak=0 then enem[i,2]:=-7;
if ak=1 then enem[i,2]:=312;
enem[i,3]:=8+random(176);
enem[i,4]:=random(3)+1;
enem[i,5]:=0;
if ak=0 then enem[i,6]:=1+random(3);
if ak=1 then enem[i,6]:=0-(1+random(3));
enem[i,7]:=38+random(132);
enem[i,8]:=0;
enem[i,9]:=32+random(264);
goto okay;
end;
end;
okay:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure spawne5;{SLIMELIEN}
label okay;
var ak:integer;
begin
for i:=1 to 30 do
begin
if enem[i,1]=0 then
begin
ak:=random(2);
enem[i,1]:=6;
if ak=0 then enem[i,2]:=-7;
if ak=1 then enem[i,2]:=312;
enem[i,3]:=8+random(176);
enem[i,4]:=random(3)+1;
enem[i,5]:=0;
if ak=0 then enem[i,6]:=1+random(3);
if ak=1 then enem[i,6]:=0-(1+random(3));
enem[i,7]:=38+random(132);
enem[i,8]:=0;
enem[i,9]:=32+random(264);
goto okay;
end;
end;
okay:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure spawne6;{CHAOSHAND}
label okay;
var ak:integer;
begin
for i:=1 to 30 do
begin
if enem[i,1]=0 then
begin
ak:=random(2);
enem[i,1]:=7;
if ak=0 then enem[i,2]:=-7;
if ak=1 then enem[i,2]:=312;
enem[i,3]:=8+random(176);
enem[i,4]:=random(3)+1;
enem[i,5]:=0;
if ak=0 then enem[i,6]:=2+random(3);
if ak=1 then enem[i,6]:=0-(2+random(3));
enem[i,7]:=38+random(132);
enem[i,8]:=0;
enem[i,9]:=32+random(264);
goto okay;
end;
end;
okay:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure initenems;
begin
for i:=1 to 30 do
begin
enem[i,1]:=0;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Putstr(wx,wy:integer;what:string;where:word);
var sctr:integer;
    crx,cry:integer;
begin
for sctr:=1 to length(what) do
begin
crx:=wx+((sctr-1)*8);
if upcase(what[sctr])='A' then putimg8(crx,wy,let_a,where);
if upcase(what[sctr])='B' then putimg8(crx,wy,let_b,where);
if upcase(what[sctr])='C' then putimg8(crx,wy,let_c,where);
if upcase(what[sctr])='D' then putimg8(crx,wy,let_d,where);
if upcase(what[sctr])='E' then putimg8(crx,wy,let_e,where);
if upcase(what[sctr])='F' then putimg8(crx,wy,let_f,where);
if upcase(what[sctr])='G' then putimg8(crx,wy,let_g,where);
if upcase(what[sctr])='H' then putimg8(crx,wy,let_h,where);
if upcase(what[sctr])='I' then putimg8(crx,wy,let_i,where);
if upcase(what[sctr])='J' then putimg8(crx,wy,let_j,where);
if upcase(what[sctr])='K' then putimg8(crx,wy,let_k,where);
if upcase(what[sctr])='L' then putimg8(crx,wy,let_l,where);
if upcase(what[sctr])='M' then putimg8(crx,wy,let_m,where);
if upcase(what[sctr])='N' then putimg8(crx,wy,let_n,where);
if upcase(what[sctr])='O' then putimg8(crx,wy,let_o,where);
if upcase(what[sctr])='P' then putimg8(crx,wy,let_p,where);
if upcase(what[sctr])='Q' then putimg8(crx,wy,let_q,where);
if upcase(what[sctr])='R' then putimg8(crx,wy,let_r,where);
if upcase(what[sctr])='S' then putimg8(crx,wy,let_s,where);
if upcase(what[sctr])='T' then putimg8(crx,wy,let_t,where);
if upcase(what[sctr])='U' then putimg8(crx,wy,let_u,where);
if upcase(what[sctr])='V' then putimg8(crx,wy,let_v,where);
if upcase(what[sctr])='W' then putimg8(crx,wy,let_w,where);
if upcase(what[sctr])='X' then putimg8(crx,wy,let_x,where);
if upcase(what[sctr])='Y' then putimg8(crx,wy,let_y,where);
if upcase(what[sctr])='Z' then putimg8(crx,wy,let_z,where);
if upcase(what[sctr])='0' then putimg8(crx,wy,let_0,where);
if upcase(what[sctr])='1' then putimg8(crx,wy,let_1,where);
if upcase(what[sctr])='2' then putimg8(crx,wy,let_2,where);
if upcase(what[sctr])='3' then putimg8(crx,wy,let_3,where);
if upcase(what[sctr])='4' then putimg8(crx,wy,let_4,where);
if upcase(what[sctr])='5' then putimg8(crx,wy,let_5,where);
if upcase(what[sctr])='6' then putimg8(crx,wy,let_6,where);
if upcase(what[sctr])='7' then putimg8(crx,wy,let_7,where);
if upcase(what[sctr])='8' then putimg8(crx,wy,let_8,where);
if upcase(what[sctr])='9' then putimg8(crx,wy,let_9,where);
if upcase(what[sctr])=':' then putimg8(crx,wy,let_dp,where);
end;
end;

procedure Messages;
begin
if ((xtral>0) and (((anim div 2) mod 2)=0)) then putstr(98,192,'EXTRA PAIR AWARDED',vaddr);
end;

procedure Enterzone;
begin
InitStars;
cls(vaddr2,0);
cls(vaddr,0);
flip(vaddr2,vaddr);
CalcStars;
DrawStars;
putstr(96,88,'ENTERING ZONE',vaddr);
putdigit(208,88,digit(level,2));
putdigit(216,88,digit(level,1));
putstr(88,104,'PREPARE FOR BATTLE',vaddr);
flip(vaddr,vaddr2);
OnScreen;
cls(vaddr2,0);
cls(vaddr,0);
for k:=1 to 200 do
begin
flip(vaddr2,vaddr);
for zek:=1 to factor do
begin
Animate;
CalcStars;
end;
DrawStars;
putstr(96,88,'ENTERING ZONE',vaddr);
putdigit(208,88,digit(level,2));
putdigit(216,88,digit(level,1));
putstr(88,104,'PREPARE FOR BATTLE',vaddr);
Controls;
waitretrace;
playmux;
flip(vaddr,vga);
end;
OffScreen;
cls(vaddr2,0);
InitStars;
CalcStars;
DrawStars;
scoreboard;
if (pad_4=false) and (pad_6=false) then
begin
putimg16(x,8,satc,vaddr);
putimg16(304-x,184,satc,vaddr);
end;
if (pad_4=true) and (pad_6=true) then
begin
putimg16(x,8,satc,vaddr);
putimg16(304-x,184,satc,vaddr);
end;
if (pad_4=true) and (pad_6=false) then
begin
putimg16(x,8,satl,vaddr);
putimg16(304-x,184,satr,vaddr);
end;
if (pad_4=false) and (pad_6=true) then
begin
putimg16(x,8,satr,vaddr);
putimg16(304-x,184,satl,vaddr);
end;
if angle=0 then
begin
putimg8(x+4,16,dish6,vaddr);
putimg8(308-x,176,dish1,vaddr);
end;
if angle=1 then
begin
putimg8(x+4,16,dish7,vaddr);
putimg8(308-x,176,dish4,vaddr);
end;
if angle=2 then
begin
putimg8(x+4,16,dish8,vaddr);
putimg8(308-x,176,dish5,vaddr);
end;
if angle=3 then
begin
putimg8(x+4,16,dish9,vaddr);
putimg8(308-x,176,dish2,vaddr);
end;
if angle=4 then
begin
putimg8(x+4,16,disha,vaddr);
putimg8(308-x,176,dish3,vaddr);
end;
flip(vaddr,vaddr2);
OnScreen;
cls(vaddr2,0);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure ShowLives;
begin
InitStars;
cls(vaddr2,0);
cls(vaddr,0);
CalcStars;
DrawStars;
putstr(88,96,'PAIRS REMAINING:',vaddr);
putdigit(224,96,sats);
flip(vaddr,vaddr2);
OnScreen;
cls(vaddr2,0);
cls(vaddr,0);
for k:=1 to 200 do
begin
flip(vaddr2,vaddr);
for zek:=1 to factor do
begin
Animate;
CalcStars;
end;
DrawStars;
putstr(88,96,'PAIRS REMAINING:',vaddr);
putdigit(224,96,sats);
Controls;
waitretrace;
playmux;
flip(vaddr,vga);
end;
OffScreen;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure ShowZapped;
var perc:integer;
    bonuz:longint;
    totalz:integer;
begin
bonuz:=0;
if killz=0 then killz:=1;
totalz:=scapez+killz;
perc:=round((killz/totalz)*100);
InitStars;
cls(vaddr2,0);
cls(vaddr,0);
CalcStars;
DrawStars;
putstr(120, 64,'ZONE ZAPPED',vaddr);
putstr(72, 80,'CLEAR PERCENT:    X100',vaddr);
putstr(80, 96,'DOUBLE ZAPS:   X1000',vaddr);
putstr(80,112,'TREBLE ZAPS:   X2500',vaddr);
putstr(80,128,'TOTAL BONUS:',vaddr);
putdigit(8+184,80,digit(perc,3));
putdigit(8+192,80,digit(perc,2));
putdigit(8+200,80,digit(perc,1));
putdigit(8+176,96,digit(dzaps,2));
putdigit(8+184,96,digit(dzaps,1));
putdigit(8+176,112,digit(tzaps,2));
putdigit(8+184,112,digit(tzaps,1));
bonuz:=(perc*100)+(dzaps*1000)+(tzaps*2500);
for i:=0 to 6 do putdigit(8+176+i*8,128,digit(bonuz,(7-i)));
flip(vaddr,vaddr2);
OnScreen;
cls(vaddr2,0);
cls(vaddr,0);
for k:=1 to 500 do
begin
flip(vaddr2,vaddr);
for zek:=1 to factor do
begin
Animate;
CalcStars;
end;
DrawStars;
putstr(120, 64,'ZONE ZAPPED',vaddr);
putstr(72, 80,'CLEAR PERCENT:    X100',vaddr);
putstr(80, 96,'DOUBLE ZAPS:   X1000',vaddr);
putstr(80,112,'TREBLE ZAPS:   X2500',vaddr);
putstr(80,128,'TOTAL BONUS:',vaddr);
putdigit(8+184,80,digit(perc,3));
putdigit(8+192,80,digit(perc,2));
putdigit(8+200,80,digit(perc,1));
putdigit(8+176,96,digit(dzaps,2));
putdigit(8+184,96,digit(dzaps,1));
putdigit(8+176,112,digit(tzaps,2));
putdigit(8+184,112,digit(tzaps,1));
for i:=0 to 6 do putdigit(8+176+i*8,128,digit(bonuz,(7-i)));
Controls;
waitretrace;
playmux;
flip(vaddr,vga);
end;
OffScreen;
score:=score+bonuz;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure ShowGameOver;
begin
InitStars;
cls(vaddr2,0);
cls(vaddr,0);
CalcStars;
DrawStars;
putstr(132,96,'GAME OVER',vaddr);
flip(vaddr,vaddr2);
OnScreen;
cls(vaddr2,0);
cls(vaddr,0);
for k:=1 to 300 do
begin
flip(vaddr2,vaddr);
for zek:=1 to factor do
begin
Animate;
CalcStars;
end;
DrawStars;
putstr(132,96,'GAME OVER',vaddr);
Controls;
waitretrace;
playmux;
flip(vaddr,vga);
end;
OffScreen;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function Askcontinue:boolean;
var res:boolean;
label done;
begin
res:=false;
InitStars;
cls(vaddr2,0);
cls(vaddr,0);
CalcStars;
DrawStars;
putstr( 72,88 ,'PRESS FIRE TO CONTINUE',vaddr);
putstr( 96,104,'OR WAIT TO RETIRE',vaddr);
flip(vaddr,vaddr2);
OnScreen;
cls(vaddr2,0);
cls(vaddr,0);
for k:=1 to 500 do
begin
flip(vaddr2,vaddr);
for zek:=1 to factor do
begin
Animate;
CalcStars;
end;
DrawStars;
putstr( 72,88 ,'PRESS FIRE TO CONTINUE',vaddr);
putstr( 96,104,'OR WAIT TO RETIRE',vaddr);
Controls;
waitretrace;
playmux;
flip(vaddr,vga);
if key_spacebar=true then
begin
res:=true;
goto done;
end;
end;
done:
OffScreen;
AskContinue:=res;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure ShowWellDone;
begin
InitStars;
cls(vaddr2,0);
cls(vaddr,0);
CalcStars;
DrawStars;
putstr(124,88,'WELL DONE',vaddr);
putstr( 88,104,'THE GALAXY IS SAFE',vaddr);
flip(vaddr,vaddr2);
OnScreen;
cls(vaddr2,0);
cls(vaddr,0);
for k:=1 to 300 do
begin
flip(vaddr2,vaddr);
for zek:=1 to factor do
begin
Animate;
CalcStars;
end;
DrawStars;
putstr(124,88,'WELL DONE',vaddr);
putstr( 88,104,'THE GALAXY IS SAFE',vaddr);
Controls;
waitretrace;
playmux;
flip(vaddr,vga);
end;
OffScreen;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure initbooms;
begin
for i:=1 to 30 do
begin
boom[i,1]:=0;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure initbitz;
begin
for i:=1 to 30 do
begin
bitz[i,1]:=0;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure initweaps;
begin
for i:=1 to 30 do
begin
weap[i,1]:=0;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure resetvars;
begin
endl:=0;
initbitz;
InitStars;
Initenems;
Initbooms;
Initweaps;
x:=152;
lives:=7;
shi:=0;
alive:=1;
paws:=0;
dely:=0;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure drawstars2;
var gyi:integer;
    rx,ry:integer;
begin
for i:=1 to 40 do
begin
rx:=round(star[i,1]);
ry:=round(Star[i,2]);
if star[i,3]=1 then if anim mod 3=0 then star[i,1]:=star[i,1]-1;
if star[i,3]=2 then if anim mod 2=0 then  star[i,1]:=star[i,1]-1;
if star[i,3]=3 then star[i,1]:=star[i,1]-1;
if (rx<(star[i,3]-1)) then
begin
star[i,3]:=random(3)+1;
star[i,1]:=320-star[i,3];
star[i,2]:=random(196)+2;
end;
end;
for i:=1 to 40 do
begin
rx:=round(star[i,1]);
ry:=round(Star[i,2]);
if star[i,3]=1 then if point(rx,ry,vaddr)=0 then pixel(rx,ry,200,vaddr);
if (star[i,3]=2) then
 begin
 if point(rx,ry,vaddr)=0 then pixel(rx,ry,196,vaddr);
 if point(rx+1,ry,vaddr)=0 then pixel(rx+1,ry,210,vaddr);
 if point(rx-1,ry,vaddr)=0 then pixel(rx-1,ry,210,vaddr);
 if point(rx,ry+1,vaddr)=0 then pixel(rx,ry+1,210,vaddr);
 if point(rx,ry-1,vaddr)=0 then pixel(rx,ry-1,210,vaddr);
 end;
if (star[i,3]=3) then
 begin
 if point(rx,ry,vaddr)=0 then pixel(rx,ry,192,vaddr);
 if point(rx+1,ry,vaddr)=0 then pixel(rx+1,ry,200,vaddr);
 if point(rx-1,ry,vaddr)=0 then pixel(rx-1,ry,200,vaddr);
 if point(rx,ry+1,vaddr)=0 then pixel(rx,ry+1,200,vaddr);
 if point(rx,ry-1,vaddr)=0 then pixel(rx,ry-1,200,vaddr);
 if point(rx+2,ry,vaddr)=0 then pixel(rx+2,ry,214,vaddr);
 if point(rx-2,ry,vaddr)=0 then pixel(rx-2,ry,214,vaddr);
 if point(rx,ry+2,vaddr)=0 then pixel(rx,ry+2,214,vaddr);
 if point(rx,ry-2,vaddr)=0 then pixel(rx,ry-2,214,vaddr);
 if point(rx-1,ry-1,vaddr)=0 then pixel(rx-1,ry-1,214,vaddr);
 if point(rx+1,ry-1,vaddr)=0 then pixel(rx+1,ry-1,214,vaddr);
 if point(rx-1,ry+1,vaddr)=0 then pixel(rx-1,ry+1,214,vaddr);
 if point(rx+1,ry+1,vaddr)=0 then pixel(rx+1,ry+1,214,vaddr);
 end;
end;
for i:=0 to 191 do
begin
xhline(i,0,8,0,vaddr);
xhline(i,311,319,0,vaddr);
end;
{for i:=0 to 7 do xhline(i,0,319,0,vaddr);}
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure delstars2;
var gyi:integer;
    rx,ry:integer;
begin
for i:=1 to 40 do
begin
rx:=round(star[i,1]);
ry:=round(star[i,2]);
if star[i,3]=1 then if point(rx,ry,vaddr)=200 then pixel(rx,ry,0,vaddr);
if (star[i,3]=2) then
 begin
 if point(rx,ry,vaddr)=196 then pixel(rx,ry,0,vaddr);
 if point(rx+1,ry,vaddr)=210 then pixel(rx+1,ry,0,vaddr);
 if point(rx-1,ry,vaddr)=210 then pixel(rx-1,ry,0,vaddr);
 if point(rx,ry+1,vaddr)=210 then pixel(rx,ry+1,0,vaddr);
 if point(rx,ry-1,vaddr)=210 then pixel(rx,ry-1,0,vaddr);
 end;
if (star[i,3]=3) then
 begin
 if point(rx,ry,vaddr)=192 then pixel(rx,ry,0,vaddr);
 if point(rx+1,ry,vaddr)=200 then pixel(rx+1,ry,0,vaddr);
 if point(rx-1,ry,vaddr)=200 then pixel(rx-1,ry,0,vaddr);
 if point(rx,ry+1,vaddr)=200 then pixel(rx,ry+1,0,vaddr);
 if point(rx,ry-1,vaddr)=200 then pixel(rx,ry-1,0,vaddr);
 if point(rx+2,ry,vaddr)=214 then pixel(rx+2,ry,0,vaddr);
 if point(rx-2,ry,vaddr)=214 then pixel(rx-2,ry,0,vaddr);
 if point(rx,ry+2,vaddr)=214 then pixel(rx,ry+2,0,vaddr);
 if point(rx,ry-2,vaddr)=214 then pixel(rx,ry-2,0,vaddr);
 if point(rx-1,ry-1,vaddr)=214 then pixel(rx-1,ry-1,0,vaddr);
 if point(rx+1,ry-1,vaddr)=214 then pixel(rx+1,ry-1,0,vaddr);
 if point(rx-1,ry+1,vaddr)=214 then pixel(rx-1,ry+1,0,vaddr);
 if point(rx+1,ry+1,vaddr)=214 then pixel(rx+1,ry+1,0,vaddr);
 end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure calcstars;
var gyi:integer;
    rx,ry:integer;
begin
for i:=1 to 40 do
begin
rx:=round(star[i,1]);
ry:=round(Star[i,2]);
if star[i,3]=1 then if anim mod 3=0 then star[i,1]:=star[i,1]-1;
if star[i,3]=2 then if anim mod 2=0 then  star[i,1]:=star[i,1]-1;
if star[i,3]=3 then star[i,1]:=star[i,1]-1;
if (rx<(star[i,3]-1)) then
begin
star[i,3]:=random(3)+1;
star[i,1]:=320-star[i,3];
star[i,2]:=random(196)+2;
end;
end;
end;

procedure drawstars;
var gyi:integer;
    rx,ry:integer;
begin
for i:=1 to 40 do
begin
rx:=round(star[i,1]);
ry:=round(Star[i,2]);
if star[i,3]=1 then pixel(rx,ry,200,vaddr);
if (star[i,3]=2) then
 begin
 pixel(rx,ry,196,vaddr);
 pixel(rx+1,ry,210,vaddr);
 pixel(rx-1,ry,210,vaddr);
 pixel(rx,ry+1,210,vaddr);
 pixel(rx,ry-1,210,vaddr);
 end;
if (star[i,3]=3) then
 begin
 pixel(rx,ry,192,vaddr);
 pixel(rx+1,ry,200,vaddr);
 pixel(rx-1,ry,200,vaddr);
 pixel(rx,ry+1,200,vaddr);
 pixel(rx,ry-1,200,vaddr);
 pixel(rx+2,ry,214,vaddr);
 pixel(rx-2,ry,214,vaddr);
 pixel(rx,ry+2,214,vaddr);
 pixel(rx,ry-2,214,vaddr);
 pixel(rx-1,ry-1,214,vaddr);
 pixel(rx+1,ry-1,214,vaddr);
 pixel(rx-1,ry+1,214,vaddr);
 pixel(rx+1,ry+1,214,vaddr);
 end;
end;
for i:=8 to 199 do
begin
xhline(i,0,8,0,vaddr);
xhline(i,311,319,0,vaddr);
end;
for i:=0 to 7 do xhline(i,0,319,0,vaddr);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure delstars;
var gyi:integer;
    rx,ry:integer;
begin
for i:=1 to 30 do
begin
if weap[i,1]>0 then
begin
putspc8(weap[i,2],weap[i,3],blk8,vaddr);
end;
if bitz[i,1]>0 then
begin
putspc8(bitz[i,2],bitz[i,3],blk8,vaddr);
end;
if enem[i,1]>0 then
begin
putspc16(enem[i,2],enem[i,3],blk16,vaddr);
end;
if boom[i,1]>0 then
begin
putspc16(boom[i,2],boom[i,3],blk16,vaddr);
end;
end;
for i:=1 to 40 do
begin
rx:=round(star[i,1]);
ry:=round(star[i,2]);
if star[i,3]=1 then pixel(rx,ry,0,vaddr);
if (star[i,3]=2) then
 begin
 pixel(rx,ry,0,vaddr);
 pixel(rx+1,ry,0,vaddr);
 pixel(rx-1,ry,0,vaddr);
 pixel(rx,ry+1,0,vaddr);
 pixel(rx,ry-1,0,vaddr);
 end;
if (star[i,3]=3) then
 begin
 pixel(rx,ry,0,vaddr);
 pixel(rx+1,ry,0,vaddr);
 pixel(rx-1,ry,0,vaddr);
 pixel(rx,ry+1,0,vaddr);
 pixel(rx,ry-1,0,vaddr);
 pixel(rx+2,ry,0,vaddr);
 pixel(rx-2,ry,0,vaddr);
 pixel(rx,ry+2,0,vaddr);
 pixel(rx,ry-2,0,vaddr);
 pixel(rx-1,ry-1,0,vaddr);
 pixel(rx+1,ry-1,0,vaddr);
 pixel(rx-1,ry+1,0,vaddr);
 pixel(rx+1,ry+1,0,vaddr);
 end;
end;
end;

procedure DrawSats;
begin
if (pad_4=false) and (pad_6=false) then
begin
putimg16(x,8,satc,vaddr);
putimg16(304-x,184,satc,vaddr);
end;
if (pad_4=true) and (pad_6=true) then
begin
putimg16(x,8,satc,vaddr);
putimg16(304-x,184,satc,vaddr);
end;
if (pad_4=true) and (pad_6=false) then
begin
putimg16(x,8,satl,vaddr);
putimg16(304-x,184,satr,vaddr);
end;
if (pad_4=false) and (pad_6=true) then
begin
putimg16(x,8,satr,vaddr);
putimg16(304-x,184,satl,vaddr);
end;
if angle=0 then
begin
putimg8(x+4,16,dish6,vaddr);
putimg8(308-x,176,dish1,vaddr);
end;
if angle=1 then
begin
putimg8(x+4,16,dish7,vaddr);
putimg8(308-x,176,dish4,vaddr);
end;
if angle=2 then
begin
putimg8(x+4,16,dish8,vaddr);
putimg8(308-x,176,dish5,vaddr);
end;
if angle=3 then
begin
putimg8(x+4,16,dish9,vaddr);
putimg8(308-x,176,dish2,vaddr);
end;
if angle=4 then
begin
putimg8(x+4,16,disha,vaddr);
putimg8(308-x,176,dish3,vaddr);
end;
if (shi>0) and (((anim mod 4) div 2)=0) then
begin
if (pad_4=false) and (pad_6=false) then
begin
putimg16s(x,8,satc,vaddr,0);
putimg16s(304-x,184,satc,vaddr,0);
end;
if (pad_4=true) and (pad_6=true) then
begin
putimg16s(x,8,satc,vaddr,0);
putimg16s(304-x,184,satc,vaddr,0);
end;
if (pad_4=true) and (pad_6=false) then
begin
putimg16s(x,8,satl,vaddr,0);
putimg16s(304-x,184,satr,vaddr,0);
end;
if (pad_4=false) and (pad_6=true) then
begin
putimg16s(x,8,satr,vaddr,0);
putimg16s(304-x,184,satl,vaddr,0);
end;
if angle=0 then
begin
putimg8s(x+4,16,dish6,vaddr,0);
putimg8s(308-x,176,dish1,vaddr,0);
end;
if angle=1 then
begin
putimg8s(x+4,16,dish7,vaddr,0);
putimg8s(308-x,176,dish4,vaddr,0);
end;
if angle=2 then
begin
putimg8s(x+4,16,dish8,vaddr,0);
putimg8s(308-x,176,dish5,vaddr,0);
end;
if angle=3 then
begin
putimg8s(x+4,16,dish9,vaddr,0);
putimg8s(308-x,176,dish2,vaddr,0);
end;
if angle=4 then
begin
putimg8s(x+4,16,disha,vaddr,0);
putimg8s(308-x,176,dish3,vaddr,0);
end;
end;
end;
procedure movesats;
begin
angle:=0;
if (pad_6=true) and (x<288) then inc(x,2);
if (pad_4=true) and (x>16) then dec(x,2);
if (x>152) and ((x-152)>21) and ((x-152)<66) then angle:=1;
if (x>152) and ((x-152)>65) then angle:=2;
if (x<152) and ((152-x)>21) and ((152-x)<66) then angle:=3;
if (x<152) and ((152-x)>65) then angle:=4;
end;

procedure DrawZaps;
begin
if (zaptm>19) then
begin
if angle=0 then getnodes(x+  8,23,311-x,175);
if angle=1 then getnodes(x+  5,23,314-x,175);
if angle=2 then getnodes(x+  4,23,316-x,175);
if angle=3 then getnodes(x+ 10,23,309-x,175);
if angle=4 then getnodes(x+ 11,23,307-x,175);
drawnodes;
end;
end;

procedure FireZaps;
begin
if (key_spacebar) and (zaptm=0) then
begin
Sfx7;
zaptm:=30;
czaps:=0;
end;
end;

procedure spawnenem;
begin
if (lspa[level,1]=1) and (anim=0) and (random( 5)=0) and (aliens>0) then spawne1;
if (lspa[level,1]=2) and (anim=0) and (random(10)=0) and (aliens>0) then spawne1;
if (lspa[level,2]=1) and (anim=0) and (random( 5)=0) and (aliens>0) then spawne2;
if (lspa[level,2]=2) and (anim=0) and (random(10)=0) and (aliens>0) then spawne2;
if (lspa[level,3]=1) and (anim=0) and (random( 5)=0) and (aliens>0) then spawne3;
if (lspa[level,3]=2) and (anim=0) and (random(10)=0) and (aliens>0) then spawne3;
if (lspa[level,4]=1) and (anim=0) and (random( 5)=0) and (aliens>0) then spawne4;
if (lspa[level,4]=2) and (anim=0) and (random(10)=0) and (aliens>0) then spawne4;
if (lspa[level,5]=1) and (anim=0) and (random( 5)=0) and (aliens>0) then spawne5;
if (lspa[level,5]=2) and (anim=0) and (random(10)=0) and (aliens>0) then spawne5;
if (lspa[level,6]=1) and (anim=0) and (random( 5)=0) and (aliens>0) then spawne6;
if (lspa[level,6]=2) and (anim=0) and (random(10)=0) and (aliens>0) then spawne6;
end;

function UpS(S: string): string;
var
  I: Integer;
begin
  for I := 1 to Length(S) do
  if (S[I] >= 'A') and (S[I] <= 'Z') then
  Inc(S[I], 32);
  UpS := S;
end;

procedure Controls;
begin
CheckSounds;
CheckPaws;
if key_f2=true then hi:=score;
if key_f1=true then
begin
uninitialise;
savehiscore;
halt;
end;
end;

{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{                                   MAIN                                   }
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
label EndProg,NextLev,Replay,Outahere,Restart;
begin
SyncON;
synctype:=1;
stepv:=2;
factor:=1;
fskip:=0;
turbo:=0;
zaptm:=0;
nodet:=0;
sounds:=1;
muzak:=1;
for i:=1 to paramcount do
begin
if pos('slowsync',ups(paramstr(i)))<>0 then stepv:=3;
if pos('vgasync',ups(paramstr(i)))<>0 then synctype:=2;
if pos('fskip=2',ups(paramstr(i)))<>0 then factor:=2;
if pos('fskip=3',ups(paramstr(i)))<>0 then factor:=3;
if pos('fskip=4',ups(paramstr(i)))<>0 then factor:=4;
if pos('nosfx',ups(paramstr(i)))<>0 then sounds:=0;
if pos('nomus',ups(paramstr(i)))<>0 then muzak:=0;
if pos('nodet',ups(paramstr(i)))<>0 then nodet:=1;
end;
loadhiscore;
randomize;
Initialise;
if sbl_have=0 then sounds:=0;
if adl_have=0 then muzak:=0;
fade(0);
restart:
initstars;
cls(vaddr2,0);
cls(vaddr,0);
calcstars;
drawstars;
Rig_bit2;
for i:=0 to 7 do putdigit(176+i*8,168,digit(hi,8-i));
flip(vaddr,vaddr2);
OnScreen;
{
cls(vaddr2,0);
cls(vaddr,0);
}
while not key_spacebar do
begin
if key_f1=true then
begin
uninitialise;
savehiscore;
halt;
end;
CheckSounds;
if key_f2=true then
begin
hi:=0;
end;
for zek:=1 to factor
do
begin
delstars2;
drawstars2;
animate;
end;
for i:=0 to 7 do putdigit(176+i*8,168,digit(hi,8-i));

waitretrace;
flip(vaddr,vga);
playmux;
end;
Sfx7;
OffScreen;
InitStars;
cheatpos:=1;
score:=0;
ps:=1;
level:=0;
sats:=4;
nextlev:
inc(level);
cycle:=0;
killz:=0;
dzaps:=0;
tzaps:=0;
scapez:=0;
aliens:=40;
replay:
Resetvars;
Enterzone;
while endl<200 do
begin
CheckSounds;
CheckPaws;
if key_f2=true then hi:=score;
if key_f1=true then
begin
uninitialise;
savehiscore;
halt;
end;
if (key_m=true) and (cheatpos=01) then inc(cheatpos);
if (key_e=true) and (cheatpos=02) then inc(cheatpos);
if (key_o=true) and (cheatpos=03) then inc(cheatpos);
if (key_w=true) and (cheatpos=04) then inc(cheatpos);
if (key_enter=true) and (cheatpos<5) then cheatpos:=1;
if (key_enter=true) and (cheatpos=5) then cheatpos:=6;
if cheatpos=6 then lives:=7;
if alive=0 then zaptm:=0;
putspc16(x,8,blk16,vaddr);
putspc16(304-x,176,blk16,vaddr);
if (zaptm>19) then delnodes;
delstars;
{}
for zek:=1 to factor do
begin
spawnenem;
calcbooms;
calcstars;
calcbitz;
calcweaps;
tanim:=anim;
calcenems;
anim:=tanim;
MoveSats;
if (alive=1) then FireZaps;
animh:=tanimh;
animate;
tanimh:=animh;
LoopCounters;
if score>hi then hi:=score;
end;
{}
tanim:=anim;
drawstars;
anim:=tanim;
animh:=tanimh;
drawbitz;
anim:=tanim;
drawenems;
anim:=tanim;
drawweaps;
anim:=tanim;
drawenems2;
anim:=tanim;
if (alive=1) then
begin
DrawSats;
DrawZaps;
end;
drawbooms;
for i:=192 to 199 do xhline(i,0,319,0,vaddr);
for i:=0 to 7 do xhline(i,0,319,0,vaddr);
for i:=8 to 199 do
begin
xhline(i,0,8,0,vaddr);
xhline(i,311,319,0,vaddr);
end;
scoreboard;
Messages;
playmux;
waitretrace;
flip(vaddr,vga);
if (bcount=0) and (aliens=0) then if endl=0 then endl:=1;
bcount:=0;
end;
OffScreen;
if (alive=0) then dec(sats);
if (alive=0) and (sats>0) then ShowLives;
if (alive=0) and (sats=0) then ShowGameOver;
if (alive=0) and (sats>0) then goto replay;
if (alive=1) then
begin
ShowZapped;
if level<15 then goto nextlev;
if level=15 then
begin
ShowWellDone;
savehiscore;
if Askcontinue=true then
begin
level:=0;
goto nextlev;
end;
end;
end;
savehiscore;
goto restart;
Uninitialise;
end.