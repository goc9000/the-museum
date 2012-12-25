program Vizualizatorhexa;
{$R VECH20}
{$X+}
uses bwcc,objects,Winprocs,wintypes,owindows,odialogs,win31,windos,strings,commdlg,omemory;
const ninfofis='Orice fisier'+chr(0)+'*.*'+chr(0)+chr(0);
      wm_user1=6666;
      cul_fond:tcolorref=$ffffff;
var termina,existdlg:boolean;
    aratadif:boolean;
    scr_sinc:boolean;
    stn1,stn2,stn3,stn4,stn5,stn6:array[0..128] of char;
    stp1:string;
    ast:integer;
    despar:integer;
    adr_min,adr_max:word;
    lung1,lung2:longint;
    bitfont:hbitmap;
    ferbloc,stbloc,sfbloc,starebloc:word;
    win:hwnd;
    intro,i,j,k,l,m:longint;
    adr_cursor,fer_cursor,nibble_cursor:longint;
    proc1,proc2,proc3:tfarproc;
    viewer1,viewer2:hwnd;
    numefis1,numefis2:array[0..128] of char;
    poz1,poz2,poz1h,poz2h:word;
    param1,param2:word;
    bloc1:pointer;
    bloc2:pointer;
    n:longint;
type
 TApp = object(TApplication)
    procedure InitMainWindow; virtual;
   { function IdleAction:boolean; virtual;}
  end;
  Pdropper = ^Tdropper;
  Tdropper = object(twindow)
    constructor Init(AParent: PWindowsObject; Title: PChar);
    procedure GetWindowClass(var WndClass: TWndClass); virtual;
    procedure desch1;
    procedure desch2;
    procedure salv1;
    procedure salv2;
    procedure creeaza;
    procedure Desparte;
    procedure WMSize(var Message: Tmessage); virtual wm_First+wm_size;
    procedure SetUpWindow; virtual;
    procedure WMcommand (var Message: Tmessage); virtual wm_Command;
    procedure WMClose (var Message: Tmessage); virtual wm_Close;
    procedure WMDestroy(var Message: TMessage); virtual wm_Destroy;
    procedure WMTimer(var Message: TMessage); virtual wm_Timer + wm_First;
  end;
{-----------------------------------------------------------------------------------------}
procedure rect(tdc:HDC;r1,r2,r3,r4:integer; Col:TcolorRef);
var rec:trect;
begin
rec.left:=r1;
rec.top:=r2;
rec.right:=r3;
rec.bottom:=r4;
fillrect(tdc,rec,createsolidbrush(col));
end;
{-----------------------------------------------------------------------------------------}
procedure creeazabloc;
begin
enablemenuitem(getmenu(win),150,mf_bycommand or mf_enabled);
enablemenuitem(getmenu(win),152,mf_bycommand or mf_enabled);
enablemenuitem(getmenu(win),153,mf_bycommand or mf_enabled);
end;
{-----------------------------------------------------------------------------------------}
procedure distrugebloc;
begin
enablemenuitem(getmenu(win),150,mf_bycommand or mf_grayed);
enablemenuitem(getmenu(win),152,mf_bycommand or mf_grayed);
enablemenuitem(getmenu(win),153,mf_bycommand or mf_grayed);
end;
{-----------------------------------------------------------------------------------------}
function jpp(hw:hwnd;te,fe,gcen:pchar):boolean;
var tofn:topenfilename;
begin
gcen[0]:=chr(0);
fillchar(tofn,sizeof(tofn),0);
with tofn do
begin
hwndowner:=hw;
hinstance:=0;
lpstrfilter:=fe;
lpstrcustomfilter:=nil;
nmaxcustfilter:=40;
nfilterindex:=0;
lpstrfile:=gcen;
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
function spp(hw:hwnd;te,fe,gcen:pchar):boolean;
var tofn:topenfilename;
begin
gcen[0]:=chr(0);
fillchar(tofn,sizeof(tofn),0);
with tofn do
begin
hwndowner:=hw;
hinstance:=0;
lpstrfilter:=fe;
lpstrcustomfilter:=nil;
nmaxcustfilter:=40;
nfilterindex:=0;
lpstrfile:=gcen;
nmaxfile:=128;
lpstrfiletitle:=nil;
lpstrinitialdir:=nil;
lpstrdefext:='';
lpstrtitle:=te;
flags:=ofn_hidereadonly;
lstructsize:=sizeof(tofn);
end;
spp:=getsavefilename(tofn);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tdropper.desch1;
var onumefis1:array[0..128] of char;
    fhd:integer;
    marime:longint;
