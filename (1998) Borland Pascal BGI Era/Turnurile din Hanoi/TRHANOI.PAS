program TrHanoi; {V3.0}
uses graph,crt,dos,bgidriv,bgifont;
const grosimedisc=7;
      tija_ybaza=112;
      tija_yvarf=tija_ybaza-75;
      cul_rezervata=8;
      umplHatch : FillPatternType = ($AA, $55, $AA, $55, $AA, $55, $AA, $55);
      culori:array[1..14] of byte=(4,6,22,18,19,17,21,5,1,3,2,16,7,23);
      paleta:array[1..14,1..3] of byte=((63,0,0),(63,30,0),(63,63,0),(0,63,6),
                                     (0,57,63),(6,0,63),(55,0,60),(63,0,31),
                                     (40,20,0),(30,10,0),(55,55,55),(24,24,24),
                                     (42,42,42),(63,63,63));
{ROSU,PORTOCALIU,GALBEN,AZURIU,ALBASTRU,VIOLET,PURPURIU,MARO,LEMN,FUNDAL,GRI,
 GRI-INCHIS,ALB}
var cpage:byte;
    gr_mod,gr_driver:integer;
    turnuri:array[1..3,1..8] of byte;
    sunet:boolean;
    eroare:integer;
    mesajbara:string;
    numdsc:integer;
    rezolvat:boolean;
    cul_mesaj:byte;
    mutare:integer;
    ecranprinc:integer;
    sfarsit:boolean;
    sursa_i:byte;
    dest_i:byte;
    {Generale}
    strn1:string;
    strn2:string;
    bool1:boolean;
    char1:char;
    byte1:byte;
    i,j,k:integer;
{----------------------------------------------------------------------------}
procedure parasdos;
begin
nosound;
gotoxy(1,1);
for i:=0 to 40 do
begin
delline;
delay(5);
end;
end;
{----------------------------------------------------------------------------}
procedure sunet_activ;
begin
for k:=1 to 10 do
begin
if sunet=true then sound(5000+k*250);
delay(1);
end;
nosound;
end;
{----------------------------------------------------------------------------}
procedure sunet_dezactiv;
begin
for k:=10 downto 0 do
begin
if sunet=true then sound(5000+k*250);
delay(1);
end;
nosound;
end;
{----------------------------------------------------------------------------}
procedure Bip(frecv,frec2,durata,sop:integer);
begin
for k:=0 to durata do
begin
if sunet=true then sound (frecv);
delay(sop);
if sunet=true then sound (round(frec2-(sin(k*18)*200)));
delay(sop);
end;
nosound;
end;
{----------------------------------------------------------------------------}
procedure Sunet_piesa;
begin
Bip(3960,1960,3,2);
end;
{----------------------------------------------------------------------------}
procedure Sunet_tasta;
begin
Bip(2960,2960,1,1);
end;
{----------------------------------------------------------------------------}
procedure Sunet_Eroare;
begin
Bip(3960,1960,100,2);
end;
{----------------------------------------------------------------------------}
procedure sunet_gata;
begin
Bip(2960,2960,200,1);
end;
{----------------------------------------------------------------------------}
Procedure WaitRetrace; {din PC Games Programmers Encyclopedia}
label
  l1, l2;
begin
asm
    mov dx,3DAh
l1:
    in al,dx
    and al,08h
    jnz l1
l2:
    in al,dx
    and al,08h
    jz  l2
