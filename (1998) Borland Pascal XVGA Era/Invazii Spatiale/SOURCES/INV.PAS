{$X+ $N+ $E-}
program Inv;
uses Crt,Dos,Video,Filez,General,Inter_SB,SB_unit,Strings;
{}
const boxx=95;
      boxy=40;
      invxdist=5;
      invydist=5;
      wavdx=184;
      wavdy=80;
      logox=(320 div 2)-(142 div 2);
      logoy=80;
      hiscorex=242;
      hiscorey=188;
      shipy=164;
      KEYBOARDPORT = $60;
      KEYBOARDINTR = 9;
var lmx:integer;
    mpx,mpy:integer;
    Minavail:longint;
    mess:integer;
    mbut:word;
    olfayd:integer;
    bam:integer;
    hold:integer;
    olsnd:integer;
    cota:byte;
    stat:integer;
    tleft,tright:boolean;
    timetofire:integer;
    f:file of byte;
    shields:array[1..10,1..6] of shortint;
    groove:array[1..10,1..6] of shortint;
    alienz:array[1..10,1..6] of shortint;
    fallers:array[1..5,1..6] of integer;
    {settings}
    havesoundcard:boolean;
    sincro,hiqual,muzeak:boolean;
    sounds:byte;
    adr,irq,dma:integer;
    fast:byte;
    {status}
    hzml,hz,hs,hm,hzm,hsm,hml,zml,z,s,m,zm,sm,ml,lives:byte;
    bonus:integer;
    {speaker sounds}
    fla,blt,sli,pho,las,bum,clic,bip:integer;
    {loops}
    k:integer;
    {weapons}
    laser:array[1..4,1..3] of integer;
    photon:array[1..6,1..3] of integer;
    bload:integer;
    dispprot:byte;
    {general}
    invkill,anim,iwav:byte;
    wave,fayd,oldfayd:integer;
    fluct1,fluct2,fluct3,fluct4:shortint;
    {checksum}
    fw:file of word;
    checksum:longint;
    w:word;
    {player ship}
    shield,shipx:integer;
    {invaders}
    direction,godown,invx,invy,tfreq:integer;
    speed,rinvx:real;
    maxleft,maxright:boolean;
    {algorithmic}
    optp:integer;
    mpos,mpos2:integer;
    start:byte;
    fired_on_that_row:boolean;
    {wave-end}
    boom,doom,done:boolean;
    {keys}
    alt,F1_,F2_,F3_,F4_,k1,k2,k3,k4,plus,minus,space,up,down,right,left,esc:boolean;
    CallBiosHandler:boolean;
    BiosKeyboardHandler:procedure;
    {fireworks-show}
    fw1:array[1..60,1..6] of real;
    fw2:array[1..60,1..6] of real;
    fw3:array[1..60,1..6] of real;
    {forward procedures}
    procedure HideCursor;forward;
    procedure DoSounds; forward;
    procedure Ship_Check; forward;
    procedure FireWShow; forward;
    procedure DrawStatusBar; forward;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{$F+}
procedure KeyboardHandler(Flags, CS, IP, AX, BX, CX, DX,
                          SI, DI, DS, ES, BP: Word);interrupt;
var key : byte;
begin
  key := Port[KEYBOARDPORT];
  case key of
              1 : esc:=true;
        128 + 1 : esc:=false;
              75 : left:=true;
        128 + 75 : left:=false;
              77 : right:=true;
        128 + 77 : right:=false;
              72 : up:=true;
        128 + 72 : up:=false;
              80 : down:=true;
        128 + 80 : down:=false;
              59 : F1_:=true;
        128 + 59 : F1_:=false;
              60 : F2_:=true;
        128 + 60 : F2_:=false;
              61 : F3_:=true;
        128 + 61 : F3_:=false;
              62 : F4_:=true;
        128 + 62 : F4_:=false;
              56 : alt:=true;
        128 + 56 : alt:=false;
              57 : space:=true;
        128 + 57 : space:=false;
              78 : plus:=true;
        128 + 78 : plus:=false;
              74 : minus:=true;
        128 + 74 : minus:=false;
               2 : k1:=true;
        128 +  2 : k1:=false;
               3 : k2:=true;
        128 +  3 : k2:=false;
               4 : k3:=true;
        128 +  4 : k3:=false;
               5 : k4:=true;
        128 +  5 : k4:=false;
  end;
  if CallBIOSHandler then
    begin
      asm pushf end;
      BIOSKeyboardHandler;
    end
  else Port[$20] := $20;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure PlayAie;
begin
SB_PlayDma(S1Buff,S1Rate,S1Size-5)
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure PlayHit;
begin
SB_PlayDma(S2Buff,S2Rate,S2Size-5)
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure PlayLas;
begin
SB_PlayDma(S3Buff,S3Rate,S3Size-5)
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure PlayPho;
begin
SB_PlayDma(S4Buff,S4Rate,S4Size-5)
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure PlayBlt;
begin
SB_PlayDma(S5Buff,S5Rate,S5Size-5)
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure PlaySli;
begin
SB_PlayDma(S6Buff,S6Rate,S6Size-5)
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure PlayFla;
begin
SB_PlayDma(S7Buff,S7Rate,S7Size-5)
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure PlayBum;
begin
SB_PlayDma(S8Buff,S8Rate,S8Size-5)
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure PlayClc;
begin
SB_PlayDma(S9Buff,S9Rate,S9Size-5)
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure PlayBip;
begin
SB_PlayDma(SABuff,SARate,SASize-5)
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure SpkBeep;
begin
for i:=1 to 50 do
begin
sound(2000+((i mod 4)*100));
delay(1);
end;
nosound;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure ClsScr;
begin
for i:=8 to 170 do line (8,i,311,i,1,vaddr);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{
Function Tampered:boolean;
var
checksum2:longint;
checksum3:longint;
checksum4:longint;
x:byte;
kia:file of longint;
tt:longint;
tt2:longint;
tt3:longint;
tt4:longint;
po:longint;
begin
checksum:=0;
checksum2:=0;
checksum3:=0;
checksum4:=0;
Gotoxy(1,11);
Textcolor(14);
HideCursor;
ShowProg(0);
while (not SB_Dmacomplete) do;

while (not SB_Dmacomplete) do;
assign(f,'DATE\grafica.grp');
reset(f);
seek(f,4);
while not eof(f) do
begin
read(f,x);
po:=filepos(f);
seek(f,po+9);
checksum2:=checksum2+x;
end;
close(f);
ShowProg(50);

while (not SB_Dmacomplete) do;
assign(f,'DATE\decor.rle');
reset(f);
while not eof(f) do
begin
read(f,x);
po:=filepos(f);
seek(f,po+9);
checksum3:=checksum3+x;
end;
close(f);
ShowProg(100);
while (not SB_Dmacomplete) do;
assign(f,'inv.doc');
reset(f);
while not eof(f) do
begin
read(f,x);
po:=filepos(f);
seek(f,po+2);
checksum4:=checksum4+x;
end;
close(f);
ShowProg(100);

while (not SB_Dmacomplete) do;
assign(kia,'inv.chk');
reset(kia);
read (kia,tt3);
read (kia,tt2);
read (kia,tt4);
close(kia);
assign(f,'inv.exe');
reset(f);
checksum:=filesize(f);
close(f);
if ((checksum<40000) and (checksum2=tt2) and (checksum3=tt3) and (checksum4=tt4)) then Tampered:=false
 else Tampered:=true;
end;
}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure RegenerateConfig;
var ux:byte;
begin
assign(f,'inv.cfg');
{$I-}
reset(f);
{$I+}
if IOresult<>0 then
begin
rewrite(f);
ux:=0;
write (f,ux);
ux:=0;
write (f,ux);
ux:=1;
write (f,ux);
ux:=1;
write (f,ux);
ux:=2;
write (f,ux);
ux:=5;
write (f,ux);
ux:=1;
write (f,ux);
end;
close(f);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure DefVar;
var x:byte;
begin
RegenerateConfig;
Assign(f,'inv.cfg');
reset(f);
read(f,x);
if x=0 then sounds:=0;
if x=1 then sounds:=1;
if x=2 then sounds:=2;
read(f,x);
if x=0 then muzeak:=false;
if x=1 then muzeak:=true;
read(f,x);
fast:=x;
read(f,x);
if x=0 then sincro:=false;
if x=1 then sincro:=true;
read(f,x);
adr:=x;
read(f,x);
irq:=x;
read(f,x);
dma:=x;
close(f);
randomize;
hiqual:=true;
wave:=0;
CallBIOSHandler := false;
GetIntVec(KEYBOARDINTR, @BIOSKeyboardHandler);
SetIntVec(KEYBOARDINTR, Addr(KeyboardHandler));
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure ResetSB;
begin
if SBinit(adr,irq,dma)=false then sounds:=0
                                        else sounds:=2;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure NewFaller(fx,fy,ftype:integer);
var gy,oky:integer;
begin
oky:=0;
for gy:=1 to 5 do
begin
if (fallers[gy,1]=0) and (oky=0) then
begin
fallers[gy,1]:=ftype;
fallers[gy,2]:=fx;
fallers[gy,3]:=fy;
fallers[gy,4]:=random(5)-2;
fallers[gy,5]:=-(2+random(2));
oky:=1;
end;
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure DetermineShot;
begin
if (j=0) and (iwav=0) then photon[k,3]:=1;
if (j=1) and (iwav=0) then photon[k,3]:=4;
if (j=2) and (iwav=0) then photon[k,3]:=3;
if (j=3) and (iwav=0) then photon[k,3]:=4;
if (j=4) and (iwav=0) then photon[k,3]:=2;
if (j=0) and (iwav=1) then photon[k,3]:=3;
if (j=1) and (iwav=1) then photon[k,3]:=1;
if (j=2) and (iwav=1) then photon[k,3]:=1;
if (j=3) and (iwav=1) then photon[k,3]:=4;
if (j=4) and (iwav=1) then photon[k,3]:=2;
if (j=0) and (iwav=2) then photon[k,3]:=2;
if (j=1) and (iwav=2) then photon[k,3]:=1;
if (j=2) and (iwav=2) then photon[k,3]:=1;
if (j=3) and (iwav=2) then photon[k,3]:=4;
if (j=4) and (iwav=2) then photon[k,3]:=3;
if (j=0) and (iwav=3) then photon[k,3]:=4;
if (j=1) and (iwav=3) then photon[k,3]:=3;
if (j=2) and (iwav=3) then photon[k,3]:=2;
if (j=3) and (iwav=3) then photon[k,3]:=1;
if (j=4) and (iwav=3) then photon[k,3]:=3;
if (j=0) and (iwav=4) then photon[k,3]:=1;
if (j=1) and (iwav=4) then photon[k,3]:=4;
if (j=2) and (iwav=4) then photon[k,3]:=2;
if (j=3) and (iwav=4) then photon[k,3]:=3;
if (j=4) and (iwav=4) then photon[k,3]:=1;

if (j=0) and (iwav=0) then if (sounds=2) then PlayPho;
if (j=0) and (iwav=0) then pho:=10;
if (j=1) and (iwav=0) then if (sounds=2) then PlayBlt;
if (j=1) and (iwav=0) then blt:=6;
if (j=2) and (iwav=0) then if (sounds=2) then PlayFla;
if (j=2) and (iwav=0) then fla:=8;
if (j=3) and (iwav=0) then if (sounds=2) then PlayBlt;
if (j=3) and (iwav=0) then blt:=6;
if (j=4) and (iwav=0) then if (sounds=2) then PlaySli;
if (j=4) and (iwav=0) then sli:=8;
if (j=0) and (iwav=1) then if (sounds=2) then ;
if (j=0) and (iwav=1) then fla:=8;
if (j=1) and (iwav=1) then if (sounds=2) then ;
if (j=1) and (iwav=1) then pho:=10;
if (j=2) and (iwav=1) then if (sounds=2) then ;
if (j=2) and (iwav=1) then pho:=10;
if (j=3) and (iwav=1) then if (sounds=2) then ;
if (j=3) and (iwav=1) then blt:=6;
if (j=4) and (iwav=1) then if (sounds=2) then ;
if (j=4) and (iwav=1) then sli:=8;
if (j=0) and (iwav=2) then if (sounds=2) then ;
if (j=0) and (iwav=2) then sli:=8;
if (j=1) and (iwav=2) then if (sounds=2) then ;
if (j=1) and (iwav=2) then pho:=10;
if (j=2) and (iwav=2) then if (sounds=2) then ;
if (j=2) and (iwav=2) then pho:=10;
if (j=3) and (iwav=2) then if (sounds=2) then ;
if (j=3) and (iwav=2) then blt:=6;
if (j=4) and (iwav=2) then if (sounds=2) then ;
if (j=4) and (iwav=2) then fla:=8;
if (j=0) and (iwav=3) then if (sounds=2) then ;
if (j=0) and (iwav=3) then blt:=6;
if (j=1) and (iwav=3) then if (sounds=2) then ;
if (j=1) and (iwav=3) then fla:=8;
if (j=2) and (iwav=3) then if (sounds=2) then ;
if (j=2) and (iwav=3) then sli:=8;
if (j=3) and (iwav=3) then if (sounds=2) then ;
if (j=3) and (iwav=3) then pho:=10;
if (j=4) and (iwav=3) then if (sounds=2) then ;
if (j=4) and (iwav=3) then fla:=6;
if (j=0) and (iwav=4) then if (sounds=2) then ;
if (j=0) and (iwav=4) then pho:=10;
if (j=1) and (iwav=4) then if (sounds=2) then ;
if (j=1) and (iwav=4) then blt:=6;
if (j=2) and (iwav=4) then if (sounds=2) then ;
if (j=2) and (iwav=4) then sli:=8;
if (j=3) and (iwav=4) then if (sounds=2) then ;
if (j=3) and (iwav=4) then fla:=8;
if (j=4) and (iwav=4) then if (sounds=2) then ;
if (j=4) and (iwav=4) then pho:=12;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Invaders_Shoot;
begin
invx:=round(rinvx);
start:=random(10);
{ 1 }
for i:=start to 9 do
begin
fired_on_that_row:=false;
for j:=0 to 4 do
begin
Dosounds;
if (dispprot>(5-wave div 4)) and (alienz[i+1,j+1]=0) and (random(20)=1) then
if (fired_on_that_row=false) then
begin
fired_on_that_row:=true;
alienz[i+1,j+1]:=-15;
dispprot:=dispprot-1;
end;
end;
end;

