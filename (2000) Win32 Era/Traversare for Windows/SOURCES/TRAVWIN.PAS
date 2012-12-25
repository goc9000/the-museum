program Traversare;
{TOATE MASINILE IN FISIER VOR AVEA H=20}
{VEZI PROBL. CU MASINILE PREA ALATURATE}
{$R TRAVWIN}
{$X+}
uses
 windos,WinTypes, WinProcs, OWindows, ODialogs, Strings, BWCC,wincrt,win31{,playinfo},mmsystem;
const nmas=450;
      INTT=8;
var randuri:array[0..11,1..3] of integer;
    su_clax,su_moto:integer;
    a_crasti:integer;
    a_muzik:integer;
    a_kablam:integer;
    a_nivel:integer;
    a_gandesc:integer;
    han:hmidiout;
    clock_ticks, counter : longint;
    modjoc:integer;
    tic:integer;
    stringuri:array[0..5000] of char;
    dublu:integer;
    i,j,k,l:longint;
    gt:longint;
    tmproc:tfarproc;
    mainw:hwnd;
    sv:integer;
    iac_s1,iac_s2,iac_s3:array[0..1000] of char;
    fig:longint;
    OPT_TIPSINC:integer;
    OPT_MHZS2:integer;
    OPT_SUNET:boolean;
    BOPT_TIPSINC:integer;
    BOPT_MHZS2:integer;
    T_astept:integer;
type
  TApp = object(TApplication)
    procedure InitMainWindow; virtual;
    function IdleAction:boolean; virtual;
  end;
  PferJoc = ^TferJoc;
  TferJoc = object(TWindow)
    umemdc,dc:hdc;
    scor:longint;
    restac:boolean;
    ptr1:pointer;
    recd:longint;
    scr_cul,scr_ofs,scr_poz:longint;
    Hazarde: HBitMap;
    Barascor:hbitmap;
    fonttrav:hbitmap;
    sejoaca:boolean;
    Zona_joc:Hbitmap;
    xom,yom,som:integer;
    tict:integer;
    nxom,nyom:integer;
    tic:integer;
    anim:integer;
    animscr:integer;
    vieti:integer;
    anmas:integer;
    bravo:integer;
    nivel:integer;
    iesim,intram:boolean;
    masini:array[1..nmas,1..5] of integer;
    _reset:boolean;
    pb:integer;
    dific:integer;
    icn1,om1,om2,om3,om4,om5,om6,om7,om8,om9,om10,om11: Hicon;
    rec1:trect;
    constructor Init(AParent: PWindowsObject; Title: PChar);
    procedure PutBMP(TDC: HDC; X, Y, BitMap: HBitMap; W,H,x2,y2:integer);
    procedure GetWindowClass(var WndClass: TWndClass); virtual;
    procedure Paint(PaintDC: HDC; var PaintInfo: TPaintStruct); virtual ;
    procedure Rect(TDC:HDC;R1,R2,R3,R4:integer; Col:Tcolorref);
    procedure Rct2(TDC:HDC;R1,R2,R3,R4:integer; Col:Tcolorref);
    procedure Splatci(TDC:HDC;X1,Y1:integer; Col:Tcolorref);
    procedure IRect(r1,r2,r3,r4:integer);
    procedure SetUpWindow; virtual;
    procedure WMEraseBkGND (var Message: Tmessage); virtual wm_Erasebkgnd+wm_First;
    procedure WMClose (var Message: Tmessage); virtual wm_Close;
    procedure WMCommand (var Message: Tmessage); virtual wm_Command;
    procedure WMDestroy(var Message: TMessage); virtual wm_Destroy;
    procedure Scrie (tx,ty:integer;ce:string);
    procedure ScrieMC (tx,ty:integer;ce:string;culs:integer);
    function DetColiz:boolean;
    procedure RemsCor;
    procedure DessCor;
    procedure Crasti;
    procedure AduScor;
    procedure Lasascor;
    procedure Mesaj(textm,titlum,icom:pchar);
    procedure Desfundal;
    procedure Miscmasini;
    procedure Admasini;
    procedure StergeOm;
    procedure Admasina(rand,dir,tip,tip2,cul:integer);
    procedure Desmasina(lx,ly,tip,tip2,cul:integer);
    procedure Resetniv;
    procedure Scrolly;
    procedure Miscaom;
    procedure Desom;
  end;
{-----------------------------------------------------------------------------------------}
procedure m_nota(can:byte;nota:byte;vel:byte);
begin
if opt_sunet=true then midioutshortmsg(han,$90+can+nota*256+vel*65536);
end;

procedure m_gura(can:byte;nota:byte;vel:byte);
begin
if opt_sunet=true then midioutshortmsg(han,$80+can+nota*256+vel*65536);
end;

procedure m_cont(can:byte;cnum:byte;val:byte);
begin
if opt_sunet=true then midioutshortmsg(han,$b0+can+cnum*256+val*65536);
end;

procedure m_ins(can:byte;prog:byte);
begin
if opt_sunet=true then midioutshortmsg(han,$c0+can+prog*256);
end;

procedure m_bend(can:byte;bend:word);
var lw,hy:integer;
begin
lw:=bend and 127;
hy:=bend shr 7;
if opt_sunet=true then midioutshortmsg(han,$e0+can+lw*256+hy*65536);
end;

procedure s_startmot;
begin
su_moto:=1;
m_ins(0,69);
m_nota(0,13,120);
m_nota(0,16,120);
end;

procedure s_stopmot;
begin
su_moto:=0;
m_gura(0,13,0);
m_gura(0,16,0);
end;

procedure s_startclax;
begin
if su_clax>0 then exit;
su_clax:=20+random(2)*20;
m_ins(1,69);
m_nota(1,63,127);
m_nota(1,66,102);
end;

procedure s_stopclax;
begin
m_gura(1,63,127);
m_gura(1,66,102);
end;

procedure s_muzik2(k:integer);
var i,a,b,c,d,e:integer;
const vol_corn=127;
      vol_orga=127;
      vol_clax=80;
      cant:array[0..96] of integer=(0,49,49,49,48,49,52,57,57,57,57,56,57,59,57,56,57,
                                      49,52,56,56,56,56,56,56,50,50,50,49,50,52,56,56,
                                      56,56,55,56,57,56,55,56,50,56,49,49,49,49,49,00,
                                      49,49,49,48,49,52,57,57,57,57,56,57,59,57,56,57,
                                      49,52,54,54,54,54,54,54,42,42,42,47,50,54,52,52,
                                      52,52,50,49,47,45,44,42,44,40,45,45,45,45,45,00);
