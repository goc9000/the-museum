{$X+}
unit Video;
interface
uses Dos,Crt,Logic,Strings,clok,sb_unit;
CONST VGA = $a000;
TYPE  Virtual = Array [1..64000] of byte;
      VirtPtr = ^Virtual;
      img8 = Array [1..8*8] of byte;
      img16 = Array [1..16*16] of byte;
      img24 = Array [1..24*24] of byte;
      img32 = Array [1..32*32] of byte;
VAR   synctype:integer;
      Virscr : VirtPtr;
      Virscr2 : VirtPtr;
      Virscr3 : VirtPtr;
      Vaddr  : word;
      Vaddr2  : word;
      Vaddr3  : word;
      tstr1:pchar;
      tstr2:pchar;
      tstr3:string;
      InitialMem: longint;
      Paleta  : array[0..255,1..3] of byte;
      PalFile : file of byte;
      er,ge,be:byte;
{ Real and virtual screens }
Procedure InitGr;
Procedure VgaOn;
Procedure VgaOff;
Procedure VrtOn;
Procedure VrtOff;
Procedure Flip(source,dest:Word);
Procedure WaitRetrace;
Procedure Cls (Where:word;Col : Byte);
{ Palette operations }
Procedure Pal(Col,R,G,B : Byte);
Procedure GetPal(Col : Byte; Var R,G,B : Byte);
Procedure Fade(Darkness:Integer);
Procedure FadeIn;
Procedure FadeOut;
{ Primitives }
Procedure TPixel (X,Y : Integer;where:word;wherefrom:word);
Procedure Pixel (X,Y : Integer;col:byte;where:word);
Function Point (X,Y : Integer;where:word):byte;
Procedure Line(a,b,c,d:integer;col:byte;where:word);
Procedure SLine(a,b,c,d:integer;where:word);
Procedure Rectangle(x1,y1,x2,y2:integer;col:byte;where:word);
procedure Box(x1,y1,x2,y2:integer;col:byte;where:word);
{ Images }
Procedure Putimg8(X,Y:Word;sprt :virtptr;Where:Word);
procedure putspc8(x,y:word;sprt:virtptr;where:word);
procedure putspc16(x,y:word;sprt:virtptr;where:word);
Procedure Putimg16(X,Y:Word;sprt :virtptr;Where:Word);
Procedure Putimg16K(X,Y:Word;sprt :virtptr;Where:Word;cucu:byte);
Procedure Putimg16L(X,Y:Word;sprt :virtptr;Where:Word;cucu:byte);
Procedure Putimg8A(X,Y:Word;sprt :virtptr;Where:Word;colr:byte);
Procedure Putimg8S(X,Y:Word;sprt :virtptr;Where:Word;colr:byte);
Procedure Putimg16S(X,Y:Word;sprt :virtptr;Where:Word;colr:byte);
Procedure Putimg168(X,Y:Word;sprt :virtptr;Where:Word);
Procedure Putimg168A(X,Y:Word;sprt :virtptr;Where:Word;colr:byte);
Procedure Putimg168G(X,Y:Word;sprt :virtptr;Where:Word;colr:byte);
Procedure Putimg168b(X,Y:Word;sprt :virtptr;Where:Word;colr:byte);
Procedure Putimg24(X,Y:Word;sprt :virtptr;Where:Word);
Procedure Putimg32(X,Y:Word;sprt :virtptr;Where:Word);
Procedure Putimg32S(X,Y:Word;sprt :virtptr;Where:Word);
Procedure putletter(X,Y:Word;sprt :virtptr;Where:Word;colr:byte);
Procedure LoadPcx(name:string;where:word);
implementation
uses General,Filez;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{                         Real and virtual screens                         }
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure InitGr;
begin
LoadPal;
VrtOn;
cls(vga,0);
cls(vaddr,0);
cls(vaddr2,0);
VgaOn;
Fade(31);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure VgaOn;
begin
  asm
     mov        ax,0013h
     int        10h
  end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure VgaOff;
begin
  asm
     mov        ax,0003h
     int        10h
  end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure VrtOn;
begin
  GetMem (VirScr,64000);
  GetMem (VirScr2,64000);
  GetMem (VirScr3,64000);
  vaddr := seg (virscr^);
  vaddr2 := seg (virscr2^);
  vaddr3 := seg (virscr3^);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure VrtOff;