end;
end;
{----------------------------------------------------------------------------}
procedure lumineaza;
var er,ge,be:integer;
begin
for j:=16 downto 0 do
begin
waitretrace;
for i:=12 to 14 do
begin
er:=paleta[i,1]-j*4;
if er<0 then er:=0;
ge:=paleta[i,2]-j*4;
if ge<0 then ge:=0;
be:=paleta[i,3]-j*4;
if be<0 then be:=0;
SetRgbPalette(culori[i],er,ge,be);
end;
end;
waitretrace;
for i:=1 to 14 do
begin
SetRgbPalette(culori[i],paleta[i,1],paleta[i,2],paleta[i,3]);
end;
end;
{----------------------------------------------------------------------------}
procedure intuneca;
var er,ge,be:integer;
begin
for j:=0 to 16 do
begin
waitretrace;
for i:=12 to 14 do
begin
er:=paleta[i,1]-j*4;
if er<0 then er:=0;
ge:=paleta[i,2]-j*4;
if ge<0 then ge:=0;
be:=paleta[i,3]-j*4;
if be<0 then be:=0;
SetRgbPalette(culori[i],er,ge,be);
end;
end;
end;
{----------------------------------------------------------------------------}
procedure intuneric;
begin
for i:=1 to 14 do setrgbpalette(culori[i],0,0,0);
end;
{----------------------------------------------------------------------------}
procedure term_eroare;
begin
TextMode(13);
write('Eroare grafica !');
Sunet_eroare;
Halt(1);
end;
{----------------------------------------------------------------------------}
procedure init_grafica;
begin
  if RegisterBGIdriver(@EGAVGADriverProc) < 0 then term_eroare;
  if RegisterBGIfont(@GothicFontProc) < 0 then term_eroare;
  if RegisterBGIfont(@SansSerifFontProc) < 0 then term_eroare;
  if RegisterBGIfont(@SmallFontProc) < 0 then term_eroare;
  if RegisterBGIfont(@TriplexFontProc) < 0 then term_eroare;
gr_driver:=VGA;
gr_mod:=VGALo;
initgraph(gr_driver,gr_mod,'');
end;
{----------------------------------------------------------------------------}
procedure Desdisc(tija:byte;inaltime:byte;diametru:byte;esteinvarf:boolean);
var rx,ry:integer;
    cul:integer;
