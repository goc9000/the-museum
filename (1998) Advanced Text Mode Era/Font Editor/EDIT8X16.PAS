uses TextFont,Dos,Crt,Fontsdef,windos,strings;
const titlestring='EDITOR FONTURI 8X16 DE D.C.M. SOFT - ';
type stri=array[0..12] of char;
var i,j,k:integer;
    active:byte;
{    finfo:array[0..200] of string;}
    cletr:array[0..8,0..15] of byte;
    clipb:array[0..8,0..15] of byte;
    show:integer;
    dirs:array[1..50] of string;
    files:array[1..50] of string;
    time2die:boolean;
    fontfnam:string;
    x,y:byte;
    temps,temps2:string;
    ku:byte;
    c:byte;
    ch:char;
procedure DrawInfo(whr:word);forward;
procedure Updateclip;forward;
procedure EditMenu;forward;
procedure FXMenu;forward;
procedure AFXMenu;forward;
{----------------------------------------------------------------------------}
procedure InitPrg;
begin
Setlines(1);
TextMode(3);
delay(500);
ScrOn;
BlastTextCursor;
for i:=0 to 4095 do MEM[gradr:i]:=ORIGIFONT[i];
CopyFont(gradr,0);
for i:=0 to 4095 do MEM[gradr:i]:=INTERFONT[i];
CopyFont(gradr,1);
for i:=0 to 4095 do MEM[cradr:i]:=ORIGIFONT[i];
CopyFont(cradr,2);
SelectFonts(0,1);
SelectIorB(BIntensity);
SetBorder(0);
BlastTextCursor;
Pal(57,16,16,63);
Pal(62,50,50,50);
Pal(1,40,40,40);
Pal(2,48,48,48);
Pal(59,40,40,40);
Pal(3,56,56,56);
Pal(4,63,63,63);
Pal(60,48,0,0);
Pal(61,0,0,0);
show:=0;
for i:=0 to 1999 do MEMW[vaddr:i*2]:=0;
end;
{----------------------------------------------------------------------------}
procedure SaveUndo;
begin
for i:=0 to 4095 do MEM[unadr:i]:=MEM[cradr:i];
end;
procedure ExecUndo;
var tem:byte;
begin
for i:=0 to 4095 do
begin
tem:=MEM[cradr:i];
MEM[cradr:i]:=MEM[unadr:i];
MEM[unadr:I]:=tem;
end;
end;

procedure statusline(sst:string;whr:word);
var ta:byte;
begin
ta:=textattr;
textbackground(7);
textcolor(13);
gotoxy(2,21);
writest(sst,whr);
while wherex<79 do writest(' ',whr);
textattr:=ta;
end;

procedure menuinfo(sst:string;whr:word);
var ta:byte;
begin
ta:=textattr;
textbackground(7);
textcolor(8);
gotoxy(34,2);
writest('³',whr);
textcolor(13);
while wherex<(79-length(sst)) do writest(' ',whr);
writest(sst,whr);
textattr:=ta;
end;

procedure DrawLetters(wher:word);
begin
if show=1 then SelectFonts(2,1)
          else SelectFonts(0,1);
BlastTextCursor;
TextBackGround(0);
k:=0;
for j:=0 to 15 do
begin
for i:=0 to 15 do
begin
GotoXy(25+i,4+j);
if k=c then TextColor(4)
       else TextColor(1);
if (k>191) and (k<224) then
begin
if k=c then TextColor(4)
       else TextColor(2);
end;
writech(chr(k),wher);
k:=k+1;
end;
end;
end;
{----------------------------------------------------------------------------}
procedure DrawXtraInfo(where:word);
begin
temps:='';
str(x,temps);
temps2:='COORDONATE: X=0'+temps+', Y=';
str(y,temps);
if y<10 then temps:='0'+temps;
temps2:=temps2+temps;
str(c,temps);
temps2:=temps2+'; ASCII=';
if c<100 then temps2:=temps2+'0';
if c<10 then temps2:=temps2+'0';
temps2:=temps2+temps+' ';
if (c<32) then temps2:=temps2+'(SISTEM)'
          else
          begin
          if (c>191) and (c<224) then temps2:=temps2+'(EXTINS)'
                                 else temps2:=temps2+'(NORMAL)'
          end;
menuinfo(temps2,where);
end;

procedure DrawMainMenu;
begin
DrawMenu(1,2,79,7,vaddr);
DrawBut(02,2,9,7,9,' FIsIERE ',2,false,vaddr);
DrawBut(11,2,9,7,9,' EDITARE ',2,false,vaddr);
DrawBut(20,2,8,7,9,' LITERa ',2,false,vaddr);
DrawBut(28,2,6,7,9,' FONT ',3,false,vaddr);
DrawXtraInfo(vaddr);
end;

procedure DrawGrid(whr:word);
begin
for i:=0 to 15 do
begin
for j:=0 to 8 do
begin
if (i=y) and (j=x) then Textcolor(15)
               else Textcolor(11+(cletr[j,i]*3)); {11}
if cletr[j,i]=1 then
begin
gotoxy(4+j*2,4+i);
writech('Ê',whr);
gotoxy(5+j*2,4+i);
writech('ä',whr);
end else
begin
gotoxy(4+j*2,4+i);
writech('É',whr);
gotoxy(5+j*2,4+i);
writech('ã',whr);
end;
end;
end;
end;
{----------------------------------------------------------------------------}
procedure Updateletter;
var sloc:integer;
    bait:integer;
    res:byte;
