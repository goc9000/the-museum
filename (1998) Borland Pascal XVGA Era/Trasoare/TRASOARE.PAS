program trasoare;
uses dos,crt,rutvid;
const sus=1;
      dreapta=2;
      jos=3;
      stanga=4;
      concm=3{sau 2600};
      canextra=1;
      pm_recd=10;
      pm_numerecd=11;
      msemn:array[1..5,0..6] of byte=((0,8,0,0,0,8,0), {:}
                                      (0,0,0,0,0,8,16), {,}
                                      (0,64,96,112,96,64,0), {>}
                                      (0,0,0,62,0,0,0), {-}
                                      (8,28,28,8,8,0,8)) {!};
      mnum:array[1..10,0..6] of byte=((62,65,65,65,65,65,62), {0}
                                      (120,8,8,8,8,8,127), {1}
                                      (62,65,1,62,64,64,127), {2}
                                      (62,65,1,30,1,65,62), {3}
                                      (17,33,65,127,1,1,1), {4}
                                      (127,64,64,126,1,65,62), {5}
                                      (62,65,64,126,65,65,62), {6}
                                      (127,66,4,8,16,32,64), {7}
                                      (62,65,65,62,65,65,62), {8}
                                      (62,65,65,63,1,65,62));{9}
      mlit:array[1..26,0..6] of byte=((62,65,65,127,65,65,65), {A}
                                      (126,65,65,126,65,65,126), {B}
                                      (62,65,64,64,64,65,62), {C}
                                      (126,65,65,65,65,65,126), {D}
                                      (127,64,64,120,64,64,127), {E}
                                      (127,64,64,120,64,64,64), {F}
                                      (62,65,64,79,65,65,62), {G}
                                      (65,65,65,127,65,65,65), {H}
                                      (127,8,8,8,8,8,127), {I}
                                      (1,1,1,1,65,65,62), {J}
                                      (65,66,68,120,68,66,65), {K}
                                      (64,64,64,64,64,64,127), {L}
                                      (65,99,85,73,65,65,65), {M}
                                      (65,97,81,73,69,67,65), {N}
                                      (62,65,65,65,65,65,62), {O}
                                      (126,65,65,126,64,64,64), {P}
                                      (62,65,65,65,69,67,63), {Q}
                                      (126,65,65,126,65,65,65), {R}
                                      (62,65,64,62,1,65,62), {S}
                                      (127,8,8,8,8,8,8), {T}
                                      (65,65,65,65,65,65,62), {U}
                                      (65,65,65,65,34,20,8), {V}
                                      (65,65,65,73,85,99,65), {W}
                                      (65,34,20,8,20,34,65), {X}
                                      (65,65,65,63,1,1,126), {Y}
                                      (127,2,4,8,16,32,127));{Z}
      ritm:string='                                ';
      muzica:array[1..4] of string=(('d6  C6  c6C6c6b5A5  a5  G5G5a5  ')+
                                    ('b5  A5  a5b5A5a5g5  F5  f5f5F5  ')+
                                    ('a5  e5e5D5D5e5  a5  e5e5D5D5e5  ')+
                                    ('a4b4C5d5e5F5g5a5b5b5C6  b5b5a5  ')+
                                    ('d6  C6  c6C6c6b5A5  a5  G5G5a5  ')+
                                    ('b5  A5  a5b5A5a5g5  F5  f5f5F5  ')+
                                    ('e5  e5e5a5a5e5  f5  f5f5A5A5    ')+
                                    ('C6e6d6b5C6e6d6C6d6d6d5  d5d5d5  '),
                                    ('d3d3d3  a2a2a2  d3d3d3  a2a2a2  ')+
                                    ('d3d3d3  a2a2a2  d3d3d3  a2a2a2  ')+
                                    ('a2a2a2  e2e2e2  a2a2a2  e2e2e2  ')+
                                    ('a2a2a2  e3e3e3  b3b3b3  a3a3a3  ')+
                                    ('d3d3d3  a2a2a2  d3d3d3  a2a2a2  ')+
                                    ('d3d3d3  a2a2a2  d3d3d3  a2a2a2  ')+
                                    ('e3e3e3  a3a3a3  e3e3e3  A3A3A3  ')+
                                    ('c4c4c4  C4C4C4  d4d4d4  d4d4d4  '),
                                    ('    a6      a6      a6      a6  ')+
                                    ('    a6      a6      a6  a6      ')+
                                    ('    a6      a6      a6      a6  ')+
                                    ('    a6      a6      a6  a6      ')+
                                    ('    a6      a6      a6      a6  ')+
                                    ('    a6      a6      a6  a6      ')+
                                    ('    a6      a6      A6      A6  ')+
                                    ('    c7      c7      d7  d7      '),
                                    ('    d6      d6      d6      d6  ')+
                                    ('    d6      d6      d6  d6      ')+
                                    ('    e6      e6      e6      e6  ')+
                                    ('    a5      e6      a5  a5      ')+
                                    ('    d6      d6      d6      d6  ')+
                                    ('    d6      d6      d6  d6      ')+
                                    ('    e6      e6      f6      f6  ')+
                                    ('    c6      C6      d6  d6      '));
      f_octav:array[1..9] of integer=(0,1,2,4,8,16,32,64,128);
      prcan:array[1..6] of byte=(1,1,2,2,3,4);
      maxmes=12;
      fcv_c=524;
      fcv_Cd=556;
      fcv_d=588;
      fcv_Dd=624;
      fcv_e=660;
      fcv_f=700;
      fcv_Fd=740;
      fcv_g=784;
      fcv_Gd=832;
      fcv_a=880;
      fcv_Ad=932;
      fcv_b=988;