end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure Invaders_Shoot2;
label ty;
begin
for i:=0 to 9 do
begin
for j:=0 to 4 do
begin
if (alienz[i+1,j+1]=-1) then begin
for k:=1 to 6 do
begin
if (photon[k,3]=0) then
begin
photon[k,1]:=4+invx+i*(16+invxdist);
photon[k,2]:=8+invy+j*(16+invydist);
DetermineShot;
goto ty
end;
end;
ty:
end;
end;
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure Invaders_Draw;
var janim:integer;
    adey:integer;
begin
for i:=1 to 5 do
begin
if fallers[i,1]=1 then putimg16(fallers[i,2],fallers[i,3],i1x,vaddr);
if fallers[i,1]=2 then putimg16(fallers[i,2],fallers[i,3],i2x,vaddr);
if fallers[i,1]=3 then putimg16(fallers[i,2],fallers[i,3],i3x,vaddr);
if fallers[i,1]=4 then putimg16(fallers[i,2],fallers[i,3],i4x,vaddr);
if fallers[i,1]=5 then putimg16(fallers[i,2],fallers[i,3],i5x,vaddr);
if fallers[i,1]>0 then
begin
fallers[i,2]:=fallers[i,2]+fallers[i,4];
fallers[i,3]:=fallers[i,3]+fallers[i,5];
if anim mod 3=0 then fallers[i,5]:=fallers[i,5]+1;
if fallers[i,5]>6 then fallers[i,5]:=6;
if fallers[i,2]<8 then
begin
fallers[i,2]:=8;
fallers[i,4]:=0-fallers[i,4];
end;
if fallers[i,2]>296 then
begin
fallers[i,2]:=296;
fallers[i,4]:=0-fallers[i,4];
end;
if fallers[i,3]<8 then
begin
fallers[i,3]:=8;
end;
if fallers[i,3]>180 then
begin
fallers[i,1]:=0;
end;
end;
end;
janim:=anim div 5;
invx:=round(rinvx);
for j:=0 to 9 do
begin
Dosounds;
adey:=0;
if (alienz[j+1,1]=0)and(((janim)+groove[j+1,1])mod 4=0)then putimg16(invx+j*(16+invxdist),invy+adey+0*(16+invydist),i11,vaddr);
if (alienz[j+1,1]=0)and(((janim)+groove[j+1,1])mod 4=1)then putimg16(invx+j*(16+invxdist),invy+adey+0*(16+invydist),i12,vaddr);
if (alienz[j+1,1]=0)and(((janim)+groove[j+1,1])mod 4=2)then putimg16(invx+j*(16+invxdist),invy+adey+0*(16+invydist),i13,vaddr);
if (alienz[j+1,1]=0)and(((janim)+groove[j+1,1])mod 4=3)then putimg16(invx+j*(16+invxdist),invy+adey+0*(16+invydist),i14,vaddr);
if (alienz[j+1,2]=0)and(((janim)+groove[j+1,2])mod 4=0)then putimg16(invx+j*(16+invxdist),invy+adey+1*(16+invydist),i21,vaddr);
if (alienz[j+1,2]=0)and(((janim)+groove[j+1,2])mod 4=1)then putimg16(invx+j*(16+invxdist),invy+adey+1*(16+invydist),i22,vaddr);
if (alienz[j+1,2]=0)and(((janim)+groove[j+1,2])mod 4=2)then putimg16(invx+j*(16+invxdist),invy+adey+1*(16+invydist),i23,vaddr);
if (alienz[j+1,2]=0)and(((janim)+groove[j+1,2])mod 4=3)then putimg16(invx+j*(16+invxdist),invy+adey+1*(16+invydist),i24,vaddr);
if (alienz[j+1,3]=0)and(((janim)+groove[j+1,3])mod 4=0)then putimg16(invx+j*(16+invxdist),invy+adey+2*(16+invydist),i31,vaddr);
if (alienz[j+1,3]=0)and(((janim)+groove[j+1,3])mod 4=1)then putimg16(invx+j*(16+invxdist),invy+adey+2*(16+invydist),i32,vaddr);
if (alienz[j+1,3]=0)and(((janim)+groove[j+1,3])mod 4=2)then putimg16(invx+j*(16+invxdist),invy+adey+2*(16+invydist),i33,vaddr);
if (alienz[j+1,3]=0)and(((janim)+groove[j+1,3])mod 4=3)then putimg16(invx+j*(16+invxdist),invy+adey+2*(16+invydist),i34,vaddr);
if (alienz[j+1,4]=0)and(((janim)+groove[j+1,4])mod 4=0)then putimg16(invx+j*(16+invxdist),invy+adey+3*(16+invydist),i41,vaddr);
if (alienz[j+1,4]=0)and(((janim)+groove[j+1,4])mod 4=1)then putimg16(invx+j*(16+invxdist),invy+adey+3*(16+invydist),i42,vaddr);
if (alienz[j+1,4]=0)and(((janim)+groove[j+1,4])mod 4=2)then putimg16(invx+j*(16+invxdist),invy+adey+3*(16+invydist),i43,vaddr);
if (alienz[j+1,4]=0)and(((janim)+groove[j+1,4])mod 4=3)then putimg16(invx+j*(16+invxdist),invy+adey+3*(16+invydist),i44,vaddr);
if (alienz[j+1,5]=0)and(((janim)+groove[j+1,5])mod 4=0)then putimg16(invx+j*(16+invxdist),invy+adey+4*(16+invydist),i51,vaddr);
if (alienz[j+1,5]=0)and(((janim)+groove[j+1,5])mod 4=1)then putimg16(invx+j*(16+invxdist),invy+adey+4*(16+invydist),i52,vaddr);
if (alienz[j+1,5]=0)and(((janim)+groove[j+1,5])mod 4=2)then putimg16(invx+j*(16+invxdist),invy+adey+4*(16+invydist),i53,vaddr);
if (alienz[j+1,5]=0)and(((janim)+groove[j+1,5])mod 4=3)then putimg16(invx+j*(16+invxdist),invy+adey+4*(16+invydist),i54,vaddr);
if (alienz[j+1,1]<0)and(anim mod 7<4)then putimg16(invx+j*(16+invxdist),invy+adey+0*(16+invydist),i1f,vaddr);
if (alienz[j+1,2]<0)and(anim mod 7<4)then putimg16(invx+j*(16+invxdist),invy+adey+1*(16+invydist),i2f,vaddr);
if (alienz[j+1,3]<0)and(anim mod 7<4)then putimg16(invx+j*(16+invxdist),invy+adey+2*(16+invydist),i3f,vaddr);
if (alienz[j+1,4]<0)and(anim mod 7<4)then putimg16(invx+j*(16+invxdist),invy+adey+3*(16+invydist),i4f,vaddr);
if (alienz[j+1,5]<0)and(anim mod 7<4)then putimg16(invx+j*(16+invxdist),invy+adey+4*(16+invydist),i5f,vaddr);
if (alienz[j+1,1]<0)and(anim mod 7>3)then putimg16(invx+j*(16+invxdist),invy+adey+0*(16+invydist),i1f,vaddr);
if (alienz[j+1,2]<0)and(anim mod 7>3)then putimg16(invx+j*(16+invxdist),invy+adey+1*(16+invydist),i2f,vaddr);
if (alienz[j+1,3]<0)and(anim mod 7>3)then putimg16(invx+j*(16+invxdist),invy+adey+2*(16+invydist),i3f,vaddr);
if (alienz[j+1,4]<0)and(anim mod 7>3)then putimg16(invx+j*(16+invxdist),invy+adey+3*(16+invydist),i4f,vaddr);
if (alienz[j+1,5]<0)and(anim mod 7>3)then putimg16(invx+j*(16+invxdist),invy+adey+4*(16+invydist),i5f,vaddr);
if (alienz[j+1,1]>0)and(alienz[j+1,1]<3)then putimg16(invx+j*(16+invxdist),invy+adey+0*(16+invydist),i1x,vaddr);
if (alienz[j+1,2]>0)and(alienz[j+1,2]<3)then putimg16(invx+j*(16+invxdist),invy+adey+1*(16+invydist),i2x,vaddr);
if (alienz[j+1,3]>0)and(alienz[j+1,3]<3)then putimg16(invx+j*(16+invxdist),invy+adey+2*(16+invydist),i3x,vaddr);
if (alienz[j+1,4]>0)and(alienz[j+1,4]<3)then putimg16(invx+j*(16+invxdist),invy+adey+3*(16+invydist),i4x,vaddr);
if (alienz[j+1,5]>0)and(alienz[j+1,5]<3)then putimg16(invx+j*(16+invxdist),invy+adey+4*(16+invydist),i5x,vaddr);
if (alienz[j+1,1]>2)and(alienz[j+1,1]<5)then putimg16(invx+j*(16+invxdist),invy+adey+0*(16+invydist)-2,i1x,vaddr);
if (alienz[j+1,2]>2)and(alienz[j+1,2]<5)then putimg16(invx+j*(16+invxdist),invy+adey+1*(16+invydist)-2,i2x,vaddr);
if (alienz[j+1,3]>2)and(alienz[j+1,3]<5)then putimg16(invx+j*(16+invxdist),invy+adey+2*(16+invydist)-2,i3x,vaddr);
if (alienz[j+1,4]>2)and(alienz[j+1,4]<5)then putimg16(invx+j*(16+invxdist),invy+adey+3*(16+invydist)-2,i4x,vaddr);
if (alienz[j+1,5]>2)and(alienz[j+1,5]<5)then putimg16(invx+j*(16+invxdist),invy+adey+4*(16+invydist)-2,i5x,vaddr);
if (alienz[j+1,1]>4)and(alienz[j+1,1]<7)then putimg16(invx+j*(16+invxdist),invy+adey+0*(16+invydist)-3,i1x,vaddr);
if (alienz[j+1,2]>4)and(alienz[j+1,2]<7)then putimg16(invx+j*(16+invxdist),invy+adey+1*(16+invydist)-3,i2x,vaddr);
if (alienz[j+1,3]>4)and(alienz[j+1,3]<7)then putimg16(invx+j*(16+invxdist),invy+adey+2*(16+invydist)-3,i3x,vaddr);
if (alienz[j+1,4]>4)and(alienz[j+1,4]<7)then putimg16(invx+j*(16+invxdist),invy+adey+3*(16+invydist)-3,i4x,vaddr);
if (alienz[j+1,5]>4)and(alienz[j+1,5]<7)then putimg16(invx+j*(16+invxdist),invy+adey+4*(16+invydist)-3,i5x,vaddr);
if (alienz[j+1,1]>6)and(alienz[j+1,1]<9)then putimg16(invx+j*(16+invxdist),invy+adey+0*(16+invydist)-4,i1x,vaddr);
if (alienz[j+1,2]>6)and(alienz[j+1,2]<9)then putimg16(invx+j*(16+invxdist),invy+adey+1*(16+invydist)-4,i2x,vaddr);
if (alienz[j+1,3]>6)and(alienz[j+1,3]<9)then putimg16(invx+j*(16+invxdist),invy+adey+2*(16+invydist)-4,i3x,vaddr);
if (alienz[j+1,4]>6)and(alienz[j+1,4]<9)then putimg16(invx+j*(16+invxdist),invy+adey+3*(16+invydist)-4,i4x,vaddr);
if (alienz[j+1,5]>6)and(alienz[j+1,5]<9)then putimg16(invx+j*(16+invxdist),invy+adey+4*(16+invydist)-4,i5x,vaddr);
if (alienz[j+1,1]>8)and(alienz[j+1,1]<11)then putimg16(invx+j*(16+invxdist),invy+adey+0*(16+invydist)-3,i1x,vaddr);
if (alienz[j+1,2]>8)and(alienz[j+1,2]<11)then putimg16(invx+j*(16+invxdist),invy+adey+1*(16+invydist)-3,i2x,vaddr);
if (alienz[j+1,3]>8)and(alienz[j+1,3]<11)then putimg16(invx+j*(16+invxdist),invy+adey+2*(16+invydist)-3,i3x,vaddr);
if (alienz[j+1,4]>8)and(alienz[j+1,4]<11)then putimg16(invx+j*(16+invxdist),invy+adey+3*(16+invydist)-3,i4x,vaddr);
if (alienz[j+1,5]>8)and(alienz[j+1,5]<11)then putimg16(invx+j*(16+invxdist),invy+adey+4*(16+invydist)-3,i5x,vaddr);
if (alienz[j+1,1]>10)and(alienz[j+1,1]<13)then putimg16(invx+j*(16+invxdist),invy+adey+0*(16+invydist)-2,i1x,vaddr);
if (alienz[j+1,2]>10)and(alienz[j+1,2]<13)then putimg16(invx+j*(16+invxdist),invy+adey+1*(16+invydist)-2,i2x,vaddr);
if (alienz[j+1,3]>10)and(alienz[j+1,3]<13)then putimg16(invx+j*(16+invxdist),invy+adey+2*(16+invydist)-2,i3x,vaddr);
if (alienz[j+1,4]>10)and(alienz[j+1,4]<13)then putimg16(invx+j*(16+invxdist),invy+adey+3*(16+invydist)-2,i4x,vaddr);
if (alienz[j+1,5]>10)and(alienz[j+1,5]<13)then putimg16(invx+j*(16+invxdist),invy+adey+4*(16+invydist)-2,i5x,vaddr);
end;
for i:=0 to 9 do
begin
for j:=0 to 4 do
begin
Dosounds;
if alienz[i+1,j+1]<0 then alienz[i+1,j+1]:=alienz[i+1,j+1]+1;
if (alienz[i+1,j+1]>0) and (alienz[i+1,j+1]<99) then alienz[i+1,j+1]:=alienz[i+1,j+1]+1;
if alienz[i+1,j+1]=13 then alienz[i+1,j+1]:=0;
end;
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure Invaders_Check;
begin
for i:=0 to 9 do
begin
for j:=0 to 4 do
begin
Ship_Check;
Dosounds;
for k:=1 to 4 do
begin
if laser[k,3]=1 then
begin
if (laser[k,1]>invx+i*(16+invxdist)) and (laser[k,1]<invx+16+i*(16+invxdist)) and (alienz[i+1,j+1]<1) and
(laser[k,2]+8>invy+j*(16+invydist)) and (laser[k,2]<invy+16+j*(16+invydist)) then
begin
if alienz[i+1,j+1]<0 then bonus:=bonus+1000;
alienz[i+1,j+1]:=1;
shields[i+1,j+1]:=shields[i+1,j+1]-1;
if shields[i+1,j+1]>0 then if sounds=2 then PlayHit;
if shields[i+1,j+1]=0 then
begin
alienz[i+1,j+1]:=99;
NewFaller(invx+i*(16+invxdist),invy+j*(16+invydist),j+1);
bonus:=bonus+(random(j)+1)*100;
bonus:=bonus+((20-(((invy+j*(16+invydist)) div 10))*10));
invkill:=invkill+1;
tfreq:=tfreq-25;
if tfreq<2 then tfreq:=2;
if sounds=2 then PlayAie;
end;
laser[k,3]:=0;
blt:=10;
end;
end;
end;
end;
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure Invaders_Move;
begin
if speed>1 then speed:=1;
rinvx:=rinvx+((direction)*speed);
if godown>0 then invy:=invy+1;
if godown>0 then godown:=godown-1;
maxleft:=false;
maxright:=false;
for i:=0 to 4 do
begin
DoSounds;
for j:=0 to 9 do
begin
if (alienz[j+1,i+1]<1) and ((invx+j*(16+invxdist))<13) then maxleft:=true;
if (alienz[j+1,i+1]<1) and ((invx+j*(16+invxdist))>291) then maxright:=true;
if (alienz[j+1,i+1]<1) and ((invy+i*(16+invydist))>184) and (boom=false) then doom:=true;
if (alienz[j+1,i+1]<1) and ((invy+i*(16+invydist))>184) then lives:=0;
if (alienz[j+1,i+1]<1) and ((invy+i*(16+invydist))>184) then invy:=invy-1;
end;
end;
if maxright then
begin
rinvx:=rinvx-1;
direction:=-1;
if (godown=0) then godown:=2;
if speed<1 then speed:=speed+0.02;
end;
if maxleft then
begin
rinvx:=rinvx+1;
direction:=1;
if (godown=0) then godown:=2;
if speed<1 then speed:=speed+0.02;
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure Invaders_Prepare;
begin
for i:=0 to 5 do
for j:=0 to 9 do alienz[j+1,i+1]:=0;
for i:=0 to 5 do
for j:=0 to 9 do shields[j+1,i+1]:=2+(wave div 3);
{}
if (sincro=true) then
begin
for i:=0 to 5 do
for j:=0 to 9 do groove[j+1,i+1]:=0;
end;