begin
for j:=0 to 15 do
    for i:=0 to 8 do
        cletr[i,j]:=0;
sloc:=c*16;
for j:=0 to 15 do
begin
bait:=MEM[cradr:(sloc+j)];
for i:=0 to 7 do
begin
res:=bait mod 2;
cletr[7-i,j]:=res;
bait:=bait div 2;
end;
if (c>((12*16)-1)) and (c<(14*16)) then cletr[8,j]:=cletr[7,j];
end;
end;
{----------------------------------------------------------------------------}
procedure RUpdateletter;
var sloc:integer;
    bait:integer;
    res:byte;
begin
sloc:=c*16;
for j:=0 to 15 do
begin
bait:=0;
if cletr[0,j]=1 then bait:=bait+128;
if cletr[1,j]=1 then bait:=bait+64;
if cletr[2,j]=1 then bait:=bait+32;
if cletr[3,j]=1 then bait:=bait+16;
if cletr[4,j]=1 then bait:=bait+8;
if cletr[5,j]=1 then bait:=bait+4;
if cletr[6,j]=1 then bait:=bait+2;
if cletr[7,j]=1 then bait:=bait+1;
MEM[cradr:(sloc+j)]:=bait;
end;
end;
{----------------------------------------------------------------------------}
procedure Updateclip;
var sloc:integer;
    bait:integer;
    res:byte;
begin
sloc:=255*16;
for j:=0 to 15 do
begin
bait:=0;
if cletr[0,j]=1 then bait:=bait+128;
if cletr[1,j]=1 then bait:=bait+64;
if cletr[2,j]=1 then bait:=bait+32;
if cletr[3,j]=1 then bait:=bait+16;
if cletr[4,j]=1 then bait:=bait+8;
if cletr[5,j]=1 then bait:=bait+4;
if cletr[6,j]=1 then bait:=bait+2;
if cletr[7,j]=1 then bait:=bait+1;
MEM[gradr:(sloc+j)]:=bait;
end;
waitR1;
CopyFont(gradr,1);
BlastTextCursor;
end;
{----------------------------------------------------------------------------}
procedure DrawScr;
begin
WDrawBox(1,1,80,21,14,0,9,14,(titlestring+fontfnam),vaddr);
DrawMenu(1,21,79,7,vaddr);
DrawBox(3,3,22,20,11,9,0,vaddr);
DrawBox(24,3,41,20,11,9,0,vaddr);
DrawBox(43,3,78,20,11,9,0,vaddr);
DrawMainMenu;
UpdateLetter;
DrawLetters(vaddr);
DrawGrid(vaddr);
DrawInfo(vaddr);
end;
{----------------------------------------------------------------------------}
procedure DrawMScr(where:word);
begin
if active=0 then
begin
DrawEBox(3,3,22,20,15,9,0,where);
DrawEBox(24,3,41,20,11,9,0,where);
end else
begin
DrawEBox(3,3,22,20,11,9,0,where);
DrawEBox(24,3,41,20,15,9,0,where);
end;
DrawLetters(saddr);
DrawGrid(saddr);
{DrawInfo;}
end;

{----------------------------------------------------------------------------}
procedure FileDialog1;
var homep:pchar;
    homepath:string;
    f:file of byte;
    activep:integer;
    numdirs:integer;
    numfiles:integer;
    DirInf: TSearchRec;
    scrl_pos,fscrl_pos,dirs_pos,files_pos:integer;
    ts1,ts2,ts3:string;
    fs:longint;
    tpos:integer;
    dun:boolean;
    Ps: PathStr;
    Ds: DirStr;
    Ns: NameStr;
    Es: ExtStr;

procedure DrawLeftPanel;
begin
gotoxy(51,6);
if scrl_pos>1 then write(chr(24)) else write(' ');
gotoxy(51,19);
if numdirs>(scrl_pos+11) then write(chr(25)) else write(' ');
for i:=0 to 11 do
begin
gotoxy(45,7+i);
if (i+scrl_pos)<=numdirs then
begin
if (activep=1) and (dirs_pos=i+scrl_pos) then textbackground(5);
if dirs[i+scrl_pos,1]='.' then
begin
textcolor(14);
write('<..   PaRINTE>');
textcolor(15);
end
else
begin
write('<');
ps:=dirs[i+scrl_pos];
FSplit(Ps, Ds, Ns, Es);
write(ns);for j:=1 to 8-length(ns) do write(' ');
if es='' then write(' ');
write(es);
while wherex<58 do write(' ');
write('>');
end;
end
else
write('              ');
textbackground(0);
end;
end;

procedure DrawRightPanel;
begin
gotoxy(67,6);
if fscrl_pos>1 then write(chr(24)) else write(' ');
gotoxy(67,19);
if numfiles>(fscrl_pos+11) then write(chr(25)) else write(' ');

for i:=0 to 11 do
begin
gotoxy(62,7+i);
if (i+fscrl_pos)<=numfiles then
begin
if (activep=2) and (files_pos=i+fscrl_pos) then textbackground(5);

