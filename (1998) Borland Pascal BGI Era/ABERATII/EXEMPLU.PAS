program exemplu;

{Treaba asta este o 'baza' de program cu driverele & fonturile link-ate in el,}
{care ruleaza fara sa aiba nevoie de .bgi-uri sau .chr-uri		      }
{Uita-te prin unitati/program si modifica conform nevoilor tale 	      }
{Toata chestia asta am gasit-o in BP\EXAMPLES\DOS\BGI\			      }
{Si i-am bagat eu cateva aberatii                                             }
{Ce e marcat cu * nu-ti trebuie neaparat, dar am inclus eu in exemplu         }
{Te rog totusi, nu te uita in listing pana cand nu rulezi programul ;-D       }

uses Graph,
     Crt,      {*}
     BGIDriv,  {drivere}
     BGIFont;  {fonturi}
var
  GraphDriver, GraphMode, Error : integer;
  i:integer;{*}

procedure Abort(Msg : string);
begin
  Writeln(Msg, ' spune ca ', GraphErrorMsg(GraphResult));
  Halt(1);
end;

procedure Beep;
begin
sound(1000);
delay(1000);
nosound;
end;

begin

  {'nregistreaza driverele}
  if RegisterBGIdriver(@EGAVGADriverProc) < 0 then
    Abort('EGA/VGA');
  {si fonturile}
  if RegisterBGIfont(@GothicFontProc) < 0 then
    Abort('Gothic');
  if RegisterBGIfont(@SansSerifFontProc) < 0 then
    Abort('SansSerif');
  if RegisterBGIfont(@SmallFontProc) < 0 then
    Abort('Small');
  if RegisterBGIfont(@TriplexFontProc) < 0 then
    Abort('Triplex');
{si aici, restul programului! *}
GraphDriver:=Vga;
GraphMode:=VgaHi;
initgraph(GraphDriver,GraphMode,'');
{aberatii------+   }
{              |   }
{              |   }
{              |   }
{             \|/  }
for i:=1 to 28 do
begin
setcolor(i div 2);
circle(random(640),random(480),50+random(100));
end;
setcolor(15);
settextstyle(0,0,1);
settextjustify(1,1);
outtextxy(320,100,'Am impresia ca, cam merge.');
settextstyle(1,0,1);
settextjustify(1,1);
outtextxy(320,130,'El Triplexo');
settextstyle(2,0,4);
settextjustify(1,1);
outtextxy(320,170,'Fontuletzul');
settextstyle(3,0,1);
settextjustify(1,1);
outtextxy(320,200,'Der SansSerifsch von Micromoft');
settextstyle(4,0,4);
settextjustify(1,1);
outtextxy(320,250,'Fontul lui Tzepesh');
settextstyle(1,0,0);
settextjustify(1,1);
outtextxy(320,300,'& toate astea far`de BGI-u/CHR-uri !!!');
readkey;
closegraph;
delay(1000);
writeln;
writeln('Dezactivez Mega-Cache-ul secret ascuns in spatele sursei ...');
delay(2000);
writeln('Accesez mini-modemul secret de pe placa de baza ...');
delay(2000);
writeln('Intru pe site-ul Micromoft si te storc de bani ...');
delay(2000);
writeln('Dezactivez butoanele de RESET/POWER ...');
delay(2000);
writeln('Activez campul de forta din jurul calculatorului ...');
delay(2000);
writeln('Deviez cursul statiei MIR ...');
delay(2000);
writeln('Intru in computer-ul de la pentagon ...');
delay(2000);
writeln('Pun FBI-ul pe urmele tale ...');
delay(2000);
writeln('Le transmit extraterestrilor niste injuraturi ...');
delay(2000);
writeln('Comand o pizza ca mi-e foame ...');
delay(2000);
writeln('Sterg fisierul de swap ...');
delay(3000);
writeln('UPS! ti-am sters hard-discul - nu te superi, nu?');
delay(2000);
for i:=1 to 3000 do write(chr(32+random(200)));
writeln;
writeln('Memory allocation error');
delay(500);
writeln('Critical disk error on drive C:');
Beep;
delay(200);
writeln('General protection fault');
delay(500);
writeln('Illegal instruction');
delay(100);
writeln('Tomato pizza');
delay(500);
writeln('Illegal instruction');
writeln('General protection fault');
for i:=1 to 3000 do write(chr(32+random(200)));
writeln;
writeln('Critical disk error on drive C:');
delay(400);
writeln('Illegal instruction');
writeln('General protection fault');
delay(500);
writeln('Patrick Stewart');
writeln('Illegal instruction');
delay(200);
writeln('Hardware error');
delay(500);
for i:=1 to 3000 do write(chr(32+random(200)));
Beep;
for i:=1 to 6000 do
begin
textcolor(random(16));
textbackground(random(8));
write(chr(32+random(200)));
end;
textcolor(10);
textbackground(9);
clrscr;
write('ProceS sor maLf');
textcolor(12);
write('unctio n - syyteM Ha');
Beep;
textcolor(3);
write('LTe Dd .+-makmIae83hr cnjNnauhHeand');
textcolor(0);
write('ia');
 asm
    mov ah,01h
    mov ch,20h
    int 10h
end;
Beep;
for i:=1 to 120 do
begin
textcolor(random(16));
textbackground(random(8));
write(chr(32+random(200)));
end;
textcolor(7);
textbackground(0);
delay(5000);
clrscr;
write('GLUMA! - acum apasa orice tasta ca sa te intorci in BASIC');
readkey;
TextMode(1);
 asm
    mov ah,01h
    mov ch,20h
    int 10h
end;
textbackground(7);
textcolor(0);
clrscr;
gotoxy(1,24);
write('  (C) 1982 Sinclair Research Ltd.');
delay(2000);
clrscr;
for i:=1 to 10 do
begin
gotoxy(3,24);
textbackground(7);
textcolor(0);
write('K');
delay(70);
gotoxy(3,24);
textbackground(0);
textcolor(7);
write('K');
delay(100);
end;
gotoxy(3,24);
textbackground(7);
textcolor(0);
write('LOAD ');
for i:=1 to 4 do
begin
gotoxy(8,24);
textbackground(7);
textcolor(0);
write('K');
delay(70);
gotoxy(8,24);
textbackground(0);
textcolor(7);
write('K');
delay(100);
end;
gotoxy(3,24);
textbackground(7);
textcolor(0);
write('LOAD "');
for i:=1 to 2 do
begin
gotoxy(9,24);
textbackground(7);
textcolor(0);
write('K');
delay(70);
gotoxy(9,24);
textbackground(0);
textcolor(7);
write('K');
delay(100);
end;
gotoxy(3,24);
textbackground(7);
textcolor(0);
write('LOAD ""');
for i:=1 to 4 do
begin
gotoxy(10,24);
textbackground(7);
textcolor(0);
write('K');
delay(70);
gotoxy(10,24);
textbackground(0);
textcolor(7);
write('K');
delay(100);
end;
textbackground(7);
textcolor(0);
clrscr;
delay(500);
gotoxy(3,24);
textbackground(7);
textcolor(0);
write('B Integer out of range, 0:1');
delay(2000);
textmode(3);
 asm
    mov ah,01h
    mov ch,20h
    int 10h
end;
textbackground(0);
textcolor(7);
writeln('(Sorin va intelege)');
delay(2000);
clrscr;
for i:=0 to 7 do
begin
gotoxy(36,11);
textcolor(i);
writeln('GAME  OVER');
delay(50);
end;
delay(2000);
for i:=7 downto 0 do
begin
gotoxy(36,11);
textcolor(i);
writeln('GAME  OVER');
delay(50);
end;
clrscr;
textmode(3);
delay(1000);
writeln('Ce credeai ca s-a terminat ? Urmeaza inca 7 ore pline de aberatii,');
writeln('megaberatii si superatii !!! Apasa <RESET> pana cand nu e prea tarziu!');
delay(4000);
writeln;
writeln('FATAL SYSTEM ERROR #299D - program skipped');
delay(3000);
clrscr;
writeln('Pazuzu fie cu voi.');
writeln('THE END. Really.');
delay(2000);
writeln;
write('D:\CASAALBA\BILL\RELATII\NEPOTRIV\MONICA\');
readln;
writeln('Acces denied.(hehe)');
{ sfirsitul aberatiilor }
end.