var i,j,k,l,m:word;
    x,y,dir:byte;
    canta:integer;
    can:integer;
    ptrmuz:word;
    mpm:integer;
    mesaje:array[1..maxmes] of string;
    numrecd:string;
    numrai:integer;
    vx,vy:integer;
    viteza:integer;
    vechimes:string;
    gata:boolean;
    mort:boolean;
    timp,cultext:integer;
    scor,recd:longint;
    vieti,nivel:integer;
    ts:char;
    grila:array[0..39,0..23] of byte;
    adv:array[1..6,1..5] of integer;
    calibrare,mincalib:longint;
    m_fcv:array[1..4] of word;
    m_num:array[1..4] of word;
    m_stare:array[1..20] of byte;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure salveaza_rec;
var rf:text;
    tl:string;
begin
assign(rf,'trasoare.rec');
rewrite(rf);
tl:='';
str(recd,tl);
writeln(rf,tl);
writeln(rf,numrecd);
close(rf);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure incarca_rec;
var rf:text;
    tl:string;
begin
assign(rf,'trasoare.rec');
{$I-}
reset(rf);
{$I+}
if IOResult=0 then
              begin
              readln(rf,tl);
              readln(rf,numrecd);
              close(rf);
              val(tl,recd,i);
              end
              else
              begin
              recd:=0;
              numrecd:='NIMENI';
              salveaza_rec;
              end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function strs(num,lat:longint):string;
var temps:string;
begin
if num>99999 then num:=99999;
str(num:lat,temps);
while pos(' ', temps) > 0 do temps[pos(' ', temps)] := '0';
strs:=temps;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Scar(lx,ly:integer;car:char);
var cx,cy:integer;
begin
for cy:=0 to 7 do
begin
cx:=0;
if (cy<7) then
begin
if car=':' then cx:=msemn[1,cy];
if car=',' then cx:=msemn[2,cy];
if car='>' then cx:=msemn[3,cy];
if car='-' then cx:=msemn[4,cy];
if car='!' then cx:=msemn[5,cy];
if (ord(car)>64) and (ord(car)<91) then cx:=mlit[ord(car)-64,cy];
if (ord(car)>47) and (ord(car)<58) then cx:=mnum[ord(car)-47,cy];
end;
if (ly+cy>191) and (ly+cy<200) then
begin
if (cx and 64)>0 then pixel(lx+0,ly+cy,cultext) else pixel(lx+0,ly+cy,0);
if (cx and 32)>0 then pixel(lx+1,ly+cy,cultext) else pixel(lx+1,ly+cy,0);
if (cx and 16)>0 then pixel(lx+2,ly+cy,cultext) else pixel(lx+2,ly+cy,0);
if (cx and 8)>0 then pixel(lx+3,ly+cy,cultext) else pixel(lx+3,ly+cy,0);
if (cx and 4)>0 then pixel(lx+4,ly+cy,cultext) else pixel(lx+4,ly+cy,0);
if (cx and 2)>0 then pixel(lx+5,ly+cy,cultext) else pixel(lx+5,ly+cy,0);
if (cx and 1)>0 then pixel(lx+6,ly+cy,cultext) else pixel(lx+6,ly+cy,0);
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure gigacar(lx,ly:integer;car:char;op:byte);
var cx,cy,colt:integer;
    ci,cj:integer;