begin
  FreeMem (VirScr,64000);
  FreeMem (VirScr2,64000);
  FreeMem (VirScr3,64000);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{procedure DirtyTrick;
begin
inline ($F3/$66/$A5);
end;
 }
Procedure Flip(source,dest:Word);assembler;
  asm
    cld
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
{
Procedure Flip(source,dest:Word);
begin
inline ($FC/$1E/$8B/$46/<source/$8E/$C0/$8B/$46/<dest/$8E/$D8/$33/$F6/$33/$FF/$B9/
       $00/$60/$F3/$66/$A5/$1F);
end;
}
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure WaitRetrace;
label
  l1, l2;
begin
inc(sb_ready);
if sb_ready>2 then sb_ready:=2;
if synctype=2 then
begin
asm
    cli
    mov dx,3DAh
l1:
    in al,dx
    and al,08h
    jnz l1
l2:
    in al,dx
    and al,08h
    jz  l2
    sti
end;
end
else
begin
while not (fluff=stepv) do;
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Cls (Where:word;Col : Byte);
begin
     asm
        push    es
        mov     cx, 32000;
        mov     es,[where]
        xor     di,di
        mov     al,[col]
        mov     ah,al
        rep     stosw
        pop     es
     end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{                            Palette operations                            }
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Pal(Col,R,G,B : Byte);
begin
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
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure GetPal(Col : Byte; Var R,G,B : Byte);
Var
   rr,gg,bb : Byte;
begin
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
Procedure Fade(darkness:integer);
var range,ji,er,ge,be:integer;
begin
for ji:=0 to 255 do
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
Procedure FadeIn;
var fdi:byte;
begin
for fdi:=31 downto 0 do
begin
delay(20);
waitretrace;
Fade(fdi);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure FadeOut;
var fdi:byte;
begin
for fdi:=0 to 31 do
begin
delay(20);
waitretrace;
Fade(fdi);
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{                               Primitives                                 }
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure TPixel(X,Y : Integer;where:word;wherefrom:word);
var a3:word;
begin
a3:=y*32;
a3:=a3*10;
a3:=a3+x;
mem[where:a3]:=mem[wherefrom:a3];
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Pixel (X,Y : Integer; Col : Byte; where:word);
begin
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
  end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Function Point (X,Y : Integer;where:word):byte;
begin
Point:=mem[where:X+Y*320];
end;
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
Procedure SLine(a,b,c,d:integer;where:word);
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
          pixel(a,b,point(a,b,vaddr),where);
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
procedure Rectangle(x1,y1,x2,y2:integer;col:byte;where:word);
begin
if x2<x1 then SwapI(x1,x2);
if y2<y1 then SwapI(y1,y2);
line(x1,y1,x2,y1,col,where);
line(x2,y1,x2,y2,col,where);
line(x1,y2,x2,y2,col,where);
line(x1,y1,x1,y2,col,where);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure Box(x1,y1,x2,y2:integer;col:byte;where:word);
begin
if x2<x1 then SwapI(x1,x2);
if y2<y1 then SwapI(y1,y2);
for i:=y1 to y2 do line (x1,i,x2,i,col,where);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{                                 Images                                   }
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg8(X,Y:Word;sprt :virtptr;Where:Word); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax
    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,8
    xor   ch,ch
    mov   cl,8
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
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
    jz    _Exit
    add   di,320
    jmp   _DrawLoop
_Exit:
    pop   ax
    pop   es
    pop   ds
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putspc16(X,Y:Word;sprt :virtptr;Where:Word); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax
    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 6
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,16
    xor   ch,ch
    mov   cl,8
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    movsw
    loop  _LineLoop
_NextLine:
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
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putspc8(X,Y:Word;sprt :virtptr;Where:Word); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax
    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 6
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,8
    xor   ch,ch
    mov   cl,4
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    movsw
    loop  _LineLoop
_NextLine:
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
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg16(X,Y:Word;sprt :virtptr;Where:Word); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax
    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 6
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,16
    xor   ch,ch
    mov   cl,16
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
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
    jz    _Exit
    add   di,320
    jmp   _DrawLoop
