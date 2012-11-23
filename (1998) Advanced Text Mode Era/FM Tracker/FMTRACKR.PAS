uses adlibu,crt,textfont,keyboard,dos;{maxptr}
const keydl=7;
      stmaxlen=60;
var drumchn:byte;
    subsl:integer;
    anim:integer;
    octave,inst:integer;
    playingfor:integer;
    m:integer;
    w2loc:integer;
    windw:integer;
    prevalt:integer;
    ch:char;
    instype:array[1..9] of byte;
    clipb:array[1..(maxframes+2),1..4] of char;
    captsize:integer;
    drawingblock:integer;
    drumrec:integer;
    oldpos:integer;
    helpmsg:string;
    wind,crx:integer;
    put:byte;
    pressed:integer;
    quit:boolean;
    playing:boolean;
    blys,blye,blxs,blxe:integer;
    t_h,t_m,t_s,t_hs:word;
    o_h,o_m,o_s,o_hs:word;
procedure DrawHelpMsg; forward;
procedure DrawWindow2; forward;
procedure Message(title,txt:string;col:integer;help:string);forward;
function Confirm(title,txt:string;col:integer;help:string):boolean;forward;
procedure DrawPortion(wf:longint);forward;
label l1,l2,jmp2;
{--------------------------------------------------------------------------}
procedure UpdTime;
var diff:integer;
begin
diff:=0;
GetTime(t_h,t_m,t_s,t_hs);
if o_s<t_s then diff:=t_s-o_s;
if o_s>t_s then diff:=(60-o_s)+t_s;
playingfor:=playingfor+diff;
o_s:=t_s;
end;
{--------------------------------------------------------------------------}
procedure MakePlayMess;
var tstr:string;
    ts2:string;
    tmpm,tmps:integer;
begin
tmpm:=playingfor div 60;
tmps:=playingfor mod 60;
tstr:='Playing for ';
if tmpm<10 then tstr:=tstr+'0';
str(tmpm,ts2);
tstr:=tstr+ts2+':';
if tmps<10 then tstr:=tstr+'0';
str(tmps,ts2);
tstr:=tstr+ts2+' seconds';

helpmsg:=tstr;
end;
{--------------------------------------------------------------------------}
procedure ResTime;
var diff:integer;
begin
diff:=0;
GetTime(t_h,t_m,t_s,t_hs);
o_s:=t_s;
playingfor:=0;
end;
{--------------------------------------------------------------------------}
procedure WriteChn(chn:byte;what:array of char);
begin
mem[sgadr:songptr+((chn-1)*4)+0]:=ord(what[0]);
mem[sgadr:songptr+((chn-1)*4)+1]:=ord(what[1]);
mem[sgadr:songptr+((chn-1)*4)+2]:=ord(what[2]);
mem[sgadr:songptr+((chn-1)*4)+3]:=ord(what[3]);
end;
{--------------------------------------------------------------------------}
function GetChn(chn:byte):string;
var res:array[1..4] of char;
begin
res:='XXXX';
res[1]:=chr(mem[sgadr:songptr+((chn-1)*4)+0]);
res[2]:=chr(mem[sgadr:songptr+((chn-1)*4)+1]);
res[3]:=chr(mem[sgadr:songptr+((chn-1)*4)+2]);
res[4]:=chr(mem[sgadr:songptr+((chn-1)*4)+3]);
GetChn:=res;
end;
{--------------------------------------------------------------------------}
procedure DrawHelpMsg;
begin
gotoxy(1,25);
textbackground(0);
textcolor(3);
write(helpmsg);
for i:=1 to 79-length(helpmsg) do write(' ');
end;
{--------------------------------------------------------------------------}
procedure DrawCol(wh:longint;hg:integer;cb:integer;ishi:boolean);
var blk:integer;
begin
blk:=0;
if cb=0 then textbackground(0);
if cb=1 then textbackground(1);
if hg>0 then blk:=cb*128;
if hg>0 then textbackground(4);
if hg<0 then blk:=128;
if (wh>0) and (wh<(maxptr+24)) then
begin
textcolor(10+blk);
if (chr(mem[sgadr:wh])='N') and (chr(mem[sgadr:wh+1])='T') and (chr(mem[sgadr:wh+2])='E') then textcolor(7+blk);
if (chr(mem[sgadr:wh])='V') and (chr(mem[sgadr:wh+1])='O') and (chr(mem[sgadr:wh+2])='L') then textcolor(7+blk);
if (chr(mem[sgadr:wh])='R') and (chr(mem[sgadr:wh+1])='E') and (chr(mem[sgadr:wh+2])='P') then textcolor(7+blk);
if (chr(mem[sgadr:wh])='E') and (chr(mem[sgadr:wh+1])='N') and (chr(mem[sgadr:wh+2])='D') then textcolor(7+blk);
if (chr(mem[sgadr:wh])='S') and (chr(mem[sgadr:wh+1])='E') and (chr(mem[sgadr:wh+2])='T') then textcolor(7+blk);
if (chr(mem[sgadr:wh])='T') and (chr(mem[sgadr:wh+1])='R') and (chr(mem[sgadr:wh+2])='M') then textcolor(7+blk);
if (chr(mem[sgadr:wh])='V') and (chr(mem[sgadr:wh+1])='I') and (chr(mem[sgadr:wh+2])='B') then textcolor(7+blk);
if (chr(mem[sgadr:wh])='F') and (chr(mem[sgadr:wh+1])='R') and (chr(mem[sgadr:wh+2])='Q') then textcolor(7+blk);
if (chr(mem[sgadr:wh])='S') and (chr(mem[sgadr:wh+1])='P') and (chr(mem[sgadr:wh+2])='D') then textcolor(7+blk);
if (chr(mem[sgadr:wh])=' ') and
   (chr(mem[sgadr:wh+1])=' ') and
   (chr(mem[sgadr:wh+2])=' ') and
   (ishi=true) then
   begin
   textcolor(4+blk);
   write('óóó');
   textcolor(10+blk);
   end
else
begin
write(chr(mem[sgadr:wh]));
write(chr(mem[sgadr:wh+1]));
write(chr(mem[sgadr:wh+2]));
end;
textcolor(3+blk);
write('≥');
textcolor(10+blk);
if (chr(mem[sgadr:wh])='V') and (chr(mem[sgadr:wh+1])='O') and (chr(mem[sgadr:wh+2])='L') then textcolor(7+blk);
if (chr(mem[sgadr:wh+3])='ò') then textcolor(3+blk);
if (chr(mem[sgadr:wh+3])='ô') then textcolor(15+blk);
if (chr(mem[sgadr:wh+3])='ú') then textcolor(11+blk);
if (chr(mem[sgadr:wh+3])='ù') then textcolor(5+blk);
if (chr(mem[sgadr:wh+3])=chr(24)) then textcolor(11+blk);
if (chr(mem[sgadr:wh+3])=chr(25)) then textcolor(5+blk);
if (chr(mem[sgadr:wh])='S') and (chr(mem[sgadr:wh+1])='P') and (chr(mem[sgadr:wh+2])='D') then textcolor(7+blk);
if (chr(mem[sgadr:wh])='R') and (chr(mem[sgadr:wh+1])='E') and (chr(mem[sgadr:wh+2])='P') then textcolor(7+blk);
if (chr(mem[sgadr:wh])='E') and (chr(mem[sgadr:wh+1])='N') and (chr(mem[sgadr:wh+2])='D') then textcolor(7+blk);
if (chr(mem[sgadr:wh])='V') and (chr(mem[sgadr:wh+1])='I') and (chr(mem[sgadr:wh+2])='B') then textcolor(7+blk);
if (chr(mem[sgadr:wh])='T') and (chr(mem[sgadr:wh+1])='R') and (chr(mem[sgadr:wh+2])='M') then textcolor(7+blk);
write(chr(mem[sgadr:wh+3]));
end
else
begin
textcolor(10+blk);
write('   ');
textcolor(3+blk);
write('≥');
textcolor(10+blk);
write(' ');
end;
textbackground(0);
end;
{--------------------------------------------------------------------------}
procedure DrawDrm(wh:longint;hg:integer;cb:integer);
var bd,sn,oh,ch,rv,cr:integer;
    blk:integer;
begin
blk:=0;
if (hg<>0) then blk:=128;
if (wh>0) and (wh<(maxptr+24)) then begin
bd:=0;
sn:=0;
oh:=0;
ch:=0;
rv:=0;
cr:=0;
if chr(mem[sgadr:wh])='1' then bd:=1;
if chr(mem[sgadr:wh])='2' then sn:=1;
if chr(mem[sgadr:wh])='3' then ch:=1;
if chr(mem[sgadr:wh])='4' then oh:=1;
if chr(mem[sgadr:wh])='5' then cr:=1;
if chr(mem[sgadr:wh])='6' then rv:=1;
if chr(mem[sgadr:wh+1])='3' then ch:=1;
if chr(mem[sgadr:wh+1])='4' then oh:=1;
if chr(mem[sgadr:wh+1])='5' then cr:=1;
if chr(mem[sgadr:wh+1])='6' then rv:=1;
textbackground(0+cb); textcolor(10+blk);
if hg=1 then begin textbackground(4); textcolor(10+cb*128); end;
if bd=1 then write('˛') else write('˙');
textbackground(0+cb); textcolor(10+blk);
if hg=2 then begin textbackground(4); textcolor(10+cb*128); end;
if sn=1 then write('˛') else write('˙');
textbackground(0+cb); textcolor(10+blk);
if hg=3 then begin textbackground(4); textcolor(10+cb*128); end;
if oh=1 then write('˛') else write('˙');
textbackground(0+cb); textcolor(10+blk);
if hg=4 then begin textbackground(4); textcolor(10+cb*128); end;
if ch=1 then write('˛') else write('˙');
textbackground(0+cb); textcolor(10+blk);
if hg=5 then begin textbackground(4); textcolor(10+cb*128); end;
if cr=1 then write('˛') else write('˙');
textbackground(0+cb); textcolor(10+blk);
if hg=6 then begin textbackground(4); textcolor(10+cb*128); end;
if rv=1 then write('˛') else write('˙');
end
else
begin
textcolor(1);
write('      ');
end;
textcolor(1);
textbackground(0);
end;
{--------------------------------------------------------------------------}
procedure DrawRow(rw:longint;highl:integer);
var colinblock:integer;
    rowinblock,crow:integer;
    sendhi:boolean;
begin
crow:=rw div (columns*4);
rowinblock:=0;
if (crow>=blys) and (crow<=blye) then rowinblock:=1;
if rw<0 then rowinblock:=0;
textcolor(7);
write('∫');
for i:=1 to columns do
begin
colinblock:=0;
if (i>=blxs) and (i<=blxe) then colinblock:=1*rowinblock;
sendhi:=false;
if (((rw div (columns*4)) mod 4)=0) then sendhi:=true;
if (i=crx) and (highl>0) then
begin
if i<>drumchn then DrawCol(rw+(i-1)*4,1,colinblock,sendhi);
if i=drumchn then DrawDrm(rw+(i-1)*4,subsl+1,colinblock);
end;
if (i<>crx) and (highl>0) then
begin
if i<>drumchn then DrawCol(rw+(i-1)*4,-10,colinblock,sendhi);
if i=drumchn then DrawDrm(rw+(i-1)*4,-10,colinblock);
end;
if (highl=0) then
begin
if i<>drumchn then DrawCol(rw+(i-1)*4,0,colinblock,sendhi);
if i=drumchn then DrawDrm(rw+(i-1)*4,0,colinblock);
end;
textcolor(7);
if i<>columns then write('∫');
end;
textcolor(7);
if (wherey<>3)
and (wherey<>6)
and (wherey<>7)
and (wherey<>10)
and (wherey<>11)
and (wherey<>13)
and (wherey<>14)

and (wherey<>19)
then
write('∫')
else
write('Ã');
                     {…ÕÕÕÀÕÕÕÕÕª π  ∫ Õ—ÕœÕ}
                     {»ÕÕÕ ÕÕÕÕÕº Ã     ≥   }