begin
for cx:=0 to 2 do for cy:=0 to 3 do grila[lx div 8+cx,ly div 8+cy]:=15;
for cx:=-1 to 21+op do for cy:=-2 to 28 do pixel(lx+cx,ly+cy,0);
for cy:=0 to 7 do
begin
cx:=0;
if (cy<7) then
begin
if car=':' then cx:=msemn[1,cy];
if car=',' then cx:=msemn[2,cy];
if car='>' then cx:=msemn[3,cy];
if car='s' then cx:=mlit[19,cy];
if car='t' then cx:=mlit[20,cy];
if (ord(car)>64) and (ord(car)<91) then cx:=mlit[ord(car)-64,cy];
if (ord(car)>47) and (ord(car)<58) then cx:=mnum[ord(car)-47,cy];
end;
if (cy=7) and ((car='s') or (car='t')) then cx:=8;
if (cy=6) and (car='t') then cx:=0;
if (cy=7) and (car=',') then cx:=16;
colt:=32+cy*3;
for cj:=0 to 2 do
begin
for ci:=0 to 2 do
begin
if (cx and 64)>0 then pixel(lx+ 0+cj,ly+cy*4+ci,colt+ci);
if (cx and 32)>0 then pixel(lx+ 3+cj,ly+cy*4+ci,colt+ci);
if (cx and 16)>0 then pixel(lx+ 6+cj,ly+cy*4+ci,colt+ci);
if (cx and 8)>0 then  pixel(lx+ 9+cj,ly+cy*4+ci,colt+ci);
if (cx and 4)>0 then  pixel(lx+12+cj,ly+cy*4+ci,colt+ci);
if (cx and 2)>0 then  pixel(lx+15+cj,ly+cy*4+ci,colt+ci);
if (cx and 1)>0 then  pixel(lx+18+cj,ly+cy*4+ci,colt+ci);
end;
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Plaseaza_adv(niv:integer);
begin
if niv=1 then
begin
adv[1,1]:=dreapta;
adv[1,2]:=0; adv[1,3]:=9; adv[1,4]:=adv[1,2]; adv[1,5]:=adv[1,3];
adv[2,1]:=stanga;
adv[2,2]:=39; adv[2,3]:=15; adv[2,4]:=adv[2,2]; adv[2,5]:=adv[2,3];
end;
if niv=2 then
begin
adv[1,1]:=dreapta;
adv[1,2]:=6; adv[1,3]:=20; adv[1,4]:=adv[1,2]; adv[1,5]:=adv[1,3];
adv[2,1]:=stanga;
adv[2,2]:=33; adv[2,3]:=20; adv[2,4]:=adv[2,2]; adv[2,5]:=adv[2,3];
adv[3,1]:=jos;
adv[3,2]:=20; adv[3,3]:=2; adv[3,4]:=adv[3,2]; adv[3,5]:=adv[3,3];
end;
if niv=3 then
begin
adv[1,1]:=dreapta;
adv[1,2]:=0; adv[1,3]:=0; adv[1,4]:=adv[1,2]; adv[1,5]:=adv[1,3];
adv[2,1]:=jos;
adv[2,2]:=39; adv[2,3]:=0; adv[2,4]:=adv[2,2]; adv[2,5]:=adv[2,3];
adv[3,1]:=sus;
adv[3,2]:=0; adv[3,3]:=23; adv[3,4]:=adv[3,2]; adv[3,5]:=adv[3,3];
adv[4,1]:=stanga;
adv[4,2]:=39; adv[4,3]:=23; adv[4,4]:=adv[4,2]; adv[4,5]:=adv[4,3];
end;
if niv=4 then
begin
adv[1,1]:=dreapta;
adv[1,2]:=8; adv[1,3]:=23; adv[1,4]:=adv[1,2]; adv[1,5]:=adv[1,3];
adv[2,1]:=stanga;
adv[2,2]:=31; adv[2,3]:=23; adv[2,4]:=adv[2,2]; adv[2,5]:=adv[2,3];
adv[3,1]:=jos;
adv[3,2]:=20; adv[3,3]:=0; adv[3,4]:=adv[3,2]; adv[3,5]:=adv[3,3];
adv[4,1]:=dreapta;
adv[4,2]:=0; adv[4,3]:=12; adv[4,4]:=adv[4,2]; adv[4,5]:=adv[4,3];
adv[5,1]:=stanga;
adv[5,2]:=39; adv[5,3]:=12; adv[5,4]:=adv[5,2]; adv[5,5]:=adv[5,3];
end;
if niv=5 then
begin
adv[1,1]:=dreapta;
adv[1,2]:=8; adv[1,3]:=0; adv[1,4]:=adv[1,2]; adv[1,5]:=adv[1,3];
adv[2,1]:=jos;
adv[2,2]:=31; adv[2,3]:=0; adv[2,4]:=adv[2,2]; adv[2,5]:=adv[2,3];
adv[3,1]:=sus;
adv[3,2]:=8; adv[3,3]:=23; adv[3,4]:=adv[3,2]; adv[3,5]:=adv[3,3];
adv[4,1]:=stanga;
adv[4,2]:=31; adv[4,3]:=23; adv[4,4]:=adv[4,2]; adv[4,5]:=adv[4,3];
adv[5,1]:=dreapta;
adv[5,2]:=0; adv[5,3]:=12; adv[5,4]:=adv[5,2]; adv[5,5]:=adv[5,3];
adv[6,1]:=stanga;
adv[6,2]:=39; adv[6,3]:=12; adv[6,4]:=adv[6,2]; adv[6,5]:=adv[6,3];
end;
if niv>5 then
begin
adv[1,1]:=jos;
adv[1,2]:=1+random(38); adv[1,3]:=0; adv[1,4]:=adv[1,2]; adv[1,5]:=adv[1,3];
adv[2,1]:=sus;
adv[2,2]:=1+random(38); adv[2,3]:=23; adv[2,4]:=adv[2,2]; adv[2,5]:=adv[2,3];
adv[3,1]:=dreapta;
adv[3,2]:=0; adv[3,3]:=1+random(22); adv[3,4]:=adv[3,2]; adv[3,5]:=adv[3,3];
adv[4,1]:=stanga;
adv[4,2]:=39; adv[4,3]:=1+random(22); adv[4,4]:=adv[4,2]; adv[4,5]:=adv[4,3];
repeat
adv[5,1]:=1+random(4);
adv[5,2]:=1+random(38); adv[5,3]:=1+random(22); adv[5,4]:=adv[5,2]; adv[5,5]:=adv[5,3];
adv[6,1]:=1+random(4);
adv[6,2]:=1+random(38); adv[6,3]:=1+random(22); adv[6,4]:=adv[6,2]; adv[6,5]:=adv[6,3];
until ((adv[5,2]=20) or (adv[6,2]=20) or (adv[6,3]=12) or (adv[5,3]=12))=false;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Actmesrecd;
begin
mesaje[pm_recd]:=' RECORDUL DE '+strs(recd,6)+' A FOST REALIZAT DE: ';
mesaje[pm_numerecd]:='';
for i:=1 to (40-length(numrecd)) div 2 do mesaje[pm_numerecd]:=mesaje[pm_numerecd]+' ';
mesaje[pm_numerecd]:=mesaje[pm_numerecd]+numrecd;
while length(mesaje[pm_numerecd])<40 do mesaje[pm_numerecd]:=mesaje[pm_numerecd]+' ';
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Init;
var byt:byte;
begin
incarca_rec;
canta:=2;
can:=0;
mpm:=-1;
ptrmuz:=1;
for i:=1 to 20 do m_stare[i]:=0;
m_num[1]:=0;
m_num[2]:=0;
m_num[3]:=0;
m_num[4]:=0;
calibrare:=0;
clrscr;
delay(1000);
byt:=mem[0000:$046C];
while mem[0000:$046C]=byt do;
byt:=mem[0000:$046C];
while mem[0000:$046C]=byt do
begin
inc(calibrare);
end;
calibrare:=349371; {Pentru 486DX6 la 133Mhz}
if paramcount>0 then val(paramstr(1),calibrare,i);
mincalib:=calibrare div 1000;
vechimes:='                                        ';
mesaje[1]:='   PROGRAMAT DE: DINU CRISTIAN MIRCEA   ';
mesaje[2]:='  DUPA UN CONCEPT DE: SIMON LANE, 1983  ';
mesaje[3]:='              INSTRUCTIUNI:             ';
mesaje[4]:=' >BLOCHEAZA INAMICII CU URMELE TALE     ';
mesaje[5]:=' >RAMAI PE GRILA SI EVITA-TI URMELE     ';
mesaje[6]:=' >EVITA INAMICII SI URMELE LASATE DE EI ';
mesaje[7]:=' >RESPECTA LIMITA DE TIMP ACORDAT       ';
mesaje[8]:='    APASA ORICE TASTA PENTRU A PORNI    ';
 mesaje[9]:='      SAU ESC PENTRU A IESI IN DOS      ';