_Exit:
    pop   ax
    pop   es
    pop   ds
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg16K(X,Y:Word;sprt :virtptr;Where:Word;cucu:byte);
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint;
var cucu2,cucu3:integer;
begin
cucu2:=320;
cucu3:=16-cucu;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax
    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 6
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,16
    xor   ch,ch
    mov   cl,cucu
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
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
    add si,cucu3
    pop   di
    dec   dl
    jz    _Exit
    add   di,cucu2
    jmp   _DrawLoop
_Exit:
    pop   ax
    pop   es
    pop   ds
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg16L(X,Y:Word;sprt :virtptr;Where:Word;cucu:byte);
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint;
var cucu2,cucu3:integer;
begin
cucu2:=320;
cucu3:=16-cucu;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax
    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,16
    xor   ch,ch
    mov   cl,cucu
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    add si,cucu3
    mov   cx,ax
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
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
    jz    _Exit
    add   di,cucu2
    jmp   _DrawLoop
_Exit:
    pop   ax
    pop   es
    pop   ds
end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg8A(X,Y:Word;sprt :virtptr;Where:Word;colr:byte); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint,_Nah;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax
    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,8
    xor   ch,ch
    mov   cl,8
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
    jnz   _Store
_NoPaint:
    inc    si
    inc    di
    loop   _LineLoop
    jmp    _NextLine
_Store:
    mov  bl,ds:[si]
    cmp bl,0
    jz _nah
    add bl,colr
_Nah:
    mov  es:[di],bl
    inc    si
    inc    di
    loop  _LineLoop
_NextLine:
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
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg8S(X,Y:Word;sprt :virtptr;Where:Word;colr:byte); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint,_Nah;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax
    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,8
    xor   ch,ch
    mov   cl,8
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
    jnz   _Store
_NoPaint:
    inc    si
    inc    di
    loop   _LineLoop
    jmp    _NextLine
_Store:
    mov  bl,ds:[si]
    cmp bl,0
    jz _nah
    and bl,31
    add bl,128
    add bl,colr
_Nah:
    mov  es:[di],bl
    inc    si
    inc    di
    loop  _LineLoop
_NextLine:
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
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg16S(X,Y:Word;sprt :virtptr;Where:Word;colr:byte); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint,_Nah;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax
    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,16
    xor   ch,ch
    mov   cl,16
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
    jnz   _Store
_NoPaint:
    inc    si
    inc    di
    loop   _LineLoop
    jmp    _NextLine
_Store:
    mov  bl,ds:[si]
    cmp bl,0
    jz _nah
    and bl,31
    add bl,128
    add bl,colr
_Nah:
    mov  es:[di],bl
    inc    si
    inc    di
    loop  _LineLoop
_NextLine:
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
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg168(X,Y:Word;sprt :virtptr;Where:Word); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax
    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,8
    xor   ch,ch
    mov   cl,16
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
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
    jz    _Exit
    add   di,320
    jmp   _DrawLoop
_Exit:
    pop   ax
    pop   es
    pop   ds
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg168A(X,Y:Word;sprt :virtptr;Where:Word;colr:byte); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint,_Nah;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax
    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,8
    xor   ch,ch
    mov   cl,16
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
    jnz   _Store
_NoPaint:
    inc    si
    inc    di
    loop   _LineLoop
    jmp    _NextLine
_Store:
    mov  bl,ds:[si]
    test bl, 240
    jz _Nah
    add bl,colr
_Nah:
    mov  es:[di],bl
    inc    si
    inc    di
    loop  _LineLoop
_NextLine:
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
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg168G(X,Y:Word;sprt :virtptr;Where:Word;colr:byte); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax
    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,8
    xor   ch,ch
    mov   cl,16
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
    jnz   _Store
_NoPaint:
    inc    si
    inc    di
    loop   _LineLoop
    jmp    _NextLine
_Store:
    mov  bl,ds:[si]
    and  bl,[colr]
    mov  es:[di],bl
    inc    si
    inc    di
    loop  _LineLoop
_NextLine:
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
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg168b(X,Y:Word;sprt :virtptr;Where:Word;colr:byte); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint,_cucu;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax
    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,8
    xor   ch,ch
    mov   cl,16
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
    jnz   _Store
