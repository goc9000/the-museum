{$X+}
unit Video;
interface
uses Dos,Crt;
CONST VGA = $a000;
      dark=1;
TYPE  Virtual = Array [1..64000] of byte;
      VirtPtr = ^Virtual;
      img8 = Array [1..8*8] of byte;
      img16 = Array [1..16*16] of byte;
      Vimg16 = ^img16;
      img24 = Array [1..24*24] of byte;
VAR   Virscr : VirtPtr;
      Vaddr  : word;
      Virscr2 : VirtPtr;
      Vaddr2  : word;
      Paleta  : array[0..255,1..3] of byte;
      PalFile : file of byte;
      er,ge,be:byte;
Procedure Fade(Darkness:Integer;frametoo:boolean);
Procedure InitGr;
Procedure NormlPal;
Procedure LightPal;
Procedure VgaOn;
Procedure VgaOff;
Procedure VrtOn;
Procedure VrtOff;
Procedure FadeIn;
Procedure FadeOut;
Procedure WaitRetrace;
Function Point (X,Y : Integer):byte;
Procedure Pixel (X,Y : Integer;col:byte;where:word);
Procedure Flip(source,dest:Word);
Procedure Pal(Col,R,G,B : Byte);
Procedure GetPal(Col : Byte; Var R,G,B : Byte);
Procedure Putimg8(X,Y:Word;sprt :img8;Where:Word);
Procedure Putimg16(X,Y:Word;sprt :img16;Where:Word);
Procedure Putimg16b(X,Y:Word;sprt :img16;Where:Word);
Procedure Putimg24(X,Y:Word;sprt :img24;Where:Word);
Procedure Cls (Where:word;Col : Byte);
Procedure Line(a,b,c,d:integer;col:byte;where:word);
Procedure LoadPal;
implementation
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Line(a,b,c,d:integer;col:byte;where:word);
  function sgn(a:real):integer;
  begin
       if a>0 then sgn:=+1;
       if a<0 then sgn:=-1;
       if a=0 then sgn:=0;
  end;
var i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;
    count:integer;
begin
     count:=50;
     u:= c - a;
     v:= d - b;
     d1x:= SGN(u);
     d1y:= SGN(v);
     d2x:= SGN(u);
     d2y:= 0;
     m:= ABS(u);
     n := ABS(v);
     IF NOT (M>N) then
     BEGIN
	  d2x := 0 ;
	  d2y := SGN(v);
	  m := ABS(v);
	  n := ABS(u);
     END;
     s := m shr 1;
     FOR i := 0 TO m DO
     BEGIN
	  pixel(a,b,col,where);
	  s := s + n;
	  IF not (s<m) THEN
	  BEGIN
	       s := s - m;
	       a:= a + d1x;
	       b := b + d1y;
	  END
	  ELSE
	  BEGIN
	       a := a + d2x;
	       b := b + d2y;
	  END;
     end;
END;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure VgaOn;  { This procedure gets you into 320x200x256 mode. }
BEGIN
  asm
     mov	ax,0013h
     int	10h
  end;
END;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure VgaOff;  { This procedure returns you to text mode.  }
BEGIN
  asm
     mov	ax,0003h
     int	10h
  end;
END;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure VrtOn;
   { This sets up the memory needed for the virtual screen }
BEGIN
  GetMem (VirScr,64000);
  vaddr := seg (virscr^);
  GetMem (VirScr2,64000);
  vaddr2 := seg (virscr2^);
END;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure VrtOff;
   { This frees the memory used by the virtual screen }
BEGIN
  FreeMem (VirScr,64000);
  FreeMem (VirScr2,64000);
END;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure WaitRetrace; assembler;  { Waits the Vertical Retrace. }
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
    jz	l2
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Function Point (X,Y : Integer):byte;
begin
Point:=mem[VGA:X+Y*320];
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Pixel (X,Y : Integer; Col : Byte; where:word);
BEGIN
  Asm
    push    ds
    push    es
    mov     ax,[where]
    mov     es,ax
    mov     bx,[X]
    mov     dx,[Y]
    push    bx
    mov     bx, dx
    mov     dh, dl
    xor     dl, dl
    shl     bx, 1
    shl     bx, 1
    shl     bx, 1
    shl     bx, 1
    shl     bx, 1
    shl     bx, 1
    add     dx, bx
    pop     bx
    add     bx, dx
    mov     di, bx
    xor     al,al
    mov     ah, [Col]
    mov     es:[di],ah
    pop     es
    pop     ds
  End;
