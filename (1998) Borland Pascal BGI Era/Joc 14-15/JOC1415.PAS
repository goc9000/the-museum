uses graph,crt,dos,bgidriv,bgifont;
const Checkerfill : FillPatternType = ($AA, $55, $AA, $55, $AA, $55, $AA, $55);
var dee_mode,dee_driv:integer;
    cpage:byte;
    sounds:boolean;
    quit:boolean;
    fuzz:integer;
    movenr:integer;
    emx,emy:integer;
    error:integer;
    prevrnd:integer;
    botmes:string;
    bmesc:byte;
    highl:integer;
    blk,blx,bly:integer;
    mainscr:integer;
    zend:boolean;
    table:array[1..4,1..4] of byte;
    cmx,cmy:integer;
    {All-purpose}
    strn1:string;
    strn2:string;
    bool1:boolean;
    char1:char;
    byte1:byte;
    i,j,k:integer;
    BlackPType,WhitePType:byte;
procedure DoMove(piece:integer);forward;
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
procedure QDUPDATE;
begin
setvisualpage(cpage);
setactivepage(1-cpage);
cpage:=1-cpage;
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
      co2:array[1..14,1..3] of byte=((63,0,0),{mid}(40,20,0),{h/sh} (34,14,0),(6,0,63),(0,57,63),
                            {shadow} (28,8,0),{h/hi}(46,26,0),{hilite} (52,32,0),(48,24,0),(48,24,0),
                                     (55,55,55),(24,24,24),(42,42,42),(63,63,63));
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
      co2:array[1..14,1..3] of byte=((63,0,0),(40,20,0),(63,63,0),(6,0,63),(0,57,63),
                            {shadow} (16,8,0),(55,0,60),{hilite} (63,32,0),(48,24,0),(48,24,0),
                                     (55,55,55),(24,24,24),(42,42,42),(63,63,63));
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
procedure WoodFrame(fx1,fy1,fx2,fy2,typ:integer);
begin
if typ=1 then setcolor(5);   {15}
if typ=2 then setcolor(9);     {8}
line (fx1+0,fy1+0,fx2-2,fy1+0);
line (fx1+0,fy1+0,fx1+0,fy2-1);
line (fx1+1,fy1+0,fx1+1,fy2-1);
if typ=1 then setcolor(9);
if typ=2 then setcolor(5);
line (fx1+2,fy2+0,fx2+0,fy2+0);
line (fx2+0,fy1+1,fx2+0,fy2+0);
line (fx2-1,fy1+1,fx2-1,fy2+0);
end;
{----------------------------------------------------------------------------}
procedure DotWoodFrame(fx1,fy1,fx2,fy2,typ:integer);
begin
if typ=1 then setcolor(13);
if typ=2 then setcolor(14);
line (fx1+0,fy1+0,fx2-2,fy1+0);
line (fx1+0,fy1+0,fx1+0,fy2-1);
line (fx1+1,fy1+0,fx1+1,fy2-1);
if typ=1 then setcolor(14);
if typ=2 then setcolor(13);
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
procedure DrawWoodBox(x1,y1,x2,y2,backgrnd:integer;ornaments:boolean);
begin
setfillstyle(1,6);
bar(x1,y1,x2,y2);
Woodframe(x1+00,y1+00,x2-00,y2-00,1);
Woodframe(x1+10,y1+6,x2-10,y2-6,2);
DotWoodframe(x1+02,y1+01,x2-02,y2-01,1);
DotWoodframe(x1+8,y1+5,x2-8,y2-5,2);

if ornaments=true then
begin
Woodframe(x1+12,y1+02,x2-12,y1+04,2);
Woodframe(x1+03,y2-04,x2-12,y2-02,2);

Woodframe(x1+03,y1+02,x1+07,y1+04,2);
Woodframe(x2-07,y1+02,x2-03,y1+04,2);
Woodframe(x1+03,y2-04,x1+07,y2-02,2);
Woodframe(x2-07,y2-04,x2-03,y2-02,2);