ps:=files[i+fscrl_pos];
FSplit(Ps, Ds, Ns, Es);
if es='.FNT' then textcolor(15) else textcolor(11);
write(ns);for j:=1 to 8-length(ns) do write(' ');
if es='' then write(' ');
write(es);
textcolor(15);
while wherex<74 do write(' ');
end
else
write('              ');
textbackground(0);
end;

end;

procedure Scandirs;
label pup1,pup2;
begin
fscrl_pos:=1;
files_pos:=1;
numdirs:=0;
numfiles:=0;
FindFirst('*.*', Anyfile, DirInf);
while DosError = 0 do
begin
{$I-}
   chdir(dirinf.name);
   if ioresult<>0 then
   begin
   inc(numfiles);
   files[numfiles]:=strpas(dirinf.name);
   goto pup1;
   end;
{$I+}
   chdir(homepath);
   if (dirinf.name[0]='.') and (dirinf.name[1]<>'.') then goto pup1;
   inc(numdirs);
   dirs[numdirs]:=strpas(dirinf.name);
   pup1:
   FindNext(DirInf);
end;
end;

begin
getdir(0,homepath);
WDrawBox(1,1,80,21,14,0,9,14,(titlestring+fontfnam),vaddr);
DrawMenu(1,21,79,7,vaddr);
DrawBox(3,3,22,20,11,9,0,vaddr);
DrawBox(24,3,41,20,11,9,0,vaddr);
DrawBox(43,3,78,20,15,9,0,vaddr);
DrawMainMenu;
UpdateLetter;
DrawLetters(vaddr);
DrawGrid(vaddr);
textbackground(0);
textcolor(15);
flip(vaddr,saddr,2000);
for i:=7 to 18 do
begin
gotoxy(60,i);
write('³');
end;
ScanDirs;
dirs_pos:=1;
scrl_pos:=1;
dun:=false;
activep:=1;

while dun=false do
begin
textbackground(0);
textcolor(15);
gotoxy(44,4);
ts1:=homepath;
if length(ts1)>34 then for i:=1 to 34 do ts1[i]:=ts1[length(ts1)-(34-i)];for i:=35 to length(ts1) do ts1[i]:=' ';
while length(ts1)<34 do ts1:=ts1+' ';
write(ts1);
DrawLeftPanel;
DrawRightPanel;
ch:=readkey;
if activep=1 then
begin
if ch=chr(72) then begin
                   dirs_pos:=dirs_pos-1;
                   if dirs_pos<1 then dirs_pos:=1;
                   if dirs_pos<scrl_pos then dec(scrl_pos);
                   end;
if ch=chr(80) then begin
                   dirs_pos:=dirs_pos+1;
                   if dirs_pos>numdirs then dirs_pos:=numdirs;
                   if dirs_pos>(scrl_pos+11) then inc(scrl_pos);
                   end;
if ch=chr(13) then
begin
chdir(dirs[dirs_pos]);
getdir(0,homepath);
ScanDirs;
dirs_pos:=1;
files_pos:=1;
scrl_pos:=1;
end;
end;
if activep=2 then
begin
if ch=chr(72) then begin
                   files_pos:=files_pos-1;
                   if files_pos<1 then files_pos:=1;
                   if files_pos<fscrl_pos then dec(fscrl_pos);
                   end;
if ch=chr(80) then begin
                   files_pos:=files_pos+1;
                   if files_pos>numfiles then files_pos:=numfiles;
                   if files_pos>(fscrl_pos+11) then inc(fscrl_pos);
                   end;
if ch=chr(13) then
begin
ps:=files[files_pos];
FSplit(Ps, Ds, Ns, Es);
if es='.FNT' then
begin
fontfnam:=files[files_pos];
loadfont(files[files_pos],cradr);
for c:=0 to 255 do begin
                   Updateletter;
                   Rupdateletter;
                   end;
c:=65;
updateletter;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
dun:=true;
end;
end;
end;
if (ch=chr(9)) and (numfiles>0) then
begin
activep:=3-activep;
end;
if ch=chr(27) then
begin
dun:=true;
end;
end;
end;
{----------------------------------------------------------------------------}
procedure DiskMenu;
label quitmenu;
var cpos:integer;
    hi:integer;
    gotonx:integer;
