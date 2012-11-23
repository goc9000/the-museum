unit TextFont;
interface
type virtual=array[1..4000] of byte;
     virtptr=^virtual;
     font8x16=array[0..4095] of byte;
     virtfont=^font8x16;
Const BIntensity=0;
      FBlink=1;
      saddr=$B800;
var virscr:virtptr;
    grfnt:virtfont;
    crfnt:virtfont;
    unfnt:virtfont;
    vaddr:word;
    gradr:word;
    cradr:word;
    unadr:word;
Procedure WaitR1;
Procedure WaitR2;
procedure ScrOn;
procedure ScrOff;
Procedure ScrollDNToScr(where:word);
Procedure ScrollUNToScr(where:word);
Procedure SinkScr;
Procedure Flip(source,dest,size:Word);
procedure WriteCh(character:char;pag:word);
procedure WriteSt(what:string;pag:word);
procedure TransCh(pag,pagt:word);
procedure DrawBox(x1,y1,x2,y2,col,col2,col3,p:word);
procedure DrawEBox(x1,y1,x2,y2,col,col2,col3,p:word);
procedure WDrawBox(x1,y1,x2,y2,col,col2,col3,col4:byte;st:string;p:word);
procedure DrawBut(bx,by,wid,bcol,bcol2:byte;st:string;hil:byte;shad:boolean;where:word);
procedure DrawMenu(bx,by,width,bcol:byte;p:word);
procedure BlastTextCursor;
procedure SetLines(nr:byte);
procedure LoadFont(fname:string;var Fontul:word);
procedure SaveFont(fname:string;var Fontul:word);
procedure CopyFont(Fontul:word;block:byte);
procedure SelectFonts(block1,block2:byte);
procedure SelectIorB(which:byte);
procedure SetBorder(col:byte);
procedure SetPage(pag:byte);
Procedure Pal(Col,R,G,B : Byte);
Procedure GetPal(Col : Byte; Var R,G,B : Byte);
implementation
uses Crt;
var AdrFnt:word;
    OfsFnt:word;
    f:file of byte;
    i,j,k:integer;
    b:byte;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure ScrOn;
begin
{
GetMem(virscr,4000);
vaddr:=seg(virscr^);
}
GetMem(grfnt,4096);
gradr:=seg(grfnt^);
GetMem(crfnt,4096);
cradr:=seg(crfnt^);
GetMem(unfnt,4096);
unadr:=seg(unfnt^);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure ScrOff;
begin
{FreeMem(virscr,4000);}
FreeMem(grfnt,4096);
FreeMem(crfnt,4096);
FreeMem(unfnt,4096);
vaddr:=0;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure SinkScr;
begin
gotoxy(1,1);
for i:=1 to 26 do
begin
insline;
delay(10);
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure DrawBox(x1,y1,x2,y2,col,col2,col3,p:word);
var h:integer;
begin
if x1>x2 then
begin
h:=x1;
x1:=x2;
x2:=h;
end;
if y1>y2 then
begin
h:=y1;
y1:=y2;
y2:=h;
end;
TextBackground(col2);
TextColor(col);
if (col2>7) then if TextAttr<128 then TextAttr:=TextAttr+128;
gotoxy(x1,y1);
writech('Ç',p);
gotoxy(x2,y1);
writech('á',p);
gotoxy(x1,y2);
writech('È',p);
gotoxy(x2,y2);
writech('â',p);
for h:=x1+1 to x2-1 do
begin
gotoxy(h,y1);
writech('Å',p);
end;
for h:=x1+1 to x2-1 do
begin
gotoxy(h,y2);
writech('Á',p);
end;
for h:=y1+1 to y2-1 do
begin
gotoxy(x1,h);
writech('Ã',p);
end;
for h:=y1+1 to y2-1 do
begin
gotoxy(x2,h);
writech('à',p);
end;
TextBackground(col3);
if (col3>7) then if TextAttr<128 then TextAttr:=TextAttr+128;
if (col3<8) then if TextAttr>128 then TextAttr:=TextAttr-128;
for h:=x1+1 to x2-1 do
for i:=y1+1 to y2-1 do
begin
gotoxy(h,i);
writech(' ',p);
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure DrawEBox(x1,y1,x2,y2,col,col2,col3,p:word);
var h:integer;
begin
if x1>x2 then
begin
h:=x1;
x1:=x2;
x2:=h;
end;
if y1>y2 then
begin
h:=y1;
y1:=y2;
y2:=h;
end;
TextBackground(col2);
TextColor(col);
if (col2>7) then if TextAttr<128 then TextAttr:=TextAttr+128;
gotoxy(x1,y1);
writech('Ç',p);
gotoxy(x2,y1);
writech('á',p);
gotoxy(x1,y2);
writech('È',p);
gotoxy(x2,y2);
writech('â',p);
for h:=x1+1 to x2-1 do
begin
gotoxy(h,y1);
writech('Å',p);
end;
for h:=x1+1 to x2-1 do
begin
gotoxy(h,y2);
writech('Á',p);
end;
for h:=y1+1 to y2-1 do
begin
gotoxy(x1,h);
writech('Ã',p);
end;
for h:=y1+1 to y2-1 do
begin
gotoxy(x2,h);
writech('à',p);
end;
TextBackground(col3);
if (col3>7) then if TextAttr<128 then TextAttr:=TextAttr+128;
if (col3<8) then if TextAttr>128 then TextAttr:=TextAttr-128;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure DrawMenu(bx,by,width,bcol:byte;p:word);
begin
TextBackground(bcol);
TextColor(14);
if (bcol>7) then if TextAttr<128 then TextAttr:=TextAttr+128;
if (bcol<8) then if TextAttr>128 then TextAttr:=TextAttr-128;
for i:=0 to width do
begin
gotoxy(bx+i,by);
if i=0 then writech('à',p);
if (i>0) and (i<width) then writech(' ',p);
if i=width then writech('Ã',p);
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure DrawBut(bx,by,wid,bcol,bcol2:byte;st:string;hil:byte;shad:boolean;where:word);
begin
TextBackground(bcol);
TextColor(13);
if (bcol>7) then if TextAttr<128 then TextAttr:=TextAttr+128;
if (bcol<8) then if TextAttr>128 then TextAttr:=TextAttr-128;
for i:=1 to wid do
begin
gotoxy(bx+(i-1),by+0);
writech(' ',where);
end;
GotoXy((bx+wid div 2)-(length(st) div 2),by);
for i:=1 to length(st) do
begin
TextBackground(bcol);
TextColor(13);
if i=hil then TextColor(12);
if (bcol>7) then if TextAttr<128 then TextAttr:=TextAttr+128;
if (bcol<8) then if TextAttr>128 then TextAttr:=TextAttr-128;
writech(st[i],where);
gotoxy(wherex+1,wherey);
end;
TextBackground(bcol2);
TextColor(13);
if (bcol2>7) then if TextAttr<128 then TextAttr:=TextAttr+128;
if (bcol2<8) then if TextAttr>128 then TextAttr:=TextAttr-128;
if shad=true then
begin
for i:=1 to wid do
begin
gotoxy(bx+i,by+1);
writech('ß',where);
end;
gotoxy(bx+wid,by+0);
writech('Ü',where);
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure WDrawBox(x1,y1,x2,y2,col,col2,col3,col4:byte;st:string;p:word);
var h:integer;
    mega:byte;
