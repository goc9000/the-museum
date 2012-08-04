REM com1=760,com2=1016
tapend = 1
blok = 0
lim = 170
asp = .44
tptick = 2
tape.pos = 1
tape.play = 0
tape.stop = 1
tape.rew = 0
tape.ff = 0
tape.rec = 0
DIM cass(1000)
FOR r = 1 TO 1000
cass(r) = 999
NEXT r
connchar = 4
REM 207/209
bco = 1
REM 191,218,196,193
KEY(1) ON
ON KEY(1) GOSUB help
SCREEN 8
REM COLOR 9, bco
COLOR 9
PALETTE 1, 0
PALETTE 0, 1
DIM g(30)
d = 0
rreset:
LOCATE 1, 1
PRINT CHR$(201); STRING$(74, 205); CHR$(209); STRING$(3, 205); CHR$(187)
FOR i = 2 TO 20
LOCATE i, 1
PRINT CHR$(186); STRING$(74, 32); CHR$(179); STRING$(3, 32); CHR$(186)
NEXT i
hread = 1
d1 = 0
d2 = 0
d3 = 0
d4 = 0
d5 = 0
d6 = 0
d7 = 0
d8 = 0
REM chr$(24),chr$(25)
COLOR 9
state = 1
waity = 30
pall = 30
GOSUB closepal
tape = 0
1
IF gyro = 1 THEN PALETTE 6, 15
IF gyro = 2 THEN PALETTE 6, 11
IF gyro = 3 THEN PALETTE 6, 3
IF gyro = 4 THEN PALETTE 6, 11
IF pall > 0 THEN pall = pall - 1
IF pall = 1 THEN GOSUB openpal
IF waity > 0 THEN pstat = 0
waity = waity - 1
IF waity < 0 THEN waity = 0
gyro = gyro + 1
IF gyro > 3 THEN gyro = 0
IF pstat = 0 AND gyro = 0 THEN ps$ = "      "
IF pstat = 0 AND gyro = 1 THEN ps$ = "      "
IF pstat = 0 AND gyro = 2 THEN ps$ = "(WAIT)"
IF pstat = 0 AND gyro = 3 THEN ps$ = "(WAIT)"
IF pstat = 1 THEN ps$ = "STEADY"
IF pstat = 2 THEN ps$ = "ACTIVE"
IF state = 1 AND tape = 0 THEN u$ = "   MONITOR: PORT IS " + ps$ + "   "
tap$ = "         "
IF INT(gyro / 2) = 1 AND tape.play = 1 THEN tap$ = " PLAYING "
IF tape.stop = 1 THEN tap$ = " STOPPED "
IF INT(gyro / 2) = gyro / 2 AND tape.rew = 1 THEN tap$ = "REWINDING"
IF INT(gyro / 2) = gyro / 2 AND tape.ff = 1 THEN tap$ = "F-FORWARD"
IF INT(gyro / 2) = 1 AND tape.rec = 1 THEN tap$ = "RECORDING"
IF state = 1 AND tape = 1 THEN u$ = "       TAPE: " + tap$ + "       "
cc = INP(d)
GOSUB recor
GOSUB chn: GOSUB bdr
KEY(1) OFF
LOCATE 21, 1
PRINT CHR$(204); STRING$(9, 205); CHR$(209); STRING$(29, 205); CHR$(209); STRING$(8, 205); CHR$(209); STRING$(8, 205); CHR$(209); STRING$(16, 205); CHR$(207); STRING$(3, 205); CHR$(185)
PRINT CHR$(186);
COLOR 10
PRINT "PRT#";
COLOR 11
PRINT USING "#####"; d;
COLOR 9
PRINT CHR$(179);
COLOR 10
PRINT u$;
COLOR 9
PRINT CHR$(179);
COLOR 4
GOSUB binrt
COLOR 9
PRINT CHR$(179);
GOSUB chnt
COLOR 9
PRINT CHR$(179);
COLOR 10
PRINT "  PUSH F1 FOR HELP  ";
COLOR 9
PRINT CHR$(186)
PRINT CHR$(200); STRING$(9, 205); CHR$(207); STRING$(29, 205); CHR$(207); STRING$(8, 205); CHR$(207); STRING$(8, 205); CHR$(207); STRING$(20, 205); CHR$(188)
KEY(1) ON
torg = 19
FOR g = 2 TO 20
ix = ((torg) * 8)
torg = torg - 1
REM iy = 10 + (g(g) * 2)
iy = INT(10 + (g(g) * 1.8))
maxiy = INT(10 + (256 * 1.8))
endl = 0
IF (tape.pos - 18) + torg = tapend + 3 THEN endl = 1
IF blok = 1 OR g(g) > 255 THEN iy = maxiy - 3: nul = 1
nmc = 5
hlc = 13
shc = 1
IF torg = 18 THEN hlc = 15: nmc = 13: shc = 5
IF g(g) > 255 THEN hlc = 0: nmc = 0: shc = 0
IF endl = 1 THEN hlc = 1: nmc = 6: shc = 9
IF blok = 1 THEN hlc = 1: nmc = 0: shc = 9
LINE (10, ix + 1)-(iy - 1, ix + 6), nmc, BF
LINE (8, ix + 1)-(9, ix + 6), hlc, B
LINE (8, ix)-(iy - 1, ix), hlc
LINE (9, ix + 7)-(iy + 1, ix + 7), shc
LINE (iy, ix + 1)-(iy + 1, ix + 7), shc, B
nodr:
LINE (iy + 2, ix)-(maxiy + 3, ix + 7), 0, BF
COLOR 11
LOCATE torg + 2, 77
IF bcdmode = 0 THEN IF g(g) <> 999 AND blok = 0 AND pall = 0 THEN PRINT USING "###"; g(g)
p1 = g(g) AND 15
p2 = (g(g) AND 240) / 16
IF p2 = 0 THEN pz$ = "0"
IF p2 = 1 THEN pz$ = "1"
IF p2 = 2 THEN pz$ = "2"
IF p2 = 3 THEN pz$ = "3"
IF p2 = 4 THEN pz$ = "4"
IF p2 = 5 THEN pz$ = "5"
IF p2 = 6 THEN pz$ = "6"
IF p2 = 7 THEN pz$ = "7"
IF p2 = 8 THEN pz$ = "8"
IF p2 = 9 THEN pz$ = "9"
IF p2 = 10 THEN pz$ = "A"
IF p2 = 11 THEN pz$ = "B"
IF p2 = 12 THEN pz$ = "C"
IF p2 = 13 THEN pz$ = "D"
IF p2 = 14 THEN pz$ = "E"
IF p2 = 15 THEN pz$ = "F"
IF p1 = 0 THEN pu$ = "0"
IF p1 = 1 THEN pu$ = "1"
IF p1 = 2 THEN pu$ = "2"
IF p1 = 3 THEN pu$ = "3"
IF p1 = 4 THEN pu$ = "4"
IF p1 = 5 THEN pu$ = "5"
IF p1 = 6 THEN pu$ = "6"
IF p1 = 7 THEN pu$ = "7"
IF p1 = 8 THEN pu$ = "8"
IF p1 = 9 THEN pu$ = "9"
IF p1 = 10 THEN pu$ = "A"
IF p1 = 11 THEN pu$ = "B"
IF p1 = 12 THEN pu$ = "C"
IF p1 = 13 THEN pu$ = "D"
IF p1 = 14 THEN pu$ = "E"
IF p1 = 15 THEN pu$ = "F"
IF bcdmode = 1 THEN IF g(g) <> 999 AND blok = 0 AND pall = 0 THEN PRINT " "; pz$; pu$
IF blok = 1 AND pall = 0 THEN PRINT "   "
kes$ = "   "
IF (tape.pos - 18) + torg = tapend + 3 THEN kes$ = "END"
IF g(g) = 999 AND blok = 0 AND pall = 0 THEN PRINT kes$
COLOR 9
NEXT g
IF del = 1 THEN cc = cc AND 3
g(1) = cc
FOR i = 30 TO 2 STEP -1
g(i) = g(i - 1)
NEXT i
pstat = 1
FOR i = 30 TO 2 STEP -1
IF g(i) <> g(i - 1) THEN pstat = 2
NEXT i
v$ = INKEY$
IF v$ = "~" THEN GOSUB sfx1: bcdmode = 1 - bcdmode
IF v$ = "!" THEN GOSUB sfx1: d1 = 0 + 1 - d1: waity = 30
IF v$ = "@" THEN GOSUB sfx1: d2 = 0 + 1 - d2: waity = 30
IF v$ = "#" THEN GOSUB sfx1: d3 = 0 + 1 - d3: waity = 30
IF v$ = "$" THEN GOSUB sfx1: d4 = 0 + 1 - d4: waity = 30
IF v$ = "%" THEN GOSUB sfx1: d5 = 0 + 1 - d5: waity = 30
IF v$ = "^" THEN GOSUB sfx1: d6 = 0 + 1 - d6: waity = 30
IF v$ = "&" THEN GOSUB sfx1: d7 = 0 + 1 - d7: waity = 30
IF v$ = "*" THEN GOSUB sfx1: d8 = 0 + 1 - d8: waity = 30
IF v$ = "1" THEN d = d - 30: waity = 30
IF v$ = "q" THEN d = d - 1: waity = 30
IF v$ = "a" THEN d = d + 1: waity = 30
IF v$ = "z" THEN d = d + 30: waity = 30
IF v$ = "f" THEN PLAY "mbl64cdefedcdefedcdefed"
IF tape = 0 AND v$ = "o" THEN GOSUB sfx1: GOSUB outto
IF v$ = "r" AND tape = 0 THEN GOSUB sfx1: blok = 1: tape = 1: v$ = ""
IF v$ = "r" AND tape = 1 THEN GOSUB sfx1: blok = 0: tape = 0
IF v$ = "S" THEN CLS : GOTO safemode
IF tape = 0 AND v$ = "p" THEN GOSUB sfx1: GOSUB aktiv
IF tape = 0 AND v$ = "g" THEN GOSUB sfx1: waity = 30: GOSUB gotop
IF v$ = CHR$(27) THEN GOSUB sfx1: CLS : SYSTEM
IF d > 65535 THEN d = d - 65536
IF d < 0 THEN d = d + 65536
GOTO 1
bdr:
binr$ = STRING$(8, 249)
IF blok = 1 THEN RETURN
bd = cc
nd = INT(bd / 2): dif = bd - (2 * nd): IF dif = 1 THEN MID$(binr$, 8, 1) = CHR$(254):
bd = nd
nd = INT(bd / 2): dif = bd - (2 * nd): IF dif = 1 THEN MID$(binr$, 7, 1) = CHR$(254):
bd = nd
nd = INT(bd / 2): dif = bd - (2 * nd): IF dif = 1 THEN MID$(binr$, 6, 1) = CHR$(254):
bd = nd
nd = INT(bd / 2): dif = bd - (2 * nd): IF dif = 1 THEN MID$(binr$, 5, 1) = CHR$(254):
bd = nd
nd = INT(bd / 2): dif = bd - (2 * nd): IF dif = 1 THEN MID$(binr$, 4, 1) = CHR$(254):
bd = nd
nd = INT(bd / 2): dif = bd - (2 * nd): IF dif = 1 THEN MID$(binr$, 3, 1) = CHR$(254):
bd = nd
nd = INT(bd / 2): dif = bd - (2 * nd): IF dif = 1 THEN MID$(binr$, 2, 1) = CHR$(254):
bd = nd
nd = INT(bd / 2): dif = bd - (2 * nd): IF dif = 1 THEN MID$(binr$, 1, 1) = CHR$(254):
bd = nd
RETURN
chn:
chn$ = STRING$(8, 2)
IF d1 = 1 THEN MID$(chn$, 8, 1) = CHR$(1)
IF d2 = 1 THEN MID$(chn$, 7, 1) = CHR$(1)
IF d3 = 1 THEN MID$(chn$, 6, 1) = CHR$(1)
IF d4 = 1 THEN MID$(chn$, 5, 1) = CHR$(1)
IF d5 = 1 THEN MID$(chn$, 4, 1) = CHR$(1)
IF d6 = 1 THEN MID$(chn$, 3, 1) = CHR$(1)
IF d7 = 1 THEN MID$(chn$, 2, 1) = CHR$(1)
IF d8 = 1 THEN MID$(chn$, 1, 1) = CHR$(1)
IF tape = 1 THEN RETURN
IF d1 = 1 THEN cc = cc AND 254
IF d2 = 1 THEN cc = cc AND 253
IF d3 = 1 THEN cc = cc AND 251
IF d4 = 1 THEN cc = cc AND 247
IF d5 = 1 THEN cc = cc AND 239
IF d6 = 1 THEN cc = cc AND 223
IF d7 = 1 THEN cc = cc AND 191
IF d8 = 1 THEN cc = cc AND 127
RETURN
help:
IF tape = 1 THEN RETURN
GOSUB sfx1
FOR t = 2 TO 15
IF t <> 9 THEN PALETTE t, bco
NEXT t
FOR r = 2 TO 20
LOCATE r, 2
PRINT STRING$(70, 32)
LOCATE r, 77
PRINT "   "
NEXT r
COLOR 10
LOCATE 22, 14
PRINT "   USER ASKED FOR HELP   "
LOCATE 22, 60
PRINT " PUSH ENTER TO EXIT "
COLOR 11
LOCATE 3, 27
PRINT "          Ú";
COLOR 10
PRINT "KEYS";
COLOR 11
PRINT "¿"
LOCATE 4, 27
PRINT "ÉÍÍÍÍÍÍÍÍÍÏÍÍÍÍÏÍÍÍÍÍÍÍÍÍ»"
FOR k = 5 TO 14
LOCATE k, 27
PRINT "º                        º"
NEXT k
LOCATE 15, 27
PRINT "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
COLOR 10
LOCATE 5, 29
PRINT "Q........UP 1 PORT (-)"
LOCATE 6, 29
PRINT "A......DOWN 1 PORT (+)"
LOCATE 7, 29
PRINT "1......UP 30 PORTS (-)"
LOCATE 8, 29
PRINT "Z....DOWN 30 PORTS (+)"
LOCATE 9, 29
PRINT "SHFT+1..8 TOGGLES BITS"
LOCATE 10, 29
PRINT "G..GO TO PORT NR.#####"
LOCATE 11, 29
PRINT "P.....ACTIVE PORT SCAN"
LOCATE 12, 29
PRINT "F...SOUND FROM SPEAKER"
LOCATE 13, 29
PRINT "O.......OUTPUT TO PORT"
LOCATE 14, 29
PRINT "ESC.....EXITS READPORT"
LOCATE 18, 2
PRINT "   PORT               SYSTEM             BINARY    BITS    HELP"
LOCATE 19, 2
PRINT "  NUMBER             MESSAGES             READ     READ   MESSAGE"
COLOR 11
LOCATE 20, 2
PRINT " ÚÄÄÁÄÄÄ¿ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ ÚÄÄÁÄÄÄ¿ ÚÄÄÁÄÄÄ¿ ÚÄÄÁÄÄÄÄÄÄÄÄ¿"
FOR t = 2 TO 15
PALETTE t, t
NEXT t
COLOR 9
tyu:
IF INKEY$ <> CHR$(13) THEN GOTO tyu
FOR t = 2 TO 15
IF t <> 9 THEN PALETTE t, bco
NEXT t
FOR r = 2 TO 20
LOCATE r, 2
PRINT "                                                                        "
LOCATE r, 77
PRINT "   "
NEXT r
LOCATE 22, 14
PRINT "                          "
LOCATE 22, 60
PRINT "                    "
FOR t = 2 TO 15
PALETTE t, t
NEXT t
GOSUB closepal
pall = 10
GOSUB sfx1
RETURN
outto:
COLOR 10
LOCATE 22, 14
n$ = ""
PRINT "INPUT PORT NUMBER: úúúúú ";
t = 5
2
re:
B$ = INKEY$
IF B$ >= "0" AND B$ <= "9" THEN n$ = n$ + B$: GOSUB sfx1: GOTO rd
IF B$ = CHR$(8) THEN bksp = 1: GOSUB sfx2: GOTO rd
IF B$ = CHR$(13) THEN GOTO ende
GOTO re
rdd2:
LOCATE 22, 33
IF LEN(n$) > 5 OR bksp = 1 THEN GOSUB eras
bksp = 0
PRINT n$ + STRING$(5 - LEN(n$), 250)
GOTO reyu
rd:
LOCATE 22, 33
IF LEN(n$) > 5 OR bksp = 1 THEN GOSUB eras
bksp = 0
PRINT n$ + STRING$(5 - LEN(n$), 250)
GOTO 2
ende:
outport = VAL(n$)
LOCATE 22, 14
n$ = ""
PRINT "INPUT PORT VALUE:   úúú  ";
t = 5
3
re2:
B$ = INKEY$
IF B$ >= "0" AND B$ <= "9" THEN n$ = n$ + B$: GOSUB sfx1: GOTO rd2
IF B$ = CHR$(8) THEN GOSUB sfx2: bksp = 1: GOTO rd2
IF B$ = CHR$(13) THEN GOTO ende2
GOTO re2
rd2:
LOCATE 22, 34
IF LEN(n$) > 3 OR bksp = 1 THEN GOSUB eras
bksp = 0
PRINT n$ + STRING$(3 - LEN(n$), 250)
GOTO 3
ende2:
outval = VAL(n$)
ok = 1
COLOR 12
IF outport > 65535 THEN LOCATE 22, 13: PRINT "PORT MUST BE LESS THAN 65536": GOSUB sfx2: SLEEP 1: ok = 0
IF outval > 255 THEN LOCATE 22, 13: PRINT "VALUE MUST BE LESS THAN 256 ": GOSUB sfx2: SLEEP 1: ok = 0
LOCATE 22, 13
IF ok = 0 THEN COLOR 12: GOSUB sfx2: PRINT "      OPERATION FAILED      "
IF ok = 1 THEN COLOR 10: GOSUB sfx1: PRINT "      OPERATION SUCESS      "
IF ok = 1 THEN OUT outport, outval
SLEEP 1
COLOR 9
GOSUB sfx1
RETURN
eras:
IF n$ = "" THEN RETURN
h = LEN(n$)
n$ = MID$(n$, 1, h - 1)
GOSUB sfx1
RETURN
chnt:
FOR n = 1 TO 8
IF MID$(chn$, n, 1) = CHR$(2) THEN COLOR 10: PRINT CHR$(251);
IF MID$(chn$, n, 1) = CHR$(1) THEN COLOR 12: PRINT "x";
NEXT n
RETURN
closepal:
PALETTE 1, bco
PALETTE 5, bco
PALETTE 13, bco
PALETTE 15, bco
RETURN
openpal:
PALETTE 1, 0
PALETTE 5, 5
PALETTE 13, 13
PALETTE 15, 15
RETURN
gotop:
COLOR 10
LOCATE 22, 14
n$ = ""
PRINT "INPUT PORT NUMBER: úúúúú ";
t = 5
reyu:
B$ = INKEY$
IF B$ >= "0" AND B$ <= "9" THEN n$ = n$ + B$: GOSUB sfx1: GOTO rdd2
IF B$ = CHR$(8) THEN bksp = 1: GOSUB sfx2: GOTO rdd2
IF B$ = CHR$(13) THEN GOTO uiuo
GOTO reyu
uiuo:
goport = VAL(n$)
ok = 1
COLOR 12
IF goport > 65535 THEN LOCATE 22, 13: PRINT "PORT MUST BE LESS THAN 65536": GOSUB sfx2: SLEEP 1: ok = 0
IF ok = 1 THEN d = goport
COLOR 9
RETURN
aktiv:
KEY(1) OFF
GOSUB closepal
FOR r = 2 TO 20
LOCATE r, 2
PRINT STRING$(70, 32)
LOCATE r, 77
PRINT "   "
NEXT r