if (sincro=false) then
begin
for i:=0 to 5 do
for j:=0 to 9 do groove[j+1,i+1]:=((j+i) mod 4);
end;

tfreq:=2240-(wave*90);
invx:=14;
rinvx:=14;
invy:=12;
speed:=0.2+wave/160;
dispprot:=6;
direction:=1;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Indications;
const scorex=34;
begin
if lives=5 then putimg8(162,188,n5,vaddr);
if lives=4 then putimg8(162,188,n4,vaddr);
if lives=3 then putimg8(162,188,n3,vaddr);
if lives=2 then putimg8(162,188,n2,vaddr);
if lives=1 then putimg8(162,188,n1,vaddr);
if lives=0 then putimg8(162,188,n0,vaddr);
if   z=0 then putimg8(scorex+00,188,n0,vaddr);
if   s=0 then putimg8(scorex+08,188,n0,vaddr);
if   m=0 then putimg8(scorex+16,188,n0,vaddr);
if  zm=0 then putimg8(scorex+24,188,n0,vaddr);
if  sm=0 then putimg8(scorex+32,188,n0,vaddr);
if  ml=0 then putimg8(scorex+40,188,n0,vaddr);
if zml=0 then putimg8(scorex+48,188,n0,vaddr);
if   z=1 then putimg8(scorex+00,188,n1,vaddr);
if   s=1 then putimg8(scorex+08,188,n1,vaddr);
if   m=1 then putimg8(scorex+16,188,n1,vaddr);
if  zm=1 then putimg8(scorex+24,188,n1,vaddr);
if  sm=1 then putimg8(scorex+32,188,n1,vaddr);
if  ml=1 then putimg8(scorex+40,188,n1,vaddr);
if zml=1 then putimg8(scorex+48,188,n1,vaddr);
if   z=2 then putimg8(scorex+00,188,n2,vaddr);
if   s=2 then putimg8(scorex+08,188,n2,vaddr);
if   m=2 then putimg8(scorex+16,188,n2,vaddr);
if  zm=2 then putimg8(scorex+24,188,n2,vaddr);
if  sm=2 then putimg8(scorex+32,188,n2,vaddr);
if  ml=2 then putimg8(scorex+40,188,n2,vaddr);
if zml=2 then putimg8(scorex+48,188,n2,vaddr);
if   z=3 then putimg8(scorex+00,188,n3,vaddr);
if   s=3 then putimg8(scorex+08,188,n3,vaddr);
if   m=3 then putimg8(scorex+16,188,n3,vaddr);
if  zm=3 then putimg8(scorex+24,188,n3,vaddr);
if  sm=3 then putimg8(scorex+32,188,n3,vaddr);
if  ml=3 then putimg8(scorex+40,188,n3,vaddr);
if zml=3 then putimg8(scorex+48,188,n3,vaddr);
if   z=4 then putimg8(scorex+00,188,n4,vaddr);
if   s=4 then putimg8(scorex+08,188,n4,vaddr);
if   m=4 then putimg8(scorex+16,188,n4,vaddr);
if  zm=4 then putimg8(scorex+24,188,n4,vaddr);
if  sm=4 then putimg8(scorex+32,188,n4,vaddr);
if  ml=4 then putimg8(scorex+40,188,n4,vaddr);
if zml=4 then putimg8(scorex+48,188,n4,vaddr);
if   z=5 then putimg8(scorex+00,188,n5,vaddr);
if   s=5 then putimg8(scorex+08,188,n5,vaddr);
if   m=5 then putimg8(scorex+16,188,n5,vaddr);
if  zm=5 then putimg8(scorex+24,188,n5,vaddr);
if  sm=5 then putimg8(scorex+32,188,n5,vaddr);
if  ml=5 then putimg8(scorex+40,188,n5,vaddr);
if zml=5 then putimg8(scorex+48,188,n5,vaddr);
if   z=6 then putimg8(scorex+00,188,n6,vaddr);
if   s=6 then putimg8(scorex+08,188,n6,vaddr);
if   m=6 then putimg8(scorex+16,188,n6,vaddr);
if  zm=6 then putimg8(scorex+24,188,n6,vaddr);
if  sm=6 then putimg8(scorex+32,188,n6,vaddr);
if  ml=6 then putimg8(scorex+40,188,n6,vaddr);
if zml=6 then putimg8(scorex+48,188,n6,vaddr);
if   z=7 then putimg8(scorex+00,188,n7,vaddr);
if   s=7 then putimg8(scorex+08,188,n7,vaddr);
if   m=7 then putimg8(scorex+16,188,n7,vaddr);
if  zm=7 then putimg8(scorex+24,188,n7,vaddr);
if  sm=7 then putimg8(scorex+32,188,n7,vaddr);
if  ml=7 then putimg8(scorex+40,188,n7,vaddr);
if zml=7 then putimg8(scorex+48,188,n7,vaddr);
if   z=8 then putimg8(scorex+00,188,n8,vaddr);
if   s=8 then putimg8(scorex+08,188,n8,vaddr);
if   m=8 then putimg8(scorex+16,188,n8,vaddr);
if  zm=8 then putimg8(scorex+24,188,n8,vaddr);
if  sm=8 then putimg8(scorex+32,188,n8,vaddr);
if  ml=8 then putimg8(scorex+40,188,n8,vaddr);
if zml=8 then putimg8(scorex+48,188,n8,vaddr);
if   z=9 then putimg8(scorex+00,188,n9,vaddr);
if   s=9 then putimg8(scorex+08,188,n9,vaddr);
if   m=9 then putimg8(scorex+16,188,n9,vaddr);
if  zm=9 then putimg8(scorex+24,188,n9,vaddr);
if  sm=9 then putimg8(scorex+32,188,n9,vaddr);
if  ml=9 then putimg8(scorex+40,188,n9,vaddr);
if zml=9 then putimg8(scorex+48,188,n9,vaddr);
if hz=0 then putimg8(hiscorex+00,hiscorey,n0,vaddr);
if hs=0 then putimg8(hiscorex+08,hiscorey,n0,vaddr);
if hm=0 then putimg8(hiscorex+16,hiscorey,n0,vaddr);
if hzm=0 then putimg8(hiscorex+24,hiscorey,n0,vaddr);
if hsm=0 then putimg8(hiscorex+32,hiscorey,n0,vaddr);
if hml=0 then putimg8(hiscorex+40,hiscorey,n0,vaddr);
if hzml=0 then putimg8(hiscorex+48,hiscorey,n0,vaddr);
if hz=1 then putimg8(hiscorex+00,hiscorey,n1,vaddr);
if hs=1 then putimg8(hiscorex+08,hiscorey,n1,vaddr);
if hm=1 then putimg8(hiscorex+16,hiscorey,n1,vaddr);
if hzm=1 then putimg8(hiscorex+24,hiscorey,n1,vaddr);
if hsm=1 then putimg8(hiscorex+32,hiscorey,n1,vaddr);
if hml=1 then putimg8(hiscorex+40,hiscorey,n1,vaddr);
if hzml=1 then putimg8(hiscorex+48,hiscorey,n1,vaddr);
if hz=2 then putimg8(hiscorex+00,hiscorey,n2,vaddr);
if hs=2 then putimg8(hiscorex+08,hiscorey,n2,vaddr);
if hm=2 then putimg8(hiscorex+16,hiscorey,n2,vaddr);
if hzm=2 then putimg8(hiscorex+24,hiscorey,n2,vaddr);
if hsm=2 then putimg8(hiscorex+32,hiscorey,n2,vaddr);
if hml=2 then putimg8(hiscorex+40,hiscorey,n2,vaddr);
if hzml=2 then putimg8(hiscorex+48,hiscorey,n2,vaddr);
if hz=3 then putimg8(hiscorex+00,hiscorey,n3,vaddr);
if hs=3 then putimg8(hiscorex+08,hiscorey,n3,vaddr);
if hm=3 then putimg8(hiscorex+16,hiscorey,n3,vaddr);
if hzm=3 then putimg8(hiscorex+24,hiscorey,n3,vaddr);
if hsm=3 then putimg8(hiscorex+32,hiscorey,n3,vaddr);
if hml=3 then putimg8(hiscorex+40,hiscorey,n3,vaddr);
if hzml=3 then putimg8(hiscorex+48,hiscorey,n3,vaddr);
if hz=4 then putimg8(hiscorex+00,hiscorey,n4,vaddr);
if hs=4 then putimg8(hiscorex+08,hiscorey,n4,vaddr);
if hm=4 then putimg8(hiscorex+16,hiscorey,n4,vaddr);
if hzm=4 then putimg8(hiscorex+24,hiscorey,n4,vaddr);
if hsm=4 then putimg8(hiscorex+32,hiscorey,n4,vaddr);
if hml=4 then putimg8(hiscorex+40,hiscorey,n4,vaddr);
if hzml=4 then putimg8(hiscorex+48,hiscorey,n4,vaddr);
if hz=5 then putimg8(hiscorex+00,hiscorey,n5,vaddr);
if hs=5 then putimg8(hiscorex+08,hiscorey,n5,vaddr);
if hm=5 then putimg8(hiscorex+16,hiscorey,n5,vaddr);
if hzm=5 then putimg8(hiscorex+24,hiscorey,n5,vaddr);
if hsm=5 then putimg8(hiscorex+32,hiscorey,n5,vaddr);
if hml=5 then putimg8(hiscorex+40,hiscorey,n5,vaddr);
if hzml=5 then putimg8(hiscorex+48,hiscorey,n5,vaddr);
if hz=6 then putimg8(hiscorex+00,hiscorey,n6,vaddr);
if hs=6 then putimg8(hiscorex+08,hiscorey,n6,vaddr);
if hm=6 then putimg8(hiscorex+16,hiscorey,n6,vaddr);
if hzm=6 then putimg8(hiscorex+24,hiscorey,n6,vaddr);
if hsm=6 then putimg8(hiscorex+32,hiscorey,n6,vaddr);
if hml=6 then putimg8(hiscorex+40,hiscorey,n6,vaddr);
if hzml=6 then putimg8(hiscorex+48,hiscorey,n6,vaddr);
if hz=7 then putimg8(hiscorex+00,hiscorey,n7,vaddr);
if hs=7 then putimg8(hiscorex+08,hiscorey,n7,vaddr);
if hm=7 then putimg8(hiscorex+16,hiscorey,n7,vaddr);
if hzm=7 then putimg8(hiscorex+24,hiscorey,n7,vaddr);
if hsm=7 then putimg8(hiscorex+32,hiscorey,n7,vaddr);
if hml=7 then putimg8(hiscorex+40,hiscorey,n7,vaddr);
if hzml=7 then putimg8(hiscorex+48,hiscorey,n7,vaddr);
if hz=8 then putimg8(hiscorex+00,hiscorey,n8,vaddr);
if hs=8 then putimg8(hiscorex+08,hiscorey,n8,vaddr);
if hm=8 then putimg8(hiscorex+16,hiscorey,n8,vaddr);
if hzm=8 then putimg8(hiscorex+24,hiscorey,n8,vaddr);
if hsm=8 then putimg8(hiscorex+32,hiscorey,n8,vaddr);
if hml=8 then putimg8(hiscorex+40,hiscorey,n8,vaddr);
if hzml=8 then putimg8(hiscorex+48,hiscorey,n8,vaddr);
if hz=9 then putimg8(hiscorex+00,hiscorey,n9,vaddr);
if hs=9 then putimg8(hiscorex+08,hiscorey,n9,vaddr);
if hm=9 then putimg8(hiscorex+16,hiscorey,n9,vaddr);
if hzm=9 then putimg8(hiscorex+24,hiscorey,n9,vaddr);
if hsm=9 then putimg8(hiscorex+32,hiscorey,n9,vaddr);
if hml=9 then putimg8(hiscorex+40,hiscorey,n9,vaddr);
if hzml=9 then putimg8(hiscorex+48,hiscorey,n9,vaddr);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure ShowWave;
begin
flip(vaddr2,vaddr);
lives:=lives-1;
Indications;
lives:=lives+1;
putimg16(wavdx-070,wavdy,logo2,vaddr);
putimg16(wavdx-061,wavdy,logo1,vaddr);
putimg16(wavdx-052,wavdy,logo3,vaddr);
putimg16(wavdx-043,wavdy,logoa,vaddr);
putimg16(wavdx-034,wavdy,logo9,vaddr);
putimg16(wavdx-025,wavdy,logob,vaddr);
putimg16(wavdx-016,wavdy,logo9,vaddr);
if ((wave-(wave mod 10)) div 10)=0 then putimg16(wavdx,wavdy,nr0,vaddr);
if ((wave-(wave mod 10)) div 10)=1 then putimg16(wavdx,wavdy,nr1,vaddr);
if ((wave-(wave mod 10)) div 10)=2 then putimg16(wavdx,wavdy,nr2,vaddr);
if ((wave-(wave mod 10)) div 10)=3 then putimg16(wavdx,wavdy,nr3,vaddr);
if ((wave-(wave mod 10)) div 10)=4 then putimg16(wavdx,wavdy,nr4,vaddr);
if ((wave-(wave mod 10)) div 10)=5 then putimg16(wavdx,wavdy,nr5,vaddr);
if ((wave-(wave mod 10)) div 10)=6 then putimg16(wavdx,wavdy,nr6,vaddr);
if ((wave-(wave mod 10)) div 10)=7 then putimg16(wavdx,wavdy,nr7,vaddr);
if ((wave-(wave mod 10)) div 10)=8 then putimg16(wavdx,wavdy,nr8,vaddr);
if ((wave-(wave mod 10)) div 10)=9 then putimg16(wavdx,wavdy,nr9,vaddr);
if wave mod 10=0 then putimg16(wavdx+9,wavdy,nr0,vaddr);
if wave mod 10=1 then putimg16(wavdx+9,wavdy,nr1,vaddr);
if wave mod 10=2 then putimg16(wavdx+9,wavdy,nr2,vaddr);
if wave mod 10=3 then putimg16(wavdx+9,wavdy,nr3,vaddr);
if wave mod 10=4 then putimg16(wavdx+9,wavdy,nr4,vaddr);
if wave mod 10=5 then putimg16(wavdx+9,wavdy,nr5,vaddr);
if wave mod 10=6 then putimg16(wavdx+9,wavdy,nr6,vaddr);
if wave mod 10=7 then putimg16(wavdx+9,wavdy,nr7,vaddr);
if wave mod 10=8 then putimg16(wavdx+9,wavdy,nr8,vaddr);
if wave mod 10=9 then putimg16(wavdx+9,wavdy,nr9,vaddr);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure AddScore;
begin
for i:=1 to 10 do
begin
if bonus>0 then zml:=zml+2;
if bonus>0 then bonus:=bonus-2;
if zml>9 then
begin
ml:=ml+1;
zml:=0;
end;
if ml>9 then
begin
sm:=sm+1;
ml:=0;
end;
if sm>9 then
begin
zm:=zm+1;
sm:=0;
end;
if zm>9 then
begin
m:=m+1;
zm:=0;
end;
if m>9 then
begin
s:=s+1;
m:=0;
end;
if s>9 then
begin
z:=z+1;
s:=0;
end;
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure LoadPcx(name:string;where:word);
var offset:word;
    leng:byte;
    datar:byte;
    pcxf:file of byte;