writeln;
textbackground(0);
end;
{--------------------------------------------------------------------------}
procedure DrawPanel;
begin
textcolor(7);
gotoxy(39,2);
write('ÕÕÕÕÕÕÕÕÕÕÕÕÕ');
textcolor(15);
write('FM TRACKER 2.00');
textcolor(7);
write('ÕÕÕÕÕÕÕÕÕÕÕÕÕª');
gotoxy(39,3);
textcolor(15);
write('ATTACK');
textcolor(7);
write('ÕÀÕ');
textcolor(15);
write('DECAY');
textcolor(7);
write('ÕÀ');
textcolor(15);
write('SUSTAIN');
textcolor(7);
write('À');
textcolor(15);
write('RELEASE');
textcolor(7);
write('À');
textcolor(15);
write('HARMONIC');
textcolor(7);
write('Õπ');
gotoxy(46,4); write('∫'); gotoxy(46,5); write('∫');
gotoxy(54,4); write('∫'); gotoxy(54,5); write('∫');
gotoxy(62,4); write('∫'); gotoxy(62,5); write('∫');
gotoxy(70,4); write('∫'); gotoxy(70,5); write('∫');
gotoxy(80,4); write('∫'); gotoxy(80,5); write('∫');
gotoxy(39,6);
write('ÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕπ');
gotoxy(39,7);
textcolor(15);
write('VOLUME');
textcolor(7);
write('ÕÀ');
textcolor(15);
write('VIBRATO');
textcolor(7);
write('À');
textcolor(15);
write('TREMOLO');
textcolor(7);
write('À');
textcolor(15);
write('FEEDBACK');
textcolor(7);
write('ÕÀÕ');
textcolor(15);
write('WAVE');
textcolor(7);
write('ÕÕπ');
gotoxy(46,8); write('∫'); gotoxy(46,9); write('∫');
gotoxy(54,8); write('∫'); gotoxy(54,9); write('∫');
gotoxy(62,8); write('∫'); gotoxy(62,9); write('∫');
gotoxy(72,8); write('∫'); gotoxy(72,9); write('∫');
gotoxy(80,8); write('∫'); gotoxy(80,9); write('∫');
gotoxy(39,10);
write('ÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕπ');
gotoxy(39,11);
write('ÕÕ');
textcolor(15);
write('ALGORITHM');
textcolor(7);
write('ÕÕÀÕÕ');
textcolor(15);
write('INS. NAME');
textcolor(7);
write('ÕÕÕÀ');
textcolor(15);
write('INSTRUMENTS');
textcolor(7);
write('Õπ');
gotoxy(52,12); write('∫');
gotoxy(67,12); write('∫');
gotoxy(80,12); write('∫');
gotoxy(39,13);
write('ÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ');
gotoxy(39,14);
write('ÕÕÕÕÕÕÕÕ');
textcolor(15);
write('MENU');
textcolor(7);
write('ÕÕÕÕÕÕÕÕÀÕ');
textcolor(15);
write('VARS.');
textcolor(7);
write('Õπ');
textcolor(3);
gotoxy(46,15);
write('≥');
gotoxy(46,16);
write('≥');
gotoxy(46,17);
write('≥');
gotoxy(46,18);
write('≥');
for k:=20 to 23 do
begin
gotoxy(63,k);
write('≥');
end;
textcolor(7);
gotoxy(39,19);
write('ÕÕÕÕÕÕÕÕ');
textcolor(15);
write('ENVELOPE');
textcolor(7);
write('ÕÕÕÕ ÕÕÕÕÕÕÕπ');
for k:=13 to 23 do
begin
gotoxy(80,k);
write('∫');
end;
for k:=15 to 18 do
begin
gotoxy(59,k);
write('∫');
gotoxy(67,k);
write('∫');
end;
for k:=20 to 23 do
begin
gotoxy(67,k);
write('∫');
end;
gotoxy(39,24);
write('ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕº');
textcolor(11);
gotoxy(64,20);
write('OPR');
gotoxy(64,21);
write(' 1 ');
textcolor(5);
gotoxy(64,22);
write('OPR');
gotoxy(64,23);
write(' 2 ');
end;
{--------------------------------------------------------------------------}
function Inputstuff(title:string;maxlen:integer;col:integer;ext,hlp:string):string;
var instring:string;
    lconstant:integer;
    mconstant:integer;
    cpos:integer;
    tch:char;
    thelp:string;
    tvideo:array[1..481] of byte;
procedure DrawInput;
begin
textcolor(15);
gotoxy(mconstant,12);
for k:=1 to length(instring) do
begin
if k=cpos then textbackground(4)
          else textbackground(0);
if (k=maxlen) and (cpos=maxlen+1) then textbackground(4);
write(instring[k]);
textbackground(0);
end;
for k:=length(instring)+1 to maxlen do
begin
if k=cpos then textbackground(4)
          else textbackground(0);
if (k=maxlen) and (cpos=maxlen+1) then textbackground(4);
write('˙');
textbackground(0);
end;
write(ext);
end;

begin
for k:=1600 to 2080 do tvideo[k-1599]:=mem[$b800:k];
thelp:=helpmsg;
mconstant:=40-(maxlen div 2)-(length(ext) div 2);
lconstant:=length(title)+2;
if (maxlen+length(ext))>length(title) then lconstant:=length(ext)+maxlen+2;
helpmsg:=hlp;
DrawHelpMsg;
textcolor(col);
cpos:=1;
for i:=40-((lconstant) div 2)-1 to 39+((lconstant) div 2)+1 do
begin
gotoxy(i,11);
write('Õ');
gotoxy(i,12);
write(' ');
gotoxy(i,13);
write('Õ');
end;
gotoxy(40-((lconstant) div 2)-2,11);
write('…');
gotoxy(40-((lconstant) div 2)-2,12);
write('∫');
gotoxy(40-((lconstant) div 2)-2,13);
write('»');
gotoxy(39+((lconstant) div 2)+2,11);
write('ª');
gotoxy(39+((lconstant) div 2)+2,12);
write('∫');
gotoxy(39+((lconstant) div 2)+2,13);
write('º');
gotoxy(40-((length(title)) div 2),11);
writeln(title);
instring:='';
tch:='@';
reload:=rcon;
while((tch<>chr(13)) and (tch<>chr(255))) do
begin
DrawInput;
tch:=readkey2;
if (ord(tch)>31) and (ord(tch)<127) and (length(instring)<maxlen) then
begin
instring:=instring+tch;
if cpos<(maxlen+1) then inc(cpos);
end;
if (ord(tch)=8) and (length(instring)>0) then
begin
delete(instring,length(instring),1);
if cpos>1 then dec(cpos);
end;
delay(20);
end;
for k:=1600 to 2080 do mem[$b800:k]:=tvideo[k-1599];
helpmsg:=' ';
if ord(tch)=255 then instring:='(CANCEL)';
reload:=0;
pressed:=keydl*3;
Inputstuff:=instring;
end;
{--------------------------------------------------------------------------}
procedure SaveIns;
var f:file of byte;
    x:byte;
    inz:string;
    tst:string;
label skip;
begin
inz:=InputStuff('ENTER FILENAME',8,15,'.FTI','Enter filename for saved instrument');
if inz='(CANCEL)' then goto skip;
inz:=inz+'.FTI';
assign(f,inz);
{$I-}
reset(f);
{$I+}
if IOResult=0 then
begin
if confirm('WARNING','File '+inz+' exists. Overwrite (Y/N) ?',15,'Y:Yes, N:No')
   =false then goto skip;
end;
{$I-}
rewrite(f);
{$I+}
if IOResult<>0 then
begin
tst:='Cannot create '+inz;
Message('ERROR',tst,5,'Invalid name or disk write error');
goto skip;
end;
x:=ord('F'); write(f,x);
x:=ord('M'); write(f,x);
x:=ord('T'); write(f,x);
x:=ord('K'); write(f,x);
x:=ord('I'); write(f,x);
x:=ord(':'); write(f,x);
for i:=1 to 10 do begin x:=ord(insnames[inst,i]); write(f,x); end;
for i:=1 to 15 do begin x:=inses[inst,i]; write(f,x); end;
x:=0;
if inst<10 then x:=instype[inst];
write(f,x);
close(f);
{}
tst:=inz+' saved';
Message('OK',tst,15,'File saved OK');
skip:
end;
{--------------------------------------------------------------------------}
procedure SaveSng;
var f:file of byte;
    x:byte;
    inz:string;
    tst:string;
    newt:string;
label skip;
begin
newt:=InputStuff('ENTER SONG TITLE',stmaxlen,15,'','Enter your song''s title');
if newt='(CANCEL)' then goto skip;
inz:=InputStuff('ENTER FILENAME',8,15,'.FTM','Enter a filename for saved song');
if inz='(CANCEL)' then goto skip;
inz:=inz+'.FTM';
assign(f,inz);
{$I-}
reset(f);
{$I+}
if IOResult=0 then
begin
if confirm('WARNING','File '+inz+' exists. Overwrite (Y/N) ?',15,'Y:Yes, N:No')
   =false then goto skip;
end;
{$I-}
rewrite(f);
{$I+}
if IOResult<>0 then
begin
tst:='Cannot create '+inz;
Message('ERROR',tst,5,'Invalid name or disk write error');
goto skip;
end;
songtitle:=newt;
x:=ord('F'); write(f,x);
x:=ord('M'); write(f,x);
x:=ord('T'); write(f,x);
x:=ord('K'); write(f,x);
x:=ord('M'); write(f,x);
x:=ord(':'); write(f,x);
for i:=1 to (maxptr+24) do begin x:=mem[sgadr:i]; write(f,x); end;
x:=ord('I'); write(f,x);
x:=ord('N'); write(f,x);
x:=ord('S'); write(f,x);
x:=ord(':'); write(f,x);
for k:=1 to 15 do inses[10,k]:=   bass_drum[k];
for k:=1 to 15 do inses[11,k]:=      snared[k];
for k:=1 to 15 do inses[12,k]:=  hihat_open[k];
for k:=1 to 15 do inses[13,k]:=hihat_closed[k];
for k:=1 to 15 do inses[14,k]:=   crash_cym[k];
for k:=1 to 15 do inses[15,k]:=     rev_cym[k];
for k:=1 to 15 do
begin
for i:=1 to 10 do begin x:=ord(insnames[k,i]); write(f,x); end;
for i:=1 to 15 do begin x:=inses[k,i]; write(f,x); end;
x:=0;
if k<10 then x:=instype[k];
write(f,x);
end;
x:=ord('F'); write(f,x);
x:=ord('L'); write(f,x);
x:=ord('G'); write(f,x);
x:=ord(':'); write(f,x);
x:=crspeed; write(f,x);
x:=tremflag; write(f,x);
x:=vibflag; write(f,x);
x:=ord('N'); write(f,x);
x:=ord('M'); write(f,x);
x:=ord('E'); write(f,x);
x:=ord(':'); write(f,x);
for i:=1 to length(songtitle) do begin x:=ord(songtitle[i]); write(f,x);end;
close(f);
{}
tst:=inz+' saved';
DrawPortion(songptr);
Message('OK',tst,15,'File saved OK');
skip:
end;
{--------------------------------------------------------------------------}
procedure LoadIns;
var f:file of byte;
    x:byte;
    inz:string;
    tst:string;
label skip;
begin
inz:=InputStuff('ENTER PATH/FILENAME',64,15,'.FTI','Enter path and/or filename of instrument');
if inz='(CANCEL)' then goto skip;
inz:=inz+'.FTI';
assign(f,inz);
{$I-}
reset(f);
{$I+}
if IOResult<>0 then
begin
tst:='File '+inz+' not found';
Message('ERROR',tst,5,'Invalid path/name or inexistent file');
goto skip;
end;
tst:='';
read(f,x); tst:=tst+chr(x);read(f,x); tst:=tst+chr(x);read(f,x); tst:=tst+chr(x);
read(f,x); tst:=tst+chr(x);read(f,x); tst:=tst+chr(x);read(f,x); tst:=tst+chr(x);
if tst<>'FMTKI:' then
begin
tst:='File '+inz+' is corrupt';
Message('ERROR',tst,5,'The FMTracker Instrument header is missing');
goto skip;
end;
{}

for i:=1 to 10 do begin read(f,x); insnames[inst,i]:=chr(x);  end;
for i:=1 to 15 do begin read(f,x); inses[inst,i]:=x; end;
read(f,x);
if inst<10 then instype[inst]:=x;
{}
close(f);
{}
skip:
end;
{--------------------------------------------------------------------------}
procedure LoadSng;
var f:file of byte;
    x:byte;
    inz:string;
    tst:string;
