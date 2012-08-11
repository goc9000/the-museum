uses graph,crt,dos,bgidriv,bgifont;
const Checkerfill : FillPatternType = ($AA, $55, $AA, $55, $AA, $55, $AA, $55);
      year=365.26;
      revtime:array[1..9] of real=(88.98,
                                   224.7,
                                   year,
                                   year+321.7,
                                   11*year+314.8,
                                   29*year+167,
                                   84*year+7,
                                   164*year+280,
                                   247*year+249);
      lunarev=27.32;
var lunarpos:real;
    showmoon:integer;
    rotate:integer;
    mfactor:integer;
    lrfactor:real;
    planpos:array[1..9] of real;
    rfactor:array[1..9] of real;
    cmmmc:longint;
    day:integer;
    mill,yr:integer;
    blank:integer;
    plac:integer;
    dee_mode,dee_driv:integer;
    cpage:byte;
    sounds:boolean;
    error:integer;
    botmes:string;
    highl,highx,highy,highp:integer;
    bmesc:byte;
    numply:byte;
    mainscr:integer;
    zend:boolean;
    cmx,cmy:integer;
    {All-purpose}
    strn1:string;
    strn2:string;
    bool1:boolean;
    char1:char;
    byte1:byte;
    i,j,k:integer;
    BlackPType,WhitePType:byte;
{----------------------------------------------------------------------------}
procedure LeaveDos;
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
procedure Pop;
begin
for k:=1 to 10 do
begin
if sounds=true then sound(5000+k*250);
delay(1);
end;
nosound;
end;
{----------------------------------------------------------------------------}
procedure UnPop;
begin
for k:=10 downto 0 do
begin
if sounds=true then sound(5000+k*250);
delay(1);
end;
nosound;
end;
{----------------------------------------------------------------------------}
procedure Bip(height,heit2,dur,waggle:integer);
begin
for k:=0 to dur do
begin
if sounds=true then sound (height);
delay(waggle);
if sounds=true then sound (round(heit2-(sin(k*18)*200)));
delay(waggle);
end;
nosound;
end;
{----------------------------------------------------------------------------}
procedure PieceBeep;
begin
Bip(3960,1960,3,2);
end;
{----------------------------------------------------------------------------}
procedure KeyBeep;
begin
Bip(2960,2960,1,1);
end;
{----------------------------------------------------------------------------}
procedure ErrorBeep;
begin
Bip(3960,1960,100,2);
end;
{----------------------------------------------------------------------------}
procedure DoneBeep;
begin
Bip(2960,2960,200,1);
end;
{----------------------------------------------------------------------------}
Procedure WaitRetrace;
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
procedure FadeIn;
const co1:array[1..14] of byte=(4,6,22,18,19,17,21,5,1,3,2,16,7,23);
      co2:array[1..14,1..3] of byte=((63,0,0),(48,24,0),{h/sh} (40,0,0),(6,0,63),(0,57,63),
                                     (63,32,0),{h/hi}(0,28,16),{hilite} (12,12,12),(16,16,63),(12,48,32),
                                     (8,32,24),(24,24,24),(42,42,42),(63,63,63));
var er,ge,be:integer;
begin
for j:=16 downto 0 do
begin
waitretrace;
for i:=12 to 14 do
begin
er:=co2[i,1]-j*4;
if er<0 then er:=0;
ge:=co2[i,2]-j*4;
if ge<0 then ge:=0;
be:=co2[i,3]-j*4;
if be<0 then be:=0;
SetRgbPalette(co1[i],er,ge,be);
end;
end;
waitretrace;
for i:=1 to 14 do
begin
SetRgbPalette(co1[i],co2[i,1],co2[i,2],co2[i,3]);
end;
end;
{----------------------------------------------------------------------------}
procedure FadeOut;
const co1:array[1..14] of byte=(4,6,22,18,19,17,21,5,1,3,2,16,7,23);
      co2:array[1..14,1..3] of byte=((63,0,0),(48,24,0),{h/sh} (40,0,0),(6,0,63),(0,57,63),
                                     (63,32,0),{h/hi}(0,28,16),{hilite} (12,12,12),(16,16,63),(12,48,32),
                                     (8,32,24),(24,24,24),(42,42,42),(63,63,63));
