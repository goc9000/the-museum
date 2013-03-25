unit adlibu;
interface
uses crt;
const frames=1080;
      b   =$2ae;
      c   =$16b;
      cm  =$181;
      d   =$198;
      dm  =$1b0;
      e   =$1ca;
      f   =$1e5;
      fm  =$202;
      g   =$220;
      gm  =$241;
      a   =$263;
      am  =$287;
      cho:array[0..8] of byte=(0,1,2,8,9,$a,$10,$11,$12);
{Chan block='NMOI'

 N=note (space to leave it alone, 1 for bass drum, 2 for snare)
 M=modification (# or space for none)
 O=octave
 I=instrument (preset sust/rel/wave/atk/dec)}
var i,j,k:integer;
    bx,bl:byte;
    by:byte;
    songptr:integer;
    song:array[1..16*frames] of char;
    bln:char;
    fi:file of char;

procedure Readframe;
procedure InitFM;
procedure StopFM;
procedure LoadSong(fname:string);
function DetectFM:boolean;
implementation
procedure Reg(r:byte;v:byte);
var mi,mj:integer;
begin
port[$388]:=r;
for mi:=1 to 6 do mj:=port[$388];
port[$389]:=v;
for mi:=1 to 35 do mj:=port[$388];
end;

procedure Shutup(chn:word);
begin
Reg($a0+chn,0);
Reg($b0+chn,0);
end;

procedure Note(freq,oct,chn,atk,dek,sus,rel,wave:word);
begin
Shutup(chn);
Reg($20+cho[chn],1);
Reg($20+cho[chn]+3,1);
Reg($60+cho[chn],(atk shl 4)+dek);
Reg($60+cho[chn]+3,(atk shl 4)+dek);
Reg($80+cho[chn],(sus shl 4)+rel);
Reg($80+cho[chn]+3,(sus shl 4)+rel);
Reg($a0+chn,lo(freq));
Reg($b0+chn,(oct shl 2)+32+hi(freq));
Reg($c0+chn,0);
Reg($e0+cho[chn],wave);
end;

procedure Config(freq,oct,chn,atk,dek,sus,rel:word);
begin
Shutup(chn);
Reg($20+cho[chn],0);
Reg($20+cho[chn]+3,0);
Reg($60+cho[chn],(atk shl 4)+dek);
Reg($60+cho[chn]+3,(atk shl 4)+dek);
Reg($80+cho[chn],(sus shl 4)+rel);
Reg($80+cho[chn]+3,(sus shl 4)+rel);
Reg($a0+chn,lo(freq));
Reg($b0+chn,(oct shl 2)+hi(freq));
Reg($c0+chn,0);
end;

procedure Bdrum;
begin
reg($bd,32);
Config(d,2,6,15,15,0,8);
Config(0,0,7,15,15,0,6);
Config(a,3,8,15,15,0,8);
reg($bd,32+16+4);
end;

procedure Hih_o;
begin
reg($bd,32);
Config(d,2,6,15,15,0,8);
Config(0,0,7,13,15,3,6);
Config(a,3,8,15,15,0,8);
reg($bd,32+8);
end;

procedure Hih_c;
begin
reg($bd,32);
Config(d,2,6,15,15,0,8);
Config(0,0,7,15,15,2,8);
Config(a,3,8,15,15,0,8);
reg($bd,32+8);
end;

procedure BasHh;
begin
reg($bd,32);
Config(d,2,6,15,15,0,8);
Config(0,0,7,15,15,2,8);
Config(a,3,8,15,15,0,8);
reg($bd,32+8+16+4);
end;

procedure BasHhO;
begin
reg($bd,32);
Config(d,2,6,15,15,0,8);
Config(0,0,7,13,15,3,6);
Config(a,3,8,15,15,0,8);
reg($bd,32+8+16+4);
end;

procedure Snare;
begin
reg($bd,32);
Config(d,3,6,15,15,0,9);
Config(0,0,7,15,15,0,7);
Config(a,3,8,15,15,0,6);
reg($bd,32+8+4+16);
end;

procedure Readframe;
var at,dc,su,rl,wv,oc,fq,ch,ins:integer;
    i02:integer;
label pufiu;
begin
pufiu:
for i02:=0 to 3 do
begin
fq:=0;
ins:=0;
if (song[songptr]='E') and (song[songptr+1]='N') then
begin
songptr:=1;
goto pufiu;
end;
if (song[songptr]='1') then Bdrum;
if (song[songptr]='2') then Snare;
if (song[songptr]='3') then Hih_o;
if (song[songptr]='4') then Hih_c;
if (song[songptr]='5') then Bashh;
if (song[songptr]='6') then Bashho;
if (song[songptr]='C') and (song[songptr+1]=' ') then fq:=c;
if (song[songptr]='C') and (song[songptr+1]='#') then fq:=cm;
if (song[songptr]='D') and (song[songptr+1]=' ') then fq:=d;
if (song[songptr]='D') and (song[songptr+1]='#') then fq:=dm;
if (song[songptr]='E') and (song[songptr+1]=' ') then fq:=e;
if (song[songptr]='F') and (song[songptr+1]=' ') then fq:=f;
if (song[songptr]='F') and (song[songptr+1]='#') then fq:=fm;
if (song[songptr]='G') and (song[songptr+1]=' ') then fq:=g;
if (song[songptr]='G') and (song[songptr+1]='#') then fq:=gm;
if (song[songptr]='A') and (song[songptr+1]=' ') then fq:=a;
if (song[songptr]='A') and (song[songptr+1]='#') then fq:=am;
if (song[songptr]='B') and (song[songptr+1]=' ') then fq:=b;
ch:=1;
if (song[songptr]=' ') then ch:=0;
if fq=0 then ch:=0;
if (song[songptr+2]='0') then oc:=0;
if (song[songptr+2]='1') then oc:=1;
if (song[songptr+2]='2') then oc:=2;
if (song[songptr+2]='3') then oc:=3;
if (song[songptr+2]='4') then oc:=4;
if (song[songptr+2]='5') then oc:=5;
if (song[songptr+2]='6') then oc:=6;
if (song[songptr+2]='7') then oc:=7;
if (song[songptr+3]='X') then
begin
ch:=0;
Shutup(i02);
if i02=3 then Shutup(5);
end;
if (song[songptr+3]='1') then ins:=1;
if (song[songptr+3]='2') then ins:=2;
if (song[songptr+3]='3') then ins:=3;
if (song[songptr+3]='4') then ins:=4;
if (song[songptr+3]='5') then ins:=5;
if (song[songptr+3]='6') then ins:=6;
if (song[songptr+3]='7') then ins:=7;
if (song[songptr+3]='8') then ins:=8;
if (song[songptr+3]='9') then ins:=9;
if ins=1 then
begin
at:=15;
dc:=15;
su:=1;
rl:=1;
wv:=1;
Reg($40+cho[i02],0);
Reg($40+cho[i02]+3,0);
end;
if ins=2 then
begin
at:=15;
dc:=15;
su:=0;
rl:=3;
wv:=1;
Reg($40+cho[i02],0);
Reg($40+cho[i02]+3,0);
end;
if ins=3 then
begin
at:=15;
dc:=15;
su:=0;
rl:=3;
wv:=1;
inc(oc);
inc(oc);
end;
if ins=4 then
begin
at:=15;
dc:=15;
su:=0;
rl:=1;
wv:=1;
inc(oc);
inc(oc);
end;
dec(oc);
if ch=1 then
begin
note(fq,oc,i02,at,dc,su,rl,wv);
if ins=3 then note(fq,oc,5,at,dc,su+1,rl-1,wv);
if ins=4 then note(fq,oc,5,at,dc,su+1,rl-1,wv);
end;
songptr:=songptr+4;
end;
end;

procedure InitFM;
begin
for i:=0 to $ff do Reg(i,0);
reg($01,32);
end;

procedure Loadsong(fname:string);
begin
assign(fi,fname);
reset(fi);
bl:=255;
bx:=0;
for i:=1 to frames do
begin
for j:=1 to 16 do
begin
read(fi,bln);
by:=ord(bln);
bx:=bx+1;
if bx=bl then
begin
dec(bl);
bx:=0;
end;
if bl=0 then bl:=255;
by:=by xor bx;
bln:=chr(by);
song[((i-1)*16)+j]:=bln;
end;
bx:=bx+1;
if bx=bl then
begin
dec(bl);
bx:=0;
end;
if bl=0 then bl:=255;
bx:=bx+1;
if bx=bl then
begin
dec(bl);
bx:=0;
end;
if bl=0 then bl:=255;
bx:=bx+1;
if bx=bl then
begin
dec(bl);
bx:=0;
end;
if bl=0 then bl:=255;
read(fi,bln);
read(fi,bln);
read(fi,bln);
end;
close(fi);
end;

procedure StopFM;
begin
shutup(0);
shutup(1);
shutup(2);
shutup(3);
shutup(4);
shutup(5);
end;

function DetectFM:boolean;
var res:boolean;
    x1,x2:byte;
begin
res:=false;
Reg(4,$60);
delay(10);
Reg(4,$80);
delay(10);
x1:=port[$388];
Reg(2,$FF);
delay(10);
Reg(4,$21);
delay(10);
x2:=port[$388];
Reg(4,$60);
delay(10);
Reg(4,$80);
delay(10);
if ((x1 and $e0)=$00) and ((x2 and $e0)=$c0) then res:=true;
DetectFM:=res;
end;

begin
end.




