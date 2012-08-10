{$A-,B-,D+,E-,F-,G+,I+,L+,N+,O-,P+,Q-,R-,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}
{$X+ $N+ $E-}
program SpriteEditor;
uses Crt,Dos,Video,Filez,General,Strings,keyboard;
{}
const KEYBOARDPORT = $60;
      KEYBOARDINTR = 9;
      ss1 = 0*32+16;
      ss2 = 4;
      ss3 = 0*32+16;
      ss4 = 2;
      m10 = 768;
      brightegreen=(2*32)+20;
      brighteyellow=(7*32)+20;
      maxlimx=307;
var gump:integer;
    acc:integer;
    zz:longint;
    touch:integer;
    zebedee:integer;
    zebenee:integer;
    zolk:integer;
    llkx,llky:integer;
    windx1:integer;
    windy1:integer;
    windx2:integer;
    windy2:integer;
    twindx1:integer;
    twindy1:integer;
    twindx2:integer;
    twindy2:integer;
    sname:string;
    uname:string;
    rname:string;
    energy:integer;
    stf:integer;
    stf2:integer;
    homepath:string;
    kreed:string;
    mvx,mvy:real;
    mrx,mry:real;
    cxsize,cysize:integer;
    usize:integer;
    rsize:integer;
    ssize:integer;
    info:array[0..250,0..11] of char;
    oname:array[0..11] of char;
    backcolour:integer;
    exitnow:integer;
    tmode:integer;
    bload:byte;
    AX,AY:integer;
    GX,GY:integer;
    LX,LY:integer;
    SP:boolean;
    tool:integer;
    colour,brightness:integer;
    anim:integer;
    mainspr:array[0..33,0..33] of byte;
    undospr:array[1..32,1..32] of byte;
    redospr:array[1..32,1..32] of byte;
    textspr:array[1..32,1..32] of byte;
    clipspr:array[1..32,1..32] of byte;
    txsize:integer;
    tysize:integer;
    mleft,mright,mup,mdown,mbut:boolean;
    climl,climr,climu,climd:integer;
    cred,cgre,cblu:byte;
    n,k:integer;
    dob:real;
    kbdmode:boolean;
    VMX,VMY,vtx,vty:real;
    MouseX,MouseY,BStat:integer;
    CallBiosHandler:boolean;
    BiosKeyboardHandler:procedure;
    procedure SubFNFillRow(mid,drow,borgcolour:integer);forward;
    procedure DrawPoint(ki,kj,scrx1,scry1,scrx2,scry2:integer);forward;
    procedure FlashButton(Bx,By:integer;krno:img16);forward;
    procedure DrawMain;forward;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure InitMouse;assembler;
 asm
    mov ax,0000h
    int 33h
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure ShowMouse;assembler;
 asm
    mov ax,0001h
    int 33h
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure HideMouse;assembler;
 asm
    mov ax,0002h
    int 33h
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure MoveMouse(DesrX,DesrY:integer);
begin
    asm
    mov ax,0004h
    mov cx,DesrX
    mov dx,DesrY
    int 33h
    end;
VMX:=DesrX;
VMY:=DesrY;
vtx:=0;
vty:=0;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure StatMouse;
var EMX,EMY,BUTTONSTATUS:integer;
begin
 asm
    mov ax,0003h
    int 33h
    mov BUTTONSTATUS,bx
    mov EMX,cx
    mov EMY,dx
end;
acc:=4;
if key_leftalt=true then acc:=1;
if (pad_6=true) then begin
                     kbdmode:=true;
                     vmx:=vmx+acc;
                     end;
if (pad_4=true) then begin
                     kbdmode:=true;
                     vmx:=vmx-acc;
                     end;
if (pad_2=true) then begin
                     kbdmode:=true;
                     vmy:=vmy+acc;
                     end;
if (pad_8=true) then begin
                     kbdmode:=true;
                     vmy:=vmy-acc;
                     end;
if vmx>(climr-1) then vmx:=climr-1;
if vmx<climl then vmx:=climl;
if vmy>(climd-1) then vmy:=climd-1;
if vmy<climu then vmy:=climu;
MouseX:=EMX;
MouseY:=EMY;
if kbdmode=true then begin mousex:=round(vmx); mousey:=round(vmy); end;
Bstat:=BUTTONSTATUS;
if kbdmode=true then
begin
if key_spacebar=true then bstat:=1 else bstat:=0;
end;
if bload>0 then bstat:=0;
if bload>0 then dec(bload);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DrawText;
begin
for i:=0 to 31 do
begin
for j:=0 to 31 do
begin
if (i<(cxsize+1)) and (j<(cysize+1)) then pixel(217+i,138+j,clipspr[1+i,1+j],vaddr2)
                             else pixel(217+i,138+j,0,vaddr2);
end;
end;
for i:=0 to 14 do
begin
for j:=0 to 31 do
begin
pixel(256+i,138+j,textspr[1+(i mod txsize),1+(j mod tysize)],vaddr2);
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure LimtMouse(MinX,MaxX,MinY,MaxY:integer);
begin
climl:=MinX;
climr:=MaxX;
climu:=MinY;
climd:=MaxY;
 asm
    mov ax,0007h
    mov cx,MinX
    mov dx,MaxX
    int 33h
    mov ax,0008h
    mov cx,MinY
    mov dx,MaxY
    int 33h
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure VelcMouse(HorzS,VertS,DoublT:integer);assembler;
 asm
     mov ax,001ah
    mov bx,HorzS
    mov cx,VertS
    mov dx,DoublT
    int 33h
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Initialise;
begin
tmode:=1;
stf:=0;
stf2:=1;
TextMode(13);
BlastTextCursor;
{if tampered then FuckUp;}
VrtOn;
LoadSpr;
CallBIOSHandler := false;
GetIntVec(KEYBOARDINTR, @BIOSKeyboardHandler);
SetIntVec(KEYBOARDINTR, Addr(KeyboardHandler));
InitGr;
InitMouse;
HideMouse;
MoveMouse(160,100);
mrx:=160;
mry:=100;
LimtMouse(0,maxlimx,0,184);
VelcMouse(20,20,200);
dob:=2;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure ClipSprite;
begin
 for i:=1 to 32 do
 for j:=1 to 32 do
 begin
 if (i>ssize) or (j>ssize) then mainspr[i,j]:=0;
 end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure SaveUndo;
begin
usize:=ssize;
uname:=sname;
for i:=1 to 32 do
for j:=1 to 32 do
undospr[i,j]:=mainspr[i,j];
 windx1:=0;
 windy1:=0;
 windx2:=ssize-1;
 windy2:=ssize-1;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure RestoreUndo;
begin
for i:=1 to 32 do
for j:=1 to 32 do
redospr[i,j]:=mainspr[i,j];
rname:=sname;
for i:=1 to 32 do
for j:=1 to 32 do
mainspr[i,j]:=undospr[i,j];
sname:=uname;
for i:=1 to 32 do
for j:=1 to 32 do
undospr[i,j]:=redospr[i,j];
uname:=rname;
rsize:=ssize;
ssize:=usize;
usize:=rsize;
 windx1:=0;
 windy1:=0;
 windx2:=ssize-1;
 windy2:=ssize-1;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Animate;
begin
anim:=anim+1;
if anim>19 then anim:=0;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure DrawBox(boxx,boxy,boxw,boxh,bcol,barc,cs1,cs2:integer;titlebar:boolean;where:word);
begin
for i:=boxy to boxy+(boxh+0) do
begin
line (boxx+000,i,boxx+(boxw+1),i,bcol,where);
end;
line (boxx+000,boxy+000,boxx+(boxw+0),boxy+000,bcol+cs1,where);
line (boxx+000,boxy+000,boxx+000,boxy+(boxh-1),bcol+cs1,where);
line (boxx+001,boxy+(boxh+0),boxx+(boxw+1),boxy+(boxh+0),bcol-cs1,where);
line (boxx+(boxw+1),boxy+001,boxx+(boxw+1),boxy+(boxh+0),bcol-cs1,where);
if titlebar=true then
begin
for i:=boxy+006 to boxy+023 do
begin
line (boxx+0+6,i,boxx+(boxw+0)-5,i,barc,where);
end;
line (boxx+000+5,boxy+000+5,boxx+(boxw+0)-5,boxy+000+5,bcol-cs1,where);
line (boxx+000+5,boxy+000+5,boxx+000+5,boxy+029-6,bcol-cs1,where);
line (boxx+001+5,boxy+029-5,boxx+(boxw+1)-5,boxy+029-5,bcol+cs1,where);
line (boxx+(boxw+1)-5,boxy+000+6,boxx+(boxw+1)-5,boxy+029-5,bcol+cs1,where);
line (boxx+000+6,boxy+000+6,boxx+(boxw+0)-6,boxy+000+6,barc+cs2,where);
line (boxx+000+6,boxy+000+6,boxx+000+6,boxy+029-7,barc+cs2,where);
line (boxx+001+6,boxy+029-6,boxx+(boxw+1)-6,boxy+029-6,barc-cs2,where);
line (boxx+(boxw+1)-6,boxy+000+7,boxx+(boxw+1)-6,boxy+029-6,barc-cs2,where);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure DrawBox2(boxx,boxy,boxw,boxh,bcol,barc,cs1,cs2:integer;titlebar:boolean;where:word);
var drk2,drk1,lit1,lit2:integer;
    kk1,kk2,kk3,kk4:integer;
begin
drk2:=bcol-cs1;
drk1:=bcol-cs2;
lit2:=bcol+cs1;
lit1:=bcol+cs2;
kk1:=bcol div 32;
kk2:=kk1*32;
kk3:=drk2-kk2;
if kk3<0 then drk2:=kk2;
kk3:=drk1-kk2;
if kk3<0 then drk1:=kk2;
kk3:=lit2-kk2;
if kk3>31 then lit2:=kk2+31;
kk3:=lit1-kk2;
if kk3>31 then lit1:=kk2+31;
for i:=boxy to boxy+(boxh+0) do
begin
line (boxx+000,i,boxx+(boxw+1),i,bcol,where);
end;
line (boxx+000,boxy+000,boxx+(boxw+0),boxy+000,lit2,where);
line (boxx+000,boxy+000,boxx+000,boxy+(boxh-1),lit2,where);
line (boxx+001,boxy+(boxh+0),boxx+(boxw+1),boxy+(boxh+0),drk2,where);
line (boxx+(boxw+1),boxy+001,boxx+(boxw+1),boxy+(boxh+0),drk2,where);
line (boxx+000+1,boxy+000+1,boxx+(boxw+0)-1,boxy+000+1,lit1,where);
line (boxx+000+1,boxy+000+1,boxx+000+1,boxy+(boxh+0)-2,lit1,where);
line (boxx+001+1,boxy+(boxh+0)-1,boxx+(boxw+1)-1,boxy+(boxh+0)-1,drk1,where);
line (boxx+(boxw+1)-1,boxy+000+2,boxx+(boxw+1)-1,boxy+(boxh+0)-1,drk1,where);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure DrawBox3(boxx,boxy,boxw,boxh,bcol,barc,cs1,cs2:integer;titlebar:boolean;where:word);
var drk2,drk1,lit1,lit2:integer;
    kk1,kk2,kk3,kk4:integer;
begin
lit2:=15+cs1;
lit1:=15+cs2;
drk1:=15-cs2;
drk2:=15-cs1;
drk1:=bcol-cs2;
lit1:=bcol+cs2;
kk1:=bcol div 32;
kk2:=kk1*32;
kk3:=drk2-kk2;
kk3:=drk1-kk2;
if kk3<0 then drk1:=kk2;
kk3:=drk1-kk2;
if kk3>31 then drk1:=kk2+31;
kk3:=lit1-kk2;
if kk3<0 then lit1:=kk2;
kk3:=lit1-kk2;
if kk3>31 then lit1:=kk2+31;
for i:=boxy to boxy+(boxh+0) do
begin
line (boxx+000,i,boxx+(boxw+1),i,bcol,where);
end;
line (boxx+000,boxy+000,boxx+(boxw+0),boxy+000,lit2,where);
line (boxx+000,boxy+000,boxx+000,boxy+(boxh-1),lit2,where);
line (boxx+001,boxy+(boxh+0),boxx+(boxw+1),boxy+(boxh+0),drk2,where);
line (boxx+(boxw+1),boxy+001,boxx+(boxw+1),boxy+(boxh+0),drk2,where);
line (boxx+000+1,boxy+000+1,boxx+(boxw+0)-1,boxy+000+1,lit1,where);
line (boxx+000+1,boxy+000+1,boxx+000+1,boxy+(boxh+0)-2,lit1,where);
line (boxx+001+1,boxy+(boxh+0)-1,boxx+(boxw+1)-1,boxy+(boxh+0)-1,drk1,where);
line (boxx+(boxw+1)-1,boxy+000+2,boxx+(boxw+1)-1,boxy+(boxh+0)-1,drk1,where);
pixel(boxx+boxw+1,boxy+0,15,where);
pixel(boxx+0,boxy+boxh,15,where);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure DrawBox4(boxx,boxy,boxw,boxh,bcol,barc,cs1,cs2:integer;titlebar:boolean;where:word);
var drk2,drk1,lit1,lit2:integer;
    kk1,kk2,kk3,kk4:integer;
begin
line(boxx,boxy,boxx+(boxw),boxy,bcol,where);
line(boxx+(boxw),boxy,boxx+(boxw),boxy+(boxh),bcol,where);
line(boxx+(boxw),boxy+(boxh),boxx,boxy+(boxh),bcol,where);
line(boxx,boxy+(boxh),boxx,boxy,bcol,where);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure ChangeColour;
var v1,v2,v3,v4,v5,v6:integer;
begin
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
v1:=backcolour div 32;
v2:=backcolour mod 32;
for i:=windx1 to windx2 do
for j:=windy1 to windy2 do
begin
v3:=mainspr[i+1,j+1] div 32;
v4:=mainspr[i+1,j+1] mod 32;
if v3=v1 then
begin
v5:=v4+(brightness-v2);
if v5<0 then v5:=0;
if v5>31 then v5:=31;
mainspr[i+1,j+1]:=colour*32+v5;
end;

end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure ChangeColourToText;
var v1,v2,v3,v4,v5,v6:integer;
begin
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
v1:=colour;
v2:=brightness;
for i:=windx1 to windx2 do
for j:=windy1 to windy2 do
begin
v3:=mainspr[i+1,j+1] div 32;
v4:=mainspr[i+1,j+1] mod 32;
if v3=v1 then
begin
mainspr[i+1,j+1]:=textspr[(i mod txsize)+1,(j mod tysize)+1];
end;