var er,ge,be:integer;
begin
for j:=0 to 16 do
begin
waitretrace;
for i:=12 to 14 do
begin
er:=co2[i,1]-j*4;
if er<0 then er:=0;
ge:=co2[i,2]-j*4;
if ge<0 then ge:=0;
be:=co2[i,3]-j*4;
if be<0 then be:=0;
SetRgbPalette(co1[i],er,ge,be);
end;
end;
end;
{----------------------------------------------------------------------------}
procedure BlackOut;
begin
setRGBpalette(04,00,00,00);       {The RED    grotty palette fixing thingy}
setRGBpalette(06,00,00,00);       {The ORANGE grotty palette fixing thingy}
setRGBpalette(22,00,00,00);       {The YELLOW grotty palette fixing thingy}
setRGBpalette(18,00,00,00);       {The GREEN  grotty palette fixing thingy}
setRGBpalette(19,00,00,00);       {The CYAN   grotty palette fixing thingy}
setRGBpalette(17,00,00,00);       {The L-BLUE grotty palette fixing thingy}
setRGBpalette(21,00,00,00);       {The VIOLET grotty palette fixing thingy}
setRGBpalette(05,00,00,00);       {The PURPLE grotty palette fixing thingy}
setRGBpalette(01,00,00,00);       {The BROWN  grotty palette fixing thingy}
setRGBpalette(03,00,00,00);       {The WOOD   grotty palette fixing thingy}
setRGBpalette(02,00,00,00);       {The BACK   grotty palette fixing thingy}
setRGBpalette(07,00,00,00);       {The GRAY   grotty palette fixing thingy}
setRGBpalette(16,00,00,00);       {The DGRAY  grotty palette fixing thingy}
setRGBpalette(23,00,00,00);       {The WHITE  grotty palette fixing thingy}
end;
{----------------------------------------------------------------------------}
procedure FuckUp;
begin
TextMode(13);
write('Am vaga impresie ca ceva nu chiar corect s-a petrecut ...');
Halt(1);
end;
{----------------------------------------------------------------------------}
procedure StartGFX;
begin
  if RegisterBGIdriver(@EGAVGADriverProc) < 0 then FuckUp;
  if RegisterBGIfont(@GothicFontProc) < 0 then FuckUp;
  if RegisterBGIfont(@SansSerifFontProc) < 0 then FuckUp;
  if RegisterBGIfont(@SmallFontProc) < 0 then FuckUp;
  if RegisterBGIfont(@TriplexFontProc) < 0 then FuckUp;
dee_driv:=VGA;
dee_mode:=VGALo;
initgraph(dee_driv,dee_mode,'');
end;
{----------------------------------------------------------------------------}
procedure Frame(fx1,fy1,fx2,fy2,typ:integer);
begin
if typ=1 then setcolor(15);
if typ=2 then setcolor(8);
line (fx1+0,fy1+0,fx2-2,fy1+0);
line (fx1+0,fy1+0,fx1+0,fy2-1);
line (fx1+1,fy1+0,fx1+1,fy2-1);
if typ=1 then setcolor(8);
if typ=2 then setcolor(15);
line (fx1+2,fy2+0,fx2+0,fy2+0);
line (fx2+0,fy1+1,fx2+0,fy2+0);
line (fx2-1,fy1+1,fx2-1,fy2+0);
end;
{----------------------------------------------------------------------------}
procedure DrawBox(x1,y1,x2,y2,backgrnd:integer;ornaments:boolean);
begin
setfillstyle(1,7);
bar(x1,y1,x2,y2);
frame(x1+00,y1+00,x2-00,y2-00,1);
frame(x1+10,y1+6,x2-10,y2-6,2);

if ornaments=true then
begin
frame(x1+12,y1+02,x2-12,y1+04,2);
frame(x1+03,y2-04,x2-12,y2-02,2);

frame(x1+03,y1+02,x1+07,y1+04,2);
frame(x2-07,y1+02,x2-03,y1+04,2);
frame(x1+03,y2-04,x1+07,y2-02,2);
frame(x2-07,y2-04,x2-03,y2-02,2);

frame(x1+03,y1+07,x1+07,y2-7,2);
frame(x2-07,y1+07,x2-03,y2-7,2);
end;
setfillstyle(1,backgrnd);
bar(x1+12,y1+7,x2-12,y2-7);
end;
{----------------------------------------------------------------------------}
procedure DrawBoxCU(x1,y1,x2,y2,backgrnd:integer);
begin
setfillstyle(1,7);
bar(x1,y1,x2,y2);
frame(x1+00,y1+00,x2-00,y2-00,1);
frame(x1+10,y1+6,x2-10,y2-6,2);

frame(x1+12,y1+02,x2-12,y1+04,2);
frame(x1+12,y2-04,x2-12,y2-02,2);