begin
{CORN}
if k=1 then
begin
m_cont(10,7,100);
m_cont(11,7,100);
m_cont(12,7,100);
end;
if k=1 then m_ins(12,60);
i:=(k div 20)+1;
if k mod 20=1 then
begin
if i>96 then i:=96;
if cant[i-1]<>cant[i] then
begin
m_gura(12,cant[i-1]+12,vol_corn);
if cant[i]<>0 then m_nota(12,cant[i]+12,vol_corn);
end;
end;
{ORGA}
if k=1 then m_ins(10,19);
case ((i-1+6) div 12) of
0,1,4,5: begin a:=57; b:=61; c:=64; d:=45; e:=40; end;
2,3: begin a:=56; b:=59; c:=64; d:=40; e:=35; end;
6: begin a:=54; b:=59; c:=66; d:=47; e:=42; end;
7,8: begin a:=52; b:=61; c:=64; d:=45; e:=40; end;
end;
case k mod 60 of
1: m_nota(10,a,vol_orga);
10: m_gura(10,a,vol_orga);
20,40: begin m_nota(10,a,vol_orga); m_nota(10,b,vol_orga); m_nota(10,c,vol_orga); end;
30,50: begin m_gura(10,a,vol_orga); m_gura(10,b,vol_orga); m_gura(10,c,vol_orga); end;
end;
{KORN}
if k=1 then m_ins(11,69);
case k mod 120 of
1: m_nota(11,d,vol_clax);
40: m_gura(11,d,vol_clax);
60: m_nota(11,e,vol_clax);
100: m_gura(11,e,vol_clax);
end;
end;

procedure s_stopmuzik;
var i:integer;
begin
a_muzik:=10000;
m_cont(10,7,0);
m_cont(11,7,0);
m_cont(12,7,0);
end;

procedure s_pasi;
var i:integer;
begin
m_ins(9,0);
m_nota(9,35,48);
end;

procedure s_toba(k,vol:integer);
begin
m_ins(9,0);
if k=1 then m_nota(9,38,vol);
if k=2 then m_nota(9,36,vol);
if k=3 then m_nota(9,49,vol);
end;

procedure s_pleatci;
begin
m_ins(2,122);
m_nota(2,80,127);
end;

procedure s_kerash;
begin
m_ins(9,0);
m_nota(9,35,127);
m_nota(9,36,127);
m_nota(9,41,127);
m_nota(9,43,127);
m_nota(9,49,127);
m_nota(9,52,127);
m_nota(9,57,127);
m_ins(2,0);
m_nota(2,3,127);
m_nota(2,3,127);
m_ins(3,127);
m_nota(3,3,127);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure s_gameover;
begin
m_ins(2,0);
m_nota(2,3,127);
m_nota(2,3,127);
m_ins(3,127);
m_nota(3,3,127);
m_ins(5,116);
m_nota(5,12,127);
m_ins(6,107);
m_nota(6,12,127);
m_ins(7,81);
m_nota(7,24,127);
m_nota(7,24,127);
end;
{-----------------------------------------------------------------------------------------}
function PutereProc:longint;
var gt1,gt2,putere:longint;
    tc:hcursor;
begin
tc:=setcursor(loadcursor(0,idc_wait));
port[$70]:=0;
gt2:=port[$71];
putere:=0;
asm cli end;
repeat
port[$70]:=0;
gt1:=port[$71];
until gt2<>gt1;
repeat
port[$70]:=0;
gt2:=port[$71];
inc(putere);
until gt2<>gt1;
asm sti end;
setcursor(tc);
putereproc:=putere;
end;
{-----------------------------------------------------------------------------------------}
procedure Decodif(var unde:array of char;cheie:word);
var x,dx,y:byte;
    av:word;
begin
av:=0;
randseed:=cheie;
repeat
y:=random(256);
x:=ord(unde[av]);
dx:=x xor y;
unde[av]:=chr(dx);
av:=av+1;
until (av>=4900);
randomize;
end;
{-----------------------------------------------------------------------------------------}
function DIALOG_DESPRE(Dialog: HWnd; Message, WParam: Word; LParam: Longint): Bool; export;
begin
  DIALOG_DESPRE := True;
  case Message of
    wm_InitDialog:
      begin
      end;
    wm_Command:
      if (WParam = 500) or (wparam=id_cancel) then
      begin
        EndDialog(Dialog, 1);
        Exit;
      end;
  end;
  DIALOG_DESPRE := False;
end;
{-----------------------------------------------------------------------------------------}
function DIALOG_MESAJOK(Dialog: HWnd; Message, WParam: Word; LParam: Longint): Bool; export;
begin
  DIALOG_MESAJOK := True;
  case Message of
    wm_InitDialog:
      begin
      SetWindowText(dialog,iac_s2);
      SetDlgitemtext(dialog,801,iac_s1);
      end;
    wm_Command:
      if (WParam = 500) or (wparam=id_cancel) then
      begin
        EndDialog(Dialog, 1);
        Exit;
      end;
  end;
  DIALOG_MESAJOK := False;
end;
{-----------------------------------------------------------------------------------------}
function DIALOG_VITEZA(Dialog: HWnd; Message, WParam: Word; LParam: Longint): Bool; export;
var pcr:array[0..200] of char;
    pst:string;
    erv:integer;
begin
  DIALOG_VITEZA := True;
  case Message of
    wm_InitDialog:
      begin
      bopt_mhzs2:=opt_mhzs2;
      bopt_tipsinc:=opt_tipsinc;
      str(opt_mhzs2,pst);
      strpcopy(pcr,pst);
      SetDlgItemText(dialog,203,pcr);
      Checkradiobutton(dialog,200,202,199+opt_tipsinc);
      end;
    wm_Command:
      begin
      if (wparam >=200) and (wparam <=202) then opt_tipsinc:=wparam-199;
      if (WParam = 500) then
      begin
        GetDlgItemText(dialog,203,pcr,10);
        Val(pcr,opt_mhzs2,erv);
        if (opt_mhzs2<=0) then begin messagebeep(65535); exit; end;
        EndDialog(Dialog, 1);
        Exit;
      end;
      if (WParam = id_cancel) then
      begin
        opt_mhzs2:=bopt_mhzs2;
        opt_tipsinc:=bopt_tipsinc;
        EndDialog(Dialog, 1);
      end;
      end;
  end;
  DIALOG_VITEZA := False;
