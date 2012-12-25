program MidPlay;
{sa faci si lcd ca la GSM, cu bitmap si dublu-clic pe display il schimba}
{$R MIDPLAY}
{$X+}
uses
  playinfo,windos,WinTypes, WinProcs, OWindows, ODialogs, Strings,wincrt,commdlg;
const coerr=30;
      nmode=525;
      ndevice='Sequencer';
      nfileinfo='Fisiere MIDI standard'+chr(0)+'*.mid;*.rmi'+chr(0)+
                'Alte fisiere suportate ?'+chr(0)+'*.*'+chr(0)+
                chr(0);
      nopentitle='Deschide fisier MIDI';
var tic:integer;
    modlcd:byte;
    hw1,hw2,hw3:hwnd;
    bjos:boolean;
    pvx,pvy:integer;
    DC:Hdc;
    dc2:hdc;
    dublu:integer;
    handleclass:twndclass;
    GFileName: array[0..128] of Char;
    DS1,ds2,ds3,ds4: array[0..128] of Char;
    Tfilename: array[0..128] of char;
    i,j,k,l,m:longint;
    pornit:integer;
    mainw:hwnd;
    aremid:boolean;
    fig:longint;
    bucleaza:boolean;
    nucanta:boolean;
    eroare,apas_inch,apas_open,apas_play,apas_stop,apas_rew:integer;
type
  TApp = object(TApplication)
    procedure InitMainWindow; virtual;
    function IdleAction:boolean; virtual;
  end;
  PPlayerWindow = ^TPlayerWindow;
  TPlayerWindow = object(TWindow)
    boxa,Aparat,FontLCD1,FontLCD2,FontLCD3,FontLCD4,LCD2,buton:Hbitmap;
    icn1: Hicon;
    rec1:trect;
    constructor Init(AParent: PWindowsObject; Title: PChar);
    procedure PutBMP(DC: HDC; X, Y, BitMap: HBitMap; W,H,x2,y2:integer);
    procedure GetWindowClass(var WndClass: TWndClass); virtual;
    procedure Paint(PaintDC: HDC; var PaintInfo: TPaintStruct); virtual ;
    procedure Rect(TDC:HDC;R1,R2,R3,R4:integer; Col:Tcolorref);
    procedure Rct2(TDC:HDC;R1,R2,R3,R4:integer; Col:Tcolorref);
    procedure Scrie(tx,ty:integer;ce:string);
    procedure Apasa(bx,by,bl,bi:integer);
    procedure Restaur(bx,by,bl,bi:integer);
    procedure InitAparat;
    procedure IRect(r1,r2,r3,r4:integer);
    function jpp(te,fe:pchar):boolean;
    procedure SetUpWindow; virtual;
    procedure WMactivate (var Message:Tmessage); virtual wm_activate+wm_first;
    procedure WMLButtondown (var Message: Tmessage); virtual wm_LButtondown;
    procedure WMEraseBkGND (var Message: Tmessage); virtual wm_Erasebkgnd+wm_First;
    procedure WMClose (var Message: Tmessage); virtual wm_Close;
    procedure WMDestroy(var Message: TMessage); virtual wm_Destroy;
    procedure WMTimer(var Message: TMessage); virtual wm_Timer + wm_First;
  end;
{-----------------------------------------------------------------------------------------}
function HW1PROC(Wnd: hWnd; iMessage, wParam: Word; lParam: LongInt): LongInt;export;
var
  PaintStruct: TPaintStruct;
  Memdc,ODC: hDC;
  tpt:tpoint;
  maner1,maner2:hbitmap;
  adx,ady,wd,hg:integer;
  S: String;
  R: TRect;
