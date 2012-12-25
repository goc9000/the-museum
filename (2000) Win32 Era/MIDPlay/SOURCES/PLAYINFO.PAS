unit PlayInfo;
{
  Routines shared by all the Play objects. These are things
  that everyone can do, or at least that can be done on more
  than one device.

  Status: Beta
  Date: 5/16/93

  Copyright (c) June 1993, by Charlie Calvert
  Feel free to use this code as an adjunct to your own programs.
}

interface
uses
  Strings,
  MMSystem,
  WinProcs,
  WinTypes;

const
  MsgLen = 200;

var
  eroaremci:longint;
  wDeviceID: Word;
  PlayWindow: HWnd;
function Playfromto(mfrom,mto:longint): Boolean; export;
function Playfrom(mfrom:longint): Boolean; export;
function CloseMCI: Boolean; export;
function ErrorMsg(Error: LongInt; Msg: PChar): Boolean; export;
function GetDeviceID: Word; export;
function GetInfo(S: PChar): PChar; export;
function GetLen: Longint; export;
function GetLocation: LongInt; export;
function GetMode: Longint; export;
function OpenMCI(PWindow: HWnd; FileName, DeviceType: PChar): Boolean; export;
function PlayMCI: Boolean; export;
function SetTimeFormatMs: Boolean; export;
function StopMci: Boolean; export;

implementation

function CloseMci: Boolean;
var
  Result: LongInt;
  S1: array[0..MsgLen] of Char;
begin
  CloseMci := True;
  Result := mciSendCommand(wDeviceID, MCI_Close, 0, 0);
  if Result <> 0 then begin
    CloseMci := False;
    ErrorMsg(Result, S1);
    exit;
  end;
  wDeviceID := 0;
end;

function GetDeviceId: Word;
begin
  GetDeviceId := wDeviceId;
end;

function GetErrorMessage(RC:LongInt; S: PChar): PChar;
begin
  if not mciGetErrorString(RC, S, MsgLen) then
    StrCopy(S, 'No message available');
  GetErrorMessage := S;
end;

function ErrorMsg(Error: LongInt; Msg: PChar): Boolean;
var
  S, S1: array[0..MsgLen] of Char;
begin
eroaremci:=error;
{  ErrorMsg := True;
  StrCopy(S, 'Return Code: ');
  Str(Error:5, S1);
  StrCat(S, S1);
  StrCat(S, Msg);
  StrCat(S, GetErrorMessage(Error, S1));
  if Error <> 0 then begin
    MessageBox(0, S1, 'Information', mb_OK);
    ErrorMsg := False;
  end;}
end;

function GetInfo(S: PChar): PChar;
var
  Info: TMci_Info_Parms;
  Flags: LongInt;
  S1: array[0..MsgLen] of Char;
  Result: LongInt;
begin
  Info.dwCallBack := 0;
  Info.lpstrReturn := S;
  Info.dwRetSize := MsgLen;
  Flags := Mci_Info_Product;
  Result := mciSendCommand(wDeviceID, Mci_Info, Flags, LongInt(@Info));
  ErrorMsg(Result, S1);
  GetInfo := S;
end;

function GetLen: Longint;
var
  Info: TMci_Status_Parms;
  Flags,
  Result: LongInt;
  S1: array [0..MsgLen] of Char;
begin
  FillChar(Info, SizeOf(TMci_Status_Parms), 0);
  Info.dwItem := Mci_Status_Length;
  Flags := Mci_Status_Item;
  Result := MciSendCommand(wDeviceID, Mci_Status, Flags, LongInt(@Info));
  if Result <> 0 then begin
    ErrorMsg(Result, S1);
    exit;
  end;
  GetLen := Info.dwReturn;
end;

function GetLocation: LongInt;
var
  Info: TMci_Status_Parms;
  Flags: LongInt;
  Result: LongInt;
  S: array[0..MsgLen] of Char;

begin
  Info.dwItem := Mci_Status_Position;
  Flags := Mci_Status_Item;
  Result := MciSendCommand(wDeviceID, Mci_Status, Flags, LongInt(@Info));
  if Result <> 0 then begin
    ErrorMsg(Result, S);
    Exit;
  end;
  GetLocation := Info.dwReturn;