begin
strcopy(onumefis1,numefis1);
if jpp(hwindow,'Încarcã #1',ninfofis,numefis1)=false then strcopy(numefis1,onumefis1)
else
begin
fhd:=_lopen(numefis1,of_readwrite);
marime:=_llseek(fhd,0,2);
if marime>64512 then
begin
messagebox(viewer1,'Fisier prea mare pentru aceastã versiune (>63K)!',
           'Eroare',mb_ok or mb_iconexclamation);
_lclose(fhd);
exit;
end;
if marime=0 then
begin
messagebox(viewer2,'Fisier nul!',
           'Eroare',mb_ok or mb_iconexclamation);
_lclose(fhd);
exit;
end;
_llseek(fhd,0,0);
lung1:=_lread(fhd,bloc1,-1535);
poz1:=0;
poz1h:=0;
adr_cursor:=0;
nibble_cursor:=0;
fer_cursor:=viewer1;
_lclose(fhd);
postmessage(viewer1,wm_user1,0,0);
updatewindow(viewer1);
postmessage(viewer2,wm_user1,0,0);
updatewindow(viewer2);
enablemenuitem(getmenu(hwindow),110,mf_bycommand or mf_enabled);
end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tdropper.desch2;
var onumefis2:array[0..128] of char;
    fhd:integer;
    marime:longint;
begin
strcopy(onumefis2,numefis2);
if jpp(hwindow,'Încarcã #2',ninfofis,numefis2)=false then strcopy(numefis2,onumefis2)
else
begin
fhd:=_lopen(numefis2,of_readwrite);
marime:=_llseek(fhd,0,2);
if marime>64512 then
begin
messagebox(viewer2,'Fisier prea mare pentru aceastã versiune (>63K)!',
           'Eroare',mb_ok or mb_iconexclamation);
_lclose(fhd);
exit;
end;
if marime=0 then
begin
messagebox(viewer2,'Fisier nul!',
           'Eroare',mb_ok or mb_iconexclamation);
_lclose(fhd);
exit;
end;
_llseek(fhd,0,0);
lung2:=_lread(fhd,bloc2,-1535);
poz2:=0;
poz2h:=0;
adr_cursor:=0;
nibble_cursor:=0;
fer_cursor:=viewer2;
_lclose(fhd);
postmessage(viewer1,wm_user1,0,0);
updatewindow(viewer1);
postmessage(viewer2,wm_user1,0,0);
updatewindow(viewer2);
enablemenuitem(getmenu(hwindow),111,mf_bycommand or mf_enabled);
end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tdropper.salv1;
var onumefis1:array[0..128] of char;
    fhd:integer;
    marime:longint;
begin
strcopy(onumefis1,numefis1);
if spp(hwindow,'Salveazã #1',ninfofis,numefis1)=false then strcopy(numefis1,onumefis1)
else
begin
fhd:=_lcreat(numefis1,0);
_lwrite(fhd,bloc1,lung1);
_lclose(fhd);
postmessage(viewer1,wm_user1,0,0);
updatewindow(viewer1);
end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tdropper.salv2;
var onumefis2:array[0..128] of char;
    fhd:integer;
    marime:longint;
begin
strcopy(onumefis2,numefis2);
if spp(hwindow,'Salveazã #2',ninfofis,numefis2)=false then strcopy(numefis2,onumefis2)
else
begin
fhd:=_lcreat(numefis2,0);
_lwrite(fhd,bloc2,lung2);
_lclose(fhd);
postmessage(viewer2,wm_user1,0,0);
updatewindow(viewer2);
end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tdropper.creeaza;
var fhd:integer;
    tp:array[0..128] of char;
    a:integer;
    par:longint;
    buf:array[0..255] of char;
begin
if dialogbox(hinstance,'FISNOU_V20',hwindow,proc2)=400 then
begin
if spp(hwindow,'Creeazã...',ninfofis,tp)=true then
begin
par:=param1;
fillchar(buf,sizeof(buf),param2);
fhd:=_lcreat(tp,0);
repeat
if par>256 then a:=256 else a:=par;
_lwrite(fhd,buf,a);
par:=par-256;
until par<=0;
_lclose(fhd);
end;

end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tdropper.wmcommand(var message:tmessage);
var sg:word;
    mr:word;
    bufpt:integer;
    buf:array[0..255] of char;
    p1:pchar;
    fhd:integer;
    lcit:word;