end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure ExchangeColour;
var v1,v2,v3,v4,v5,v6:integer;
label torg;
begin
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
v1:=backcolour div 32;
v2:=backcolour mod 32;
for i:=windx1 to windx2 do
for j:=windy1 to windy2 do
begin
v3:=mainspr[i+1,j+1] div 32;
v4:=mainspr[i+1,j+1] mod 32;
if v3=v1 then
begin
v5:=v4+(brightness-v2);
if v5<0 then v5:=0;
if v5>31 then v5:=31;
mainspr[i+1,j+1]:=colour*32+v5;
goto torg;
end;
if v3=colour then
begin
v5:=v4+(v2-brightness);
if v5<0 then v5:=0;
if v5>31 then v5:=31;
mainspr[i+1,j+1]:=v1*32+v5;
end;
torg:

end;

end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Dstatic;
var v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,enagi:integer;
label zoo;
begin
v1:=colour;
v2:=brightness;
v3:=backcolour div 32;
v4:=backcolour mod 32;
if v1>v3 then begin v5:=v1; v1:=v3; v3:=v5; end;
if v2>v4 then begin v5:=v2; v2:=v4; v4:=v5; end;
v5:=v3-v1;
v6:=v4-v2;
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
for i:=windx1 to windx2 do
for j:=windy1 to windy2 do
begin
enagi:=20;
zoo:
v7:=((v1+random(v5+1))*32)+(v2+random(v6+1));
v8:=-1;
v9:=-1;
v10:=-1;
if i>windx1 then v8:=mainspr[i,j+1];
if j>windy1 then v9:=mainspr[i+1,j];
if (i>windy1) and (j>windy1) then v10:=mainspr[i,j];
if (enagi>0) and ((v7=v8) or (v7=v9) or (v7=v10)) then
begin
dec(enagi);
goto zoo;
end;
mainspr[i+1,j+1]:=v7;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function Avc(c1,c2:integer):integer;
var res:integer;
    f1,f2,f3,f4,f5,f6,f7,f8,f9:byte;
    i2:integer;
    max:integer;
    crna:real;
    maxa:real;
begin
if c1=0 then res:=c2;
if c2=0 then res:=c1;
if c1=c2 then res:=c1;
if (c1=1) and (c2=2) then res:=3;
if (c1=1) and (c2=3) then res:=1;
if (c1=1) and (c2=4) then res:=5;
if (c1=1) and (c2=5) then res:=5;
if (c1=1) and (c2=6) then res:=0;
if (c1=1) and (c2=7) then res:=2;
if (c1=2) and (c2=1) then res:=2;
if (c1=2) and (c2=3) then res:=3;
if (c1=2) and (c2=4) then res:=0;
if (c1=2) and (c2=5) then res:=1;
if (c1=2) and (c2=6) then res:=0;
if (c1=2) and (c2=7) then res:=2;
if (c1=3) and (c2=1) then res:=1;
if (c1=3) and (c2=2) then res:=3;
if (c1=3) and (c2=4) then res:=5;
if (c1=3) and (c2=5) then res:=5;
if (c1=3) and (c2=6) then res:=2;
if (c1=3) and (c2=7) then res:=2;
if (c1=4) and (c2=1) then res:=5;
if (c1=4) and (c2=2) then res:=0;
if (c1=4) and (c2=3) then res:=5;
if (c1=4) and (c2=5) then res:=5;
if (c1=4) and (c2=6) then res:=6;
if (c1=4) and (c2=7) then res:=6;
if (c1=5) and (c2=1) then res:=5;
if (c1=5) and (c2=2) then res:=1;
if (c1=5) and (c2=3) then res:=5;
if (c1=5) and (c2=4) then res:=5;
if (c1=5) and (c2=6) then res:=4;
if (c1=5) and (c2=7) then res:=0;
if (c1=6) and (c2=1) then res:=2;
if (c1=6) and (c2=2) then res:=0;
if (c1=6) and (c2=3) then res:=2;
if (c1=6) and (c2=4) then res:=4;
if (c1=6) and (c2=5) then res:=0;
if (c1=6) and (c2=7) then res:=6;
if (c1=7) and (c2=1) then res:=2;
if (c1=7) and (c2=2) then res:=7;
if (c1=7) and (c2=3) then res:=2;
if (c1=7) and (c2=4) then res:=6;
if (c1=7) and (c2=5) then res:=0;
if (c1=7) and (c2=6) then res:=7;
Avc:=res;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DBlur;
var v1,v2,v3,v4,v5,v6,ki,kj:integer;
label skeep,dok;
begin
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
for i:=windx1 to windx2 do
for j:=windy1 to windy2 do
begin
if mainspr[i+1,j+1]<>(colour*32+brightness) then
begin
redospr[i+1,j+1]:=mainspr[i+1,j+1];
goto skeep;
end;
v4:=0;
v3:=mainspr[i+1,j+1] div 32;
for ki:=-1 to 1 do
for kj:=-1 to 1 do
begin
if (ki<>0) and (kj<>0) then goto dok;
v1:=(i+1)+ki;
v2:=(j+1)+kj;
if v1<(windx1+1) then v1:=(windx1+1);
if v1>(windx2+1) then v1:=(windx2+1);
if v2<(windy1+1) then v2:=(windy1+1);
if v2>(windy2+1) then v2:=(windy2+1);
v4:=v4+(mainspr[v1,v2] mod 32);
v3:=Avc(v3,mainspr[v1,v2] div 32);
dok:
end;
v4:=v4 div 5{9};
if v4>31 then v4:=31;
redospr[i+1,j+1]:=v3*32+v4{Avc(Avc(v3*32+v4,(colour*32+brightness)),(colour*32+brightness))};
skeep:
end;
for i:=windx1 to windx2 do
for j:=windy1 to windy2 do
begin
mainspr[i+1,j+1]:=redospr[i+1,j+1];
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DBleed;
var v1,v2,v3,v4,v5,v6,ki,kj:integer;
begin
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
for i:=windx1 to windx2 do
for j:=windy1 to windy2-1 do
begin
if random(5)=0 then mainspr[i+1,j+2]:=mainspr[i+1,j+1];
end;

end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DMorph;
var v1,v2,v3,v4,v5,v6,ki,kj:integer;
    changed,ini:integer;
begin
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
changed:=0;
for i:=windx1 to windx2 do
for j:=windy1 to windy2 do
begin
v1:=mainspr[i+1,j+1] div 32;
v2:=mainspr[i+1,j+1] mod 32;
v3:=clipspr[i+1,j+1] div 32;
v4:=clipspr[i+1,j+1] mod 32;
ini:=mainspr[i+1,j+1];
mainspr[i+1,j+1]:=(Avc(v1,v3)*32)+((v2+v4) div 2);
if mainspr[i+1,j+1]<>ini then inc(changed);
end;
if changed<4 then
begin
for i:=windx1 to windx2 do
for j:=windy1 to windy2 do
begin
mainspr[i+1,j+1]:=clipspr[i+1,j+1];
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DMirr;
var v1,v2,v3,v4,v5,v6,ki,kj:integer;
begin
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
for i:=windx1 to windx2 do
for j:=windy1 to windy2 do
begin
v1:=mainspr[i+1,j+1] div 32;
v2:=mainspr[i+1,j+1] mod 32;
mainspr[i+1,j+1]:=v1*32+(31-v2);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure ChangeSingle;
begin
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
for i:=windx1 to windx2 do
for j:=windy1 to windy2 do
if mainspr[i+1,j+1]=backcolour then mainspr[i+1,j+1]:=colour*32+brightness
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure ExchangeSingle;
label zee;
begin
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
for i:=windx1 to windx2 do
for j:=windy1 to windy2 do
begin
if mainspr[i+1,j+1]=colour*32+brightness then
begin
mainspr[i+1,j+1]:=backcolour;
goto zee;
end;
if mainspr[i+1,j+1]=backcolour then mainspr[i+1,j+1]:=colour*32+brightness;
zee:
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure CopyWin;
begin
for i:=windx1 to windx2 do
begin
for j:=windy1 to windy2 do
begin
clipspr[(i-windx1)+1,(j-windy1)+1]:=mainspr[i+1,j+1];
end;
end;
cxsize:=windx2-windx1;
cysize:=windy2-windy1;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure CutWin;
begin
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
for i:=windx1 to windx2 do
begin
for j:=windy1 to windy2 do
begin
clipspr[(i-windx1)+1,(j-windy1)+1]:=mainspr[i+1,j+1];
mainspr[i+1,j+1]:=0;
DrawPoint(i,j,6,6,172,172);
end;
end;
cxsize:=windx2-windx1;
cysize:=windy2-windy1;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure RotWin;
begin
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
for i:=windx1 to windx2 do
begin
for j:=windy1 to windy2 do
begin
redospr[i+1,(windy2-(j-windy1))+1]:=mainspr[i+1,j+1];
mainspr[i+1,j+1]:=0;
end;
end;
for i:=windx1 to windx2 do
begin
for j:=windy1 to windy2 do
begin
mainspr[j+1,i+1]:=redospr[i+1,j+1];
end;
end;
twindx1:=windy1;
twindy1:=windx1;
twindx2:=windy2;
twindy2:=windx2;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
DrawMain;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure SkewHWin(angle:integer);
var crot,argn,carry:integer;
begin
crot:=1+((windx2-windx1) div (angle*2));
argn:=1;
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
for i:=windy1 to windy2 do
begin
argn:=argn+1;
if argn>angle then
begin
argn:=1;
dec(crot);
if crot<0 then crot:=windx2-windx1;
end;
for k:=0 to crot do
begin
carry:=mainspr[windx1+1,i];
for j:=windx1+1 to windx2 do
begin
mainspr[j,i]:=mainspr[j+1,i];
end;
mainspr[windx2+1,i]:=carry;
end;

end;
DrawMain;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure SkewVWin(angle:integer);
var crot,argn,carry:integer;
begin
crot:=1;
argn:=1;
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
for i:=windx1 to windx2 do
begin
argn:=argn+1;
if argn>angle then
begin
argn:=1;
dec(crot);
if crot<0 then crot:=windy2-windy1;
end;
for k:=0 to crot do
begin
carry:=mainspr[i+1,windy1+1];
for j:=windy1+1 to windy2 do
begin
mainspr[i+1,j]:=mainspr[i+1,j+1];
end;
mainspr[i+1,windy2+1]:=carry;
end;

end;
DrawMain;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure FlipHWin;
begin
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
for i:=windx1 to windx2 do
begin
for j:=windy1 to windy2 do
begin
redospr[(windx2-(i-windx1))+1,j+1]:=mainspr[i+1,j+1];
end;
end;
for i:=windx1 to windx2 do
begin
for j:=windy1 to windy2 do
begin
mainspr[i+1,j+1]:=redospr[i+1,j+1];
end;
end;
DrawMain;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure FlipVWin;
begin
twindx1:=windx1;
twindy1:=windy1;
twindx2:=windx2;
twindy2:=windy2;
SaveUndo;
windx1:=twindx1;
windy1:=twindy1;
windx2:=twindx2;
windy2:=twindy2;
for i:=windx1 to windx2 do
begin
for j:=windy1 to windy2 do
begin
redospr[i+1,(windy2-(j-windy1))+1]:=mainspr[i+1,j+1];
end;
end;
for i:=windx1 to windx2 do
begin
for j:=windy1 to windy2 do
begin
mainspr[i+1,j+1]:=redospr[i+1,j+1];
end;
end;
DrawMain;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Recharge;
begin
FlashButton(258,41,ba_rech);
txsize:=(windx2-windx1)+1;
tysize:=(windy2-windy1)+1;
for i:=windx1+1 to windx2+1 do
begin
for j:=windy1+1 to windy2+1 do
begin
textspr[i-windx1,j-windy1]:=mainspr[i,j];
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DrawPoint(ki,kj,scrx1,scry1,scrx2,scry2:integer);
var stepx,stepy:integer;
begin
inc(scrx1);
inc(scry1);
dec(scrx2);
dec(scry2);
inc(scrx1);
inc(scry1);
dec(scrx2);
dec(scry2);
inc(scrx1);
inc(scry1);
dec(scrx2);
dec(scry2);
stepx:=(scrx2-scrx1) div 32;
stepy:=(scry2-scry1) div 32;
for k:=(scry1+kj*stepy)+1 to (scry1+(kj+1)*stepy)-1 do
begin
line((scrx1+ki*stepx)+1,k,(scrx1+(ki+1)*stepx)-1,k,mainspr[ki+1,kj+1],vaddr2);
if (mainspr[ki+1,kj+1]=0) then pixel((scrx1+ki*stepx)+2,(scry1+kj*stepy)+2,5,vaddr2);
if (mainspr[ki+1,kj+1]=0) then pixel((scrx1+(ki+1)*stepx)-2,(scry1+(kj+1)*stepy)-2,5,vaddr2);
end;
pixel(178+ki,138+kj,mainspr[ki+1,kj+1],vaddr2);

end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DrawScreen(scrx1,scry1,scrx2,scry2,scol,cs1,sbak:integer;dogrid,dobak:boolean;where:word);
var stepx,stepy:integer;
begin
inc(cs1);
if dobak then
begin
for i:=scrx1 to scrx2 do
begin
line (i,scry1,i,scry2,sbak,where);
end;
end;
line(scrx1+0,scry1+0,scrx2-0,scry1+0,scol+000,where);
line(scrx2-0,scry1+0,scrx2-0,scry2-0,scol+000,where);
line(scrx1+0,scry2-0,scrx2-0,scry2-0,scol+000,where);
line(scrx1+0,scry1+0,scrx1+0,scry2-0,scol+000,where);
line(scrx1+0,scry1+0,scrx2-1,scry1+0,scol+cs1,where);
line(scrx1+0,scry1+0,scrx1+0,scry2-1,scol+cs1,where);
line(scrx2+0,scry2+0,scrx2+0,scry1+0,scol-cs1,where);
line(scrx2+0,scry2+0,scrx1+0,scry2+0,scol-cs1,where);
inc(scrx1);
inc(scry1);
dec(scrx2);
dec(scry2);
line(scrx1+0,scry1+0,scrx2-0,scry1+0,scol+000,where);
line(scrx2-0,scry1+0,scrx2-0,scry2-0,scol+000,where);
line(scrx1+0,scry2-0,scrx2-0,scry2-0,scol+000,where);
line(scrx1+0,scry1+0,scrx1+0,scry2-0,scol+000,where);
inc(scrx1);
inc(scry1);
dec(scrx2);
dec(scry2);
line(scrx1+0,scry1+0,scrx2-0,scry1+0,scol+000,where);
line(scrx2-0,scry1+0,scrx2-0,scry2-0,scol+000,where);
line(scrx1+0,scry2-0,scrx2-0,scry2-0,scol+000,where);
line(scrx1+0,scry1+0,scrx1+0,scry2-0,scol+000,where);
line(scrx1+0,scry1+0,scrx2-1,scry1+0,scol-cs1,where);
line(scrx1+0,scry1+0,scrx1+0,scry2-1,scol-cs1,where);
line(scrx2+0,scry2+0,scrx2+0,scry1+0,scol+cs1,where);
line(scrx2+0,scry2+0,scrx1+0,scry2+0,scol+cs1,where);
inc(scrx1);
inc(scry1);
dec(scrx2);
dec(scry2);
stepx:=(scrx2-scrx1) div 32;
stepy:=(scry2-scry1) div 32;
if dogrid then
begin
for i:=1 to 31 do
begin
if i mod 8<>0 then line(scrx1+i*stepx,scry1,scrx1+i*stepx,scry2,6,where);
if i mod 8<>0 then line(scrx1,scry1+i*stepy,scrx2,scry1+i*stepy,6,where);
end;
for i:=1 to 31 do
begin
if i mod 8=0 then line(scrx1+i*stepx,scry1,scrx1+i*stepx,scry2,8,where);
if i mod 8=0 then line(scrx1,scry1+i*stepy,scrx2,scry1+i*stepy,8,where);
end;
for i:=1 to 31 do
begin
if i=ssize then line(scrx1+i*stepx,scry1,scrx1+i*stepx,scry2,10,where);
if i=ssize then line(scrx1,scry1+i*stepy,scrx2,scry1+i*stepy,10,where);
end;