end;
{-----------------------------------------------------------------------------------------}
function Tapp.IdleAction:boolean;
begin
invalidaterect(mainw,nil,false);
if su_clax>0 then su_clax:=su_clax-1;
if su_clax=1 then s_stopclax;
IdleAction:=true;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
constructor TferJoc.Init(AParent: PWindowsObject; Title: PChar);
begin
  TWindow.Init(AParent, Title);
  Attr.X:=(getsystemmetrics(sm_cxscreen)-640) div 2;
  Attr.y:=(getsystemmetrics(sm_cyscreen)-480) div 2;
  Attr.W := 640+1;
  Attr.H := 438+getsystemmetrics(sm_cycaption)+getsystemmetrics(sm_cymenu)+1;
  Attr.Style := ws_minimizebox or ws_sysmenu or ws_popup or ws_caption{WS_Caption};
  Randomize;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.PutBMP(TDC: HDC; X, Y, BitMap: HBitMap; W,H,x2,y2:integer);
begin
  SelectObject(uMemDC, BitMap);
  BitBlt(TDC, X, Y, W, H, uMemDC, x2, y2, srccopy);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tferjoc.Scrie (tx,ty:integer;ce:string);
var it:integer;
    cr:integer;
begin
SelectObject(uMemDC, fonttrav);
for it:=1 to length(ce) do
begin
cr:=ord(ce[it]);
if cr>127 then cr:=32;
cr:=cr-32;
if cr<0 then cr:=0;
BitBlt(DC, tx, ty, 12, 11, uMemDC,(cr and 31)*12,(cr shr 5)*12, srccopy);
tx:=tx+12;
end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tferjoc.ScrieMC (tx,ty:integer;ce:string;culs:integer);
var it:integer;
    cr:integer;
    locx,locy:longint;
begin
SelectObject(uMemDC, fonttrav);
for it:=1 to length(ce) do
begin
cr:=ord(ce[it]);
if cr>127 then cr:=32;
cr:=cr-32;
if cr<0 then cr:=0;
locx:=(cr and 31)*12;
locy:=0;
case culs of 0,1,2,3,4,5: locy:=culs+1;
             7,8,9,10,11:locy:=13-culs;
             end;
locy:=locy*36;
locy:=locy+(cr shr 5)*12;
BitBlt(DC, tx, ty, 12, 11, uMemDC,locx,locy, srccopy);
culs:=culs+1;
if culs>11 then culs:=0;
tx:=tx+12;
end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.Desfundal;
var MemDC: HDC;
    MemDC2: HDC;
    iter:byte;
    tempbmp:hbitmap;
    th:thandle;
begin
  tempbmp:=createcompatiblebitmap(dc,640,438);
  MemDC2 := CreateCompatibleDC(DC);
  SelectObject(uMemDC, zona_joc);
  th:=SelectObject(MemDC2, tempbmp);
for iter:=0 to 31 do BitBlt(memdc2,iter*20,0,20,410,uMemDc,0,0,srccopy);
{}selectobject(umemdc,barascor);
BitBlt(memdc2,0,410,640,28,umemdc,0,0,srccopy);{}
BitBlt(dc,0,0,640,410,MemDc2,0,0,srccopy);
  SelectObject(MemDC2, th);
  deleteobject(tempbmp);
  DeleteDC(MemDC2);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.WMClose;
var i:integer;
begin
for i:=0 to 13 do m_cont(i,7,0);
a_kablam:=10;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.GetWindowClass(var WndClass: TWndClass);
begin
  TWindow.GetWindowClass(WndClass);
  WndClass.Style := cs_bytealignwindow or cs_owndc;
  WndClass.hCursor := LoadCursor(hInstance, 'CRS_GOL');
  WndClass.hbrBackGround := GetStockObject(black_Brush);
  WndClass.lpszMenuName := 'MNU_ROM';
  WndClass.hIcon := LoadIcon(hInstance, 'ICO_TRAV');
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.Splatci(tdc:HDC;x1,y1:integer; Col:TcolorRef);
var cra:array[1..100] of tpoint;
    ung:real;
    ds:integer;
    gii:integer;
    kb,kr:hbrush;
    kpb,kpr:hpen;
    npo:integer;
begin
kr:=createsolidbrush(col);
ung:=0;
npo:=0;
while ung<6.28 do
begin
if npo mod 2=1 then ds:=120+random(100) else ds:=60+random(30);
npo:=npo+1;
cra[npo].x:=round(x1+sin(ung)*ds);
cra[npo].y:=round(y1+cos(ung)*ds);
ung:=ung+(62/(200+random(200)));
end;
kpr:=createpen(ps_null,0,0);
kb:=selectobject(tdc,kr);
kpb:=selectobject(tdc,kpr);
polygon(tdc,cra,npo);
selectobject(tdc,kb);
selectobject(tdc,kpb);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.Rect(tdc:HDC;r1,r2,r3,r4:integer; Col:TcolorRef);
begin
rec1.top:=r1;
rec1.left:=r2;
rec1.right:=r3;
rec1.bottom:=r4;
fillrect(tdc,rec1,createsolidbrush(col));
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.Rct2(tdc:HDC;r1,r2,r3,r4:integer; Col:TcolorRef);
begin
rec1.top:=r1;
rec1.left:=r2;
rec1.right:=r3;
rec1.bottom:=r4;
framerect(tdc,rec1,createsolidbrush(col));
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.IRect(r1,r2,r3,r4:integer);
begin
rec1.top:=r1;
rec1.left:=r2;
rec1.right:=r3;
rec1.bottom:=r4;
invalidaterect(hwindow,addr(rec1),false);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
{$F+}
procedure TimeProc(hwnd:hwnd;msg:word;idtimer:word;dwTime:longint);export;
begin
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure tferjoc.desscor;
var s1,s2,s3:string;
    ii:byte;
    ik:integer;