label skip;
begin
inz:=InputStuff('ENTER PATH/FILENAME',64,15,'.FTM','Enter path and/or filename of song');
if inz='(CANCEL)' then goto skip;
inz:=inz+'.FTM';
assign(f,inz);
{$I-}
reset(f);
{$I+}
if IOResult<>0 then
begin
tst:='File '+inz+' not found';
Message('ERROR',tst,5,'Invalid path/name or inexistent file');
goto skip;
end;
tst:='';
read(f,x); tst:=tst+chr(x);read(f,x); tst:=tst+chr(x);read(f,x); tst:=tst+chr(x);
read(f,x); tst:=tst+chr(x);read(f,x); tst:=tst+chr(x);read(f,x); tst:=tst+chr(x);
if tst<>'FMTKM:' then
begin
tst:='File '+inz+' is corrupt';
Message('ERROR',tst,5,'The FMTracker Music header is missing');
goto skip;
end;
{}
for i:=1 to (maxptr+24) do begin read(f,x); mem[sgadr:i]:=x; end;
read(f,x);read(f,x);read(f,x);read(f,x);
for k:=1 to 15 do
begin
for i:=1 to 10 do begin read(f,x); insnames[k,i]:=chr(x);  end;
for i:=1 to 15 do begin read(f,x); inses[k,i]:=x; end;
read(f,x);
if k<10 then instype[k]:=x;
end;
for k:=1 to 15 do    bass_drum[k]:=inses[10,k];
for k:=1 to 15 do       snared[k]:=inses[11,k];
for k:=1 to 15 do   hihat_open[k]:=inses[12,k];
for k:=1 to 15 do hihat_closed[k]:=inses[13,k];
for k:=1 to 15 do    crash_cym[k]:=inses[14,k];
for k:=1 to 15 do      rev_cym[k]:=inses[15,k];
read(f,x);read(f,x);read(f,x);read(f,x);
read(f,x);
crspeed:=x;
read(f,x);
tremflag:=x;
read(f,x);
vibflag:=x;
read(f,x);read(f,x);read(f,x);read(f,x);
songtitle:='';
while not eof(f) do
begin
read(f,x);
songtitle:=songtitle+chr(x);
end;
{}
close(f);
{}
skip:
end;
{--------------------------------------------------------------------------}
procedure MenuFns;
begin
if (key_f4=true) and (pressed=0) then
begin
pressed:=keydl*3;
if inst<10 then Note(d,octave,0,inses[inst]);
end;
if (key_f2=true) and (pressed=0) then
begin
pressed:=keydl*4;
SaveSng;
end;
if (key_f3=true) and (pressed=0) then
begin
pressed:=keydl*4;
LoadSng;
end;
if (key_f7=true) and (pressed=0) then
begin
pressed:=keydl*4;
SaveIns;
end;
if (key_f6=true) and (pressed=0) then
begin
pressed:=keydl*4;
LoadIns;
end;
end;
{--------------------------------------------------------------------------}
procedure DrawWindow2;
const newdest:array[1..26,1..4] of byte=
       ((1{26}, 2, 1{9}, 3),
        ( 1,11,2{10}, 4),
        (3{26}, 4, 1, 5),
        ( 3,13, 2, 6),
        (5{26}, 6, 3, 7),
        ( 5,15, 4, 8),
        (7{26}, 8, 5, 9),
        ( 7,17, 6,10),
        (9{26},10, 7, 9{1}),
        ( 9,18, 8, 10{2}),
        ( 2,12,11{18},13),
        (11,20,12{19},14),
        ( 4,14,11,15),
        (13,20,12,16),
        ( 6,16,13,17),
        (15,21,14,17),
        ( 8,21,15,18),
        (10,19,17,18{11}),
        (18,26,17,19{12}),
        (12,22,20{26},21),
        (16,22,20,26),
        (21,23,22{26},26),
        (22,24,23{26},26),
        (23,25,24{26},26),
        (24,25{ 4},25{26},26),
        (19,26{ 9},21,26{20}));
var catk,cdec,csus,crel:integer;
    catk2,cdec2,csus2,crel2:integer;
    cvol,cvol2,cwav,cwav2:integer;
    cvib,cvib2,ctrm,ctrm2,chrm,chrm2:integer;
    calg:integer;
    cfbk:integer;
    cxval:integer;
    clev:real;
procedure DrawEnvLevel(kx,ky,kl:integer);
begin
gotoxy(kx,ky);
if kl< 9 then write(' ');
if kl= 9 then write('à');
if kl=10 then write('â');
if kl=11 then write('ä');
if kl=12 then write('ã');
if kl=13 then write('å');
if kl=14 then write('ç');
if kl=15 then write('é');
if kl=16 then write('è');
gotoxy(kx,ky+1);
if kl=0 then write(' ');
if kl=1 then write('à');
if kl=2 then write('â');
if kl=3 then write('ä');
if kl=4 then write('ã');
if kl=5 then write('å');
if kl=6 then write('ç');
if kl=7 then write('é');
if kl=8 then write('è');
if kl> 8 then write('è');
end;
procedure DrawEnvLevel2(kx,ky,kl:integer);
begin
gotoxy(kx,ky);
if kl=0 then write(' ');
if kl=1 then write('ñ');
if kl=2 then write('ï');
if kl=3 then write('î');
if kl=4 then write('ì');
if kl=5 then write('í');
if kl=6 then write('ë');
if kl=7 then write('ê');
if kl=8 then write('è');
if kl> 8 then write('è');
gotoxy(kx,ky+1);
if kl< 9 then write(' ');
if kl= 9 then write('ñ');
if kl=10 then write('ï');
if kl=11 then write('î');
if kl=12 then write('ì');
if kl=13 then write('í');
if kl=14 then write('ë');
if kl=15 then write('ê');
if kl=16 then write('è');
end;

procedure DrawEnvelope;
label done1,done2,skip1,skip2;
begin
cxval:=0;
clev:=0;
textcolor(11);
while (clev<16) do
begin
clev:=clev+catk*2;
if round(clev)>16 then clev:=16;
DrawEnvLevel(39+cxval,20,(round(clev)));
inc(cxval);
if cxval>23 then goto done1;
end;
if cdec=0 then goto skip1;
while (clev>csus) do
begin
clev:=clev-cdec;
if round(clev)<csus then clev:=csus;
DrawEnvLevel(39+cxval,20,(round(clev)));
inc(cxval);
if cxval>23 then goto done1;
end;
skip1:
while (cxval<24) do
begin
clev:=clev-crel;
if round(clev)<0 then clev:=0;
DrawEnvLevel(39+cxval,20,(round(clev)));
inc(cxval);
end;
done1:
cxval:=0;
clev:=0;
textcolor(5);
while (clev<16) do
begin
clev:=clev+catk2*2;
if round(clev)>16 then clev:=16;
DrawEnvLevel2(39+cxval,22,(round(clev)));
inc(cxval);
if cxval>23 then goto done2;
end;
if cdec2=0 then goto skip2;
while (clev>csus2) do
begin
clev:=clev-cdec2;
if round(clev)<csus2 then clev:=csus2;
DrawEnvLevel2(39+cxval,22,(round(clev)));
inc(cxval);
if cxval>23 then goto done2;
end;
skip2:
while (cxval<24) do
begin
clev:=clev-crel2;
if round(clev)<0 then clev:=0;
DrawEnvLevel2(39+cxval,22,(round(clev)));
inc(cxval);
end;
done2:
end;

procedure DrawPMET(wx,wy,val,vmx,col,index:integer);
var perc:integer;
    blk:integer;
begin
blk:=0;
if (windw=2) and (index=w2loc) then blk:=1;
gotoxy(wx,wy);
textcolor(col+blk*128);
perc:=round(val/vmx*15);
if perc=00 then write(chr(193)+chr(197)+chr(197)+chr(197));
if perc=01 then write(chr(194)+chr(197)+chr(197)+chr(197));
if perc=02 then write(chr(195)+chr(197)+chr(197)+chr(197));
if perc=03 then write(chr(196)+chr(197)+chr(197)+chr(197));
if perc=04 then write(chr(197)+chr(193)+chr(197)+chr(197));
if perc=05 then write(chr(197)+chr(194)+chr(197)+chr(197));
if perc=06 then write(chr(197)+chr(195)+chr(197)+chr(197));
if perc=07 then write(chr(197)+chr(196)+chr(197)+chr(197));
if perc=08 then write(chr(197)+chr(197)+chr(193)+chr(197));
if perc=09 then write(chr(197)+chr(197)+chr(194)+chr(197));
if perc=10 then write(chr(197)+chr(197)+chr(195)+chr(197));
if perc=11 then write(chr(197)+chr(197)+chr(196)+chr(197));
if perc=12 then write(chr(197)+chr(197)+chr(197)+chr(193));
if perc=13 then write(chr(197)+chr(197)+chr(197)+chr(194));
if perc=14 then write(chr(197)+chr(197)+chr(197)+chr(195));
if perc=15 then write(chr(197)+chr(197)+chr(197)+chr(196));
textcolor(3+blk*128);
write('≥');
textcolor(col+blk*128);
if val<10 then write('0');
write(val);
textcolor(7);
end;

procedure DrawSwitch(wx,wy,val,col,index:integer);
var perc:integer;
    blk:integer;
begin
blk:=0;
if (windw=2) and (index=w2loc) then blk:=1;
gotoxy(wx,wy);
textcolor(4+(11*val)+blk*128);
write('ON');
textcolor(col+blk*128);
if val=01 then write(chr(194)+chr(197));
if val=00 then write(chr(197)+chr(195));
textcolor(15-(11*val)+blk*128);
write('OFF');
textcolor(7);
end;

procedure DrawHarm(wx,wy,val,col,index:integer);
var perc:integer;
    blk:integer;
begin
blk:=0;
if (windw=2) and (index=w2loc) then blk:=1;
gotoxy(wx,wy);
textcolor(col+blk*128);
if val= 0 then write(' -1 OCT  ');
if val= 1 then write(' +0 OCT  ');
if val= 2 then write(' +1 OCT  ');
if val= 3 then write('+1 OCT 5 ');
if val= 4 then write(' +2 OCT  ');
if val= 5 then write('+2 OCT 3M');
if val= 6 then write('+2 OCT 5 ');
if val= 7 then write('+2 OCT 7m');
if val= 8 then write(' +3 OCT  ');
if val= 9 then write('+3 OCT 2M');
if val=10 then write('+3 OCT 3M');
if val=12 then write('+3 OCT 5 ');
if val=15 then write('+3 OCT 7m');
textcolor(7);
end;

procedure DrawWave(wx,wy,val,col,index:integer);
var perc:integer;
    blk:integer;
begin
blk:=0;
if (windw=2) and (index=w2loc) then blk:=1;
gotoxy(wx,wy);
textcolor(col+blk*128);
if val= 0 then write('†°†°†°†');
if val= 1 then write('†£†£†£†');
if val= 2 then write('†††††††');
if val= 3 then write('¢¢¢¢¢¢¢');
textcolor(7);
end;

procedure DrawMisc;
var tw2loc:integer;
    xfc:integer;