frame(x1+03,y1+02,x1+07,y1+04,2);
frame(x2-07,y1+02,x2-03,y1+04,2);
frame(x1+03,y2-04,x1+07,y2-02,2);
frame(x2-07,y2-04,x2-03,y2-02,2);

frame(x1+03,y1+07,x1+07,y2-7,2);
frame(x2-07,y1+07,x2-03,y2-7,2);

setfillstyle(1,backgrnd);
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
function Str4(nr:integer):string;
begin
strn1:='';
strn2:='';
str(nr,strn2);
if nr<1000 then strn1:=strn1+'0';
if nr<100 then strn1:=strn1+'0';
if nr<10 then strn1:=strn1+'0';
strn1:=strn1+strn2;
if nr>9999 then strn1:='????';
Str4:=strn1;
end;
{----------------------------------------------------------------------------}
function Str2(nr:integer):string;
begin
strn1:='';
strn2:='';
str(nr,strn2);
if nr<10 then strn1:=strn1+'0';
strn1:=strn1+strn2;
Str2:=strn1;
end;
{----------------------------------------------------------------------------}
procedure Wtxt(txx,txy:integer;what:string;col:byte);
begin
settextstyle(0,0,0);
settextjustify(1,1);
if col=1 then setcolor(8);
if col=2 then setcolor(0);
if col=3 then setcolor(10);
if col=4 then setcolor(8);
outtextxy(txx+1,txy+1,what);
if col=1 then setcolor(15);
if col=2 then setcolor(4);
if col=3 then setcolor(11);
if col=4 then setcolor(7);
outtextxy(txx+0,txy+0,what);
end;
{----------------------------------------------------------------------------}
procedure DrawScr2;
begin
Wtxt(320,25,'S i s t e m   s o l a r',3);
Wtxt(320,74,'Simulator al miscarii de revolutie a planetelor',1);
Wtxt(320,89,'Programat in Borland Pascal 7 de Dinu Cristian Mircea',1);
end;
{----------------------------------------------------------------------------}
procedure DrawScr3;
begin
Wtxt(320,25,'S i s t e m   s o l a r',3);
Wtxt(320, 52,'Acest program simuleaza numai rotatia planetelor in jurul soarelui.',1);
Wtxt(320, 67,'Distantele fata de Soare, marimile planetelor si inclinarea orbitelor',1);
Wtxt(320, 82,'NU sunt simulate. De asemenea, precizia programului nu este exceptionala,',1);
Wtxt(320, 97,'asa ca nu veti putea prevede cu acest program o aliniere a planetelor',1);
Wtxt(320,112,'sau alte coincidente astrale.',1);
Wtxt(320,142,'Apasati o tasta pentru a continua.',3);
end;
{----------------------------------------------------------------------------}
procedure DrawScr4;
begin
Wtxt(320,25,'S i s t e m   s o l a r',3);
Wtxt(320, 52,'Datele despre revolutia planetelor si excentricitatile orbitelor au',1);
Wtxt(320, 67,'fost luate dintr-o carte din 1985. Cum noi descoperiri se fac in',1);
Wtxt(320, 82,'fiecare an, ele s-ar putea sa nu mai fie valabile astazi.',1);
Wtxt(320, 97,'Pozitia intiala a planetelor nu-mi este cunoscuta, asa ca veti avea',1);
Wtxt(320,112,'de ales intre o dispunere liniara, spirala sau aleatorie.',1);
Wtxt(320,142,'Apasati o tasta pentru a continua.',3);
end;
{----------------------------------------------------------------------------}
procedure DrawScr5;
begin
Wtxt(320,25,'S i s t e m   s o l a r',3);
Wtxt(320, 52,'In timpul simularii, puteti schimba viteza cu tastele plus si minus.',1);
Wtxt(320, 67,'Atentie insa: la viteze mai mari, planetele rapide si Luna vor parea',1);
Wtxt(320, 82,'ca merg incet sau chiar retrograd. Cu tastele Enter, * si / puteti',1);
Wtxt(320, 97,'"sari" in timp cu o zi, 10 ani sau 100 de ani, cu L puteti suprima',1);
Wtxt(320,112,'afisarea Lunii, iar cu tasta R puteti opri miscarea planetelor.',1);
Wtxt(320,142,'Apasati o tasta pentru a continua.',3);
end;
{----------------------------------------------------------------------------}
procedure DrawScr7;
begin
Wtxt(320,25,'S i s t e m   s o l a r',3);
Wtxt(320, 67,'Alege dispunerea initiala a planetelor:',1);
Wtxt(320, 82,'1 - Liniara / 2 - Spirala (rasucire 5%) / 3 - Spirala (rasucire 15%)',1);
Wtxt(320, 97,'4 - Antispirala (rasucire 15%) / 5 - Aleatorie',1);
end;
{----------------------------------------------------------------------------}
procedure DrawScr9;
begin
Wtxt(320,25,'S i s t e m   s o l a r',3);
Wtxt(320, 52,'Cu tastele I si A puteti accelera simularea pana la alinierea planetelor',1);
Wtxt(320, 67,'interioare, respectiv alinierea totala. Atentie insa, alinierea este',1);
Wtxt(320, 82,'aproximativa si gasirea alinierii totale poate dura extrem de mult. Cu',1);
Wtxt(320, 97,'tasta T puteti accelera gasirea alinierii totale de 4 ori, dar exista',1);
Wtxt(320,112,'o mica sansa ca sa ratati unele alinierei datorita scaderii rezolutiei.',1);
Wtxt(320,142,'Apasati o tasta pentru a continua.',3);
end;
{----------------------------------------------------------------------------}
procedure DrawScr6;
begin
Wtxt(320,25,'S i s t e m   s o l a r',3);
end;
{----------------------------------------------------------------------------}
procedure DrawScr10;
begin
Wtxt(320,25,'S i s t e m   s o l a r',3);
Wtxt(320,82,'Inca o simulare ? (Da/Nu)',1);
end;
{----------------------------------------------------------------------------}
procedure DrawScr8;
begin
Wtxt(320,25,'S i s t e m   s o l a r',3);
Wtxt(320,142,'Apasati o tasta pentru a continua.',3);
end;
{----------------------------------------------------------------------------}
procedure DrawSys;
const OrbitExc:array[1..9] of real=(1.5217,1.0130,1.034,1.202,1.1012,1.1177,
                                    1.097,1.018,1.669);
      DistModf:array[1..9] of integer=(-3,-2,-2,-3,2,3,4,9,-1);