begin
if scor<0 then scor:=0;
if scor>999999 then scor:=999999;
if scor>recd then recd:=scor;
str(scor,s1);
while length(s1)<6 do s1:='0'+s1;
s2:='';
ik:=vieti;
if ik<0 then ik:=0;
for ii:=1 to ik do s2:=s2+'ab ';
while length(s2)<15 do s2:=s2+'cd ';
str(recd,s3);
while length(s3)<6 do s3:='0'+s3;
scrie(8,417,'PUNCTE:'+s1+'      '+s2+'     RECORD:'+s3);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure tferjoc.remscor;
var s1,s2:string;
begin
if scor<0 then scor:=0;
if scor>999999 then scor:=999999;
if scor>recd then recd:=scor;
str(scor,s1);
while length(s1)<6 do s1:='0'+s1;
str(recd,s2);
while length(s2)<6 do s2:='0'+s2;
scrie(92,417,s1);
scrie(560,417,s2);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.WMEraseBKGND (var Message: Tmessage);
var w1,w2:longint;
begin
if modjoc=0 then
begin
rect(dc,0,0,640,410,$000000);
putbmp(dc,0,410,barascor,640,28,0,0);
end;
if modjoc=1 then
begin
DesFundal;
putbmp(dc,0,410,barascor,640,28,0,0);
if sejoaca=true then Desscor else scrolly;
for i:=1 to nmas do if masini[i,3]<>0 then Desmasina(masini[i,1],masini[i,2],masini[i,3],masini[i,4],masini[i,5]);
if sejoaca=true then drawicon(dc,xom,yom,om1);
end;
end;
{-----------------------------------------------------------------------------------------}
procedure TferJoc.Admasina(rand,dir,tip,tip2,cul:integer);
label l1;
begin
for i:=1 to nmas do
begin
if masini[i,3]=0 then
begin
if tip<>2 then
begin
if dir=-1 then masini[i,1]:=640;
if dir=1 then masini[i,1]:=-47;
end
else
begin
if dir=-1 then masini[i,1]:=640;
if dir=1 then masini[i,1]:=-63;
end;
masini[i,2]:=rand*30;
masini[i,3]:=tip*dir;
masini[i,4]:=tip2;
masini[i,5]:=cul;
goto l1;
end;
end;
l1:
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.Admasini;
var semn:integer;
    nv:byte;
    ci:integer;
begin
for ci:=0 to 11 do
begin
if randuri[ci,2]>0 then randuri[ci,2]:=randuri[ci,2]-(1+dublu);
if randuri[ci,2]=0 then
begin
semn:=-1;
if randuri[ci,1]>0 then semn:=1;
if abs(randuri[ci,1])=4 then {apa, lent}
begin
nv:=random(3);
case nv of 0,1:begin
               Admasina(1+ci,semn,1,4,(random(2)*4)+random(3));
               randuri[ci,2]:=64+(random(3+dific+pb) shl 4);
               end;
           2:  begin
               Admasina(1+ci,semn,2,3,0);
               randuri[ci,2]:=80+(random(3+dific+pb) shl 4);
               end;
end;
end;
if abs(randuri[ci,1])=1 then
begin
if random(2)=0 then
               begin
               Admasina(1+ci,semn,1,random(4),random(7));
               randuri[ci,2]:=64+(random(pb) shl 4);
               end
               else
               begin
               Admasina(1+ci,semn,2,random(3),random(7));
               randuri[ci,2]:=80+(random(pb) shl 4);
               end;
end;
if abs(randuri[ci,1])=2 then
begin
if randuri[ci,3]=1 then
begin
if semn=1 then Admasina(1+ci,semn,3,2,0);
if semn=-1 then Admasina(1+ci,semn,3,3,0);
randuri[ci,3]:=0;
randuri[ci,2]:=32+(random(1+pb) shl 3);
end
else
begin
if random(10)>0 then
begin
Admasina(1+ci,semn,3,random(2),random(7));
randuri[ci,2]:=24+(random(1+pb) shl 3);
end
else
begin
if semn=1 then Admasina(1+ci,semn,3,3,0);
if semn=-1 then Admasina(1+ci,semn,3,2,0);
randuri[ci,2]:=16;
randuri[ci,3]:=1;
end;
end;
end;
if abs(randuri[ci,1])=3 then  {apa, rapid}
begin
nv:=random(5);
case nv of
0,1: begin
   Admasina(1+ci,semn,3,2,4);
   randuri[ci,2]:=24+(random(pb) shl 3);
   end;
2,3: begin
   Admasina(1+ci,semn,3,3,4);
   randuri[ci,2]:=24+(random(pb) shl 3);
   end;
4: begin
   Admasina(1+ci,semn,3,2,3);
   randuri[ci,2]:=24+(random(pb) shl 3);
   end;
end;
end;
end;
end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.Desmasina(lx,ly,tip,tip2,cul:integer);
begin
if tip=1  then putbmp(dc,lx,ly,hazarde, 32, 20,tip2 shl 5,0+cul*20);
if tip=-1 then putbmp(dc,lx,ly,hazarde, 32, 20,160+tip2 shl 5,0+cul*20);
if tip=2  then putbmp(dc,lx,ly,hazarde, 64, 20,tip2 shl 6,140+cul*20);
if tip=-2 then putbmp(dc,lx,ly,hazarde, 64, 20,256+tip2 shl 6,140+cul*20);
if tip=3  then putbmp(dc,lx,ly,hazarde, 32, 20,tip2 shl 5,280+cul*20);
if tip=-3 then putbmp(dc,lx,ly,hazarde, 32, 20,128+tip2 shl 5,280+cul*20);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure tferJoc.miscmasini;
begin
for i:=1 to nmas do
begin
if masini[i,3]<>0 then
begin
if masini[i,3]=1 then masini[i,1]:=masini[i,1]+(1+dublu);
if masini[i,3]=2 then masini[i,1]:=masini[i,1]+(1+dublu);
if masini[i,3]=3 then
                 begin
                 masini[i,1]:=masini[i,1]+(2+dublu+dublu);
                 end;
if masini[i,3]=-1 then masini[i,1]:=masini[i,1]-(1+dublu);
if masini[i,3]=-2 then masini[i,1]:=masini[i,1]-(1+dublu);
if masini[i,3]=-3 then
                 begin
                 masini[i,1]:=masini[i,1]-(2+dublu+dublu);
                 end;

if (abs(masini[i,3])=1) and (masini[i,4]=4) then
  begin
  if masini[i,5]<3 then masini[i,5]:=anmas;
  if masini[i,5]>3 then masini[i,5]:=4+anmas;
  end;
if (abs(masini[i,3])=2) and (masini[i,4]=3) then
  begin
  if masini[i,5]<3 then masini[i,5]:=anmas;
  if masini[i,5]>3 then masini[i,5]:=4+anmas;
  end;