begin
  odc:=getdc(wnd);
  case iMessage of
    WM_Activate:
      begin
      if wparam>0 then
      begin
      setwindowpos(mainw,0,0,0,0,0,swp_nomove or swp_nosize or swp_noactivate);
      setwindowpos(hw1,mainw,0,0,0,0,swp_nomove or swp_nosize or swp_noactivate);
      setwindowpos(hw2,hw1,0,0,0,0,swp_nomove or swp_nosize or swp_noactivate);
      setwindowpos(hw3,hw2,0,0,0,0,swp_nomove or swp_nosize or swp_noactivate);
     end;
      end;
    WM_lbuttondown:
      begin
      bjos:=true;
      getcursorpos(tpt);
      pvx:=tpt.x;
      pvy:=tpt.y;
      setcapture(wnd);
      end;
    WM_mousemove:
      begin
      if bjos=true then
      begin
      getcursorpos(tpt);
      adx:=tpt.x-pvx;
      ady:=tpt.y-pvy;
      pvx:=tpt.x;
      pvy:=tpt.y;
      getwindowrect(hw1,r);
      wd:=r.right-r.left;
      hg:=r.bottom-r.top;
      movewindow(hw1,r.left+adx,r.top+ady,wd,hg,true);
      getwindowrect(hw2,r);
      wd:=r.right-r.left;
      hg:=r.bottom-r.top;
      movewindow(hw2,r.left+adx,r.top+ady,wd,hg,true);
      getwindowrect(hw3,r);
      wd:=r.right-r.left;
      hg:=r.bottom-r.top;
      movewindow(hw3,r.left+adx,r.top+ady,wd,hg,true);
      getwindowrect(mainw,r);
      wd:=r.right-r.left;
      hg:=r.bottom-r.top;
      movewindow(mainw,r.left+adx,r.top+ady,wd,hg,true);
      end;
      end;
    WM_lbuttonup:
      begin
      bjos:=false;
      releasecapture;
      end;
    WM_erasebkgnd:
      begin
      if wnd=hw1 then
      begin
      maner1:=loadbitmap(hinstance,'MANER1');
      MemDC := CreateCompatibleDC(ODC);
      SelectObject(MemDC, maner1);
      BitBlt(ODC, 0, 0, 113, 8, MemDC, 0, 0, srccopy);
      DeleteDC(MemDC);
      deleteobject(maner1);
      end
      else
      begin
      maner2:=loadbitmap(hinstance,'MANER2');
      MemDC := CreateCompatibleDC(ODC);
      SelectObject(MemDC, maner2);
      BitBlt(ODC, 0, 0, 6, 15, MemDC, 0, 0, srccopy);
      DeleteDC(MemDC);
      deleteobject(maner2);
      end;
      end;
      WM_Destroy:
      begin
    releasedc(odc,wnd);
      end;
    else
      HW1PROC := DefWindowProc(Wnd, iMessage, wParam, lParam);
    releasedc(odc,wnd);
  end;
end;


function Tapp.IdleAction:boolean;
begin
IdleAction:=true;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
constructor TPlayerWindow.Init(AParent: PWindowsObject; Title: PChar);
var styl:longint;
    bazx,bazy:integer;
begin
  bazx:=(getsystemmetrics(sm_cxscreen) div 2)-98;
  bazy:=(getsystemmetrics(sm_cyscreen) div 2)-26;
  TWindow.Init(AParent, Title);
  Attr.X:=bazx;
  Attr.y:=bazy;
  Attr.W := 195;
  Attr.H := 53;
  Attr.Style := ws_popup;
  Randomize;
  styl:=ws_popup;
  handleclass.Style := CS_OwnDC;
  handleclass.lpfnWndProc:= @HW1PROC;
  handleclass.cbClsExtra := 0;
  handleclass.cbWndExtra := 0;
  handleclass.hInstance := HInstance;
  handleclass.hIcon := LoadIcon(hinstance,'ICO_MPC');
  handleclass.hCursor := LoadCursor(hinstance,'CRS_MP');
  handleclass.hbrBackground := GetStockObject(White_Brush);
  handleclass.lpszMenuName := 'Menu';
  handleclass.lpszclassname:='HWCLASS';
  if registerclass(handleclass)=false then messagebox(hwindow,'Eroare memorie','EROARE',mb_ok);
  hw1:=Createwindow('HWCLASS','Aux1',styl,bazx+41,bazy-15,113,8,hwindow,0,hinstance,nil);
  hw2:=Createwindow('HWCLASS','Aux2',styl,bazx+35,bazy-15,6,15,hwindow,0,hinstance,nil);
  hw3:=Createwindow('HWCLASS','Aux3',styl,bazx+154,bazy-15,6,15,hwindow,0,hinstance,nil);
  setparent(hw1,hwindow);
  setparent(hw2,hwindow);
  setparent(hw3,hwindow);
  showwindow(hw1,sw_show);
  showwindow(hw2,sw_show);
  showwindow(hw3,sw_show);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