end;

function GetMode: Longint;
var
  Info: TMci_Status_Parms;
  Flags,
  Result: LongInt;
  S1: array [0..MsgLen] of Char;
begin
  FillChar(Info, SizeOf(TMci_Status_Parms), 0);
  Info.dwItem := Mci_Status_Mode;
  Flags := Mci_Status_Item;
  Result := MciSendCommand(wDeviceID, Mci_Status, Flags, LongInt(@Info));
  if Result <> 0 then begin
    ErrorMsg(Result, S1);
    exit;
  end;
  GetMode := Info.dwReturn;
end;

function OpenMCI(PWindow: HWnd; FileName, DeviceType: PChar): Boolean;
var
  OpenParms: TMci_Open_Parms;
  Style: LongInt;
  Result: LongInt;
  S1: array [0..MsgLen] of Char;
begin
  OpenMCI := True;
  PlayWindow := PWindow;
  OpenParms.lpstrDeviceType := DeviceType;
  OpenParms.lpstrElementName := FileName;
  Style := Mci_Open_Type or Mci_Open_Element;
  Result := MciSendCommand(0, MCI_OPEN, Style, LongInt(@OpenParms));
  if Result <> 0 then begin
    OpenMCI := False;
    ErrorMsg(Result, S1);
    exit;
  end;
  wDeviceId := OpenParms.wDeviceID;
end;

function PlayMCI: Boolean;
var
  Result: LongInt;
  Info: TMci_Play_Parms;
  S1: array[0..MsgLen] of Char;
begin
  PlayMci := True;
  Info.dwCallBack := PlayWindow;
  Result := MciSendCommand(wDeviceID, Mci_Play, Mci_Notify, LongInt(@Info));
  if Result <> 0 then begin
    PlayMci := False;
    ErrorMsg(Result, S1);
    exit;
  end;
end;

function Playfromto(mfrom,mto:longint): Boolean;
var
  Result: LongInt;
  Info: TMci_Play_Parms;
  S1: array[0..MsgLen] of Char;
begin
  Playfromto := True;
  Info.dwCallBack := PlayWindow;
  Info.dwFrom:=mfrom;
  Info.dwto:=mto;
  Result := MciSendCommand(wDeviceID, Mci_Play, Mci_Notify or Mci_From or Mci_to, LongInt(@Info));
  if Result <> 0 then begin
    Playfromto := False;
    ErrorMsg(Result, S1);
    exit;
  end;
end;

function Playfrom(mfrom:longint): Boolean;
var
  Result: LongInt;
  Info: TMci_Play_Parms;
  S1: array[0..MsgLen] of Char;
begin
  Playfrom := True;
  Info.dwCallBack := PlayWindow;
  Info.dwFrom:=mfrom;
  Result := MciSendCommand(wDeviceID, Mci_Play, Mci_Notify or Mci_From, LongInt(@Info));
  if Result <> 0 then begin
    Playfrom := False;
    ErrorMsg(Result, S1);
    exit;
  end;
end;

function SetTimeFormatMS: Boolean;
var
  Info: TMci_Set_Parms;
  Flags,
  Result: LongInt;
  S1: array [0..MsgLen] of Char;
begin
  SetTimeFormatMS := True;
  Info.dwTimeFormat := Mci_Format_Milliseconds;
  Flags := Mci_Set_Time_Format;
  Result := MciSendCommand(wDeviceID, MCI_Set, Flags, LongInt(@Info));
  if Result <> 0 then begin
    ErrorMsg(Result, S1);
    SetTimeFormatMS := False;
  end;
end;

function StopMci: Boolean;
var
  Result: LongInt;
  Info: TMci_Generic_Parms;
  S1: array[0..MsgLen] of Char;
begin
  StopMci := True;
  Info.dwCallBack := 0;
  Result := MciSendCommand(wDeviceID, Mci_Stop, Mci_Notify, LongInt(@Info));
  if Result <> 0 then begin
    StopMci := False;
    ErrorMsg(Result, S1);
    exit;
  end;
end;

begin
  wDeviceId := 0;
end.