if (abs(masini[i,3])=3) and (masini[i,4]<>1) then
  begin
  if masini[i,5]<3 then masini[i,5]:=anmas;
  if masini[i,5]>3 then masini[i,5]:=4+anmas;
  end;
if (masini[i,1]>656) or (masini[i,1]<-66) then
                                          begin
                                          if (masini[i,4]=3) and (masini[i,5]=3) and (abs(masini[i,3])=3)
                                          then masini[i,3]:=0-masini[i,3]
                                          else masini[i,3]:=0;
                                          end;
end;
end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
function tferJoc.DetColiz:boolean;
var r1,r2,r3,r4:integer;
begin
for i:=1 to 200 do
begin
if masini[i,3]<>0 then
begin
r1:=masini[i,1];
r2:=masini[i,2];
r3:=masini[i,1]+32;
r4:=masini[i,2]+20;
if (masini[i,3]=1) and (masini[i,4]<2) then r1:=r1+6;
if (masini[i,3]=3) and (masini[i,4]<2) and (masini[i,5]<4) then r1:=r1+6;
if (masini[i,3]=3) and (masini[i,4]=1) and (masini[i,5]>3) then r1:=r1+6;
if (masini[i,3]=-1) and (masini[i,4]<2) then r3:=r3-6;
if (masini[i,3]=-3) and (masini[i,4]<2) and (masini[i,5]<4) then r3:=r3-6;
if (masini[i,3]=-3) and (masini[i,4]=1) and (masini[i,5]>3) then r3:=r3-6;
if abs(masini[i,3])=2 then r3:=r3+32;
if (r3>xom+3) and (r1<xom+13) and (r4>yom+8) and (r2<yom+8) then DetColiz:=true;
end;
end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure tferJoc.StergeOm;
var v1:integer;
begin
v1:=20-(xom mod 20);
if v1>16 then v1:=16;
putbmp(dc,xom,yom,zona_joc,v1,18,xom mod 20,yom);
if v1<16 then putbmp(dc,xom+v1,yom,zona_joc,16-v1,18,0,yom);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure tferJoc.Miscaom;
begin
nxom:=xom;
nyom:=yom;
if som mod 20>0 then
begin
som:=som-1;
end;
if (getasynckeystate(vk_up)<0) and (som mod 20=0) then som:=0+15;
if (getasynckeystate(vk_down)<0) and (som mod 20=0) then som:=20+15;
if (getasynckeystate(vk_left)<0) and (som mod 20=0) then som:=40+8;
if (getasynckeystate(vk_right)<0) and (som mod 20=0) then som:=60+8;
if som=0+15 then begin scor:=scor+10; remscor; end;
if som=20+15 then begin scor:=scor-5; remscor; end;
if (som mod 20>0) and (som div 20=0) then begin nyom:=nyom-2; end;
if (som mod 20>0) and (som div 20=1) then begin nyom:=nyom+2; end;
if (som mod 20>0) and (som div 20=2) then nxom:=nxom-2;
if (som mod 20>0) and (som div 20=3) then nxom:=nxom+2;
if nyom>394 then nyom:=394;
if nyom<4 then nyom:=4;
if nxom<0 then nxom:=0;
if nxom>624 then nxom:=624;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure tferJoc.DesOm;
var anom:integer;
begin
if bravo=0 then
begin
anom:=(som mod 20) div 2;
if (yom<32) or (yom>160) then
begin
if som mod 20<2 then drawicon(dc,xom,yom,om1);
if (som mod 20>1) then
begin
case som div 40 of 0: begin
                      if anom mod 4=0 then s_pasi;
                      case anom mod 4 of
                      0,2: drawicon(dc,xom,yom,om1);
                      1: drawicon(dc,xom,yom,om2);
                      3: drawicon(dc,xom,yom,om3);
                      end;
                      end;
                   1: begin
                      if anom=2 then s_pasi;
                      case anom mod 4 of
                      0: drawicon(dc,xom,yom,om5);
                      1,3: drawicon(dc,xom,yom,om1);
                      2: drawicon(dc,xom,yom,om4);
                      end;
                      end;
end;
end;
end
else
begin
if som mod 20<2 then drawicon(dc,xom,yom,om6);
if (som mod 20>1) then
begin
case som div 40 of 0: begin
                      if anom=2 then s_pleatci;
                      case anom mod 4 of 0,1,4,5: drawicon(dc,xom,yom,om6);
                                         2,3: drawicon(dc,xom,yom,om7);
                                         6,7: drawicon(dc,xom,yom,om8);
                      end;
                      end;
                   1: begin
                      if anom=2 then s_pleatci;
                      case anom mod 4 of 0: drawicon(dc,xom,yom,om8);
                                         1,3: drawicon(dc,xom,yom,om6);
                                         2: drawicon(dc,xom,yom,om7);
                      end;
                      end;
end;
end;
end;
end else
begin
case (anim div 8) of
0:drawicon(dc,xom,yom,om10);
1:drawicon(dc,xom,yom,om11);
end;
end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure tferjoc.crasti;
var gt:longint;
    an:byte;
    vv:byte;
    reg1:hrgn;
    cul:tcolorref;
    mix:tmsg;
begin
vieti:=vieti-1;
a_crasti:=300;
anim:=-1;
s_stopmot;
s_kerash;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure tferJoc.ResetNiv;
var ai:integer;
begin
s_stopmot;
pb:=8-(nivel div 2);
if pb<2 then pb:=2;
modjoc:=1;
rect(dc,0,0,640,410,$000000);
if intram=true then aduscor;
if iesim=true then lasascor;
if sejoaca=true then desscor;
deleteobject(Zona_joc);
deleteobject(Hazarde);
case nivel mod 2 of
0:begin
Zona_joc := LoadBitMap(hInstance, 'ZONA_JOC');
Hazarde := LoadBitMap(hInstance, 'HAZARDE');
end;
1:begin
Zona_joc := LoadBitMap(hInstance, 'ZONA_JOC2');
Hazarde := LoadBitMap(hInstance, 'HAZARDE2');
end;
end;
intram:=false;
iesim:=false;
randuri[0,1]:=-4;
randuri[1,1]:=3;
randuri[2,1]:=-4;
randuri[3,1]:=4;
randuri[4,1]:=3;
randuri[6,1]:=-2;
randuri[7,1]:=-1;
randuri[8,1]:=-1;
randuri[9,1]:=1;
randuri[10,1]:=2;
randuri[11,1]:=1;
xom:=304;
yom:=394;
nxom:=304;
nyom:=394;
som:=0;
if sejoaca=false then begin scr_ofs:=0; scr_poz:=0; end;
for i:=1 to nmas do masini[i,3]:=0;
for ai:=1 to 1280 do begin anim:=(anim+1{+dublu}) and 15; admasini; miscmasini; end;
Admasina(6,1,3,3,3);
if restac=false then
begin
a_nivel:=300;
end
else
begin
Desfundal;
if sejoaca=true then drawicon(dc,xom,yom,om1);
end;
if sejoaca=false then a_muzik:=-1 else s_stopmuzik;
_reset:=false;
restac:=false;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure tferJoc.Paint(PaintDC: HDC; var PaintInfo: TPaintStruct);
var
  reg1:hrgn;
  dw:longint;
  ch:byte;
  m:longint;
  anom:integer;
  in_1:integer;
  f:file of word;