for i:=0 to 31 do
begin
for j:=0 to 31 do
begin
for k:=(scry1+j*stepy)+1 to (scry1+(j+1)*stepy)-1 do
begin
line((scrx1+i*stepx)+1,k,(scrx1+(i+1)*stepx)-1,k,mainspr[i+1,j+1],vaddr2);
if (mainspr[i+1,j+1]=0) then pixel((scrx1+i*stepx)+2,(scry1+j*stepy)+2,5,vaddr2);
if (mainspr[i+1,j+1]=0) then pixel((scrx1+(i+1)*stepx)-2,(scry1+(j+1)*stepy)-2,5,vaddr2);
pixel(178+i,138+j,mainspr[i+1,j+1],vaddr2);
end;
end;
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function Overbutton(Bx,By:integer):boolean;
var res:boolean;
begin
res:=false;
if (MouseX>=bx) and (MouseY>=by) and (MouseX<=bx+15) and (MouseY<=by+15) then res:=true;
OverButton:=res;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure FlashButton(Bx,By:integer;krno:img16);
begin
flip(vaddr2,vaddr);
putimg16(Bx,By,krno,vaddr);
putimg16(MouseX,MouseY,c_sageata3,vaddr);
flip(vaddr,vga);
delay(100);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DrawPalSelector;
begin
PutImg16(296,138,bn_for2bak,vaddr2);
PutImg16(296,154,bn_xforbak,vaddr2);
DrawScreen(275,135,291,152,ss1,ss2,colour*32+brightness,false,true,vaddr2);
DrawScreen(275,154,291,172,ss1,ss2,backcolour,false,true,vaddr2);
DrawScreen(253,135,273,172,ss1,ss2,0,false,false,vaddr2);
DrawScreen(6,174,115,193,ss1,ss2,0,false,false,vaddr2);
DrawScreen(117,174,314,193,ss1,ss2,0,false,false,vaddr2);
for n:=0 to 7 do
begin
DrawBox3(9+n*13,177,11,13,(n*32)+12,70,4,1,false,vaddr2);
end;
DrawBox3(9+colour*13,177,11,13,(colour*32)+12,70,-4,-1,false,vaddr2);
for n:=0 to 31 do
begin
DrawBox3(120+n*6,177,4,13,(colour*32)+n,70,2,1,false,vaddr2);
end;
DrawBox3(120+brightness*6,177,4,13,(colour*32)+brightness,70,-2,-1,false,vaddr2);
line(122+brightness*6,183,122+brightness*6,184,(colour*32)+(31-brightness),vaddr2);
line(123+brightness*6,183,123+brightness*6,184,(colour*32)+(31-brightness),vaddr2);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure OperatePalSelector;
begin
if OverButton(296,138) then
begin
FlashButton(296,138,ba_for2bak);
backcolour:=colour*32+brightness;
DrawPalSelector;
end;
if OverButton(296,154) then
begin
FlashButton(296,154,ba_xforbak);
n:=colour*32+brightness;
colour:=backcolour div 32;
brightness:=backcolour mod 32;
backcolour:=n;
DrawPalSelector;
end;
for k:=0 to 7 do
begin
if (MouseX>=9+k*13) and (MouseY>=177) and (MouseX<=21+k*13) and (MouseY<=190) then
begin
colour:=k;
DrawPalSelector;
end;
end;
for k:=0 to 31 do
begin
if (MouseX>=120+k*6) and (MouseY>=177) and (MouseX<=132+k*6) and (MouseY<=190) then
begin
brightness:=k;
DrawPalSelector;
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure NewSprite;
label bilbo;
var kko:integer;
begin
ssize:=32;
sname:='SPRITE  .SPR';
windx2:=ssize-1;
windy2:=ssize-1;
for i:=1 to 32 do for j:=1 to 32 do mainspr[i,j]:=0;
bilbo:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DrawBut;
begin
if tool=1 then Putimg16(178,9,ba_felttip,vaddr2);
if tool=2 then Putimg16(194,9,ba_line,vaddr2);
if tool=3 then Putimg16(210,9,ba_rectangle,vaddr2);
if tool=4 then Putimg16(226,9,ba_filledrect,vaddr2);
if tool=5 then Putimg16(242,9,ba_flood,vaddr2);
if tool=6 then Putimg16(178,89,ba_eyedrop,vaddr2);
if tool<>1 then Putimg16(178,9,bn_felttip,vaddr2);
if tool<>2 then Putimg16(194,9,bn_line,vaddr2);
if tool<>3 then Putimg16(210,9,bn_rectangle,vaddr2);
if tool<>4 then Putimg16(226,9,bn_filledrect,vaddr2);
if tool<>5 then Putimg16(242,9,bn_flood,vaddr2);
if tool<>6 then Putimg16(178,89,bn_eyedrop,vaddr2);
Putimg16(258,9,bn_fw,vaddr2);
if tmode=1 then Putimg16(178,25,ba_cray,vaddr2);
if tmode=2 then Putimg16(194,25,ba_chalk,vaddr2);
if tmode=3 then Putimg16(210,25,ba_charc,vaddr2);
if tmode=4 then Putimg16(226,25,ba_tint,vaddr2);
if tmode=5 then Putimg16(242,25,ba_text,vaddr2);
if tmode=6 then Putimg16(258,25,ba_paint,vaddr2);
if tmode=7 then Putimg16(178,41,ba_wind,vaddr2);
if tmode=8 then Putimg16(194,41,ba_paste,vaddr2);
if tmode=9 then Putimg16(210,41,ba_mask,vaddr2);
if tmode<>1 then Putimg16(178,25,bn_cray,vaddr2);
if tmode<>2 then Putimg16(194,25,bn_chalk,vaddr2);
if tmode<>3 then Putimg16(210,25,bn_charc,vaddr2);
if tmode<>4 then Putimg16(226,25,bn_tint,vaddr2);
if tmode<>5 then Putimg16(242,25,bn_text,vaddr2);
if tmode<>6 then Putimg16(258,25,bn_paint,vaddr2);
if tmode<>7 then Putimg16(178,41,bn_wind,vaddr2);
if tmode<>8 then Putimg16(194,41,bn_paste,vaddr2);
if tmode<>9 then Putimg16(210,41,bn_mask,vaddr2);

Putimg16(281,9,bn_new,vaddr2);
Putimg16(281,25,bn_load,vaddr2);
Putimg16(281,41,bn_save,vaddr2);
Putimg16(281,57,bn_smem,vaddr2);
Putimg16(281,73,bn_undo,vaddr2);
Putimg16(281,89,bn_iesire,vaddr2);

Putimg16(226,41,bn_copy,vaddr2);
Putimg16(242,41,bn_cut,vaddr2);
Putimg16(258,41,bn_rech,vaddr2);
Putimg16(178,57,bn_fliph,vaddr2);
Putimg16(194,57,bn_flipv,vaddr2);
Putimg16(210,57,bn_rot,vaddr2);
Putimg16(226,57,bn_skewh,vaddr2);
Putimg16(242,57,bn_skewv,vaddr2);
Putimg16(258,57,bn_size,vaddr2);
Putimg16(194,89,bn_csing,vaddr2);
Putimg16(210,89,bn_xsing,vaddr2);
Putimg16(226,89,bn_ccolr,vaddr2);
Putimg16(242,89,bn_xcolr,vaddr2);
Putimg16(178,73,bn_static,vaddr2);
Putimg16(194,73,bn_blur,vaddr2);
Putimg16(210,73,bn_bleed,vaddr2);
Putimg16(226,73,bn_mirr,vaddr2);
Putimg16(242,73,bn_morph,vaddr2);
Putimg16(258,73,bn_anim,vaddr2);
Putimg16(258,89,bn_wand,vaddr2);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DrawSFName(FX,FY:integer;FilenameK:string;where:word);
var filename:array[0..11] of char;
begin
for i:=0 to 11 do
begin
filename[i]:=' ';
end;
for i:=0 to (pos('.',FilenameK)-2) do
begin
filename[i]:=filenameK[i+1];
end;
for i:=0 to 11 do
begin
if filename[i]='A' then putimg16(FX+i*9,FY,lea,where);
if filename[i]='B' then putimg16(FX+i*9,FY,leb,where);
if filename[i]='C' then putimg16(FX+i*9,FY,lec,where);
if filename[i]='D' then putimg16(FX+i*9,FY,led,where);
if filename[i]='E' then putimg16(FX+i*9,FY,lee,where);
if filename[i]='F' then putimg16(FX+i*9,FY,lef,where);
if filename[i]='G' then putimg16(FX+i*9,FY,leg,where);
if filename[i]='H' then putimg16(FX+i*9,FY,leh,where);
if filename[i]='I' then putimg16(FX+i*9,FY,lei,where);
if filename[i]='J' then putimg16(FX+i*9,FY,lej,where);
if filename[i]='K' then putimg16(FX+i*9,FY,lek,where);
if filename[i]='L' then putimg16(FX+i*9,FY,lel,where);
if filename[i]='M' then putimg16(FX+i*9,FY,lem,where);
if filename[i]='N' then putimg16(FX+i*9,FY,len,where);
if filename[i]='O' then putimg16(FX+i*9,FY,leo,where);
if filename[i]='P' then putimg16(FX+i*9,FY,lep,where);
if filename[i]='Q' then putimg16(FX+i*9,FY,leq,where);
if filename[i]='R' then putimg16(FX+i*9,FY,ler,where);
if filename[i]='S' then putimg16(FX+i*9,FY,les,where);
if filename[i]='T' then putimg16(FX+i*9,FY,let,where);
if filename[i]='U' then putimg16(FX+i*9,FY,leu,where);
if filename[i]='V' then putimg16(FX+i*9,FY,lev,where);
if filename[i]='W' then putimg16(FX+i*9,FY,lew,where);
if filename[i]='X' then putimg16(FX+i*9,FY,lex,where);
if filename[i]='Y' then putimg16(FX+i*9,FY,ley,where);
if filename[i]='Z' then putimg16(FX+i*9,FY,lez,where);
if filename[i]='_' then putimg16(FX+i*9,FY,le_,where);
if filename[i]='0' then putimg16(FX+i*9,FY,le0,where);
if filename[i]='1' then putimg16(FX+i*9,FY,le1,where);
if filename[i]='2' then putimg16(FX+i*9,FY,le2,where);
if filename[i]='3' then putimg16(FX+i*9,FY,le3,where);
if filename[i]='4' then putimg16(FX+i*9,FY,le4,where);
if filename[i]='5' then putimg16(FX+i*9,FY,le5,where);
if filename[i]='6' then putimg16(FX+i*9,FY,le6,where);
if filename[i]='7' then putimg16(FX+i*9,FY,le7,where);
if filename[i]='8' then putimg16(FX+i*9,FY,le8,where);
if filename[i]='9' then putimg16(FX+i*9,FY,le9,where);
if filename[i]='.' then putimg16(FX+i*9,FY,ledot,where);
if filename[i]='\' then putimg16(FX+i*9,FY,leslash,where);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}