begin
if stbloc>sfbloc then
begin
sg:=stbloc;
stbloc:=sfbloc;
sfbloc:=sg;
end;
if message.wparam=999 then dialogbox(hinstance,'DESPRE_V20',hwindow,proc3);
if message.wparam=105 then Creeaza;
if message.wparam=102 then desch1;
if message.wparam=103 then desch2;
if message.wparam=110 then salv1;
if message.wparam=150 then begin
                           sg:=seg(bloc1^);
                           if ferbloc<>viewer1 then sg:=seg(bloc2^);
                           getwindowsdirectory(stn1,100);
                           strcat(stn1,'\cliptemp.$$$');
                           fhd:=_lcreat(stn1,0);
                           bufpt:=0;
                           for i:=stbloc to sfbloc do
                           begin
                           buf[bufpt]:=char(mem[sg:i]);
                           bufpt:=bufpt+1;
                           if bufpt=256 then
                           begin
                           _lwrite(fhd,buf,256);
                           bufpt:=0;
                           end;
                           end;
                           if bufpt>0 then _lwrite(fhd,buf,bufpt);
                           _lclose(fhd);
                           enablemenuitem(getmenu(hwindow),151,mf_bycommand or mf_enabled);
                           end;
if message.wparam=151 then begin
                           sg:=seg(bloc1^);
                           if fer_cursor<>viewer1 then sg:=seg(bloc2^);
                           getwindowsdirectory(stn1,100);
                           strcat(stn1,'\cliptemp.$$$');
                           fhd:=_lopen(stn1,of_readwrite);
                           repeat
                           mr:=_lread(fhd,buf,256);
                           for i:=1 to mr do
                           begin
                           mem[sg:adr_cursor]:=ord(buf[i-1]);
                           if adr_cursor<64513 then inc(adr_cursor);
                           end;
                           until mr<256;
                           _lclose(fhd);
                           postmessage(viewer1,wm_user1,0,0);
                           postmessage(viewer2,wm_user1,0,0);
                           end;
if message.wparam=152 then begin
                           sg:=seg(bloc1^);
                           if ferbloc<>viewer1 then sg:=seg(bloc2^);
                           for i:=stbloc to sfbloc do mem[sg:i]:=0;
                           postmessage(viewer1,wm_user1,0,0);
                           postmessage(viewer2,wm_user1,0,0);
                           end;
if message.wparam=153 then begin
                           distrugebloc;
                           starebloc:=0; stbloc:=65535; sfbloc:=65535;
                           postmessage(ferbloc,wm_user1,0,0);
                           end;
if message.wparam=200 then
begin
despar:=1;
desparte;
checkmenuitem(getmenu(hwindow),200,mf_bycommand or mf_checked);
checkmenuitem(getmenu(hwindow),201,mf_bycommand or mf_unchecked);
end;
if message.wparam=201 then
begin
despar:=2;
desparte;
checkmenuitem(getmenu(hwindow),200,mf_bycommand or mf_unchecked);
checkmenuitem(getmenu(hwindow),201,mf_bycommand or mf_checked);
end;
if message.wparam=303 then
begin
if aratadif=true then begin checkmenuitem(getmenu(hwindow),303,mf_bycommand or mf_unchecked); aratadif:=false; end
                else begin checkmenuitem(getmenu(hwindow),303,mf_bycommand or mf_checked); aratadif:=true; end;
postmessage(viewer1,wm_user1,0,0);
updatewindow(viewer1);
postmessage(viewer2,wm_user1,0,0);
updatewindow(viewer2);
end;
if message.wparam=300 then
begin
scr_sinc:=true;
checkmenuitem(getmenu(hwindow),300,mf_bycommand or mf_checked);
checkmenuitem(getmenu(hwindow),301,mf_bycommand or mf_unchecked);
end;
if message.wparam=301 then
begin
scr_sinc:=false;
checkmenuitem(getmenu(hwindow),300,mf_bycommand or mf_unchecked);
checkmenuitem(getmenu(hwindow),301,mf_bycommand or mf_checked);
end;
if message.wparam=104 then destroywindow(hwindow);
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
{$F+}
function DIALOG_FISNOU(Dialog: HWnd; Message, WParam: Word; LParam: Longint): Bool; export;
var oktrad:boolean;
begin
Dialog_fisnou:=true;
case message of
wm_InitDialog:
begin
end;
wm_command:
begin
if (wparam=400) or (wparam=401) or (wparam=id_cancel) then
begin
if (wparam=400) then
begin
param1:=getdlgitemint(dialog,600,addr(oktrad),false);
if (oktrad=false) or (param1=0) or (param1>64512) then
                begin
                messagebox(dialog,'Lungimea trebuie sã fie între 1 si 64512 !','Eroare',mb_ok or mb_iconstop);
                exit;
                end;