Actmesrecd;
mesaje[12]:='                                        ';
randomize;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sterge_zona;
begin
directvideo:=false;
for i:=16 to 174 do linie (40,i,278,i,0);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Fa_grila;
var tx,ty,oc,baz:integer;
begin
baz:=32;
for i:=0 to 39 do
for j:=0 to 23 do
begin
tx:=i*8;
ty:=j*8;
oc:=(i+j) mod 24;
if j=0 then linie(tx,ty,tx+7,ty,baz+oc);
if i=0 then linie(tx,ty,tx,ty+7,baz+oc);
linie(tx,ty+7,tx+7,ty+7,baz+oc);
linie(tx+7,ty,tx+7,ty+7,baz+oc);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function Se_poate(ux,uy:integer):boolean;
begin
if (ux<0) or (ux>39) or (uy<0) or (uy>23) or (grila[ux,uy]<>0) then se_poate:=false
                                                               else se_poate:=true;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Des_juc;
begin
linie(vx*8+3,vy*8+3,x*8+3,y*8+3,1);
linie(vx*8+4,vy*8+3,x*8+4,y*8+3,1);
linie(vx*8+3,vy*8+4,x*8+3,y*8+4,1);
linie(vx*8+4,vy*8+4,x*8+4,y*8+4,1);
linie(x*8+3,y*8+3,x*8+4,y*8+3,15);
linie(x*8+3,y*8+4,x*8+4,y*8+4,15);
grila[x,y]:=1;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Des_adv;
var ax,ay,avx,avy:integer;
begin
for i:=1 to 6 do
begin
if adv[i,1]>0 then
begin
ax:=adv[i,2];
ay:=adv[i,3];
avx:=adv[i,4];
avy:=adv[i,5];
linie(avx*8+3,avy*8+3,ax*8+3,ay*8+3,1+i);
linie(avx*8+4,avy*8+3,ax*8+4,ay*8+3,1+i);
linie(avx*8+3,avy*8+4,ax*8+3,ay*8+4,1+i);
linie(avx*8+4,avy*8+4,ax*8+4,ay*8+4,1+i);
linie(ax*8+3,ay*8+3,ax*8+4,ay*8+3,15);
linie(ax*8+3,ay*8+4,ax*8+4,ay*8+4,15);
grila[ax,ay]:=i+1;
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sterge_juc(cul:integer);
var tx,ty,oc,xi,xj:integer;
begin
for xi:=0 to 39 do
for xj:=0 to 23 do
begin
if grila[xi,xj]=cul then
begin
grila[xi,xj]:=0;
tx:=xi*8;
ty:=xj*8;
oc:=(xi+xj) mod 24;
for k:=0 to 6 do linie(tx,ty+k,tx+6,ty+k,0);
if xj=0 then linie(tx,ty,tx+7,ty,32+oc);
if xi=0 then linie(tx,ty,tx,ty+7,32+oc);
linie(tx,ty+7,tx+7,ty+7,32+oc);
linie(tx+7,ty,tx+7,ty+7,32+oc);
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sterge_tot;
var tx,ty,oc,xi,xj:integer;
begin
for xi:=0 to 39 do
for xj:=0 to 23 do
begin
if grila[xi,xj]<>0 then
begin
grila[xi,xj]:=0;
tx:=xi*8;
ty:=xj*8;
oc:=(xi+xj) mod 24;
for k:=0 to 6 do linie(tx,ty+k,tx+6,ty+k,0);
if xj=0 then linie(tx,ty,tx+7,ty,32+oc);
if xi=0 then linie(tx,ty,tx,ty+7,32+oc);
linie(tx,ty+7,tx+7,ty+7,32+oc);
linie(tx+7,ty,tx+7,ty+7,32+oc);
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sun_crasti;
var stare:byte;
    si:integer;