type globepattern=array[1..17] of byte;
     bigglobepattern=array[1..37] of byte;
var z:integer;
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
procedure PutGlobe(wx,wy:integer;patrn:Globepattern);
begin
putpixel(wx-2,wy-1,patrn[01]);
putpixel(wx-1,wy-1,patrn[02]);
putpixel(wx+0,wy-1,patrn[03]);
putpixel(wx+1,wy-1,patrn[04]);
putpixel(wx+2,wy-1,patrn[05]);
putpixel(wx-3,wy+0,patrn[06]);
putpixel(wx-2,wy+0,patrn[07]);
putpixel(wx-1,wy+0,patrn[08]);
putpixel(wx+0,wy+0,patrn[09]);
putpixel(wx+1,wy+0,patrn[10]);
putpixel(wx+2,wy+0,patrn[11]);
putpixel(wx+3,wy+0,patrn[12]);
putpixel(wx-2,wy+1,patrn[13]);
putpixel(wx-1,wy+1,patrn[14]);
putpixel(wx+0,wy+1,patrn[15]);
putpixel(wx+1,wy+1,patrn[16]);
putpixel(wx+2,wy+1,patrn[17]);
end;
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
procedure PutBigGlobe(wx,wy:integer;patrn:BigGlobepattern);
begin
putpixel(wx-2,wy-2,patrn[01]);
putpixel(wx-1,wy-2,patrn[02]);
putpixel(wx+0,wy-2,patrn[03]);
putpixel(wx+1,wy-2,patrn[04]);
putpixel(wx+2,wy-2,patrn[05]);
putpixel(wx-4,wy-1,patrn[06]);
putpixel(wx-3,wy-1,patrn[07]);
putpixel(wx-2,wy-1,patrn[08]);
putpixel(wx-1,wy-1,patrn[09]);
putpixel(wx+0,wy-1,patrn[10]);
putpixel(wx+1,wy-1,patrn[11]);
putpixel(wx+2,wy-1,patrn[12]);
putpixel(wx+3,wy-1,patrn[13]);
putpixel(wx+4,wy-1,patrn[14]);
putpixel(wx-4,wy+0,patrn[15]);
putpixel(wx-3,wy+0,patrn[16]);
putpixel(wx-2,wy+0,patrn[17]);
putpixel(wx-1,wy+0,patrn[18]);
putpixel(wx+0,wy+0,patrn[19]);
putpixel(wx+1,wy+0,patrn[20]);
putpixel(wx+2,wy+0,patrn[21]);
putpixel(wx+3,wy+0,patrn[22]);
putpixel(wx+4,wy+0,patrn[23]);
putpixel(wx-4,wy+1,patrn[24]);
putpixel(wx-3,wy+1,patrn[25]);
putpixel(wx-2,wy+1,patrn[26]);
putpixel(wx-1,wy+1,patrn[27]);
putpixel(wx+0,wy+1,patrn[28]);
putpixel(wx+1,wy+1,patrn[29]);
putpixel(wx+2,wy+1,patrn[30]);
putpixel(wx+3,wy+1,patrn[31]);
putpixel(wx+4,wy+1,patrn[32]);
putpixel(wx-2,wy+2,patrn[33]);
putpixel(wx-1,wy+2,patrn[34]);
putpixel(wx+0,wy+2,patrn[35]);
putpixel(wx+1,wy+2,patrn[36]);
putpixel(wx+2,wy+2,patrn[37]);
end;
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
procedure PutPlanet(which:byte;orbitpercent:real);
const m=pi/50;
      venus:globepattern=(   02,03,03,02,02,
                          03,03,03,03,03,02,02,
                             02,03,03,02,02);
      earth:globepattern=(   01,01,03,02,02,
                          01,03,03,01,03,01,01,
                             01,03,01,01,02);
      mars: globepattern=(   04,14,04,14,14,
                          04,14,04,14,04,14,14,
                             04,14,14,14,14);
      jupiter: bigglobepattern=(   09,06,06,06,06,
                             06,09,09,06,06,09,09,06,06,
                             07,06,14,14,09,07,07,09,07,
                             09,09,06,06,06,06,09,06,06,
                                   09,09,06,09,06);
      sun:    bigglobepattern=(    15,15,15,15,15,
                             15,15,15,15,15,15,15,15,15,
                             15,15,15,15,15,15,15,15,15,
                             15,15,15,15,15,15,15,15,15,
                                   15,15,15,15,15);
      saturn:  bigglobepattern=(   09,06,06,06,02,
                             06,09,09,06,06,09,09,06,06,
                             07,15,07,15,07,07,15,07,07,
                             09,09,06,06,06,06,09,06,06,
                                   09,06,09,06,02);
      uranus:globepattern=(   13,02,13,13,13,
                           02,02,02,13,02,13,13,
                              13,02,13,13,13);
      neptune:globepattern=(  10,01,01,01,10,
                           01,01,01,01,01,10,10,
                              10,01,01,01,10);
