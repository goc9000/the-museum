uses dos,crt,rutvid,travdef;
const msemn:array[1..6,0..6] of byte=((0,8,0,0,0,8,0), {:}
                                      (0,0,0,0,0,8,16), {,}
                                      (0,64,96,112,96,64,0), {>}
                                      (0,0,0,62,0,0,0), {-}
                                      (8,28,28,8,8,0,8), {!}
                                      (0,0,28,32,28,2,60));{s}
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

      pm_recd=10;
      pm_numerecd=11;
      maxmes=12;
type rau=array[0..127] of byte;
var i,j,k,l,m:integer;
    sd:integer;
    zzum:integer;
    anim,anim2:integer;
    mesaje:array[1..maxmes] of string;
    nivel:integer;
    stb:boolean;
    mas1d:array[1..6] of rau;
    mas1s:array[1..6] of rau;
    mas2d:array[1..6] of rau;
    mas2s:array[1..6] of rau;
    cam1d:array[1..6] of rau;
    cam1s:array[1..6] of rau;
    rem1d:array[1..6] of rau;
    rem1s:array[1..6] of rau;
    x,y:integer;
    ts:char;
    claxon:integer;
    avceata:integer;
    vechimes:string;
    gata:boolean;
    timp:integer;
    scor,recd:longint;
    numrecd:string;
    tc:char;
    ox,oy:integer;
    ax,ay:integer;
    motod,motos,vald,vals,crocs,crocd,sald,sals,vap1d,vap1s,vap2d,vap2s,vap3d,vap3s:rau;
    rai:array[1..100,1..4] of integer;
    tempf:array[0..63] of byte;
    numrai:integer;
    cultext:integer;
    prajit:boolean;
    calibrare,mincalib:longint;
    vieti:integer;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure salveaza_rec;
var rf:text;
    tl:string;
begin
assign(rf,'traversr.rec');
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
assign(rf,'traversr.rec');
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
if num>999999 then num:=999999;
str(num:lat,temps);
while pos(' ', temps) > 0 do temps[pos(' ', temps)] := '0';
strs:=temps;
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
port[$61]:=stare or sd;
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
port[$61]:=stare or sd;
for j:=0 to mincalib*k do;
port[$61]:=stare;
for j:=0 to mincalib*k do;
end;
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
if car='s' then cx:=msemn[6,cy];
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
procedure DScar(lx,ly:integer;car:char);
var cx,cy,cj,ct,cf:integer;
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
if car='s' then cx:=msemn[6,cy];
if (ord(car)>64) and (ord(car)<91) then cx:=mlit[ord(car)-64,cy];
if (ord(car)>47) and (ord(car)<58) then cx:=mnum[ord(car)-47,cy];
end;
for cj:=0 to 1 do
begin
ct:=3;
cf:=4;
if (cx and 128)>0 then pixel(lx+cj+0,ly+cy,ct) else pixel(lx+cj+0,ly+cy,cf);
if (cx and 64)>0 then pixel(lx+cj+2,ly+cy,ct) else pixel(lx+cj+2,ly+cy,cf);
if (cx and 32)>0 then pixel(lx+cj+4,ly+cy,ct) else pixel(lx+cj+4,ly+cy,cf);
if (cx and 16)>0 then pixel(lx+cj+6,ly+cy,ct) else pixel(lx+cj+6,ly+cy,cf);
if (cx and 8)>0 then pixel(lx+cj+8,ly+cy,ct) else pixel(lx+cj+8,ly+cy,cf);
if (cx and 4)>0 then pixel(lx+cj+10,ly+cy,ct) else pixel(lx+cj+10,ly+cy,cf);
if (cx and 2)>0 then pixel(lx+cj+12,ly+cy,ct) else pixel(lx+cj+12,ly+cy,cf);
if (cx and 1)>0 then pixel(lx+cj+14,ly+cy,ct) else pixel(lx+cj+14,ly+cy,cf);
end;
end;
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
noumes('PUNCTE:'+strs(scor,6)+'   TIMP:'+strs(timp,2)+'s   RECORD:'+strs(recd,6));
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure actscor;
var cic,poz:integer;
    ts1:string;
