uses graph,crt,dos,bgidriv,bgifont,revunit;
const Checkerfill : FillPatternType = ($AA, $55, $AA, $55, $AA, $55, $AA, $55);
      Human=1;
      Computer=2;
var dee_mode,dee_driv:integer;
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
Wtxt(320,25,'R e v e r s i',3);
Wtxt(320,74,'Joc de logica',1);
Wtxt(320,89,'Programat in Borland Pascal 7 de Dinu Cristian Mircea',1);
end;
{----------------------------------------------------------------------------}
procedure DrawScr3;
begin
Wtxt(320,25,'R e v e r s i',3);
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
Wtxt(320,25,'R e v e r s i',3);
Wtxt(320,82,'Inca o partida ? (Da/Nu)',1);
end;
{----------------------------------------------------------------------------}
procedure DrawScr7;
begin
Wtxt(320,25,'R e v e r s i',3);
Wtxt(320,82,'Introdu nivelul de joc al calculatorului (1 = expert - 9 = novice)',1);
end;
{----------------------------------------------------------------------------}
procedure DrawScr6;
begin
Wtxt(320,25,'R e v e r s i',3);
end;
{----------------------------------------------------------------------------}
procedure DrawTable;
const sqsize=16;
      xoffs=152;
var tmpx,tmpy:integer;
begin
setfillstyle(1,3);
DrawWoodBox(12+xoffs,11,307+xoffs,152,2,false);
for i:=1 to 8 do
begin
for j:=1 to 8 do
begin
tmpx:=xoffs+12+12+((i-1)*((sqsize*2)+2));
tmpy:=11+7+((j-1)*sqsize);
DrawWoodBlock(tmpx,tmpy,tmpx+1+(sqsize*2),tmpy+sqsize-1,2,false);
if b[i,j]=3 then
begin
setcolor(7);
setfillstyle(1,7);
fillellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,(sqsize-2),(sqsize div 2)-1);
setcolor(8);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,225,50,(sqsize-2),(sqsize div 2)-1);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,50,224,(sqsize-2)-4,(sqsize div 2)-3);
setcolor(15);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,50,224,(sqsize-2),(sqsize div 2)-1);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,225,45,(sqsize-2)-4,(sqsize div 2)-3);
end;
if b[i,j]=2 then
begin
setcolor(8);
setfillstyle(1,8);
fillellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,(sqsize-2),(sqsize div 2)-1);
setcolor(0);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,225,50,(sqsize-2),(sqsize div 2)-1);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,50,224,(sqsize-2)-4,(sqsize div 2)-3);
setcolor(7);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,50,224,(sqsize-2),(sqsize div 2)-1);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,225,45,(sqsize-2)-4,(sqsize div 2)-3);
end;
end;
end;
WTxt(88,75,'Alb',1);
WTxt(88,89,str2(bp),1);
WTxt(544,75,'Negru',4);
WTxt(544,89,str2(wp),4);
if highl=1 then
begin
tmpx:=xoffs+12+12+((highx-1)*((sqsize*2)+2));
tmpy:=11+7+((highy-1)*sqsize);
if highp=1 then
begin
setcolor(15);
line(tmpx+sqsize,tmpy+(sqsize div 2)-3,tmpx+sqsize,tmpy+2);
line(tmpx+sqsize+1,tmpy+(sqsize div 2)-3,tmpx+sqsize+1,tmpy+2);
line(tmpx+sqsize,tmpy+(sqsize div 2)+1,tmpx+sqsize,tmpy+(sqsize div 2)+4);
line(tmpx+sqsize+1,tmpy+(sqsize div 2)+1,tmpx+sqsize+1,tmpy+(sqsize div 2)+4);
line(tmpx+sqsize+5,tmpy+(sqsize div 2)-1,tmpx+(sqsize*2)-3,tmpy+(sqsize div 2)-1);
line(tmpx+sqsize-4,tmpy+(sqsize div 2)-1,tmpx+4,tmpy+(sqsize div 2)-1);
end;
if highp=3 then
begin
setcolor(7);
setfillstyle(1,7);
fillellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,(sqsize-2),(sqsize div 2)-1);
setcolor(8);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,225,50,(sqsize-2),(sqsize div 2)-1);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,50,224,(sqsize-2)-4,(sqsize div 2)-3);
setcolor(15);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,50,224,(sqsize-2),(sqsize div 2)-1);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,225,45,(sqsize-2)-4,(sqsize div 2)-3);
end;
if highp=2 then
begin
setcolor(8);
setfillstyle(1,8);
fillellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,(sqsize-2),(sqsize div 2)-1);
setcolor(0);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,225,50,(sqsize-2),(sqsize div 2)-1);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,50,224,(sqsize-2)-4,(sqsize div 2)-3);
setcolor(7);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,50,224,(sqsize-2),(sqsize div 2)-1);
ellipse(tmpx+sqsize,tmpy+(sqsize div 2)-1,225,45,(sqsize-2)-4,(sqsize div 2)-3);
end;
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
procedure QueryPlayers;
label lab0;
begin
ShowScr(3);
lab0:
char1:=readkey;
byte1:=ord(char1);
if (byte1>47) and (byte1<51) then numply:=byte1-48
                             else goto lab0;