_NoPaint:
    inc    si
    inc    di
    loop   _LineLoop
    jmp    _NextLine
_Store:
    mov  bl,ds:[si]
    cmp  bl,16
    jb _cucu
    and bl,15
    sub bl,[colr]
    _cucu:
    mov  es:[di],bl
    inc    si
    inc    di
    loop  _LineLoop
_NextLine:
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
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg24(X,Y:Word;sprt :virtptr;Where:Word); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax

    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,24
    xor   ch,ch
    mov   cl,24
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
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
    jz    _Exit
    add   di,320
    jmp   _DrawLoop
_Exit:
    pop   ax
    pop   es
    pop   ds
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg32(X,Y:Word;sprt :virtptr;Where:Word); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax

    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,32
    xor   ch,ch
    mov   cl,32
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
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
    jz    _Exit
    add   di,320
    jmp   _DrawLoop
_Exit:
    pop   ax
    pop   es
    pop   ds
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putimg32S(X,Y:Word;sprt :virtptr;Where:Word); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X
    mov   bx,Y
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax

    mov     ax, bx
    mov     bh, bl
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    add     bx, ax
    pop     ax
    add     ax, bx
    mov     di, ax
    mov   dl,32
    xor   ch,ch
    mov   cl,32
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di
    mov   cx,ax
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
    jnz   _Store
_NoPaint:
    inc    si
    inc    di
    loop   _LineLoop
    jmp    _NextLine
_Store:
    mov  bl,ds:[si]
    mov bl,1
    mov  es:[di],bl
    inc  di
    inc  si
    loop  _LineLoop
_NextLine:
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
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure putletter(X,Y:Word;sprt :virtptr;Where:Word;colr:byte); ASSEMBLER;
label
  _Redraw, _DrawLoop, _Exit, _LineLoop, _NextLine, _Store, _NoPaint,_Tra;
asm
    push  ds
    push  es
    lds   si,Sprt
    mov   ax,X     { ax = x }
    mov   bx,Y     { bx = y }
_Redraw:
    push    ax
    mov     ax,[where]
    mov     es,ax

    mov     ax, bx                  {; ax = bx  x = y}
    mov     bh, bl                  {; y = y * 256  bx = bx * 256}
    xor     bl, bl
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1
    shl     ax, 1                   {; y = y * 64   ax = ax * 64}
    add     bx, ax                  {; y = (y*256) + (Y*64)  bx = bx + ax (ie y*320)}
    pop     ax                      {; get back our x}
    add     ax, bx                  {; finalise location}
    mov     di, ax
    mov   dl,8    { dl = height of sprite }
    xor   ch,ch
    mov   cl,8     { cx = width of sprite }
    cld
    push  ax
    mov   ax,cx
_DrawLoop:
    push  di            { store y adr. for later }
    mov   cx,ax          { store width }
_LineLoop:
    mov   bl,byte ptr [si]
    or    bl,bl
    jnz   _Store
_NoPaint:
    inc    si
    inc    di
    loop   _LineLoop
    jmp    _NextLine
_Store:
    mov  bl,ds:[si]
    mov bh,bl
    and bh,224
    shr bh,5
    cmp bh,1
    jnz _Tra
    push ax
    and bl,15
    mov al,colr
    shl al,5
    add bl,al
    pop ax
_Tra:
    mov  es:[di],bl
    inc  di
    inc  si
    loop  _LineLoop
_NextLine:
    pop   di
    dec   dl
    jz    _Exit
    add   di,320        { di = next line of sprite }
    jmp   _DrawLoop
_Exit:
    pop   ax
    pop   es
    pop   ds
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure LoadPcx(name:string;where:word);
var offset:word;
    leng:byte;
    datar:byte;
    pcxf:file of byte;
label looped,donel;
begin
assign(pcxf,name);
reset(pcxf);
offset:=0;
seek(pcxf,128);
looped:
if offset>63999 then goto donel;
read(pcxf,leng);
if leng<193 then mem[where:offset]:=255-leng;
if leng<193 then inc(offset);
if leng<193 then goto looped;
read(pcxf,datar);
for i:=1 to (leng-192) do begin
mem[where:offset]:=255-datar;
inc(offset);
end;
goto looped;
donel:
close(pcxf);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{                                  Main                                    }
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
begin
end.