begin
if x1>x2 then
begin
h:=x1;
x1:=x2;
x2:=h;
end;
if y1>y2 then
begin
h:=y1;
y1:=y2;
y2:=h;
end;
TextBackground(col3);
TextColor(col);
if (col3>7) then if TextAttr<128 then TextAttr:=TextAttr+128;
if (col3<8) then if TextAttr>128 then TextAttr:=TextAttr-128;
gotoxy(x1,y2);
writech('Ä',p);
gotoxy(x2,y2);
writech('Æ',p);
for h:=x1+1 to x2-1 do
begin
gotoxy(h,y2);
writech('Å',p);
end;
for h:=y1+1 to y2-1 do
begin
gotoxy(x1,h);
writech('à',p);
end;
for h:=y1+1 to y2-1 do
begin
gotoxy(x2,h);
writech('Ã',p);
end;
mega:=textattr;
if (x2<79) and (y2<25) then
begin
textbackground(0);
textcolor(0);
for h:=y1+1 to y2 do
begin
gotoxy(x2+1,h);
writech('Û',p);
gotoxy(x2+2,h);
writech('Û',p);
end;
for h:=x1+2 to x2+2 do
begin
gotoxy(h,y2+1);
writech('Û',p);
end;
end;
textattr:=mega;
for h:=x1+1 to x2-1 do
for i:=y1+1 to y2-1 do
begin
gotoxy(h,i);
writech(' ',p);
end;
TextColor(13);
TextBackground(col4);
if (col4>7) then if TextAttr<128 then TextAttr:=TextAttr+128;
if (col4<8) then if TextAttr>128 then TextAttr:=TextAttr-128;
for h:=x1 to x2 do
begin
gotoxy(h,y1);
writech(' ',p);
end;
Gotoxy(((x1+((x2-x1) div 2))-(Length(st) div 2)+1)-1,y1);
for i:=1 to length(st) do
begin
writech(st[i],p);
gotoxy(wherex+1,wherey);
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure BlastTextCursor;assembler;
 asm
    mov ah,01h
    mov ch,20h
    int 10h
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure SetLines(nr:byte);assembler;
asm
mov ah,12h
mov bl,30h
mov al,[nr]
int 10h
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure LoadFont(fname:string;var Fontul:word);
begin
i:=0;
assign(f,fname);
reset(f);
while not eof(f) do
begin
read(f,b);
MEM[fontul:i]:=b;
i:=i+1;
end;
close(f);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure SaveFont(fname:string;var Fontul:word);
var by:byte;
begin
assign(f,fname);
rewrite(f);
for i:=0 to 4095 do
begin
by:=MEM[fontul:i];
write(f,by);
end;
close(f);
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure CopyFont(Fontul:word;block:byte);
begin
AdrFnt:=fontul;
OfsFnt:=0;
 asm
    PUSH ES
    PUSH BP
    MOV  AX, 1110h
    MOV  BH, 10h
    MOV  BL, [block]
    MOV  CX, 100h
    XOR  DX, DX
    MOV  ES, AdrFnt
    MOV  BP, OfsFnt
    INT  10h
    POP  BP
    POP  ES
 end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure WaitR1; assembler;