Woodframe(x1+03,y1+07,x1+07,y2-7,2);
Woodframe(x2-07,y1+07,x2-03,y2-7,2);
end;
setfillstyle(1,backgrnd);
bar(x1+12,y1+7,x2-12,y2-7);
end;
{----------------------------------------------------------------------------}
procedure DrawWoodBlock(x1,y1,x2,y2,backgrnd:integer;ornaments:boolean);
begin
setfillstyle(1,6);
bar(x1,y1,x2,y2);
Woodframe(x1+00,y1+00,x2-00,y2-00,1);
if ornaments=true then
begin
Woodframe(x1+12,y1+02,x2-12,y1+04,2);
Woodframe(x1+03,y2-04,x2-12,y2-02,2);

Woodframe(x1+03,y1+02,x1+07,y1+04,2);
Woodframe(x2-07,y1+02,x2-03,y1+04,2);
Woodframe(x1+03,y2-04,x1+07,y2-02,2);
Woodframe(x2-07,y2-04,x2-03,y2-02,2);

Woodframe(x1+03,y1+07,x1+07,y2-7,2);
Woodframe(x2-07,y1+07,x2-03,y2-7,2);
end;
end;
{----------------------------------------------------------------------------}
procedure DrawBlock(x1,y1,x2,y2,backgrnd:integer;ornaments:boolean);
begin
setfillstyle(1,6);
bar(x1,y1,x2,y2);
setfillstyle(1,7);
bar(x1+7,y1+3,x2-7,y2-3);
WoodFrame(x1+00,y1+00,x2-00,y2-00,1);
WoodFrame(x1+05,y1+02,x2-05,y2-02,2);
Frame(x1+07,y1+03,x2-07,y2-03,1);
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
function StrS(nr:integer):string;
begin
strn1:='';
strn2:='';
str(nr,strn2);
strn1:=strn1+strn2;
StrS:=strn1;
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
if col=4 then setcolor(15);
outtextxy(txx+1,txy+1,what);
if col=1 then setcolor(15);
if col=2 then setcolor(4);
if col=3 then setcolor(11);
if col=4 then setcolor(8);
outtextxy(txx+0,txy+0,what);
end;
{----------------------------------------------------------------------------}
procedure DrawScr2;
begin
Wtxt(320,25,'J o c u l   1 4 - 1 5',3);
Wtxt(320,67,'Joc solitar de logica',1);
Wtxt(320,82,'Inventat de Sam Lloyd',1);
Wtxt(320,97,'Programat in Borland Pascal 7 de Dinu Cristian Mircea',1);
end;
{----------------------------------------------------------------------------}
procedure DrawScr3;
begin
Wtxt(320,25,'J o c u l   1 4 - 1 5',3);
Wtxt(320,82,'Introdu numarul de jucatori umani (0-2)',1);
end;
{----------------------------------------------------------------------------}
procedure DrawScr4;
begin
Wtxt(320,25,'R e v e r s i',3);
Wtxt(320,82,'Joci Alb sau Negru ? (A/N)',1);
end;
{----------------------------------------------------------------------------}
procedure DrawScr5;
begin
Wtxt(320,25,'J o c u l   1 4 - 1 5',3);
Wtxt(320,82,'Inca un joc ? (Da/Nu)',1);
end;
{----------------------------------------------------------------------------}
procedure DrawScr7;
begin
Wtxt(320,25,'J o c u l   1 4 - 1 5',3);
Wtxt(320,82,'Introdu gradul de amestecare (1 = minim - 9 = maxim)',1);
end;
{----------------------------------------------------------------------------}
procedure DrawScr6;
begin
Wtxt(320,25,'J o c u l   1 4 - 1 5',3);
end;
{----------------------------------------------------------------------------}
function LeftOfSp:integer;
var res:integer;
begin
if emx=1 then res:=0
         else res:=table[emx-1,emy];
LeftOfSp:=res;
end;
{----------------------------------------------------------------------------}
function RightOfSp:integer;
var res:integer;
begin
if emx=4 then res:=0
         else res:=table[emx+1,emy];
RightOfSp:=res;
end;
{----------------------------------------------------------------------------}
function TopOfSp:integer;
var res:integer;
begin
if emy=1 then res:=0
         else res:=table[emx,emy-1];
TopOfSp:=res;
end;
{----------------------------------------------------------------------------}
function BotOfSp:integer;
var res:integer;
begin
if emy=4 then res:=0
         else res:=table[emx,emy+1];
