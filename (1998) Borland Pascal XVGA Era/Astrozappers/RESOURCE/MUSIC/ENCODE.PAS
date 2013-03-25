uses dos,crt;
var f:file of byte;
    f2:file of byte;
    x:byte;
    y:byte;
    l:byte;
begin
x:=0;
y:=0;
assign(f,paramstr(1));
assign(f2,paramstr(2));
reset(f);
rewrite(f2);
l:=255;
while not eof(f) do
begin
read(f,x);
y:=y+1;
if y=l then
begin
dec(l);
y:=0;
end;
if l=0 then
begin
l:=255;
end;
x:=x xor y;
write(f2,x);
end;
close(f);
close(f2);
end.