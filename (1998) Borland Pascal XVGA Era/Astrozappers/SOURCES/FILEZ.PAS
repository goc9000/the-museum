{$X+}
unit Filez;
interface
uses Dos,Crt,Video,Strings,Logic;
var  inames:array[1..400,1..12] of char;
     iposes:array[1..400] of longint;
     isizes:array[1..400] of byte;
     numspr:integer;
     spritefile : file of byte;
     i,j:integer;
function Exist(fname:string):boolean;
Procedure LoadPal;
Procedure LoadIndexToMEM;
Procedure LoadImg(path:string;shift:byte;var sprt : virtptr);
implementation
uses General;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
function Exist(fname:string):boolean;
var a8:SearchRec;
    res:boolean;
begin
res:=true;
findfirst(fname,$00,a8);
if doserror<>0 then res:=false;
Exist:=res;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure LoadPal;
var i: byte;
begin
Assign(PalFile,'astrozap.pal');
Reset(PalFile);
for i:=0 to 255 do
begin
read(PalFile,er);
read(PalFile,ge);
read(PalFile,be);
Paleta[255-i,1]:=er div 4;
Paleta[255-i,2]:=ge div 4;
Paleta[255-i,3]:=be div 4;
end;
Paleta[0,1]:=0;
Paleta[0,2]:=0;
Paleta[0,3]:=0;
Paleta[254,1]:=0;
Paleta[254,2]:=0;
Paleta[254,3]:=0;
Close(PalFile);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure LoadIndexToMEM;
var idxf,idxf2:file of char;
    idxf3:file of longint;
    j1:integer;
    tch:char;
    tnm:integer;
    entry:integer;
    zend:boolean;
    long1:longint;
    long2:longint;
begin
numspr:=0;
entry:=1;
assign(idxf,'astrozap.idx');
reset(idxf);
zend:=false;
while zend=false do
begin
for j1:=1 to 12 do
begin
read(idxf,tch);
inames[entry,j1]:=tch;
end;
read(idxf,tch);
if tch='!' then zend:=true;
isizes[entry]:=ord(tch);
inc(entry);
end;
numspr:=entry-2;
entry:=1;
long1:=filepos(idxf);
assign(idxf2,'astrozap.tmp');
rewrite(idxf2);
while not eof(idxf) do
begin
read(idxf,tch);
write(idxf2,tch);
end;
close(idxf2);
close(idxf);
assign(idxf3,'astrozap.tmp');
reset(idxf3);
for i:=1 to numspr do
begin
read(idxf3,long1);
iposes[entry]:=long1;
inc(entry);
end;
close(idxf3);
assign(idxf3,'astrozap.tmp');
erase(idxf3);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure WhereS(path:string;var w:longint;var siz:byte);
const step=17;
var ef1:file of char;
    jojo:string[12];
    d:char;
    ok:boolean;
    locat:word;
    ii,jj,kk:longint;
    kl,kh:byte;
    calc:word;
    entry:integer;
label rewire;
begin
{
StrPCopy(tstr1,path);
Say(StrPas(tstr1),14);
}
entry:=0;
rewire:
inc(entry);
if entry>numspr then FuckUp('GFX file damaged !');
ok:=true;
for i:=1 to 12 do
begin
if path[i]<>inames[entry,i] then ok:=false;
end;
if ok=false then goto rewire;
w:=iposes[entry];
siz:=isizes[entry];
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure LoadImg(path:string;shift:byte;var sprt:virtptr);
var yu:file of word;
    ii,jj:integer;
    x:word;
    sz:byte;
    w:longint;
    a1,a2:byte;
    aseg,aofs:word;
begin
Wheres(path,w,sz);
assign(yu,'astrozap.gfx');
reset(yu);
seek(yu,w div 2);
aseg:=seg(sprt^);
aofs:=0{ofs(sprt^)};
for ii:=1 to ((sz*sz) div 2) do
begin
read(yu,x);
a1:=255-Hi(x);
a2:=255-Lo(x);
if a1=0 then a1:=1;
if a1=255 then a1:=0;
if a2=0 then a2:=1;
if a2=255 then a2:=0;
if a1>0 then Inc(a1,shift);
if a2>0 then Inc(a2,shift);
Mem[aseg:(aofs+1+((ii-1)*2))]:=a1;
Mem[aseg:(aofs+0+((ii-1)*2))]:=a2;
end;
close(yu);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
end.