begin
if diametru=2 then cul:=4;
if diametru=3 then cul:=6;
if diametru=4 then cul:=14;
if diametru=5 then cul:=10;
if diametru=6 then cul:=11;
if diametru=7 then cul:=9;
if diametru=8 then cul:=13;
if diametru=9 then cul:=5;
rx:=tija*160;
ry:=tija_ybaza-grosimedisc-((inaltime-1)*(grosimedisc+1));
setcolor(cul_rezervata);
ellipse(rx,ry,0,180,diametru*9,1+diametru div 1);
ellipse(rx,ry+grosimedisc,160+diametru,3,diametru*9,1+diametru div 1);
line (rx-diametru*9,ry,rx-diametru*9,ry+grosimedisc);
line (rx+diametru*9,ry,rx+diametru*9,ry+grosimedisc);
setfillstyle(1,cul);
floodfill(rx,ry,cul_rezervata);
setcolor(cul_rezervata);
ellipse(rx,ry,0,360,diametru*9,1+diametru div 1);
ellipse(rx,ry+grosimedisc,160+diametru,3,diametru*9,1+diametru div 1);
line (rx-diametru*9,ry,rx-diametru*9,ry+grosimedisc);
line (rx+diametru*9,ry,rx+diametru*9,ry+grosimedisc);
setfillpattern(umplHatch,cul);
floodfill(rx,ry+grosimedisc+diametru div 1,cul_rezervata);
setcolor(0);
ellipse(rx,ry,0,360,diametru*9,1+diametru div 1);
ellipse(rx,ry+grosimedisc,160+diametru,3,diametru*9,1+diametru div 1);
line (rx-diametru*9,ry,rx-diametru*9,ry+grosimedisc);
line (rx+diametru*9,ry,rx+diametru*9,ry+grosimedisc);
if esteinvarf=true then
begin
setcolor(0);
setfillpattern(umplHatch,cul);
fillellipse(rx,ry,(diametru*9) div 5,(1+diametru div 1) div 5);
setcolor(0);
line(rx-2,ry+(1+diametru div 1) div 5,rx-2,tija_yvarf+1);
setcolor(7);
line(rx-1,ry+(1+diametru div 1) div 5,rx-1,tija_yvarf+1);
setcolor(15);
line(rx+0,ry+(1+diametru div 1) div 5,rx+0,tija_yvarf+1);
setcolor(7);
line(rx+1,ry+(1+diametru div 1) div 5,rx+1,tija_yvarf+1);
setcolor(0);
line(rx+2,ry+(1+diametru div 1) div 5,rx+2,tija_yvarf+1);
end;
end;
{----------------------------------------------------------------------------}
procedure initdiscuri;
begin
for i:=1 to 8 do
begin
if i<=numdsc then turnuri[1,i]:=10-i;
turnuri[2,i]:=0;
turnuri[3,i]:=0;
end;
end;
{----------------------------------------------------------------------------}
procedure verificarez;
var res:boolean;
begin
res:=true;
for i:=1 to numdsc do
begin
if turnuri[3,i]<>10-i then res:=false;
end;
if res=true then rezolvat:=true;
end;
{----------------------------------------------------------------------------}
function estegol(tr:integer):boolean;
var res:boolean;
begin
res:=false;
if turnuri[tr,1]=0 then res:=true;
estegol:=res;
end;
{----------------------------------------------------------------------------}
function Dinvarf(tr:integer):integer;
var res:integer;
label el1;
begin
for i:=1 to 8 do
begin
if turnuri[tr,i]=0 then
begin
res:=i-1;
goto el1;
end;
end;
res:=8;
el1:
Dinvarf:=res;
end;
{----------------------------------------------------------------------------}
procedure FaMutarea(surs,dest:byte);
begin
inc(mutare);
turnuri[dest,Dinvarf(dest)+1]:=turnuri[surs,Dinvarf(surs)];
turnuri[surs,Dinvarf(surs)]:=0;
end;
{----------------------------------------------------------------------------}
procedure desmasa;
begin
setcolor(0);
line(12,tija_ybaza-22,627,tija_ybaza-22);
setfillstyle(1,3);
bar(12,tija_ybaza-21,627,157);
setfillstyle(userfill,1);
setfillpattern(umplHatch,1);
bar(30,tija_ybaza+14,609,tija_ybaza+24);
rectangle(30,tija_ybaza+14,609,tija_ybaza+24);
line(30,tija_ybaza+14,60,tija_ybaza-10);
line(609,tija_ybaza+14,581,tija_ybaza-10);
line(60,tija_ybaza-10,581,tija_ybaza-10);
setfillstyle(1,1);
floodfill(320,tija_ybaza-5,0);
for i:=1 to 3 do
begin
setColor(0);
line ((160*i)-2,tija_yvarf,(160*i)-2,tija_ybaza);
setColor(7);
line ((160*i)-1,tija_yvarf,(160*i)-1,tija_ybaza);
setColor(15);
line ((160*i)+0,tija_yvarf,(160*i)+0,tija_ybaza);
setColor(7);
line ((160*i)+1,tija_yvarf,(160*i)+1,tija_ybaza);
setColor(0);
line ((160*i)+2,tija_yvarf,(160*i)+2,tija_ybaza);
setcolor(2);
line ((160*i)-2,tija_yvarf,(160*i)+2,tija_yvarf);
setcolor(1);
line ((160*i)-2,tija_ybaza,(160*i)+2,tija_ybaza);
setcolor(0);
line ((160*i)-2,tija_yvarf,(160*i)+2,tija_yvarf);
line ((160*i)-2,tija_ybaza,(160*i)+2,tija_ybaza);
end;
end;
{----------------------------------------------------------------------------}
procedure desdiscuri;
begin
for j:=1 to 3 do
begin
for i:=1 to 8 do
begin
bool1:=false;
if i<8 then if turnuri[j,i+1]=0 then bool1:=true;
if i=8 then bool1:=true;
if (turnuri[j,i]>0) then DesDisc(j,i,turnuri[j,i],bool1);
end;
end;
end;
{----------------------------------------------------------------------------}
procedure cadru(fx1,fy1,fx2,fy2,tip:integer);
begin
if tip=1 then setcolor(15);
if tip=2 then setcolor(8);
line (fx1+0,fy1+0,fx2-2,fy1+0);
line (fx1+0,fy1+0,fx1+0,fy2-1);
line (fx1+1,fy1+0,fx1+1,fy2-1);
if tip=1 then setcolor(8);
if tip=2 then setcolor(15);
line (fx1+2,fy2+0,fx2+0,fy2+0);
line (fx2+0,fy1+1,fx2+0,fy2+0);
line (fx2-1,fy1+1,fx2-1,fy2+0);
end;
{----------------------------------------------------------------------------}
procedure cutie(x1,y1,x2,y2,fundal:integer);
begin
setfillstyle(1,7);
bar(x1,y1,x2,y2);
cadru(x1+00,y1+00,x2-00,y2-00,1);
cadru(x1+10,y1+6,x2-10,y2-6,2);

cadru(x1+12,y1+02,x2-12,y1+04,2);
cadru(x1+03,y2-04,x2-12,y2-02,2);

