program makechk;
var fw:file of byte;
    i:integer;
    w:byte;
    checksum:longint;
    checksum2:longint;
    checksum3:longint;
    checksum4:longint;
    kia:file of longint;
    tt:longint;
begin
assign(fw,'astrozap.gfx');
reset(fw);
seek(fw,4);
while not eof(fw) do
begin
read(fw,w);
tt:=filepos(fw);
seek(fw,tt+9);
checksum2:=checksum2+w;
end;
close(fw);
{}
assign(fw,'astrozap.txt');
reset(fw);
while not eof(fw) do
begin
read(fw,w);
tt:=filepos(fw);
seek(fw,tt+2);
checksum4:=checksum4+w;
end;
close(fw);
{}
checksum3:=123456;
assign(kia,'astrozap.chk');
rewrite(kia);
write (kia,checksum3);
write (kia,checksum2);
write (kia,checksum4);
close(kia);
end.