param2:=getdlgitemint(dialog,601,addr(oktrad),false);
if (oktrad=false) or (param2>255) then
                begin
                messagebox(dialog,'Valoarea trebuie sã fie între 0 si 255 !','Eroare',mb_ok or mb_iconstop);
                exit;
                end;
end;
enddialog(dialog,wparam);
end;
end;

end;
Dialog_fisnou:=false;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
{$F+}
function DIALOG_DESPRE(Dialog: HWnd; Message, WParam: Word; LParam: Longint): Bool; export;
begin
Dialog_despre:=true;
case message of
wm_InitDialog:
begin
end;
wm_command:
begin
if (wparam=400) or (wparam=id_cancel) then
begin
enddialog(dialog,1);
end;
end;

end;
Dialog_despre:=false;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
{$F+}
function DIALOG_PRINC(Dialog: HWnd; Message, WParam: Word; LParam: Longint): Bool; export;
var tip:integer;
    tw:hwnd;
    pc1:array[0..200] of char;
    adr:word;
    st:string;
    tv1,tv2:longint;
    ok:boolean;
    ypos:integer;
    pos:integer;
    memdc:hdc;
    tsrcy:integer;
    tsrc2:integer;
    tx:integer;
    pozh_cr,poz_cr,seg_cr,segopus_cr,lung_cr:word;
    lungcom:word;
    nonadr:boolean;
    lastj:integer;
    pozc:tpoint;
    modop:longint;
    but:integer;
begin
  DIALOG_PRINC := True;
  case Message of
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
wm_drawitem:
begin
with pdrawitemstruct(lparam)^ do
begin
getcursorpos(pozc);
screentoclient(hwnditem,pozc);
nonadr:=false;
if (ctlid<>500) then exit;
but:=0;
if getasynckeystate(vk_lbutton)<0 then but:=1;
if getasynckeystate(vk_shift)<0 then but:=but*2;
memdc:=createcompatibledc(hdc);
seg_cr:=seg(bloc1^); segopus_cr:=seg(bloc2^); lung_cr:=lung1; poz_cr:=poz1; pozh_cr:=poz1h*7;
if dialog=viewer2 then begin seg_cr:=seg(bloc2^);segopus_cr:=seg(bloc1^); lung_cr:=lung2; poz_cr:=poz2; pozh_cr:=poz2h*7; end;
lungcom:=lung1;
if lung1>lung2 then lungcom:=lung2;
lastj:=0;
if lung_cr>0 then
begin
selectobject(memdc,bitfont);
adr:=poz_cr*16;
adr_min:=poz_cr*16;
for j:=poz_cr to ((lung_cr-1) div 16) do
begin
adr_max:=j*16;
ypos:=(j-poz_cr)*10;
if ((ypos+10)>rcitem.bottom) then begin nonadr:=true; break; end;
lastj:=lastj+10;
bitblt(hdc,00-pozh_cr,ypos,7,10,memdc,((j shl 4) shr 12)*7,0,srccopy);
bitblt(hdc,07-pozh_cr,ypos,7,10,memdc,(((j shl 4) shr 8) and 15)*7,0,srccopy);
bitblt(hdc,14-pozh_cr,ypos,7,10,memdc,(((j shl 4) shr 4) and 15)*7,0,srccopy);
bitblt(hdc,21-pozh_cr,ypos,7,10,memdc,(((j shl 4) and 15))*7,0,srccopy);
bitblt(hdc,28-pozh_cr,ypos,7,10,memdc,112,0,srccopy);
for i:=0 to 15 do
begin
tx:=35-pozh_cr+i*17;
tsrcy:=0;
if adr<(lung_cr) then
begin
if aratadif=true then if (adr<lungcom) then if (mem[seg_cr:adr]<>mem[segopus_cr:adr]) then tsrcy:=10;
tsrc2:=0;
if (pozc.x>=(tx-2)) and (pozc.x<(tx+6)) and (pozc.y>=(ypos+0)) and (pozc.y<=(ypos+9)) then
begin
if but=1 then begin fer_cursor:=dialog; adr_cursor:=adr; nibble_cursor:=0; end;
if but=2 then
begin
postmessage(viewer1,wm_user1,0,0);
postmessage(viewer2,wm_user1,0,0);
if (starebloc=0) then
begin
distrugebloc;
ferbloc:=dialog;
stbloc:=adr;
sfbloc:=adr;
starebloc:=1;
end
else
begin
if ferbloc=dialog then
begin
creeazabloc;
sfbloc:=adr;
starebloc:=0;
end;
end;
end;
end;
modop:=srccopy;
if (ferbloc=dialog) then
if ((adr>=stbloc) and (adr<=sfbloc)) or
   ((adr>=sfbloc) and (adr<=stbloc)) then modop:=notsrccopy;
