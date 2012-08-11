unit revunit;
interface
uses crt;
const size=3;
var b:array[1..8,1..8] of integer;
    t:array[1..8,1..8] of integer;
    sS:array[1..26] of char;
    legal:integer;
    nS:string;
    iS:string;
    jS:string;
    fuzz,nx,ny,xc,yc,xp,bp,yp,wp,lx,ly,hx,hy,gamov:integer;
    ax,ay,w,v,dx,dy,dist,black,white,turn,enemy,moving,take,i,j:integer;
procedure SetUpGame;
procedure WhitesTurn;
procedure BlacksTurn;
procedure DoMove(movx,movy:integer);
function IsLegal(movx,movy:integer):boolean;
procedure CompMove(var vnx,vny:integer);
function CanMove:boolean;
implementation
procedure InitTactics;
const datastr:array[1..16] of byte=(10,1,7,5,1,0,2,2,7,2,4,3,5,2,3,3);
var x,y,tactic:integer;
    dataidx:integer;
begin
dataidx:=1;
for x:=1 to 4 do
begin
for y:=1 to 4 do
begin
tactic:=datastr[dataidx];
inc(dataidx);
t[x,y]:=tactic;
t[x,9-y]:=tactic;
t[9-x,9-y]:=tactic;
t[9-x,y]:=tactic;
end;
end;
end;
procedure PutBlackPiece(x,y:integer);
begin
b[x,y]:=3;
wp:=wp-1;
bp:=bp+1;
end;
procedure PutWhitePiece(x,y:integer);
begin
b[x,y]:=2;
wp:=wp+1;
bp:=bp-1;
end;
procedure InitBoard;
var x,y,z:integer;
begin
xp:=0;
yp:=0;
wp:=0;
bp:=0;
nS:='';
for x:=1 to 8 do
begin
for y:=1 to 8 do b[x,y]:=1;
end;
for z:=4 to 5 do
begin
x:=z;
y:=z;
PutBlackPiece(x,y);
y:=9-x;
PutWhitePiece(x,y);
end;
bp:=2;
wp:=2;
lx:=3;
ly:=3;
hx:=6;
hy:=6;
gamov:=0;
end;
procedure SetUpGame;
begin
InitTactics;
InitBoard;
legal:=1;
end;
procedure CheckTake;
var x,y,z:integer;
label l370,l510,l520,l550,l560;
begin
take:=0;
for v:=-1 to 1 do
begin
dx:=v;
for w:=-1 to 1 do
begin
dy:=w;
dist:=0;
l370:
dist:=dist+1;
ax:=nx+dx*dist;
ay:=ny+dy*dist;
if (ax<1) or (ax>8) or (ay<1) or (ay>8) then goto l560;
if b[ax,ay]=enemy then goto l370;
if dist=1 then goto l560;
if b[nx+dx*dist,ny+dy*dist]<>turn then goto l560;
take:=take+dist-1;
if moving=0 then goto l560;
if take<>dist-1 then goto l520;
x:=nx;
y:=ny;
if x=lx then begin lx:=x-1; if lx=0 then lx:=1; end;
if x=hx then begin hx:=x+1; if hx=9 then hx:=8; end;
if y=ly then begin ly:=y-1; if ly=0 then ly:=1; end;
if y=hy then begin hy:=y+1; if hy=9 then hy:=8; end;
if turn=3 then begin PutBlackPiece(x,y); {GOSUB 1650} goto l510; end;
if turn=2 then PutWhitePiece(x,y); {GOSUB 1760}
l510:
if turn=3 then begin wp:=wp+1; goto l520; end;
bp:=bp+1;
l520:
for z:=1 to dist-1 do
begin
x:=nx+dx*z;
y:=ny+dy*z;
if turn=3 then begin PutBlackPiece(x,y); {GOSUB 1650} goto l550; end;
if turn=2 then PutWhitePiece(x,y); {GOSUB 1760}
l550:
end;
l560:
end;
end;
end;
function CanMove:boolean;
label l1590;
var res:boolean;
begin
legal:=0;
moving:=0;
take:=0;
For i:=lx to hx do
begin
nx:=i;
for j:=ly to hy do
begin
ny:=j;
if b[nx,ny]<>1 then goto l1590;
CheckTake;
if take<>0 then
begin
xc:=nx;
yc:=ny;
nx:=8;
ny:=8;
i:=8;
j:=8;
end;
l1590:
if take<>0 then break;
end;
if take<>0 then break;
end;
if take<>0 then legal:=1;
res:=false;
if legal=1 then res:=true;
CanMove:=res;
end;
procedure CompMove(var vnx,vny:integer);
var scraux,pts,c,d,scre,xbest,ybest:integer;
label l1260,l1255;
begin
moving:=0;
pts:=-1000;
scraux:=(hx-lx)*(hy-ly)+1;
for c:=lx to hx do
begin
nx:=c;
for d:=ly to hy do
begin
ny:=d;
if b[nx,ny]<>1 then goto l1260;
CheckTake;
if take=0 then goto l1260;
scre:=t[nx,ny]*20+random(fuzz)+take*(xp+yp-32);
if scre<pts then goto l1255;
pts:=scre;
xbest:=nx;
ybest:=ny;
l1255:
l1260:
end;
end;
vnx:=xbest;
vny:=ybest;
end;
function IsLegal(movx,movy:integer):boolean;
var res:boolean;
label isnot;
begin
res:=false;
moving:=0;
if b[movx,movy]<>1 then goto isnot;
nx:=movx;
ny:=movy;
CheckTake;
if take=0 then goto isnot;
res:=true;
isnot:
Islegal:=res;
end;
procedure DoMove(movx,movy:integer);
begin
nx:=movx;
ny:=movy;
moving:=1;
CheckTake;
end;
procedure WhitesTurn;
begin
turn:=3;
enemy:=2;
end;
procedure BlacksTurn;
begin
turn:=2;
enemy:=3;
end;
begin
end.