label
  l1, l2;
asm
    mov dx,3DAh
l1:
    in al,dx
    and al,08h
    jnz l1
l2:
    in al,dx
    and al,08h
    jz  l2
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure WaitR2; assembler;
label
  l1, l2;
asm
    mov dx,3DAh
l1:
    in al,dx
    and al,01h
    jnz l1
l2:
    in al,dx
    and al,01h
    jz  l2
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Flip(source,dest,size:Word);
begin
  asm
    push    ds
    mov     ax, [Dest]
    mov     es, ax
    mov     ax, [Source]
    mov     ds, ax
    xor     si, si
    xor     di, di
    mov     cx, [Size]
    rep     movsw
    pop     ds
  end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure SelectFonts(block1,block2:byte);
var bitinfo:byte;
begin
bitinfo:=0;
if (block1 and 1)>0 then bitinfo:=bitinfo+01;
if (block1 and 2)>0 then bitinfo:=bitinfo+02;
if (block2 and 1)>0 then bitinfo:=bitinfo+04;
if (block2 and 2)>0 then bitinfo:=bitinfo+08;
if (block1 and 4)>0 then bitinfo:=bitinfo+16;
if (block2 and 4)>0 then bitinfo:=bitinfo+32;
asm
 mov ax,1103h
 mov bl,[bitinfo]
 int 10h
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure SelectIorB(which:byte);assembler;
asm
mov ax,1003h
mov bl,[which]
int 10h
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure SetBorder(col:byte);assembler;
asm
mov ax,1001h
mov bh,[col]
int 10h
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure SetPage(pag:byte);assembler;
asm
mov ah,05h
mov al,[pag]
int 10h
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Pal(Col,R,G,B : Byte);
Begin
   asm
      mov    dx,3c8h
      mov    al,[col]
      out    dx,al
      inc    dx
      mov    al,[r]
      out    dx,al
      mov    al,[g]
      out    dx,al
      mov    al,[b]
      out    dx,al
   end;
End;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure GetPal(Col : Byte; Var R,G,B : Byte);
Var
   rr,gg,bb : Byte;
Begin
   asm
      mov    dx,3c7h
      mov    al,col
      out    dx,al
      add    dx,2
      in     al,dx
      mov    [rr],al
      in     al,dx
      mov    [gg],al
      in     al,dx
      mov    [bb],al
   end;
   r := rr;
   g := gg;
   b := bb;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure WriteCh(character:char;pag:word);
var v,u:byte;
    l:word;
begin
v:=ord(character);
u:=TextAttr;
l:=(((WhereY-1)*80)+(WhereX-1))*2;
MEM[pag:l]:=v;
MEM[pag:l+1]:=u;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure WriteSt(what:string;pag:word);
var v,u:byte;
    l:word;
begin
for i:=1 to length(what) do
begin
v:=ord(what[i]);
u:=TextAttr;
l:=(((WhereY-1)*80)+(WhereX-1))*2;
MEM[pag:l]:=v;
MEM[pag:l+1]:=u;
gotoxy(wherex+1,wherey);
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure TransCh(pag,pagt:word);
var v,u:byte;
    l:word;
begin
l:=(((WhereY-1)*80)+(WhereX-1))*2;
v:=MEM[pag:l];
u:=MEM[pag:l+1];
MEM[pagt:l]:=v;
MEM[pagt:l+1]:=u;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure ScrollDNToScr(where:word);
begin
for i:=24 downto 0 do
begin
waitR1;
flip(where+(i*10),saddr,(80+((24-i)*80)));
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure ScrollUNToScr(where:word);
begin
for i:=0 to 24 do
begin
waitR1;
flip(where,saddr+((24-i)*10),(80+(i*80)));
end;
end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
begin
end.