cadru(x1+03,y1+02,x1+07,y1+04,2);
cadru(x2-07,y1+02,x2-03,y1+04,2);
cadru(x1+03,y2-04,x1+07,y2-02,2);
cadru(x2-07,y2-04,x2-03,y2-02,2);

cadru(x1+03,y1+07,x1+07,y2-7,2);
cadru(x2-07,y1+07,x2-03,y2-7,2);

setfillstyle(1,fundal);
bar(x1+12,y1+7,x2-12,y2-7);
end;
{----------------------------------------------------------------------------}
procedure cutieCU(x1,y1,x2,y2,fundal:integer);
begin
setfillstyle(1,7);
bar(x1,y1,x2,y2);
cadru(x1+00,y1+00,x2-00,y2-00,1);
cadru(x1+10,y1+6,x2-10,y2-6,2);

cadru(x1+12,y1+02,x2-12,y1+04,2);
cadru(x1+12,y2-04,x2-12,y2-02,2);

cadru(x1+03,y1+02,x1+07,y1+04,2);
cadru(x2-07,y1+02,x2-03,y1+04,2);
cadru(x1+03,y2-04,x1+07,y2-02,2);
cadru(x2-07,y2-04,x2-03,y2-02,2);

cadru(x1+03,y1+07,x1+07,y2-7,2);
cadru(x2-07,y1+07,x2-03,y2-7,2);

setfillstyle(1,fundal);
bar(x1+12,y1+7,x2-12,y2-7);
setcolor(7);
line(x1+2,y1,x1+11,y1);
line(x2-9,y1,x2-2,y1);
setcolor(8);
line(x2-1,y1,x2,y1);
end;
{----------------------------------------------------------------------------}
function Str3(nr:integer):string;
begin
strn1:='';
strn2:='';
str(nr,strn2);
if nr<100 then strn1:=strn1+'0';
if nr<10 then strn1:=strn1+'0';
strn1:=strn1+strn2;
Str3:=strn1;
end;
{----------------------------------------------------------------------------}
procedure scrie(txx,txy:integer;ce:string;cul:byte);
begin
settextstyle(0,0,0);
settextjustify(1,1);
if cul=1 then setcolor(8);
if cul=2 then setcolor(0);
if cul=3 then setcolor(9);
outtextxy(txx+1,txy+1,ce);
if cul=1 then setcolor(15);
if cul=2 then setcolor(4);
if cul=3 then setcolor(11);
outtextxy(txx+0,txy+0,ce);
end;
{----------------------------------------------------------------------------}
procedure desecran2;
begin
scrie(320,25,'T u r n u r i l e   d i n   H a n o i',3);
scrie(320,67,'O aplicatie grafica a problemei lui E. Lucas',1);
scrie(320,82,'Programat in Borland Pascal 7 de Dinu Cristian Mircea',1);
scrie(320,97,'Versiune algoritm: á1',1);
end;
{----------------------------------------------------------------------------}
procedure desecran3;
begin
scrie(320,25,'T u r n u r i l e   d i n   H a n o i',3);
scrie(320,82,'Introdu numarul de discuri (3-8)',1);
end;
{----------------------------------------------------------------------------}
procedure desecran4;
begin
scrie(320,25,'T u r n u r i l e   d i n   H a n o i',3);
scrie(320,82,'Mai vrei o partida ? (Da/Nu)',1);
end;
{----------------------------------------------------------------------------}
procedure desecran5;
begin
scrie(320,25,'T u r n u r i l e   d i n   H a n o i',3);
scrie(320,75,'Mutari facute: '+Str3(mutare-1),1);
j:=2;
for i:=2 to numdsc do j:=j*2;
scrie(320,90,'Mutari minime: '+Str3(j-1),1);
end;
{----------------------------------------------------------------------------}
procedure desecran6;
begin
scrie(320,25,'T u r n u r i l e   d i n   H a n o i',3);
scrie(320,82,'Pot sa incerc si eu ? (Da/Nu)',1);
end;
{----------------------------------------------------------------------------}
procedure desecran7;
begin
scrie(320,25,'T u r n u r i l e   d i n   H a n o i',3);
scrie(320,82,'Calculez ...',1);
end;
{----------------------------------------------------------------------------}
procedure desecran8;
begin
scrie(320,25,'T u r n u r i l e   d i n   H a n o i',3);
scrie(320,82,'Nu stiu sa rezolv problema din pozitia asta !',1);
end;
{----------------------------------------------------------------------------}
procedure desecran10;
begin
scrie(320,25,'T u r n u r i l e   d i n   H a n o i',3);
end;
{----------------------------------------------------------------------------}
procedure desecran00;
begin
if ecranprinc=1 then cutie(0,0,639,164,2)
             else cutie(0,0,639,164,0);
