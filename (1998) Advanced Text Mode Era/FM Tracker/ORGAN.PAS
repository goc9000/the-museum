uses dos,crt,keyboard,adlibu,textfont;
var chans:array[0..5] of integer;
    notes:array[1..32] of integer;
    notelag:array[1..32] of integer;
    lagtime:integer;
    bload:integer;
procedure DisplayChans;
var ci:integer;
begin
for ci:=0 to 5 do
begin
gotoxy(1+ci*4,1);
textcolor(8);
if chans[ci]>0 then textcolor(15);
if chans[ci]=0 then write('---');
if chans[ci]>0 then write('-ў-');
end;
textcolor(7);
gotoxy(25,1);
write('LAGTIME: ');
if lagtime<10000 then write('0');
if lagtime<1000 then write('0');
if lagtime<100 then write('0');
if lagtime<10 then write('0');
write(lagtime);

end;

function GetFreeChan:byte;
var ki:integer;
    cc:integer;
label pup;
begin
cc:=6;
for ki:=0 to 5 do
begin
if chans[ki]=0 then
begin
cc:=ki;
goto pup;
end;
end;
pup:
GetFreeChan:=cc;
end;

procedure HandleKey(var ky:boolean; freqn:integer; octave:byte; keyn:byte);
label pupu;
var fchan:integer;
begin
if (ky=true) and (notes[keyn]=255) then
                                   begin
                                   fchan:=GetFreeChan;
                                   if fchan=6 then goto pupu;
                                   notes[keyn]:=fchan;
                                   notelag[keyn]:=lagtime;
                                   chans[fchan]:=freqn;
                                   note(freqn,octave,fchan,organ);
                                   end;
if (ky=false) and (notes[keyn]<255) then
                                    begin
                                    if notelag[keyn]>0 then dec(notelag[keyn]);
                                    if notelag[keyn]>0 then goto pupu;
                                    shutup(notes[keyn]);
                                    chans[notes[keyn]]:=0;
                                    notes[keyn]:=255;
                                    end;
pupu:
end;

procedure DrawPiano;
begin
textbackground(7);
textcolor(0);
gotoxy(2,5);
writeln('  олн олн  Г  олн олн олн  Г  олн олн  Г  олн олн олн  Г  ');
gotoxy(2,6);
writeln('  олн олн  Г  олн олн олн  Г  олн олн  Г  олн олн олн  Г  ');
gotoxy(2,7);
writeln('  олн олн  Г  олн олн олн  Г  олн олн  Г  олн олн олн  Г  ');
gotoxy(2,8);
writeln('   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г  ');
gotoxy(2,9);
writeln('   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г  ');
gotoxy(2,10);
writeln('   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г   Г  ');
textcolor(1);
for i:=5 to 10 do
begin
gotoxy(1,i);
write('н');
gotoxy(60,i);
write('о');
textbackground(0);
gotoxy(70,i);
write('о');
textbackground(7);
end;
textbackground(1);
textcolor(11);
gotoxy(1,4);
write('   C#1 D#1     F#1 G#1 A#1     C#2 D#2    F#2 G#2 A#2       ');
textcolor(15);
writeln(' FORG-Y2K ');
textcolor(11);
gotoxy(1,11);
write(' C-1 D-1 E-1 F-1 G-1 A-1 B-1 C-2 D-2 E-2 F-2 G-2 A-2 B-2 C-3          ');
textbackground(0);
textcolor(15);
end;

procedure PlayNotes;
begin
DrawPiano;
DisplayChans;
if (pad_plus=true) and (bload=0) then
begin
lagtime:=lagtime+50;
bload:=100;
end;
if (pad_minus=true) and (bload=0) then
begin
lagtime:=lagtime-50;
if lagtime<0 then lagtime:=0;
bload:=100;
end;
if bload>0 then dec(bload);
HandleKey(key_q, c,3, 1);
HandleKey(key_2,cm,3, 2);
HandleKey(key_w, d,3, 3);
HandleKey(key_3,dm,3, 4);
HandleKey(key_e, e,3, 5);
HandleKey(key_r, f,3, 6);
HandleKey(key_5,fm,3, 7);
HandleKey(key_t, g,3, 8);
HandleKey(key_6,gm,3, 9);
HandleKey(key_y, a,3,10);
HandleKey(key_7,am,3,11);
HandleKey(key_u, b,3,12);

HandleKey(key_z, c,4,13);
HandleKey(key_s,cm,4,14);
HandleKey(key_x, d,4,15);
HandleKey(key_d,dm,4,16);
HandleKey(key_c, e,4,17);
HandleKey(key_v, f,4,18);
HandleKey(key_f,fm,4,19);
HandleKey(key_b, g,4,20);
HandleKey(key_g,gm,4,21);
HandleKey(key_n, a,4,22);
HandleKey(key_h,am,4,23);
HandleKey(key_m, b,4,24);
HandleKey(key_comma, c,5,25);
delay(1);
end;


begin
clrscr;
InitFM;
KeysOn;
blasttextcursor;
for i:=0 to 5 do chans[i]:=0;
for i:=1 to 32 do notes[i]:=255;
for i:=1 to 32 do notelag[i]:=0;
lagtime:=0;
while not key_esc do
begin
PlayNotes;
end;
KeysOff;
StopFm;
end.