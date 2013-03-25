Unit Logic;
Interface
{ Loops }
Var i, j, k: Integer;
  anim: Integer;
  animh:integer;
  { Loopers }
Procedure Animate;
{ Swappers }
Procedure SwapI (Var I1, I2: Integer);
{ Converters }
Function FourBytesToLongint (b1,b2,b3,b4:byte):longint;
Procedure LongintToFourBytes (lit:longint; var b1,b2,b3,b4:byte);
Implementation
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{                                 Loopers                                  }
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure Animate;
Begin
  inc(anim);
  If anim > 23 Then anim := 0;
  inc(animh);
  If animh > 15 Then animh := 0;
End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{                                 Swappers                                 }
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure SwapI (Var I1, I2: Integer);
Var Ex: Integer;
Begin
  Ex := I1;
  I1 := I2;
  I2 := Ex;
End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{                                Converters                                }
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Function FourBytesToLongint (b1,b2,b3,b4:byte):longint;
var res:longint;
begin
res:=(b1*16777216)+(b2*65536)+(b3*256)+b4;
FourBytesToLongint:=res;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure LongintToFourBytes (lit:longint; var b1,b2,b3,b4:byte);
var res:longint;
begin
res:=lit;
b1:=res div 16777216;
res:=res-(b1*16777216);
b2:=res div 65536;
res:=res-(b2*65536);
b3:=res div 256;
b4:=res-(b3*256);
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
{                                    Main                                  }
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Begin
End.