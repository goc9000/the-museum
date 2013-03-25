Unit Inter_SB;
interface
Uses CRT,DOS,SB_Unit,General;
Const
   DEFAULT_BUFFER : word = 8000;
   DEFAULT_IRQ : byte = 5;
   DEFAULT_DMA : byte = 1;
Var
   FileStr : String[80];
   FileName : Array[1..80] of char;
   Loop : integer;
   FullFilename : boolean;
   FileHandle : word;
   ReadError : byte;
   Base : word;
   IRQ,
   DMA : byte;
   Blaster,
   Param : string[20];
   Err : integer;
   BufferSize : word;
   VOCHeader : Array[0..18] of char;
function SBInit(basse:word;irrq,dmma:byte):boolean;
procedure LoadVoc(FileStr:string;var Buffer1:pointer;var Siz:word;var rate:word);
function GetVars(var baz,irk,dme:integer):boolean;
implementation
function GetVars(var baz,irk,dme:integer):boolean;
var err:integer;
    res:boolean;
    blaster:string[20];
begin
   res:=true;
   Blaster := GetEnv('BLASTER');
   Err := 0;
   if blaster='' then err:=210;
   While (Blaster <> '') and (Err = 0) do
      Case Blaster[1] of
         'A','a' : Begin         { Base address. }
                      Val(Blaster[2]+Blaster[3]+Blaster[4],Baz,Err);
                      Baz := ((Baz mod 200) div 10)*16 + 512;
                      If (Err = 0)
                        then
                           Blaster := Copy(Blaster,5,Length(Blaster)-4);
                   end;
         'I','i' : Begin         { IRQ }
                      Val(Blaster[2],IRk,Err);
                      If (Err = 0)
                        then
                           Blaster := Copy(Blaster,3,Length(Blaster)-2);
                   end;
         'D','d' : Begin         { DMA channel. }
                      Val(Blaster[2],DMe,Err);
                      If (Err = 0)
                        then
                           Blaster := Copy(Blaster,3,Length(Blaster)-2);
                   end;
         else    { Step past extraneous characters. }
            Blaster := Copy(Blaster,2,Length(Blaster)-1);
      end;
if (err>0) then res:=false;
GetVars:=res;
end;
function SBInit(basse:word;irrq,dmma:byte):boolean;
label fail;
var res:boolean;
begin
   res:=false;
   Base:= basse;
   IRQ := irrq;
   DMA := dmma;
   SB_SetBaseAddr(Base);
   SB_SetIRQ(IRQ);
   SB_SetDMAChannel(DMA);
   If Not(SB_DSPReset(Base)) then goto fail;
   res:=true;
   SB_Speaker(1);
   SB_SetIntHandler;
fail:
SBInit:=res;
end;

Procedure ReadBuffer(Handle : word; Buffer : pointer; Var Size : word;
                     Var Error : byte);
      assembler;
      asm
         cld
         push  ds
         mov   ax,word ptr Buffer+2
         mov   ds,ax
         mov   dx,word ptr Buffer
         mov   bx,Handle
         mov   es,word ptr Size+2
         mov   si,word ptr Size
         mov   di,word ptr Error
         mov   cx,es:[si]
         mov   ah,3Fh
         int   21h
         jnc   @@Success
         @@Fail:
            mov   es,word ptr Error+2
            mov   es:[di],al
            jmp   @@Finish
         @@Success:
            mov   es:[si],ax
            mov   es,word ptr Error+2
            mov   al,0
            mov   es:[di],al
         @@Finish:
            pop   ds
      end;

procedure LoadVoc(FileStr:string;var Buffer1:pointer;var Siz:word;var rate:word);
var Size:word;
    SampleRate:word;
begin
   FullFilename := FALSE;
   For Loop := 1 to Ord(FileStr[0]) do
      Begin
         FileName[Loop] := FileStr[Loop];
         If FileName[Loop] = '.'
            then
               FullFilename := TRUE;
      end;
   Inc(Loop);
   FileName[Loop] := #0;
      asm
      push  ds
      mov   ax,seg FileName
      mov   ds,ax
      mov   dx,offset FileName
      mov   ax,3D00h
      int   21h
      jnc   @@Success
      @@Fail:
         mov   [ReadError],al
         jmp   @@Finish
      @@Success:
         mov   [FileHandle],ax
         mov   [ReadError],0
      @@Finish:
         pop   ds
   end;
   Size := 19;
   ReadBuffer(FileHandle,@VOCHeader,Size,ReadError);
   If Not(VOCHeader = 'QAZWSXEDCRFVTGBYHNJ') then Fuckup('SFX file is corrupted !');
   Size := 13;
   ReadBuffer(FileHandle,@VOCHeader,Size,ReadError);
   If (VOCHeader[7] = #1)
      then
         SampleRate := word (VOCHeader[11])
      else
         Fuckup('SFX file is corrupted !');
   SampleRate := word (1000000 div (256 - SampleRate));
   SB_MakeDMABuffer(Buffer1,BufferSize div $10);
   If ((Buffer1 = nil))
      then Fuckup('Memory allocation error !');
   ReadError := 0;
   SB_DMAComplete := TRUE;
   Size := BufferSize;
      ReadBuffer(FileHandle,Buffer1,Size,ReadError);
      If (ReadError <> 0)
         then Fuckup('Error reading SFX file !');
Siz:=size;
Rate:=samplerate;
end;

procedure ShutUp;
begin
   SB_StopDMA;
   SB_DSPReset(Base);
   SB_Speaker(0);
   SB_ResetIntHandler;
end;

Begin
end.
