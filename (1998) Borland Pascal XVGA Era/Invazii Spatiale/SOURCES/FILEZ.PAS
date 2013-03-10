{$X+}
unit Filez;
interface
uses Dos,Crt,Video,Strings;
var  inames:array[1..400,1..12] of char;
     iposes:array[1..400] of integer;
     sprf16x : file of byte;
     i,j:integer;
     tmpsprt:img16;
     tempspr:img24;
     tempspri:img8;
Procedure LoadIndexToMEM;
Procedure LoadImg8(path:string;shift:byte;var sprt :img8);
Procedure LoadImg16(path:string;shift:byte;var sprt :img16);
Procedure LoadImg24(path:string;shift:byte;var sprt :img24);
implementation
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure LoadIndexToMEM;
var idxf:file of char;
    j1:integer;
    tch:char;
    tnm:integer;
    entry:integer;
    kl,kh:byte;
    calc:word;
begin
assign(idxf,'DATE\grafica.idx');
reset(idxf);
entry:=1;
for i:=1 to (filesize(idxf) div 14) do
begin
     for j1:=1 to 12 do
     begin
     read(idxf,tch);
     inames[entry,j1]:=tch;
     end;
read(idxf,tch);
kh:=ord(tch);
read(idxf,tch);
kl:=ord(tch);
calc:=0;
calc:=kh;
calc:=swap(calc);
calc:=calc+kl;
iposes[entry]:=calc;
inc(entry);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Function WhereS(path:string):word;
const step=14;
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
(*
Assign(ef1,'DATE\grafica.idx');
Reset(ef1);
locat:=0;
{}
{ FIND ENTRY }
{}
for ii:=0 to ((FileSize(ef1)-14) div step) do
begin
Seek(ef1,ii*step);
jojo:='            ';
for jj:=1 to 8 do
begin
read(ef1,d);
jojo[jj]:=d;
end;
ok:=true;
for jj:=1 to 8 do
begin
if jojo[jj]<>path[jj] then ok:=false;
if jojo[jj]<>path[jj] then break;
end;
if ok=true then locat:=ii*step;
if ok=true then break;
end;
{}
{ DECODE ENTRY }
{}
seek(ef1,locat);
for ii:=1 to 12 do read (ef1,d);
read (ef1,d);
kh:=ord(d);
read (ef1,d);
kl:=ord(d);
calc:=0;
calc:=kh;
calc:=swap(calc);
calc:=calc+kl;
close(ef1);
{}
Wheres:=calc;
*)
entry:=0;
rewire:
inc(entry);
ok:=true;
for i:=1 to 12 do
begin
if path[i]<>inames[entry,i] then ok:=false;
end;
if ok=false then goto rewire;
Wheres:=iposes[entry];
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure LoadImg16(path:string;shift:byte;var sprt:img16);
var yu:file of word;
    ii,jj:integer;
    x:word;
    w:longint;
begin
w:=Wheres(path);
assign(yu,'DATE\grafica.grp');
reset(yu);
seek(yu,w div 2);
for ii:=1 to ((16*16) div 2) do
begin
read(yu,x);
tmpsprt[(ii*2)-1]:=Lo(x)+shift;
tmpsprt[(ii*2)]:=Hi(x)+shift;
end;
close(yu);
sprt:=tmpsprt;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure LoadImg24(path:string;shift:byte;var sprt:img24);
var yu:file of word;
    ii,jj:integer;
    x:word;
    w:longint;
begin
w:=Wheres(path);
assign(yu,'DATE\grafica.grp');
reset(yu);
seek(yu,w div 2);
for ii:=1 to ((24*24) div 2) do
begin
read(yu,x);
tempspr[(ii*2)-1]:=Lo(x)+shift;
tempspr[(ii*2)]:=Hi(x)+shift;
end;
close(yu);
sprt:=tempspr;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure LoadImg8(path:string;shift:byte;var sprt:img8);
var yu:file of word;
    ii,jj:integer;
    x:word;
    w:longint;
begin
w:=Wheres(path);
assign(yu,'DATE\grafica.grp');
reset(yu);
seek(yu,w div 2);
for ii:=1 to ((8*8) div 2) do
begin
read(yu,x);
tempspri[(ii*2)-1]:=Lo(x)+shift;
tempspri[(ii*2)]:=Hi(x)+shift;
end;
close(yu);
sprt:=tempspri;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
end.