GOSUB chart
COLOR 10
LOCATE 2, 2
PRINT " ACTIVE PORTS FOUND "
LOCATE 22, 13
PRINT "    INPUT SENSITIVITY: ?    "
LOCATE 22, 60              '
PRINT " A=LOWùùùùùùùZ=HIGH "
tiriop:
v$ = UCASE$(INKEY$)
IF v$ = "" THEN GOTO tiriop
IF ASC(v$) < 65 OR ASC(v$) > 90 THEN GOTO tiriop
GOSUB sfx1
value = (ASC(v$) - 65)
sens = 1 + (value * 4)
REM sens = 1 + (value * 10)
LOCATE 22, 13
COLOR 10                          '
PRINT "TIME 0: 0: 0 OUT OF ?:??:??"
LOCATE 22, 60              '
PRINT "  PUSH KEY TO STOP  "
LOCATE 2, 2
PRINT " ACTIVE PORTS FOUND "
lok = 4
tb = 0
x = 171
y = 8
uy = TIMER
FOR k = 0 TO 65535
active = 0
GOSUB determine
IF active = 1 THEN COLOR 15: LOCATE lok, 3 + tb * 6: PRINT USING "#####"; k; : COLOR 10: lok = lok + 1: IF lok > 18 THEN lok = 4: tb = tb + 1: IF tb > 2 THEN k = 65535
LOCATE 20, 2
PRINT "PROGRESS: ";
COLOR 11
PRINT USING "#####"; k;
COLOR 10
PRINT " OF ";
COLOR 11
PRINT "65535";
COLOR 10
PRINT " PORTS SEARCHED; ";
COLOR 11
PRINT USING "##"; lok;
COLOR 10
PRINT " ACTIVE PORTS FOUND; ";
IF active = 0 AND titr = 0 THEN COLOR 4: PRINT " ZERO "; : PSET (x, y), 4
IF active = 0 AND titr = 255 THEN COLOR 12: PRINT " DEAD "; : PSET (x, y), 12
IF active = 0 AND titr <> 0 AND titr <> 255 THEN COLOR 14: PRINT " JAMM "; : PSET (x, y), 14
IF active = 1 THEN COLOR 10: PRINT " LIVE "; : PSET (x, y), 15
IF INT(tik) = 1 THEN PALETTE 15, 2
IF INT(tik) = 2 THEN PALETTE 15, 10
IF INT(tik) = 3 THEN PALETTE 15, 15
IF INT(tik) = 4 THEN PALETTE 15, 10
tik = tik + .2
IF INT(tik) > 4 THEN tik = 1
x = x + 1
IF x > 598 THEN x = 171: y = y + 1
IF y > 149 THEN y = 149
COLOR 11
PRINT USING "###"; titr
COLOR 10
IF onyx = 0 AND FIX(TIMER - uy) = 3 THEN speed = 3 / k: onyx = 1: GOSUB kalk
v$ = INKEY$
IF v$ <> "" THEN k = 65534
LOCATE 22, 13
COLOR 10
GOSUB kalk
PRINT "TIME "; USING "#:"; hrp; : PRINT USING "##:"; mnp; : PRINT USING "##"; scp;
IF onyx = 1 THEN PRINT " OUT OF "; USING "#:"; hr; : PRINT USING "##:"; mn; : PRINT USING "##"; sc;
NEXT k
GOSUB sfx3
LOCATE 22, 13
COLOR 10                          '
PRINT " SCANNER: SEARCH COMPLETED "
LOCATE 22, 60
PRINT "  PUSH KEY TO EXIT  "
WHILE INKEY$ = ""
IF INT(tik) = 1 THEN PALETTE 15, 2
IF INT(tik) = 2 THEN PALETTE 15, 10
IF INT(tik) = 3 THEN PALETTE 15, 15
IF INT(tik) = 4 THEN PALETTE 15, 10
tik = tik + .2
IF INT(tik) > 4 THEN tik = 1
WEND
onyx = 0
COLOR 9
pall = 30
GOSUB closepal
KEY(1) ON
LOCATE 20, 2
PRINT STRING$(74, 32)
LINE (169, 7)-(600, 150), 0, BF
GOSUB sfx1
RETURN
determine:
f = INP(k)
FOR n = 1 TO sens
IF INP(k) <> f THEN active = 1
FOR bg = 1 TO sens
NEXT bg
NEXT n
titr = INP(k)
RETURN
chart:
PALETTE 1, 0
LINE (169, 7)-(600, 150), 0, BF
LINE (169, 7)-(170, 149), 1, B
LINE (169, 7)-(598, 7), 1
LINE (599, 8)-(600, 150), 9, B
LINE (171, 150)-(600, 150), 9
RETURN
                