begin
ts1:='PUNCTE:'+strs(scor,6)+'   TIMP:'+strs(timp,2)+'s   RECORD:'+strs(recd,6);
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
procedure Init;
var byt:byte;
begin
calibrare:=0;
clrscr;
delay(500);
port[$60]:=$f3;
delay(50);
port[$60]:=0;
byt:=mem[0000:$046C];
while mem[0000:$046C]=byt do;
byt:=mem[0000:$046C];
while mem[0000:$046C]=byt do
begin
inc(calibrare);
end;
calibrare:=349371; {Pentru 486DX6 la 133Mhz}
mincalib:=calibrare div 1000;
vechimes:='                                        ';
mesaje[1]:='   PROGRAMAT DE: DINU CRISTIAN MIRCEA   ';
mesaje[2]:='   DUPA IDEEA UNUI JOC DIN ARCADE-URI   ';
mesaje[3]:='              INSTRUCTIUNI:             ';
mesaje[4]:=' >TRAVERSEAZA AUTOSTRADA SI FLUVIUL     ';
mesaje[5]:=' >EVITA MASINILE, VALURILE, NAVELE, ETC ';
mesaje[6]:=' >INCEARCA SA OBTII UN TIMP CAT MAI BUN ';
mesaje[7]:='  PENTRU A PRIMI CAT MAI MULTE PUNCTE   ';
mesaje[8]:='    APASA ORICE TASTA PENTRU A PORNI    ';
mesaje[9]:='      SAU ESC PENTRU A IESI IN DOS      ';
Actmesrecd;
mesaje[12]:='                                        ';
randomize;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Sun_crasti;
var stare:byte;
    si:integer;
begin
stare:=(port[$61] and 252);
for k:=1 to 64 do
begin
for si:=0 to (1000 div k) do
begin
port[$61]:=stare or (random(sd) shl 1);
for j:=0 to mincalib*k*2 do;
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
port[$61]:=stare or (random(sd) shl 1);
for j:=0 to mincalib*4 do;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure puneom(ux,uy:integer;cadru:array of byte);
var cx,cy,loc:integer;
begin
loc:=0;
for cy:=0 to 7 do for cx:=0 to 7 do begin
                                    tempf[loc]:=punct(ux+cx,uy+cy);
                                    if cadru[loc]<>0 then pixel(ux+cx,uy+cy,cadru[loc]);
                                    loc:=loc+1;
                                    end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Fa_masina(var mat:array of byte; def1:string; cul,op:byte);
var loc:integer;
begin
for i:=1 to 128 do
begin
if op=0 then loc:=i-1;
if op=1 then loc:=((i-1) and 240)+(15-((i-1) mod 16));
if def1[i]=' ' then mat[loc]:=0;
if def1[i]='C' then mat[loc]:=cul;
if def1[i]='c' then mat[loc]:=cul+8;
if def1[i]='f' then mat[loc]:=14;
if def1[i]='a' then mat[loc]:=130;
if def1[i]='b' then mat[loc]:=20;
if def1[i]='d' then mat[loc]:=128;
if def1[i]='e' then mat[loc]:=129;
if def1[i]='z' then mat[loc]:=2;
if def1[i]='Z' then mat[loc]:=44;
if def1[i]='.' then mat[loc]:=6;
if def1[i]='v' then mat[loc]:=31;
if def1[i]='k' then mat[loc]:=10;
if def1[i]='m' then mat[loc]:=28;
if def1[i]='M' then mat[loc]:=32;
if def1[i]='R' then mat[loc]:=22;
if def1[i]='A' then mat[loc]:=3;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DesMas(x,y:integer;mas:array of byte);
begin
if x<305 then sprite(x,y,16,8,0,0,mas);
if x>304 then sprite(x,y,16-(x-304),8,(x-304),0,mas);
if x>304 then sprite(0,y,(x-304),8,0,16-(x-304),mas);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Nourau(ux,uy,tip,dir:integer);
begin
numrai:=numrai+1;
rai[numrai,1]:=ux;
rai[numrai,2]:=uy;
rai[numrai,3]:=tip;
rai[numrai,4]:=dir;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure GenLin(lin,fel:integer);
var bx:integer;
    incr:byte;
    sct:integer;
    lng:byte;
    pls:integer;