procedure DrawMain;
begin
DrawScreen(1,1,319,198,ss1,ss2,0,false,false,vaddr2);
DrawBox(4,4,311,191,ss3,70,ss4,2,false,vaddr2);
DrawScreen(175,135,212,172,ss1,ss2,0,false,true,vaddr2);
DrawScreen(214,135,251,172,ss1,ss2,0,false,true,vaddr2);
DrawScreen(293,135,314,172,ss1,ss2,0,false,false,vaddr2);
DrawPalSelector;
DrawScreen(175,6,276,107,ss1,ss2,0,false,false,vaddr2);
DrawScreen(278,6,299,107,ss1,ss2,0,false,true,vaddr2);
DrawScreen(301,6,314,107,ss1,ss2,0,false,false,vaddr2);
DrawScreen(175,109,284,133,ss1,ss2,0,false,true,vaddr2);
DrawScreen(286,109,314,133,ss1,ss2,0,false,true,vaddr2);
DrawSFname(180,114,sname,vaddr2);
if (ssize div 10)=0 then PutImg16(292,114,le0,vaddr2);
if (ssize div 10)=1 then PutImg16(292,114,le1,vaddr2);
if (ssize div 10)=2 then PutImg16(292,114,le2,vaddr2);
if (ssize div 10)=3 then PutImg16(292,114,le3,vaddr2);
if (ssize div 10)=4 then PutImg16(292,114,le4,vaddr2);
if (ssize div 10)=5 then PutImg16(292,114,le5,vaddr2);
if (ssize div 10)=6 then PutImg16(292,114,le6,vaddr2);
if (ssize div 10)=7 then PutImg16(292,114,le7,vaddr2);
if (ssize div 10)=8 then PutImg16(292,114,le8,vaddr2);
if (ssize div 10)=9 then PutImg16(292,114,le9,vaddr2);
if (ssize mod 10)=0 then PutImg16(301,114,le0,vaddr2);
if (ssize mod 10)=1 then PutImg16(301,114,le1,vaddr2);
if (ssize mod 10)=2 then PutImg16(301,114,le2,vaddr2);
if (ssize mod 10)=3 then PutImg16(301,114,le3,vaddr2);
if (ssize mod 10)=4 then PutImg16(301,114,le4,vaddr2);
if (ssize mod 10)=5 then PutImg16(301,114,le5,vaddr2);
if (ssize mod 10)=6 then PutImg16(301,114,le6,vaddr2);
if (ssize mod 10)=7 then PutImg16(301,114,le7,vaddr2);
if (ssize mod 10)=8 then PutImg16(301,114,le8,vaddr2);
if (ssize mod 10)=9 then PutImg16(301,114,le9,vaddr2);
DrawScreen(6,6,172,172,ss1,ss2,0,true,true,vaddr2);
DrawBut;
DrawText;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DrawGhostLine(x1,y1,x2,y2:integer);
begin
line (6+(X1)*5,6+(Y1)*5,6+(X2)*5,6+(Y2)*5,colour*32+brightness,vaddr);
line (7+(X1)*5,6+(Y1)*5,7+(X2)*5,6+(Y2)*5,colour*32+brightness,vaddr);
line (6+(X1)*5,7+(Y1)*5,6+(X2)*5,7+(Y2)*5,colour*32+brightness,vaddr);
line (7+(X1)*5,7+(Y1)*5,7+(X2)*5,7+(Y2)*5,colour*32+brightness,vaddr);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DrawRGhostLine(x1,y1,x2,y2:integer;lcolor:integer);
begin
if (lcolor>-1) then
begin
line (6+(X1)*5,6+(Y1)*5,6+(X2)*5,6+(Y2)*5,lcolor,vaddr);
line (7+(X1)*5,6+(Y1)*5,7+(X2)*5,6+(Y2)*5,lcolor,vaddr);
line (6+(X1)*5,7+(Y1)*5,6+(X2)*5,7+(Y2)*5,lcolor,vaddr);
line (7+(X1)*5,7+(Y1)*5,7+(X2)*5,7+(Y2)*5,lcolor,vaddr);
end;
if (lcolor=-1) then
begin
funnyline2 (6+(X1)*5,6+(Y1)*5,6+(X2)*5,6+(Y2)*5,176,144,0,vaddr);
funnyline2 (7+(X1)*5,6+(Y1)*5,7+(X2)*5,6+(Y2)*5,176,144,0,vaddr);
funnyline2 (6+(X1)*5,7+(Y1)*5,6+(X2)*5,7+(Y2)*5,176,144,0,vaddr);
funnyline2 (7+(X1)*5,7+(Y1)*5,7+(X2)*5,7+(Y2)*5,176,144,0,vaddr);
end;
if (lcolor>-26) and (lcolor<-9) then
begin
if gump=0 then
begin
funnyline (6+(X1)*5,6+(Y1)*5,6+(X2)*5,6+(Y2)*5,48,(abs(lcolor)-10),vaddr);
funnyline (7+(X1)*5,6+(Y1)*5,7+(X2)*5,6+(Y2)*5,48,(abs(lcolor)-10),vaddr);
funnyline (6+(X1)*5,7+(Y1)*5,6+(X2)*5,7+(Y2)*5,48,(abs(lcolor)-10),vaddr);
funnyline (7+(X1)*5,7+(Y1)*5,7+(X2)*5,7+(Y2)*5,48,(abs(lcolor)-10),vaddr);
end;
if gump=1 then
begin
funnyline (6+(X1)*5,6+(Y1)*5,6+(X2)*5,6+(Y2)*5,176,(abs(lcolor)-10),vaddr);
funnyline (7+(X1)*5,6+(Y1)*5,7+(X2)*5,6+(Y2)*5,176,(abs(lcolor)-10),vaddr);
funnyline (6+(X1)*5,7+(Y1)*5,6+(X2)*5,7+(Y2)*5,176,(abs(lcolor)-10),vaddr);
funnyline (7+(X1)*5,7+(Y1)*5,7+(X2)*5,7+(Y2)*5,176,(abs(lcolor)-10),vaddr);
end;
end;
if (lcolor>-43) and (lcolor<-25) then
begin
funnyline (6+(X1)*5,6+(Y1)*5,6+(X2)*5,6+(Y2)*5,144,(abs(lcolor)-26),vaddr);
funnyline (7+(X1)*5,6+(Y1)*5,7+(X2)*5,6+(Y2)*5,144,(abs(lcolor)-26),vaddr);
funnyline (6+(X1)*5,7+(Y1)*5,6+(X2)*5,7+(Y2)*5,144,(abs(lcolor)-26),vaddr);
funnyline (7+(X1)*5,7+(Y1)*5,7+(X2)*5,7+(Y2)*5,144,(abs(lcolor)-26),vaddr);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure RestoreByThumbnail;
begin
 for i:=0 to 31 do
 for j:=0 to 31 do
 begin
 mainspr[i+1,j+1]:=point(178+i,138+j);
 Drawpoint(i,j,6,6,172,172);
 end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure SubFnPoint(RIxI,RiyI:integer);
begin
 if (random(10)=0) and (RIxI>0) and (RIxI<33) and (RIyI>0) and (RIyI<33) then
 begin
 mainspr[RIxI,RIyI]:=colour*32+brightness;
 DrawPoint(RIxI-1,RIyI-1,6,6,172,172);
 end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure OperateTool1;
var vc,vb:integer;
    RIx,RIy:integer;
begin
if (GX>=0) and (GY>=0) and (GX<llkx) and (gy<llky) then
begin
 if (tmode=1) then
 begin
 mainspr[GX+1,GY+1]:=colour*32+brightness;
 DrawPoint(GX,GY,6,6,172,172);
 end;
 if (tmode=2) then
 begin
 vc:=mainspr[GX+1,GY+1] div 32;
 vb:=mainspr[GX+1,GY+1] mod 32;
 if (vb=0) and (vc=0) then vb:=-1;
 if vb<31 then vb:=vb+1;
 mainspr[GX+1,GY+1]:=vc*32+vb;
 DrawPoint(GX,GY,6,6,172,172);
 end;
 if (tmode=3) then
 begin
 vc:=mainspr[GX+1,GY+1] div 32;
 vb:=mainspr[GX+1,GY+1] mod 32;
 if vb>0 then vb:=vb-1;
 mainspr[GX+1,GY+1]:=vc*32+vb;
 DrawPoint(GX,GY,6,6,172,172);
 end;
 if (tmode=4) then
 begin
 vc:=colour;
 vb:=mainspr[GX+1,GY+1] mod 32;
 mainspr[GX+1,GY+1]:=vc*32+vb;
 DrawPoint(GX,GY,6,6,172,172);
 end;
 if (tmode=5) then
 begin
 RIx:=GX+0;
 RIy:=GY-1;
 SubFNPoint(RIx,RIy);
 RIx:=GX+1;
 RIy:=GY-1;
 SubFNPoint(RIx,RIy);
 RIx:=GX+2;
 RIy:=GY-1;
 SubFNPoint(RIx,RIy);
 RIx:=GX+0;
 RIy:=GY+3;
 SubFNPoint(RIx,RIy);
 RIx:=GX+1;
 RIy:=GY+3;
 SubFNPoint(RIx,RIy);
 RIx:=GX+2;
 RIy:=GY+3;
 SubFNPoint(RIx,RIy);
 for i:=0 to 2 do
 begin
 RIx:=GX-1;
 RIy:=GY+I;
 SubFNPoint(RIx,RIy);
 RIx:=GX+0;
 RIy:=GY+I;
 SubFNPoint(RIx,RIy);
 RIx:=GX+1;
 RIy:=GY+I;
 SubFNPoint(RIx,RIy);
 RIx:=GX+2;
 RIy:=GY+I;
 SubFNPoint(RIx,RIy);
 RIx:=GX+3;
 RIy:=GY+I;
 SubFNPoint(RIx,RIy);
 end;
 end;
 if (tmode=6) then
 begin
 vc:=textspr[(GX mod txsize)+1,(GY mod tysize)+1];
 mainspr[GX+1,GY+1]:=vc;
 DrawPoint(GX,GY,6,6,172,172);
 end;
 if (tmode=10) then
 begin
 mainspr[GX+1,GY+1]:=mainspr[GX+1,GY+1] xor 128;
 DrawPoint(GX,GY,6,6,172,172);
 end;
StatMouse;
if (bstat=0) then bload:=5;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure MSprayLine(a,b,c,d:integer;col:byte;where:word);
  function sgn(a:real):integer;
  begin
       if a>0 then sgn:=+1;
       if a<0 then sgn:=-1;
       if a=0 then sgn:=0;
  end;
var i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;
    count:integer;
    zii:integer;
    zbrg,zcol:integer;
begin
     count:=50;
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
          if random(2)=0 then pixel(a,b,col,where);
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
END;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure PaintLine(a,b,c,d:integer;where:word);
  function sgn(a:real):integer;
  begin
       if a>0 then sgn:=+1;
       if a<0 then sgn:=-1;
       if a=0 then sgn:=0;
  end;
var i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;
    count:integer;
    zii:integer;
    col:integer;
begin
     count:=50;
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
          col:=textspr[((a-178) mod txsize)+1,((b-138) mod tysize)+1];
          pixel(a,b,col,where);
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
END;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}

procedure OperateTool2;
label Zend;
begin
if (GX>=0) and (GY>=0) and (GX<llkx) and (gy<llky) and (sp=false) then
begin
 bload:=10;
 sp:=true;
 LX:=GX;
 LY:=GY;
goto Zend;
end;
if (GX>=0) and (GY>=0) and (GX<llkx) and (gy<llky) and (sp=true) then
begin
 bload:=10;
 if tmode=1 then line(178+GX,138+GY,178+Lx,138+LY,colour*32+brightness,vaddr2);
 if tmode=2 then Tline(178+GX,138+GY,178+Lx,138+LY,colour*32+brightness,1,vaddr2);
 if tmode=3 then Tline(178+GX,138+GY,178+Lx,138+LY,colour*32+brightness,-1,vaddr2);
 if tmode=4 then Tintline(178+GX,138+GY,178+Lx,138+LY,colour,vaddr2);
 if tmode=5 then MSprayline(178+GX,138+GY,178+Lx,138+LY,colour*32+brightness,vaddr2);
 if tmode=6 then Paintline(178+GX,138+GY,178+Lx,138+LY,vaddr2);
 if tmode=10 then ORXline(178+GX,138+GY,178+Lx,138+LY,colour,vaddr2);
 RestoreByThumbnail;
 sp:=false;
end;
Zend:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure OperateTool3;
label Zend;
begin
if (GX>=0) and (GY>=0) and (GX<llkx) and (gy<llky) and (sp=false) then
begin
 bload:=10;
 sp:=true;
 LX:=GX;
 LY:=GY;
 windx1:=0;
 windy1:=0;
 windx2:=ssize-1;
 windy2:=ssize-1;
 if (tmode=8) and (cxsize<>-1) then
 begin
 SaveUndo;
 sp:=false;
 twindx2:=gx+cxsize;
 twindy2:=gy+cysize;
 if twindx2>31 then twindx2:=31;
 if twindy2>31 then twindy2:=31;
 for i:=gx+1 to twindx2+1 do
 begin
 for j:=gy+1 to twindy2+1 do
 begin
 mainspr[i,j]:=clipspr[i-gx,j-gy];
 end;
 end;
 DrawMain;
 end;
 if (tmode=9) and (cxsize<>-1) then
 begin
 SaveUndo;
 sp:=false;
 twindx2:=gx+cxsize;
 twindy2:=gy+cysize;
 if twindx2>31 then twindx2:=31;
 if twindy2>31 then twindy2:=31;
 for i:=gx+1 to twindx2+1 do
 begin
 for j:=gy+1 to twindy2+1 do
 begin
 if clipspr[i-gx,j-gy]>0 then mainspr[i,j]:=clipspr[i-gx,j-gy];
 end;
 end;
 DrawMain;
 end;
goto Zend;
end;
if (GX>=0) and (GY>=0) and (GX<llkx) and (gy<llky) and (sp=true) then
begin
 if lx>gx then
 begin
 bload:=lx;
 lx:=gx;
 gx:=bload;
 end;
 if ly>gy then
 begin
 bload:=ly;
 ly:=gy;
 gy:=bload;
 end;
 bload:=10;
 if (tmode=1) then
 begin
 line(178+LX,138+LY,177+GX,138+LY,colour*32+brightness,vaddr2);
 line(178+GX,138+LY,178+GX,137+GY,colour*32+brightness,vaddr2);
 line(178+GX,138+GY,179+LX,138+GY,colour*32+brightness,vaddr2);
 line(178+LX,138+GY,178+LX,139+LY,colour*32+brightness,vaddr2);
 end;
 if (tmode=2) then
 begin
 tline(178+LX,138+LY,177+GX,138+LY,colour*32+brightness,1,vaddr2);
 tline(178+GX,138+LY,178+GX,137+GY,colour*32+brightness,1,vaddr2);
 tline(178+GX,138+GY,179+LX,138+GY,colour*32+brightness,1,vaddr2);
 tline(178+LX,138+GY,178+LX,139+LY,colour*32+brightness,1,vaddr2);
 end;
 if (tmode=3) then
 begin
 tline(178+LX,138+LY,177+GX,138+LY,colour*32+brightness,-1,vaddr2);
 tline(178+GX,138+LY,178+GX,137+GY,colour*32+brightness,-1,vaddr2);
 tline(178+GX,138+GY,179+LX,138+GY,colour*32+brightness,-1,vaddr2);
 tline(178+LX,138+GY,178+LX,139+LY,colour*32+brightness,-1,vaddr2);
 end;
 if (tmode=4) then
 begin
 tintline(178+LX,138+LY,177+GX,138+LY,colour,vaddr2);
 tintline(178+GX,138+LY,178+GX,137+GY,colour,vaddr2);
 tintline(178+GX,138+GY,179+LX,138+GY,colour,vaddr2);
 tintline(178+LX,138+GY,178+LX,139+LY,colour,vaddr2);
 end;
 if (tmode=5) then
 begin
 sprayline(178+LX,138+LY,177+GX,138+LY,colour*32+brightness,vaddr2);
 sprayline(178+GX,138+LY,178+GX,137+GY,colour*32+brightness,vaddr2);
 sprayline(178+GX,138+GY,179+LX,138+GY,colour*32+brightness,vaddr2);
 sprayline(178+LX,138+GY,178+LX,139+LY,colour*32+brightness,vaddr2);
 end;
 if (tmode=6) then
 begin
 paintline(178+LX,138+LY,177+GX,138+LY,vaddr2);
 paintline(178+GX,138+LY,178+GX,137+GY,vaddr2);
 paintline(178+GX,138+GY,179+LX,138+GY,vaddr2);
 paintline(178+LX,138+GY,178+LX,139+LY,vaddr2);
 end;
 if (tmode=7) and (lx<ssize) and (ly<ssize) then
 begin
 windx1:=lx;
 windy1:=ly;
 windx2:=gx;
 windy2:=gy;
 end;
 if (tmode=10) then
 begin
 ORXline(178+LX,138+LY,177+GX,138+LY,colour,vaddr2);
 ORXline(178+GX,138+LY,178+GX,137+GY,colour,vaddr2);
 ORXline(178+GX,138+GY,179+LX,138+GY,colour,vaddr2);
 ORXline(178+LX,138+GY,178+LX,139+LY,colour,vaddr2);
 end;
 RestoreByThumbnail;
 sp:=false;