label looped,donel;
begin
assign(pcxf,name);
reset(pcxf);
offset:=0;
seek(pcxf,128);
looped:
if offset>63999 then goto donel;
read(pcxf,leng);
if leng<193 then mem[where:offset]:=leng;
if leng<193 then inc(offset);
if leng<193 then goto looped;
read(pcxf,datar);
for i:=1 to (leng-192) do begin
mem[where:offset]:=datar;
inc(offset);
end;
goto looped;
donel:
close(pcxf);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure LoadInvSpr;
begin
if iwav=0 then
begin
loadimg16('I1F.SPR     ',000,i1f);
loadimg16('I2F.SPR     ',000,i2f);
loadimg16('I3F.SPR     ',000,i3f);
loadimg16('I4F.SPR     ',000,i4f);
loadimg16('I5F.SPR     ',000,i5f);
loadimg16('I1X.SPR     ',000,i1x);
loadimg16('I2X.SPR     ',000,i2x);
loadimg16('I3X.SPR     ',000,i3x);
loadimg16('I4X.SPR     ',000,i4x);
loadimg16('I5X.SPR     ',000,i5x);
loadimg16('I11.SPR     ',000,i11);
loadimg16('I12.SPR     ',000,i12);
loadimg16('I13.SPR     ',000,i13);
loadimg16('I14.SPR     ',000,i14);
loadimg16('I21.SPR     ',000,i21);
loadimg16('I22.SPR     ',000,i22);
loadimg16('I23.SPR     ',000,i23);
loadimg16('I24.SPR     ',000,i24);
loadimg16('I31.SPR     ',000,i31);
loadimg16('I32.SPR     ',000,i32);
loadimg16('I33.SPR     ',000,i33);
loadimg16('I34.SPR     ',000,i34);
loadimg16('I41.SPR     ',000,i41);
loadimg16('I42.SPR     ',000,i42);
loadimg16('I43.SPR     ',000,i43);
loadimg16('I44.SPR     ',000,i44);
loadimg16('I51.SPR     ',000,i51);
loadimg16('I52.SPR     ',000,i52);
loadimg16('I53.SPR     ',000,i53);
loadimg16('I54.SPR     ',000,i54);
end;
if iwav=1 then
begin
loadimg16('I6F.SPR     ',000,i1f);
loadimg16('I7F.SPR     ',000,i2f);
loadimg16('I8F.SPR     ',000,i3f);
loadimg16('I9F.SPR     ',000,i4f);
loadimg16('IAF.SPR     ',000,i5f);
loadimg16('I6X.SPR     ',000,i1x);
loadimg16('I7X.SPR     ',000,i2x);
loadimg16('I8X.SPR     ',000,i3x);
loadimg16('I9X.SPR     ',000,i4x);
loadimg16('IAX.SPR     ',000,i5x);
loadimg16('I61.SPR     ',000,i11);
loadimg16('I62.SPR     ',000,i12);
loadimg16('I63.SPR     ',000,i13);
loadimg16('I64.SPR     ',000,i14);
loadimg16('I71.SPR     ',000,i21);
loadimg16('I72.SPR     ',000,i22);
loadimg16('I73.SPR     ',000,i23);
loadimg16('I74.SPR     ',000,i24);
loadimg16('I81.SPR     ',000,i31);
loadimg16('I82.SPR     ',000,i32);
loadimg16('I83.SPR     ',000,i33);
loadimg16('I84.SPR     ',000,i34);
loadimg16('I91.SPR     ',000,i41);
loadimg16('I92.SPR     ',000,i42);
loadimg16('I93.SPR     ',000,i43);
loadimg16('I94.SPR     ',000,i44);
loadimg16('IA1.SPR     ',000,i51);
loadimg16('IA2.SPR     ',000,i52);
loadimg16('IA3.SPR     ',000,i53);
loadimg16('IA4.SPR     ',000,i54);
end;
if iwav=2 then
begin
loadimg16('IBF.SPR     ',000,i1f);
loadimg16('ICF.SPR     ',000,i2f);
loadimg16('IDF.SPR     ',000,i3f);
loadimg16('IEF.SPR     ',000,i4f);
loadimg16('IFF.SPR     ',000,i5f);
loadimg16('IBX.SPR     ',000,i1x);
loadimg16('ICX.SPR     ',000,i2x);
loadimg16('IDX.SPR     ',000,i3x);
loadimg16('IEX.SPR     ',000,i4x);
loadimg16('IFX.SPR     ',000,i5x);
loadimg16('IB1.SPR     ',000,i11);
loadimg16('IB2.SPR     ',000,i12);
loadimg16('IB3.SPR     ',000,i13);
loadimg16('IB4.SPR     ',000,i14);
loadimg16('IC1.SPR     ',000,i21);
loadimg16('IC2.SPR     ',000,i22);
loadimg16('IC3.SPR     ',000,i23);
loadimg16('IC4.SPR     ',000,i24);
loadimg16('ID1.SPR     ',000,i31);
loadimg16('ID2.SPR     ',000,i32);
loadimg16('ID3.SPR     ',000,i33);
loadimg16('ID4.SPR     ',000,i34);
loadimg16('IE1.SPR     ',000,i41);
loadimg16('IE2.SPR     ',000,i42);
loadimg16('IE3.SPR     ',000,i43);
loadimg16('IE4.SPR     ',000,i44);
loadimg16('IF1.SPR     ',000,i51);
loadimg16('IF2.SPR     ',000,i52);
loadimg16('IF3.SPR     ',000,i53);
loadimg16('IF4.SPR     ',000,i54);
end;
if iwav=3 then
begin
loadimg16('IGF.SPR     ',000,i1f);
loadimg16('IHF.SPR     ',000,i2f);
loadimg16('IIF.SPR     ',000,i3f);
loadimg16('IJF.SPR     ',000,i4f);
loadimg16('IKF.SPR     ',000,i5f);
loadimg16('IGX.SPR     ',000,i1x);
loadimg16('IHX.SPR     ',000,i2x);
loadimg16('IIX.SPR     ',000,i3x);
loadimg16('IJX.SPR     ',000,i4x);
loadimg16('IKX.SPR     ',000,i5x);
loadimg16('IG1.SPR     ',000,i11);
loadimg16('IG2.SPR     ',000,i12);
loadimg16('IG3.SPR     ',000,i13);
loadimg16('IG4.SPR     ',000,i14);
loadimg16('IH1.SPR     ',000,i21);
loadimg16('IH2.SPR     ',000,i22);
loadimg16('IH3.SPR     ',000,i23);
loadimg16('IH4.SPR     ',000,i24);
loadimg16('II1.SPR     ',000,i31);
loadimg16('II2.SPR     ',000,i32);
loadimg16('II3.SPR     ',000,i33);
loadimg16('II4.SPR     ',000,i34);
loadimg16('IJ1.SPR     ',000,i41);
loadimg16('IJ2.SPR     ',000,i42);
loadimg16('IJ3.SPR     ',000,i43);
loadimg16('IJ4.SPR     ',000,i44);
loadimg16('IK1.SPR     ',000,i51);
loadimg16('IK2.SPR     ',000,i52);
loadimg16('IK3.SPR     ',000,i53);
loadimg16('IK4.SPR     ',000,i54);
end;
if iwav=4 then
begin
loadimg16('ILF.SPR     ',000,i1f);
loadimg16('IMF.SPR     ',000,i2f);
loadimg16('INF.SPR     ',000,i3f);
loadimg16('IOF.SPR     ',000,i4f);
loadimg16('IPF.SPR     ',000,i5f);
loadimg16('ILX.SPR     ',000,i1x);
loadimg16('IMX.SPR     ',000,i2x);
loadimg16('INX.SPR     ',000,i3x);
loadimg16('IOX.SPR     ',000,i4x);
loadimg16('IPX.SPR     ',000,i5x);
loadimg16('IL1.SPR     ',000,i11);
loadimg16('IL2.SPR     ',000,i12);
loadimg16('IL3.SPR     ',000,i13);
loadimg16('IL4.SPR     ',000,i14);
loadimg16('IM1.SPR     ',000,i21);
loadimg16('IM2.SPR     ',000,i22);
loadimg16('IM3.SPR     ',000,i23);
loadimg16('IM4.SPR     ',000,i24);
loadimg16('IN1.SPR     ',000,i31);
loadimg16('IN2.SPR     ',000,i32);
loadimg16('IN3.SPR     ',000,i33);
loadimg16('IN4.SPR     ',000,i34);
loadimg16('IO1.SPR     ',000,i41);
loadimg16('IO2.SPR     ',000,i42);
loadimg16('IO3.SPR     ',000,i43);
loadimg16('IO4.SPR     ',000,i44);
loadimg16('IP1.SPR     ',000,i51);
loadimg16('IP2.SPR     ',000,i52);
loadimg16('IP3.SPR     ',000,i53);
loadimg16('IP4.SPR     ',000,i54);
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure Animate;
begin
anim:=anim+1;
if anim>19 then anim:=0;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure WiggleLogo;
begin
Putimg16(logox+000+00,logoy+fluct1,logo1,vaddr);
Putimg16(logox+008+01,logoy+fluct2,logo2,vaddr);
Putimg16(logox+016+02,logoy+fluct3,logo3,vaddr);
Putimg16(logox+024+03,logoy+fluct4,logo4,vaddr);
Putimg16(logox+032+04,logoy+fluct1,logo5,vaddr);
Putimg16(logox+040+05,logoy+fluct2,logo1,vaddr);
Putimg16(logox+048+06,logoy+fluct3,logo1,vaddr);
Putimg16(logox+064+07,logoy+fluct4,logo6,vaddr);
Putimg16(logox+072+08,logoy+fluct1,logo7,vaddr);
Putimg16(logox+080+09,logoy+fluct2,logo4,vaddr);
Putimg16(logox+088+10,logoy+fluct3,logo8,vaddr);
Putimg16(logox+096+11,logoy+fluct4,logo1,vaddr);
Putimg16(logox+104+12,logoy+fluct1,logo4,vaddr);
Putimg16(logox+112+13,logoy+fluct2,logo9,vaddr);
Putimg16(logox+120+14,logoy+fluct3,logoa,vaddr);