begin
bx:=random(3);
sct:=1;
repeat
if fel=1 then
         begin
         pls:=random(5);
         if bx>34 then pls:=0;
         if pls<2 then
                        begin
                        Nourau(bx*8,lin*8,0*10+1+random(6),1);
                        lng:=2;
                        end
                        else
                        begin
                        lng:=1+random(6);
                        Nourau(bx*8,lin*8,4*10+lng,1);
                        Nourau(bx*8+16,lin*8,2*10+lng,1);
                        lng:=4;
                        end;
         end;
if fel=2 then
         begin
         pls:=random(5);
         if bx>34 then pls:=0;
         if pls<2 then
                        begin
                        Nourau(bx*8,lin*8,1*10+1+random(6),-1);
                        lng:=2;
                        end
                        else
                        begin
                        lng:=1+random(6);
                        Nourau(bx*8,lin*8,3*10+lng,-1);
                        Nourau(bx*8+16,lin*8,5*10+lng,-1);
                        lng:=4;
                        end;
         end;
if fel=3 then
         begin
         lng:=2;
         Nourau(bx*8,lin*8,6*10+1+random(6),2);
         end;
if fel=4 then
         begin
         lng:=2;
         Nourau(bx*8,lin*8,7*10+1+random(6),-2);
         end;
if fel=5 then
         begin
         lng:=2;
         Nourau(bx*8,lin*8,100+random(2)*40,2);
         end;
if fel=6 then
         begin
         lng:=2;
         Nourau(bx*8,lin*8,110+random(2)*40,-2);
         end;
if fel=7 then
         begin
         pls:=random(3);
         if bx>34 then pls:=0;
         if pls<2 then
                        begin
                        Nourau(bx*8,lin*8,120,1);
                        lng:=2;
                        end
                        else
                        begin
                        Nourau(bx*8+00,lin*8,200,1);
                        Nourau(bx*8+16,lin*8,180,1);
                        Nourau(bx*8+32,lin*8,160,1);
                        lng:=5;
                        end;
         end;
if fel=8 then
         begin
         pls:=random(3);
         if bx>34 then pls:=0;
         if pls<2 then
                        begin
                        Nourau(bx*8,lin*8,130,-1);
                        lng:=2;
                        end
                        else
                        begin
                        Nourau(bx*8+00,lin*8,170,-1);
                        Nourau(bx*8+16,lin*8,190,-1);
                        Nourau(bx*8+32,lin*8,210,-1);
                        lng:=5;
                        end;
         end;
pls:=10-(nivel div 2);
if pls<1 then pls:=1;
incr:=lng+3+random(pls); {cum nivelele cresc, creste densitatea scazand din random}
if (sct=1) and (incr=5) and (random(2)=0) then begin sct:=0; incr:=4; end;
bx:=bx+incr;
until bx>36;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DesZona(lin:integer;car:array of byte);
var cc:integer;
begin
for cc:=0 to 39 do sprite(cc*8,lin*8,8,8,0,0,car);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Efsun;
var dc:integer;
begin
if (claxon=0) and (random(600)=0) then claxon:=100;
if (claxon=0) and (random(700)=0) then claxon:=60;
if (avceata=0) and (random(650)=0) then avceata:=550;
if claxon>0 then dec(claxon);
if avceata>0 then dec(avceata);
dc:=30;
if (zzum>0) then dc:=zzum;
if (claxon>20) and ((claxon<55) or (claxon>65)) then dc:=(294{+((anim mod 4) div 3)*36});
if (avceata>290) and (avceata<350) then dc:=82;
if (avceata>175) and (avceata<291) then dc:=55;
if (dc=0) or (sd=0) then nosound else sound(dc);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure DesRai;
var tx,ty,tt,bx,by:integer;
const raz=8;
begin
zzum:=0;
for i:=1 to numrai do
begin
tx:=rai[i,1];
ty:=rai[i,2];
tt:=rai[i,3] div 10;
bx:=ox*4;
by:=oy*8;
if (tt<10) and (tt<>4) and (tt<>5) then
begin
if (rai[i,4]>0) and ((tx+16)>(bx-raz)) and (tx<(bx+8+raz)) and ((ty div 8)=oy-2)
   then zzum:=130-((tx+16)-(bx-raz));