BotOfSp:=res;
end;
{----------------------------------------------------------------------------}
function RandomMove:integer;
var rez:integer;
    cho:integer;
begin
rez:=0;
while(rez=0) do
begin
cho:=random(4);
if cho=0 then rez:=LeftOfSp;
if cho=1 then rez:=RightOfSp;
if cho=2 then rez:=TopOfSp;
if cho=3 then rez:=BotOfSp;
end;
RandomMove:=rez;
end;
{----------------------------------------------------------------------------}
procedure DrawTable;
const sqsize=32;
      xoffs=152;
      left=1;
      right=2;
      up=3;
      down=4;
var tmpx,tmpy:integer;
procedure Arrow(arrx,arry,ardir:integer);
procedure ArrowCol(ax,ay,dir,col:integer);
begin
setcolor(col);
if dir=right then
begin
Line(ax-10,ay,ax+10,ay);
Line(ax+10,ay,ax+2,ay-4);
Line(ax+9,ay,ax+2,ay+4);
end;
if dir=down then
begin
Line(ax,ay-5,ax,ay+5);
Line(ax+1,ay-5,ax+1,ay+5);
Line(ax-9,ay+1,ax,ay+5);
Line(ax+9,ay+1,ax,ay+5);
end;
if dir=left then
begin
Line(ax-10,ay,ax+10,ay);
Line(ax-10,ay,ax-2,ay-4);
Line(ax-9,ay,ax-2,ay+4);
end;
if dir=up then
begin
Line(ax,ay-5,ax,ay+5);
Line(ax+1,ay-5,ax+1,ay+5);
Line(ax-9,ay-1,ax,ay-5);
Line(ax+9,ay-1,ax,ay-5);
end;
end;
begin
ArrowCol(arrx+1,arry+1,ardir,8);
ArrowCol(arrx,arry,ardir,15);
end;
begin
setfillstyle(1,3);
DrawWoodBox(12+xoffs,11,307+xoffs,152,6,false);
for i:=1 to 4 do
begin
for j:=1 to 4 do
begin
tmpx:=xoffs+12+12+((i-1)*((sqsize*2)+4));
tmpy:=11+7+((j-1)*sqsize);
if table[i,j]>0 then DrawBlock(tmpx,tmpy,tmpx+3+(sqsize*2),tmpy+sqsize-1,2,false);
if table[i,j]>0 then Wtxt(tmpx+sqsize+1,tmpy+(sqsize div 2),strS(table[i,j]),4);
if table[i,j]=0 then begin emx:=i;emy:=j;end;
end;
end;
if highl=1 then
begin
tmpx:=xoffs+12+12+((emx-1)*((sqsize*2)+4));
tmpy:=11+7+((emy-1)*sqsize);
setcolor(15);
if emx>1 then Arrow(tmpx,tmpy+(sqsize div 2)-1,right);
if emy>1 then Arrow(tmpx+sqsize,tmpy,down);
if emx<4 then Arrow(tmpx+(sqsize*2)+1,tmpy+(sqsize div 2)-1,left);
if emy<4 then Arrow(tmpx+sqsize-1,tmpy+sqsize-1,up);
end;
if blk>0 then
begin
DrawBlock(blx,bly,blx+3+(sqsize*2),bly+sqsize-1,2,false);
Wtxt(blx+sqsize+1,bly+(sqsize div 2),strS(blk),4);
end;
end;
{----------------------------------------------------------------------------}
procedure DrawScreen;
begin
if mainscr=1 then DrawBox(0,0,639,164,0,true)
             else DrawBox(0,0,639,164,0,true);
DrawBoxCu(0,158,639,190,0);
if mainscr=1 then begin DrawTable; end;
if mainscr=2 then DrawScr2;
if mainscr=3 then DrawScr3;
if mainscr=4 then DrawScr4;
if mainscr=5 then DrawScr5;
if mainscr=6 then DrawScr7;
if mainscr=10 then DrawScr6;
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
procedure QueryFuzz;
label lab0;
begin
ShowScr(6);
lab0:
char1:=readkey;
byte1:=ord(char1);
if (byte1>48) and (byte1<58) then fuzz:=5+((byte1-48)*5)
                             else goto lab0;
