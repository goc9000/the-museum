unit TextFont;
interface
uses Crt;
procedure SetFont(fname:string);
procedure SetFont2(fname:string);
procedure BlastTextCursor;
procedure SetLines(nr:byte);
implementation
var Fontul:array[0..4095] of byte;
    AdrFnt:word;
    OfsFnt:word;
    f:file of byte;
    i:integer;
    b:byte;
procedure SetFont(fname:string);
begin
AdrFnt:=seg(Fontul);
OfsFnt:=ofs(Fontul);
i:=0;
assign(f,fname);
reset(f);
while not eof(f) do
begin
read(f,b);
Fontul[i]:=b;
i:=i+1;
end;
close(f);
 asm

    PUSH ES
    PUSH BP

    MOV  AX, 1110h
    MOV  BH, 10h
    MOV  BL, 00h     { Font table #0 }
    MOV  CX, 100h
    XOR  DX, DX
    MOV  ES, AdrFnt
    MOV  BP, OfsFnt
    INT  10h

    POP  BP
    POP  ES
 end;
end;
procedure SetFont2(fname:string);
begin
AdrFnt:=seg(Fontul);
OfsFnt:=ofs(Fontul);
i:=0;
assign(f,fname);
reset(f);
seek(f,17);
while not eof(f) do
begin
read(f,b);
Fontul[i]:=b;
i:=i+1;
end;
close(f);
assign(f,fname);
rewrite(f);
for i:=0 to 4095 do write(f,fontul[i]);
close(f);
end;
procedure BlastTextCursor;assembler;
 asm
    mov ah,01h
    mov ch,20h
    int 10h
end;
procedure SetLines(nr:byte);assembler;
asm
mov ah,12h
mov bl,30h
mov al,[nr]
int 10h
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
begin
end.