var x,y,z:integer;
begin
x:=320+round(sin(orbitpercent*m)*(round(which*16*orbitexc[which])+(distmodf[which]*2)));
y:=82+round(cos(orbitpercent*m)*((which*8)+distmodf[which]));
if which=1 then
begin
putpixel(x,y,12);
putpixel(x+1,y,6);
end;
if which=2 then
begin
PutGlobe(x,y,venus);
end;
if which=3 then
begin
PutGlobe(x,y,earth);
end;
if which=4 then
begin
PutGlobe(x,y,mars);
end;
if which=5 then
begin
PutBigGlobe(x,y,jupiter);
end;
if which=6 then
begin
PutBigGlobe(x,y,saturn);
putpixel(x-5,y,7);
putpixel(x-6,y,7);
putpixel(x-7,y,8);
putpixel(x-8,y,7);
putpixel(x+5,y,7);
putpixel(x+6,y,7);
putpixel(x+7,y,8);
putpixel(x+8,y,7);
end;
if which=7 then
begin
PutGlobe(x,y,uranus);
putpixel(x,y-2,8);
putpixel(x,y+2,8);
end;
if which=8 then
begin
PutGlobe(x,y,neptune);
end;
if which=9 then
begin
putpixel(x,y,7);
putpixel(x+1,y,7);
PutBigGlobe(320,82,sun);
end;
end;
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
procedure DrawMoon;
const m=pi/50;
      pl1=3;
var x1,y1,x2,y2,dist,shfactor:integer;
    dfactor:real;
    cansee:integer;