kalk:
secs = INT(speed * 65535)
hr = INT(secs / 3600)
min = INT((secs) - (hr * 3600))
mn = INT(((secs) - (hr * 3600)) / 60)
sc = INT(min - (mn * 60))

secsp = FIX(TIMER - uy)
hrp = INT(secsp / 3600)
minp = INT((secsp) - (hrp * 3600))
mnp = INT(((secsp) - (hrp * 3600)) / 60)
scp = INT(minp - (mnp * 60))
RETURN
binrt:
FOR n = 1 TO 8
IF MID$(binr$, n, 1) = CHR$(254) THEN COLOR 12: PRINT CHR$(254);
IF MID$(binr$, n, 1) = CHR$(249) THEN COLOR 4: PRINT CHR$(254);
NEXT n
RETURN
sfx1:
FOR yuu = 2000 TO 6000 STEP 200
SOUND yuu, .03
NEXT yuu
RETURN
sfx2:
FOR yuu = 1000 TO 5000 STEP 200
SOUND yuu, .03
NEXT yuu
RETURN
sfx3:
FOR yuu = 1 TO 200
SOUND 2000, .03
SOUND 2000 - ((yuu MOD 6) * 100), .03
SOUND 2000 + ((yuu MOD 6) * 100), .03
NEXT yuu
RETURN
recor:
IF tape = 0 THEN FOR jk = 2 TO 9: LOCATE jk, 66: PRINT STRING$(9, 32): NEXT jk: RETURN
COLOR 1
LOCATE 2, 66
PRINT CHR$(218); STRING$(7, 196); CHR$(191)
LOCATE 3, 66
PRINT CHR$(179)
LOCATE 3, 74
PRINT CHR$(179)
LOCATE 4, 66
PRINT CHR$(179); "ÚÄÄÄÄÄ¿"; CHR$(179)
LOCATE 5, 66
PRINT CHR$(192); "ÁÄÄÄÄÄÁ"; CHR$(217)
COLOR 9
LOCATE 7, 66
PRINT CHR$(218); STRING$(7, 196); CHR$(191)
LOCATE 8, 66
PRINT CHR$(179)
LOCATE 8, 74
PRINT CHR$(179)
LOCATE 9, 66
PRINT CHR$(192); STRING$(7, 196); CHR$(217)
COLOR 11
LOCATE 8, 69
PRINT USING "###"; tape.pos
LOCATE 3, 68
COLOR 14
dr$ = "ta" + STR$(tptick) + "l5r10"
IF running = 0 THEN GOTO nodel
PSET (542, 19), 0
DRAW dr$
PSET (568, 19), 0
DRAW dr$
nodel:
CIRCLE (542, 19), 7, , , , asp
CIRCLE (568, 19), 7, , , , asp
tptick = tptick + running
fullr = 0
IF INT(tptick) > (lim - 1) THEN tptick = tptick - lim: fullr = 1
IF INT(tptick) < 0 THEN tptick = tpick + lim: fullr = 1
dr$ = "ta" + STR$(tptick) + "l5r10"
PSET (542, 19), 14
DRAW dr$
PSET (568, 19), 14
DRAW dr$
LOCATE 6, 66
COLOR 2
IF tape.play = 1 THEN COLOR 10
PRINT CHR$(16); " ";
COLOR 4
IF tape.stop = 1 THEN COLOR 12
PRINT CHR$(254); " ";
COLOR 3
IF tape.rew = 1 OR revy > 0 THEN COLOR 11
PRINT CHR$(174); " ";
COLOR 3
IF tape.ff = 1 OR ffpushed = 1 THEN COLOR 11
ffpushed = 0
PRINT CHR$(175); " ";
COLOR 4
IF tape.rec = 1 AND gyro = 1 THEN COLOR 12
IF tape.rec = 1 AND gyro = 2 THEN COLOR 12
PRINT "R"
COLOR 9
IF tape.stop = 1 THEN running = 0: blok = 1
IF tape.rec = 1 THEN running = -30: tape.pos = tape.pos + 1: cass(tape.pos) = cc: blok = 0: IF tape.pos > tapend THEN tapend = tape.pos
IF tape.play = 1 THEN running = -30: tape.pos = tape.pos + 1: cc = cass(tape.pos): blok = 0: IF tape.pos > (tapend + 32) THEN tape.pos = tape.pos - 1: v$ = " "
IF tape.rew = 1 THEN running = 60: tape.pos = tape.pos - 10: blok = 1
IF tape.ff = 1 THEN running = -60: tape.pos = tape.pos + 10: blok = 1
IF tape.pos > 999 THEN tape.pos = 999: v$ = " "
IF tape.pos < 1 THEN tape.pos = 1: v$ = " "
IF v$ = CHR$(13) AND tape.play = 0 THEN GOSUB sfx1: tape.play = 1: tape.stop = 0: tape.rew = 0: tape.ff = 0: tape.rec = 0: cc = 999: GOSUB clrs
IF v$ = " " THEN GOSUB sfx2: tape.play = 0: tape.stop = 1: tape.rew = 0: tape.ff = 0: tape.rec = 0: : GOSUB clrs
IF v$ = "<" AND tape.stop = 1 THEN GOSUB sfx1: tape.play = 0: tape.stop = 0: tape.rew = 1: tape.ff = 0: tape.rec = 0: GOSUB clrs
IF v$ = ">" AND tape.stop = 1 THEN GOSUB sfx1: tape.play = 0: tape.stop = 0: tape.rew = 0: tape.ff = 1: tape.rec = 0: GOSUB clrs
IF v$ = "<" AND tape.play = 1 THEN revy = 5
IF v$ = ">" AND tape.play = 1 THEN ffy = 10
IF revy > 0 THEN tape.play = 1: tape.stop = 0: tape.rew = 0: tape.ff = 0: tape.rec = 0: running = 45: tape.pos = tape.pos - 5: revy = revy - 1
IF ffy > 0 THEN tape.play = 1: tape.stop = 0: tape.rew = 0: tape.ff = 0: tape.rec = 0: running = 90: tape.pos = tape.pos + 11: ffy = fyy - 1: ffpushed = 1
IF tape.pos > 999 THEN tape.pos = 999
IF tape.pos < 1 THEN tape.pos = 1
IF v$ = "+" THEN GOSUB sfx1: tape.play = 0: tape.stop = 0: tape.rew = 0: tape.ff = 0: tape.rec = 1: GOSUB clrs
IF v$ = CHR$(8) THEN GOSUB sfx2: tape.play = 0: tape.stop = 1: tape.rew = 0: tape.ff = 0: tape.rec = 0: tape.pos = 0: FOR lk = 0 TO 1000: cass(lk) = 999: NEXT lk: GOSUB clrs
IF running = 0 THEN FOR t = 1 TO 230: NEXT t
IF running = -30 AND fullr = 0 THEN FOR t = 1 TO 230: NEXT t
IF running = -30 AND fullr = 1 THEN SOUND 9000, .023
IF running <> 0 AND running <> -30 THEN SOUND 2000 + tptick, .023
RETURN
clrs:
FOR ui = 0 TO 30
g(ui) = 999
NEXT ui
RETURN
safemode:
LOCATE 1, 35
COLOR 11
PRINT "SAFE  MODE"
ch = 1
gogu:
LOCATE 3, 1
COLOR 11
PRINT "Are you really sure you want to go in the safe mode? ";
COLOR 9
IF ch = 1 THEN COLOR 11
IF ch = 1 AND gyro < 5 THEN COLOR 0
PRINT "Yes ";
COLOR 11
PRINT "or ";
COLOR 9
IF ch = 2 THEN COLOR 11
IF ch = 2 AND gyro < 5 THEN COLOR 0
PRINT "No";
gyro = gyro + 1
IF gyro > 8 THEN gyro = 1
v$ = INKEY$
IF v$ = "n" THEN ch = 2
IF v$ = "y" THEN ch = 1
IF v$ = " " THEN ch = 3 - ch
IF v$ = CHR$(13) AND ch = 2 THEN CLS : COLOR 9: GOTO rreset
IF v$ = CHR$(13) AND ch = 1 THEN GOTO forgn
FOR g = 1 TO 1000
NEXT g
GOTO gogu
forgn:
LOCATE 3, 1
COLOR 11
PRINT " The safe mode will allow you to monitor 'rapid' changes in your ports as well"
PRINT "as monitoring correctly the video card by not drawing anything on the screen."
PRINT " During the safe mode, the screen will be black, and you won't be able to stop"
PRINT "the search. The changes will be written to tape and you can see them after the"
PRINT "search has ended. Press any key to continue."
SLEEP 0
CLS
t$ = INKEY$
COLOR 15, 0
PALETTE 15, 15
inik:
INPUT "Monitor which port? (0-65535)", mp
IF mp < 0 OR mp > 65535 THEN PRINT "Out of bounds": GOTO inik
CLS
LOCATE 1, 1
t$ = INKEY$
PRINT "Press a key when ready."
SLEEP 0
PALETTE 15, 7
j = STICK(1)
PALETTE 15, 8
j = STICK(1)
CLS
PALETTE 15, 15
SLEEP 1
FOR i = 1 TO 999
cass(i) = INP(mp)
NEXT i
tapend = 999
LOCATE 1, 1
COLOR 11, 1
PRINT " Done. Activate the tape interface by pressing `R` and see the recording."
SLEEP 0
CLS
COLOR 9
GOTO rreset