begin
tw2loc:=w2loc;
if windw<>2 then w2loc:=0;
gotoxy(39,12);
if w2loc=20 then textcolor(128+15) else textcolor(15);
if calg=0 then write('1 MODULATES 2');
if calg=1 then write(' INDEPENDENT ');
textcolor(3);
{}
if w2loc=21 then textcolor(128+15) else textcolor(15);
gotoxy(53,12);
if instype[inst]=0 then begin textattr:=textattr and 240; textattr:=textattr or 15; end;
if instype[inst]=0 then write('Í');
if instype[inst]=1 then begin textattr:=textattr and 240; textattr:=textattr or 13; end;
if instype[inst]=1 then write('‡');
if instype[inst]=2 then begin textattr:=textattr and 240; textattr:=textattr or 6; end;
if instype[inst]=2 then write('·');
if instype[inst]=3 then begin textattr:=textattr and 240; textattr:=textattr or 13; end;
if instype[inst]=3 then write('‚');
if instype[inst]=4 then begin textattr:=textattr and 240; textattr:=textattr or 14; end;
if instype[inst]=4 then write('„');
if instype[inst]=5 then begin textattr:=textattr and 240; textattr:=textattr or 15; end;
if instype[inst]=5 then write('‰');
if instype[inst]=6 then begin textattr:=textattr and 240; textattr:=textattr or 14; end;
if instype[inst]=6 then write('Â');
if instype[inst]=7 then begin textattr:=textattr and 240; textattr:=textattr or 3; end;
if instype[inst]=7 then write('Ê');
if instype[inst]=8 then begin textattr:=textattr and 240; textattr:=textattr or 13; end;
if instype[inst]=8 then write('Á');
if instype[inst]=9 then begin textattr:=textattr and 240; textattr:=textattr or 7; end;
if instype[inst]=9 then write('Ë');
if instype[inst]=10 then begin textattr:=textattr and 240; textattr:=textattr or 3; end;
if instype[inst]=10 then write('È');
if (inst=10) then if w2loc=21 then textcolor(128+3) else textcolor(3);
if (inst=11) then if w2loc=21 then textcolor(128+3) else textcolor(3);
if (inst>11) then if w2loc=21 then textcolor(128+14) else textcolor(14);
if (inst=10) then write('Ö');
if (inst=11) then write('Ä');
if (inst=12) then write('Å');
if (inst=13) then write('Ç');
if (inst=14) then write('É');
if (inst=15) then write('Ñ');
if w2loc=21 then textcolor(128+3) else textcolor(3);
gotoxy(54,12);
write('≥');
if w2loc=21 then textcolor(128+15) else textcolor(15);
gotoxy(55,12);
write(' ',insnames[inst],' ');
textcolor(3);
{}
if w2loc=22 then textcolor(128+7) else textcolor(7);
gotoxy(60,15);
write('VIB=');
if w2loc=22 then textcolor(128+15) else textcolor(15);
if vibflag=0 then write('07%');
if vibflag=1 then write('15%');
textcolor(3);
if w2loc=23 then textcolor(128+7) else textcolor(7);
gotoxy(60,16);
write('TRM=');
if w2loc=23 then textcolor(128+15) else textcolor(15);
if tremflag=0 then write('1dB');
if tremflag=1 then write('5dB');
textcolor(3);
if w2loc=24 then textcolor(128+7) else textcolor(7);
gotoxy(60,17);
write(' OCT=');
if w2loc=24 then textcolor(128+15) else textcolor(15);
write(octave);
write(' ');
textcolor(3);
if w2loc=25 then textcolor(128+7) else textcolor(7);
gotoxy(60,18);
write('SPEED=');
if w2loc=25 then textcolor(128+15) else textcolor(15);
write(crspeed);
textcolor(15);
gotoxy(39,15);
write('F1-HELP');
gotoxy(39,16);
write('F2-SAVE');
gotoxy(39,17);
write('F3-LOAD');
gotoxy(39,18);
write('F5-PLAY');
gotoxy(47,15);
write('F8-STOP');
gotoxy(47,16);
write('F6-LOAD INS.');
gotoxy(47,17);
write('F7-SAVE INS.');
gotoxy(47,18);
write('F4-TEST INS.');
textcolor(3);
for k:=-5 to 6 do
begin
xfc:=0;
if (inst+k)=10 then xfc:=12;
if (inst+k)=11 then xfc:=12;
if (inst+k)>11 then xfc:=1;
if w2loc<>26 then
begin
if k<>0 then textcolor(15-xfc);
if k=0 then textcolor(128+15-xfc);
end;
if w2loc=26 then
begin
if k<>0 then
begin
textbackground(0);
textcolor(15-xfc);
end;
if k=0 then
begin
textbackground(4);
textcolor(15-xfc);
end;
end;
gotoxy(68,17+k);
if (inst+k>0) and (inst+k<16) then
begin
if (inst+k>0) and (inst+k<10) then
begin
if instype[inst+k]=0 then begin textattr:=textattr and 240; textattr:=textattr or 15; end;
if instype[inst+k]=0 then write('Í');
if instype[inst+k]=1 then begin textattr:=textattr and 240; textattr:=textattr or 13; end;
if instype[inst+k]=1 then write('‡');
if instype[inst+k]=2 then begin textattr:=textattr and 240; textattr:=textattr or 6; end;
if instype[inst+k]=2 then write('·');
if instype[inst+k]=3 then begin textattr:=textattr and 240; textattr:=textattr or 13; end;
if instype[inst+k]=3 then write('‚');
if instype[inst+k]=4 then begin textattr:=textattr and 240; textattr:=textattr or 14; end;
if instype[inst+k]=4 then write('„');
if instype[inst+k]=5 then begin textattr:=textattr and 240; textattr:=textattr or 15; end;
if instype[inst+k]=5 then write('‰');
if instype[inst+k]=6 then begin textattr:=textattr and 240; textattr:=textattr or 14; end;
if instype[inst+k]=6 then write('Â');
if instype[inst+k]=7 then begin textattr:=textattr and 240; textattr:=textattr or 3; end;
if instype[inst+k]=7 then write('Ê');
if instype[inst+k]=8 then begin textattr:=textattr and 240; textattr:=textattr or 13; end;
if instype[inst+k]=8 then write('Á');
if instype[inst+k]=9 then begin textattr:=textattr and 240; textattr:=textattr or 7; end;
if instype[inst+k]=9 then write('Ë');
if instype[inst+k]=10 then begin textattr:=textattr and 240; textattr:=textattr or 3; end;
if instype[inst+k]=10 then write('È');
end;
if (inst+k=10) then write('Ö');
if (inst+k=11) then write('Ä');
if (inst+k=12) then write('Å');
if (inst+k=13) then write('Ç');
if (inst+k=14) then write('É');
if (inst+k=15) then write('Ñ');
textattr:=textattr and 240;
textattr:=textattr or 3;
write('≥');
textattr:=textattr or 7;
write(insnames[inst+k]);
end
else
begin
textattr:=textattr and 240;
textattr:=textattr or 3;
write(' ≥          ');
end;
end;
w2loc:=tw2loc;
end;

procedure GetVals;
begin
for k:=1 to 15 do inses[10,k]:=   bass_drum[k];
for k:=1 to 15 do inses[11,k]:=      snared[k];
for k:=1 to 15 do inses[12,k]:=  hihat_open[k];
for k:=1 to 15 do inses[13,k]:=hihat_closed[k];
for k:=1 to 15 do inses[14,k]:=   crash_cym[k];
for k:=1 to 15 do inses[15,k]:=     rev_cym[k];
cvol:=inses[inst,1];
cvol2:=inses[inst,2];
catk:=inses[inst,3];
catk2:=inses[inst,4];
cdec:=inses[inst,5];
cdec2:=inses[inst,6];
csus:=inses[inst,7];
csus2:=inses[inst,8];
crel:=inses[inst,9];
crel2:=inses[inst,10];
cwav:=inses[inst,13];
cwav2:=inses[inst,14];
chrm:=inses[inst,11] and 15;
chrm2:=inses[inst,12] and 15;
ctrm:=(inses[inst,11] and 128) div 128;
cvib:=(inses[inst,11] and 64) div 64;
ctrm2:=(inses[inst,12] and 128) div 128;
cvib2:=(inses[inst,12] and 64) div 64;
cfbk:=(inses[inst,15] shr 1);
calg:=(inses[inst,15] and 1);
csus:=15-csus;
csus2:=15-csus2;
cvol:=63-cvol;
cvol2:=63-cvol2;
end;

procedure ChangeInsName;
var ts:string;
label skip;
begin
ts:=InputStuff('ENTER NEW NAME',10,15,'','Enter a name for this instrument');
if ts='(CANCEL)' then goto skip;
while length(ts)<10 do ts:=ts+' ';
insnames[inst]:=ts;
skip:
end;

procedure SetVals;
begin
cvol:=63-cvol;
cvol2:=63-cvol2;
csus:=15-csus;
csus2:=15-csus2;
inses[inst,1]:=cvol;
inses[inst,2]:=cvol2;
inses[inst,3]:=catk;
inses[inst,4]:=catk2;
inses[inst,5]:=cdec;
inses[inst,6]:=cdec2;
inses[inst,7]:=csus;
inses[inst,8]:=csus2;
inses[inst,9]:=crel;
inses[inst,10]:=crel2;
inses[inst,11]:=chrm+(64*cvib)+(128*ctrm);
inses[inst,12]:=chrm2+(64*cvib2)+(128*ctrm2);
inses[inst,13]:=cwav;
inses[inst,14]:=cwav2;
inses[inst,15]:=(cfbk shl 1)+calg;
for k:=1 to 15 do    bass_drum[k]:=inses[10,k];
for k:=1 to 15 do       snared[k]:=inses[11,k];
for k:=1 to 15 do   hihat_open[k]:=inses[12,k];
for k:=1 to 15 do hihat_closed[k]:=inses[13,k];
for k:=1 to 15 do    crash_cym[k]:=inses[14,k];
for k:=1 to 15 do      rev_cym[k]:=inses[15,k];
Reg($40+cho[0],inses[inst,ins_vol1]);
Reg($40+cho[0]+3,inses[inst,ins_vol2]);
Reg($20+cho[0],inses[inst,ins_hrm1]);
Reg($20+cho[0]+3,inses[inst,ins_hrm2]);
Reg($60+cho[0],(inses[inst,ins_atk1] shl 4)+inses[inst,ins_dek1]);
Reg($60+cho[0]+3,(inses[inst,ins_atk2] shl 4)+inses[inst,ins_dek2]);
Reg($80+cho[0],(inses[inst,ins_sus1] shl 4)+inses[inst,ins_rel1]);
Reg($80+cho[0]+3,(inses[inst,ins_sus2] shl 4)+inses[inst,ins_rel2]);
Reg($c0+0,inses[inst,ins_conn]);
Reg($e0+cho[0],inses[inst,ins_wav1]);
Reg($e0+cho[0]+3,inses[inst,ins_wav2]);
end;

begin
GetVals;
DrawEnvelope;
DrawPMET(39,4,catk,15,11, 1);
DrawPMET(39,5,catk2,15,5, 2);
DrawPMET(47,4,cdec,15,11, 3);
DrawPMET(47,5,cdec2,15,5, 4);
DrawPMET(55,4,csus,15,11, 5);
DrawPMET(55,5,csus2,15,5, 6);
DrawPMET(63,4,crel,15,11, 7);
DrawPMET(63,5,crel2,15,5, 8);
DrawHarm(71,4,chrm,11,    9);
DrawHarm(71,5,chrm2,5,   10);
DrawPMET(39,8,cvol,63,11,11);
DrawPMET(39,9,cvol2,63,5,12);
DrawSwitch(47,8,cvib,11, 13);
DrawSwitch(47,9,cvib2,5, 14);
DrawSwitch(55,8,ctrm,11, 15);
DrawSwitch(55,9,ctrm2,5, 16);
DrawPMET(64,8,cfbk,7,11, 17);
DrawPMET(64,9,0,7,4,0);
DrawWave(73,8,cwav,11,18);
DrawWave(73,9,cwav2,5,19);
DrawMisc;
if windw=2 then
begin
if pressed=0 then
begin
if (key_alt=false) then
begin
if Pad_8=true then begin pressed:=keydl+keydl; w2loc:=newdest[w2loc,1]; end;
if Pad_2=true then begin pressed:=keydl+keydl; w2loc:=newdest[w2loc,2]; end;
if Pad_4=true then begin pressed:=keydl+keydl; w2loc:=newdest[w2loc,3]; end;
if Pad_6=true then begin pressed:=keydl+keydl; w2loc:=newdest[w2loc,4]; end;
end;
{MODIFS}
if (Pad_8=true) and (Key_Alt=true) then
begin
pressed:=keydl+(keydl div 2);
if w2loc=26 then
begin
SetVals;
dec(inst);
if inst<1 then inst:=1;
GetVals;
end;
end;
if (Pad_2=true) and (Key_Alt=true) then
begin
pressed:=keydl+(keydl div 2);
if w2loc=26 then
begin
SetVals;
inc(inst);
if inst>15 then inst:=15;
GetVals;
end;
end;
if (Pad_4=true) and (Key_Alt=true) then
begin
pressed:=keydl+(keydl div 3);
if w2loc=1 then
begin
catk:=catk-1;
if catk<0 then catk:=0;
end;
if w2loc=2 then
begin
catk2:=catk2-1;
if catk2<0 then catk2:=0;
end;
if w2loc=3 then
begin
cdec:=cdec-1;
if cdec<0 then cdec:=0;
end;
if w2loc=4 then
begin
cdec2:=cdec2-1;
if cdec2<0 then cdec2:=0;
end;
if w2loc=5 then
begin
csus:=csus-1;
if csus<0 then csus:=0;
end;
if w2loc=6 then
begin
csus2:=csus2-1;
if csus2<0 then csus2:=0;
end;
if w2loc=7 then
begin
crel:=crel-1;
if crel<0 then crel:=0;
end;
if w2loc=8 then
begin
crel2:=crel2-1;
if crel2<0 then crel2:=0;
end;
if w2loc=9 then
begin
pressed:=keydl*3;
chrm:=chrm-1;
if chrm=11 then chrm:=10;
if chrm=14 then chrm:=12;
if chrm<0 then chrm:=0;
end;
if w2loc=10 then
begin
pressed:=keydl*3;
chrm2:=chrm2-1;
if chrm2=11 then chrm2:=10;
if chrm2=14 then chrm2:=12;
if chrm2<0 then chrm2:=0;
end;
if w2loc=11 then
begin
cvol:=cvol-1;
if cvol<0 then cvol:=0;
end;
if w2loc=12 then
begin
cvol2:=cvol2-1;
if cvol2<0 then cvol2:=0;
end;
if w2loc=13 then
begin
if cvib=0 then cvib:=1;
end;
if w2loc=14 then
begin
if cvib2=0 then cvib2:=1;
end;
if w2loc=15 then
begin
if ctrm=0 then ctrm:=1;
end;
if w2loc=16 then
begin
if ctrm2=0 then ctrm2:=1;
end;
if w2loc=20 then
begin
if calg=1 then calg:=0;
end;
if w2loc=17 then
begin
cfbk:=cfbk-1;
if cfbk<0 then cfbk:=0;
end;
if w2loc=18 then
begin
cwav:=cwav-1;
if cwav<0 then cwav:=0;
end;
if w2loc=19 then
begin
cwav2:=cwav2-1;
if cwav2<0 then cwav2:=0;
end;
if w2loc=21 then
begin
pressed:=keydl+(keydl div 2);
if instype[inst]>0 then instype[inst]:=instype[inst]-1;
end;
if w2loc=22 then
begin
if vibflag=1 then vibflag:=0;
reg($bd,128*tremflag+64*vibflag);
end;
if w2loc=23 then
begin
if tremflag=1 then tremflag:=0;
reg($bd,128*tremflag+64*vibflag);
end;
if w2loc=24 then
begin
octave:=octave-1;
if octave<0 then octave:=0;
end;
if w2loc=25 then
begin
crspeed:=crspeed-1;
if crspeed<1 then crspeed:=1;
end;
{MORE}
end;
{EDITING}
if Key_Enter=true then
begin
pressed:=keydl+(keydl div 3);
ChangeInsName;
end;
{MODIF}
if (Pad_6=true) and (Key_Alt=true) then
begin
pressed:=keydl+(keydl div 3);
if w2loc=21 then
begin
pressed:=keydl+(keydl div 2);
instype[inst]:=instype[inst]+1;
if instype[inst]>10 then instype[inst]:=10;
end;
if w2loc=1 then
begin
catk:=catk+1;
if catk>15 then catk:=15;
end;
if w2loc=2 then
begin
catk2:=catk2+1;
if catk2>15 then catk2:=15;
end;
if w2loc=3 then
begin
cdec:=cdec+1;
if cdec>15 then cdec:=15;
end;
if w2loc=4 then
begin
cdec2:=cdec2+1;
if cdec2>15 then cdec2:=15;
end;
if w2loc=5 then
begin
csus:=csus+1;
if csus>15 then csus:=15;
end;
if w2loc=6 then
begin
csus2:=csus2+1;
if csus2>15 then csus2:=15;
end;
if w2loc=7 then
begin
crel:=crel+1;
if crel>15 then crel:=15;
end;
if w2loc=8 then
begin
crel2:=crel2+1;
if crel2>15 then crel2:=15;
end;
if w2loc=9 then
begin
pressed:=keydl*3;
chrm:=chrm+1;
if chrm=11 then chrm:=12;
if chrm=13 then chrm:=15;
if chrm>15 then chrm:=15;
end;
if w2loc=10 then
begin
pressed:=keydl*3;
chrm2:=chrm2+1;
if chrm2=11 then chrm2:=12;
if chrm2=13 then chrm2:=15;
if chrm2>15 then chrm2:=15;
end;
if w2loc=11 then
begin
cvol:=cvol+1;
if cvol>63 then cvol:=63;
end;
if w2loc=12 then
begin
cvol2:=cvol2+1;
if cvol2>63 then cvol2:=63;
end;
if w2loc=13 then
begin
if cvib=1 then cvib:=0;
end;
if w2loc=14 then
begin
if cvib2=1 then cvib2:=0;
end;
if w2loc=15 then
begin
if ctrm=1 then ctrm:=0;
end;
if w2loc=16 then
begin
if ctrm2=1 then ctrm2:=0;
end;
if w2loc=17 then
begin
cfbk:=cfbk+1;
if cfbk>7 then cfbk:=7;
end;
if w2loc=18 then
begin
cwav:=cwav+1;
if cwav>3 then cwav:=3;
end;
if w2loc=19 then
begin
cwav2:=cwav2+1;
if cwav2>3 then cwav2:=3;
end;
if w2loc=20 then
begin
if calg=0 then calg:=1;
end;
if w2loc=26 then
begin
SetVals;
inc(inst);
if inst>15 then inst:=15;
GetVals;
end;
if w2loc=22 then
begin
if vibflag=0 then vibflag:=1;
reg($bd,128*tremflag+64*vibflag);
end;
if w2loc=23 then
begin
if tremflag=0 then tremflag:=1;
reg($bd,128*tremflag+64*vibflag);
end;
if w2loc=24 then
begin
octave:=octave+1;
if octave>7 then octave:=7;
end;
if w2loc=25 then
begin
crspeed:=crspeed+1;
if crspeed>9 then crspeed:=9;
end;