begin
stare:=(port[$61] and 252);
for k:=1 to 16 do
begin
for si:=0 to (2000 div k) do
begin
port[$61]:=stare or (random(2)*canta);
for j:=0 to mincalib*k do;
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Tmuz;
var stare:byte;
    si:integer;
    factor:real;
    oct:integer;
    tbass,toba:byte;
procedure melodie;
begin
for i:=1 to calibrare div 32 do
begin
for j:=1 to 4 do
begin
m_num[j]:=m_num[j]+1;
if m_num[j]>m_fcv[j] then
begin
m_num[j]:=0;
m_stare[j]:=1-m_stare[j];
end;
end;
port[$61]:=stare or (m_stare[1+(can div concm)]*2);
can:=can+1;
if can>(((4+canextra)*concm)-1) then
begin
can:=0;
if keypressed then ts:=readkey;
end;
end;
end;
begin
if canta=0 then
begin
for i:=1 to 40 do
begin
delay(1);
if keypressed then ts:=readkey;
end;
if ts='s' then
          begin
          canta:=2;
          ts:='?';
          exit;
          end;
end;
if canta=2 then
begin
mpm:=mpm+1;
if mpm>2 then
begin
mpm:=0;
ptrmuz:=ptrmuz+2;
if ptrmuz>length(muzica[1]) then ptrmuz:=1;
end;
stare:=(port[$61] and 252);
for i:=1 to 4 do
begin
m_fcv[i]:=65535;
oct:=ord(muzica[i,ptrmuz+1])-48;
if i=2 then oct:=oct+1;
factor:=(f_octav[oct])/4;
if factor>0 then
begin
if muzica[i,ptrmuz]='c' then m_fcv[i]:=round(calibrare/(fcv_c *factor));
if muzica[i,ptrmuz]='C' then m_fcv[i]:=round(calibrare/(fcv_cd*factor));
if muzica[i,ptrmuz]='d' then m_fcv[i]:=round(calibrare/(fcv_d *factor));
if muzica[i,ptrmuz]='D' then m_fcv[i]:=round(calibrare/(fcv_dd*factor));
if muzica[i,ptrmuz]='e' then m_fcv[i]:=round(calibrare/(fcv_e *factor));
if muzica[i,ptrmuz]='f' then m_fcv[i]:=round(calibrare/(fcv_f *factor));
if muzica[i,ptrmuz]='F' then m_fcv[i]:=round(calibrare/(fcv_fd*factor));
if muzica[i,ptrmuz]='g' then m_fcv[i]:=round(calibrare/(fcv_g *factor));
if muzica[i,ptrmuz]='G' then m_fcv[i]:=round(calibrare/(fcv_gd*factor));
if muzica[i,ptrmuz]='a' then m_fcv[i]:=round(calibrare/(fcv_a *factor));
if muzica[i,ptrmuz]='A' then m_fcv[i]:=round(calibrare/(fcv_ad*factor));
if muzica[i,ptrmuz]='b' then m_fcv[i]:=round(calibrare/(fcv_b *factor));
end;
end;
k:=0;
if (m_fcv[1]=m_fcv[2]) and (m_fcv[1]<>65535) then k:=1;
if (m_fcv[1]=m_fcv[3]) and (m_fcv[1]<>65535) then k:=1;
if (m_fcv[1]=m_fcv[4]) and (m_fcv[1]<>65535) then k:=1;
if (m_fcv[2]=m_fcv[3]) and (m_fcv[2]<>65535) then k:=1;
if (m_fcv[2]=m_fcv[4]) and (m_fcv[2]<>65535) then k:=1;
if (m_fcv[3]=m_fcv[4]) and (m_fcv[3]<>65535) then k:=1;
asm cli end;
tbass:=0;
toba:=0;
if (mpm=0) and (ritm[((ptrmuz-1) mod 32)+1]='B') then tbass:=1;
if (mpm=0) and (ritm[((ptrmuz-1) mod 32)+1]='T') then toba:=1;
if (tbass=0) and (toba=0) then melodie;
if tbass=1 then
           begin
           port[$61]:=stare or 0;
           l:=1000;
           for i:=1 to 35 do
           begin
           delay(1);
           sound(l);
           l:=round(l*0.9);
           end;
           end;