begin
gotonx:=0;
cpos:=1;
while (1=1) do
begin
DrawBut(02,2,9,10,9,' FIsIERE ',2,false,vaddr);
DrawMenuBox(2,3,17,9,14,7,7,vaddr);
if cpos=1 then statusline('eNCARCa UN FONT DE PE DISC',vaddr);
if cpos=2 then statusline('NUMEsTE sI SALVEAZa FONTUL PE DISC',vaddr);
if cpos=3 then statusline('SALVEAZa FONTUL PE DISC CU NUMELE CURENT',vaddr);
if cpos=4 then statusline('eNLOCUIEsTE LITERE DIN FONTUL CURENT CU CELE DIN ALT FONT DE PE DISC',vaddr);
if cpos=5 then statusline('REVINE eN DOS',vaddr);
if cpos=1 then hi:=10 else hi:=7;
DrawBut(03,4,14,hi,9,'eNCARCa...',0,false,vaddr);
if cpos=2 then hi:=10 else hi:=7;
DrawBut(03,5,14,hi,9,'SALVEAZa CA...',0,false,vaddr);
if cpos=3 then hi:=10 else hi:=7;
DrawBut(03,6,14,hi,9,'SALVEAZa',0,false,vaddr);
if cpos=4 then hi:=10 else hi:=7;
DrawBut(03,7,14,hi,9,'COMBINa...',0,false,vaddr);
if cpos=5 then hi:=10 else hi:=7;
DrawBut(03,8,14,hi,9,chr(28)+chr(26)+' MS-DOS',0,false,vaddr);
flip(vaddr,saddr,2000);
ch:=readkey;
if ch=chr(13) then
begin
if cpos=1 then
begin
FileDialog1;
goto quitmenu;
end;
if cpos=3 then
begin
savefont(fontfnam,cradr);
end;
if cpos=5 then
begin
time2die:=true;
goto quitmenu;
end;
end;
if ch=chr(27) then goto quitmenu;
if ch=chr(75) then begin gotonx:=1; goto quitmenu; end;
if ch=chr(77) then begin gotonx:=2; goto quitmenu; end;
if ch=chr(80) then cpos:=cpos+1;
if ch=chr(72) then cpos:=cpos-1;
if cpos>5 then cpos:=1;
if cpos<1 then cpos:=5;
end;
quitmenu:
WDrawBox(1,1,80,21,14,0,9,14,(titlestring+fontfnam),vaddr);
DrawMenu(1,21,79,7,vaddr);
if active=0 then
begin
DrawEBox(3,3,22,20,15,9,0,vaddr);
DrawEBox(24,3,41,20,11,9,0,vaddr);
end else
begin
DrawEBox(3,3,22,20,11,9,0,vaddr);
DrawEBox(24,3,41,20,15,9,0,vaddr);
end;
DrawBox(43,3,78,20,11,9,0,vaddr);
DrawInfo(vaddr);
DrawMainMenu;
DrawLetters(vaddr);
DrawGrid(vaddr);
ch:='?';
if gotonx=1 then AFXMenu;
if gotonx=2 then EditMenu;
flip(vaddr,saddr,2000);
end;
{----------------------------------------------------------------------------}
procedure EditMenu;
label quitmenu;
var cpos:integer;
    hi:integer;
    gotonx:integer;
begin
gotonx:=0;
cpos:=1;
while (1=1) do
begin
DrawBut(11,2,9,10,9,' EDITARE ',2,false,vaddr);
DrawMenuBox(11,3,21,8,14,7,7,vaddr);
if cpos=1 then statusline('COPIAZa CARACTERUL eN MEMORIE',vaddr);
if cpos=2 then statusline('PLASEAZa CARACTERUL DIN MEMORIE eN MATRICE',vaddr);
if cpos=3 then statusline('COPIAZa CARACTERUL eN MEMORIE sI sTERGE MATRICEA',vaddr);
if cpos=4 then statusline('ANULEAZa ULTIMA ACtIUNE EXECUTATa',vaddr);
if cpos=1 then hi:=10 else hi:=7;
DrawBut(12,4,9,hi,9,'COPIAZa',0,false,vaddr);
if cpos=2 then hi:=10 else hi:=7;
DrawBut(12,5,9,hi,9,'PLASEAZa',0,false,vaddr);
if cpos=3 then hi:=10 else hi:=7;
DrawBut(12,6,9,hi,9,'DECUPEAZa',0,false,vaddr);
if cpos=4 then hi:=10 else hi:=7;
DrawBut(12,7,9,hi,9,'ANULEAZa',0,false,vaddr);

flip(vaddr,saddr,2000);
ch:=readkey;
if ch=chr(13) then
begin
if cpos=1 then
begin
for i:=0 to 7 do for j:=0 to 15 do clipb[i,j]:=cletr[i,j];
Updateclip;
end;
if cpos=2 then
begin
saveundo;
for i:=0 to 7 do for j:=0 to 15 do cletr[i,j]:=clipb[i,j];
RUpdateLetter;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
end;
if cpos=3 then
begin
saveundo;
for i:=0 to 7 do for j:=0 to 15 do clipb[i,j]:=cletr[i,j];
Updateclip;
for i:=0 to 7 do for j:=0 to 15 do cletr[i,j]:=0;
RUpdateLetter;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
end;
if cpos=4 then
begin
execundo;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
end;
goto quitmenu;
end;
if ch=chr(27) then goto quitmenu;
if ch=chr(75) then begin gotonx:=1; goto quitmenu; end;
if ch=chr(77) then begin gotonx:=2; goto quitmenu; end;
if ch=chr(80) then cpos:=cpos+1;
if ch=chr(72) then cpos:=cpos-1;
if cpos>4 then cpos:=1;
if cpos<1 then cpos:=4;
end;
quitmenu:
WDrawBox(1,1,80,21,14,0,9,14,(titlestring+fontfnam),vaddr);
DrawMenu(1,21,79,7,vaddr);
if active=0 then
begin
DrawEBox(3,3,22,20,15,9,0,vaddr);
DrawEBox(24,3,41,20,11,9,0,vaddr);
end else
begin
DrawEBox(3,3,22,20,11,9,0,vaddr);
DrawEBox(24,3,41,20,15,9,0,vaddr);
end;
DrawBox(43,3,78,20,11,9,0,vaddr);
DrawInfo(vaddr);
DrawMainMenu;
DrawLetters(vaddr);
DrawGrid(vaddr);
ch:='?';
if gotonx=1 then DiskMenu;
if gotonx=2 then FXMenu;
flip(vaddr,saddr,2000);
end;
{----------------------------------------------------------------------------}
procedure FXMenu;
label quitmenu;
var cpos:integer;
    hi:integer;
    gotonx:integer;
    aorta:string;
    rotl,rotr:integer;
    pupu:array[0..15] of byte;