{MORE...}
end;
end;
end;
SetVals;
end;
{--------------------------------------------------------------------------}
procedure DrawPortion(wf:longint);
var bdr,sna,oph,clh,rvc,crh:integer;
    wh:longint;
    stitle:string;
    cframe:integer;
    cstr:string;
begin
textcolor(15);
stitle:='';
for i:=1 to (39-((length(songtitle)+12) div 2)) do stitle:=stitle+' ';
stitle:=stitle+songtitle+':Row ';
cframe:=(songptr-1) div (columns*4);
if cframe<1000 then stitle:=stitle+'0';
if cframe<100 then stitle:=stitle+'0';
if cframe<10 then stitle:=stitle+'0';
str(cframe,cstr);
stitle:=stitle+cstr;
while (length(stitle)<80) do stitle:=stitle+' ';
gotoxy(1,1);
writeln(stitle);
textcolor(7);
DrawWindow2;
bdr:=0;
sna:=0;
oph:=0;
clh:=0;
rvc:=0;
crh:=0;
wh:=wf+((drumchn-1)*4);
{BUMBI}
if (not playing) and (windw<>2) and (crx=drumchn) and (subsl=0) and (anim>(keydl*5)) then bdr:=1;
if (not playing) and (windw<>2) and (crx=drumchn) and (subsl=1) and (anim>(keydl*5)) then sna:=1;
if (not playing) and (windw<>2) and (crx=drumchn) and (subsl=2) and (anim>(keydl*5)) then oph:=1;
if (not playing) and (windw<>2) and (crx=drumchn) and (subsl=3) and (anim>(keydl*5)) then clh:=1;
if (not playing) and (windw<>2) and (crx=drumchn) and (subsl=4) and (anim>(keydl*5)) then crh:=1;
if (not playing) and (windw<>2) and (crx=drumchn) and (subsl=5) and (anim>(keydl*5)) then rvc:=1;
if playing then
begin
if chr(mem[sgadr:wh])='1' then bdr:=1;
if chr(mem[sgadr:wh])='2' then sna:=1;
if chr(mem[sgadr:wh])='3' then clh:=1;
if chr(mem[sgadr:wh])='4' then oph:=1;
if chr(mem[sgadr:wh])='5' then crh:=1;
if chr(mem[sgadr:wh])='6' then rvc:=1;
if chr(mem[sgadr:wh+1])='3' then clh:=1;
if chr(mem[sgadr:wh+1])='4' then oph:=1;
if chr(mem[sgadr:wh+1])='5' then crh:=1;
if chr(mem[sgadr:wh+1])='6' then rvc:=1;
end;
gotoxy(1,2);
Textcolor(7);
write('…');
for i:=0 to columns-1 do
begin
if i<>(drumchn-1) then
begin
Textcolor(7);
write('Õ');
textcolor(15);
if chmt[i+1]=0 then write('á') else write('™');
Textcolor(7);
write('ÕÕ');
Textcolor(14);
write('Ü');
end
else
begin
if chmt[i+1]=0 then
begin
textcolor(3);
if bdr=0 then write('Ö') else write('©');
if sna=0 then write('Ä') else write('§');
textcolor(14);
if oph=0 then write('Å') else write('•');
if clh=0 then write('Ç') else write('¶');
if crh=0 then write('É') else write('ß');
if rvc=0 then write('Ñ') else write('®');
end
else
begin
textcolor(3);
write('´´');
textcolor(14);
write('´´´´');
end;
end;
textcolor(7);
write('À');
end;
gotoxy(1,24);
Textcolor(7);
write('»');
for i:=0 to columns-1 do
begin
if i<>(drumchn-1) then
begin
Textcolor(7);
write('ÕÕÕÕÕ');
end
else
begin
Textcolor(7);
write('ÕÕÕÕÕÕ');
end;
textcolor(7);
write(' ');
end;
                     {…ÕÕÕÀÕÕÕÕÕª π  ∫ Õ—ÕœÕ}
                     {»ÕÕÕ ÕÕÕÕÕº Ã     ≥   }
if windw=1 then
begin
for j:=-10 to 10 do
begin
gotoxy(1,13+j);
if j<>0 then DrawRow(wf+j*(columns*4),0);
if j=0 then DrawRow(wf+j*(columns*4),crx);
end;
end;
if windw=2 then
begin
for j:=-10 to 10 do
begin
gotoxy(1,13+j);
DrawRow(wf+j*(columns*4),0);
end;
end;
end;
{--------------------------------------------------------------------------}
procedure movel;
begin
anim:=0;
if crx>1 then
begin
if crx=drumchn then
begin
subsl:=subsl-1;
if subsl<0 then
begin
subsl:=0;
dec(crx);
if crx<1 then crx:=1;
end;
end
else dec(crx);
if crx<1 then crx:=1;
end;
end;
{--------------------------------------------------------------------------}
procedure mover;
begin
anim:=0;
if crx=drumchn then
begin
subsl:=subsl+1;
if subsl>5 then
begin
subsl:=5;
inc(crx);
if crx>6 then crx:=6;
end;
end
else inc(crx);
if crx>6 then crx:=6;
end;
{--------------------------------------------------------------------------}
procedure InsDelLines;
var crrow:integer;
    tsptr:longint;
    tstr:string;
    tarr:array[1..4] of char;
    kri:integer;
begin
if (pad_0=true) and (pressed=0) and (key_shift=true) then
begin
crrow:=songptr div (columns*4);
tsptr:=songptr;
pressed:=(keydl)+(keydl div 2);
for kri:=999 downto (crrow+1) do
begin
songptr:=1+((kri-1)*(columns*4));
tstr:=GetChn(crx);
tarr[1]:=tstr[1];
tarr[2]:=tstr[2];
tarr[3]:=tstr[3];
tarr[4]:=tstr[4];
songptr:=songptr+(columns*4);
WriteChn(crx,tarr);
end;
songptr:=tsptr;
WriteChn(crx,'    ');
end;

if (pad_period=true) and (pressed=0) and (key_shift=true) then
begin
crrow:=songptr div (columns*4);
tsptr:=songptr;
pressed:=(keydl)+(keydl div 2);
for kri:=crrow to 998 do
begin
songptr:=1+((kri+1)*(columns*4));
tstr:=GetChn(crx);
tarr[1]:=tstr[1];
tarr[2]:=tstr[2];
tarr[3]:=tstr[3];
tarr[4]:=tstr[4];
songptr:=songptr-(columns*4);
WriteChn(crx,tarr);
end;
songptr:=1+(999*(columns*4));
WriteChn(crx,'    ');
songptr:=tsptr;
end;
{
if (pad_0=true) and (pressed=0) and (key_shift=true) then
begin
for j:=1 to 32*4 do
begin
crrow:=songptr div (columns*4);
tsptr:=songptr;
pressed:=(keydl)+(keydl div 2);
for kri:=999 downto (crrow+1) do
begin
songptr:=1+((kri-1)*(columns*4));
tstr:=GetChn(crx);
tarr[1]:=tstr[1];
tarr[2]:=tstr[2];
tarr[3]:=tstr[3];
tarr[4]:=tstr[4];
songptr:=songptr+(columns*4);
WriteChn(crx,tarr);
end;
songptr:=tsptr;
WriteChn(crx,'    ');
end;
end;

if (pad_period=true) and (pressed=0) and (key_shift=false) then
begin
for j:=1 to 32*4 do
begin
crrow:=songptr div (columns*4);
tsptr:=songptr;
pressed:=(keydl)+(keydl div 2);
for i:=crrow to 998 do
begin
songptr:=1+((i+1)*(columns*4));
tstr:=GetChn(crx);
tarr[1]:=tstr[1];
tarr[2]:=tstr[2];
tarr[3]:=tstr[3];
tarr[4]:=tstr[4];
songptr:=songptr-(columns*4);
WriteChn(crx,tarr);
end;
songptr:=1+(999*(columns*4));
WriteChn(crx,'    ');
songptr:=tsptr;
end;
end;
}
end;
{--------------------------------------------------------------------------}
procedure EnterNotes;
var inpstr:string;
    inparr:array[1..4] of char;