function TplayerWindow.jpp(te,fe:pchar):boolean;
var tofn:topenfilename;
begin
gfilename[0]:=chr(0);
fillchar(tofn,sizeof(tofn),0);
with tofn do
begin
hwndowner:=hwindow;
hinstance:=0;
lpstrfilter:=fe;
lpstrcustomfilter:=nil;
nmaxcustfilter:=40;
nfilterindex:=0;
lpstrfile:=gfilename;
nmaxfile:=128;
lpstrfiletitle:=nil;
lpstrinitialdir:=nil;
lpstrdefext:='';
lpstrtitle:=te;
flags:=ofn_filemustexist+ofn_hidereadonly;
lstructsize:=sizeof(tofn);
end;
jpp:=getopenfilename(tofn);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TPlayerWindow.WMActivate(var message:tmessage);
begin
setwindowpos(hw1,mainw,0,0,0,0,swp_nomove or swp_nosize or swp_noactivate);
setwindowpos(hw2,hw1,0,0,0,0,swp_nomove or swp_nosize or swp_noactivate);
setwindowpos(hw3,hw2,0,0,0,0,swp_nomove or swp_nosize or swp_noactivate);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TPlayerWindow.PutBMP(DC: HDC; X, Y, BitMap: HBitMap; W,H,x2,y2:integer);
var
  MemDC: HDC;
  bm: TBitMap;
  MadeDC: Boolean;
begin
  MemDC := CreateCompatibleDC(DC);
  SelectObject(MemDC, BitMap);
  BitBlt(DC, X, Y, W, H, MemDC, x2, y2, srccopy);
  DeleteDC(MemDC);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TPlayerWindow.WMClose;
begin
destroywindow(hw1);
destroywindow(hw2);
destroywindow(hw3);
TPlayerWindow.Destroy;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TPlayerWindow.GetWindowClass(var WndClass: TWndClass);
begin
  TWindow.GetWindowClass(WndClass);
  WndClass.Style := 0;
  WndClass.hCursor := LoadCursor(0, Idc_Arrow);
  WndClass.hbrBackGround := GetStockObject(black_Brush);
  WndClass.lpszMenuName := 'A';
  WndClass.hIcon := LoadIcon(hInstance, 'ICO_MP');
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TPlayerWindow.Rect(tdc:HDC;r1,r2,r3,r4:integer; Col:TcolorRef);
begin
rec1.top:=r1;
rec1.left:=r2;
rec1.right:=r3;
rec1.bottom:=r4;
fillrect(tdc,rec1,createsolidbrush(col));
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TPlayerWindow.Rct2(tdc:HDC;r1,r2,r3,r4:integer; Col:TcolorRef);
begin
rec1.top:=r1;
rec1.left:=r2;
rec1.right:=r3;
rec1.bottom:=r4;
framerect(tdc,rec1,createsolidbrush(col));
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TPlayerWindow.IRect(r1,r2,r3,r4:integer);
begin
rec1.top:=r1;
rec1.left:=r2;
rec1.right:=r3;
rec1.bottom:=r4;
invalidaterect(hwindow,addr(rec1),false);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TPlayerWindow.WMTimer(var Message: TMessage);
begin
invalidaterect(mainw,nil,false);
tic:=1;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TPlayerWindow.Apasa(bx,by,bl,bi:integer);
begin
Rct2(dc,by+1,bx+1,bx+bl-1,by+bi-1,$808080);
putbmp(dc,bx+3,by+3,aparat,bl-4,bi-4,bx+2,by+2);
Rct2(dc,by+2,bx+2,bx+bl,by+bi,$c0c0c0);
Rct2(dc,by,bx,bx+bl,by+bi,$000000);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TPlayerWindow.Restaur(bx,by,bl,bi:integer);
begin
putbmp(dc,bx,by,aparat,bl,bi,bx,by);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TPlayerWindow.InitAparat;
begin
putbmp(dc,0,0,aparat,195,53,0,0);
if modlcd=1 then putbmp(dc,38,6,lcd2,119,15,0,0);
Scrie(39,7,'GATA.   ');
end;
{-----------------------------------------------------------------------------------------}
procedure TPlayerWindow.WMEraseBKGND (var Message: Tmessage);
var ts1,ts2,ts3:array[0..200] of char;
begin
putbmp(dc,0,0,aparat,195,53,0,0);
if modlcd=1 then putbmp(dc,38,6,lcd2,119,15,0,0);
if aremid=false then Scrie(39,7,'GATA.   ')
                else
                begin
                filesplit(gfilename,ts1,ts2,ts3);
                Scrie(39,7,strpas(ts2));
                end;