if toba=1 then
           begin
           port[$61]:=stare or 0;
           l:=5000;
           for i:=1 to 35 do
           begin
           delay(1);
           sound(l);
           l:=round(l*0.9);
           end;
           end;
asm sti end;
if ts='s' then
          begin
          canta:=0;
          ts:='?';
          end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sun_tiaun(lung:integer);
var stare:byte;
    si:integer;
begin
stare:=(port[$61] and 252);
for k:=1 to lung do
begin
for si:=0 to 20 do
begin
port[$61]:=stare or canta;
for j:=0 to mincalib*k do;
port[$61]:=stare;
for j:=0 to mincalib*k do;
end;
end;

end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sun_iaunt(lung:integer);
var stare:byte;
    si:integer;
begin
stare:=(port[$61] and 252);
for k:=lung downto 1 do
begin
for si:=0 to 20 do
begin
port[$61]:=stare or canta;
for j:=0 to mincalib*k do;
port[$61]:=stare;
for j:=0 to mincalib*k do;
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sun_trosc;
var stare:byte;
    si:integer;
begin
stare:=(port[$61] and 252);
for si:=0 to 800 do
begin
port[$61]:=stare or (random(2)*canta);
for j:=0 to mincalib*4 do;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Misca_adv;
var ax,ay,avx,avy,ture,rot:integer;
label reia;
begin
rot:=-1+random(2)*2;
for i:=1 to 6 do
begin
if adv[i,1]>0 then
begin
avx:=adv[i,2];
avy:=adv[i,3];
ture:=0;
reia:
ax:=avx;
ay:=avy;
if adv[i,1]=sus then ay:=ay-1;
if adv[i,1]=jos then ay:=ay+1;
if adv[i,1]=stanga then ax:=ax-1;
if adv[i,1]=dreapta then ax:=ax+1;
if se_poate(ax,ay)=false then begin
                              adv[i,1]:=adv[i,1]+rot;
                              if adv[i,1]<1 then adv[i,1]:=4;
                              if adv[i,1]>4 then adv[i,1]:=1;
                              inc(ture);
                              end;