KeyBeep;
end;
{----------------------------------------------------------------------------}
procedure QueryFuzz;
label lab0;
begin
ShowScr(6);
lab0:
char1:=readkey;
byte1:=ord(char1);
if (byte1>48) and (byte1<58) then fuzz:=(byte1-49)*10
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
procedure GetPlayerMove(var mvx,mvy:integer);
var crsx,crsy:integer;
    done:boolean;
    t_bmesc:byte;
    t_botmes:string;
label exitgp;
begin
crsx:=4;
crsy:=4;
done:=false;
while (done=false) do
begin
char1:='X';
highl:=1;
highx:=crsx;
highy:=crsy;
highp:=1;
DrawIt;
char1:=upcase(readkey);
if (char1=chr(72)) and (crsy>1) then dec(crsy);
if (char1=chr(80)) and (crsy<8) then inc(crsy);
if (char1=chr(75)) and (crsx>1) then dec(crsx);
if (char1=chr(77)) and (crsx<8) then inc(crsx);
if char1=chr(27) then
begin
KeyBeep;
crsx:=0;
goto exitgp;
end;
if char1=' ' then
begin
if Islegal(crsx,crsy)=true then
                           begin
                           KeyBeep;
                           done:=true;
                           end
                           else
                           begin
                           t_botmes:=botmes;
                           t_bmesc:=bmesc;
                           bmesc:=2;
                           botmes:='Mutare ilegala !';
                           DrawIt;
                           ErrorBeep;
                           bmesc:=t_bmesc;
                           botmes:=t_botmes;
                           end;
end;
if keypressed then
begin
char1:=upcase(readkey);
if (char1=chr(72)) and (crsy>1) then dec(crsy);
if (char1=chr(80)) and (crsy<8) then inc(crsy);
if (char1=chr(75)) and (crsx>1) then dec(crsx);
if (char1=chr(77)) and (crsx<8) then inc(crsx);
end;
end;
highl:=0;
exitgp:
mvx:=crsx;
mvy:=crsy;
end;
{----------------------------------------------------------------------------}
procedure HighLightMove(hlx,hly,piece:integer);
var
    n:integer;