KeyBeep;
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
procedure GetPlayerMove;
var crsx,crsy:integer;
    done:boolean;
    t_bmesc:byte;
    t_botmes:string;
    finalmv:integer;
label exitgp;
begin
highl:=1;
botmes:='Mutarea #'+str3(movenr);
DrawIt;
finalmv:=0;
while(finalmv=0) do
begin
char1:=readkey;
KeyBeep;
if char1=chr(72) then finalmv:=BotOfsp;
if char1=chr(80) then finalmv:=TopOfsp;
if char1=chr(75) then finalmv:=RightOfsp;
if char1=chr(77) then finalmv:=LeftOfsp;
if char1=chr(27) then begin quit:=true; goto exitgp; end;
end;
highl:=0;
DoMove(finalmv);
highl:=0;
inc(movenr);
if movenr>999 then movenr:=999;
exitgp:
end;
{----------------------------------------------------------------------------}
procedure Init;
begin
for i:=1 to 4 do for j:=1 to 4 do table[i,j]:=(((j-1)*4)+i) mod 16;
end;
{----------------------------------------------------------------------------}
procedure DoMove(piece:integer);
var pcx,pcy,px,py:integer;
    oremx,oremy:integer;
    x1,x2,y1,y2:integer;
    dx,dy:integer;
const sqsize=32;
      xoffs=152;
begin
for i:=1 to 4 do for j:=1 to 4 do if table[i,j]=piece then begin pcx:=i;pcy:=j;end;
oremx:=emx;
oremy:=emy;
x1:=xoffs+12+12+((pcx-1)*((sqsize*2)+4));
y1:=11+7+((pcy-1)*sqsize);
x2:=xoffs+12+12+((emx-1)*((sqsize*2)+4));
y2:=11+7+((emy-1)*sqsize);
table[pcx,pcy]:=0;
px:=x1;
py:=y1;
dx:=(x2-x1) div 2;
dy:=(y2-y1) div 2;
while not ((px=x2) and (py=y2)) do
begin
blk:=piece;
blx:=px;
bly:=py;
DrawIt;
px:=px+dx;
py:=py+dy;
end;
blk:=0;
table[oremx,oremy]:=piece;
DrawIt;
PieceBeep;
end;
{----------------------------------------------------------------------------}
procedure Shuffle;
var n,mv:integer;
begin
prevrnd:=0;
mv:=0;
randomize;
for n:=1 to fuzz do
begin
while mv=prevrnd do mv:=randommove;
DoMove(mv);
prevrnd:=mv;
end;
end;
{----------------------------------------------------------------------------}
procedure PlayGame;
label exitg;
var b1,solved:boolean;
begin
quit:=false;
solved:=false;
movenr:=1;
blk:=0;
DrawIt;
DoneBeep;
bmesc:=1;
botmes:='Amestec ...';
Shuffle;
DoneBeep;
while not solved do
begin
GetPlayerMove;
if quit=true then goto exitg;
delay(100);
solved:=true;
for i:=1 to 4 do for j:=1 to 4 do if table[i,j]<>(((j-1)*4)+i) mod 16 then solved:=false;
end;
botmes:='Problema rezolvata !';
DrawIt;
DoneBeep;
delay(3000);
exitg:
end;
{----------------------------------------------------------------------------}
procedure Cls;
begin
botmes:='';
ShowScr(11);
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
function QueryAgain:boolean;
var rez:boolean;
begin
rez:=false;
ShowScr(5);
If QueryYN=true then rez:=true;
KeyBeep;
QueryAgain:=rez;
end;
{----------------------------------------------------------------------------}
(*                                  MAIN                                    *)
{----------------------------------------------------------------------------}
label lab0;
begin
blk:=0;
blx:=0;
bly:=0;
cpage:=0;
sounds:=true;
if (paramcount>0) then
begin
if pos('/s',paramstr(1))<>0 then sounds:=false;
if (pos('/?',paramstr(1))<>0) or (pos('/h',paramstr(1))<>0) then
begin
clrscr;
writeln('Jocul 14-15 - programat de Dinu Cristian Mircea');
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
lab0:
QueryFuzz;
Cls;
Init;
ShowScr(1);
PlayGame;
Cls;
If QueryAgain=true then
begin
ShowScr(10);
goto lab0;
end;
Cls;
FadeOut;
closegraph;
end.