if (adr=adr_cursor) and (fer_cursor=dialog) and (nibble_cursor=0) then tsrc2:=20;
bitblt(hdc,tx+0,ypos,7,10,memdc,((mem[seg_cr:adr]) shr 4)*7,tsrcy+tsrc2,modop);
tsrc2:=0;
if (pozc.x>=(tx+7)) and (pozc.x<=(tx+15)) and (pozc.y>=(ypos+0)) and (pozc.y<=(ypos+9)) then
begin
if but=1 then begin fer_cursor:=dialog; adr_cursor:=adr; nibble_cursor:=1; end;
if but=2 then
begin
postmessage(viewer1,wm_user1,0,0);
postmessage(viewer2,wm_user1,0,0);
if (starebloc=0) then
begin
distrugebloc;
ferbloc:=dialog;
stbloc:=adr;
sfbloc:=adr;
starebloc:=1;
end
else
begin
if ferbloc=dialog then
begin
creeazabloc;
sfbloc:=adr;
starebloc:=0;
end;
end;
end;
end;
if (adr=adr_cursor) and (fer_cursor=dialog) and (nibble_cursor=1) then tsrc2:=20;
bitblt(hdc,tx+7,ypos,7,10,memdc,((mem[seg_cr:adr]) and 15)*7,tsrcy+tsrc2,modop);
if i=15 then modop:=srccopy;
bitblt(hdc,tx+14,ypos,7,10,memdc,119,0,modop);
end else
begin
bitblt(hdc,tx+0,ypos,7,10,memdc,119,0,srccopy);
bitblt(hdc,tx+7,ypos,7,10,memdc,119,0,srccopy);
bitblt(hdc,tx+14,ypos,7,10,memdc,119,0,srccopy);
end;
adr:=adr+1;
end;
rect(hdc,56-pozh_cr+15*17,ypos,rcitem.right,ypos+10,cul_fond);
end;

end;
rect(hdc,0,lastj,rcitem.right,rcitem.bottom,cul_fond);
deletedc(memdc);
if nonadr=false then adr_max:=adr_max+32;
end;
end;
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
wm_Size:
begin
tv1:=(307-(loword(lparam)-24)) div 7;
if ((loword(lparam)-24)>=307) then tv1:=0;
setscrollrange(getdlgitem(viewer1,601),sb_ctl,0,tv1,true);
setscrollrange(getdlgitem(viewer2,601),sb_ctl,0,tv1,true);
if (poz1h>tv1) then
begin
poz1h:=tv1;
invalidaterect(getdlgitem(viewer1,500),nil,false);
end;
if (poz2h>tv1) then
begin
poz2h:=tv1;
invalidaterect(getdlgitem(viewer2,500),nil,false);
end;
{PRINC}
tw:=getdlgitem(dialog,503);
movewindow(tw,0,16,loword(lparam)-16,(hiword(lparam))-32,true);
tw:=getdlgitem(dialog,500);
movewindow(tw,1,17,loword(lparam)-18,(hiword(lparam))-34,true);
{SCROLLBARURI}
tw:=getdlgitem(dialog,600);
movewindow(tw,loword(lparam)-16,16,16,(hiword(lparam))-16,true);
tw:=getdlgitem(dialog,601);
movewindow(tw,0,(hiword(lparam))-16,loword(lparam)-16,16,true);
{CAPTION}
tw:=getdlgitem(dialog,502);
movewindow(tw,0,0,loword(lparam),16,true);
tw:=getdlgitem(dialog,501);
movewindow(tw,1,1,loword(lparam)-2,14,true);
end;
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
wm_user1:
begin
setscrollrange(getdlgitem(viewer1,600),sb_ctl,0,(lung1-1) div 16,true);
setscrollrange(getdlgitem(viewer2,600),sb_ctl,0,(lung2-1) div 16,true);
invalidaterect(getdlgitem(dialog,500),nil,false);
if dialog=viewer1 then
begin
if lung1>0 then
begin
filesplit(numefis1,stn1,stn2,stn3);
strcat(stn2,stn3);
str(lung1,stp1);
strpcopy(stn1,stp1);
strcat(stn2,' (');
strcat(stn2,stn1);
strcat(stn2,' octeti)');
setdlgitemtext(dialog,501,stn2);
end
else
begin
setdlgitemtext(dialog,501,'Nici un fisier încãrcat.');
end;
end;
if dialog=viewer2 then
begin
if lung2>0 then
begin
filesplit(numefis2,stn1,stn2,stn3);
strcat(stn2,stn3);
str(lung2,stp1);
strpcopy(stn1,stp1);
strcat(stn2,' (');
strcat(stn2,stn1);
strcat(stn2,' octeti)');
setdlgitemtext(dialog,501,stn2);
end
else
begin
setdlgitemtext(dialog,501,'Nici un fisier încãrcat.');
end;
end;
end;
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
wm_vscroll:
begin
  tw := HiWord(lParam);
  Pos := GetScrollPos(tw, SB_Ctl);
  case wParam of
    sb_LineUp: Dec(Pos);
    sb_LineDown: Inc(Pos);
    sb_PageUp: Dec(Pos, 1);
    sb_PageDown: Inc(Pos, 1);
    sb_ThumbPosition: Pos := LoWord(lParam);
    sb_ThumbTrack: Pos := LoWord(lParam);
  end;
  SetScrollPos(tw, sb_Ctl, Pos, True);