end;
Zend:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure OperateTool4;
label Zend;
begin
if (GX>=0) and (GY>=0) and (GX<llkx) and (gy<llky) and (sp=false) then
begin
 bload:=10;
 sp:=true;
 LX:=GX;
 LY:=GY;
goto Zend;
end;
if (GX>=0) and (GY>=0) and (GX<llkx) and (gy<llky) and (sp=true) then
begin
 if lx>gx then
 begin
 bload:=lx;
 lx:=gx;
 gx:=bload;
 end;
 if ly>gy then
 begin
 bload:=ly;
 ly:=gy;
 gy:=bload;
 end;
 for i:=LX to GX do
 begin
 if tmode=1 then line(178+i,138+LY,178+i,138+GY,colour*32+brightness,vaddr2);
 if tmode=2 then Tline(178+i,138+LY,178+i,138+GY,colour*32+brightness,1,vaddr2);
 if tmode=3 then Tline(178+i,138+LY,178+i,138+GY,colour*32+brightness,-1,vaddr2);
 if tmode=4 then Tintline(178+i,138+LY,178+i,138+GY,colour,vaddr2);
 if tmode=5 then DSprayline(178+i,138+LY,178+i,138+GY,colour*32+brightness,vaddr2);
 if tmode=6 then Paintline(178+i,138+LY,178+i,138+GY,vaddr2);
 if tmode=10 then ORXline(178+i,138+LY,178+i,138+GY,colour,vaddr2);
 end;
 RestoreByThumbnail;
 bload:=10;
 sp:=false;
end;
Zend:
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure SubFNFillCol(mid,drow,borgcolour:integer);
var v1,v2,v3,v4:integer;
begin
inc(energy);
v1:=-1;
v2:=drow-1;
while(mainspr[mid,v2]=borgcolour) and (v2>0) do
begin
redospr[mid,v2]:=colour*32+brightness;
if energy<m10 then SubFNFIllRow(mid,v2,borgcolour);
v2:=v2+v1;
end;
v1:=1;
v2:=drow;
while(mainspr[mid,v2]=borgcolour) and (v2<33) do
begin
redospr[mid,v2]:=colour*32+brightness;
if energy<m10 then SubFNFIllRow(mid,v2,borgcolour);
v2:=v2+v1;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure SubFNFillRow(mid,drow,borgcolour:integer);
var v1,v2,v3,v4:integer;
begin
inc(energy);
v1:=-1;
v2:=mid-1;
while(mainspr[v2,drow]=borgcolour) and (v2>0) do
begin
redospr[v2,drow]:=colour*32+brightness;
if energy<m10 then SubFNFillCol(v2,drow,borgcolour);
v2:=v2+v1;
end;
v1:=1;
v2:=mid;
while(mainspr[v2,drow]=borgcolour) and (v2<33) do
begin
redospr[v2,drow]:=colour*32+brightness;
if energy<m10 then SubFNFillCol(v2,drow,borgcolour);
v2:=v2+v1;
end;
dec(energy);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure OperateTool5;
var b1,b2,b3,b4:integer;
    vc,vb:integer;
    dree:integer;
begin
dree:=mainspr[GX+1,GY+1];
energy:=0;
for i:=1 to 32 do
for j:=1 to 32 do
begin
redospr[i,j]:=255;
end;
if (GX>=0) and (GY>=0) and (GX<llkx) and (gy<llky) then
begin
SubFNFillCol(GX+1,GY+1,dree);
b1:=GY+1;
b2:=-1;
b3:=b1-1;
while((mainspr[GX,b3]=dree) and (b3>0)) do
begin
SubFNFillRow(GX,b3,dree);
b3:=b3+b2;
end;
b2:=1;
b3:=b1;
while((mainspr[GX,b3]=dree)and (b3<33)) do
begin
SubFNFillRow(GX,b3,dree);
b3:=b3+b2;
end;
end;
for i:=1 to 32 do
for j:=1 to 32 do
begin
if redospr[i,j]<>255 then
begin
 GX:=i-1;
 GY:=j-1;
 if (tmode=1) then
 begin
 mainspr[GX+1,GY+1]:=colour*32+brightness;
 DrawPoint(GX,GY,6,6,172,172);
 end;
 if (tmode=2) then
 begin
 vc:=mainspr[GX+1,GY+1] div 32;
 vb:=mainspr[GX+1,GY+1] mod 32;
 if (vb=0) and (vc=0) then vb:=-1;
 if vb<31 then vb:=vb+1;
 mainspr[GX+1,GY+1]:=vc*32+vb;
 DrawPoint(GX,GY,6,6,172,172);
 end;
 if (tmode=3) then
 begin
 vc:=mainspr[GX+1,GY+1] div 32;
 vb:=mainspr[GX+1,GY+1] mod 32;
 if vb>0 then vb:=vb-1;
 mainspr[GX+1,GY+1]:=vc*32+vb;
 DrawPoint(GX,GY,6,6,172,172);
 end;
 if (tmode=4) then
 begin
 vc:=colour;
 vb:=mainspr[GX+1,GY+1] mod 32;
 mainspr[GX+1,GY+1]:=vc*32+vb;
 DrawPoint(GX,GY,6,6,172,172);
 end;
 if (tmode=5) then
 begin
 if random(5)=0 then
 begin
 mainspr[GX+1,GY+1]:=colour*32+brightness;
 DrawPoint(GX,GY,6,6,172,172);
 end;
 end;
 if (tmode=6) then
 begin
 mainspr[GX+1,GY+1]:=textspr[(GX mod txsize)+1,(GY mod tysize)+1];
 DrawPoint(GX,GY,6,6,172,172);
 end;
 if (tmode=10) then
 begin
 mainspr[GX+1,GY+1]:=mainspr[GX+1,GY+1] xor 128;
 DrawPoint(GX,GY,6,6,172,172);
 end;

end;
end;
DrawMain;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure OperateTool6;
begin
GX:=(MouseX) div 5;
GY:=(MouseY) div 5;
if (GX>=0) and (GY>=0) and (GX<llkx) and (gy<llky) then
begin
colour:=mainspr[GX,GY] div 32;
brightness:=mainspr[GX,GY] mod 32;
end;
DrawPalSelector;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DrawFName(FX,FY:integer;Filename:string;where:word);
var gfilename:array [0..11] of char;
    u:integer;
label nkk;
begin
for i:=0 to 11 do
begin
gfilename[i]:=' ';
end;
u:=pos('.',filename);
if (u=1) or (u=0) then begin for i:=0 to 11 do gfilename[i]:=filename[i+1]; goto nkk;end;
for i:=0 to u-2 do
begin
gfilename[i]:=filename[i+1];
end;
gfilename[8]:=filename[u];
gfilename[9]:=filename[u+1];
gfilename[10]:=filename[u+2];
gfilename[11]:=filename[u+3];
nkk:
for i:=0 to 11 do
begin
if gfilename[i]='A' then putimg16(FX+i*9,FY,lea,where);
if gfilename[i]='B' then putimg16(FX+i*9,FY,leb,where);
if gfilename[i]='C' then putimg16(FX+i*9,FY,lec,where);
if gfilename[i]='D' then putimg16(FX+i*9,FY,led,where);
if gfilename[i]='E' then putimg16(FX+i*9,FY,lee,where);
if gfilename[i]='F' then putimg16(FX+i*9,FY,lef,where);
if gfilename[i]='G' then putimg16(FX+i*9,FY,leg,where);
if gfilename[i]='H' then putimg16(FX+i*9,FY,leh,where);
if gfilename[i]='I' then putimg16(FX+i*9,FY,lei,where);
if gfilename[i]='J' then putimg16(FX+i*9,FY,lej,where);
if gfilename[i]='K' then putimg16(FX+i*9,FY,lek,where);
if gfilename[i]='L' then putimg16(FX+i*9,FY,lel,where);
if gfilename[i]='M' then putimg16(FX+i*9,FY,lem,where);
if gfilename[i]='N' then putimg16(FX+i*9,FY,len,where);
if gfilename[i]='O' then putimg16(FX+i*9,FY,leo,where);
if gfilename[i]='P' then putimg16(FX+i*9,FY,lep,where);
if gfilename[i]='Q' then putimg16(FX+i*9,FY,leq,where);
if gfilename[i]='R' then putimg16(FX+i*9,FY,ler,where);
if gfilename[i]='S' then putimg16(FX+i*9,FY,les,where);
if gfilename[i]='T' then putimg16(FX+i*9,FY,let,where);
if gfilename[i]='U' then putimg16(FX+i*9,FY,leu,where);
if gfilename[i]='V' then putimg16(FX+i*9,FY,lev,where);
if gfilename[i]='W' then putimg16(FX+i*9,FY,lew,where);
if gfilename[i]='X' then putimg16(FX+i*9,FY,lex,where);
if gfilename[i]='Y' then putimg16(FX+i*9,FY,ley,where);
if gfilename[i]='Z' then putimg16(FX+i*9,FY,lez,where);
if gfilename[i]='_' then putimg16(FX+i*9,FY,le_,where);
if gfilename[i]='0' then putimg16(FX+i*9,FY,le0,where);
if gfilename[i]='1' then putimg16(FX+i*9,FY,le1,where);
if gfilename[i]='2' then putimg16(FX+i*9,FY,le2,where);
if gfilename[i]='3' then putimg16(FX+i*9,FY,le3,where);
if gfilename[i]='4' then putimg16(FX+i*9,FY,le4,where);
if gfilename[i]='5' then putimg16(FX+i*9,FY,le5,where);
if gfilename[i]='6' then putimg16(FX+i*9,FY,le6,where);
if gfilename[i]='7' then putimg16(FX+i*9,FY,le7,where);
if gfilename[i]='8' then putimg16(FX+i*9,FY,le8,where);
if gfilename[i]='9' then putimg16(FX+i*9,FY,le9,where);
if gfilename[i]='.' then putimg16(FX+i*9,FY,ledot,where);
if gfilename[i]='\' then putimg16(FX+i*9,FY,leslash,where);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure BriteDrawFName(FX,FY:integer;Filename:string;where:word);
var gfilename:array [0..11] of char;
    u:integer;
label nkk;
begin
for i:=0 to 11 do
begin
gfilename[i]:=' ';
end;
u:=pos('.',filename);
if (u=1) or (u=0) then begin for i:=0 to 11 do gfilename[i]:=filename[i+1]; goto nkk;end;
for i:=0 to u-2 do
begin
gfilename[i]:=filename[i+1];
end;
gfilename[8]:=filename[u];
gfilename[9]:=filename[u+1];
gfilename[10]:=filename[u+2];
gfilename[11]:=filename[u+3];
nkk:
for i:=0 to 11 do
begin
if gfilename[i]='A' then putimg16b(FX+i*9,FY,lea,where);
if gfilename[i]='B' then putimg16b(FX+i*9,FY,leb,where);
if gfilename[i]='C' then putimg16b(FX+i*9,FY,lec,where);
if gfilename[i]='D' then putimg16b(FX+i*9,FY,led,where);
if gfilename[i]='E' then putimg16b(FX+i*9,FY,lee,where);
if gfilename[i]='F' then putimg16b(FX+i*9,FY,lef,where);
if gfilename[i]='G' then putimg16b(FX+i*9,FY,leg,where);
if gfilename[i]='H' then putimg16b(FX+i*9,FY,leh,where);
if gfilename[i]='I' then putimg16b(FX+i*9,FY,lei,where);
if gfilename[i]='J' then putimg16b(FX+i*9,FY,lej,where);
if gfilename[i]='K' then putimg16b(FX+i*9,FY,lek,where);
if gfilename[i]='L' then putimg16b(FX+i*9,FY,lel,where);
if gfilename[i]='M' then putimg16b(FX+i*9,FY,lem,where);
if gfilename[i]='N' then putimg16b(FX+i*9,FY,len,where);
if gfilename[i]='O' then putimg16b(FX+i*9,FY,leo,where);
if gfilename[i]='P' then putimg16b(FX+i*9,FY,lep,where);
if gfilename[i]='Q' then putimg16b(FX+i*9,FY,leq,where);
if gfilename[i]='R' then putimg16b(FX+i*9,FY,ler,where);
if gfilename[i]='S' then putimg16b(FX+i*9,FY,les,where);
if gfilename[i]='T' then putimg16b(FX+i*9,FY,let,where);
if gfilename[i]='U' then putimg16b(FX+i*9,FY,leu,where);
if gfilename[i]='V' then putimg16b(FX+i*9,FY,lev,where);
if gfilename[i]='W' then putimg16b(FX+i*9,FY,lew,where);
if gfilename[i]='X' then putimg16b(FX+i*9,FY,lex,where);
if gfilename[i]='Y' then putimg16b(FX+i*9,FY,ley,where);
if gfilename[i]='Z' then putimg16b(FX+i*9,FY,lez,where);
if gfilename[i]='_' then putimg16b(FX+i*9,FY,le_,where);
if gfilename[i]='0' then putimg16b(FX+i*9,FY,le0,where);
if gfilename[i]='1' then putimg16b(FX+i*9,FY,le1,where);
if gfilename[i]='2' then putimg16b(FX+i*9,FY,le2,where);
if gfilename[i]='3' then putimg16b(FX+i*9,FY,le3,where);
if gfilename[i]='4' then putimg16b(FX+i*9,FY,le4,where);
if gfilename[i]='5' then putimg16b(FX+i*9,FY,le5,where);
if gfilename[i]='6' then putimg16b(FX+i*9,FY,le6,where);
if gfilename[i]='7' then putimg16b(FX+i*9,FY,le7,where);
if gfilename[i]='8' then putimg16b(FX+i*9,FY,le8,where);
if gfilename[i]='9' then putimg16b(FX+i*9,FY,le9,where);
if gfilename[i]='.' then putimg16b(FX+i*9,FY,ledot,where);
if gfilename[i]='\' then putimg16b(FX+i*9,FY,leslash,where);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure SubFNDrawDirInfo(selectedd:integer;start:integer);
var gi,gj:integer;
    zaggy:array[0..11] of char;
    thepath:string;
    thisdir:array[0..11] of char;
    zap,var1:integer;
    reevey:string;