label skip;
begin
if inst>9 then goto skip;
if pressed=0 then
begin
if crx<>drumchn then
begin
if Key_C=true then
begin
pressed:=(keydl*2);
inpstr:='C '+chr(48+octave)+chr(48+inst)+' ';
if Key_Shift=true then inpstr:='C#'+chr(48+octave)+chr(48+inst)+' ';
for i:=1 to 4 do inparr[i]:=inpstr[i];
writechn(crx,inparr);
PlayNote(crx);
songptr:=songptr+4*columns;
if songptr>maxptr then songptr:=maxptr;
end;
if Key_D=true then
begin
pressed:=(keydl*2);
inpstr:='D '+chr(48+octave)+chr(48+inst)+' ';
if Key_Shift=true then inpstr:='D#'+chr(48+octave)+chr(48+inst)+' ';
for i:=1 to 4 do inparr[i]:=inpstr[i];
writechn(crx,inparr);
PlayNote(crx);
songptr:=songptr+4*columns;
if songptr>maxptr then songptr:=maxptr;
end;
if Key_E=true then
begin
pressed:=(keydl*2);
inpstr:='E '+chr(48+octave)+chr(48+inst)+' ';
for i:=1 to 4 do inparr[i]:=inpstr[i];
writechn(crx,inparr);
PlayNote(crx);
songptr:=songptr+4*columns;
if songptr>maxptr then songptr:=maxptr;
end;
if Key_F=true then
begin
pressed:=(keydl*2);
inpstr:='F '+chr(48+octave)+chr(48+inst)+' ';
if Key_Shift=true then inpstr:='F#'+chr(48+octave)+chr(48+inst)+' ';
for i:=1 to 4 do inparr[i]:=inpstr[i];
writechn(crx,inparr);
PlayNote(crx);
songptr:=songptr+4*columns;
if songptr>maxptr then songptr:=maxptr;
end;
if Key_G=true then
begin
pressed:=(keydl*2);
inpstr:='G '+chr(48+octave)+chr(48+inst)+' ';
if Key_Shift=true then inpstr:='G#'+chr(48+octave)+chr(48+inst)+' ';
for i:=1 to 4 do inparr[i]:=inpstr[i];
writechn(crx,inparr);
PlayNote(crx);
songptr:=songptr+4*columns;
if songptr>maxptr then songptr:=maxptr;
end;
if Key_A=true then
begin
pressed:=(keydl*2);
inpstr:='A '+chr(48+octave)+chr(48+inst)+' ';
if Key_Shift=true then inpstr:='A#'+chr(48+octave)+chr(48+inst)+' ';
for i:=1 to 4 do inparr[i]:=inpstr[i];
writechn(crx,inparr);
PlayNote(crx);
songptr:=songptr+4*columns;
if songptr>maxptr then songptr:=maxptr;
end;
if Key_B=true then
begin
pressed:=(keydl*2);
inpstr:='B '+chr(48+octave)+chr(48+inst)+' ';
for i:=1 to 4 do inparr[i]:=inpstr[i];
writechn(crx,inparr);
PlayNote(crx);
songptr:=songptr+4*columns;
if songptr>maxptr then songptr:=maxptr;
end;
If Key_spacebar=true then
begin
pressed:=(keydl+(keydl div 2));
writechn(crx,'    ');
songptr:=songptr+4*columns;
if songptr>maxptr then songptr:=maxptr;
end;
end;
end;
skip:
end;
{--------------------------------------------------------------------------}
procedure EnterDrums;
label jmp;
begin
if pressed=0 then
begin
if crx=drumchn then
begin
if Key_Spacebar=true then
begin
pressed:=keydl*2;
put:=0;
if (subsl=0) and (getchn(drumchn)='    ') then begin writechn(drumchn,'1   '); put:=1; goto jmp; end;
if (subsl=0) and (getchn(drumchn)='1   ') then begin writechn(drumchn,'    '); goto jmp; end;
if (subsl=0) and (getchn(drumchn)='2   ') then begin writechn(drumchn,'1   '); put:=1; goto jmp; end;
if (subsl=0) and (getchn(drumchn)='3   ') then begin writechn(drumchn,'13  '); put:=1; goto jmp; end;
if (subsl=0) and (getchn(drumchn)='4   ') then begin writechn(drumchn,'14  '); put:=1; goto jmp; end;
if (subsl=0) and (getchn(drumchn)='5   ') then begin writechn(drumchn,'15  '); put:=1; goto jmp; end;
if (subsl=0) and (getchn(drumchn)='6   ') then begin writechn(drumchn,'16  '); put:=1; goto jmp; end;
if (subsl=0) and (getchn(drumchn)='13  ') then begin writechn(drumchn,'3   '); goto jmp; end;
if (subsl=0) and (getchn(drumchn)='14  ') then begin writechn(drumchn,'4   '); goto jmp; end;
if (subsl=0) and (getchn(drumchn)='15  ') then begin writechn(drumchn,'5   '); goto jmp; end;
if (subsl=0) and (getchn(drumchn)='16  ') then begin writechn(drumchn,'6   '); goto jmp; end;

if (subsl=1) and (getchn(drumchn)<>'2   ') then begin writechn(drumchn,'2   '); put:=1; goto jmp; end;
if (subsl=1) and (getchn(drumchn)='2   ') then begin writechn(drumchn,'    '); goto jmp; end;

if (subsl=2) and (getchn(drumchn)='    ') then begin writechn(drumchn,'4   '); put:=1; goto jmp; end;
if (subsl=2) and (getchn(drumchn)='1   ') then begin writechn(drumchn,'14  '); put:=1; goto jmp; end;
if (subsl=2) and (getchn(drumchn)='2   ') then begin writechn(drumchn,'2   '); put:=1; goto jmp; end;
if (subsl=2) and (getchn(drumchn)='3   ') then begin writechn(drumchn,'4   '); put:=1; goto jmp; end;
if (subsl=2) and (getchn(drumchn)='4   ') then begin writechn(drumchn,'    '); goto jmp; end;
if (subsl=2) and (getchn(drumchn)='5   ') then begin writechn(drumchn,'4   '); put:=1; goto jmp; end;
if (subsl=2) and (getchn(drumchn)='6   ') then begin writechn(drumchn,'4   '); put:=1; goto jmp; end;
if (subsl=2) and (getchn(drumchn)='13  ') then begin writechn(drumchn,'14  '); put:=1; goto jmp; end;
if (subsl=2) and (getchn(drumchn)='14  ') then begin writechn(drumchn,'1   '); goto jmp; end;
if (subsl=2) and (getchn(drumchn)='15  ') then begin writechn(drumchn,'14  '); put:=1; goto jmp; end;
if (subsl=2) and (getchn(drumchn)='16  ') then begin writechn(drumchn,'14  '); put:=1; goto jmp; end;

if (subsl=3) and (getchn(drumchn)='    ') then begin writechn(drumchn,'3   '); put:=1; goto jmp; end;
if (subsl=3) and (getchn(drumchn)='1   ') then begin writechn(drumchn,'13  '); put:=1; goto jmp; end;
if (subsl=3) and (getchn(drumchn)='2   ') then begin writechn(drumchn,'2   '); put:=1; goto jmp; end;
if (subsl=3) and (getchn(drumchn)='3   ') then begin writechn(drumchn,'    '); goto jmp; end;
if (subsl=3) and (getchn(drumchn)='4   ') then begin writechn(drumchn,'3   '); put:=1; goto jmp; end;
if (subsl=3) and (getchn(drumchn)='5   ') then begin writechn(drumchn,'3   '); put:=1; goto jmp; end;
if (subsl=3) and (getchn(drumchn)='6   ') then begin writechn(drumchn,'3   '); put:=1; goto jmp; end;
if (subsl=3) and (getchn(drumchn)='13  ') then begin writechn(drumchn,'1   '); goto jmp; end;
if (subsl=3) and (getchn(drumchn)='14  ') then begin writechn(drumchn,'13  '); put:=1; goto jmp; end;
if (subsl=3) and (getchn(drumchn)='15  ') then begin writechn(drumchn,'13  '); put:=1; goto jmp; end;
if (subsl=3) and (getchn(drumchn)='16  ') then begin writechn(drumchn,'13  '); put:=1; goto jmp; end;

if (subsl=4) and (getchn(drumchn)='    ') then begin writechn(drumchn,'5   '); put:=1; goto jmp; end;
if (subsl=4) and (getchn(drumchn)='1   ') then begin writechn(drumchn,'15  '); put:=1; goto jmp; end;
if (subsl=4) and (getchn(drumchn)='2   ') then begin writechn(drumchn,'2   '); put:=1; goto jmp; end;
if (subsl=4) and (getchn(drumchn)='3   ') then begin writechn(drumchn,'5   '); put:=1; goto jmp; end;
if (subsl=4) and (getchn(drumchn)='4   ') then begin writechn(drumchn,'5   '); put:=1; goto jmp; end;
if (subsl=4) and (getchn(drumchn)='5   ') then begin writechn(drumchn,'    '); goto jmp; end;
if (subsl=4) and (getchn(drumchn)='6   ') then begin writechn(drumchn,'5   '); put:=1; goto jmp; end;
if (subsl=4) and (getchn(drumchn)='13  ') then begin writechn(drumchn,'15  '); put:=1; goto jmp; end;
if (subsl=4) and (getchn(drumchn)='14  ') then begin writechn(drumchn,'15  '); put:=1; goto jmp; end;
if (subsl=4) and (getchn(drumchn)='15  ') then begin writechn(drumchn,'1   '); goto jmp; end;
if (subsl=4) and (getchn(drumchn)='16  ') then begin writechn(drumchn,'15  '); put:=1; goto jmp; end;

if (subsl=5) and (getchn(drumchn)='    ') then begin writechn(drumchn,'6   '); put:=1; goto jmp; end;
if (subsl=5) and (getchn(drumchn)='1   ') then begin writechn(drumchn,'16  '); put:=1; goto jmp; end;
if (subsl=5) and (getchn(drumchn)='2   ') then begin writechn(drumchn,'2   '); put:=1; goto jmp; end;
if (subsl=5) and (getchn(drumchn)='3   ') then begin writechn(drumchn,'6   '); put:=1; goto jmp; end;
if (subsl=5) and (getchn(drumchn)='4   ') then begin writechn(drumchn,'6   '); put:=1; goto jmp; end;
if (subsl=5) and (getchn(drumchn)='5   ') then begin writechn(drumchn,'6   '); put:=1; goto jmp; end;
if (subsl=5) and (getchn(drumchn)='6   ') then begin writechn(drumchn,'    '); goto jmp; end;
if (subsl=5) and (getchn(drumchn)='13  ') then begin writechn(drumchn,'16  '); put:=1; goto jmp; end;
if (subsl=5) and (getchn(drumchn)='14  ') then begin writechn(drumchn,'16  '); put:=1; goto jmp; end;
if (subsl=5) and (getchn(drumchn)='15  ') then begin writechn(drumchn,'16  '); put:=1; goto jmp; end;
if (subsl=5) and (getchn(drumchn)='16  ') then begin writechn(drumchn,'1   '); goto jmp; end;
jmp:
if (key_spacebar=true) and (subsl=0) and (put=1) then Bdrum;
if (key_spacebar=true) and (subsl=1) and (put=1) then Snare;
if (key_spacebar=true) and (subsl=2) and (put=1) then Hho;
if (key_spacebar=true) and (subsl=3) and (put=1) then Hhc;
if (key_spacebar=true) and (subsl=4) and (put=1) then Crash;
if (key_spacebar=true) and (subsl=5) and (put=1) then Revcr;
end;
end;
end;
end;
{--------------------------------------------------------------------------}
procedure SelectOctave;
begin
if (Key_Alt=false) and (Key_I=false) and (Key_Ctrl=false) and (drawingblock=0) then
begin
if Key_0=true then octave:=0;
if Key_1=true then octave:=1;
if Key_2=true then octave:=2;
if Key_3=true then octave:=3;
if Key_4=true then octave:=4;
if Key_5=true then octave:=5;
if Key_6=true then octave:=6;
if Key_7=true then octave:=7;
end;
end;
{--------------------------------------------------------------------------}
procedure SelectInstrument;
begin
while (Key_I=true) do
begin
helpmsg:='1-9:Select ins., B:Bass dr., S:Snare, O:Op. hat, C:Cl. hat, H:Crash, R:Rev. cym';
drawhelpmsg;
drawportion(songptr);
if Key_1=true then inst:=1;
if Key_2=true then inst:=2;
if Key_3=true then inst:=3;
if Key_4=true then inst:=4;
if Key_5=true then inst:=5;
if Key_6=true then inst:=6;
if Key_7=true then inst:=7;
if Key_8=true then inst:=8;
if Key_9=true then inst:=9;
if Key_B=true then inst:=10;
if Key_S=true then inst:=11;
if Key_O=true then inst:=12;
if Key_C=true then inst:=13;
if Key_H=true then inst:=14;
if Key_R=true then inst:=15;
end;
end;
{--------------------------------------------------------------------------}
procedure BounceKeys;
begin
inc(anim);
if anim>(keydl*8) then anim:=0;
if pressed>0 then dec(pressed);
end;
{--------------------------------------------------------------------------}
procedure MoveAround;
begin
if pressed=0 then
begin
if Pad_8=true then begin pressed:=keydl; if songptr>1 then songptr:=songptr-(columns*4); end;
if Pad_2=true then begin pressed:=keydl; songptr:=songptr+(columns*4); if songptr>maxptr then songptr:=maxptr; end;
if Pad_4=true then begin pressed:=keydl*2; movel; end;
if Pad_6=true then begin pressed:=keydl*2; mover; end;
if Pad_7=true then begin songptr:=1; DrawHelpMsg; DrawPortion(songptr); end;
if Pad_1=true then begin songptr:=maxptr; DrawHelpMsg; DrawPortion(songptr); end;
if Pad_3=true then
begin
pressed:=keydl div 2;
for m:=1 to 20 do
begin
songptr:=songptr+(columns*4);
if songptr>maxptr then songptr:=maxptr;
DrawHelpMsg;
DrawPortion(songptr);
delay(5);
end;
end;
if Pad_9=true then
begin
pressed:=keydl div 2;
for m:=1 to 20 do
begin
if songptr>1 then songptr:=songptr-(columns*4);
DrawHelpMsg;
DrawPortion(songptr);
delay(5);
end;
end;
end;
end;
{--------------------------------------------------------------------------}
procedure Message(title,txt:string;col:integer;help:string);
var thelp:string;
    tvideo:array[1..481] of byte;