Putimg8(056+00,170,slc,vaddr);

Putimg8(056+16,170,slb,vaddr);
Putimg8(056+24,170,sl9,vaddr);
Putimg8(056+32,170,sl9,vaddr);
Putimg8(056+40,170,sla,vaddr);

Putimg8(056+56,170,sl1,vaddr);
Putimg8(056+64,170,sl2,vaddr);
Putimg8(056+72,170,sl3,vaddr);
Putimg8(056+80,170,sl4,vaddr);

Putimg8(056+96,170,sl5,vaddr);
Putimg8(056+104,170,sl6,vaddr);
Putimg8(056+112,170,sl2,vaddr);
Putimg8(056+120,170,sl7,vaddr);
Putimg8(056+128,170,sl8,vaddr);
Putimg8(056+136,170,sl2,vaddr);
Putimg8(056+144,170,sle,vaddr);
Putimg8(056+152,170,sl3,vaddr);

Putimg8(056+168,170,sld,vaddr);
Putimg8(056+176,170,sl2,vaddr);
Putimg8(056+184,170,sl6,vaddr);
Putimg8(056+192,170,sl5,vaddr);
Putimg8(056+200,170,slf,vaddr);
Putimg8(056+208,170,sle,vaddr);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure ResetVar;
begin
mpos:=0;
mpos2:=0;
bum:=0;
las:=0;
pho:=0;
fla:=0;
blt:=0;
sli:=0;
lives:=5;
wave:=0;
fayd:=31;
boom:=false;
doom:=false;
anim:=0;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure ManageSounds;
begin
if bum>0 then bum:=bum-1;
if bum<0 then bum:=0;
if las>0 then las:=las-1;
if las<0 then las:=0;
if pho>0 then pho:=pho-1;
if pho<0 then pho:=0;
if sli>0 then sli:=sli-1;
if sli<0 then sli:=0;
if fla>0 then fla:=fla-1;
if fla<0 then fla:=0;
if blt>0 then blt:=blt-1;
if blt<0 then blt:=0;
if clic>0 then clic:=clic-1;
if clic<0 then clic:=0;
if doom then bum:=1+(0-fayd)*5;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure DoSounds;
var snd:integer;
begin
snd:=0;
if (sounds=1) then
begin
if clic>0 then snd:=10+(clic*1000);
if las>0 then snd:=10+(las*500);
if bum>0 then snd:=50+random(20*bum);
if fla>0 then snd:=10+random((fla*100));
if pho>0 then snd:=(10+(pho*pho*pho*pho))-((anim mod 2)*50);
if blt>0 then snd:=700+random(blt*150);
if sli>0 then snd:=10+random(sli*sli*sli*50);
end;
if snd<>0 then sound(snd);
if (snd=0) and (olsnd<>0) then nosound;
olsnd:=snd;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure Ship_Fire;
begin
if (space) and (bload=0) then
begin
for j:=1 to 4 do
begin
if (laser[j,3]=0) then
begin
laser[j,1]:=shipx+7;
laser[j,2]:=shipy;
laser[j,3]:=1;
las:=10;
if (sounds=2) then PlayLas;
break;
end;
end;
bload:=25;
end;
if (hold=1) and (not space) then hold:=0;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure Ship_Draw;
begin
if (boom=false) and (not tleft) and (not tright) then putimg16(shipx,shipy,shipf,vaddr);
if (boom=false) and (    tleft) and (    tright) then putimg16(shipx,shipy,shipf,vaddr);
if (boom=false) and (not tleft) and (    tright) then putimg16(shipx,shipy,shipr,vaddr);
if (boom=false) and (    tleft) and (not tright) then putimg16(shipx,shipy,shipl,vaddr);
if (boom=false) and (shield>0) and (shield<41) and (anim mod 4<2) then putimg16(shipx,shipy,bubbleshield,vaddr);
if (boom=true) and (bam div 3=0) then PutImg24(shipx-4,shipy-4,expl1,vaddr);
if (boom=true) and (bam div 3=1) then PutImg24(shipx-4,shipy-4,expl2,vaddr);
if (boom=true) and (bam div 3=2) then PutImg24(shipx-4,shipy-4,expl3,vaddr);
if (boom=true) and (bam div 3=3) then PutImg24(shipx-4,shipy-4,expl4,vaddr);
if (boom=true) and (bam div 3=4) then PutImg24(shipx-4,shipy-4,expl5,vaddr);
if (boom=true) and (bam div 3=5) then PutImg24(shipx-4,shipy-4,expl6,vaddr);
if (boom=true) and (bam div 3=6) then PutImg24(shipx-4,shipy-4,expl7,vaddr);
if (boom=true) and (bam div 3=7) then PutImg24(shipx-4,shipy-4,expl8,vaddr);
if (boom=true) and (bam div 3=8) then PutImg24(shipx-4,shipy-4,expl9,vaddr);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure Ship_Check;
begin
if doom=true then shield:=200;
if ((shipx+16)>(invx+i*(16+invxdist))) and ((shipx)<(invx+16+i*(16+invxdist))) and (alienz[i+1,j+1]=0) and (shield=0) and
((shipy+16)>(invy+j*18)) and (shipy<invy+16+j*18) and (boom=false) then
begin
bum:=20+random(15);
mpos:=261;
boom:=true;
if (sounds=2) then PlayBum;
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure Ship_Move;
begin
tleft:=false;
tright:=false;
if (left) and (boom=false) then
begin
tleft:=true;
shipx:=shipx-2;
end;
if (right) and (boom=false)  then
begin
tright:=true;
shipx:=shipx+2;
end;
if (shield>0) and (anim mod 16=0) then shield:=shield-1;
if shield<0 then shield:=0;
if shipx+16>306 then shipx:=306-16;
if shipx<12 then shipx:=12;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure Ship_Prepare;
begin
for j:=1 to 4 do laser[j,3]:=0;
shipx:=152;
doom:=false;
boom:=false;
done:=false;
fayd:=20;
shield:=30;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure Lasers_Move;
begin
if bload>0 then bload:=bload-1;
if bload<0 then bload:=0;
for j:=1 to 4 do
begin
DoSounds;
if (laser[j,3]=1) then
begin
for i:=0 to 8 do
begin
if (laser[j,2]+i>7) then Pixel(laser[j,1],laser[j,2]+i,47-i,vaddr);
end;
laser[j,2]:=laser[j,2]-3;
if laser[j,2]<-16 then laser[j,3]:=0;
end;
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure Bombs_Move;
begin
for j:=1 to 6 do
begin
Dosounds;
if (photon[j,3]=1) then
begin
if ((anim div 5)=0) then Putimg8(photon[j,1],photon[j,2],ibul11,vaddr);
if ((anim div 5)=1) then Putimg8(photon[j,1],photon[j,2],ibul12,vaddr);
if ((anim div 5)=2) then Putimg8(photon[j,1],photon[j,2],ibul13,vaddr);
if ((anim div 5)=3) then Putimg8(photon[j,1],photon[j,2],ibul12,vaddr);
photon[j,2]:=photon[j,2]+2;
if photon[j,2]>190 then photon[j,3]:=0;
if photon[j,2]>190 then dispprot:=dispprot+1;
if (photon[j,1]+8>shipx) and (photon[j,1]<shipx+16) and (shield=0) and
(photon[j,2]>shipy-8) and (photon[j,2]<shipy+16) then
begin
mpos:=261;
if (not boom) then if (sounds=2) then PlayBum;
bum:=20+random(15);
boom:=true;
end;
end;
if (photon[j,3]=2) then
begin
if ((anim div 5)=0) then Putimg8(photon[j,1],photon[j,2],ibul21,vaddr);
if ((anim div 5)=1) then Putimg8(photon[j,1],photon[j,2],ibul22,vaddr);
if ((anim div 5)=2) then Putimg8(photon[j,1],photon[j,2],ibul23,vaddr);
if ((anim div 5)=3) then Putimg8(photon[j,1],photon[j,2],ibul22,vaddr);
if photon[j,1]<0 then photon[j,1]:=0;
if photon[j,1]>311 then photon[j,1]:=311;
photon[j,2]:=photon[j,2]+2;
if photon[j,2]>190 then photon[j,3]:=0;
if photon[j,2]>190 then dispprot:=dispprot+1;
if (photon[j,1]+8>shipx) and (photon[j,1]<shipx+16) and (shield=0) and
(photon[j,2]>shipy-8) and (photon[j,2]<shipy+16) then
begin
mpos:=261;
if (not boom) then if (sounds=2) then PlayBum;
bum:=20+random(15);
boom:=true;
end;
end;
if (photon[j,3]=3) then
begin
if ((anim div 5)=0) then Putimg8(photon[j,1],photon[j,2],ibul31,vaddr);
if ((anim div 5)=1) then Putimg8(photon[j,1],photon[j,2],ibul32,vaddr);
if ((anim div 5)=2) then Putimg8(photon[j,1],photon[j,2],ibul33,vaddr);
if ((anim div 5)=3) then Putimg8(photon[j,1],photon[j,2],ibul32,vaddr);
photon[j,1]:=photon[j,1]+((-9+anim) div 5);
if photon[j,1]<0 then photon[j,1]:=0;
if photon[j,1]>311 then photon[j,1]:=311;
photon[j,2]:=photon[j,2]+2;
if photon[j,2]>190 then photon[j,3]:=0;
if photon[j,2]>190 then dispprot:=dispprot+1;
if (photon[j,1]+8>shipx) and (photon[j,1]<shipx+16) and (shield=0) and
(photon[j,2]>shipy-8) and (photon[j,2]<shipy+16) then
begin
mpos:=261;
if (not boom) then if (sounds=2) then PlayBum;
bum:=20+random(15);
boom:=true;
end;
end;
if (photon[j,3]=4) then
begin
if ((anim div 5)=0) then Putimg8(photon[j,1],photon[j,2],ibul41,vaddr);
if ((anim div 5)=1) then Putimg8(photon[j,1],photon[j,2],ibul42,vaddr);
if ((anim div 5)=2) then Putimg8(photon[j,1],photon[j,2],ibul43,vaddr);
if ((anim div 5)=3) then Putimg8(photon[j,1],photon[j,2],ibul42,vaddr);
if photon[j,1]<0 then photon[j,1]:=0;
if photon[j,1]>311 then photon[j,1]:=311;
photon[j,2]:=photon[j,2]+2;
if photon[j,2]>190 then photon[j,3]:=0;
if photon[j,2]>190 then dispprot:=dispprot+1;
if (photon[j,1]+8>shipx) and (photon[j,1]<shipx+16) and (shield=0) and
(photon[j,2]>shipy-8) and (photon[j,2]<shipy+16) then
begin
mpos:=261;
if (not boom) then if (sounds=2) then PlayBum;
bum:=20+random(15);
boom:=true;
end;
end;
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure DrawStatusBar;
begin
DoSounds;
for i:=0 to 19 do
begin
if i=00 then putimg16(i*16,184,bar1,vaddr);
if i=01 then putimg16(i*16,184,bar7,vaddr);
if i=02 then putimg16(i*16,184,bar5,vaddr);
if i=03 then putimg16(i*16,184,bar5,vaddr);
if i=04 then putimg16(i*16,184,bar5,vaddr);
if i=05 then putimg16(i*16,184,bar6,vaddr);
if (i>05) and (i<09) then putimg16(i*16,184,bar2,vaddr);
if i=09 then putimg16(i*16,184,bar4,vaddr);
if i=10 then putimg16(i*16,184,bar6,vaddr);
if (i>10) and (i<14) then putimg16(i*16,184,bar2,vaddr);
if i=14 then putimg16(i*16,184,bar8,vaddr);
if i=15 then putimg16(i*16,184,bar5,vaddr);
if i=16 then putimg16(i*16,184,bar5,vaddr);
if i=17 then putimg16(i*16,184,bar5,vaddr);
if i=18 then putimg16(i*16,184,bar6,vaddr);
if i=19 then putimg16(i*16,184,bar3,vaddr);
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure ManageFade;
begin
if (done=true) and (anim mod 4=0) then fayd:=fayd+3;
if (boom=true) and (bam>16) and (anim mod 4=0) then fayd:=fayd+3;
if (boom=false) and (done=false) and (anim mod 4=0) and (fayd>0) then fayd:=fayd-2;
if (doom=true) and (anim mod 3=0) then fayd:=fayd-1;
if (doom=true) and (anim mod 10=0) then fayd:=fayd+2;
if (bam=1) then
begin
mess:=fayd;
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure HandleExitEvents;
begin
if (alt) and (F2_) then
begin
zml:=0;
ml:=0;
sm:=0;
zm:=0;
m:=0;
s:=0;
z:=0;
invkill:=50;
end;
if (alt) and (F3_) then
begin
zml:=0;
ml:=0;
sm:=0;
zm:=0;
m:=0;
s:=0;
z:=0;
wave:=20;
invkill:=50;
end;
if (alt) and (F4_) then
begin
zml:=0;
ml:=0;
sm:=0;
zm:=0;
m:=0;
s:=0;
z:=0;
lives:=lives+1;
if lives>5 then lives:=5;
end;
if (done=false) and (invkill=50) and (boom=false) then
begin
done:=true;
mpos:=261;
end;

