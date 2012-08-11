unit rutvid;
interface
Procedure Sinc;
Procedure Pal(Col,R,G,B : Byte);
Procedure Pixel (X,Y : Integer; Col : Byte);
Function Punct (X,Y : Integer):byte;
Procedure Linie(a,b,c,d:integer;col:byte);
Procedure Stgec;
procedure initvideo;
procedure deinitvideo;
Procedure sprite(X,Y:word;sx,sy:byte;salt1,salt2:word;VAR sprt:array of byte);
implementation
Procedure Sinc; assembler;
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
Procedure Pixel (X,Y : Integer; Col : Byte);
begin
  Asm
    push    ds
    push    es
    mov     ax,$A000
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
  end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Stgec;
var cx,cy:integer;
begin
for cx:=0 to 319 do for cy:=0 to 199 do pixel(cx,cy,0);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Function Punct (X,Y : Integer):byte;
begin
Punct:=mem[$A000:X+Y*320];
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Linie(a,b,c,d:integer;col:byte);
  function sgn(a:real):integer;
  begin
       if a>0 then sgn:=+1;
       if a<0 then sgn:=-1;
       if a=0 then sgn:=0;
  end;
var i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;
begin
     u:= c - a; v:= d - b; d1x:= SGN(u); d1y:= SGN(v); d2x:= SGN(u); d2y:= 0;
     m:= ABS(u); n := ABS(v);
     IF NOT (M>N) THEN BEGIN
                       d2x := 0 ;
                       d2y := SGN(v);
                       m := ABS(v);
                       n := ABS(u);
                       END;
     s := m shr 1;
     FOR i := 0 TO m DO
     BEGIN
          pixel(a,b,col);
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
procedure initvideo;assembler;
  asm
     mov        ax,0013h
     int        10h
  end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure deinitvideo;assembler;
  asm
     mov        ax,0003h
     int        10h
  end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure sprite(X,Y:word;sx,sy:byte;salt1,salt2:word;VAR sprt:array of byte); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,$a000
    mov     es,ax
    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 6
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,[sy]
    xor   ch,ch
    mov   cl,[sx]
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    add si,salt2
    mov   cx,ax
_LineLoop:
{
    mov   bl,byte ptr [si]
    or    bl,bl
    jnz   _Store
_NoPaint:
    inc    si
    inc    di
    loop   _LineLoop
    jmp    _NextLine
_Store:}
    movsb
    loop  _LineLoop
_NextLine:
    add   si,salt1
    pop   di
    dec   dl
    jz    _Exit
    add   di,320
    jmp   _DrawLoop
_Exit:
    pop   ax
    pop   es
    pop   ds
end;

begin
end.