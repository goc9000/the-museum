unit clok;
interface
Uses Crt, Dos;
var fluff:word;
    tix,factor:integer;
    stepv:byte;
{$F+} { Force far mode, a good idea when mucking around with interrupts }
procedure SyncOn;
procedure SyncOff;
implementation
const TIMERINTR = 8;
       PIT_FREQ = $1234DD;

var BIOSTimerHandler : procedure;
    clock_ticks, counter : longint;
procedure SetTimer(TimerHandler : pointer; frequency : word);
begin

  { Do some initialization }
  clock_ticks := 0;
  counter := $1234DD div frequency;

  { Store the current BIOS handler and set up our own }
  GetIntVec(TIMERINTR, @BIOSTimerHandler);
  SetIntVec(TIMERINTR, TimerHandler);

  { Set the PIT channel 0 frequency }
  Port[$43] := $34;
  Port[$40] := counter mod 256;
  Port[$40] := counter div 256;
end;
procedure CleanUpTimer;
begin
  { Restore the normal clock frequency }
  Port[$43] := $34;
  Port[$40] := 0;
  Port[$40] := 0;

  { Restore the normal ticker handler }
  SetIntVec(TIMERINTR, @BIOSTimerHandler);
end;

procedure Handler; Interrupt;
begin

  { DO WHATEVER WE WANT TO DO IN HERE }
  inc(fluff);
  if fluff>stepv then
  begin
  fluff:=0;
  tix:=tix+factor;
  end;
  { Adjust the count of clock ticks }
  clock_ticks := clock_ticks + counter;

  { Is it time for the BIOS handler to do it's thang? }
  if clock_ticks >= $10000 then
    begin

      { Yep! So adjust the count and call the BIOS handler }
      clock_ticks := clock_ticks - $10000;

      asm pushf end;
      BIOSTimerHandler;
    end

  { If not then just acknowledge the interrupt }
  else
    Port[$20] := $20;
end;
procedure SyncOn;
begin
SetTimer(Addr(Handler), 2);
end;
procedure SyncOff;
begin
CleanUpTimer;
end;
begin
end.