begin
for k:=1600 to 2080 do tvideo[k-1599]:=mem[$b800:k];
if length(txt)>64 then delete(txt,64,(length(txt)-63));
thelp:=helpmsg;
helpmsg:=help;
DrawHelpMsg;
textcolor(col);
for i:=40-((length(txt)) div 2)-1 to 39+((length(txt)) div 2)+1 do
begin
gotoxy(i,11);
write('Õ');
gotoxy(i,12);
write(' ');
gotoxy(i,13);
write('Õ');
end;
gotoxy(40-((length(txt)) div 2)-2,11);
write('…');
gotoxy(40-((length(txt)) div 2)-2,12);
write('∫');
gotoxy(40-((length(txt)) div 2)-2,13);
write('»');
gotoxy(39+((length(txt)) div 2)+2,11);
write('ª');
gotoxy(39+((length(txt)) div 2)+2,12);
write('∫');
gotoxy(39+((length(txt)) div 2)+2,13);
write('º');
gotoxy(40-((length(title)) div 2),11);
writeln(title);
gotoxy(40-((length(txt)) div 2),12);
writeln(txt);
delay(2000);
helpmsg:=' ';
for k:=1600 to 2080 do mem[$b800:k]:=tvideo[k-1599];
end;
{--------------------------------------------------------------------------}
function Confirm(title,txt:string;col:integer;help:string):boolean;
var thelp:string;
    tch:char;
    res:boolean;
    tvideo:array[1..481] of byte;
begin
res:=false;
for k:=1600 to 2080 do tvideo[k-1599]:=mem[$b800:k];
if length(txt)>64 then delete(txt,64,(length(txt)-63));
thelp:=helpmsg;
helpmsg:=help;
DrawHelpMsg;
textcolor(col);
for i:=40-((length(txt)) div 2)-1 to 39+((length(txt)) div 2)+1 do
begin
gotoxy(i,11);
write('Õ');
gotoxy(i,12);
write(' ');
gotoxy(i,13);
write('Õ');
end;
gotoxy(40-((length(txt)) div 2)-2,11);
write('…');
gotoxy(40-((length(txt)) div 2)-2,12);
write('∫');
gotoxy(40-((length(txt)) div 2)-2,13);
write('»');
gotoxy(39+((length(txt)) div 2)+2,11);
write('ª');
gotoxy(39+((length(txt)) div 2)+2,12);
write('∫');
gotoxy(39+((length(txt)) div 2)+2,13);
write('º');
gotoxy(40-((length(title)) div 2),11);
writeln(title);
gotoxy(40-((length(txt)) div 2),12);
writeln(txt);
tch:='?';
while (tch<>'Y') and (tch<>'N') do
begin
BounceKeys;
tch:=Readkey2;
end;
if tch='Y' then res:=true;
reload:=0;
helpmsg:=' ';
for k:=1600 to 2080 do mem[$b800:k]:=tvideo[k-1599];
pressed:=keydl*4;
Confirm:=res;
end;
{--------------------------------------------------------------------------}
procedure Copy;
var tempstr:string;
    tsngptr:longint;
    tarr:array[1..4] of char;
label skip;
begin
if (blxs=0) and (blxe=0) then
begin
Message('ERROR','No selection',5,'No regions are marked');
goto skip;
end;
drumrec:=0;
if blxs=drumchn then drumrec:=1;
tsngptr:=songptr;
songptr:=1+blys*(columns*4);
captsize:=0;
for i:=1 to 1+(blye-blys) do
begin
tempstr:=getchn(blxs);
clipb[i,1]:=tempstr[1];
clipb[i,2]:=tempstr[2];
clipb[i,3]:=tempstr[3];
clipb[i,4]:=tempstr[4];
songptr:=songptr+(columns*4);
inc(captsize);
end;
songptr:=tsngptr;
skip:
pressed:=keydl*2;
end;
{--------------------------------------------------------------------------}
procedure Cut;
var tempstr:string;
    tsngptr:longint;
    tarr:array[1..4] of char;
label skip;
begin
if (blxs=0) and (blxe=0) then
begin
Message('ERROR','No selection',5,'No regions are marked');
goto skip;
end;
drumrec:=0;
if blxs=drumchn then drumrec:=1;
tsngptr:=songptr;
songptr:=1+blys*(columns*4);
captsize:=0;
for i:=1 to 1+(blye-blys) do
begin
tempstr:=getchn(blxs);
clipb[i,1]:=tempstr[1];
clipb[i,2]:=tempstr[2];
clipb[i,3]:=tempstr[3];
clipb[i,4]:=tempstr[4];
songptr:=songptr+(columns*4);
inc(captsize);
end;
songptr:=1+blys*(columns*4);
for i:=1 to 1+(blye-blys) do
begin
writechn(blxs,'    ');
songptr:=songptr+(columns*4);
end;
songptr:=tsngptr;
skip:
pressed:=keydl*2;
end;
{--------------------------------------------------------------------------}
procedure TransUp(hto:integer);
var tempstr:string;
    tsngptr:longint;
    tarr:array[1..4] of char;
label skip,wit;
begin
if (blxs=0) and (blxe=0) then
begin
Message('ERROR','No selection',5,'No regions are marked');
goto skip;
end;
tsngptr:=songptr;
for k:=1 to hto do
begin
songptr:=1+blys*(columns*4);
songptr:=1+blys*(columns*4);
for i:=1 to 1+(blye-blys) do
begin
tempstr:=getchn(blxs);
tarr[1]:=tempstr[1];
tarr[2]:=tempstr[2];
tarr[3]:=tempstr[3];
tarr[4]:=tempstr[4];
if (tempstr[1]='C') and (tempstr[2]=' ') then begin
                                              tarr[1]:='C';
                                              tarr[2]:='#';
                                              goto wit;
                                              end;
if (tempstr[1]='C') and (tempstr[2]='#') then begin
                                              tarr[1]:='D';
                                              tarr[2]:=' ';
                                              goto wit;
                                              end;
if (tempstr[1]='D') and (tempstr[2]=' ') then begin
                                              tarr[1]:='D';
                                              tarr[2]:='#';
                                              goto wit;
                                              end;
if (tempstr[1]='D') and (tempstr[2]='#') then begin
                                              tarr[1]:='E';
                                              tarr[2]:=' ';
                                              goto wit;
                                              end;
if (tempstr[1]='E') and (tempstr[2]=' ') then begin
                                              tarr[1]:='F';
                                              tarr[2]:=' ';
                                              goto wit;
                                              end;
if (tempstr[1]='F') and (tempstr[2]=' ') then begin
                                              tarr[1]:='F';
                                              tarr[2]:='#';
                                              goto wit;
                                              end;
if (tempstr[1]='F') and (tempstr[2]='#') then begin
                                              tarr[1]:='G';
                                              tarr[2]:=' ';
                                              goto wit;
                                              end;
if (tempstr[1]='G') and (tempstr[2]=' ') then begin
                                              tarr[1]:='G';
                                              tarr[2]:='#';
                                              goto wit;
                                              end;
if (tempstr[1]='G') and (tempstr[2]='#') then begin
                                              tarr[1]:='A';
                                              tarr[2]:=' ';
                                              goto wit;
                                              end;
if (tempstr[1]='A') and (tempstr[2]=' ') then begin
                                              tarr[1]:='A';
                                              tarr[2]:='#';
                                              goto wit;
                                              end;
if (tempstr[1]='A') and (tempstr[2]='#') then begin
                                              tarr[1]:='B';
                                              tarr[2]:=' ';
                                              goto wit;
                                              end;
if (tempstr[1]='B') and (tempstr[2]=' ') then begin
                                              tarr[1]:='C';
                                              tarr[2]:=' ';
                                              if tarr[3]<>'7' then tarr[3]:=chr(ord(tarr[3])+1);
                                              goto wit;
                                              end;
wit:
writechn(blxs,tarr);
songptr:=songptr+(columns*4);
end;
end;
songptr:=tsngptr;
skip:
pressed:=keydl*2;
end;
{--------------------------------------------------------------------------}
procedure TransDown(hto:integer);
var tempstr:string;
    tsngptr:longint;
    tarr:array[1..4] of char;
label skip,wit;
begin
if (blxs=0) and (blxe=0) then
begin
Message('ERROR','No selection',5,'No regions are marked');
goto skip;
end;
tsngptr:=songptr;
for k:=1 to hto do
begin
songptr:=1+blys*(columns*4);
songptr:=1+blys*(columns*4);
for i:=1 to 1+(blye-blys) do
begin
tempstr:=getchn(blxs);
tarr[1]:=tempstr[1];
tarr[2]:=tempstr[2];
tarr[3]:=tempstr[3];
tarr[4]:=tempstr[4];
if (tempstr[1]='C') and (tempstr[2]=' ') then begin
                                              tarr[1]:='B';
                                              tarr[2]:=' ';
                                              if tarr[3]<>'0' then tarr[3]:=chr(ord(tarr[3])-1);
                                              goto wit;
                                              end;
if (tempstr[1]='C') and (tempstr[2]='#') then begin
                                              tarr[1]:='C';
                                              tarr[2]:=' ';
                                              goto wit;
                                              end;
if (tempstr[1]='D') and (tempstr[2]=' ') then begin
                                              tarr[1]:='C';
                                              tarr[2]:='#';
                                              goto wit;
                                              end;
if (tempstr[1]='D') and (tempstr[2]='#') then begin
                                              tarr[1]:='D';
                                              tarr[2]:=' ';
                                              goto wit;
                                              end;
if (tempstr[1]='E') and (tempstr[2]=' ') then begin
                                              tarr[1]:='D';
                                              tarr[2]:='#';
                                              goto wit;
                                              end;
if (tempstr[1]='F') and (tempstr[2]=' ') then begin
                                              tarr[1]:='E';
                                              tarr[2]:=' ';
                                              goto wit;
                                              end;
if (tempstr[1]='F') and (tempstr[2]='#') then begin
                                              tarr[1]:='F';
                                              tarr[2]:=' ';
                                              goto wit;
                                              end;
if (tempstr[1]='G') and (tempstr[2]=' ') then begin
                                              tarr[1]:='F';
                                              tarr[2]:='#';
                                              goto wit;
                                              end;
if (tempstr[1]='G') and (tempstr[2]='#') then begin
                                              tarr[1]:='G';
                                              tarr[2]:=' ';
                                              goto wit;
                                              end;
if (tempstr[1]='A') and (tempstr[2]=' ') then begin
                                              tarr[1]:='G';
                                              tarr[2]:='#';
                                              goto wit;
                                              end;
if (tempstr[1]='A') and (tempstr[2]='#') then begin
                                              tarr[1]:='A';
                                              tarr[2]:=' ';
                                              goto wit;
                                              end;
if (tempstr[1]='B') and (tempstr[2]=' ') then begin
                                              tarr[1]:='A';
                                              tarr[2]:='#';
                                              goto wit;
                                              end;
wit:
writechn(blxs,tarr);
songptr:=songptr+(columns*4);
end;
end;
songptr:=tsngptr;
skip:
pressed:=keydl*2;
end;
{--------------------------------------------------------------------------}
procedure Paste;
var tempstr:string;
    tsngptr:longint;
    tarr:array[1..4] of char;