cutieCu(0,158,639,190,0);
if ecranprinc=1 then begin desmasa; desdiscuri; end;
if ecranprinc=2 then desecran2;
if ecranprinc=3 then desecran3;
if ecranprinc=4 then desecran4;
if ecranprinc=5 then desecran5;
if ecranprinc=6 then desecran6;
if ecranprinc=7 then desecran7;
if ecranprinc=8 then desecran8;
if ecranprinc=10 then desecran10;
scrie(320,174,mesajbara,cul_mesaj);
end;
{----------------------------------------------------------------------------}
procedure Act_mesaj;
begin
cul_mesaj:=1;
Str(mutare,strn1);
mesajbara:='Mutarea #'+Str3(mutare)+' = ( ';
if sursa_i=255 then mesajbara:=mesajbara+'?';
if sursa_i=1 then mesajbara:=mesajbara+'1';
if sursa_i=2 then mesajbara:=mesajbara+'2';
if sursa_i=3 then mesajbara:=mesajbara+'3';
mesajbara:=mesajbara+' - ';
if dest_i=255 then mesajbara:=mesajbara+'?';
if dest_i=1 then mesajbara:=mesajbara+'1';
if dest_i=2 then mesajbara:=mesajbara+'2';
if dest_i=3 then mesajbara:=mesajbara+'3';
mesajbara:=mesajbara+' )';
end;
{----------------------------------------------------------------------------}
procedure Act_video;
begin
waitretrace; {Sa nu flicker-easca}
desecran00;
setvisualpage(cpage);
setactivepage(1-cpage);
cpage:=1-cpage;
end;
{----------------------------------------------------------------------------}
procedure ArataEcr(scre:integer);
begin
ecranprinc:=scre;
Act_video;
if scre<10 then sunet_activ
           else sunet_dezactiv;
if scre<>1 then delay(125);
end;
{----------------------------------------------------------------------------}
procedure Ceremutarea;
label lb0,lb1,lb2,lb3,lb4;
begin
lb0:
sursa_i:=255;
dest_i:=255;
Act_mesaj;
Act_video;
if mutare>1 then Sunet_piesa;
lb1:
char1:=readkey;
if char1=chr(27) then
begin
sfarsit:=true;
goto lb4;
end;
byte1:=ord(char1);
if (byte1>48) and (byte1<52) then sursa_i:=byte1-48
                             else goto lb1;
Act_mesaj;
Act_video;
Sunet_tasta;
lb2:
char1:=readkey;
if char1=chr(27) then
begin
sfarsit:=true;
goto lb4;
end;
byte1:=ord(char1);
if (byte1>48) and (byte1<52) then dest_i:=byte1-48
                             else goto lb2;
Act_mesaj;
Act_video;
Sunet_tasta;
{Verifica}
bool1:=false;
if sursa_i=dest_i then bool1:=true;
if estegol(sursa_i) then bool1:=true;
if (bool1=false) and (estegol(dest_i)) then goto lb3;
if turnuri[sursa_i,Dinvarf(sursa_i)]>turnuri[dest_i,Dinvarf(dest_i)] then bool1:=true;
lb3:
if bool1=true then
begin
delay(200);
cul_mesaj:=2;
mesajbara:='Eroare !';
Act_video;
Sunet_Eroare;
goto lb0;
end;
lb4:
delay(200);
end;
{----------------------------------------------------------------------------}
procedure prezinta;
begin
mesajbara:='';
ArataEcr(11);
lumineaza;
ArataEcr(2);
delay(3000);
ArataEcr(10);
end;
{----------------------------------------------------------------------------}
procedure IntreabaDiscuri;
label lab0;
begin
ArataEcr(3);
lab0:
char1:=readkey;
byte1:=ord(char1);
if (byte1>50) and (byte1<57) then numdsc:=byte1-48
                             else goto lab0;