if (se_poate(ax,ay)=false) and (ture<5) then goto reia;
if ture>4 then begin adv[i,1]:=0; Sun_trosc; Sterge_juc(i+1); scor:=scor+1000; numrai:=numrai-1; end;
if adv[i,1]>0 then grila[ax,ay]:=1+i;
adv[i,2]:=ax;
adv[i,3]:=ay;
adv[i,4]:=avx;
adv[i,5]:=avy;
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Misca_adv_demo;
var ax,ay,avx,avy,ture,rot:integer;
label reia;
begin
rot:=-1+random(2)*2;
for i:=1 to 6 do
begin
if adv[i,1]=0 then
begin
adv[i,1]:=1+random(4);
adv[i,2]:=1+random(38); adv[i,3]:=1+random(22); adv[i,4]:=adv[i,2]; adv[i,5]:=adv[i,3];
if grila[adv[i,2],adv[i,3]]<>0 then adv[i,1]:=0 else grila[adv[i,2],adv[i,3]]:=i+1;
end;
if adv[i,1]>0 then
begin
avx:=adv[i,2];
avy:=adv[i,3];
ture:=0;
reia:
ax:=avx;
ay:=avy;
if adv[i,1]=sus then ay:=ay-1;
if adv[i,1]=jos then ay:=ay+1;
if adv[i,1]=stanga then ax:=ax-1;
if adv[i,1]=dreapta then ax:=ax+1;
if se_poate(ax,ay)=false then begin
                              adv[i,1]:=adv[i,1]+rot;
                              if adv[i,1]<1 then adv[i,1]:=4;
                              if adv[i,1]>4 then adv[i,1]:=1;
                              inc(ture);
                              end;
if (se_poate(ax,ay)=false) and (ture<5) then goto reia;
if ture>4 then begin adv[i,1]:=0; {Sun_trosc;} Sterge_juc(i+1); end;
if adv[i,1]>0 then grila[ax,ay]:=1+i;
adv[i,2]:=ax;
adv[i,3]:=ay;
adv[i,4]:=avx;
adv[i,5]:=avy;
end;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function Demonstratie:boolean;
var ptrmes,cic,astept,poz:integer;
    stg1,stg2:string;
    iesi:boolean;
    dc:integer;
begin
ptrmuz:=1;
iesi:=false;
poz:=7;
astept:=100;
stg1:=vechimes;
stg2:=mesaje[1];
ptrmes:=1;
for i:=1 to 6 do
begin
repeat
adv[i,1]:=1+random(4);
adv[i,2]:=1+random(38); adv[i,3]:=1+random(22); adv[i,4]:=adv[i,2]; adv[i,5]:=adv[i,3];
until grila[adv[i,2],adv[i,3]]=0;
grila[adv[i,2],adv[i,3]]:=i+1;
end;
ts:='?';
while (ts='?') or (poz<>8) do
begin
Misca_adv_demo;
Des_adv;
for dc:=1 to 2 do
begin
for cic:=0 to 39 do
begin
scar(cic*8,185+poz,stg1[cic+1]);
scar(cic*8,193+poz,stg2[cic+1]);
end;
if poz<8 then
         begin
         dec(poz);
         if poz<0 then begin
                       poz:=8;
                       stg1:=mesaje[ptrmes];
                       ptrmes:=ptrmes+1;
                       if ptrmes>maxmes then ptrmes:=1;
                       stg2:=mesaje[ptrmes];
                       end;
         end;
astept:=astept-1;
if astept<0 then begin astept:=100; poz:=7; end;
end;
Tmuz;
end;
Vechimes:=stg1;
if ts=chr(27) then iesi:=true;
demonstratie:=iesi;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Noumes(stg1:string);
var cic,poz:integer;
begin
for poz:=8 downto 0 do
begin
for cic:=0 to 39 do
begin
scar(cic*8,185+poz,vechimes[cic+1]);
scar(cic*8,193+poz,stg1[cic+1]);
end;
delay(20);
end;
Vechimes:=stg1;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure mesajscor;
begin
noumes('PUNCTE:'+strs(scor,6)+'   TIMP:'+strs(timp,3)+'   RECORD:'+strs(recd,6));
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure actscor;
var cic,poz:integer;
    ts1:string;
begin
ts1:='PUNCTE:'+strs(scor,6)+'   TIMP:'+strs(timp,3)+'   RECORD:'+strs(recd,6);
vechimes:=ts1;
for cic:=0 to 39 do
begin
scar(cic*8,193,ts1[cic+1]);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure nou_recd;
var cic,clc:integer;
begin
recd:=scor;
noumes('     BRAVO !! AI DEPASIT RECORDUL !     ');
Sun_iaunt(40); delay(500);
noumes('  INTRODU-TI NUMELE PENTRU POSTERITATE  ');
delay(800);
gata:=false;
noumes('                                        ');
numrecd:='';
clc:=0;
while keypressed do readkey;
repeat
clc:=clc+1;
if clc>15 then clc:=0;
ts:='?';
if keypressed then ts:=upcase(readkey);
if (((ord(ts)>64) and (ord(ts)<91)) or
   ((ord(ts)>47) and (ord(ts)<58)) or
   (ord(ts)=32) or
   (ts='-')) and (length(numrecd)<37) then
                                 begin
                                 sun_tiaun(14);
                                 numrecd:=numrecd+ts;
                                 end;