if bucleaza=true then Apasa(144,25,15,13)
                 else restaur(144,25,15,13);
end;
{-----------------------------------------------------------------------------------------}
procedure TPlayerWindow.Scrie (tx,ty:integer;ce:string);
var it:integer;
    cr:integer;
begin
for it:=1 to length(ce) do
begin
cr:=ord(ce[it]);
if cr<32 then cr:=32;
if cr>127 then cr:=32;
if modlcd=0 then if cr>32 then putbmp(dc,tx,ty,fontlcd1,9,14,(cr-33)*10,0)
                          else putbmp(dc,tx,ty,aparat,9,14,tx,ty);
if modlcd=1 then if cr>32 then putbmp(dc,tx,ty,fontlcd3,9,14,(cr-33)*10,0)
                          else putbmp(dc,tx,ty,lcd2,9,14,1,1);
tx:=tx+11;
end;
end;
{-----------------------------------------------------------------------------------------}
procedure tPlayerWindow.Paint(PaintDC: HDC; var PaintInfo: TPaintStruct);
label l1,l2;
var
  tcr:tcolorref;
  timp:longint;
  min,sec:integer;
  ld:boolean;
  ch:byte;
  deskdc:hdc;
  k:byte;
  b1,b2,b3,b4:byte;
  ts1,ts2,ts3,ts4:array[0..200] of char;
begin
deskdc:=getwindowdc(hwindow);
releasedc(hwindow,deskdc);
if (getmode=nmode) and (nucanta=false) then
begin
if bucleaza=true then
begin
stopmci;
playfrom(0);
end
else nucanta:=true;
end;
if aremid=true then
begin
timp:=getlocation;
b1:=1;
b2:=1;
b3:=1;
b4:=1;
if (getmode<>nmode) then
begin
k:=(timp div 100) mod 4;
if k<2 then b1:=0 else b2:=0;
if k<2 then b3:=0 else b4:=0;
end;
case b1 of 0:putbmp(dc,0,0,boxa,32,26,0,0);
                  1:putbmp(dc,0,0,aparat,32,26,0,0);
end;
case b2 of 0:putbmp(dc,0,26,boxa,32,27,0,26);
                  1:putbmp(dc,0,26,aparat,32,27,0,26);
end;
case b3 of 0:putbmp(dc,163,0,boxa,32,26,0,0);
                  1:putbmp(dc,163,0,aparat,32,26,0,0);
end;
case b4 of 0:putbmp(dc,163,26,boxa,32,27,0,26);
                  1:putbmp(dc,163,26,aparat,32,27,0,26);