label e_kk;
begin
fig:=200;
anim:=(anim+1{+dublu}) and 15;
anmas:=anim div 4;

if a_crasti>0 then a_crasti:=a_crasti-1;
if a_gandesc>0 then a_gandesc:=a_gandesc-1;
if a_kablam>0 then a_kablam:=a_kablam-1;
if a_nivel>0 then a_nivel:=a_nivel-1;

if a_gandesc=0 then
begin
a_muzik:=a_muzik+1;
if a_muzik=2040 then a_muzik:=1;
if a_muzik>10000 then a_muzik:=10000;
s_muzik2(a_muzik);
end;

if (a_kablam>0) then
begin
if a_kablam=1 then
begin
midioutclose(han);
assign(f,'trav.ini');
{$I-}
rewrite(f);
{$I+}
if opt_sunet=true then opt_tipsinc:=opt_tipsinc+10;
write(f,word(opt_tipsinc));
write(f,word(opt_mhzs2));
write(f,word(recd));
close(f);
TferJoc.Destroy;
end;
end;

if (a_nivel>0) then
begin
if a_nivel=299 then
begin
rect(dc,0,0,640,410,$000000);
end;
nivel:=nivel+1;
scrie(274,170,'NIVEL '+chr(48+nivel div 10)+chr(48+nivel mod 10));
if nivel mod 2=1 then
scrie(286,194,' ZIUA ') else
scrie(280,194,'NOAPTEA');
scriemc(244,218,'PREGATESTE-TE',a_nivel mod 12);
nivel:=nivel-1;
if (a_nivel=299) then begin
                      s_toba(2,127);
                      s_toba(1,127);
                      end;
if (a_nivel=210) then begin
                      s_toba(2,127);
                      end;
if (a_nivel=200) then begin
                      s_toba(2,127);
                      s_toba(2,127);
                      s_toba(1,127);
                      s_toba(1,127);
                      s_toba(3,127);
                      end;
if (a_nivel>200) and (a_nivel mod 2=0) then s_toba(1,27+(300-a_nivel));
if a_nivel=100 then a_nivel:=1;
if a_nivel=1 then
begin
Desfundal;
drawicon(dc,xom,yom,om1);
end;
end;

if (a_crasti>0) then
begin
if (a_crasti>220) and ((anim mod 8)=0) and (a_crasti<300) then
begin
reg1:=createrectrgn(0,0,640,410);
selectcliprgn(dc,reg1);
rect(dc,0,0,640,410,$0000FF+($FF00*(anim div 8)));
splatci(dc,xom+8,yom+8,$00FFFF-($FF00*(anim div 8)));
drawicon(dc,xom,yom,om9);
selectcliprgn(dc,0);
deleteobject(reg1);
end;
if a_crasti=220 then
begin
desscor;
rect(dc,0,0,640,410,$000000);
if vieti>=0 then
begin
m_ins(4,80);
m_nota(4,67,127);
m_cont(4,101,0);
m_cont(4,100,0);
m_cont(4,6,64);
m_cont(4,101,127);
m_cont(4,100,127);
m_cont(4,7,0);
end else
begin
drawicon(dc,312,184,om1);
a_crasti:=1000;
end;
end;
if (a_crasti=1000) then
begin
m_ins(4,69);
m_nota(4,67,127);
m_nota(4,64,80);
m_cont(4,101,0);
m_cont(4,100,0);
m_cont(4,6,64);
m_cont(4,101,127);
m_cont(4,100,127);
m_cont(4,7,127);
end;
if (a_crasti>892) and (a_crasti<1000) then
begin
in_1:=(1000-a_crasti);
m_bend(4,8192-in_1);
in_1:=-64+(1000-a_crasti)*3;
rect(dc,180,in_1-2,in_1,200,$000000);
rect(dc,180,642-in_1-2,644-in_1,200,$000000);
desmasina(in_1,180,2,0,1);
desmasina(576-in_1,180,2,4,1);
end;
if a_crasti=892 then
begin
m_gura(4,67,127);
m_gura(4,64,80);
s_gameover;
splatci(dc,320,192,$0000FF);
end;
if (a_crasti<893) and (a_crasti>400) then
begin
scriemc(266,380,'SFARSIT !',a_crasti mod 12);
end;
if a_crasti=400 then
begin
m_gura(7,24,127);
m_gura(7,24,127);
a_crasti:=1;
end;
if a_crasti<220 then
begin
if a_crasti>200 then m_cont(4,7,127-(a_crasti-200)*3);
if a_crasti=200 then m_cont(4,7,127);
if a_crasti<100 then m_cont(4,7,a_crasti+27);
in_1:=0;
if a_crasti<100 then in_1:=(100-a_crasti)*10;
m_bend(4,8192-1600*((a_crasti div 16) mod 2)-in_1);
if anmas=3 then anmas:=1;
in_1:=-48+(220-a_crasti)*4;
rect(dc,180,in_1-2,in_1,200,$000000);
desmasina(in_1,180,3,0,4+anmas);
end;
if a_crasti=1 then
begin
m_gura(4,67,127);
restac:=true;
_reset:=true;
if vieti<0 then
begin
intram:=false;
iesim:=true;
sejoaca:=false;
nivel:=24;
modjoc:=0;
end;
end;
end;