Sunet_tasta;
end;
{----------------------------------------------------------------------------}
procedure initjoc;
begin
mutare:=1;
ecranprinc:=1;
sfarsit:=false;
rezolvat:=false;
mesajbara:='';
Act_video;
sunet_activ;
end;
{----------------------------------------------------------------------------}
procedure joaca;
begin
while (sfarsit=false) do
begin
CereMutarea;
if not sfarsit then FaMutarea(sursa_i,dest_i);
verificarez;
if rezolvat then sfarsit:=true;
end;
end;
{----------------------------------------------------------------------------}
procedure termjoc;
begin
cul_mesaj:=1;
mesajbara:='OK - problema rezolvata !';
Act_video;
sunet_gata;
delay(1000);
end;
{----------------------------------------------------------------------------}
procedure statistica;
begin
ArataEcr(5);
delay(2000);
ArataEcr(10);
end;
{----------------------------------------------------------------------------}
procedure Cls;
begin
mesajbara:='';
ArataEcr(11);
end;
{----------------------------------------------------------------------------}
function IntreabaDN:boolean;
var res:boolean;
label la0;
begin
la0:
char1:=upcase(readkey);
if (char1<>'D') and (char1<>'N') then goto la0;
Sunet_tasta;
res:=false;
if char1='D' then res:=true;
IntreabaDN:=res;
end;
{----------------------------------------------------------------------------}
procedure Rezolva;
var pazuzu:array[0..255,1..3,1..8] of byte;
    mutari:array[0..255,1..2] of byte;
    backup:array[1..3,1..8] of byte;
    tacum:integer;
    respectiva:integer;
    lafel:boolean;