begin
thepath:='';
for i:=0 to 11 do
begin
thisdir[i]:=' ';
end;
DrawScreen(6,6,172,172,ss1,ss2,0,false,true,vaddr2);
GetDir(0,thepath);
for i:=0 to length(thepath) do
begin
if copy(thepath,i,1)='\' then var1:=i+1;
end;
zap:=0;
for i:=var1 to length(thepath) do
begin
reevey:=copy(thepath,i,1);
thisdir[zap]:=reevey[1];
inc(zap);
end;
if thisdir[0]=' ' then thisdir[0]:='\';
BriteDrawFName(36,16,thisdir,vaddr2);
for gi:=0 to 4 do
begin
zaggy:='            ';
for gj:=0 to 11 do
begin
zaggy[gj]:=info[gi+start,gj];
end;
if (gi+start)=0 then zaggy:='\           ';
if gi=selectedd then DrawBox4(34,38+(gi)*20,(4+9*12)-2,18,brightegreen,70,2,1,false,vaddr2);
DrawFname(36,40+(gi)*20,zaggy,vaddr2);
end;
flip(vaddr2,vaddr);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function SubFNRefreshDirInfo(pathey:string):integer;
var cinf:integer;
    ziggy:string;
    DirInfo:SearchRec;
    jiji:integer;
begin
jiji:=0;
ChDir(pathey);
for i:=1 to 40 do
begin
info[i]:='            ';
end;
cinf:=1;
FindFirst('*.*', 16, DirInfo);
while (DosError = 0) and (cinf<250) do
begin
  ziggy:='            ';
  ziggy:=DirInfo.Name;
  for j:=0 to 11 do
  begin
  info[cinf,j]:=ziggy[j+1];
  end;
  FindNext(DirInfo);
  cinf:=cinf+1;
  inc(jiji);
  {$I-}
  ChDir(ziggy);
  if (IoResult<>0) or
  ((ziggy[1]='.') and (ziggy[2]=' ')) then
  begin
  dec(cinf);
  dec(jiji);
  for j:=0 to 11 do
  begin
  info[cinf,j]:=' ';
  end;
  end;
  {$I+}
  ChDir(pathey);
end;
SubFnRefreshDirInfo:=jiji;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function EnterPath(AX,AY:integer):string;
const hilitecol=brightegreen;
var pathy:string;
    gi,gj:integer;
    zaggy:array[0..11] of char;
    start:integer;
    selectd:integer;
    charc:char;
    oldpath:string;
    filmax:integer;