end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure LoadHiScore;
begin
assign(f,'inv.sco');
{$I-}
reset(f);
{$I+}
if IOresult<>0 then
begin
hz:=0;
rewrite(f);
write (f,hz,hz,hz,hz,hz,hz,hz);
reset(f);
end;
read(f,hz,hs,hm,hzm,hsm,hml,hzml);
close(f);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure UpdateHiScore;
begin
if (((hzml*1)+(hml*10)+(hsm*100)+(hzm*1000)+(hm*10000)+(hs*100000)+(hz*1000000))<
   ((zml*1)+(ml*10)+(sm*100)+(zm*1000)+(m*10000)+(s*100000)+(z*1000000))) then
   begin
   hzml:=zml;
   hml:=ml;
   hsm:=sm;
   hzm:=zm;
   hm:=m;
   hs:=s;
   hz:=z;
end;
assign(f,'inv.sco');
rewrite(f);
write(f,hz,hs,hm,hzm,hsm,hml,hzml);
close(f);
zml:=0;
ml:=0;
sm:=0;
zm:=0;
m:=0;
s:=0;
z:=0;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure ShowLoadingPhase1;
begin
GotoXy(1,13);
TextColor(10);
write ('                                  ');
write ('V');
write ('e');
write ('r');
write ('i');
write ('f');
write ('i');
write ('c');
write (' ');
write ('j');
write ('o');
write ('c');
write ('u');
write ('l');
TextColor(1);
HideCursor;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure ShowLoadingPhase2;
begin
GotoXy(1,13);
TextColor(10);
write ('                                 ');
write ('I');
write ('n');
write ('c');
write ('a');
write ('r');
write ('c');
write ('a');
write ('r');
write ('e');
write (' ');
write ('v');
write ('i');
write ('d');
write ('e');
write ('o');
TextColor(1);
HideCursor;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure ShowLoadingPhase3;
begin
GotoXy(1,13);
TextColor(10);
write ('                                 ');
write ('I');
write ('n');
write ('c');
write ('a');
write ('r');
write ('c');
write ('a');
write ('r');
write ('e');
write (' ');
write ('a');
write ('u');
write ('d');
write ('i');
write ('o');
TextColor(1);
HideCursor;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure TextCls;
begin
Gotoxy(1,25);
for i:=1 to 25 do
begin
writeln;
delay(5);
end;
HideCursor;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure TextIntro;
begin
TextCls;
Textcolor(13);
Gotoxy(1,25);
write ('                              Ú');
for i:=1 to 19 do write('Ä');
writeln('¿            ');
delay(5);
write ('                              ³ ');
Textcolor(14);
write ('I');
write ('n');
write ('v');
write ('a');
write ('z');
write ('i');
write ('i');
write ('  ');
write ('S');
write ('p');
write ('a');
write ('t');
write ('i');
write ('a');
write ('l');
write ('e');
Textcolor(13);
writeln (' ³            ');
delay(5);
write ('                              À');
for i:=1 to 19 do write('Ä');
writeln('Ù            ');
for i:=1 to 12 do
begin
writeln;
delay(5);
end;
ShowLoadingPhase1;
delay(5);
checksum:=0;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure HideCursor;
begin
TextColor(0);
Gotoxy(1,20);
write (' ');
Gotoxy(1,20);
TextColor(7);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure DrawBox;
begin
for i:=boxy to boxy+108 do
begin
line (boxx+000,i,boxx+130,i,1,vaddr);
end;
ManageSounds;
Dosounds;
line (boxx+000,boxy+000,boxx+129,boxy+000,128+5,vaddr);
line (boxx+000,boxy+000,boxx+000,boxy+107,128+5,vaddr);
line (boxx+001,boxy+108,boxx+130,boxy+108,128+3,vaddr);
line (boxx+130,boxy+001,boxx+130,boxy+108,128+3,vaddr);
ManageSounds;
Dosounds;
line (boxx+000+2,boxy+000+2,boxx+129-2,boxy+000+2,128+3,vaddr);
line (boxx+000+2,boxy+000+2,boxx+000+2,boxy+108-3,128+3,vaddr);
line (boxx+001+2,boxy+108-2,boxx+130-2,boxy+108-2,128+5,vaddr);
line (boxx+130-2,boxy+000+3,boxx+130-2,boxy+108-2,128+5,vaddr);
ManageSounds;
Dosounds;
line (boxx+000+1,boxy+000+1,boxx+129-1,boxy+000+1,128+4,vaddr);
line (boxx+000+1,boxy+000+1,boxx+000+1,boxy+108-1,128+4,vaddr);
line (boxx+001+1,boxy+108-1,boxx+130-1,boxy+108-1,128+4,vaddr);
line (boxx+130-1,boxy+000+1,boxx+130-1,boxy+108-1,128+4,vaddr);
pixel(boxx+000,boxy+108,128+4,vaddr);
pixel(boxx+002,boxy+106,128+4,vaddr);
pixel(boxx+130,boxy+000,128+4,vaddr);
pixel(boxx+128,boxy+002,128+4,vaddr);
ManageSounds;
Dosounds;
line (boxx+000+5,boxy+000+5,boxx+000+5,boxy+029-5,128+4,vaddr);
line (boxx+130-5,boxy+000+5,boxx+130-5,boxy+029-5,128+4,vaddr);
line (boxx+000+4,boxy+000+4,boxx+000+4,boxy+029-4,128+4,vaddr);
line (boxx+130-4,boxy+000+4,boxx+130-4,boxy+029-4,128+4,vaddr);
line (boxx+000+5,boxy+000+5,boxx+129-5,boxy+000+5,128+5,vaddr);
line (boxx+000+5,boxy+000+5,boxx+000+5,boxy+029-6,128+5,vaddr);
line (boxx+001+5,boxy+029-5,boxx+130-5,boxy+029-5,128+3,vaddr);
line (boxx+130-5,boxy+000+6,boxx+130-5,boxy+029-5,128+3,vaddr);
line (boxx+000+4,boxy+000+4,boxx+129-4,boxy+000+4,128+3,vaddr);
line (boxx+000+4,boxy+000+4,boxx+000+4,boxy+029-5,128+3,vaddr);
line (boxx+001+4,boxy+029-4,boxx+130-4,boxy+029-4,128+5,vaddr);
line (boxx+130-4,boxy+000+5,boxx+130-4,boxy+029-4,128+5,vaddr);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure DrawLEDs;
begin
if (optp div 10)<>0 then PutImg16(boxx+18,70,ledoff,vaddr);
if (optp div 10)<>1 then PutImg16(boxx+18,88,ledoff,vaddr);
if (optp div 10)<>2 then PutImg16(boxx+18,106,ledoff,vaddr);
if (optp div 10)<>3 then PutImg16(boxx+18,124,ledoff,vaddr);
if (optp div 10)=0 then PutImg16(boxx+18,70,ledon,vaddr);
if (optp div 10)=1 then PutImg16(boxx+18,88,ledon,vaddr);
if (optp div 10)=2 then PutImg16(boxx+18,106,ledon,vaddr);
if (optp div 10)=3 then PutImg16(boxx+18,124,ledon,vaddr);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure SndOps;
var x:byte;
label ROCyc,ROexit,RSel;
var ts:integer;
begin
nosound;
ts:=sounds;
sounds:=1;
if ts<>0 then Spkbeep;
sounds:=ts;
bload:=10;
optp:=0;
ROCyc:
DrawBox;
PutImg16b(boxx+34+008+00,47,logo6,vaddr);
PutImg16b(boxx+34+016+01,47,logob,vaddr);
PutImg16b(boxx+34+024+02,47,logo2,vaddr);
PutImg16b(boxx+34+032+03,47,logoa,vaddr);
PutImg16b(boxx+34+040+04,47,logo8,vaddr);
PutImg16b(boxx+40+000+00,70,logo8,vaddr);
PutImg16b(boxx+40+008+01,70,logoa,vaddr);
PutImg16b(boxx+40+016+02,70,logoc,vaddr);
PutImg16b(boxx+40+024+03,70,logof,vaddr);
PutImg16b(boxx+40+032+04,70,logo1,vaddr);
PutImg16b(boxx+40+040+05,70,logo2,vaddr);
PutImg16b(boxx+40+048+06,70,logo4,vaddr);
PutImg16b(boxx+40+056+07,70,logo8,vaddr);

PutImg16b(boxx+40+000+00,88,logo4,vaddr);
PutImg16b(boxx+40+008+01,88,logog,vaddr);
PutImg16b(boxx+40+016+02,88,logoc,vaddr);

PutImg16b(boxx+40+000+00,106,logo1,vaddr);
PutImg16b(boxx+40+008+01,106,logoc,vaddr);
PutImg16b(boxx+40+016+02,106,logod,vaddr);

PutImg16b(boxx+40+000+00,124,logog,vaddr);
PutImg16b(boxx+40+008+01,124,logof,vaddr);
PutImg16b(boxx+40+016+02,124,logo4,vaddr);

PutImg16b(boxx+40+040+05,88,nr2,vaddr);
if adr=1 then PutImg16b(boxx+40+048+06,88,nr1,vaddr);
if adr=2 then PutImg16b(boxx+40+048+06,88,nr2,vaddr);
if adr=3 then PutImg16b(boxx+40+048+06,88,nr3,vaddr);
if adr=4 then PutImg16b(boxx+40+048+06,88,nr4,vaddr);
if adr=6 then PutImg16b(boxx+40+048+06,88,nr6,vaddr);
PutImg16b(boxx+40+056+07,88,nr0,vaddr);

if irq>9 then PutImg16b(boxx+40+048+06,106,nr1,vaddr);
if irq=2 then PutImg16b(boxx+40+056+07,106,nr2,vaddr);
if irq=3 then PutImg16b(boxx+40+056+07,106,nr3,vaddr);
if irq=5 then PutImg16b(boxx+40+056+07,106,nr5,vaddr);
if irq=7 then PutImg16b(boxx+40+056+07,106,nr7,vaddr);
if irq=10 then PutImg16b(boxx+40+056+07,106,nr0,vaddr);
if irq=11 then PutImg16b(boxx+40+056+07,106,nr1,vaddr);
if irq=12 then PutImg16b(boxx+40+056+07,106,nr2,vaddr);
if irq=15 then PutImg16b(boxx+40+056+07,106,nr5,vaddr);

if dma=0 then PutImg16b(boxx+40+056+07,124,nr0,vaddr);
if dma=1 then PutImg16b(boxx+40+056+07,124,nr1,vaddr);
if dma=3 then PutImg16b(boxx+40+056+07,124,nr3,vaddr);
DrawLEDs;
if (up) and (bload=0) and (optp>0) then
begin
clic:=4;
optp:=optp-10;
bload:=3;
end;
if (down) and (bload=0) and (optp<30{40}) then
begin
clic:=4;
optp:=optp+10;
bload:=3;
end;
if (bload=0) and (space) and ((optp div 10)=0) then
begin
ts:=sounds;
sounds:=1;
if ts<>0 then Spkbeep;
sounds:=ts;
goto ROexit;
end;
if bload>0 then bload:=bload-1;
if (bload=0) and (space) and ((optp div 10)=1) then
begin
if sounds<>0 then blt:=10;
bload:=10;
adr:=adr+1;
if adr=5 then adr:=6;
if adr=7 then adr:=1;
goto Rsel;
end;
if (bload=0) and (space) and ((optp div 10)=2) then
begin
if sounds<>0 then blt:=10;
bload:=10;
irq:=irq+1;
if (irq=4) or (irq=6) then irq:=irq+1;
if (irq=8) or (irq=13) then irq:=irq+2;
if irq>15 then irq:=2;
goto Rsel;
end;
if (bload=0) and (space) and ((optp div 10)=3) then
begin
if sounds<>0 then blt:=10;
bload:=10;
dma:=dma+1;
if dma=2 then dma:=3;
if dma=4 then dma:=0;
goto Rsel;
end;
RSel:
ts:=sounds;
sounds:=1;
ManageSounds;
Dosounds;
sounds:=ts;
flip(vaddr,vga);
ts:=sounds;
sounds:=1;
ManageSounds;
Dosounds;
sounds:=ts;
goto ROcyc;
ROexit:
space:=false;
sounds:=2;
ResetSB;
delay(10);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure DevOps;
var x:byte;
label RROCyc,RROexit,RRSel;
var ts:integer;
begin
nosound;
ts:=sounds;
sounds:=1;
if ts<>0 then Spkbeep;
sounds:=ts;
bload:=10;
optp:=0;
RROCyc:
DrawBox;
PutImg16b(boxx+34+008+00,47,logo6,vaddr);
PutImg16b(boxx+34+016+01,47,logob,vaddr);
PutImg16b(boxx+34+024+02,47,logo2,vaddr);
PutImg16b(boxx+34+032+03,47,logoa,vaddr);
PutImg16b(boxx+34+040+04,47,logo8,vaddr);