begin
x1:=320+round(sin(planpos[pl1]*m)*(round(pl1*16*orbitexc[pl1])+(distmodf[pl1]*2)));
y1:=82+round(cos(planpos[pl1]*m)*((pl1*8)+distmodf[pl1]));
x2:=x1+round(sin(lunarpos*m)*8);
y2:=y1+round(cos(lunarpos*m)*4);
setcolor(5);
Ellipse(x1,y1,0,360,8,4);
putpixel(x2,y2,7);
putpixel(x2+1,y2,7);
end;
begin
setcolor(5);
for i:=1 to 9 do
begin
Ellipse(320,82,0,360,round(i*16*orbitexc[i])+(distmodf[i]*2),(i*8)+distmodf[i]);
end;
for i:=1 to 9 do
begin
Putplanet(i,planpos[i]);
end;
if showmoon=1 then DrawMoon;
end;
{----------------------------------------------------------------------------}
procedure DrawScreen;
begin
if mainscr=1 then DrawBox(0,0,639,164,0,true)
             else DrawBox(0,0,639,164,0,true);
DrawBoxCu(0,158,639,190,0);
if mainscr=1 then begin
                  DrawSys;
                  if blank=1 then Wtxt(320,41,'Mileniul '+str4(mill)+', anul '+str4(yr)+', ziua '+str3(day),1);
                  if blank=2 then Wtxt(320,41,'Mileniul '+str4(mill)+', anul '+str4(yr)+', ziua '+str3(day),1);
                  if blank=2 then Wtxt(320,123,'Aliniere aproximativa',1);
                  end;
if mainscr=2 then DrawScr2;
if mainscr=3 then DrawScr3;
if mainscr=4 then DrawScr4;
if mainscr=5 then DrawScr5;
if mainscr=6 then DrawScr7;
if mainscr=7 then DrawScr9;
if mainscr=8 then DrawScr10;
if mainscr=10 then DrawScr6;
if mainscr=12 then DrawScr8;
Wtxt(320,174,botmes,bmesc);
end;
{----------------------------------------------------------------------------}
procedure DrawIt;
begin
waitretrace;
DrawScreen;
setvisualpage(cpage);
setactivepage(1-cpage);
cpage:=1-cpage;
end;
{----------------------------------------------------------------------------}
procedure ShowScr(scre:integer);
begin
mainscr:=scre;
DrawIt;
if scre<10 then Pop
           else UnPop;
if scre<>1 then delay(160);
end;
{----------------------------------------------------------------------------}
procedure Present;
begin
botmes:='';
ShowScr(11);
FadeIn;
ShowScr(2);
delay(3000);
ShowScr(10);
end;
{----------------------------------------------------------------------------}
procedure InitGame;
begin
mainscr:=1;
zend:=false;
botmes:='';
DrawIt;
Pop;
end;
{----------------------------------------------------------------------------}
procedure Cls;
begin
botmes:='';
ShowScr(11);
end;
{----------------------------------------------------------------------------}
procedure RunSim;
var
    done,algn:boolean;
    tempd:real;
    cmt:integer;
    dlim:integer;
    spf:integer;
label bumbi;
begin
rotate:=1;
showmoon:=1;
lunarpos:=0;
spf:=0;
cmt:=0;
mill:=1;
day:=1;
yr:=1;
done:=false;
mfactor:=1;
bmesc:=1;
for i:=1 to 9 do
begin
if plac=2 then spf:=spf+95;
if plac=3 then spf:=spf+85;
if plac=4 then spf:=spf+15;
if plac=1 then planpos[i]:=25;
if plac=2 then planpos[i]:=spf mod 100;
if plac=3 then planpos[i]:=spf mod 100;
if plac=4 then planpos[i]:=spf mod 100;
if plac=5 then planpos[i]:=random(100);
end;
for i:=1 to 9 do rfactor[i]:=100/revtime[i];
lrfactor:=100/lunarev;
botmes:='Mileniul 001, anul 0001, ziua 001';
ShowScr(1);
DoneBeep;
delay(2000);
while not done do
begin
if cmt>0 then dec(cmt);
if cmt=0 then botmes:='Mileniul '+str4(mill)+', anul '+str4(yr)+', ziua '+str3(day);
if rotate=1 then
begin
day:=day+mfactor;
if (yr mod 4)=0 then dlim:=366
                else dlim:=365;
if day>dlim then begin day:=day-dlim; inc(yr); end;
if yr>1000 then begin yr:=1; inc(mill); end;
for i:=1 to 9 do
begin
planpos[i]:=planpos[i]+rfactor[i]*mfactor;
if planpos[i]>=100 then planpos[i]:=planpos[i]-100;
end;
lunarpos:=lunarpos+(lrfactor*mfactor);
while (lunarpos>=100) do lunarpos:=lunarpos-100;
end;
DrawIt;
char1:='X';
if keypressed then char1:=readkey;
if char1=chr(13) then
begin
KeyBeep;
day:=day+mfactor;
if (yr mod 4)=0 then dlim:=366
                else dlim:=365;