label dired;
begin
selectd:=1;
LimtMouse(18,159,138,157);
MoveMouse(117,145);
GetDir(0,pathy);
GetDir(0,oldpath);
filmax:=SubFNRefreshDirInfo(pathy);
start:=0;
repeat
SubFNDrawDirInfo(selectd,start);
putimg16(AX,AY,c_sageata3,vaddr2);
repeat
StatMouse;
flip(vaddr2,vaddr);
if (MouseX>015) and (MouseX<042) then begin DrawBox4(016,143,17,19,hilitecol,70,2,1,false,vaddr); charc:='u'; end;
if (MouseX>041) and (MouseX<073) then begin DrawBox4(048,143,17,19,hilitecol,70,2,1,false,vaddr); charc:='d'; end;
if (MouseX>072) and (MouseX<112) then begin DrawBox4(080,143,17,19,hilitecol,70,2,1,false,vaddr); charc:='i'; end;
if (MouseX>111) and (MouseX<144) then begin DrawBox4(112,143,17,19,hilitecol,70,2,1,false,vaddr); charc:='o'; end;
if (MouseX>143) and (MouseX<159) then begin DrawBox4(144,143,17,19,hilitecol,70,2,1,false,vaddr); charc:='c'; end;
putimg16(021,145,leup,vaddr);
putimg16(053,145,ledown,vaddr);
putimg16(085,145,leindir,vaddr);
putimg16(117,145,leok,vaddr);
putimg16(149,145,lecancel,vaddr);
DrawBox4(12,13,154,20,brighteyellow,70,2,1,false,vaddr);
DrawBox4(12,13,154,127,brighteyellow,70,2,1,false,vaddr);
DrawBox4(12,140,154,25,brighteyellow,70,2,1,false,vaddr);
waitretrace;
flip(vaddr,vga);
until (bstat<>0);
bload:=4;
if (charc='d') then
begin
inc(selectd);
if (selectd>filmax) then selectd:=filmax;
if selectd>4 then
begin
selectd:=4;
if start<(filmax-4) then inc(start);
end;
end;
if (charc='u') then
begin
dec(selectd);
if selectd<0 then
begin
selectd:=0;
if start>0 then dec(start);
end;
end;
if (charc='i') then
begin
for i:=0 to 11 do
begin
zaggy[i]:=' ';
zaggy[i+1]:=' ';
zaggy[i]:=info[start+selectd,i];
end;
if (zaggy[0]='.') and (zaggy[1]='.') then
begin
chdir('..');
goto dired;
end;
if (zaggy[0]=chr(0)) then
begin
chdir('\');
goto dired;
end;
chdir (zaggy);
dired:
GetDir(0,pathy);
filmax:=SubFNRefreshDirInfo(pathy);
start:=0;
selectd:=1;
end;
until (charc='o') or (charc='c');
DrawMain;
bstat:=0;
LimtMouse(0,maxlimx,0,184);
MoveMouse(AX,AY);
GetDir(0,pathy);
if charc='c' then pathy:='- cancelled -';
ChDir(oldpath);
if (charc='o') and (pathy<>oldpath) then
begin
stf:=0;
stf2:=1;
end;
EnterPath:=pathy;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure SubFNDrawFileInfo(selectedd:integer;start:integer);
var gi,gj:integer;
    zaggy:array[0..11] of char;
begin
DrawScreen(6,6,172,172,ss1,ss2,0,false,true,vaddr2);
for gi:=0 to 5 do
begin
zaggy:='            ';
for gj:=0 to 11 do
begin
zaggy[gj]:=info[gi+start,gj];
end;
if gi=selectedd then DrawBox4(34,17+(gi)*20,(4+9*12)-2,18,brightegreen,70,2,1,false,vaddr2);
DrawFname(36,19+(gi)*20,zaggy,vaddr2);
if gi=selectedd then kreed:=zaggy;
end;
flip(vaddr2,vaddr);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function SubFNRefreshFileInfo(pathey:string):integer;
var cinf:integer;
    ziggy:string;
    DirInfo:SearchRec;
    jiji:integer;
begin
jiji:=0;
ChDir(pathey);
for i:=1 to 40 do
begin
info[i]:='            ';
end;
cinf:=1;
FindFirst('*.spr', 16, DirInfo);
while (DosError = 0) and (cinf<250) do
begin
  ziggy:='            ';
  ziggy:=DirInfo.Name;
  for j:=0 to 11 do
  begin
  info[cinf,j]:=ziggy[j+1];
  end;
  FindNext(DirInfo);
  cinf:=cinf+1;
  inc(jiji);
  {$I-}
  ChDir(ziggy);
  if (IoResult=0) then
  begin
  dec(cinf);
  dec(jiji);
  for j:=0 to 11 do
  begin
  info[cinf,j]:=' ';
  end;
  end;
  {$I+}
  ChDir(pathey);
end;
SubFnRefreshFileInfo:=jiji;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function EnterFile(AX,AY:integer):string;
const hilitecol=brightegreen;
      bordercol=brighteyellow;
var pathy:string;
    gi,gj:integer;
    zaggy:array[0..11] of char;
    start:integer;
    selectd:integer;
    charc:char;
    oldpath:string;
    filmax:integer;
label dired,wrong;
begin
kreed:='';
selectd:=stf;
LimtMouse(18,159,138,157);
MoveMouse(117,145);
GetDir(0,pathy);
GetDir(0,oldpath);
filmax:=SubFNRefreshFileInfo(pathy);
if filmax=0 then
begin
pathy:='- no files here -';
goto wrong
end;
start:=stf2;
repeat
SubFNDrawFileInfo(selectd,start);
putimg16(AX,AY,c_sageata3,vaddr2);
repeat
StatMouse;
flip(vaddr2,vaddr);
if (MouseX>015) and (MouseX<042) then begin DrawBox4(016,143,17,19,hilitecol,70,2,1,false,vaddr); charc:='u'; end;
if (MouseX>041) and (MouseX<073) then begin DrawBox4(048,143,17,19,hilitecol,70,2,1,false,vaddr); charc:='d'; end;
if (MouseX>072) and (MouseX<112) then begin DrawBox4(080,143,17,19,hilitecol,70,2,1,false,vaddr); charc:='i'; end;
if (MouseX>111) and (MouseX<144) then begin DrawBox4(112,143,17,19,hilitecol,70,2,1,false,vaddr); charc:='o'; end;
if (MouseX>143) and (MouseX<159) then begin DrawBox4(144,143,17,19,hilitecol,70,2,1,false,vaddr); charc:='c'; end;
putimg16(021,145,leup,vaddr);
putimg16(053,145,ledown,vaddr);
putimg16(085,145,lewhdir,vaddr);
putimg16(117,145,leok,vaddr);
putimg16(149,145,lecancel,vaddr);
DrawBox4(12,13,154,127,brighteyellow,70,2,1,false,vaddr);
DrawBox4(12,140,154,25,brighteyellow,70,2,1,false,vaddr);
waitretrace;
flip(vaddr,vga);
until (bstat<>0);
bload:=2;
if (charc='d') then
begin
inc(selectd);
if (selectd>filmax-1) then selectd:=filmax-1;
if selectd>5 then
begin
selectd:=5;
if start<(filmax-5) then inc(start);
end;
end;
if (charc='u') then
begin
dec(selectd);
if selectd<0 then
begin
selectd:=0;
if start>1 then dec(start);
end;
end;
until (charc='o') or (charc='c') or (charc='i');
pathy:=kreed;
wrong:
DrawMain;
bstat:=0;
LimtMouse(0,maxlimx,0,184);
MoveMouse(AX,AY);
if charc='c' then pathy:='- cancelled -';
if charc='i' then pathy:='- want directory -';
if pathy=kreed then stf:=selectd;
if pathy=kreed then stf2:=start;
EnterFile:=pathy;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Function SubFNGetCharFromUser:char;
const hilitecol = brightegreen;
var charc:char;
begin
repeat
StatMouse;
flip(vaddr2,vaddr);
if (MouseY>57) and (MouseY<78) then
begin
if (MouseX>015) and (MouseX<032) then begin DrawBox4(016,58,17,19,hilitecol,70,2,1,false,vaddr); charc:='A'; end;
if (MouseX>031) and (MouseX<048) then begin DrawBox4(032,58,17,19,hilitecol,70,2,1,false,vaddr); charc:='B'; end;
if (MouseX>047) and (MouseX<064) then begin DrawBox4(048,58,17,19,hilitecol,70,2,1,false,vaddr); charc:='C'; end;
if (MouseX>063) and (MouseX<080) then begin DrawBox4(064,58,17,19,hilitecol,70,2,1,false,vaddr); charc:='D'; end;
if (MouseX>079) and (MouseX<096) then begin DrawBox4(080,58,17,19,hilitecol,70,2,1,false,vaddr); charc:='E'; end;
if (MouseX>095) and (MouseX<112) then begin DrawBox4(096,58,17,19,hilitecol,70,2,1,false,vaddr); charc:='F'; end;
if (MouseX>111) and (MouseX<128) then begin DrawBox4(112,58,17,19,hilitecol,70,2,1,false,vaddr); charc:='G'; end;
if (MouseX>127) and (MouseX<144) then begin DrawBox4(128,58,17,19,hilitecol,70,2,1,false,vaddr); charc:='H'; end;
if (MouseX>143) and (MouseX<159) then begin DrawBox4(144,58,17,19,hilitecol,70,2,1,false,vaddr); charc:='I'; end;
end;
if (MouseY>77) and (MouseY<98) then
begin
if (MouseX>015) and (MouseX<032) then begin DrawBox4(016,78,17,19,hilitecol,70,2,1,false,vaddr); charc:='J'; end;
if (MouseX>031) and (MouseX<048) then begin DrawBox4(032,78,17,19,hilitecol,70,2,1,false,vaddr); charc:='K'; end;
if (MouseX>047) and (MouseX<064) then begin DrawBox4(048,78,17,19,hilitecol,70,2,1,false,vaddr); charc:='L'; end;
if (MouseX>063) and (MouseX<080) then begin DrawBox4(064,78,17,19,hilitecol,70,2,1,false,vaddr); charc:='M'; end;
if (MouseX>079) and (MouseX<096) then begin DrawBox4(080,78,17,19,hilitecol,70,2,1,false,vaddr); charc:='N'; end;
if (MouseX>095) and (MouseX<112) then begin DrawBox4(096,78,17,19,hilitecol,70,2,1,false,vaddr); charc:='O'; end;
if (MouseX>111) and (MouseX<128) then begin DrawBox4(112,78,17,19,hilitecol,70,2,1,false,vaddr); charc:='P'; end;
if (MouseX>127) and (MouseX<144) then begin DrawBox4(128,78,17,19,hilitecol,70,2,1,false,vaddr); charc:='Q'; end;
if (MouseX>143) and (MouseX<159) then begin DrawBox4(144,78,17,19,hilitecol,70,2,1,false,vaddr); charc:='R'; end;
end;
if (MouseY>97) and (MouseY<118) then
begin
if (MouseX>015) and (MouseX<032) then begin DrawBox4(016,98,17,19,hilitecol,70,2,1,false,vaddr); charc:='S'; end;
if (MouseX>031) and (MouseX<048) then begin DrawBox4(032,98,17,19,hilitecol,70,2,1,false,vaddr); charc:='T'; end;
if (MouseX>047) and (MouseX<064) then begin DrawBox4(048,98,17,19,hilitecol,70,2,1,false,vaddr); charc:='U'; end;
if (MouseX>063) and (MouseX<080) then begin DrawBox4(064,98,17,19,hilitecol,70,2,1,false,vaddr); charc:='V'; end;
if (MouseX>079) and (MouseX<096) then begin DrawBox4(080,98,17,19,hilitecol,70,2,1,false,vaddr); charc:='W'; end;
if (MouseX>095) and (MouseX<112) then begin DrawBox4(096,98,17,19,hilitecol,70,2,1,false,vaddr); charc:='X'; end;
if (MouseX>111) and (MouseX<128) then begin DrawBox4(112,98,17,19,hilitecol,70,2,1,false,vaddr); charc:='Y'; end;
if (MouseX>127) and (MouseX<144) then begin DrawBox4(128,98,17,19,hilitecol,70,2,1,false,vaddr); charc:='Z'; end;
if (MouseX>143) and (MouseX<159) then begin DrawBox4(144,98,17,19,hilitecol,70,2,1,false,vaddr); charc:='_'; end;
end;
if (MouseY>117) and (MouseY<138) then
begin
if (MouseX>015) and (MouseX<032) then begin DrawBox4(016,118,17,19,hilitecol,70,2,1,false,vaddr); charc:='1'; end;
if (MouseX>031) and (MouseX<048) then begin DrawBox4(032,118,17,19,hilitecol,70,2,1,false,vaddr); charc:='2'; end;
if (MouseX>047) and (MouseX<064) then begin DrawBox4(048,118,17,19,hilitecol,70,2,1,false,vaddr); charc:='3'; end;
if (MouseX>063) and (MouseX<080) then begin DrawBox4(064,118,17,19,hilitecol,70,2,1,false,vaddr); charc:='4'; end;
if (MouseX>079) and (MouseX<096) then begin DrawBox4(080,118,17,19,hilitecol,70,2,1,false,vaddr); charc:='5'; end;
if (MouseX>095) and (MouseX<112) then begin DrawBox4(096,118,17,19,hilitecol,70,2,1,false,vaddr); charc:='6'; end;
if (MouseX>111) and (MouseX<128) then begin DrawBox4(112,118,17,19,hilitecol,70,2,1,false,vaddr); charc:='7'; end;
if (MouseX>127) and (MouseX<144) then begin DrawBox4(128,118,17,19,hilitecol,70,2,1,false,vaddr); charc:='8'; end;
if (MouseX>143) and (MouseX<159) then begin DrawBox4(144,118,17,19,hilitecol,70,2,1,false,vaddr); charc:='9'; end;
end;
if (MouseY>137) and (MouseY<158) then
begin
if (MouseX>015) and (MouseX<042) then begin DrawBox4(016,138,17,19,hilitecol,70,2,1,false,vaddr); charc:='0'; end;
if (MouseX>041) and (MouseX<073) then begin DrawBox4(048,138,17,19,hilitecol,70,2,1,false,vaddr); charc:='e'; end;
if (MouseX>072) and (MouseX<112) then begin DrawBox4(080,138,17,19,hilitecol,70,2,1,false,vaddr); charc:='c'; end;
if (MouseX>111) and (MouseX<144) then begin DrawBox4(112,138,17,19,hilitecol,70,2,1,false,vaddr); charc:='b'; end;
if (MouseX>143) and (MouseX<159) then begin DrawBox4(144,138,17,19,hilitecol,70,2,1,false,vaddr); charc:='m'; end;
end;
putimg16(021,140,le0,vaddr);
putimg16(053,140,leok,vaddr);
putimg16(085,140,lecancel,vaddr);
putimg16(117,140,leback,vaddr);
putimg16(149,140,lememory,vaddr);

putimg16(021,120,le1,vaddr);
putimg16(037,120,le2,vaddr);
putimg16(053,120,le3,vaddr);
putimg16(069,120,le4,vaddr);
putimg16(085,120,le5,vaddr);
putimg16(101,120,le6,vaddr);
putimg16(117,120,le7,vaddr);
putimg16(133,120,le8,vaddr);
putimg16(149,120,le9,vaddr);
putimg16(021,60,lea,vaddr);
putimg16(037,60,leb,vaddr);
putimg16(053,60,lec,vaddr);
putimg16(069,60,led,vaddr);
putimg16(085,60,lee,vaddr);
putimg16(101,60,lef,vaddr);
putimg16(117,60,leg,vaddr);
putimg16(133,60,leh,vaddr);
putimg16(149,60,lei,vaddr);
putimg16(021,80,lej,vaddr);
putimg16(037,80,lek,vaddr);
putimg16(053,80,lel,vaddr);
putimg16(069,80,lem,vaddr);
putimg16(085,80,len,vaddr);
putimg16(101,80,leo,vaddr);
putimg16(117,80,lep,vaddr);
putimg16(133,80,leq,vaddr);
putimg16(149,80,ler,vaddr);
putimg16(021,100,les,vaddr);
putimg16(037,100,let,vaddr);
putimg16(053,100,leu,vaddr);
putimg16(069,100,lev,vaddr);
putimg16(085,100,lew,vaddr);
putimg16(101,100,lex,vaddr);
putimg16(117,100,ley,vaddr);
putimg16(133,100,lez,vaddr);
putimg16(149,100,le_,vaddr);
putimg16(AX,AY,c_sageata3,vaddr);
DrawBox4(12,54,154,107,brighteyellow,70,2,1,false,vaddr);
DrawBox4(12,17,154,20,brighteyellow,70,2,1,false,vaddr);
waitretrace;
flip(vaddr,vga);
until (bstat<>0);
SubFNGetCharFromUser:=charc;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function EnterName(AX,AY:integer):string;
var character:char;
    fname:array[0..11] of char;
    posn:integer;
begin
fname:='        .SPR';
posn:=0;
LimtMouse(18,159,60,156);
MoveMouse(53,140);
repeat
DrawScreen(6,6,172,172,ss1,ss2,0,false,true,vaddr2);
DrawFname(36,20,fname,vaddr2);
character:=SubFNGetCharFromUser;
if (character>='A') and (character<='Z') and (posn<8) then
begin
fname[posn]:=character;
inc(posn);
end;
if (character>='0') and (character<='9') and (posn<8) then
begin
fname[posn]:=character;
inc(posn);
end;
if (character='_') and (posn<8) then
begin
fname[posn]:=character;
inc(posn);
end;
if (character='b') and (posn>0) then
begin
dec(posn);
fname[posn]:=' ';
end;
if (character='m') then
begin
posn:=8;
for i:=0 to 8 do
begin
fname[i]:=oname[i];
end;
for i:=8 downto 0 do
begin
if fname[i]=' ' then posn:=i;
end;
end;
bload:=10;
until ((character='e') or (character='c'));
if character='e' then
begin
for i:=0 to 8 do
begin
oname[i]:=fname[i];
end;
end;
if character='c' then fname:='- canceled -';
DrawMain;
bstat:=0;
LimtMouse(0,maxlimx,0,184);
MoveMouse(AX,AY);
EnterName:=fname;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function EnterSize(AX,AY:integer):integer;
const hilitecol=brightegreen;
var result:integer;
begin
LimtMouse(50,100,40,136);
MoveMouse(75,136);
result:=0;
repeat
DrawScreen(6,6,172,172,ss1,ss2,0,false,true,vaddr2);
putimg16(AX,AY,c_sageata3,vaddr2);
repeat
StatMouse;
flip(vaddr2,vaddr);
if (MouseY>29) and (MouseY<50) then begin DrawBox4(65,38,48,18,hilitecol,70,2,1,false,vaddr); result:=8; end;
if (MouseY>49) and (MouseY<70) then begin DrawBox4(65,58,48,18,hilitecol,70,2,1,false,vaddr); result:=16; end;
if (MouseY>69) and (MouseY<90) then begin DrawBox4(65,78,48,18,hilitecol,70,2,1,false,vaddr); result:=24; end;
if (MouseY>89) and (MouseY<110) then begin DrawBox4(65,98,48,18,hilitecol,70,2,1,false,vaddr); result:=32; end;
if (MouseY>109) and (MouseY<137) then begin DrawBox4(65,118,48,18,hilitecol,70,2,1,false,vaddr); result:=-1; end;
putimg16(67,40,le0,vaddr);
putimg16(76,40,le8,vaddr);
putimg16(85,40,lex,vaddr);
putimg16(94,40,le0,vaddr);
putimg16(103,40,le8,vaddr);
putimg16(67,60,le1,vaddr);
putimg16(76,60,le6,vaddr);
putimg16(85,60,lex,vaddr);
putimg16(94,60,le1,vaddr);
putimg16(103,60,le6,vaddr);
putimg16(67,80,le2,vaddr);
putimg16(76,80,le4,vaddr);
putimg16(85,80,lex,vaddr);
putimg16(94,80,le2,vaddr);
putimg16(103,80,le4,vaddr);
putimg16(67,100,le3,vaddr);
putimg16(76,100,le2,vaddr);
putimg16(85,100,lex,vaddr);
putimg16(94,100,le3,vaddr);
putimg16(103,100,le2,vaddr);

putimg16(85,120,lecancel,vaddr);
DrawBox4(12,34,154,107,brighteyellow,70,2,1,false,vaddr);
waitretrace;
flip(vaddr,vga);
until (bstat<>0);
bload:=2;
until (result<>0);
DrawMain;
bstat:=0;
LimtMouse(0,maxlimx,0,184);
MoveMouse(AX,AY);
EnterSize:=result;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function EnterSkew(AX,AY:integer):integer;
const hilitecol=brightegreen;
var result:integer;
begin
LimtMouse(50,100,40,136);
MoveMouse(75,136);
result:=0;
repeat
DrawScreen(6,6,172,172,ss1,ss2,0,false,true,vaddr2);
putimg16(AX,AY,c_sageata3,vaddr2);
repeat
StatMouse;
flip(vaddr2,vaddr);
if (MouseY>29) and (MouseY<50) then begin DrawBox4(73,38,32,18,hilitecol,70,2,1,false,vaddr); result:=1; end;
if (MouseY>49) and (MouseY<70) then begin DrawBox4(73,58,32,18,hilitecol,70,2,1,false,vaddr); result:=2; end;
if (MouseY>69) and (MouseY<90) then begin DrawBox4(73,78,32,18,hilitecol,70,2,1,false,vaddr); result:=3; end;
if (MouseY>89) and (MouseY<110) then begin DrawBox4(73,98,32,18,hilitecol,70,2,1,false,vaddr); result:=4; end;
if (MouseY>109) and (MouseY<137) then begin DrawBox4(73,118,32,18,hilitecol,70,2,1,false,vaddr); result:=-1; end;

putimg16(76,40,le4,vaddr);
putimg16(85,40,le5,vaddr);
putimg16(94,40,ledeg,vaddr);

putimg16(76,60,le2,vaddr);
putimg16(85,60,le7,vaddr);
putimg16(94,60,ledeg,vaddr);

putimg16(76,80,le1,vaddr);
putimg16(85,80,le4,vaddr);
putimg16(94,80,ledeg,vaddr);

putimg16(76,100,le1,vaddr);
putimg16(85,100,le1,vaddr);
putimg16(94,100,ledeg,vaddr);

putimg16(85,120,lecancel,vaddr);
DrawBox4(12,34,154,107,brighteyellow,70,2,1,false,vaddr);
waitretrace;
flip(vaddr,vga);
until (bstat<>0);
bload:=2;
until (result<>0);
DrawMain;
bstat:=0;
LimtMouse(0,maxlimx,0,184);
MoveMouse(AX,AY);
EnterSkew:=result;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure SaveIt;
label ZOZO;
var filen,pathe:string;
    sizeo:integer;
    f:file of byte;
label abandon,restart;
begin
AX:=MouseX;
AY:=MouseY;
restart:
pathe:=EnterPath(AX,AY);
if pathe='- cancelled -' then goto abandon;
filen:=EnterName(AX,AY);
if filen='- canceled -' then goto abandon;
if filen[1]=' ' then goto abandon;
sizeo:=EnterSize(AX,AY);
if sizeo=-1 then goto abandon;

chdir(pathe);
assign(f,filen);
rewrite(f);
for i:=1 to sizeo do
for j:=1 to sizeo do
begin
write(f,mainspr[j,i]);
end;
close(f);
ssize:=sizeo;
sname:=filen;
windx2:=ssize;
windy2:=ssize;
abandon:
ClipSprite;
DrawMain;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure SaveDj;
label ZOZO;
var filen,pathe:string;
    sizeo:integer;
    f:file of byte;
label abandon,restart;
begin
AX:=MouseX;
AY:=MouseY;
filen:=sname;
sizeo:=ssize;
assign(f,filen);
rewrite(f);
for i:=1 to sizeo do
for j:=1 to sizeo do
begin
write(f,mainspr[j,i]);
end;
close(f);
ssize:=sizeo;
sname:=filen;
windx2:=ssize;
windy2:=ssize;
abandon:
ClipSprite;
DrawMain;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure LoadIt;
label ZOZO;
var filen,pathe:string;
    sizeo:integer;
    f:file of byte;
    fatr:word;
label abandon,restart,loadzfile;
begin
AX:=MouseX;
AY:=MouseY;
goto loadzfile;
restart:
pathe:=EnterPath(AX,AY);
if pathe='- cancelled -' then goto abandon;
chdir(pathe);
loadzfile:
filen:=EnterFile(AX,AY);
if filen='- cancelled -' then goto abandon;
if filen='- no files here -' then goto restart;
if filen='- want directory -' then goto restart;
assign(f,filen);
GetFattr(f,fatr);
fatr:=fatr and (not ReadOnly);
SetFattr(f,fatr);
reset(f);
if filesize(f)=8*8 then sizeo:=8;
if filesize(f)=16*16 then sizeo:=16;
if filesize(f)=24*24 then sizeo:=24;
if filesize(f)=32*32 then sizeo:=32;
newSprite;
for i:=1 to sizeo do
for j:=1 to sizeo do
begin
read(f,mainspr[j,i]);
end;
close(f);
ssize:=sizeo;
sname:=filen;
windx2:=ssize;
windy2:=ssize;
abandon:
DrawMain;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure OperateButtons;
var iosize:integer;
begin
if OverButton(281,9) then
begin
FlashButton(281,9,ba_new);
SaveUndo;
NewSprite;
DrawMain;
end;
if OverButton(281,25) then
begin
SaveUndo;
FlashButton(281,25,ba_load);
LoadIt;
end;
if OverButton(281,41) then
begin
SaveUndo;
FlashButton(281,41,ba_save);
SaveIt;
end;
if OverButton(281,57) then
begin
FlashButton(281,57,ba_smem);
SaveDj;
end;
if OverButton(281,73) then
begin
FlashButton(281,73,ba_undo);
RestoreUndo;
DrawMain;
end;
if OverButton(281,89) then
begin
FlashButton(281,89,ba_iesire);
exitnow:=1;
end;
if OverButton(226,41) then
begin
FlashButton(226,41,ba_copy);
CopyWin;
end;
if OverButton(178,57) then
begin
FlashButton(178,57,ba_fliph);
FlipHWin;
end;
if OverButton(194,57) then
begin
FlashButton(194,57,ba_flipv);
FlipVWin;
end;
if OverButton(210,57) then
begin
FlashButton(210,57,ba_rot);
RotWin;
end;
if OverButton(226,57) then
begin
FlashButton(226,57,ba_skewh);
iosize:=enterskew(mousex,mousey);
if iosize<>-1 then SkewHWin(iosize);
end;
if OverButton(242,57) then
begin
FlashButton(242,57,ba_skewv);
iosize:=enterskew(mousex,mousey);
if iosize<>-1 then SkewVWin(iosize);
end;
if OverButton(258,57) then
begin
FlashButton(258,57,ba_size);
iosize:=entersize(mousex,mousey);
if iosize<>-1 then ssize:=iosize;
windx2:=ssize;
windy2:=ssize;
clipsprite;
DrawMain;
end;
if OverButton(242,41) then
begin
FlashButton(242,41,ba_cut);
CutWin;
end;
if OverButton(258,41) then
begin
Recharge;
end;
{}
if (tmode<>7) and (tmode<>8) and (tmode<>9) then
            begin
if OverButton(178,9) then
begin
tool:=1;
SaveUndo;
sp:=false;
end;
if OverButton(194,9) then
begin
tool:=2;
SaveUndo;
sp:=false;
end;
if OverButton(210,9) then
begin
tool:=3;
SaveUndo;
sp:=false;
end;
if OverButton(226,9) then
begin
tool:=4;
SaveUndo;
sp:=false;
end;
if OverButton(242,9) then
begin
tool:=5;
sp:=false;
end;
if OverButton(178,89) and (tmode<>10) then
begin
tool:=6;
sp:=false;
end;
                end;
if OverButton(178,41) then
begin
tool:=3;
tmode:=7;
sp:=false;
end;
if OverButton(194,41) and (cxsize<>-1) then
begin
tool:=3;
tmode:=8;
sp:=false;
end;
if OverButton(210,41) and (cxsize<>-1) then
begin
tool:=3;
tmode:=9;
sp:=false;
end;
if OverButton(258,9) then
begin
FlashButton(258,9,ba_fw);
sp:=true;
lx:=windx1;
ly:=windy1;
gx:=windx2;
gy:=windy2;
OperateTool4;
if tmode=7 then
begin
windx1:=0;
windy1:=0;
windx2:=ssize-1;
windy2:=ssize-1;
end;
sp:=false;
end;
if OverButton(178,25) then
begin
tmode:=1;
SaveUndo;
sp:=false;
end;
if OverButton(194,25) then
begin
tmode:=2;
SaveUndo;
sp:=false;
end;
if OverButton(210,25) then
begin
tmode:=3;
SaveUndo;
sp:=false;
end;
if OverButton(226,25) then
begin
tmode:=4;
SaveUndo;
sp:=false;
end;
if OverButton(242,25) then
begin
tmode:=5;
SaveUndo;
sp:=false;
end;
if OverButton(258,25) then
begin
tmode:=6;
SaveUndo;
sp:=false;
end;
if OverButton(194,89) then
begin
FlashButton(194,89,ba_csing);
ChangeSingle;
DrawMain;
end;
if OverButton(210,89) then
begin
FlashButton(210,89,ba_xsing);
ExchangeSingle;
DrawMain;
end;
if OverButton(226,89) then
begin
FlashButton(226,89,ba_ccolr);
ChangeColour;
DrawMain;
end;
if OverButton(242,89) then
begin
FlashButton(242,89,ba_xcolr);
ExchangeColour;
DrawMain;
end;
if (OverButton(258,89)) and (tool<>6) then
begin
FlashButton(258,89,ba_wand);
ChangeColourToText;
DrawMain;
end;
if OverButton(178,73) then
begin
FlashButton(178,73,ba_static);
DStatic;
DrawMain;
end;
if OverButton(194,73) then
begin
FlashButton(194,73,ba_blur);
DBlur;
DrawMain;
end;
if OverButton(210,73) then
begin
FlashButton(210,73,ba_bleed);
DBleed;
DrawMain;
end;
if OverButton(226,73) then
begin
FlashButton(226,73,ba_mirr);
DMorph;
DrawMain;
end;
if OverButton(242,73) then
begin
FlashButton(242,73,ba_morph);
DMirr;
DrawMain;
end;
{}
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DrawArrow;
begin
touch:=0;
If OverButton(296,138) then touch:=1;
If OverButton(296,154) then touch:=1;
if (MouseX>177) and (MouseY>8) and (MouseX<274) and (MouseY<105) then touch:=1;
if touch=0 then putimg16(MouseX,MouseY,c_sageata,vaddr);
if touch=1 then putimg16(MouseX,MouseY,c_sageata2,vaddr);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure MoveCursor;
var iiruc:integer;
    monikalewinski,moni:integer;
    ssp:boolean;
label Zend;
begin
repeat
inc(zebedee);
if zebedee>15 then zebedee:=0;
waitretrace;
flip(vaddr2,vaddr);
StatMouse;
monikalewinski:=-10-zebedee;
ssp:=true;
if (windx1=0) and (windy1=0) and (windx2=ssize-1) and (windy2=ssize-1) then ssp:=false;
gump:=1;
if ssp=true then DrawRGhostLine(windx2+1,windy1+1,windx1+1,windy1+1,monikalewinski);
if ssp=true then DrawRGhostLine(windx1+1,windy2+1,windx2+1,windy2+1,monikalewinski);
if ssp=true then DrawRGhostLine(windx1+1,windy1+1,windx1+1,windy2+1,monikalewinski);
if ssp=true then DrawRGhostLine(windx2+1,windy2+1,windx2+1,windy1+1,monikalewinski);
gump:=0;
if tmode=1 then monikalewinski:=colour*32+brightness;
if tmode=2 then monikalewinski:=24;
if tmode=3 then monikalewinski:=8;
if tmode=4 then monikalewinski:=colour*32+brightness;
if tmode=5 then monikalewinski:=colour*32+brightness;
if tmode=6 then monikalewinski:=-1;
if tmode=7 then monikalewinski:=-10-zebedee;
if tmode=8 then monikalewinski:=-26-zebedee;
if tmode=9 then monikalewinski:=-26-zebedee;
if tmode=10 then monikalewinski:=-10-zebedee;
GX:=(MouseX-9) div 5;
GY:=(MouseY-9) div 5;
if (tmode=10) and (MouseX>9) and (MouseY>9) and (mouseX<169) and (mouseY<169) then moni:=mainspr[gx+1,gy+1] div 32;
if (tool=1) and (MouseX>9) and (MouseY>9) and (mouseX<169) and (mouseY<169) then
begin
if tmode=1 then putimg16c(MouseX,MouseY,c_creion,vaddr,colour);
if tmode=2 then putimg16c(MouseX,MouseY,c_creta,vaddr,colour);
if tmode=3 then putimg16c(MouseX,MouseY,c_carbune,vaddr,colour);
if tmode=4 then putimg16c(MouseX,MouseY,c_pensula,vaddr,colour);
if tmode=5 then putimg16c(MouseX,MouseY,c_flood,vaddr,colour);
if tmode=6 then putimg16c(MouseX,MouseY,c_paint,vaddr,colour);
goto Zend;
end;
if (tool=2) and (MouseX>9) and (MouseY>9) and (mouseX<169) and (mouseY<169) then
begin
if sp=true then DrawRGhostLine(GX+1,GY+1,LX+1,LY+1,monikalewinski);
if tmode=1 then putimg16c(MouseX,MouseY,c_creion,vaddr,colour);
if tmode=2 then putimg16c(MouseX,MouseY,c_creta,vaddr,colour);
if tmode=3 then putimg16c(MouseX,MouseY,c_carbune,vaddr,colour);
if tmode=4 then putimg16c(MouseX,MouseY,c_pensula,vaddr,colour);
if tmode=5 then putimg16c(MouseX,MouseY,c_flood,vaddr,colour);
if tmode=6 then putimg16c(MouseX,MouseY,c_paint,vaddr,colour);
goto Zend;
end;
if (tool=3) and (MouseX>9) and (MouseY>9) and (mouseX<169) and (mouseY<169) then
begin
if sp=true then DrawRGhostLine(GX+1,LY+1,LX+1,LY+1,monikalewinski);
if sp=true then DrawRGhostLine(LX+1,GY+1,GX+1,GY+1,monikalewinski);
if sp=true then DrawRGhostLine(LX+1,LY+1,LX+1,GY+1,monikalewinski);
if sp=true then DrawRGhostLine(GX+1,GY+1,GX+1,LY+1,monikalewinski);
if tmode=8 then
begin
twindx2:=gx+cxsize;
twindy2:=gy+cysize;
if twindx2>31 then twindx2:=31;
if twindy2>31 then twindy2:=31;
DrawRGhostLine(twindx2+1,gy+1,gx+1,gy+1,monikalewinski);
DrawRGhostLine(gx+1,twindy2+1,twindx2+1,twindy2+1,monikalewinski);
DrawRGhostLine(gx+1,gy+1,gx+1,twindy2+1,monikalewinski);
DrawRGhostLine(twindx2+1,twindy2+1,twindx2+1,gy+1,monikalewinski);
end;
if tmode=9 then
begin
twindx2:=gx+cxsize;
twindy2:=gy+cysize;
if twindx2>31 then twindx2:=31;
if twindy2>31 then twindy2:=31;
DrawRGhostLine(twindx2+1,gy+1,gx+1,gy+1,monikalewinski);
DrawRGhostLine(gx+1,twindy2+1,twindx2+1,twindy2+1,monikalewinski);
DrawRGhostLine(gx+1,gy+1,gx+1,twindy2+1,monikalewinski);
DrawRGhostLine(twindx2+1,twindy2+1,twindx2+1,gy+1,monikalewinski);
end;
if tmode=1 then putimg16c(MouseX,MouseY,c_creion,vaddr,colour);
if tmode=2 then putimg16c(MouseX,MouseY,c_creta,vaddr,colour);
if tmode=3 then putimg16c(MouseX,MouseY,c_carbune,vaddr,colour);
if tmode=4 then putimg16c(MouseX,MouseY,c_pensula,vaddr,colour);
if tmode=5 then putimg16c(MouseX,MouseY,c_flood,vaddr,colour);
if tmode=6 then putimg16c(MouseX,MouseY,c_paint,vaddr,colour);
if tmode=7 then putimg16(MouseX,MouseY,c_wind,vaddr);
if tmode=8 then putimg16(MouseX,MouseY,c_paste,vaddr);
if tmode=9 then putimg16(MouseX,MouseY,c_paste,vaddr);
goto Zend;
end;
if (tool=4) and (MouseX>9) and (MouseY>9) and (mouseX<169) and (mouseY<169) then
begin
if sp=true then DrawRGhostLine(LX+1,LY+1,GX+1,LY+1,monikalewinski);
if sp=true then DrawRGhostLine(LX+1,GY+1,GX+1,GY+1,monikalewinski);
if sp=true then DrawRGhostLine(LX+1,LY+1,LX+1,GY+1,monikalewinski);
if sp=true then DrawRGhostLine(GX+1,LY+1,GX+1,GY+1,monikalewinski);
if sp=true then DrawRGhostLine(LX+1,LY+1,GX+1,GY+1,monikalewinski);
if sp=true then DrawRGhostLine(GX+1,LY+1,LX+1,GY+1,monikalewinski);
if tmode=1 then putimg16c(MouseX,MouseY,c_creion,vaddr,colour);
if tmode=2 then putimg16c(MouseX,MouseY,c_creta,vaddr,colour);
if tmode=3 then putimg16c(MouseX,MouseY,c_carbune,vaddr,colour);
if tmode=4 then putimg16c(MouseX,MouseY,c_pensula,vaddr,colour);
if tmode=5 then putimg16c(MouseX,MouseY,c_flood,vaddr,colour);
if tmode=6 then putimg16c(MouseX,MouseY,c_paint,vaddr,colour);
goto Zend;
end;
if (tool=5) and (MouseX>9) and (MouseY>9) and (mouseX<169) and (mouseY<169) then
begin
if tmode=1 then putimg16c(MouseX,MouseY,c_creion,vaddr,colour);
if tmode=2 then putimg16c(MouseX,MouseY,c_creta,vaddr,colour);
if tmode=3 then putimg16c(MouseX,MouseY,c_carbune,vaddr,colour);
if tmode=4 then putimg16c(MouseX,MouseY,c_pensula,vaddr,colour);
if tmode=5 then putimg16c(MouseX,MouseY,c_flood,vaddr,colour);
if tmode=6 then putimg16c(MouseX,MouseY,c_paint,vaddr,colour);
goto Zend;
end;
if (tool=6) and (MouseX>5) and (MouseY>5) and (mouseX<167) and (mouseY<167) then
begin
GX:=(MouseX) div 5;
GY:=(MouseY) div 5;
iiruc:=Mainspr[GX,GY];
putimg16ct(MouseX,MouseY,c_eyedrop,vaddr,iiruc);
goto Zend;
end;
DrawArrow;
Zend:
waitretrace;
flip(vaddr,vga);
until (bstat<>0)
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{                                   MAIN                                   }
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
label MainLoop;
begin
kbdmode:=false;
GetDir(0,homepath);
oname:='SPRITE  .SPR';
Initialise;
bstat:=0;
zolk:=2;
tool:=1;
cxsize:=-1;
colour:=0;
zebedee:=1;
brightness:=0;
fade(0,true);
ssize:=32;
usize:=32;
uname:='SPRITE  .SPR';
sname:='SPRITE  .SPR';
windx1:=0;
windy1:=0;
windx2:=ssize-1;
windy2:=ssize-1;
for i:=1 to 8 do
for j:=1 to 8 do
textspr[i,j]:=20;
for i:=1 to 7 do
for j:=1 to 3 do
textspr[i,j]:=137;
for i:=1 to 6 do
textspr[i,1]:=138;
for i:=1 to 2 do
textspr[1,i]:=138;
for i:=2 to 7 do
textspr[i,3]:=135;
for i:=2 to 3 do
textspr[7,i]:=135;
for i:=1 to 4 do
for j:=5 to 8 do
textspr[i,j]:=textspr[i+4,j-4];
for i:=5 to 8 do
for j:=5 to 8 do
textspr[i,j]:=textspr[i-4,j-4];
txsize:=8;
tysize:=8;
NewSprite;
DrawMain;
sp:=false;
MainLoop:
llkx:=32;
llky:=32;
if windx2>(ssize-1) then windx2:=ssize-1;
if windy2>(ssize-1) then windy2:=ssize-1;
DrawBut;
waitretrace;
MoveCursor;
exitnow:=0;
if tool=1 then OperateTool1;
if tool=2 then OperateTool2;
if tool=3 then OperateTool3;
if tool=4 then OperateTool4;
if tool=5 then OperateTool5;
if tool=6 then OperateTool6;
OperateButtons;
OperatePalSelector;
DrawText;
StatMouse;
if (not key_esc) and (exitnow=0) then goto MainLoop;
delay(150);
VgaOff;
VrtOff;
SetIntVec(KEYBOARDINTR, @BiosKeyboardHandler);
chdir(homepath);
end.