PutImg16b(boxx+44+000+00,70,logo4,vaddr);
PutImg16b(boxx+44+008+01,70,logo2,vaddr);
PutImg16b(boxx+44+016+02,70,logob,vaddr);
PutImg16b(boxx+44+024+03,70,logo9,vaddr);
PutImg16b(boxx+44+032+04,70,logo4,vaddr);
PutImg16b(boxx+44+040+05,70,logoc,vaddr);
PutImg16b(boxx+44+048+06,70,logoa,vaddr);

PutImg16b(boxx+44+000+00,88,logok,vaddr);
PutImg16b(boxx+44+008+01,88,logo9,vaddr);
PutImg16b(boxx+44+016+02,88,logo4,vaddr);
PutImg16b(boxx+44+024+03,88,logo6,vaddr);
PutImg16b(boxx+44+032+04,88,logo8,vaddr);
PutImg16b(boxx+44+040+05,88,logoa,vaddr);
PutImg16b(boxx+44+048+06,88,logoc,vaddr);

PutImg16b(boxx+44+000+00,106,logog,vaddr);
PutImg16b(boxx+44+008+01,106,logo1,vaddr);
PutImg16b(boxx+44+016+02,106,logoj,vaddr);
PutImg16b(boxx+44+024+03,106,logob,vaddr);
PutImg16b(boxx+44+032+04,106,logo5,vaddr);
PutImg16b(boxx+44+040+05,106,nr0,vaddr);
PutImg16b(boxx+44+048+06,106,logoc,vaddr);
PutImg16b(boxx+44+000+00,124,logo9,vaddr);
PutImg16b(boxx+44+008+01,124,logo1,vaddr);
PutImg16b(boxx+44+016+02,124,logo2,vaddr);
PutImg16b(boxx+44+024+03,124,logo1,vaddr);
PutImg16b(boxx+44+032+04,124,logo6,vaddr);
PutImg16b(boxx+44+040+05,124,logo8,vaddr);
PutImg16b(boxx+44+048+06,124,logoa,vaddr);
DrawLEDs;
if (up) and (bload=0) and (optp>0) then
begin
if sounds<>0 then clic:=4;
optp:=optp-10;
bload:=3;
end;
if (down) and (bload=0) and (optp<30{40}) then
begin
if sounds<>0 then clic:=4;
optp:=optp+10;
bload:=3;
end;
if (bload=0) and (space) and ((optp div 10)=0) then
begin
if sounds<>0 then SpkBeep;
goto RROexit;
end;
if (bload=0) and (space) and ((optp div 10)=1) then
begin
sounds:=1;
SpkBeep;
sounds:=2;
goto RROexit;
end;
if (bload=0) and (space) and ((optp div 10)=2) then
begin
sounds:=1;
SpkBeep;
goto RROexit;
end;
if (bload=0) and (space) and ((optp div 10)=3) then
begin
sounds:=0;
goto RROexit;
end;
if bload>0 then bload:=bload-1;
RRSel:
ts:=sounds;
sounds:=1;
ManageSounds;
Dosounds;
sounds:=ts;
flip(vaddr,vga);
ts:=sounds;
sounds:=1;
ManageSounds;
Dosounds;
sounds:=ts;
goto RROcyc;
RROexit:
optp:=0;
space:=false;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure Options;
var x,osn:byte;
label OCyc,Oexit,Sel;
begin
Fade(16,false);
nosound;
if (sounds=1) then SpkBeep;
if (sounds=2) then PlayBip;
optp:=0;
bload:=0;
OCyc:
DrawBox;
PutImg16b(boxx+34+000+00,47,nr0,vaddr);
PutImg16b(boxx+34+008+01,47,logo7,vaddr);
PutImg16b(boxx+34+016+02,47,logo8,vaddr);
PutImg16b(boxx+34+024+03,47,logo1,vaddr);
PutImg16b(boxx+34+032+04,47,logob,vaddr);
PutImg16b(boxx+34+040+05,47,logo2,vaddr);
PutImg16b(boxx+34+048+06,47,logo1,vaddr);

PutImg16b(boxx+40+000+00,70,logo8,vaddr);
PutImg16b(boxx+40+008+01,70,logoa,vaddr);
PutImg16b(boxx+40+016+02,70,logoc,vaddr);
PutImg16b(boxx+40+024+03,70,logof,vaddr);
PutImg16b(boxx+40+032+04,70,logo1,vaddr);
PutImg16b(boxx+40+040+05,70,logo2,vaddr);
PutImg16b(boxx+40+048+06,70,logo4,vaddr);
PutImg16b(boxx+40+056+07,70,logo8,vaddr);

PutImg16b(boxx+40+000+00,88,logo6,vaddr);
PutImg16b(boxx+40+008+01,88,logob,vaddr);
PutImg16b(boxx+40+016+02,88,logo2,vaddr);
PutImg16b(boxx+40+024+03,88,logoa,vaddr);
PutImg16b(boxx+40+032+04,88,logo8,vaddr);
PutImg16b(boxx+40+040+05,88,logoa,vaddr);

PutImg16b(boxx+40+000+00,106,logo3,vaddr);
PutImg16b(boxx+40+008+01,106,logo1,vaddr);
PutImg16b(boxx+40+016+02,106,logo8,vaddr);
PutImg16b(boxx+40+024+03,106,logoa,vaddr);
PutImg16b(boxx+40+032+04,106,logo5,vaddr);
PutImg16b(boxx+40+040+05,106,logo4,vaddr);
PutImg16b(boxx+40+000+00,124,logo6,vaddr);
PutImg16b(boxx+40+008+01,124,logo1,vaddr);
PutImg16b(boxx+40+016+02,124,logo2,vaddr);
PutImg16b(boxx+40+024+03,124,logoe,vaddr);
PutImg16b(boxx+40+032+04,124,logoc,vaddr);
PutImg16b(boxx+40+040+05,124,nr0,vaddr);
if sounds=1 then PutImg16(boxx+95,88,optsp,vaddr);
if sounds=2 then PutImg16(boxx+95,88,optsb,vaddr);
if fast=1 then PutImg16b(boxx+95+8,106,nr1,vaddr);
if sincro=true then PutImg16(boxx+95,124,optok,vaddr);
if sounds=0 then PutImg16(boxx+95,88,optno,vaddr);
if fast=0 then PutImg16b(boxx+95+8,106,nr2,vaddr);
if sincro=false then PutImg16(boxx+95,124,optno,vaddr);
DrawLEDs;
if (up) and (bload=0) and (optp>0) then
begin
optp:=optp-10;
bload:=3;
if (sounds=2) then PlayClc;
clic:=4;
end;
if (down) and (bload=0) and (optp<30{40}) then
begin
optp:=optp+10;
bload:=3;
if (sounds=2) then PlayClc;
clic:=4;
end;
if (space) and ((optp div 10)=0) then
begin
goto Oexit;
end;
if bload>0 then bload:=bload-1;
if (bload=0) and (space) and ((optp div 10)=1) then
begin
bload:=10;
osn:=sounds;
DevOps;
if sounds=osn then goto sel;
if sounds=2 then SndOps;
blt:=10;
if (sounds=2) then PlayBlt;
goto sel;
end;
if (bload=0) and (space) and ((optp div 10)=2) then
begin
fast:=1-fast;
bload:=10;
blt:=10;
if (sounds=2) then PlayBlt;
goto sel;
end;
if (bload=0) and (space) and ((optp div 10)=3{4}) and (sincro=true) then
begin
bload:=10;
sincro:=false;
blt:=10;
if (sounds=2) then PlayBlt;
goto sel;
end;
if (bload=0) and (space) and ((optp div 10)=3{4}) and (sincro=false) then
begin
bload:=10;
sincro:=true;
blt:=10;
if (sounds=2) then PlayBlt;
goto sel;
end;
Sel:
ManageSounds;
Dosounds;
flip(vaddr,vga);
ManageSounds;
Dosounds;
goto Ocyc;
Oexit:
if (sincro=true) then
begin
for i:=0 to 5 do
for j:=0 to 9 do groove[j+1,i+1]:=0;
end;