if (a_crasti=0) and (a_gandesc=0) and (a_nivel=0) and (a_kablam=0) then
begin
if su_moto=0 then s_startmot;
if anmas=3 then anmas:=1;
if _reset=true then begin Resetniv; goto e_kk; end;
Admasini;
Miscmasini;
for i:=1 to nmas do if masini[i,3]<>0 then Desmasina(masini[i,1],masini[i,2],masini[i,3],masini[i,4],masini[i,5]);
if sejoaca=true then
begin
if bravo=0 then tict:=tict+1;
if bravo=1 then
begin
bravo:=0;
yom:=3;
nivel:=nivel+1;
_reset:=true;
end;
if bravo>1 then
begin
dec(bravo);
if anim mod 8=0 then
begin
Stergeom;
desom;
end;
end;
if bravo=0 then Miscaom;
if (bravo=0) and (yom=4) then bravo:=120;
if tict>60 then begin tict:=0; if scor>0 then dec(scor); remscor; end;
if DetColiz=true then crasti;
if (_reset=false) then if (nxom<>xom) or (nyom<>yom) then
begin
StergeOm;
xom:=nxom;
yom:=nyom;
DesOm;
end;
end;
if sejoaca=false then scrolly;
if (_reset=false) and (sejoaca=true) then
begin
if random(250)=0 then S_startclax;
end;
if (getasynckeystate(vk_space)<0) and (sejoaca=false) then
   postmessage(hwindow,wm_command,101,0);
if (getasynckeystate(vk_escape)<0) and (getasynckeystate(vk_shift)<0) then
   postmessage(hwindow,wm_command,102,0);
end; {NORMAL}
e_kk:
if opt_tipsinc=1 then t_astept:=16;
if opt_tipsinc=2 then t_astept:=1000 div opt_mhzs2;
if opt_tipsinc<3 then
repeat
until abs(gettickcount-gt)>t_astept;
gt:=gettickcount;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.AduScor;
var ii:integer;
    gt:longint;
    s1,s2,s3,s4:string;
    trgn:hrgn;
    ma:byte;
begin
trgn:=createrectrgn(0+4,410+4,639-4,437-4);
selectobject(dc,getstockobject(black_pen));
selectcliprgn(dc,trgn);
s4:='';
for ii:=0 to 52 do
begin
ma:=ord(stringuri[scr_poz+ii]);
if ma=1 then scr_poz:=0;
s4:=s4+chr(ma);
end;
if scor<0 then scor:=0;
if scor>999999 then scor:=999999;
if scor>recd then recd:=scor;
str(scor,s1);
while length(s1)<6 do s1:='0'+s1;
s2:='';
for ii:=1 to vieti do s2:=s2+'ab ';
while length(s2)<15 do s2:=s2+'cd ';
str(recd,s3);
while length(s3)<6 do s3:='0'+s3;
for ii:=0 to 20 do
begin
gt:=gettickcount;
scrieMC(8-scr_ofs,417-ii,s4,animscr);
moveto(dc,0,428-ii);
lineto(dc,640,428-ii);
scrie(8,437-ii,'PUNCTE:'+s1+'      '+s2+'     RECORD:'+s3);
moveto(dc,0,448-ii);
lineto(dc,640,448-ii);
if opt_tipsinc<3 then repeat until abs(gettickcount-gt)>(t_astept div 2);
end;
selectcliprgn(dc,0);
deleteobject(trgn);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.LasaScor;
var ii:integer;
    gt:longint;
    s1,s2,s3:string;
    trgn:hrgn;
begin
trgn:=createrectrgn(0+4,410+4,639-4,437-4);
selectobject(dc,getstockobject(black_pen));
selectcliprgn(dc,trgn);
if scor<0 then scor:=0;
if scor>999999 then scor:=999999;
if scor>recd then recd:=scor;
str(scor,s1);
while length(s1)<6 do s1:='0'+s1;
s2:='';
for ii:=1 to vieti do s2:=s2+'ab ';
while length(s2)<15 do s2:=s2+'cd ';
str(recd,s3);
while length(s3)<6 do s3:='0'+s3;
for ii:=20 downto 0 do
begin
gt:=gettickcount;
scrie(8,437-ii,'PUNCTE:'+s1+'      '+s2+'     RECORD:'+s3);
moveto(dc,0,436-ii);
lineto(dc,640,436-ii);
if opt_tipsinc<3 then repeat until abs(gettickcount-gt)>(t_astept div 2);
end;
selectcliprgn(dc,0);
deleteobject(trgn);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.Scrolly;
var ii:integer;
    as,ao:word;
    s1:string;
    trgn:hrgn;
    ma:byte;
begin
trgn:=createrectrgn(0+4,410+4,639-4,437-4);
selectcliprgn(dc,trgn);

if anim mod 2=0 then animscr:=animscr-1;
if animscr<0 then animscr:=11;
scr_ofs:=scr_ofs+2;
if scr_ofs>11 then
begin
scr_ofs:=0;
scr_poz:=scr_poz+1;
animscr:=animscr+1;
if animscr>11 then animscr:=0;
end;
s1:='';
for ii:=0 to 52 do
begin
ma:=ord(stringuri[scr_poz+ii]);
if ma=1 then scr_poz:=0;
s1:=s1+chr(ma);
end;
scrieMC(8-scr_ofs,417,s1,animscr);

selectcliprgn(dc,0);
deleteobject(trgn);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.Mesaj(textm,titlum,icom:pchar);
var proc_instruc:tfarproc;
begin
strcopy(iac_s1,textm);
strcopy(iac_s2,titlum);
Proc_instruc := MakeProcInstance(@DIALOG_MESAJOK, HInstance);
DialogBox(HInstance, icom, HWindow, proc_instruc);
FreeProcInstance(proc_instruc);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.SetUpWindow;
var ts2,ts1:string;
    tpc1,tpc2,tpc3:array[0..200] of char;
    j:integer;
    nrg:longint;
    handlef:integer;
    dcaps:longint;
    rcinfo,rcdata:thandle;
    sir1:pointer;
    fh:integer;
    re:integer;
    f:file of word;
    ieste:boolean;
    xx:word;
    hme:hmenu;