if (rai[i,4]<0) and ((tx+16)>(bx-raz)) and (tx<(bx+8+raz)) and ((ty div 8)=oy-2)
   then zzum:=130-((bx+8+raz)-tx);
if zzum<110 then zzum:=0;
end;
if ((tx+16)>bx) and (tx<(bx+8)) and ((ty+8)>by) and (ty<(by+8)) then prajit:=true;
case tt of
    0 : desmas(rai[i,1],rai[i,2],mas1d[rai[i,3] mod 10]);
    1 : desmas(rai[i,1],rai[i,2],mas1s[rai[i,3] mod 10]);
    2 : desmas(rai[i,1],rai[i,2],cam1d[rai[i,3] mod 10]);
    3 : desmas(rai[i,1],rai[i,2],cam1s[rai[i,3] mod 10]);
    4 : desmas(rai[i,1],rai[i,2],rem1d[rai[i,3] mod 10]);
    5 : desmas(rai[i,1],rai[i,2],rem1s[rai[i,3] mod 10]);
    6 : desmas(rai[i,1],rai[i,2],mas2d[rai[i,3] mod 10]);
    7 : desmas(rai[i,1],rai[i,2],mas2s[rai[i,3] mod 10]);
    8 : desmas(rai[i,1],rai[i,2],motod);
    9 : desmas(rai[i,1],rai[i,2],motos);
    10 : desmas(rai[i,1],rai[i,2],vald);
    11 : desmas(rai[i,1],rai[i,2],vals);
    12 : desmas(rai[i,1],rai[i,2],crocd);
    13 : desmas(rai[i,1],rai[i,2],crocs);
    14 : desmas(rai[i,1],rai[i,2],sald);
    15 : desmas(rai[i,1],rai[i,2],sals);
    16 : desmas(rai[i,1],rai[i,2],vap1d);
    17 : desmas(rai[i,1],rai[i,2],vap1s);
    18 : desmas(rai[i,1],rai[i,2],vap2d);
    19 : desmas(rai[i,1],rai[i,2],vap2s);
    20 : desmas(rai[i,1],rai[i,2],vap3d);
    21 : desmas(rai[i,1],rai[i,2],vap3s);
end;
if prajit=false then
begin
if (abs(rai[i,4])=1) and (anim mod 2=0) then rai[i,1]:=rai[i,1]+rai[i,4];
if (abs(rai[i,4])=2) then rai[i,1]:=rai[i,1]+rai[i,4] div 2;
end;
if rai[i,1]>319 then rai[i,1]:=rai[i,1]-320;
if rai[i,1]<0 then rai[i,1]:=rai[i,1]+320;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure InitZona;
begin
numrai:=0;
{noumes('                                        ');}
nosound;
zzum:=0;
claxon:=0;
avceata:=0;
if stb=true then
begin
for i:=1 to 23 do DesZona(i,zona0);
delay(400);
end;
stb:=true;
DesZona(01,zona1);
DesZona(02,zona8);
DesZona(03,zona7);
DesZona(04,zona7);
DesZona(05,zona7);
DesZona(06,zona7);
DesZona(07,zona7);
DesZona(08,zona7);
DesZona(09,zona7);
DesZona(10,zona7);
DesZona(11,zona7);
DesZona(12,zona6);
DesZona(13,zona1);
DesZona(14,zona5);
DesZona(15,zona0);
DesZona(16,zona3);
DesZona(17,zona0);
DesZona(18,zona4);
DesZona(19,zona0);
DesZona(20,zona3);
DesZona(21,zona0);
DesZona(22,zona2);
DesZona(23,zona1);
numrai:=0;
GenLin(3,8);
GenLin(5,7);
GenLin(7,5);
GenLin(9,8);
GenLin(11,6);
Nourau(random(39)*8,13*8,80,2);
GenLin(15,1);
GenLin(17,4);
GenLin(19,2);
GenLin(21,1);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function Demonstratie:boolean;
var ptrmes,cic,astept,poz:integer;
    stg1,stg2:string;
    iesi:boolean;
    dc:integer;