begin
for n:=1 to 3 do
begin
Highl:=0;
DrawIt;
delay(50);
Highl:=1;
Highx:=hlx;
Highy:=hly;
Highp:=piece;
DrawIt;
delay(50);
end;
highl:=0;
end;
{----------------------------------------------------------------------------}
procedure PlayGame;
var gamecycle,failures:integer;
label retry1,retry2,skip1,skip2,gameover,exitg;
begin
while true do
begin
bmesc:=1;
WhitesTurn;
if CanMove=false then
begin
bmesc:=2;
botmes:='Alb nu poate muta';
inc(failures);
if failures=2 then goto gameover;
DrawIt;
ErrorBeep;
goto skip1;
end;
retry1:
bmesc:=1;
if whiteptype=computer then botmes:='Alb la mutare (calculez...)';
if whiteptype=human then botmes:='Alb la mutare ('+chr(24)+','+chr(25)+','+chr(26)+','+chr(27)+',Spatiu)';
DrawIt;
if whiteptype=computer then
begin
failures:=0;
CompMove(cmx,cmy);
botmes:='Alb muta la '+str2(cmx)+'-'+str2(cmy);
HighlightMove(cmx,cmy,3);
DoMove(cmx,cmy);
DrawIt;
PieceBeep;
end;
if whiteptype=human then
begin
failures:=0;
GetPlayerMove(cmx,cmy);
if cmx=0 then goto exitg;
botmes:='Alb muta la '+str2(cmx)+'-'+str2(cmy);
HighlightMove(cmx,cmy,3);
DoMove(cmx,cmy);
DrawIt;
PieceBeep;
end;
skip1:
if keypressed then char1:=readkey;
if char1=chr(27) then
begin
goto exitg;
end;
delay(200);
if bp+wp=64 then goto gameover;
BlacksTurn;
if CanMove=false then
begin
bmesc:=2;
botmes:='Negru nu poate muta';
inc(failures);
if failures=2 then goto gameover;
DrawIt;
ErrorBeep;
goto skip2;
end;
retry2:
bmesc:=4;
if blackptype=computer then botmes:='Negru la mutare (calculez...)';
if blackptype=human then botmes:='Negru la mutare ('+chr(24)+','+chr(25)+','+chr(26)+','+chr(27)+',Spatiu)';
DrawIt;
if blackptype=computer then
begin
failures:=0;
CompMove(cmx,cmy);
botmes:='Negru muta la '+str2(cmx)+'-'+str2(cmy);
HighlightMove(cmx,cmy,2);
DoMove(cmx,cmy);
DrawIt;
PieceBeep;
end;
if blackptype=human then
begin
failures:=0;
GetPlayerMove(cmx,cmy);
if cmx=0 then goto exitg;
botmes:='Negru muta la '+str2(cmx)+'-'+str2(cmy);
HighlightMove(cmx,cmy,2);
DoMove(cmx,cmy);
DrawIt;
PieceBeep;
end;
skip2:
if keypressed then char1:=readkey;
if char1=chr(27) then
begin
goto exitg;
end;
delay(200);
if bp+wp=64 then goto gameover;
end;
gameover:
bmesc:=1;
if bp>wp then botmes:='Alb castiga !';
if wp>bp then botmes:='Negru castiga !';
if (bp=0) or (wp=0) then botmes:=botmes+' (victorie totala)';
if wp>bp then bmesc:=4;
if bp=wp then botmes:='Remiza';
DrawIt;
DoneBeep;
delay(5000);
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
function QueryBW:boolean;
var res:boolean;
label la0;
begin
la0:
char1:=upcase(readkey);
if (char1<>'A') and (char1<>'N') then goto la0;
KeyBeep;
res:=false;
if char1='A' then res:=true;
QueryBW:=res;
end;
{----------------------------------------------------------------------------}
function QueryBlackWhite:boolean;
var rez:boolean;
begin
rez:=false;
ShowScr(4);
If QueryBW=true then rez:=true;
KeyBeep;
QueryBlackWhite:=rez;
end;
{----------------------------------------------------------------------------}
(*                                  MAIN                                    *)
{----------------------------------------------------------------------------}
label lab0;
begin
cpage:=0;
sounds:=true;
if (paramcount>0) then
begin
if pos('/s',paramstr(1))<>0 then sounds:=false;
if (pos('/?',paramstr(1))<>0) or (pos('/h',paramstr(1))<>0) then
begin
clrscr;
writeln('Reversi - programat de Dinu Cristian Mircea');
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
highl:=0;
SetUpGame;
QueryPlayers;
if numply=1 then ShowScr(10);
if numply=0 then
begin
whiteptype:=computer;
blackptype:=computer;
end;
if numply=2 then
begin
whiteptype:=human;
blackptype:=human;
end;
if numply=1 then
begin
if QueryBlackWhite=true then
                        begin
                        whiteptype:=human;
                        blackptype:=computer;
                        end
                        else
                        begin
                        blackptype:=human;
                        whiteptype:=computer;
                        end;
end;
if (numply=0) or (numply=1) then ShowScr(10);
if (numply=0) or (numply=1) then QueryFuzz;
Cls;
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