begin
gotonx:=0;
cpos:=1;
while (1=1) do
begin
DrawBut(20,2,8,10,9,' LITERa ',2,false,vaddr);
DrawMenuBox(20,3,34,14,14,7,7,vaddr);
if cpos=1 then statusline('eNGROAsa LITERA, CREiND O ALDINa',vaddr);
if cpos=2 then statusline('CREEAZa UN EFECT DE TREMURARE A LITEREI',vaddr);
if cpos=3 then statusline('APLEACa LITERA, CREiND O ITALICa',vaddr);
if cpos=4 then statusline('APLICa UN EFECT DE TOPIRE/SiNGERARE A LITEREI',vaddr);
if (cpos>=5) and (cpos<=8) then statusline('DEPLASEAZa LITERA, TOT CE IESE eN AFARA MATRICII SE PIERDE',vaddr);
if (cpos=9) then statusline('INVERSEAZa LITERA PE ORIZONTALa',vaddr);
if (cpos=10) then statusline('INVERSEAZa LITERA PE VERTICALa',vaddr);
if cpos=1 then hi:=10 else hi:=7;
DrawBut(21,4,13,hi,9,'eNGROAsa',0,false,vaddr);
if cpos=2 then hi:=10 else hi:=7;
DrawBut(21,5,13,hi,9,'DISRUPE',0,false,vaddr);
if cpos=3 then hi:=10 else hi:=7;
DrawBut(21,6,13,hi,9,'eNCLINa',0,false,vaddr);
if cpos=4 then hi:=10 else hi:=7;
DrawBut(21,7,13,hi,9,'TOPEsTE',0,false,vaddr);
if cpos=5 then hi:=10 else hi:=7;
aorta:='MIsCa SUS';
DrawBut(21,8,13,hi,9,aorta,0,false,vaddr);
if cpos=6 then hi:=10 else hi:=7;
aorta:='MIsCa JOS';
DrawBut(21,9,13,hi,9,aorta,0,false,vaddr);
if cpos=7 then hi:=10 else hi:=7;
aorta:='MIsCa DREAPTA';
DrawBut(21,10,13,hi,9,aorta,0,false,vaddr);
if cpos=8 then hi:=10 else hi:=7;
aorta:='MIsCa STiNGA';
DrawBut(21,11,13,hi,9,aorta,0,false,vaddr);
if cpos=9 then hi:=10 else hi:=7;
aorta:='REVERS ORIZ.';
DrawBut(21,12,13,hi,9,aorta,0,false,vaddr);
if cpos=10 then hi:=10 else hi:=7;
aorta:='REVERS VERT.';
DrawBut(21,13,13,hi,9,aorta,0,false,vaddr);
flip(vaddr,saddr,2000);
ch:=readkey;
if ch=chr(13) then
begin
SaveUndo;
if cpos=1 then
begin
for i:=7 downto 1 do for j:=0 to 15 do
begin
if cletr[i-1,j]=1 then cletr[i,j]:=1;
end;
RUpdateLetter;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
end;
if cpos=2 then
begin
for i:=7 downto 0 do for j:=0 to 7 do
begin
if i>0 then cletr[i,j*2]:=cletr[i-1,j*2];
if i=0 then cletr[i,j*2]:=0;
end;
RUpdateLetter;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
end;
if cpos=3 then
begin
for j:=0 to 15 do
begin
if (j div 3)=0 then begin rotl:=0; rotr:=2; end;
if (j div 3)=1 then begin rotl:=0; rotr:=1; end;
if (j div 3)=2 then begin rotl:=0; rotr:=0; end;
if (j div 3)=3 then begin rotl:=1; rotr:=0; end;
if (j div 3)>3 then begin rotl:=2; rotr:=0; end;
for ku:=1 to rotr do
begin
for i:=7 downto 0 do
begin
if i>0 then cletr[i,j]:=cletr[i-1,j];
if i=0 then cletr[i,j]:=0;
end;
end;
for ku:=1 to rotl do
begin
for i:=0 to 7 do
begin
if i<7 then cletr[i,j]:=cletr[i+1,j];
if i=7 then cletr[i,j]:=0;
end;
end;
end;
RUpdateLetter;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
end;
if cpos=4 then
begin
for j:=15 downto 1 do for i:=0 to 7 do
begin
if (cletr[i,j-1]=1) and (random(5)=0) then cletr[i,j]:=1;
end;
for j:=15 downto 1 do for i:=0 to 7 do
begin
if (cletr[i,j-1]=1) and (random(5)=0) then cletr[i,j]:=1;
end;
RUpdateLetter;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
end;
if cpos=5 then
begin
for j:=0 to 15 do for i:=0 to 7 do
begin
if j<15 then cletr[i,j]:=cletr[i,j+1];
if j=15 then cletr[i,j]:=0;
end;
RUpdateLetter;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
end;
if cpos=6 then
begin
for j:=15 downto 0 do for i:=0 to 7 do
begin
if j>0 then cletr[i,j]:=cletr[i,j-1];
if j=0 then cletr[i,j]:=0;
end;
RUpdateLetter;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
end;
if cpos=8 then
begin
for j:=0 to 15 do
begin
for i:=0 to 7 do
begin
if i<7 then cletr[i,j]:=cletr[i+1,j];
if i=7 then cletr[i,j]:=0;
end;
end;
RUpdateLetter;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
end;
if cpos=7 then
begin
for j:=0 to 15 do
begin
for i:=7 downto 0 do
begin
if i>0 then cletr[i,j]:=cletr[i-1,j];
if i=0 then cletr[i,j]:=0;
end;
end;
RUpdateLetter;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
end;
if cpos=9 then
begin
for j:=0 to 15 do
begin
for i:=0 to 7 do
begin
pupu[i]:=cletr[i,j];
end;
for i:=0 to 7 do
begin
cletr[i,j]:=pupu[7-i];
end;
end;
RUpdateLetter;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
end;
if cpos=10 then
begin
for i:=0 to 7 do
begin
for j:=0 to 15 do
begin
pupu[j]:=cletr[i,j];
end;
for j:=0 to 15 do
begin
cletr[i,j]:=pupu[15-j];
end;
end;
RUpdateLetter;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
end;
goto quitmenu;
end;
if ch=chr(27) then goto quitmenu;
if ch=chr(75) then begin gotonx:=1; goto quitmenu; end;
if ch=chr(77) then begin gotonx:=2; goto quitmenu; end;
if ch=chr(80) then cpos:=cpos+1;
if ch=chr(72) then cpos:=cpos-1;
if cpos>10 then cpos:=1;
if cpos<1 then cpos:=10;
end;
quitmenu:
WDrawBox(1,1,80,21,14,0,9,14,(titlestring+fontfnam),vaddr);
DrawMenu(1,21,79,7,vaddr);
if active=0 then
begin
DrawEBox(3,3,22,20,15,9,0,vaddr);
DrawEBox(24,3,41,20,11,9,0,vaddr);
end else
begin
DrawEBox(3,3,22,20,11,9,0,vaddr);
DrawEBox(24,3,41,20,15,9,0,vaddr);
end;
DrawBox(43,3,78,20,11,9,0,vaddr);
DrawInfo(vaddr);
DrawMainMenu;
DrawLetters(vaddr);
DrawGrid(vaddr);
ch:='?';
if gotonx=1 then EditMenu;
if gotonx=2 then AFXMenu;
flip(vaddr,saddr,2000);
end;
{----------------------------------------------------------------------------}
procedure AFXMenu;
label quitmenu;
var cpos:integer;
    hi:integer;
    kik:integer;
    gotonx:integer;
    aorta:string;
    rotl,rotr:integer;
    pupu:array[0..15] of byte;