begin
while keypressed do readkey;
ox:=40;
oy:=23;
cultext:=31;
iesi:=false;
poz:=7;
astept:=200;
stg1:=vechimes;
stg2:=mesaje[1];
ptrmes:=1;
ts:='?';
prajit:=false;
anim:=0;
while (ts='?') or (poz<>8) do
begin
Efsun;
Sinc;
Desrai;
anim:=(anim+1) mod 16;
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
if astept<0 then begin astept:=200; poz:=7; end;
if keypressed then ts:=readkey;
if ts='s' then
begin
sd:=2-sd;
ts:='?';
end;
end;
Vechimes:=stg1;
if ts=chr(27) then iesi:=true;
nosound;
demonstratie:=iesi;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
label restniv,restart,iesire;
begin
sd:=2;
incarca_rec;
port[$61]:=port[$61] or 2;
stb:=false;
Init;
initvideo;
Dscar(00*16,0,' ');
Dscar(01*16,0,' ');
Dscar(02*16,0,' ');
Dscar(03*16,0,' ');
Dscar(04*16,0,' ');
Dscar(05*16,0,'T');
Dscar(06*16,0,'R');
Dscar(07*16,0,'A');
Dscar(08*16,0,'V');
Dscar(09*16,0,'E');
Dscar(10*16,0,'R');
Dscar(11*16,0,'S');
Dscar(12*16,0,'A');
Dscar(13*16,0,'R');
Dscar(14*16,0,'E');
Dscar(15*16,0,' ');
Dscar(16*16,0,' ');
Dscar(17*16,0,' ');
Dscar(18*16,0,' ');
Dscar(19*16,0,' ');
for j:=1 to 6 do Fa_masina(mas1d[j],def1,j,0);
for j:=1 to 6 do Fa_masina(mas1s[j],def1,j,1);
for j:=1 to 6 do Fa_masina(cam1d[j],def2,j,0);
for j:=1 to 6 do Fa_masina(cam1s[j],def2,j,1);
for j:=1 to 6 do Fa_masina(rem1d[j],def3,j,0);
for j:=1 to 6 do Fa_masina(rem1s[j],def3,j,1);
for j:=1 to 6 do Fa_masina(mas2d[j],def4,j,0);
for j:=1 to 6 do Fa_masina(mas2s[j],def4,j,1);
Fa_masina(motod,def5,1,0);
Fa_masina(motos,def5,1,1);
Fa_masina(vald,def6,1,0);
Fa_masina(vals,def6,1,1);
Fa_masina(crocd,def7,1,0);
Fa_masina(crocs,def7,1,1);
Fa_masina(sald,def8,1,0);
Fa_masina(sals,def8,1,1);
Fa_masina(vap1d,def9,1,0);
Fa_masina(vap1s,def9,1,1);
Fa_masina(vap2d,defa,1,0);
Fa_masina(vap2s,defa,1,1);
Fa_masina(vap3d,defb,1,0);
Fa_masina(vap3s,defb,1,1);
pal(1,56,00,00);
pal(2,00,56,00);
pal(3,56,56,00);
pal(4,00,00,56);
pal(5,56,00,56);
pal(6,00,56,56);
pal(7,56,56,56);
pal(9,40,00,00);
pal(10,00,40,00);
pal(11,40,40,00);
pal(12,00,00,40);
pal(13,40,00,40);
pal(14,00,40,40);
pal(15,40,40,40);
pal(128,63,32,32);
pal(129,24,16,0);
pal(130,0,0,16);
restart:
vieti:=5;
nivel:=6;
InitZona;
DesRai;
if Demonstratie=true then goto iesire;
scor:=0;
nivel:=1;
InitZona;
DesRai;
restniv:
ox:=40;
oy:=23;
noumes('                NIVEL '+strs(nivel,2)+'                ');
while keypressed do readkey;
for i:=1 to 10 do
begin
puneom(ox*4,oy*8,om1);
sun_Tiaun(25-i*2);
sprite(ox*4,oy*8,8,8,0,0,tempf);
sun_Tiaun(25-i*2);
end;
anim:=0;
anim2:=0;
timp:=59;
puneom(ox*4,oy*8,om1);
mesajscor;
prajit:=false;
ax:=0;
ay:=0;
repeat
Efsun;
sinc;
anim:=(anim+1) mod 16;
anim2:=(anim2+1) mod 60;
if anim2=0 then timp:=timp-1;
if timp<0 then timp:=0;
actscor;
DesRai;
tc:='?';
if keypressed then tc:=readkey;
if (ay=0) and (tc=chr(75)) and (ox>0) then ax:=-1;
if (ay=0) and (tc=chr(77)) and (ox<78) then ax:=1;
if (ax=0) and (tc=chr(72)) and (oy>1) then ay:=-1;
if (ax=0) and (tc=chr(80)) and (oy<23) then ay:=1;
if (ax<>0) and (anim mod 8=0) then
begin
sprite(ox*4,oy*8,8,8,0,0,tempf);
ox:=ox+ax*2;
if ox mod 4=0 then ax:=0;
if (oy>=3) and (oy<=11) then puneom(ox*4,oy*8,om5)
else begin
if (ox mod 4>0) and (ax=-1) then puneom(ox*4,oy*8,om4);
if (ox mod 4>0) and (ax=1) then puneom(ox*4,oy*8,om3);
if ox mod 4=0 then puneom(ox*4,oy*8,om1);
end;
end;
if (ay<>0) and (anim mod 8=0) then
begin
sprite(ox*4,oy*8,8,8,0,0,tempf);
oy:=oy+ay;
if oy mod 2=1 then ay:=0;
if oy mod 2=1 then
              begin
              if (oy>=3) and (oy<=11) then puneom(ox*4,oy*8,om5)
              else puneom(ox*4,oy*8,om1);
              end;