if (sincro=false) then
begin
for i:=0 to 5 do
for j:=0 to 9 do groove[j+1,i+1]:=((j+i) mod 4);
end;
Assign (f,'inv.cfg');
rewrite(f);
if sounds=0 then x:=0;
if sounds=1 then x:=1;
if sounds=2 then x:=2;
write(f,x);
if muzeak=false then x:=0;
if muzeak=true then x:=1;
write(f,x);
x:=fast;
write(f,x);
if sincro=false then x:=0;
if sincro=true then x:=1;
write(f,x);
x:=adr;
write(f,x);
x:=irq;
write(f,x);
x:=dma;
write(f,x);
close(f);
if (sounds=1) then SpkBeep;
if (sounds=2) then PlayBip;
space:=false;
Fade(0,false);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure EndGame;
begin
flip(vaddr2,vaddr);
Indications;
putimg16(120+000+00,160,logo3,vaddr);
putimg16(120+008+01,160,logo1,vaddr);
putimg16(120+016+02,160,logoe,vaddr);
putimg16(120+024+03,160,logo8,vaddr);
putimg16(120+032+04,160,nr0,vaddr);
putimg16(120+040+05,160,logoc,vaddr);
putimg16(120+048+06,160,logo1,vaddr);
putimg16(120+056+07,160,logoa,vaddr);
putimg16(120+064+08,160,logoh,vaddr);
flip(vaddr,vga);
FadeIn;
while not esc do
begin
FireWShow;
end;
nosound;
FadeOut;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure FireWShow;
var miau,miau2,miau3,miau4,miau5,flash:real;
begin
flip(vaddr2,vaddr);
Indications;
Animate;
{}
mpos:=265;
mpos2:=0;
ManageSounds;
if bum>0 then pho:=0;
{}
DoSounds;
if (fw1[1,5]=0) and (random(10)=1) then
begin
miau:=random(320);
miau2:=random(3)+2;
miau3:=random(6);
miau4:=20+random(6);
miau5:=-1+random(3);
for i:=1 to 60 do
begin
fw1[i,1]:=miau;
fw1[i,2]:=150;
fw1[i,3]:=miau2;
if miau3=0 then fw1[i,4]:=1*16;
if miau3=1 then fw1[i,4]:=2*16;
if miau3=2 then fw1[i,4]:=3*16;
if miau3=3 then fw1[i,4]:=4*16;
if miau3=4 then fw1[i,4]:=5*16;
if miau3=5 then fw1[i,4]:=7*16;
fw1[i,5]:=miau4*2;
fw1[i,6]:=miau5;
end;
if (not (not SB_Dmacomplete)) and (sounds=2) then ;
end;
for i:=1 to 60 do
begin
if fw1[i,5]<0 then fw1[i,5]:=0;
if fw1[i,5]>15 then
begin
if (fw1[i,2]>0) and (fw1[i,1]>0) and (fw1[i,1]<319) and (fw1[i,2]<199)
and (MEM[vaddr2:(round(fw1[i,2])*320)+round(fw1[i,1])]=17)
then Pixel(round(fw1[i,1]),round(fw1[i,2]),round(fw1[i,4])+10+anim div 4,vaddr);
fw1[i,1]:=fw1[i,1]+fw1[i,6];
fw1[i,2]:=fw1[i,2]-fw1[i,3];
fw1[i,5]:=fw1[i,5]-1;
end;
if (fw1[i,5]>0) and (fw1[i,5]<13) then
begin
if (fw1[i,2]>0) and (fw1[i,1]>0) and (fw1[i,1]<319) and (fw1[i,2]<199)
and (MEM[vaddr2:(round(fw1[i,2])*320)+round(fw1[i,1])]=17)
then Pixel(round(fw1[i,1]),round(fw1[i,2]),round(fw1[i,4])+round(fw1[i,5]),vaddr);
fw1[i,1]:=fw1[i,1]+fw1[i,6]/2;
fw1[i,2]:=fw1[i,2]-fw1[i,3]/2;
if anim mod 6=0 then fw1[i,3]:=fw1[i,3]-0.2;
if anim mod 6=0 then fw1[i,5]:=fw1[i,5]-1;
end;
end;
if (fw1[1,5]=13) or (fw1[1,5]=14) or (fw1[1,5]=15) then
begin
for i:=1 to 60 do
begin
miau2:=(((((-50+random(101))/20)*random(20)))/20);
miau3:=(((((-50+random(101))/20)*random(20)))/20);
fw1[i,3]:=miau2;
fw1[i,6]:=miau3;
fw1[i,5]:=fw1[i,5]-3;
fw1[i,5]:=fw1[i,5]-random(3);
bum:=10+random(30);
if (not (not SB_Dmacomplete)) and (sounds=2) then ;
flash:=1;
end;
end;
{}
DoSounds;
if (fw2[1,5]=0) and (random(10)=1) then
begin
miau:=random(320);
miau2:=random(3)+2;
miau3:=random(6);
miau4:=20+random(6);
miau5:=-1+random(3);
for i:=1 to 60 do
begin
fw2[i,1]:=miau;
fw2[i,2]:=150;
fw2[i,3]:=miau2;
if miau3=0 then fw2[i,4]:=1*16;
if miau3=1 then fw2[i,4]:=2*16;
if miau3=2 then fw2[i,4]:=3*16;
if miau3=3 then fw2[i,4]:=4*16;
if miau3=4 then fw2[i,4]:=5*16;
if miau3=5 then fw2[i,4]:=7*16;
fw2[i,5]:=miau4*2;
fw2[i,6]:=miau5;
end;
if (not (not SB_Dmacomplete)) and (sounds=2) then ;
end;
for i:=1 to 60 do
begin
if fw2[i,5]<0 then fw2[i,5]:=0;
if fw2[i,5]>15 then
begin
if (fw2[i,2]>0) and (fw2[i,1]>0) and (fw2[i,1]<319) and (fw2[i,2]<199)
and (MEM[vaddr2:(round(fw2[i,2])*320)+round(fw2[i,1])]=17)
then Pixel(round(fw2[i,1]),round(fw2[i,2]),round(fw2[i,4])+10+anim div 4,vaddr);
fw2[i,1]:=fw2[i,1]+fw2[i,6];
fw2[i,2]:=fw2[i,2]-fw2[i,3];
fw2[i,5]:=fw2[i,5]-1;
end;
if (fw2[i,5]>0) and (fw2[i,5]<13) then
begin
if (fw2[i,2]>0) and (fw2[i,1]>0) and (fw2[i,1]<319) and (fw2[i,2]<199)
and (MEM[vaddr2:(round(fw2[i,2])*320)+round(fw2[i,1])]=17)
then Pixel(round(fw2[i,1]),round(fw2[i,2]),round(fw2[i,4])+round(fw2[i,5]),vaddr);
fw2[i,1]:=fw2[i,1]+fw2[i,6]/2;
fw2[i,2]:=fw2[i,2]-fw2[i,3]/2;
if anim mod 6=0 then fw2[i,3]:=fw2[i,3]-0.2;
if anim mod 7=0 then fw2[i,5]:=fw2[i,5]-1;
end;
end;
if (fw2[1,5]=13) or (fw2[1,5]=14) or (fw2[1,5]=15) then
begin
for i:=1 to 60 do
begin
miau2:=(((((-50+random(101))/20)*random(20)))/20);
miau3:=(((((-50+random(101))/20)*random(20)))/20);
fw2[i,3]:=miau2;
fw2[i,6]:=miau3;
fw2[i,5]:=fw2[i,5]-3;
fw2[i,5]:=fw2[i,5]-random(3);
bum:=10+random(30);
if (not (not SB_Dmacomplete)) and (sounds=2) then ;
flash:=1;
end;
end;
{}
DoSounds;
if (fw3[1,5]=0) and (random(10)=1) then
begin
miau:=random(320);
miau2:=random(3)+2;
miau3:=random(6);
miau4:=20+random(6);
miau5:=-1+random(3);
for i:=1 to 60 do
begin
fw3[i,1]:=miau;
fw3[i,2]:=150;
fw3[i,3]:=miau2;
if miau3=0 then fw3[i,4]:=1*16;
if miau3=1 then fw3[i,4]:=2*16;
if miau3=2 then fw3[i,4]:=3*16;
if miau3=3 then fw3[i,4]:=4*16;
if miau3=4 then fw3[i,4]:=5*16;
if miau3=5 then fw3[i,4]:=7*16;
fw3[i,5]:=miau4*2;
fw3[i,6]:=miau5;
end;
if (not (not SB_Dmacomplete)) and (sounds=2) then ;
end;
for i:=1 to 60 do
begin
if fw3[i,5]<0 then fw3[i,5]:=0;
if fw3[i,5]>15 then
begin
if (fw3[i,2]>0) and (fw3[i,1]>0) and (fw3[i,1]<319) and (fw3[i,2]<199)
and (MEM[vaddr2:(round(fw3[i,2])*320)+round(fw3[i,1])]=17)
then Pixel(round(fw3[i,1]),round(fw3[i,2]),round(fw3[i,4])+10+anim div 4,vaddr);
fw3[i,1]:=fw3[i,1]+fw3[i,6];
fw3[i,2]:=fw3[i,2]-fw3[i,3];
fw3[i,5]:=fw3[i,5]-1;
end;
if (fw3[i,5]>0) and (fw3[i,5]<13) then
begin
if (fw3[i,2]>0) and (fw3[i,1]>0) and (fw3[i,1]<319) and (fw3[i,2]<199)
and (MEM[vaddr2:(round(fw3[i,2])*320)+round(fw3[i,1])]=17)
then Pixel(round(fw3[i,1]),round(fw3[i,2]),round(fw3[i,4])+round(fw3[i,5]),vaddr);
fw3[i,1]:=fw3[i,1]+fw3[i,6]/2;
fw3[i,2]:=fw3[i,2]-fw3[i,3]/2;
if anim mod 6=0 then fw3[i,3]:=fw3[i,3]-0.2;
if anim mod 5=0 then fw3[i,5]:=fw3[i,5]-1;
end;
end;
if (fw3[1,5]=13) or (fw3[1,5]=14) or (fw3[1,5]=15) then
begin
for i:=1 to 60 do
begin
miau2:=(((((-50+random(101))/20)*random(20)))/20);
miau3:=(((((-50+random(101))/20)*random(20)))/20);
fw3[i,3]:=miau2;
fw3[i,6]:=miau3;
fw3[i,5]:=fw3[i,5]-3;
fw3[i,5]:=fw3[i,5]-random(3);
bum:=10+random(30);
if (not (not SB_Dmacomplete)) and (sounds=2) then ;
flash:=1;
end;
end;
{}
if bum>0 then pho:=0;
DoSounds;
putimg16(120+000+00,160,logo3,vaddr);
putimg16(120+008+01,160,logo1,vaddr);
putimg16(120+016+02,160,logoe,vaddr);
putimg16(120+024+03,160,logo8,vaddr);
putimg16(120+032+04,160,nr0,vaddr);
putimg16(120+040+05,160,logoc,vaddr);
putimg16(120+048+06,160,logo1,vaddr);
putimg16(120+056+07,160,logoa,vaddr);
putimg16(120+064+08,160,logoh,vaddr);
{}
waitretrace;
if flash=0 then Pal(17,Paleta[17,1],Paleta[17,2],Paleta[17,3]);
if flash=1 then Pal(17,Paleta[17,1],Paleta[17,2],Paleta[17,3]+random(30));
flip(vaddr,vga);
if (anim mod 8=0) then flash:=0;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{                                   MAIN                                   }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
label Once_again,Game_Over,New_Wave,Yeah,Restart,Exit_Game,Lets_Go;
begin
TextIntro;
LoadIndexToMEM;
{$IFNDEF Prot_ShutDown}
{
if tampered then
begin
ClrScr;
HideCursor;
delay(100);
Gotoxy(1,10);
Textcolor(12);
write ('                  ');
write ('A');
write ('A');
write ('A');
write ('A');
write ('A');
write ('A');
write ('A');
write ('A');
write ('A');
write ('A');
write ('A');
write ('I');
write ('I');
write ('I');
write ('E');
write ('E');
write ('E');
write ('E');
write ('!');
write ('!');
write ('!');
write ('!');
write (' ');
write ('A');
write ('m');
write (' ');
write ('f');
write ('o');
write ('s');
write ('t');
write (' ');
write ('m');
write ('o');
write ('d');
write ('i');
write ('f');
write ('i');
write ('c');
write ('a');
write ('t');
write (' ');
write ('!');
write ('!');
writeln ('!');

write ('                   ');
write ('M');
write ('-');
write ('a');
write ('m');
write (' ');
write ('s');
write ('u');
write ('p');
write ('a');
write ('r');
write ('a');
write ('t');
write (' ');
write ('s');
write ('i');
write (' ');
write ('n');
write ('u');
write (' ');
write ('m');
write ('a');
write ('i');
write (' ');
write ('v');
write ('r');
write ('e');
write ('a');
write ('u');
write (' ');
write ('s');
write ('a');
write (' ');
write ('m');
write ('a');
write ('i');
write (' ');
write ('r');
write ('u');
write ('l');
write ('e');
write ('z');
writeln ('!');
HideCursor;
for i:=1 to 40 do
begin
for j:=0 to 5 do
begin
sound (2000+j*100);
delay(10);
end;
end;
nosound;
ReadKey;
TextCls;
halt;
end;
}
{$ENDIF}
LoadHiScore;
VrtOn;
ShowLoadingPhase2;
LoadSpr;
ShowProg(99);
ShowLoadingPhase3;
LoadSnd;
TextCls;
DefVar;
if sounds=2 then
begin
ResetSB;
end;
InitGr;
LoadPcx('DATE\decor.rle',vaddr2);
flip(vaddr2,vaddr);
DrawStatusBar;
flip(vaddr,vaddr2);
ClsScr;
lives:=5;
Indications;
flip(vaddr,vga);
for i:=31 downto 0 do
begin
Fade(i,true);
delay(5);
waitretrace;
end;
{rgp}
restart:
ResetVar;
nosound;
mpos:=0;
mpos2:=0;
{}
while true do
begin
if space then boom:=true;
if esc then
begin
boom:=true;
doom:=true;
end;
flip(vaddr2,vaddr);
Animate;
Animate;
WiggleLogo;
DrawStatusBar;
Indications;
if F1_ then Options;
waitretrace;
Fade(fayd,false);
flip(vaddr,vga);
if boom=false and (anim mod 4=0) then fayd:=fayd-2;
if boom=true then fayd:=fayd+2;
if fayd<0 then fayd:=0;
if fayd>34 then goto Lets_Go;
end;
{Start game point}
Lets_Go:
nosound;
wave:=0;
if doom=true then goto Exit_Game;
cota:=0;
{Start level point}
New_wave:
timetofire:=0;
lives:=lives+1;
invkill:=0;
ShowWave;
iwav:=wave mod 5;
flip(vaddr,vga);
FadeIn;
Invaders_Prepare;
delay(200);
if (sounds=1) then SpkBeep;
if (sounds=2) then PlayBip;
delay(400);
LoadInvSpr;
FadeOut;
mpos:=0;
mpos2:=0;
Once_again:
{Retry level point}

for i:=1 to 6 do
begin
photon[i,3]:=0;
end;
for i:=1 to 5 do
begin
fallers[i,1]:=0;
end;
dispprot:=6;
Ship_prepare;
lives:=lives-1;
if lives>250 then goto game_over;

{ Main loop start }

while true do
begin
if boom=false then bam:=0;
if boom=true then inc(bam);
ManageSounds;
DoSounds;
if F1_ then
begin
Options;
end;
if esc then
begin
if boom=false then if sounds=2 then PlayBum;
mpos:=261;
bum:=50;
boom:=true;
lives:=0;
end;
flip(vaddr2,vaddr);
if minus then doom:=true;
Lasers_Move;
Invaders_Move;
Invaders_Draw;
inc(timetofire);
if (timetofire>(125-wave*6)) then
begin
if not doom then Invaders_Shoot;
timetofire:=0;
end;
Invaders_Shoot2;
Invaders_Check;
Bombs_Move;
Ship_Move;
if not doom then Ship_Fire;
Ship_Draw;
Animate;
if (fayd>40) and (boom=true) then goto Once_Again;
if (fayd>40) and (done=true) then goto Yeah;
if (fayd<-31) and (doom=true) then goto Game_Over;
DrawStatusBar;
if k1 then bonus:=3000;
Indications;
Dosounds;
AddScore;
if (m>cota) then
begin
lives:=lives+1;
if lives>5 then lives:=5;
cota:=cota+1;
clic:=4;
if (sounds=2) then ;
end;
if (m=0) and (cota=9) then
begin
lives:=lives+1;
if lives>5 then lives:=5;
cota:=0;
clic:=4;
if (sounds=2) then ;
end;
HandleExitEvents;
Dosounds;
if (doom) then lives:=0;
if (doom) and (not (not SB_Dmacomplete)) then
begin
if (sounds=2) then ;
if Fayd>-2 then Fayd:=(-2);
end;
if fast=1 then waitretrace;
ManageFade;
if (olfayd<>fayd) and (doom=false) then Fade(fayd,false);
if (doom=true) then Fade(fayd-random(5),false);
olfayd:=fayd;
Dosounds;
flip(vaddr,vga);
end;

{ Main loop end }

Yeah:
nosound;
wave:=wave+1;
if wave=21 then EndGame;
if wave=21 then Goto Game_Over;
goto New_Wave;
Game_Over:
nosound;
if doom=true then
begin
flip(vaddr2,vaddr);
Dosounds;
ClsScr;
Dosounds;
Indications;
Dosounds;
flip(vaddr,vga);
Dosounds;
doom:=false;
for i:=-34 to 34 do
begin
for j:=1 to 20 do
begin
if (j mod 2=0) then ManageSounds;
Dosounds;
delay(1);
end;
waitretrace;
Fade(i,false);
end;
end;
nosound;
flip(vaddr2,vaddr);
lives:=5;
DrawStatusBar;
Indications;
nosound;
ClsScr;
putimg24(148,88,gameover,vaddr);
flip(vaddr,vga);
FadeIn;
delay(500);
FadeOut;
UpdateHiScore;
 ResetVar;
goto restart;
Exit_Game:
nosound;
delay(100);
flip(vaddr2,vaddr);
ClsScr;
lives:=5;
Indications;
flip(vaddr,vga);
for i:=0 to 31 do
begin
Fade(i,true);
delay(10);
waitretrace;
end;
nosound;
VgaOff;
VrtOff;
SetIntVec(KEYBOARDINTR, @BiosKeyboardHandler);
SB_FreeDMABuffer(S1Buff,7000 div $10);
SB_FreeDMABuffer(S2Buff,3000 div $10);
SB_FreeDMABuffer(S3Buff,3100 div $10);
SB_FreeDMABuffer(S4Buff,4000 div $10);
SB_FreeDMABuffer(S5Buff,2000 div $10);
SB_FreeDMABuffer(S6Buff,3000 div $10);
SB_FreeDMABuffer(S7Buff,8000 div $10);
SB_FreeDMABuffer(S8Buff,8000 div $10);
SB_FreeDMABuffer(S9Buff,500 div $10);
SB_FreeDMABuffer(SABuff,2000 div $10);
write(mess);
end.