if dialog=viewer1 then poz1:=GetScrollPos(tw, SB_Ctl);
if dialog=viewer2 then poz2:=GetScrollPos(tw, SB_Ctl);
if scr_sinc=true then
begin
if dialog=viewer1 then
begin
poz2:=GetScrollPos(tw, SB_Ctl);
Setscrollpos(getdlgitem(viewer2,600),sb_ctl,poz2,true);
invalidaterect(getdlgitem(viewer2,500),nil,false);
end;
if dialog=viewer2 then
begin
poz1:=GetScrollPos(tw, SB_Ctl);
Setscrollpos(getdlgitem(viewer1,600),sb_ctl,poz1,true);
invalidaterect(getdlgitem(viewer1,500),nil,false);
end;

end;
invalidaterect(getdlgitem(dialog,500),nil,false);
end;
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
wm_hscroll:
begin
  tw := HiWord(lParam);
  Pos := GetScrollPos(tw, SB_Ctl);
  case wParam of
    sb_LineUp: Dec(Pos);
    sb_LineDown: Inc(Pos);
    sb_PageUp: Dec(Pos, 1);
    sb_PageDown: Inc(Pos, 1);
    sb_ThumbPosition: Pos := LoWord(lParam);
    sb_ThumbTrack: Pos := LoWord(lParam);
  end;
  SetScrollPos(tw, sb_Ctl, Pos, True);
if dialog=viewer1 then poz1h:=GetScrollPos(tw, SB_Ctl);
if dialog=viewer2 then poz2h:=GetScrollPos(tw, SB_Ctl);
invalidaterect(getdlgitem(dialog,500),nil,false);
end;
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
wm_InitDialog:
begin
end;
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
wm_Command:
begin
if (wparam=id_cancel) then
begin
termina:=true;
destroywindow(dialog);
Exit;
end;
end;
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
end;
  DIALOG_PRINC := False;
end;
{-----------------------------------------------------------------------------------------}
constructor Tdropper.Init(AParent: PWindowsObject; Title: PChar);
var ms:integer;
begin
  TWindow.Init(AParent, Title);
  ms:=768;
  if getsystemmetrics(sm_cxscreen)=640 then ms:=640;
  Attr.X:=(getsystemmetrics(sm_cxscreen)-ms) div 2;
  Attr.y:=(getsystemmetrics(sm_cyscreen)-480) div 2;
  Attr.W := ms;
  Attr.H := 480;
  Attr.Style :=ws_popup or ws_caption or ws_sysmenu or ws_thickframe or ws_sizebox or ws_maximizebox or ws_minimizebox;
  Randomize;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tdropper.WMClose;