label skip;
begin
if captsize=0 then
begin
Message('ERROR','Nothing to paste',5,'Nothing has been copied to the clipboard');
goto skip;
end;
if (drumrec=0) and (crx=drumchn) then
begin
Message('ERROR','Channel type mismatch',5,'Notes cannot be put in the percussion channel');
goto skip;
end;
if (drumrec=1) and (crx<>drumchn) then
begin
Message('ERROR','Channel type mismatch',5,'Drums cannot be put in a musical channel');
goto skip;
end;
tsngptr:=songptr;
for i:=1 to captsize do
begin
tarr[1]:=clipb[i,1];
tarr[2]:=clipb[i,2];
tarr[3]:=clipb[i,3];
tarr[4]:=clipb[i,4];
WriteChn(crx,tarr);
songptr:=songptr+(columns*4);
if songptr>maxptr then songptr:=maxptr;
end;
songptr:=tsngptr;
skip:
pressed:=keydl*2;
end;
{--------------------------------------------------------------------------}
procedure HandleBlock;
label lb1;
begin
while (Key_Alt=true) do
begin
helpmsg:='B:Begin, C:Copy, V:Paste, X:Cut, D:Dispose, T:Transpose';
DrawHelpMsg;
Drawportion(songptr);
BounceKeys;
if pressed=0 then
begin
while (key_T=true) do
begin
helpmsg:='+:1 halftone up, -:1 halftone down, *:1 octave up, /:1 octave down';
DrawHelpMsg;
Drawportion(songptr);
BounceKeys;
if pressed=0 then
begin
if (pad_plus=true) then TransUp(1);
if (pad_mul=true) then TransUp(12);
if (pad_minus=true) then TransDown(1);
if (key_slash=true) then TransDown(12);
end;
end;
if (Key_C=true) then Copy;
if (Key_X=true) then Cut;
if (Key_D=true) then
begin
pressed:=keydl*2;
blxs:=0;
blys:=0;
blxe:=0;
blye:=0;
end;
if (Key_V=true) then Paste;
end;
if (Key_B=true) then
begin
blxs:=crx;
blys:=songptr div (columns*4);
blxe:=blxs;
blye:=blys;
drawingblock:=1;
goto lb1;
end;
end;
lb1:
while (drawingblock=1) do
begin
BounceKeys;
MoveAround;
crx:=blxs;
if (songptr div (columns*4))>=blys then blye:=(songptr div (columns*4));
if (songptr div (columns*4))<blys then songptr:=songptr+columns*4;
helpmsg:='E:End';
DrawHelpMsg;
Drawportion(songptr);
if (Key_E=true) then
begin
pressed:=keydl*2;
drawingblock:=0;
end;
end;
end;
{--------------------------------------------------------------------------}
procedure HandleFX;            {END/STOP=inf.loop, END/Loop=inf. loop(w/song)}
var tms:array[1..4] of char;
begin
while(Key_Ctrl=true) do
begin
helpmsg:='V:Volume FX, P:Pitch FX, N:Note cut, S:Speed change, E:End, F:Flags, L:Loops';
DrawHelpMsg;
Drawportion(songptr);
BounceKeys;
if pressed=0 then
begin
 while(Key_V=true) do
 begin
 helpmsg:='+:Slide up, -:Slide down, *:Fast slide up, /:Fast slide down, 0-9:Volume change';
 DrawHelpMsg;
 Drawportion(songptr);
 BounceKeys;
 if pressed=0 then
 begin
 if Pad_Plus then
 begin
 pressed:=keydl*2;
 tms:='VOL'+chr(24);
 writechn(crx,tms);
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Pad_Minus then
 begin
 pressed:=keydl*2;
 tms:='VOL'+chr(25);
 writechn(crx,tms);
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_Slash then
 begin
 pressed:=keydl*2;
 writechn(crx,'VOLù');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Pad_Mul then
 begin
 pressed:=keydl*2;
 writechn(crx,'VOLú');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_0 then
 begin
 pressed:=keydl*2;
 writechn(crx,'VOL0');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_1 then
 begin
 pressed:=keydl*2;
 writechn(crx,'VOL1');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_2 then
 begin
 pressed:=keydl*2;
 writechn(crx,'VOL2');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_3 then
 begin
 pressed:=keydl*2;
 writechn(crx,'VOL3');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_4 then
 begin
 pressed:=keydl*2;
 writechn(crx,'VOL4');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_5 then
 begin
 pressed:=keydl*2;
 writechn(crx,'VOL5');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_6 then
 begin
 pressed:=keydl*2;
 writechn(crx,'VOL6');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_7 then
 begin
 pressed:=keydl*2;
 writechn(crx,'VOL7');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_8 then
 begin
 pressed:=keydl*2;
 writechn(crx,'VOL8');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_9 then
 begin
 pressed:=keydl*2;
 writechn(crx,'VOL9');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
end;
 end;
 {}
 while(Key_P=true) do
 begin
 helpmsg:='+:Slide up, -:Slide down, *:Fast slide up, /:Fast slide down';
 DrawHelpMsg;
 Drawportion(songptr);
 BounceKeys;
 if pressed=0 then
 begin
 if Pad_Plus then
 begin
 pressed:=keydl*2;
 tms:='FRQ'+chr(24);
 writechn(crx,tms);
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Pad_Minus then
 begin
 pressed:=keydl*2;
 tms:='FRQ'+chr(25);
 writechn(crx,tms);
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_Slash then
 begin
 pressed:=keydl*2;
 writechn(crx,'FRQù');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Pad_Mul then
 begin
 pressed:=keydl*2;
 writechn(crx,'FRQú');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
end;
 end;
 {}
 while(Key_S=true) do
 begin
 helpmsg:='1-9:Speed change';
 DrawHelpMsg;
 Drawportion(songptr);
 BounceKeys;
 if pressed=0 then
 begin
 if Key_1 then
 begin
 pressed:=keydl*2;
 writechn(crx,'SPD1');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_2 then
 begin
 pressed:=keydl*2;
 writechn(crx,'SPD2');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_3 then
 begin
 pressed:=keydl*2;
 writechn(crx,'SPD3');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_4 then
 begin
 pressed:=keydl*2;
 writechn(crx,'SPD4');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_5 then
 begin
 pressed:=keydl*2;
 writechn(crx,'SPD5');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_6 then
 begin
 pressed:=keydl*2;
 writechn(crx,'SPD6');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_7 then
 begin
 pressed:=keydl*2;
 writechn(crx,'SPD7');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_8 then
 begin
 pressed:=keydl*2;
 writechn(crx,'SPD8');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_9 then
 begin
 pressed:=keydl*2;
 writechn(crx,'SPD9');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 end;
 end;
 {}
 while(Key_L=true) do
 begin
 helpmsg:='S:Set loopback point, 0:Infinite loop, 1-9:Repeat "n" times';
 DrawHelpMsg;
 Drawportion(songptr);
 BounceKeys;
 if pressed=0 then
 begin
 if Key_S then
 begin
 pressed:=keydl*2;
 writechn(crx,'SETô');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_0 then
 begin
 pressed:=keydl*2;
 writechn(crx,'REPü');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_1 then
 begin
 pressed:=keydl*2;
 writechn(crx,'REP1');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_2 then
 begin
 pressed:=keydl*2;
 writechn(crx,'REP2');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_3 then
 begin
 pressed:=keydl*2;
 writechn(crx,'REP3');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_4 then
 begin
 pressed:=keydl*2;
 writechn(crx,'REP4');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_5 then
 begin
 pressed:=keydl*2;
 writechn(crx,'REP5');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_6 then
 begin
 pressed:=keydl*2;
 writechn(crx,'REP6');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_7 then
 begin
 pressed:=keydl*2;
 writechn(crx,'REP7');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_8 then
 begin
 pressed:=keydl*2;
 writechn(crx,'REP8');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_9 then
 begin
 pressed:=keydl*2;
 writechn(crx,'REP9');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 end;
 end;
 {}
 while(Key_F=true) do
 begin
 helpmsg:='T:Set tremolo=HI, V:Set vibrato=HI, R:Set tremolo=LO, C:Set vibrato=LO';
 DrawHelpMsg;
 Drawportion(songptr);
 BounceKeys;
 if pressed=0 then
 begin
 if Key_T then
 begin
 pressed:=keydl*2;
 writechn(crx,'TRMö');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_V then
 begin
 pressed:=keydl*2;
 writechn(crx,'VIBö');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_R then
 begin
 pressed:=keydl*2;
 writechn(crx,'TRMõ');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 if Key_C then
 begin
 pressed:=keydl*2;
 writechn(crx,'VIBõ');
 songptr:=songptr+(columns*4);
 if songptr>maxptr then songptr:=maxptr;
 end;
 end;
 end;
if Key_N then
begin
pressed:=keydl*2;
writechn(crx,'NTEò');
songptr:=songptr+(columns*4);
if songptr>maxptr then songptr:=maxptr;
end;
if Key_E then
begin
pressed:=keydl*2;
writechn(crx,'ENDû');
songptr:=songptr+(columns*4);
if songptr>maxptr then songptr:=maxptr;
end;
end;
end;
end;
{--------------------------------------------------------------------------}
procedure MuteCtrl;
begin
if (pressed=0) then
begin
if Key_M=true then begin pressed:=keydl*3; ChMt[crx]:=1-ChMt[crx]; end;
end;
end;
{--------------------------------------------------------------------------}
label resta;
begin
InitMux;
TextMode(13);
Pal(1,0,0,20);
Pal(4,20,20,20);
Pal(5,48,0,0);
Pal(59,0,48,0);
Pal(56,12,12,12);
Pal(57,0,0,32);
Pal(61,48,32,0);
Pal(60,0,0,48);
Pal(63,56,56,56);
KeysOn;
textbackground(0);
clrscr;
ScrOn;
SelectIorB(0);
LoadFont('fmtrackr.fnt',cradr);
Copyfont(cradr,0);
delay(100);
blasttextcursor;
InitFM;
for i:=1 to 9 do instype[i]:=0;
blxs:=0;
blxe:=0;
blys:=0;
w2loc:=1;
blye:=0;
windw:=1;
drawingblock:=0;
subsl:=0;
crspeed:=5;
drumchn:=6;
frames:=400;
columns:=6;
octave:=4;
inst:=1;
captsize:=0;
prevalt:=0;
crx:=1;
songptr:=1;
clrscr;
quit:=false;
playing:=false;
pressed:=0;
resta:
DrawPanel;
while (quit=false) do
begin
helpmsg:=' ';
if crx<>drumchn then helpmsg:='CDEFGAB:notes (Shift:#), Ctrl:FX, Alt:Block, 0-7:Octave, I:Ins, M:Mute, TAB:Win';
if (crx=drumchn) and (subsl=0) then helpmsg:='SPACE:Toggle bass drum, Alt:Block, 0-7:Octave, I:Ins, M:Mute, TAB:Window';
if (crx=drumchn) and (subsl=1) then helpmsg:='SPACE:Toggle snare, Alt:Block, 0-7:Octave, I:Ins, M:Mute, TAB:Window';
if (crx=drumchn) and (subsl=2) then helpmsg:='SPACE:Toggle open hi-hat, Alt:Block, 0-7:Octave, I:Ins, M:Mute, TAB:Window';
if (crx=drumchn) and (subsl=3) then helpmsg:='SPACE:Toggle closed hi-hat, Alt:Block, 0-7:Octave, I:Ins, M:Mute, TAB:Window';
if (crx=drumchn) and (subsl=4) then helpmsg:='SPACE:Toggle crash cymbal, Alt:Block, 0-7:Octave, I:Ins, M:Mute, TAB:Window';
if (crx=drumchn) and (subsl=5) then helpmsg:='SPACE:Toggle reverse cymbal, Alt:Block, 0-7:Octave, I:Ins, M:Mute, TAB:Window';
if playing=true then
begin
MakePlayMess;
end;
DrawHelpMsg;
drawportion(songptr);
if (not playing) and (Key_f8=true) then StopFm;
if playing then
begin
UpdTime;
readframe;
for i:=1 to ((10-crspeed)*5) do
begin
delay(2);
SlideFreQs;
if key_f8=true then
begin
drawportion(songptr);
playing:=false;
StopFm;
break;
end;
end;
end;
BounceKeys;
if (Key_Esc=true) and (pressed=0) then begin pressed:=keydl; quit:=true; end;
if playing=true then pressed:=0;
if playing=false then
begin
MuteCtrl;
EnterDrums;
EnterNotes;
InsDelLines;
MoveAround;
HandleBlock;
HandleFX;
SelectOctave;
SelectInstrument;
if Key_f5=true then begin playing:=true; ResTime; crtimes:=0; end;
MenuFns;
end;
if (key_tab=true) and (pressed=0) then
begin
windw:=2;
pressed:=keydl*4;
drawportion(songptr);
StopFm;
playing:=false;
end;
while(windw=2) do
begin
helpmsg:='Alt '+chr(27)+chr(26)+':Change, 0-7:Octave, I:Instrument, M:Mute, TAB:Window';
{}
if w2loc=21 then helpmsg:='Alt '+chr(27)+chr(26)+':Change icon, Enter:Edit, 0-7:Octave, I:Instrument, M:Mute, TAB:Window';
if w2loc=26 then helpmsg:='Alt '+chr(24)+chr(25)+':Scroll, 0-7:Octave, I:Instrument, M:Mute, TAB:Window';
{}
BounceKeys;
SelectOctave;
SelectInstrument;
MuteCtrl;
MenuFns;
if (not playing) and (Key_f8=true) then StopFm;
if (Key_f5=true) and (pressed=0) then
begin
crtimes:=0;
playing:=true;
ResTime;
windw:=1;
pressed:=keydl*4;
end;
if (key_tab=true) and (pressed=0) then
begin
windw:=1;
pressed:=keydl*4;
end;
if (pressed=0) and (Key_Esc=true) then begin pressed:=keydl; quit:=true; windw:=1; end;
DrawHelpMsg;
drawportion(songptr);
end;
end;
StopFM;
 if (Confirm('CONFIRM','Are you sure you want to exit FM Tracker (Y/N) ?',
    15,'Y:Yes, N:No'))=false then begin quit:=false; goto resta; end;
ScrOff;
KeysOff;
TextMode(13);
DeInitMux;
end.
{COMING UP:

-HELP FUNCTION
-MORE DEMO SONGS
? POSSIBLE : MOUSE SUPPORT (ARMOUSE.TPU)
? POSSIBLE : ADDITION OF INSTRUMENT ICONS
? POSSIBLE : ADDITION OF DIR&FILE SELECTION BOXES
? POSSIBLE : SWITCH TO EGA-MODE (CHARWIDTH=8)
}