label lk;
{  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure rez_alfa;
var gata:boolean;
begin
Cls;
mesajbara:='Iata cum se rezolva de aici :';
ecranprinc:=1;
Act_video;
sunet_activ;
Sunet_tasta;
delay(1000);
inc(respectiva);
gata:=false;
mutare:=tacum;
while not gata do
begin
sursa_i:=mutari[respectiva,1];
dest_i:=mutari[respectiva,2];
inc(respectiva);
FaMutarea(sursa_i,dest_i);
Act_mesaj;
Act_video;
Sunet_tasta;
verificarez;
if (rezolvat) then gata:=true;
end;
termjoc;
Cls;
inc(mutare);
statistica;
end;
{  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure rez_beta(d_S,d_d:integer);
var gata:boolean;
begin
Cls;
mesajbara:='Iata cum se rezolva de aici :';
ecranprinc:=1;
Act_video;
sunet_activ;
Sunet_tasta;
delay(1000);
mutari[respectiva,1]:=d_s;
mutari[respectiva,2]:=d_d;
gata:=false;
mutare:=tacum;
while not gata do
begin
sursa_i:=mutari[respectiva,1];
dest_i:=mutari[respectiva,2];
inc(respectiva);
FaMutarea(sursa_i,dest_i);
Act_mesaj;
Act_video;
Sunet_tasta;
{Sunet_piesa;}
verificarez;
if (rezolvat) then gata:=true;
end;
termjoc;
Cls;
inc(mutare);
statistica;
end;
{  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure rez_beta2(d_s,d_d,d_s2,d_d2:integer);
var gata:boolean;
begin
Cls;
mesajbara:='Iata cum se rezolva de aici :';
ecranprinc:=1;
Act_video;
sunet_activ;
Sunet_tasta;
delay(1000);
dec(respectiva);
mutari[respectiva,1]:=d_s;
mutari[respectiva,2]:=d_d;
mutari[respectiva+1,1]:=d_s2;
mutari[respectiva+1,2]:=d_d2;
gata:=false;
mutare:=tacum;
while not gata do
begin
sursa_i:=mutari[respectiva,1];
dest_i:=mutari[respectiva,2];
inc(respectiva);
FaMutarea(sursa_i,dest_i);
Act_mesaj;
Act_video;
Sunet_tasta;
verificarez;
if (rezolvat) then gata:=true;
end;
termjoc;
Cls;
inc(mutare);
statistica;
end;
{  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Inr(t_surs,t_dest:integer);
begin
FaMutarea(t_surs,t_dest);
ecranprinc:=1;
mutari[byte1,1]:=t_surs;
mutari[byte1,2]:=t_dest;
for i:=1 to 3 do for j:=1 to 8 do pazuzu[byte1,i,j]:=turnuri[i,j];
inc(byte1);
end;
{  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Hanoi(n,a,b,c:integer);
begin
if n=1 then inr(a,b)
       else begin
            hanoi(n-1,a,c,b);
            inr(a,b);
            hanoi(n-1,c,b,a);
            end;
end;
{  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
function CautaPoz:integer;
var aceea:integer;
begin
aceea:=999;
for k:=0 to 255 do
begin
lafel:=true;
for i:=1 to 3 do for j:=1 to 8 do if (turnuri[i,j]<>pazuzu[k,i,j])
                                  then lafel:=false;
if lafel=true then aceea:=k;
end;
CautaPoz:=aceea;
end;
{  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure salvtabla;
begin
for i:=1 to 3 do for j:=1 to 8 do backup[i,j]:=turnuri[i,j];
end;
{  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure restaurtabla;
begin
for i:=1 to 3 do for j:=1 to 8 do turnuri[i,j]:=backup[i,j];
end;
{  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure inregjoc;
begin
initdiscuri;
for i:=1 to 3 do for j:=1 to 8 do pazuzu[0,i,j]:=turnuri[i,j];
byte1:=1;
Hanoi(numdsc,1,3,2);
end;
{  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure inc_rez_beta;
label l0,l1;
var var_s,var_d:integer;
begin
for var_s:=1 to 3 do
begin
for var_d:=1 to 3 do
begin
if var_s=var_d then goto l0;
restaurtabla;
FaMutarea(var_s,var_d);
respectiva:=CautaPoz;
if respectiva<>999 then
begin
restaurtabla;
rez_beta(var_s,var_d);
goto l1;
end;
l0:
end;
end;
l1:
end;
{  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure inc_rez_beta2;
label l0,l1,l02;
var var_s,var_d:integer;
    var_s2,var_d2:integer;
begin
for var_s:=1 to 3 do
begin
for var_d:=1 to 3 do
begin
if var_s=var_d then goto l0;
for var_s2:=1 to 3 do
begin
for var_d2:=1 to 3 do
begin
if var_s2=var_d2 then goto l02;
restaurtabla;
FaMutarea(var_s,var_d);
FaMutarea(var_s2,var_d2);
respectiva:=CautaPoz;
if respectiva<>999 then
begin
restaurtabla;
rez_beta2(var_s,var_d,var_s2,var_d2);
goto l1;
end;
l02:
end;
end;
l0:
end;
end;
l1:
end;
{  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
begin
tacum:=mutare-1;
salvtabla;
inregjoc;
restaurtabla;
respectiva:=CautaPoz;
if respectiva=999 then goto lk;
rez_alfa;
lk:
if respectiva=999 then inc_rez_beta;
if respectiva=999 then inc_rez_beta2;
if respectiva=999 then begin
ArataEcr(8);
Sunet_Eroare;
delay(1000);
end;
end;
{----------------------------------------------------------------------------}
procedure intreabarez;
label gata;
begin
ArataEcr(6);
if IntreabaDN=false then goto gata;
ArataEcr(10);
ArataEcr(7);
Rezolva;
gata:
ArataEcr(10);
end;
{----------------------------------------------------------------------------}
(*                               PRINCIPALU'                                *)
{----------------------------------------------------------------------------}
label lab0;
begin
cpage:=0;
sunet:=true;
if (paramcount>0) then
begin
if pos('/s',paramstr(1))<>0 then sunet:=false;
if (pos('/?',paramstr(1))<>0) or (pos('/h',paramstr(1))<>0) then
begin
clrscr;
writeln('Turnul din Hanoi - programat de Dinu Cristian Mircea');
writeln('Parametrii: /? sau /h - ajutor');
writeln('            /s - fara sunet');
halt;
end;
end;
parasdos;
init_grafica;
intuneric;
prezinta;
lab0:
IntreabaDiscuri;
Cls;
initdiscuri;
initjoc;
joaca;
if rezolvat then termjoc;
Cls;
if rezolvat then statistica;
if not rezolvat then intreabarez;
ArataEcr(4);
if (IntreabaDN)=true then
begin
ArataEcr(10);
goto lab0;
end;
Cls;
intuneca;
closegraph;
end.