begin
Tdropper.Destroy;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tdropper.GetWindowClass(var WndClass: TWndClass);
begin
  TWindow.GetWindowClass(WndClass);
  WndClass.Style := 0;
  WndClass.hCursor := LoadCursor(0, idc_arrow);
  WndClass.hbrBackGround := GetStockObject(white_Brush);
  WndClass.lpszMenuName := 'MENIU_PRINC';
  WndClass.hIcon := LoadIcon(hInstance, 'ICO_V20');
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tdropper.WMTimer(var Message: TMessage);
var miscat:integer;
    segm:word;
    lim:longint;
    tastanum:integer;
begin
miscat:=0;
if ast>0 then ast:=ast-1;
if fer_cursor=viewer1 then begin lim:=lung1-1; segm:=seg(bloc1^); end;
if fer_cursor=viewer2 then begin lim:=lung2-1; segm:=seg(bloc2^); end;
if (getactivewindow=hwindow) then
begin
tastanum:=16;
if ast=0 then
begin
if getasynckeystate($30)<0 then tastanum:=0;
if getasynckeystate($31)<0 then tastanum:=1;
if getasynckeystate($32)<0 then tastanum:=2;
if getasynckeystate($33)<0 then tastanum:=3;
if getasynckeystate($34)<0 then tastanum:=4;
if getasynckeystate($35)<0 then tastanum:=5;
if getasynckeystate($36)<0 then tastanum:=6;
if getasynckeystate($37)<0 then tastanum:=7;
if getasynckeystate($38)<0 then tastanum:=8;
if getasynckeystate($39)<0 then tastanum:=9;
if getasynckeystate($41)<0 then tastanum:=10;
if getasynckeystate($42)<0 then tastanum:=11;
if getasynckeystate($43)<0 then tastanum:=12;
if getasynckeystate($44)<0 then tastanum:=13;
if getasynckeystate($45)<0 then tastanum:=14;
if getasynckeystate($46)<0 then tastanum:=15;
if getasynckeystate($47)<0 then tastanum:=16;
end;
if tastanum<16 then
begin
if nibble_cursor=0 then mem[segm:adr_cursor]:=mem[segm:adr_cursor] and 15+tastanum shl 4;
if nibble_cursor=1 then mem[segm:adr_cursor]:=mem[segm:adr_cursor] and 240+tastanum;
ast:=3;
end;
if (getasynckeystate(vk_right)<0) or (tastanum<16) then
begin
nibble_cursor:=nibble_cursor+1;
if nibble_cursor>1 then
begin
nibble_cursor:=0;
adr_cursor:=adr_cursor+1;
end;
miscat:=1;
end;
if (getasynckeystate(vk_left)<0) then
begin
nibble_cursor:=nibble_cursor-1;
if nibble_cursor<0 then
begin
nibble_cursor:=1;
adr_cursor:=adr_cursor-1;
end;
miscat:=1;
end;
if (getasynckeystate(vk_up)<0) then
begin
adr_cursor:=adr_cursor-16;
miscat:=1;
end;
if (getasynckeystate(vk_down)<0) then
begin
adr_cursor:=adr_cursor+16;
miscat:=1;
end;
if (getasynckeystate(vk_tab)<0) then
begin
if fer_cursor=viewer1 then begin if lung2>0 then fer_cursor:=viewer2; end
                    else begin if lung1>0 then fer_cursor:=viewer1; end;