begin
gotonx:=0;
cpos:=1;
while (1=1) do
begin
DrawBut(28,2,6,10,9,' FONT ',3,false,vaddr);
DrawMenuBox(28,3,42,14,14,7,7,vaddr);
if cpos=1 then statusline('eNGROAsa LITERELE, CREiND ASTFEL UN SET DE ALDINE',vaddr);
if cpos=2 then statusline('CREEAZa UN EFECT DE TREMURARE A LITERELOR',vaddr);
if cpos=3 then statusline('APLEACa LITERELE, CREiND UN SET DE ITALICE',vaddr);
if cpos=4 then statusline('APLICa UN EFECT DE TOPIRE/SiNGERARE A LITERELOR',vaddr);
if (cpos>=5) and (cpos<=8) then statusline('DEPLASEAZa LITERELE, TOT CE IESE eN AFARA MATRICII SE PIERDE',vaddr);
if (cpos=9) then statusline('INVERSEAZa LITERELE PE ORIZONTALa',vaddr);
if (cpos=10) then statusline('INVERSEAZa LITERELE PE VERTICALa',vaddr);
if cpos=1 then hi:=10 else hi:=7;
DrawBut(29,4,13,hi,9,'eNGROAsa',0,false,vaddr);
if cpos=2 then hi:=10 else hi:=7;
DrawBut(29,5,13,hi,9,'DISRUPE',0,false,vaddr);
if cpos=3 then hi:=10 else hi:=7;
DrawBut(29,6,13,hi,9,'eNCLINa',0,false,vaddr);
if cpos=4 then hi:=10 else hi:=7;
DrawBut(29,7,13,hi,9,'TOPEsTE',0,false,vaddr);
if cpos=5 then hi:=10 else hi:=7;
aorta:='MIsCa SUS';
DrawBut(29,8,13,hi,9,aorta,0,false,vaddr);
if cpos=6 then hi:=10 else hi:=7;
aorta:='MIsCa JOS';
DrawBut(29,9,13,hi,9,aorta,0,false,vaddr);
if cpos=7 then hi:=10 else hi:=7;
aorta:='MIsCa DREAPTA';
DrawBut(29,10,13,hi,9,aorta,0,false,vaddr);
if cpos=8 then hi:=10 else hi:=7;
aorta:='MIsCa STiNGA';
DrawBut(29,11,13,hi,9,aorta,0,false,vaddr);
if cpos=9 then hi:=10 else hi:=7;
aorta:='REVERS ORIZ.';
DrawBut(29,12,13,hi,9,aorta,0,false,vaddr);
if cpos=10 then hi:=10 else hi:=7;
aorta:='REVERS VERT.';
DrawBut(29,13,13,hi,9,aorta,0,false,vaddr);
flip(vaddr,saddr,2000);
ch:=readkey;
if ch=chr(13) then
begin
SaveUndo;
if cpos=1 then
begin
ku:=c;
for c:=0 to 255 do
begin
UpdateLetter;
for i:=7 downto 1 do for j:=0 to 15 do
begin
if cletr[i-1,j]=1 then cletr[i,j]:=1;
end;
RUpdateLetter;
end;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
c:=ku;
UpdateLetter;
end;
if cpos=2 then
begin
ku:=c;
for c:=0 to 255 do
begin
UpdateLetter;
for i:=7 downto 0 do for j:=0 to 7 do
begin
if i>0 then cletr[i,j*2]:=cletr[i-1,j*2];
if i=0 then cletr[i,j*2]:=0;
end;
RUpdateLetter;
end;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
c:=ku;
UpdateLetter;
end;
if cpos=3 then
begin
ku:=c;
for c:=0 to 255 do
begin
UpdateLetter;
for j:=0 to 15 do
begin
if (j div 3)=0 then begin rotl:=0; rotr:=2; end;
if (j div 3)=1 then begin rotl:=0; rotr:=1; end;
if (j div 3)=2 then begin rotl:=0; rotr:=0; end;
if (j div 3)=3 then begin rotl:=1; rotr:=0; end;
if (j div 3)>3 then begin rotl:=2; rotr:=0; end;
for kik:=1 to rotr do
begin
for i:=7 downto 0 do
begin
if i>0 then cletr[i,j]:=cletr[i-1,j];
if i=0 then cletr[i,j]:=0;
end;
end;
for kik:=1 to rotl do
begin
for i:=0 to 7 do
begin
if i<7 then cletr[i,j]:=cletr[i+1,j];
if i=7 then cletr[i,j]:=0;
end;
end;
end;
RUpdateLetter;
end;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
c:=ku;
UpdateLetter;
end;
if cpos=4 then
begin
ku:=c;
for c:=0 to 255 do
begin
UpdateLetter;
for j:=15 downto 1 do for i:=0 to 7 do
begin
if (cletr[i,j-1]=1) and (random(5)=0) then cletr[i,j]:=1;
end;
for j:=15 downto 1 do for i:=0 to 7 do
begin
if (cletr[i,j-1]=1) and (random(5)=0) then cletr[i,j]:=1;
end;
RUpdateLetter;
end;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
c:=ku;
UpdateLetter;
end;
if cpos=5 then
begin
ku:=c;
for c:=0 to 255 do
begin
UpdateLetter;
for j:=0 to 15 do for i:=0 to 7 do
begin
if j<15 then cletr[i,j]:=cletr[i,j+1];
if j=15 then cletr[i,j]:=0;
end;
RUpdateLetter;
end;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
c:=ku;
UpdateLetter;
end;
if cpos=6 then
begin
ku:=c;
for c:=0 to 255 do
begin
UpdateLetter;
for j:=15 downto 0 do for i:=0 to 7 do
begin
if j>0 then cletr[i,j]:=cletr[i,j-1];
if j=0 then cletr[i,j]:=0;
end;
RUpdateLetter;
end;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
c:=ku;
UpdateLetter;
end;
if cpos=7 then
begin
ku:=c;
for c:=0 to 255 do
begin
UpdateLetter;
for j:=0 to 15 do
begin
for i:=7 downto 0 do
begin
if i>0 then cletr[i,j]:=cletr[i-1,j];
if i=0 then cletr[i,j]:=0;
end;
end;
RUpdateLetter;
end;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
c:=ku;
UpdateLetter;
end;
if cpos=8 then
begin
ku:=c;
for c:=0 to 255 do
begin
UpdateLetter;
for j:=0 to 15 do
begin
for i:=0 to 7 do
begin
if i<7 then cletr[i,j]:=cletr[i+1,j];
if i=7 then cletr[i,j]:=0;
end;
end;
RUpdateLetter;
end;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
c:=ku;
UpdateLetter;
end;
if cpos=9 then
begin
ku:=c;
for c:=0 to 255 do
begin
UpdateLetter;
for j:=0 to 15 do
begin
for i:=0 to 7 do
begin
pupu[i]:=cletr[i,j];
end;
for i:=0 to 7 do
begin
cletr[i,j]:=pupu[7-i];
end;
end;
RUpdateLetter;
end;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
c:=ku;
UpdateLetter;
end;
if cpos=10 then
begin
ku:=c;
for c:=0 to 255 do
begin
UpdateLetter;
for i:=0 to 7 do
begin
for j:=0 to 15 do
begin
pupu[j]:=cletr[i,j];
end;
for j:=0 to 15 do
begin
cletr[i,j]:=pupu[15-j];
end;
end;
RUpdateLetter;
end;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
c:=ku;
UpdateLetter;
end;
goto quitmenu;
end;
if ch=chr(27) then goto quitmenu;
if ch=chr(75) then begin gotonx:=1; goto quitmenu; end;
if ch=chr(77) then begin gotonx:=2; goto quitmenu; end;
if ch=chr(80) then cpos:=cpos+1;
if ch=chr(72) then cpos:=cpos-1;
if cpos>10 then cpos:=1;
if cpos<1 then cpos:=10;
end;
quitmenu:
WDrawBox(1,1,80,21,14,0,9,14,(titlestring+fontfnam),vaddr);
DrawMenu(1,21,79,7,vaddr);
if active=0 then
begin
DrawEBox(3,3,22,20,15,9,0,vaddr);
DrawEBox(24,3,41,20,11,9,0,vaddr);
end else
begin
DrawEBox(3,3,22,20,11,9,0,vaddr);
DrawEBox(24,3,41,20,15,9,0,vaddr);
end;
DrawBox(43,3,78,20,11,9,0,vaddr);
DrawInfo(vaddr);
DrawMainMenu;
DrawLetters(vaddr);
DrawGrid(vaddr);
ch:='?';
if gotonx=1 then FXMenu;
if gotonx=2 then DiskMenu;
flip(vaddr,saddr,2000);
end;
{----------------------------------------------------------------------------}
procedure HandleEdit;
begin
if ch=chr(72) then if y>0 then y:=y-1;
if ch=chr(80) then if y<15 then y:=y+1;
if ch=chr(75) then if x>0 then x:=x-1;
if ch=chr(77) then if x<7 then x:=x+1;
if ch=' ' then
begin
cletr[x,y]:=1-cletr[x,y];
RUpdateLetter;
waitR1;
CopyFont(cradr,2);
BlastTextCursor;
end;
end;
{----------------------------------------------------------------------------}
procedure DrawInfo(whr:word);
var puf:string;
    undol:array[0..7,0..15] of byte;
    bait,sloc:integer;
    res:byte;