end;
timp:=timp div 1000;
min:=(timp div 60) mod 60;
sec:=timp mod 60;
if modlcd=0 then
begin
putbmp(dc,129,9,fontlcd2,5,9,0+(min div 10)*6,0);
putbmp(dc,135,9,fontlcd2,5,9,0+(min mod 10)*6,0);
putbmp(dc,143,9,fontlcd2,5,9,0+(sec div 10)*6,0);
putbmp(dc,149,9,fontlcd2,5,9,0+(sec mod 10)*6,0);
setpixel(dc,141,11,$FFFF00);
setpixel(dc,141,15,$FFFF00);
end;
if modlcd=1 then
begin
putbmp(dc,129,9,fontlcd4,5,9,0+(min div 10)*6,0);
putbmp(dc,135,9,fontlcd4,5,9,0+(min mod 10)*6,0);
putbmp(dc,143,9,fontlcd4,5,9,0+(sec div 10)*6,0);
putbmp(dc,149,9,fontlcd4,5,9,0+(sec mod 10)*6,0);
setpixel(dc,141,11,$000000);
setpixel(dc,141,15,$000000);
end;
end;
if pornit=0 then
begin
InitAparat;
pornit:=1;
end;
if eroare=1 then
begin
if aremid=false then Scrie(39,7,'GATA.   ')
                else
                begin
                filesplit(gfilename,ts1,ts2,ts3);
                Scrie(39,7,'        ');
                Scrie(39,7,strpas(ts2));
                end;
end;
if eroare>0 then dec(eroare);
if apas_open>0 then dec(apas_open);
if apas_play>0 then dec(apas_play);
if apas_stop>0 then dec(apas_stop);
if apas_rew>0 then dec(apas_rew);
if apas_inch>0 then dec(apas_inch);
if apas_open=1 then
begin
Restaur(36,25,24,24);
strcopy(tfilename,gfilename);
ld:=false;
ld:=jpp(nopentitle,nfileinfo);
if ld=true then
begin
nucanta:=true;
stopmci;
closemci;
aremid:=true;
Scrie(39,7,'INCARC..');                                                                               {disc}
if openmci(hwindow,gfilename,ndevice)=false then begin aremid:=false; eroare:=coerr; Scrie(39,7,'EROARE  '); end;
settimeformatms;
end else strcopy(gfilename,tfilename);
if (eroare=0) then
begin
if  aremid=false then Scrie(39,7,'GATA.   ')
                else
                begin
                filesplit(gfilename,ts1,ts2,ts3);
                Scrie(39,7,'        ');
                Scrie(39,7,strpas(ts2));
                end;
end;
end;
if apas_play=1 then
begin
Restaur( 66,25,24,24);
if (aremid=true) then
begin
if getmode=nmode then
begin
nucanta:=false;
playmci;
end;                                            {n-are fis}
end else begin eroare:=coerr; Scrie(39,7,'EROARE  '); end;
end;
if apas_stop=1 then
begin
Restaur( 92,25,24,24);
if getmode<>nmode then
begin
nucanta:=true;
stopmci;
end;
end;
if apas_rew =1 then
begin
if aremid=true then
begin
nucanta:=true;
stopmci;
closemci;
Scrie(39,7,'DERULEZ ');
openmci(hwindow,gfilename,ndevice);
settimeformatms;
if aremid=false then Scrie(39,7,'GATA.   ')
                else
                begin
                filesplit(gfilename,ts1,ts2,ts3);
                Scrie(39,7,'        ');
                Scrie(39,7,strpas(ts2));
                end;                              {n-are fisier}
end else begin eroare:=coerr; Scrie(39,7,'EROARE  ');end;
Restaur(118,25,24,24);
end;
if apas_inch=1 then
               begin
               destroywindow(hw1);
               destroywindow(hw2);
               destroywindow(hw3);
               TPlayerWindow.destroy;
               end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TPlayerWindow.WmLbuttondown(var message: TMessage);