if oy mod 2=0 then puneom(ox*4,oy*8,om2);
end;
if tc='p' then
begin
nosound;
noumes('                 PAUZA                  ');
readkey;
mesajscor;
end;
until (tc=chr(27)) or (prajit) or (oy=1);
if prajit then
begin
sprite(ox*4,oy*8,8,8,0,0,tempf);
desrai;
puneom(ox*4,oy*8,omm);
sun_crasti;
sprite(ox*4,oy*8,8,8,0,0,tempf);
desrai;
vieti:=vieti-1;
if vieti>0 then
begin
noumes('            VIETI RAMASE: '+strs(vieti,1)+'             ');
delay(1000);
goto restniv;
end;
if vieti=0 then
begin
noumes('            ESTI TERMINAT !!            ');
for i:=20 downto 1 do
begin
sun_Tiaun(25-i);
end;
if scor>recd then nou_recd;
goto restart;
end;
end;
if tc<>chr(27) then
begin
if timp>0 then noumes('      BRAVO !!  BONUS TIMP: '+strs(timp*100,6)+'      ');
if timp=0 then noumes('   AI TRECUT CU BINE DAR N-AI BONUS !   ');
scor:=scor+timp*100;
nivel:=nivel+1;
Sun_iaunt(40); delay(1500);
InitZona;
Desrai;
goto restniv;
end;
if tc=chr(27) then
begin
goto restart;
end;
iesire:
deinitvideo;
end.