if day>dlim then begin day:=day-dlim; inc(yr); end;
if yr>1000 then begin yr:=1; inc(mill); end;
for i:=1 to 9 do
begin
planpos[i]:=planpos[i]+rfactor[i]*mfactor;
if planpos[i]>=100 then planpos[i]:=planpos[i]-100;
end;
lunarpos:=lunarpos+(lrfactor*mfactor);
while (lunarpos>=100) do lunarpos:=lunarpos-100;
end;
if char1='*' then
begin
KeyBeep;
for k:=1 to 365 do
begin
day:=day+1;
if (yr mod 4)=0 then dlim:=366
                else dlim:=365;
if day>dlim then begin day:=day-dlim; inc(yr); end;
if yr>1000 then begin yr:=1; inc(mill); end;
for i:=1 to 9 do
begin
planpos[i]:=planpos[i]+rfactor[i]*1;
if planpos[i]>=100 then planpos[i]:=planpos[i]-100;
end;
lunarpos:=lunarpos+(lrfactor);
while (lunarpos>=100) do lunarpos:=lunarpos-100;
end;
cmt:=20;
botmes:='Salt inainte 1 an';
end;
if char1='/' then
begin
KeyBeep;
for k:=1 to 3652 do
begin
day:=day+1;
if (yr mod 4)=0 then dlim:=366
                else dlim:=365;
if day>dlim then begin day:=day-dlim; inc(yr); end;
if yr>1000 then begin yr:=1; inc(mill); end;
for i:=1 to 9 do
begin
planpos[i]:=planpos[i]+rfactor[i]*1;
if planpos[i]>=100 then planpos[i]:=planpos[i]-100;
end;
lunarpos:=lunarpos+(lrfactor);
while (lunarpos>=100) do lunarpos:=lunarpos-100;
end;
cmt:=20;
botmes:='Salt inainte 10 ani';
end;
{}
if char1='i' then
begin
KeyBeep;
botmes:='Rulez pana la alinierea planetelor interioare ...';
DrawIt;
algn:=false;
while not algn do
begin
if keypressed then char1:=readkey;
if char1=chr(27) then
begin
KeyBeep;
goto bumbi;
end;
day:=day+2;
if (yr mod 4)=0 then dlim:=366
                else dlim:=365;
if day>dlim then begin day:=day-dlim; inc(yr); end;
if yr>1000 then begin yr:=1; inc(mill); end;
tempd:=0;
for i:=1 to 9 do
begin
planpos[i]:=planpos[i]+rfactor[i]*2;
if planpos[i]>=100 then planpos[i]:=planpos[i]-100;
if i<5 then tempd:=tempd+abs(planpos[i]-planpos[1]);
end;
lunarpos:=lunarpos+(lrfactor*2);
while (lunarpos>=100) do lunarpos:=lunarpos-100;
if tempd<0.75 then algn:=true;
if tempd<2 then
begin
blank:=2;
DrawIt;
blank:=0;
end;
end;
botmes:='Aliniere interioara';
blank:=1;
DrawIt;
DoneBeep;
delay(3000);
bmesc:=3;
botmes:='Apasa o tasta pentru a continua.';
DrawIt;
blank:=0;
readkey;
bmesc:=1;
end;
if char1='a' then
begin
KeyBeep;
botmes:='Rulez pana la alinierea primelor 7 planete ... (mare rabdare !)';
DrawIt;
algn:=false;
while not algn do
begin
if keypressed then char1:=readkey;
if char1=chr(27) then
begin
KeyBeep;
goto bumbi;
end;
day:=day+2;
if (yr mod 4)=0 then dlim:=366
                else dlim:=365;
if day>dlim then begin day:=day-dlim; inc(yr); end;
if yr>1000 then begin yr:=1; inc(mill); end;
tempd:=0;
for i:=1 to 9 do
begin
planpos[i]:=planpos[i]+rfactor[i]*2;
if planpos[i]>=100 then planpos[i]:=planpos[i]-100;
if i<8 then tempd:=tempd+abs(planpos[i]-planpos[1]);
end;
lunarpos:=lunarpos+(lrfactor*2);
while (lunarpos>=100) do lunarpos:=lunarpos-100;
if tempd<2 then algn:=true;
if tempd<16 then
begin
blank:=2;
DrawIt;
blank:=0;
end;
end;
botmes:='Planete aliniate !';
blank:=1;
DrawIt;
DoneBeep;
delay(3000);
bmesc:=3;
botmes:='Apasa o tasta pentru a continua.';
DrawIt;
blank:=0;
readkey;
bmesc:=1;
end;
if char1='t' then
begin
KeyBeep;
botmes:='Rulez pana la alinierea primelor 7 planete ...  (viteza x4)';
DrawIt;
algn:=false;
while not algn do
begin
if keypressed then char1:=readkey;
if char1=chr(27) then
begin
KeyBeep;
goto bumbi;
end;
day:=day+8;
if (yr mod 4)=0 then dlim:=366
                else dlim:=365;