begin
  sejoaca:=false;
  assign(f,'trav.ini');
  ieste:=true;
{$I-}
  reset(f);
{$I+}
  if ioresult<>0 then ieste:=false;
  if ieste=false then
  begin
  OPT_sunet:=true;
  OPT_TIPSINC:=1;
  OPT_MHZS2:=60;
  recd:=10000;
  end
  else
  begin
  read(f,xx);
  opt_tipsinc:=xx;
  read(f,xx);
  opt_mhzs2:=xx;
  read(f,xx);
  recd:=xx;
  opt_sunet:=false;
  if opt_tipsinc>10 then begin opt_sunet:=true; opt_tipsinc:=opt_tipsinc-10; end;
  end;
{$I-}close(f);{$I+}

hme:=getmenu(hwindow);
if opt_sunet=true then checkmenuitem(hme,111,mf_bycommand or mf_checked);

  modjoc:=0;
  scor:=0;
  restac:=true;
  vieti:=0;
  xom:=-16;
  yom:=-16;
  dublu:=0;
  _reset:=true;
  mainw:=Hwindow;
  handlef:=AccessResource(hinstance,Findresource(hinstance,'STRINGURI','DOC'));
  _lread(handlef,stringuri,2300);
  _lclose(handlef);
  Decodif(stringuri,23296);
  Zona_joc := LoadBitMap(hInstance, 'ZONA_JOC');
  Hazarde := LoadBitMap(hInstance, 'HAZARDE');
  fonttrav := LoadBitMap(hInstance, 'FONT_TRAV');
  Barascor := LoadBitMap(hInstance, 'BARASCOR');
  Icn1 := LoadIcon(hInstance, 'ICO_TRAV');
  om1:= LoadIcon(hInstance, 'OM1');
  om2:= LoadIcon(hInstance, 'OM2');
  om3:= LoadIcon(hInstance, 'OM3');
  om4:= LoadIcon(hInstance, 'OM4');
  om5:= LoadIcon(hInstance, 'OM5');
  om6:= LoadIcon(hInstance, 'OM6');
  om7:= LoadIcon(hInstance, 'OM7');
  om8:= LoadIcon(hInstance, 'OM8');
  om9:= LoadIcon(hInstance, 'OM9');
 om10:= LoadIcon(hInstance, 'OM10');
 om11:= LoadIcon(hInstance, 'OM11');
dc:=getdc(hwindow);
umemdc:=createcompatibledc(dc);
SetMapmode(dc,mm_text);
tmproc:=makeprocinstance(@timeproc,hinstance);
settimer(hwindow,1,1,tmproc);
nrg:=putereproc;
if nrg<350 then
begin
strpcopy(tpc1,'');
strcat(tpc1,'Acest sistem nu pare sa fie suficient de rapid pentru a rula');
strcat(tpc1,' programul. Este nevoie de cel putin un 486DX4/100Mhz.');
Mesaj(tpc1,'Atentie','MSJ_ATN1');
end
else
begin
if (nrg<360) and (getsystemmetrics(sm_cxscreen)<>640) then
begin
strpcopy(tpc1,'');
strcat(tpc1,'Pentru acest sistem mai lent este recomandabil sa rulati in');
strcat(tpc1,' 640x480x256 pentru o viteza corecta.');
Mesaj(tpc1,'Sugestie','MSJ_INFO1');
end;
end;
bravo:=0;
nivel:=16;
dific:=0;
intram:=false;
iesim:=false;
re:=midioutopen(addr(han),$ffff,0,0,callback_null);
if opt_sunet=true then
begin
if re<>0 then Mesaj('Nu am detectat suport MIDI pentru sunet!','Eroare','MSJ_INFO1');
end;
for i:=0 to 9 do m_cont(i,121,0);
a_gandesc:=50;
a_muzik:=-1;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TferJoc.WMDestroy(var Message: TMessage);
var i,j:longint;
begin
  killtimer(hwindow,1);
  freeprocinstance(tmproc);
  releasedc(dc,hwindow);
  deletedc(umemdc);
  TWindow.WMDestroy(Message);
  deleteobject(om1);
  deleteobject(om2);
  deleteobject(om3);
  deleteobject(om4);
  deleteobject(om5);
  deleteobject(om6);
  deleteobject(om7);
  deleteobject(om8);
  deleteobject(om9);
  deleteobject(om10);
  deleteobject(om11);
  deleteobject(icn1);
  deleteobject(barascor);
  deleteobject(fonttrav);
  deleteobject(Zona_joc);
  deleteobject(Hazarde);
end;
{--------------- TApp ------------------------}

procedure TApp.InitMainWindow;
begin
  MainWindow := New(PferJoc, Init(nil, 'Traversare'));
end;
{-------------Main Program--------------------}
procedure TferJoc.WMCommand(var Message: TMessage);
var ctid:word;
    i,j:integer;
    procd:tfarproc;
    hme:hmenu;
    buf3,buf,buf2:array[0..255] of char;
const comm_incepe=101;
      comm_iesi=102;
      comm_viteza=103;
      comm_sunet=111;
      comm_despre=110;

begin
ctid:=message.wparam;
if ctid=comm_incepe then
begin
vieti:=5;
scor:=0;
nivel:=0;
intram:=false;
if sejoaca=false then intram:=true;
sejoaca:=true;
iesim:=false;
_reset:=true;
end;
if ctid=comm_iesi then
begin
for i:=0 to 13 do m_cont(i,7,0);
a_kablam:=10;
end;
if ctid=comm_viteza then
begin
Procd := MakeProcInstance(@DIALOG_VITEZA, HInstance);
DialogBox(HInstance, 'VITEZA_ROM', HWindow, procd);
FreeProcInstance(procd);
end;
if ctid=comm_sunet then
begin
hme:=getmenu(hwindow);
if opt_sunet=true then
begin
checkmenuitem(hme,111,mf_bycommand or mf_unchecked);
midioutclose(han);
midioutopen(addr(han),$ffff,0,0,callback_null);
opt_sunet:=false;
end else
begin
checkmenuitem(hme,111,mf_bycommand or mf_checked);
opt_sunet:=true;
midioutclose(han);
midioutopen(addr(han),$ffff,0,0,callback_null);
for i:=10 to 13 do m_cont(i,7,0);
s_startmot;
if a_muzik<2040 then a_muzik:=-1;
end;
end;
if ctid=comm_despre then
begin
Procd := MakeProcInstance(@DIALOG_DESPRE, HInstance);
DialogBox(HInstance, 'DESPRE_ROM', HWindow, procd);
FreeProcInstance(procd);
end;
end;
{-------------Main Program--------------------}

var
  App: TApp;
begin
  App.Init('Traversare');
  App.Run;
  App.Done;
end.