END;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Flip(source,dest:Word);
begin
  asm
    push    ds
    mov     ax, [Dest]
    mov     es, ax
    mov     ax, [Source]
    mov     ds, ax
    xor     si, si
    xor     di, di
    mov     cx, 32000
    rep     movsw
    pop     ds
  end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
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
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure GetPal(Col : Byte; Var R,G,B : Byte);
  { This gets the Red, Green and Blue values of a certain color }
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
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg8(X,Y:Word;sprt :img8;Where:Word); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X	   { ax = x }
    mov   bx,Y	   { bx = y }
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax

    mov     ax, bx		    {; ax = bx	x = y}
    mov     bh, bl		    {; y = y * 256  bx = bx * 256}
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1		    {; y = y * 64   ax = ax * 64}
    add     bx, ax		    {; y = (y*256) + (Y*64)  bx = bx + ax (ie y*320)}
    pop     ax			    {; get back our x}
    add     ax, bx		    {; finalise location}
    mov     di, ax
    mov   dl,8	  { dl = height of sprite }
    xor   ch,ch
    mov   cl,8	   { cx = width of sprite }
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di		{ store y adr. for later }
    mov   cx,ax 	 { store width }
_LineLoop:
    mov   bl,byte ptr [si]
    or	  bl,bl
    jnz   _Store
_NoPaint:
    inc    si
    inc    di
    loop   _LineLoop
    jmp    _NextLine
_Store:
    movsb
    loop  _LineLoop
_NextLine:
    pop   di
    dec   dl
    jz	  _Exit
    add   di,320	{ di = next line of sprite }
    jmp   _DrawLoop
_Exit:
    pop   ax
    pop   es
    pop   ds
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg16(X,Y:Word;sprt :img16;Where:Word); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X	   { ax = x }
    mov   bx,Y	   { bx = y }
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax

    mov     ax, bx		    {; ax = bx	x = y}
    mov     bh, bl		    {; y = y * 256  bx = bx * 256}
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1		    {; y = y * 64   ax = ax * 64}
    add     bx, ax		    {; y = (y*256) + (Y*64)  bx = bx + ax (ie y*320)}
    pop     ax			    {; get back our x}
    add     ax, bx		    {; finalise location}
    mov     di, ax
    mov   dl,16    { dl = height of sprite }
    xor   ch,ch
    mov   cl,16     { cx = width of sprite }
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di		{ store y adr. for later }
    mov   cx,ax 	 { store width }
_LineLoop:
    mov   bl,byte ptr [si]
    or	  bl,bl
    jnz   _Store
_NoPaint:
    inc    si
    inc    di
    loop   _LineLoop
    jmp    _NextLine
_Store:
    movsb
    loop  _LineLoop
_NextLine:
    pop   di
    dec   dl
    jz	  _Exit
    add   di,320	{ di = next line of sprite }
    jmp   _DrawLoop
_Exit:
    pop   ax
    pop   es
    pop   ds
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg24(X,Y:Word;sprt :img24;Where:Word); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X	   { ax = x }
    mov   bx,Y	   { bx = y }
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax

    mov     ax, bx		    {; ax = bx	x = y}
    mov     bh, bl		    {; y = y * 256  bx = bx * 256}
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1		    {; y = y * 64   ax = ax * 64}
    add     bx, ax		    {; y = (y*256) + (Y*64)  bx = bx + ax (ie y*320)}
    pop     ax			    {; get back our x}
    add     ax, bx		    {; finalise location}
    mov     di, ax
    mov   dl,24    { dl = height of sprite }
    xor   ch,ch
    mov   cl,24     { cx = width of sprite }
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di		{ store y adr. for later }
    mov   cx,ax 	 { store width }
_LineLoop:
    mov   bl,byte ptr [si]
    or	  bl,bl
    jnz   _Store
_NoPaint:
    inc    si
    inc    di
    loop   _LineLoop
    jmp    _NextLine
