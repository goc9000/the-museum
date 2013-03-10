Unit Inter_SB;
interface
Uses CRT,DOS,SB_Unit;
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
implementation
function SBInit(basse:word;irrq,dmma:byte):boolean;
label fail;
var res:boolean;
begin
   res:=false;
   Base:=(basse*16)+512;
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
   If (ReadError <> 0)
      then
         Begin
            Writeln('Ain`t here dude');
            Halt(2);
         end;
   Size := 19;
   ReadBuffer(FileHandle,@VOCHeader,Size,ReadError);
   If Not(VOCHeader = 'Creative Voice File')
      then
         Begin
            Writeln('Garbled, dude');
            Halt(2);
         end;
   Size := 13;
   ReadBuffer(FileHandle,@VOCHeader,Size,ReadError);
   If (VOCHeader[7] = #1)
      then
         SampleRate := word (VOCHeader[11])
      else
         Begin
            Writeln('Weir`, dude');
            Halt(4);
         end;
   SampleRate := word (1000000 div (256 - SampleRate));
   SB_MakeDMABuffer(Buffer1,BufferSize div $10);
   If ((Buffer1 = nil))
      then
         Begin
            Writeln('Can`t remember dude');
            Halt(5);
         end;
   ReadError := 0;
   SB_DMAComplete := TRUE;
   Size := BufferSize;
      ReadBuffer(FileHandle,Buffer1,Size,ReadError);
      If (ReadError <> 0)
         then
            Begin
               Writeln('Dunno h`to read, dude');
               Halt(2);
            end;
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
