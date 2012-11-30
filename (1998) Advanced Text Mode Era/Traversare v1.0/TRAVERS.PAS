program travers;
uses crt;
type model=record sasiu:string; lung:integer; end;
     banda=record linie,smas,lmas,vitez:integer; fav:boolean;end;
const modele:array[1..20] of model=
      ((sasiu:#0' !"#$';lung:4), (sasiu:#0+'%&''( ';lung:4), {dacia}
       (sasiu:#0' ----'#0')*';lung:6), (sasiu:#0'+,'#0'---- ';lung:6), {tir}
       (sasiu:#0' --------'#0')*';lung:10), (sasiu:#0'+,'#0'-------- ';lung:10), {tir 2}
       (sasiu:#0' 6P7';lung:3), (sasiu:#0'8Q9 ';lung:3), {trabant}
       (sasiu:#0' :;';lung:2), (sasiu:#0'<= ';lung:2), {moto}
       (sasiu:#27#15'2'#2'>?@@AB';lung:6), (sasiu:#27#2'BC@@DE'#15'2';lung:6), {croco1}
       (sasiu:#27#15'2'#2'>?@@@@AB';lung:8), (sasiu:#27#2'BC@@@@DE'#15'2';lung:8), {croco2}
       (sasiu:#27#15'2'#255'O'#31'R'#27'Z';lung:3), (sasiu:#27#255'O'#31'S'#27'Z'#15'2';lung:3), {catam}
       (sasiu:#27#15'2FMGHI';lung:5), (sasiu:#27#15'JKGNL2';lung:5), {salupa}
       (sasiu:#27#15'2'#255'['#254'\\\\\\'#253'^';lung:8),
       (sasiu:#27#255'['#254'\\\\\\'#253'^'#15'2';lung:8) {canoe}
       );
       benzi:array[1..8] of banda=(
       (linie:5;smas:16;lmas:3;vitez:-2;fav:false),(linie:7;smas:11;lmas:2;vitez:1;fav:false),
       (linie:9;smas:16;lmas:3;vitez:-2;fav:false),(linie:11;smas:11;lmas:2;vitez:1;fav:false),
       (linie:15;smas:2;lmas:5;vitez:-1;fav:true),(linie:17;smas:2;lmas:5;vitez:-2;fav:true),
       (linie:19;smas:1;lmas:5;vitez:2;fav:true),(linie:21;smas:1;lmas:5;vitez:1;fav:true)
       );
const caractere:array[0..1023] of byte=(
       $00,$00,$3F,$7F,$7F,$FE,$FE,$FE,$FE,$7F,$7F,$3F,$00,$00,$00,$00,
       $00,$00,$FF,$A0,$1F,$1F,$1F,$1F,$1F,$1F,$A0,$FF,$00,$00,$00,$00,
       $00,$00,$FF,$0B,$F1,$F0,$F0,$F0,$F0,$F1,$0B,$FF,$00,$00,$00,$00,
       $00,$00,$FC,$FE,$82,$FF,$FF,$FF,$FF,$82,$FE,$FC,$00,$00,$00,$00,
       $00,$00,$3F,$7F,$41,$FF,$FF,$FF,$FF,$41,$7F,$3F,$00,$00,$00,$00,
       $00,$00,$FF,$D0,$8F,$0F,$0F,$0F,$0F,$8F,$D0,$FF,$00,$00,$00,$00,
       $00,$00,$FF,$05,$F8,$F8,$F8,$F8,$F8,$F8,$05,$FF,$00,$00,$00,$00,
       $00,$00,$FC,$FE,$FE,$7F,$7F,$7F,$7F,$FE,$FE,$FC,$00,$00,$00,$00,
       $00,$FF,$02,$FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC,$02,$FF,$00,$00,$00,
       $00,$F0,$FE,$46,$39,$3F,$3F,$3F,$3F,$39,$46,$FE,$F0,$00,$00,$00,
       $00,$0F,$7F,$62,$9C,$FC,$FC,$FC,$FC,$9C,$62,$7F,$0F,$00,$00,$00,
       $00,$FF,$40,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$40,$FF,$00,$00,$00,
       $55,$AA,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$AA,$55,$00,$00,
       $00,$00,$00,$00,$00,$40,$88,$A6,$EF,$FF,$FF,$FF,$FF,$FF,$00,$00,
       $00,$00,$00,$00,$00,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,
       $00,$00,$00,$00,$FF,$00,$00,$00,$FF,$00,$00,$00,$00,$00,$00,$00,
       $00,$00,$00,$00,$00,$70,$FD,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,
       $00,$C0,$0E,$31,$00,$0E,$95,$EA,$51,$A0,$00,$06,$09,$60,$00,$00,
       $91,$66,$38,$41,$56,$99,$E8,$0B,$8C,$34,$04,$00,$00,$00,$00,$00,
       $00,$00,$00,$00,$00,$3C,$E7,$FF,$FF,$E7,$3C,$00,$00,$00,$00,$00,
       $00,$00,$00,$3C,$E7,$FF,$FF,$E7,$3C,$00,$00,$00,$00,$00,$00,$00,
       $00,$00,$0F,$38,$47,$BF,$FF,$FF,$BF,$47,$38,$0F,$00,$00,$00,$00,
       $00,$00,$F8,$1E,$E2,$FD,$FF,$FF,$FD,$E2,$1E,$F8,$00,$00,$00,$00,
       $00,$00,$1F,$78,$47,$BF,$FF,$FF,$BF,$47,$78,$1F,$00,$00,$00,$00,
       $00,$00,$E0,$1C,$E2,$FD,$FF,$FF,$FD,$E2,$1C,$E0,$00,$00,$00,$00,
       $00,$00,$00,$00,$01,$0F,$FF,$FF,$0F,$01,$00,$00,$00,$00,$00,$00,
       $00,$00,$00,$08,$C8,$FC,$1F,$1F,$FC,$C8,$08,$00,$00,$00,$00,$00,
       $00,$00,$00,$10,$13,$3F,$F8,$F8,$3F,$13,$10,$00,$00,$00,$00,$00,
       $00,$00,$00,$00,$80,$F0,$FF,$FF,$F0,$80,$00,$00,$00,$00,$00,$00,
       $00,$00,$00,$00,$00,$0D,$FF,$FF,$0D,$00,$00,$00,$00,$00,$00,$00,
       $00,$00,$03,$01,$1B,$BF,$FF,$FF,$BF,$1B,$01,$03,$00,$00,$00,$00,
       $00,$00,$00,$99,$FF,$FF,$FF,$FF,$FF,$FF,$99,$00,$00,$00,$00,$00,
       $00,$00,$C0,$80,$EE,$F9,$FF,$FF,$F9,$EE,$80,$C0,$00,$00,$00,$00,
       $00,$00,$00,$00,$00,$5A,$FF,$FF,$5A,$00,$00,$00,$00,$00,$00,$00,
       $00,$00,$03,$01,$77,$9F,$FF,$FF,$9F,$77,$01,$03,$00,$00,$00,$00,
       $00,$00,$C0,$80,$D8,$FD,$FF,$FF,$FD,$D8,$80,$C0,$00,$00,$00,$00,
       $00,$00,$00,$00,$00,$B0,$FF,$FF,$B0,$00,$00,$00,$00,$00,$00,$00,
       $00,$0F,$3F,$7F,$7F,$FF,$FF,$FF,$FF,$7F,$7F,$3F,$0F,$00,$00,$00,
       $00,$FF,$81,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$81,$FF,$00,$00,$00,
       $00,$FE,$87,$C3,$C3,$C1,$C1,$C1,$C1,$C3,$C3,$87,$FE,$00,$00,$00,
       $00,$00,$C0,$F0,$FC,$FE,$FF,$FF,$FE,$FC,$F0,$C0,$00,$00,$00,$00,
       $00,$00,$03,$0F,$3F,$7F,$FF,$FF,$7F,$3F,$0F,$03,$00,$00,$00,$00,
       $00,$7F,$E1,$C3,$C3,$83,$83,$83,$83,$C3,$C3,$E1,$7F,$00,$00,$00,
       $00,$F0,$FC,$FE,$FE,$FF,$FF,$FF,$FF,$FE,$FE,$FC,$F0,$00,$00,$00,
       $00,$FF,$FB,$F9,$F9,$F9,$F9,$F9,$F9,$F9,$F9,$FB,$FF,$00,$00,$00,
       $00,$FF,$DF,$9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F,$DF,$FF,$00,$00,$00,
       $00,$7F,$FF,$00,$03,$07,$07,$07,$07,$03,$00,$FF,$7F,$00,$00,$00,
       $00,$00,$F0,$0B,$F1,$F0,$F0,$F0,$F0,$F1,$0B,$F0,$00,$00,$00,$00,
       $00,$00,$0F,$D0,$8F,$0F,$0F,$0F,$0F,$8F,$D0,$0F,$00,$00,$00,$00,
       $00,$CF,$E7,$20,$F1,$F1,$F1,$F1,$F1,$E3,$00,$E7,$CF,$00,$00,$00,
       $00,$F3,$E7,$04,$8F,$8F,$8F,$8F,$8F,$C7,$00,$E7,$F3,$00,$00,$00,
       $00,$00,$00,$00,$00,$55,$2A,$3E,$1C,$22,$00,$00,$00,$00,$00,$00,
       $00,$00,$00,$00,$04,$58,$34,$38,$34,$58,$04,$00,$00,$00,$00,$00,
       $00,$00,$00,$00,$10,$0D,$16,$0E,$16,$0D,$10,$00,$00,$00,$00,$00,
       $00,$00,$41,$55,$2A,$3E,$1C,$36,$22,$41,$00,$00,$00,$00,$00,$00,
       $00,$00,$00,$00,$C1,$36,$1D,$0E,$1D,$36,$C1,$00,$00,$00,$00,$00,
       $00,$00,$00,$00,$83,$6C,$B8,$70,$B8,$6C,$83,$00,$00,$00,$00,$00,
       $00,$FE,$FF,$00,$C0,$E0,$E0,$E0,$E0,$C0,$00,$FF,$FE,$00,$00,$00,
       $00,$00,$00,$00,$0F,$7D,$D5,$D5,$7D,$0F,$00,$00,$00,$00,$00,$00,
       $40,$20,$10,$EB,$D7,$C7,$DB,$DB,$C7,$D7,$EB,$10,$20,$40,$00,$00,
       $02,$04,$08,$D7,$EB,$E3,$DB,$DB,$E3,$EB,$D7,$08,$04,$02,$00,$00,
       $00,$00,$00,$00,$F0,$BE,$AB,$AB,$BE,$F0,$00,$00,$00,$00,$00,$00,
       $00,$00,$00,$00,$00,$00,$81,$81,$C1,$E7,$7E,$18,$00,$00,$00,$00,
       $00,$00,$18,$7E,$E7,$C1,$81,$81,$00,$00,$00,$00,$00,$00,$00,$00
       );
var anim,bx,by,tend,intarz,v05,i,j,k,l,m,i3,anam,anax,anad,scor,reco,vieti,timp,niv:integer;
    inam:array[1..100,1..5] of integer;
    bocup:array[1..8] of integer;
    cas:array[0..3] of boolean;
    ecran:array[0..3999] of byte;
    ecran2:array[0..3999] of byte absolute $b800:$140;
    cataplof,gata,ura:boolean;
    sun:byte;
    ch:char;
    l1,l2,calib:longint;
    anac:array[1..2,1..2] of string;
label rejoc,restart;
{----------------------------------------------------------------------------}
procedure creazmas(x,y,vit,tip:integer);
begin
for i:=1 to 100 do if inam[i,1]=0 then
begin
inam[i,1]:=tip; inam[i,2]:=x; inam[i,3]:=y; inam[i,4]:=random(65535);
inam[i,5]:=vit;
exit;
end;
end;
{----------------------------------------------------------------------------}
procedure desmasina(x,y:integer;mas:string;cul:word);
var a,an,i2:integer;
    rs:word;
begin
an:=0;
rs:=randseed;
randseed:=cul;
for i2:=1 to length(mas) do
begin
a:=ord(mas[i2]);
if (a<32) or (a>252) then
begin
if a=0 then textattr:=1+random(15);
if (a>0) and (a<16) then textattr:=(textattr and 240)+a;
if (a>15) and (a<32) then textattr:=(a-16)*16+textattr and 15;
if a=253 then an:=0;
if a=254 then an:=1;
if a=255 then textattr:=(textattr and 240)+1+random(6);
end
else begin
if a>32 then a:=a+95;
if an=1 then a:=a+anim;
if (x>0) and (x<81) then begin gotoxy(x,y); write(chr(a)); end;
if (a<>32) and (a<>145) and (x=bx) and (y=by) then cataplof:=true;
x:=x+1;
end;
end;
randseed:=rs;
end;
{----------------------------------------------------------------------------}
procedure desinam;
begin
for i:=1 to 100 do if inam[i,1]>0 then
    desmasina(inam[i,2],inam[i,3],modele[inam[i,1]].sasiu,inam[i,4]);
if anad<>0 then desmasina(anax,13,anac[(3+anad) div 2,1+anim],0);
end;
{----------------------------------------------------------------------------}
procedure setlinii(nr:byte);assembler;
asm mov ah,12h; mov bl,30h; mov al,[nr]; int 10h; end;
{----------------------------------------------------------------------------}
procedure setclipi(nr:byte);assembler;
asm mov ax,1003h; mov bl,[nr]; int 10h; end;
{----------------------------------------------------------------------------}
procedure faracursor;assembler;
asm mov ah,01h; mov ch,20h; int 10h; end;
{----------------------------------------------------------------------------}
procedure initvideo;
begin
setlinii(1); textmode(13); setclipi(0); faracursor;
end;
{----------------------------------------------------------------------------}
procedure dezinitvideo;
begin
setlinii(2); textmode(3);
end;
{----------------------------------------------------------------------------}
procedure defcar;
var fs,fo:word;
begin
fs:=seg(caractere); fo:=ofs(caractere);
asm
push bp; mov ax,1100h; mov bh,16; mov bl,0; mov cx,64; mov dx,128
mov es,[fs]; mov bp,[fo]; int 10h; pop bp; end;
end;
{----------------------------------------------------------------------------}
procedure intar(ms:integer);
var mms:integer;
begin
for mms:=1 to ms do
begin
for l1:=1 to calib*10 do;
end;
end;
{----------------------------------------------------------------------------}
procedure genanac;
var aa:integer;
    ssa,ssb:string;
begin
ssa:=''; ssb:='';
for i:=1 to (anam-3) div 2 do begin ssa:=ssa+'_`'; ssb:=ssb+'`_'; end;
anac[1,1]:=#2#26'5'+ssa+'  ';
anac[1,2]:=#2#26'4'+ssb+'  ';
anac[2,1]:=#2#26'  '+ssa+'4';
anac[2,2]:=#2#26'  '+ssb+'5';
end;
{----------------------------------------------------------------------------}
procedure urmniv;
begin
for i:=0 to 3 do cas[i]:=false;
anam:=anam+4;
if intarz>0 then intarz:=intarz-1;
genanac;
anax:=0;
niv:=niv+1;
if niv>9 then niv:=9;
end;
{----------------------------------------------------------------------------}
procedure operbenzi;
var dx,a,i2:integer;
begin
for i2:=1 to 8 do
if bocup[i2]>0 then bocup[i2]:=bocup[i2]-1
else
begin
a:=benzi[i2].smas+random(benzi[i2].lmas)*2;
if benzi[i2].fav=true then if random(3)=0 then a:=benzi[i2].smas;
dx:=0;
if benzi[i2].smas mod 2=0 then dx:=81+modele[a].lung;
creazmas(dx-modele[a].lung,benzi[i2].linie,benzi[i2].vitez,a);
bocup[i2]:=(modele[a].lung+3+random(10))*(3-abs(benzi[i2].vitez));
end;
end;
{----------------------------------------------------------------------------}
procedure miscinam;
begin
v05:=1-v05;
for i:=1 to 100 do if inam[i,1]>0 then
begin
case inam[i,5] of
-1:inam[i,2]:=inam[i,2]-v05;
1:inam[i,2]:=inam[i,2]+v05;
-2:inam[i,2]:=inam[i,2]-1;
2:inam[i,2]:=inam[i,2]+1;
end;
if (inam[i,2]<-16) or (inam[i,2]>81) then inam[i,1]:=0;
end;
anax:=anax+anad;
if (anax>80) then anad:=-1;
if (anax<0-anam) then anad:=1;
end;
{----------------------------------------------------------------------------}
procedure desscor;
var s:string;
begin
textattr:=31;
str(scor,s); while length(s)<6 do s:='0'+s;
gotoxy(7,24); write(s);
gotoxy(21,24); write(vieti);
gotoxy(64,24); write(niv);
str(reco,s); while length(s)<6 do s:='0'+s;
gotoxy(74,24); write(s);
gotoxy(29,24);
for i:=1 to 27 do
begin
textattr:=26;
if i<15 then textattr:=30;
if i<7 then textattr:=22;
if i<3 then textattr:=20;
if i>(timp div 32) then textattr:=17;
write(chr(254));
end;
end;
{----------------------------------------------------------------------------}
procedure stgec;
begin
fillchar(ecran2,3360,0);
end;
{----------------------------------------------------------------------------}
procedure crasti;
var pt:integer;
    a,b,ab,ba,pab:byte;
    st:string;
const cul:array[0..2] of byte=(0,12,15);
begin
l2:=0;
move(ecran2,ecran,sizeof(ecran));
pab:=0;
for k:=1 to 50 do
begin
l2:=l2+calib;
repeat a:=cul[random(3)]; b:=cul[random(3)];
ab:=a shl 4+b; ba:=b shl 4+a;
until (a<>b) and (ab<>pab);
pab:=ab;
pt:=1;
for j:=1 to 21 do
for i:=1 to 80 do
begin
case j of
1,2,11,12,21:ecran[pt]:=ab;
else ecran[pt]:=ba;
end;
pt:=pt+2;
end;
move(ecran,ecran2,sizeof(ecran));
for l:=1 to 500 div k do
begin
port[$61]:=random(sun) shl 1;
for l1:=1 to l2 do;
end;
end;
nosound;
vieti:=vieti-1;
desscor;
end;
{----------------------------------------------------------------------------}
procedure jocterm;
var pt:integer; a,b,c,d,e:byte;
    st:string;
const cul:array[0..2] of byte=(0,12,15);
begin
asm cli end;
b:=0; c:=0; d:=0; e:=0;
stgec;
gotoxy(1,13);
textattr:=15; write('                               JOCUL S-A TERMINAT                               ');
l2:=calib div 6;
move(ecran2,ecran,sizeof(ecran));
for k:=1 to 150 do
begin
pt:=1;
a:=random(15)*16+15;
for j:=1 to 21 do
for i:=1 to 80 do
begin
ecran[pt]:=a;
pt:=pt+2;
end;
move(ecran,ecran2,sizeof(ecran));
for l:=1 to 1000 do
begin
b:=b+1; if b>100 then begin b:=0; d:=sun-d; end;
c:=c+1; if c>101 then begin c:=0; e:=sun-e; end;
port[$61]:=d or e;
for l1:=1 to l2 do;
port[$61]:=0;
for l1:=1 to l2 do;
end;
end;
nosound;
asm sti end;
end;
{----------------------------------------------------------------------------}
procedure bravo;
begin
m:=calib div 16;
l2:=calib*20;
asm cli end;
while l2>0 do
begin
port[$61]:=sun;
for l1:=1 to l2 do;
port[$61]:=0;
for l1:=1 to l2 do;
l2:=l2-m;
end;
asm sti end;
intar(1000);
end;
{----------------------------------------------------------------------------}
procedure hop;
begin
m:=calib;
l2:=calib*8;
asm cli end;
while l2>0 do
begin
port[$61]:=sun;
for l1:=1 to l2 do;
port[$61]:=0;
for l1:=1 to l2 do;
l2:=l2-m;
end;
asm sti end;
end;
{----------------------------------------------------------------------------}
procedure desecran;
var liber,benzi1,benzi2,valuri,stuf,tranz,marg:string;
begin
v05:=0;
liber:=''; for i:=1 to 80 do liber:=liber+' ';
benzi1:=''; for i:=1 to 20 do benzi1:=benzi1+chr(142)+chr(142)+'  ';
benzi2:=''; for i:=1 to 20 do benzi2:=benzi2+chr(143)+chr(143)+'  ';
valuri:=''; for i:=1 to 80 do valuri:=valuri+chr(145);
stuf:=''; for i:=1 to 80 do stuf:=stuf+chr(146);
tranz:=''; for i:=1 to 80 do tranz:=tranz+chr(141);
marg:=''; for i:=1 to 80 do marg:=marg+chr(144);
textattr:=0;
gotoxy(1,1);
textattr:=79; write('                                  TEXT FROGGER                                  ');
textattr:=31; write('                        Realizat de Dinu Cristian Mircea                        ');
textattr:=164; write(stuf);
textattr:=171; write(marg);
textattr:=191; write(valuri,valuri,valuri,valuri,valuri,valuri,valuri);
textattr:=186; write(marg);
textattr:=160; write(liber,tranz);
textattr:=7; write(liber);
textattr:=14; write(benzi1);
textattr:=7; write(liber);
textattr:=14; write(benzi2);
textattr:=7; write(liber);
textattr:=14; write(benzi1);
textattr:=7; write(liber);
textattr:=10; write(tranz);
textattr:=160; write(liber);
textattr:=31; write(' SCOR:        VIETI:   TIMP:                             NIVEL:   RECORD:       ');
textattr:=160; for i:=0 to 3 do if cas[i]=false then begin gotoxy(12+i*18,3);write('   '); end;
desscor;
end;
{----------------------------------------------------------------------------}
procedure calibrare;
begin
asm cli end;
calib:=0;
port[$70]:=0; i:=port[$71];
repeat
port[$70]:=0; j:=port[$71];
until j<>i;
repeat
port[$70]:=0; i:=port[$71];
calib:=calib+1;
until j<>i;
asm sti end;
calib:=calib div 100;
end;
{----------------------------------------------------------------------------}
procedure miscbroasc;
begin
if (tend>2) and (tend<6) then
begin
hop;
gotoxy(bx,by);
textattr:=(mem[$b800:(((by-1)*80+(bx-1))*2)+1] and 240)+15;
if by>benzi[4].linie then write(' ') else write(chr(145));
case tend of
3:begin by:=by-2; scor:=scor+25; end;
4:begin bx:=bx+3; scor:=scor+1; end;
5:begin bx:=bx-3; scor:=scor+1; end;
end;
desinam;
end;
if tend>2 then tend:=tend-3;
if by=3 then
begin
ura:=false;
for i:=0 to 3 do if bx=13+i*18 then begin cas[i]:=true; ura:=true; end;
if ura=false then cataplof:=true;
end;
end;
{----------------------------------------------------------------------------}
procedure desbroasc;
begin
gotoxy(bx,by);
textattr:=(mem[$b800:(((by-1)*80+(bx-1))*2)+1] and 240)+2;
m:=tend; while m>5 do m:=m-3;
if not cataplof then write(chr(179+m));
end;
{----------------------------------------------------------------------------}
begin
directvideo:=true;
randomize;
InitVideo;
Defcar;
Calibrare;
anim:=0; reco:=0; sun:=2;
for i:=1 to 8 do bocup[i]:=0;
for j:=1 to 160 do begin operbenzi; miscinam; end;
textattr:=0;
clrscr;
restart:
stgec;
intar(500);
for i:=0 to 3 do cas[i]:=false;
niv:=1;intarz:=5; tend:=0; scor:=0; anam:=7; anax:=0; anad:=1; vieti:=5; anad:=0;
desecran;
genanac;
while not keypressed do
begin
anim:=1-anim;
operbenzi;
miscinam;
desinam;
gotoxy(1,13);
textattr:=160; write('                     Apasa orice tasta pentru a incepe jocul                    ');
intar(150);
end;
if readkey=chr(27) then begin dezinitvideo; exit; end;
anad:=1;
rejoc:
stgec;
intar(500);
timp:=28*32;
Desecran;
bx:=40;by:=23; tend:=0; gata:=false; cataplof:=false; ura:=false;
desbroasc;
while not (gata or cataplof or ura) do
begin
anim:=1-anim;
operbenzi;
miscinam;
desinam;
intar(50);
for i3:=1 to intarz do
begin
intar(30);
miscbroasc;
timp:=timp-1; if timp<0 then cataplof:=true;
if keypressed then ch:=readkey else ch:=chr(0);
if ch=chr(27) then gata:=true;
if tend<3 then
begin
if ch=chr(72) then tend:=9;
if (ch=chr(75)) and (bx>2) then tend:=11;
if (ch=chr(77)) and (bx<79) then tend:=10;
end;
desbroasc;
end;
if scor>reco then reco:=scor;
desscor;
end;
if ura then
begin
Bravo;
if (cas[0] and cas[1] and cas[2] and cas[3])=true then urmniv;
goto rejoc;
end;
if cataplof then
begin
Crasti;
if vieti>0 then goto rejoc else jocterm;
goto restart;
end;
DezInitVideo;
end.