miscat:=2;
end;
if (adr_cursor<0) then begin adr_cursor:=0; nibble_cursor:=0; end;
if (adr_cursor>lim) then begin adr_cursor:=lim; nibble_cursor:=1; end;
if (miscat>0) or (n>0) then
begin
n:=0;
if adr_cursor<adr_min then
begin
m:=Getscrollpos(getdlgitem(fer_cursor,600),sb_ctl);
m:=m-1;
Setscrollpos(getdlgitem(fer_cursor,600),sb_ctl,m,true);
m:=Getscrollpos(getdlgitem(fer_cursor,600),sb_ctl);
if scr_sinc=false then
begin
if fer_cursor=viewer1 then poz1:=m;
if fer_cursor=viewer2 then poz2:=m;
invalidaterect(getdlgitem(fer_cursor,500),nil,false);
end
else
begin
poz1:=m;
poz2:=m;
Setscrollpos(getdlgitem(viewer1,600),sb_ctl,m,true);
Setscrollpos(getdlgitem(viewer2,600),sb_ctl,m,true);
invalidaterect(getdlgitem(viewer1,500),nil,false);
invalidaterect(getdlgitem(viewer2,500),nil,false);
end;
n:=1;
end;
if (adr_cursor>(adr_max-1)) then
begin
m:=Getscrollpos(getdlgitem(fer_cursor,600),sb_ctl);
m:=m+1;
Setscrollpos(getdlgitem(fer_cursor,600),sb_ctl,m,true);
m:=Getscrollpos(getdlgitem(fer_cursor,600),sb_ctl);
if scr_sinc=false then
begin
if fer_cursor=viewer1 then poz1:=m;
if fer_cursor=viewer2 then poz2:=m;
invalidaterect(getdlgitem(fer_cursor,500),nil,false);
end
else
begin
poz1:=m;
poz2:=m;
Setscrollpos(getdlgitem(viewer1,600),sb_ctl,m,true);
Setscrollpos(getdlgitem(viewer2,600),sb_ctl,m,true);
invalidaterect(getdlgitem(viewer1,500),nil,false);
invalidaterect(getdlgitem(viewer2,500),nil,false);
end;
n:=1;
end;
end;
if tastanum<16 then miscat:=2;
if miscat=1 then
begin
invalidaterect(getdlgitem(fer_cursor,500),nil,false);
updatewindow(getdlgitem(fer_cursor,500));
end;
if miscat=2 then
begin
invalidaterect(getdlgitem(viewer1,500),nil,false);
updatewindow(getdlgitem(viewer1,500));
invalidaterect(getdlgitem(viewer2,500),nil,false);
updatewindow(getdlgitem(viewer2,500));
end;
end;
if intro=1 then
begin
intro:=0;
viewer1:=createdialog(hinstance,'COPIL_V20',hwindow,proc1);
viewer2:=createdialog(hinstance,'COPIL_V20',hwindow,proc1);
fer_cursor:=viewer1;
postmessage(viewer1,wm_user1,0,0);
postmessage(viewer2,wm_user1,0,0);
desparte;
end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tdropper.SetUpWindow;
var tempc1,tempc2:array[0..100] of char;
begin
win:=hwindow;
starebloc:=0;
ferbloc:=viewer1;
stbloc:=65535;
sfbloc:=65535;
n:=0;
termina:=false;
settimer(hwindow,1,1,nil);
proc1 := MakeProcInstance(@DIALOG_PRINC, HInstance);
proc2 := MakeProcInstance(@DIALOG_FISNOU, HInstance);
proc3 := MakeProcInstance(@DIALOG_DESPRE, HInstance);
intro:=1;
aratadif:=true;
bitfont:=loadbitmap(hinstance,'FONTFIX');
bloc1:=memallocseg(65520);
bloc2:=memallocseg(65520);
scr_sinc:=true;
poz1:=0;
poz2:=0;
poz1h:=0;
poz2h:=0;
lung1:=0;
lung2:=0;
strcopy(numefis1,'Nici un fisier încãrcat.');
strcopy(numefis2,'Nici un fisier încãrcat.');
despar:=1;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tdropper.Wmsize;
begin
desparte;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tdropper.Desparte;
var tr:trect;
    hsize,vsize:word;
begin
getwindowrect(hwindow,tr);
hsize:=tr.right-tr.left-8;
vsize:=tr.bottom-tr.top-getsystemmetrics(sm_cymenu)-getsystemmetrics(sm_cycaption)-8;
if despar=1 then
begin
movewindow(viewer1,0,0,hsize div 2,vsize,true);
movewindow(viewer2,hsize div 2+1,0,hsize div 2,vsize,true);
end
else
begin
movewindow(viewer1,0,0,hsize,vsize div 2,true);
movewindow(viewer2,0,vsize div 2+1,hsize,vsize div 2,true);
end;
end;
{-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - }
procedure Tdropper.WMDestroy(var Message: TMessage);
var i,j:longint;
begin
deleteobject(bitfont);
if iswindow(viewer1) then destroywindow(viewer1);
if iswindow(viewer2) then destroywindow(viewer2);
freemem(bloc1,65520);
freemem(bloc2,65520);
  FreeProcInstance(proc1);
  FreeProcInstance(proc2);
  FreeProcInstance(proc3);
  TWindow.WMDestroy(Message);
end;
{--------------- TApp ------------------------}

procedure TApp.InitMainWindow;
begin
  MainWindow := New(Pdropper, Init(nil, 'V.E.C.H. 2.0'));
end;

{-------------Main Program--------------------}

var
  App: TApp;
begin
  App.Init('V.E.C.H. 2.0');
  App.Run;
  App.Done;
end.