_Store:
    movsb
    loop  _LineLoop
_NextLine:
    pop   di
    dec   dl
    jz	  _Exit
    add   di,320	{ di = next line of sprite }
    jmp   _DrawLoop
_Exit:
    pop   ax
    pop   es
    pop   ds
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Cls (Where:word;Col : Byte);
BEGIN
     asm
	push	es
	mov	cx, 32000;
	mov	es,[where]
	xor	di,di
	mov	al,[col]
	mov	ah,al
	rep	stosw
	pop	es
     End;
END;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure LoadPal;
var i: byte;
begin
Assign(PalFile,'DATE\spec128.pal');
Reset(PalFile);
for i:=0 to 127 do
begin
read(PalFile,er);
read(PalFile,ge);
read(PalFile,be);
Paleta[i,1]:=er;
Paleta[i,2]:=ge;
Paleta[i,3]:=be;
Paleta[i+128,1]:=er;
Paleta[i+128,2]:=ge;
Paleta[i+128,3]:=be;
end;
Paleta[1,1]:=0;
Paleta[1,2]:=0;
Paleta[1,3]:=0;
Paleta[129,1]:=0;
Paleta[129,2]:=0;
Paleta[129,3]:=0;
Close(PalFile);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure NormlPal;
var i:integer;
begin
for i:=0 to 255 do
begin
Pal(i,paleta[i,1],paleta[i,2],paleta[i,3]);
end;
Pal(1,0,0,0);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg16b(X,Y:Word;sprt :img16;Where:Word); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint,_Tra;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X	   { ax = x }
    mov   bx,Y	   { bx = y }
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax

    mov     ax, bx		    {; ax = bx	x = y}
    mov     bh, bl		    {; y = y * 256  bx = bx * 256}
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1		    {; y = y * 64   ax = ax * 64}
    add     bx, ax		    {; y = (y*256) + (Y*64)  bx = bx + ax (ie y*320)}
    pop     ax			    {; get back our x}
    add     ax, bx		    {; finalise location}
    mov     di, ax
    mov   dl,16    { dl = height of sprite }
    xor   ch,ch
    mov   cl,16     { cx = width of sprite }
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di		{ store y adr. for later }
    mov   cx,ax 	 { store width }
_LineLoop:
    mov   bl,byte ptr [si]
    or	  bl,bl
    jnz   _Store
_NoPaint:
    inc    si
    inc    di
    loop   _LineLoop
    jmp    _NextLine
_Store:
    mov  bl,ds:[si]
    or bl,128
    mov  es:[di],bl
    inc  di
    inc  si
    loop  _LineLoop
_NextLine:
    pop   di
    dec   dl
    jz	  _Exit
    add   di,320	{ di = next line of sprite }
    jmp   _DrawLoop
_Exit:
    pop   ax
    pop   es
    pop   ds
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure LightPal;
var i:integer;
begin
for i:=0 to 255 do
begin
Pal(i,48+(paleta[i,1] div 4),48+(paleta[i,2] div 4),48+(paleta[i,3] div 4));
end;
Pal(1,63,63,63);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Fade(darkness:integer;frametoo:boolean);
var range,ji,er,ge,be:integer;
begin
range:=127;
if frametoo then range:=255;
for ji:=1 to range do
begin
er:=paleta[ji,1]-darkness*2;
ge:=paleta[ji,2]-darkness*2;
be:=paleta[ji,3]-darkness*2;
if er<0 then er:=0;
if ge<0 then ge:=0;
if be<0 then be:=0;
if er>63 then er:=63;
if ge>63 then ge:=63;
if be>63 then be:=63;
Pal(ji,er,ge,be);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure InitGr;
begin
cls(vga,0);
cls(vaddr,0);
cls(vaddr2,0);
VgaOn;
LoadPal;
Fade(31,true);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure FadeIn;
var fdi:byte;
begin
for fdi:=34 downto 0 do
begin
delay(10);
waitretrace;
Fade(fdi,false);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure FadeOut;
var fdi:byte;
begin
for fdi:=0 to 34 do
begin
delay(10);
waitretrace;
Fade(fdi,false);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
begin
end.