begin
for j:=0 to 15 do for i:=0 to 7 do undol[i,j]:=0;
sloc:=c*16;
for j:=0 to 15 do
begin
bait:=MEM[unadr:(sloc+j)];
for i:=0 to 7 do
begin
res:=bait mod 2;
undol[7-i,j]:=res;
bait:=bait div 2;
end;
end;
textcolor(11);
for i:=0 to 15 do
begin
for j:=0 to 7 do
begin
if clipb[j,i]=1 then
begin
gotoxy(44+j*2,4+i);
writech('Ê',whr);
gotoxy(45+j*2,4+i);
writech('ä',whr);
end else
begin
gotoxy(44+j*2,4+i);
writech('É',whr);
gotoxy(45+j*2,4+i);
writech('ã',whr);
end;
if undol[j,i]=1 then
begin
gotoxy(62+j*2,4+i);
writech('Ê',whr);
gotoxy(63+j*2,4+i);
writech('ä',whr);
end else
begin
gotoxy(62+j*2,4+i);
writech('É',whr);
gotoxy(63+j*2,4+i);
writech('ã',whr);
end;
end;
end;
textcolor(15);
gotoxy(62,5);
end;
{----------------------------------------------------------------------------}
procedure HandleTable;
begin
if ch=chr(72) then
begin
SaveUndo;
c:=c-16;
end;
if ch=chr(80) then
begin
SaveUndo;
c:=c+16;
end;
if ch=chr(75) then
begin
SaveUndo;
c:=c-1;
end;
if ch=chr(77) then
begin
SaveUndo;
c:=c+1;
end;
if ch=' ' then show:=1-show;
end;
{----------------------------------------------------------------------------}
label zend;
begin
InitPrg;
delay(400);
fontfnam:='ORIGINAL.FNT';
x:=0;
y:=0;
c:=65;
active:=0;
DrawScr;
ScrollUNToScr(vaddr);
time2die:=false;
SaveUndo;
while (1=1) do
begin
DrawMScr(saddr);
DrawXtraInfo(saddr);
DrawInfo(saddr);
if active=0 then statusline('EDITEAZa CARACTERUL CU SaGEtILE sI SPAtIU',saddr);
if (active=1) and (show=0) then statusline('ALEGE CARACTERUL CU SaGEtILE, CU SPAtIU VEZI FONTUL EDITAT',saddr);
if (active=1) and (show=1) then statusline('ALEGE CARACTERUL CU SaGEtILE, CU SPAtIU VEZI FONTUL ORIGINAL',saddr);
ch:='?';
if keypressed then ch:=readkey;
if (ch<>'?') and (port[$60]=33) then begin flip(saddr,vaddr,2000); diskmenu; end;
if (ch<>'?') and (port[$60]=18) then begin flip(saddr,vaddr,2000); editmenu; end;
if (ch<>'?') and (port[$60]=38) then begin flip(saddr,vaddr,2000); FXmenu; end;
if (ch<>'?') and (port[$60]=24) then begin flip(saddr,vaddr,2000); AFXmenu; end;
if paramcount>0 then
begin
if ch='S' then savefont(paramstr(1),cradr);
if ch='I' then begin sound(1000); loadfont(paramstr(1),cradr); nosound; end;
end;
if ch=chr(9) then active:=1-active;
if active=0 then HandleEdit;
if active=1 then HandleTable;
UpdateLetter;
if time2die=true then goto zend;
gotoxy(10,10);
{writeln(port[$60]);} {o=24}
end;
zend:
textbackground(0);
textcolor(7);
SinkScr;
ScrOff;
SetLines(2);
textmode(3);
end.