var cx,cy:integer; cp:tpoint;
    ts1,ts2,ts3:array[0..200] of char;
    sr:trect;
begin
GetWindowRect(hwindow,sr);
Getcursorpos(cp);
cx:=cp.X-sr.left;
cy:=cp.Y-sr.top{-19};
if (cx>38) and (cy>6) and (cx<157) and (cy<21) then
begin
modlcd:=1-modlcd;
if modlcd=0 then putbmp(dc,38,6,aparat,119,15,38,6);
if modlcd=1 then putbmp(dc,38,6,lcd2,119,15,0,0);
if aremid=false then Scrie(39,7,'GATA.   ')
                else
                begin
                filesplit(gfilename,ts1,ts2,ts3);
                Scrie(39,7,'        ');
                Scrie(39,7,strpas(ts2));
                end;
end;
if (cx>36) and (cy>25) and (cx<60) and (cy<59) then
begin
apas_open:=5;
Apasa(36,25,24,24);
end;
if (cx>66) and (cy>25) and (cx<90) and (cy<59) then
begin
apas_play:=5;
Apasa(66,25,24,24);
end;
if (cx>92) and (cy>25) and (cx<116) and (cy<59) then
begin
apas_stop:=5;
Apasa(92,25,24,24);
end;
if (cx>118) and (cy>25) and (cx<142) and (cy<59) then
begin
apas_rew:=5;
Apasa(118,25,24,24);
end;
if (cx>144) and (cy>39) and (cx<159) and (cy<49) then
begin
apas_inch:=5;
Apasa(144,39,15,10);
end;
if (cx>144) and (cy>25) and (cx<159) and (cy<38) then
begin
if bucleaza=false then bucleaza:=true else bucleaza:=false;
if bucleaza=true then Apasa(144,25,15,13)
                 else restaur(144,25,15,13);
end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure TPlayerWindow.SetUpWindow;
var ts2,ts1:string;
    tpc1:pchar;
begin
  modlcd:=0;
  nucanta:=true;
  bucleaza:=false;
  mainw:=Hwindow;
  buton := LoadBitMap(hInstance, 'BUTON');
  boxa := LoadBitMap(hInstance, 'BOXA');
  Aparat := LoadBitMap(hInstance, 'APARAT');
  FontLCD1 := LoadBitMap(hInstance, 'FONTLCD1');
  FontLCD2 := LoadBitMap(hInstance, 'FONTLCD2');
  FontLCD3 := LoadBitMap(hInstance, 'FONTLCD3');
  FontLCD4 := LoadBitMap(hInstance, 'FONTLCD4');
  LCD2 := LoadBitMap(hInstance, 'LCD2');
  Icn1 := LoadIcon(hInstance, 'ICO_MP');
  dc:=getdc(hwindow);{window}
  SetMapmode(dc,mm_text);
  aremid:=false;
  settimer(hwindow,1,1,nil);
  pornit:=0;
end;

procedure TPlayerWindow.WMDestroy(var Message: TMessage);
var i,j:longint;
begin
  releasedc(hwindow,dc);
  TWindow.WMDestroy(Message);
  deleteobject(buton);
  deleteobject(boxa);
  deleteobject(icn1);
  deleteobject(Aparat);
  deleteobject(fontLCD1);
  deleteobject(fontLCD2);
  deleteobject(fontLCD3);
  deleteobject(fontLCD4);
  deleteobject(LCD2);
end;
{--------------- TApp ------------------------}

procedure TApp.InitMainWindow;
begin
  MainWindow := New(PPlayerWindow, Init(nil, 'MIDPlay de D.C.M. SOFT'));
end;

{-------------Main Program--------------------}

var
  App: TApp;
begin
if hprevinst>0 then messagebeep(65535)
else
begin
  App.Init('MIDPlay de D.C.M. SOFT');
  App.Run;
  App.Done;
end;
end.