if day>dlim then begin day:=day-dlim; inc(yr); end;
if yr>1000 then begin yr:=1; inc(mill); end;
tempd:=0;
for i:=1 to 9 do
begin
planpos[i]:=planpos[i]+rfactor[i]*8;
if planpos[i]>=100 then planpos[i]:=planpos[i]-100;
if i<8 then tempd:=tempd+abs(planpos[i]-planpos[1]);
end;
lunarpos:=lunarpos+(lrfactor*8);
while (lunarpos>=100) do lunarpos:=lunarpos-100;
if tempd<2 then algn:=true;
if tempd<16 then
begin
blank:=2;
DrawIt;
blank:=0;
end;
end;
botmes:='Planete aliniate !';
blank:=1;
DrawIt;
DoneBeep;
delay(3000);
bmesc:=3;
botmes:='Apasa o tasta pentru a continua.';
DrawIt;
blank:=0;
readkey;
bmesc:=1;
end;
if char1='l' then
begin
KeyBeep;
showmoon:=1-showmoon;
cmt:=20;
if showmoon=0 then botmes:='Afisarea Lunii dezactivata';
if showmoon=1 then botmes:='Afisarea Lunii activata';
end;
if char1='r' then
begin
KeyBeep;
rotate:=1-rotate;
cmt:=20;
if rotate=0 then botmes:='Rotatia planetelor dezactivata';
if rotate=1 then botmes:='Rotatia planetelor activata';
end;
if char1='+' then
begin
KeyBeep;
if mfactor<361 then mfactor:=mfactor+5;
cmt:=20;
botmes:='Viteza: '+str3(mfactor)+' zile/cadru';
end;
if char1='-' then
begin
KeyBeep;
if mfactor>1 then mfactor:=mfactor-5;
cmt:=20;
botmes:='Viteza: '+str3(mfactor)+' zile/cadru';
end;
if char1=chr(27) then
begin
KeyBeep;
done:=true;
end;
end;
bumbi:
end;
{----------------------------------------------------------------------------}
function QueryYN:boolean;
var res:boolean;
label la0;
begin
la0:
char1:=upcase(readkey);
if (char1<>'D') and (char1<>'N') then goto la0;
KeyBeep;
res:=false;
if char1='D' then res:=true;
QueryYN:=res;
end;
{----------------------------------------------------------------------------}
procedure QueryPlacement;
label lab0;
begin
ShowScr(6);
lab0:
char1:=readkey;
byte1:=ord(char1);
if (byte1>48) and (byte1<54) then plac:=byte1-48
                             else goto lab0;
KeyBeep;
end;
{----------------------------------------------------------------------------}
function QueryAgain:boolean;
begin
ShowScr(8);
QueryAgain:=QueryYN;
end;
{----------------------------------------------------------------------------}
(*                                  MAIN                                    *)
{----------------------------------------------------------------------------}
label lab0;
begin
cpage:=0;
blank:=0;
sounds:=true;
if (paramcount>0) then
begin
if pos('/s',paramstr(1))<>0 then sounds:=false;
if (pos('/?',paramstr(1))<>0) or (pos('/h',paramstr(1))<>0) then
begin
clrscr;
writeln('Sistem solar - programat de Dinu Cristian Mircea');
writeln('Parametrii: /? sau /h - ajutor');
writeln('            /s - fara sunet');
halt;
end;
end;
highl:=0;
LeaveDos;
StartGFX;
BlackOut;
Present;
ShowScr(3);
readkey;
ShowScr(12);
ShowScr(4);
readkey;
ShowScr(12);
ShowScr(5);
readkey;
ShowScr(12);
ShowScr(7);
readkey;
lab0:
ShowScr(10);
QueryPlacement;
cls;
RunSim;
Cls;
If QueryAgain=true then goto lab0;
Cls;
FadeOut;
closegraph;
end.