if (ts=chr(8)) and (length(numrecd)>0) then
             begin
             sun_iaunt(14);
             numrecd:=copy(numrecd,1,length(numrecd)-1);
             for x:=0 to 6 do for y:=0 to 6 do pixel(160+(length(numrecd) div 2)*8+x,193+y,0);
             end;
if ts=chr(13) then gata:=true;
actmesrecd;
for cic:=0 to 39 do
begin
scar(cic*8,193,mesaje[pm_numerecd,cic+1]);
end;
for x:=0 to 6 do for y:=0 to 6 do pixel(160+(length(numrecd) div 2)*8+x,193+y,16+clc);
delay(25);
until gata=true;
Sun_iaunt(40);
for x:=0 to 6 do for y:=0 to 6 do pixel(160+(length(numrecd) div 2)*8+x,193+y,0);
vechimes:=mesaje[pm_numerecd,cic+1];
noumes('                                        ');
salveaza_rec;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}

{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
label start_nivel,restart,iesire;
begin
Init;
initvideo;
sinc;
Pal(1,0,48,0);
Pal(2,48,0,0);
Pal(3,0,0,48);
Pal(4,48,48,0);
Pal(5,0,48,48);
Pal(6,48,0,48);
Pal(7,48,48,48);
for i:=0 to 39 do for j:=0 to 23 do grila[i,j]:=0;
Fa_grila;
restart:
i:=40;
Gigacar(25+i+0*24,82,'T',1);
Gigacar(25+i+1*24,82,'R',1);
Gigacar(25+i+2*24,82,'A',1);
Gigacar(25+i+3*24,82,'S',1);
Gigacar(25+i+4*24,82,'O',1);
Gigacar(25+i+5*24,82,'A',1);
Gigacar(25+i+6*24,82,'R',1);
Gigacar(25+i+7*24,82,'E',0);
cultext:=15;
if Demonstratie=true then goto iesire;
sterge_tot;
scor:=0;
nivel:=1;
noumes('                                        ');
vieti:=5;
start_nivel:
ptrmuz:=1;
for i:=1 to 6 do adv[i,1]:=0;
numrai:=0;
Plaseaza_adv(1+((nivel-1) mod 6));
viteza:=((nivel-1) mod 30) div 6;
for i:=1 to 6 do if adv[i,1]>0 then inc(numrai);
x:=20; y:=12; vx:=x; vy:=y; gata:=false; mort:=false;
dir:=sus;
Des_adv;
noumes('                NIVEL '+strs(nivel,2)+'                ');
for i:=1 to 10 do
begin
Des_juc;
sun_Tiaun(25-i*2);
sterge_juc(1);
sun_Tiaun(25-i*2);
end;
des_juc;
timp:=220;
mesajscor;
repeat
Des_juc;
Misca_adv;
Des_adv;
vx:=x;
vy:=y;
ts:='?';
for m:=0 to 5-viteza do
begin
for i:=1 to 40 do
begin
if keypressed then ts:=readkey;
delay(1);
end;
end;
if ts=chr(27) then goto iesire;
if (ts=chr(75)) and (dir<>dreapta) then dir:=stanga;
if (ts=chr(77)) and (dir<>stanga) then dir:=dreapta;
if (ts=chr(72)) and (dir<>jos) then dir:=sus;
if (ts=chr(80)) and (dir<>sus) then dir:=jos;
if dir=sus then y:=y-1;
if dir=jos then y:=y+1;
if dir=stanga then x:=x-1;
if dir=dreapta then x:=x+1;
if (y<0) or (y>23) or (x<0) or (x>39) then begin mort:=true; gata:=true; end
                                      else if grila[x,y]<>0 then begin mort:=true; gata:=true; end;
if timp>0 then dec(timp);
if (timp=0) then begin mort:=true; gata:=true; end;
if numrai=0 then gata:=true;
actscor;
if ts='p' then
begin
nosound;
noumes('                 PAUZA                  ');
readkey;
mesajscor;
end;
until gata=true;
if mort=true then
             begin
             Sun_crasti; Sterge_juc(1);
             vieti:=vieti-1;
             if vieti>0 then
                        begin
                        noumes('            VIETI RAMASE: '+strs(vieti,1)+'             ');
                        delay(1000);
                        end;
             if vieti=0 then
                        begin
                        noumes('            ESTI TERMINAT !!            ');
                        for i:=20 downto 1 do
                        begin
                        sun_Tiaun(25-i);
                        end;
                        sterge_tot;
                        if scor>recd then nou_recd;
                        goto restart;
                        end;
             end;
if mort=false then
              begin
              noumes('      BRAVO !!  BONUS TIMP: '+strs(timp*10,6)+'      ');
              scor:=scor+timp*10;
              nivel:=nivel+1;
              Sun_iaunt(40); delay(500);
              end;
sterge_tot;
delay(500);
goto start_nivel;
iesire:
deinitvideo;
write(calibrare);
end.
