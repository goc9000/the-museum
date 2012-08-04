SCREEN 7
CLS
'$DYNAMIC
KEY OFF
nm = 1
PLAY "MBMNL3O1GL6O2DL10CO1BAO2L3GO1MSL15GGL5G"
COLOR 3
LOCATE 1, 12
PRINT CHR$(201) + STRING$(14, 205) + CHR$(187)
LOCATE 2, 12
PRINT CHR$(186) + "              " + CHR$(186)
LOCATE 3, 12
PRINT CHR$(200) + STRING$(14, 205) + CHR$(188)
WHILE INKEY$ = ""
k$ = "SPACE INVADERS"
LOCATE 5, 1
COLOR 7
PRINT "        C  1997 BY SMARTIESSOFT"
CIRCLE (67, 35), 8, 4
FOR i = 1 TO 14
LOCATE 2, 12 + i
COLOR nm + 6
PRINT MID$(k$, i, 1);
nm = nm + 1
IF nm = 10 THEN nm = 1
NEXT i
FOR Q = 1 TO 1000
NEXT Q
WEND
sc = 0
VIEW
DIM z(64)
DIM p(8, 64)
FOR c = 1 TO 8
RESTORE
FOR i = 1 TO 8
FOR J = 1 TO 8
READ Q
IF Q <> 0 THEN PSET (J + 99, i + 99), Q + c - 1
PSET (102, 102), 15
PSET (105, 102), 15
NEXT J
NEXT i
DATA 0,0,1,1,1,1,0,0
DATA 0,1,1,1,1,1,1,0
DATA 1,1,0,1,1,0,1,1
DATA 1,1,1,1,1,1,1,1
DATA 1,0,1,1,1,1,0,1
DATA 1,0,1,0,0,1,0,1
DATA 1,0,1,0,0,1,0,1
DATA 0,0,1,0,0,1,0,0
GET (100, 100)-(107, 107), z
FOR g = 1 TO 64
p(c, g) = z(g)
NEXT g
NEXT c
x = 100
y = 100
c = 1: s = 8
FOR i = 1 TO 64
z(i) = p(c, i)
NEXT i
CLS
rep = 1
sd = 1
DIM x(4)
DIM y(4)
DIM v(4)
lev = 1
li = 3
CLS
GOSUB Defnav
GOSUB Decor
Start:
GOSUB Decor
GOSUB Spec:
GOSUB Clw:
COLOR 3
LOCATE 10, 15
PRINT CHR$(201) + STRING$(8, 205) + CHR$(187)
LOCATE 11, 15
PRINT CHR$(186) + "        " + CHR$(186)
LOCATE 12, 15
PRINT CHR$(200) + STRING$(8, 205) + CHR$(188)
LOCATE 11, 16
COLOR lev
PRINT "LEVEL:"; lev
COLOR 3
LOCATE 11, 24
PRINT CHR$(186)
GOSUB Decor
SLEEP 0
GOSUB Clw
c = lev
GOSUB chcol
RANDOMIZE TIMER
ol = 4
oc = 0
FOR i = 1 TO 4
x(i) = INT((RND * 40)) * 8
y(i) = (INT((RND * 4)) * 8) + 8
v(i) = INT((RND * lev) + 1)
NEXT i
GOTO St:
Defnav:
DIM u(64)
DIM a(64)
FOR i = 1 TO 16
FOR J = 1 TO 8
READ Q
IF Q > 0 THEN PSET (99 + J, 99 + i), Q + 11
NEXT J
NEXT i
GET (100, 100)-(107, 107), a
GET (100, 108)-(107, 115), u
DATA 0,0,0,1,0,0,0,0
DATA 0,0,0,1,0,0,0,0
DATA 0,0,0,1,0,0,0,0
DATA 1,0,0,1,0,0,1,0
DATA 1,1,0,1,0,1,1,0
DATA 1,0,1,1,1,0,1,0
DATA 0,1,1,0,1,1,0,0
DATA 1,0,0,1,0,0,1,0
DATA 0,0,0,1,1,0,0,0
DATA 0,1,1,1,1,1,1,0
DATA 1,1,1,1,1,1,1,1
DATA 1,0,1,0,1,0,1,1
DATA 1,1,1,1,1,1,1,1
DATA 0,1,1,1,1,1,1,0
DATA 0,0,0,1,1,0,0,0
DATA 0,0,0,0,0,0,0,0
DIM n(128)
FOR i = 0 TO 7
FOR J = 0 TO 15
READ w
IF w > 0 THEN PSET (200 + J, 100 + i), 10
NEXT J
NEXT i
GET (200, 100)-(215, 107), n
DATA 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
DATA 0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
DATA 0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0
DATA 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
FOR i = 1 TO 184
PSET (100, i), 15
NEXT i
DIM l(183)
GET (100, 1)-(100, 183), l
CLS
RETURN
St:
FOR i = 1 TO 4
PUT (x(i), y(i)), z, XOR
NEXT i
ny = 152
PUT (ny, 183), a, XOR
wet = 0
inv = 5 + (lev * 10)
bad = inv
bux = 24
t = 2
hb = 0
bud = 8
PUT (bux, 8), n
COLOR 0
LINE (0, 200)-(320, 200)
1 f = 1
FOR i = 1 TO 4
IF y(i) = 200 AND inv > 0 THEN GOTO 2
IF y(i) = 200 AND inv < 1 THEN GOTO 3
PUT (x(i), y(i)), z, XOR
FOR Q = 0 TO 7
u = POINT(x(i) + Q, y(i) + 8)
IF u = 14 OR u = 13 OR u = 12 THEN GOSUB Clb
NEXT Q
y(i) = y(i) + v(i)
2 IF y(i) > 192 THEN y(i) = 16: v(i) = INT(RND * lev) + 1: x(i) = bux        '(INT((RND * 40)) * 8)
PUT (x(i), y(i)), z, XOR
3 NEXT i
J = STICK(1)
IF SCREEN(23, sd) = 32 THEN rep = rep + 1: IF rep = 39 THEN GOTO 1000
sd = sd + 1: IF sd = 41 THEN rep = 0: sd = 1
v$ = INKEY$
IF v$ = "`" THEN GOTO 1000
IF f = 1 THEN PLAY "mbp64"
IF f = 2 THEN PLAY "mbp63"
PUT (ny, 183), a, XOR
ny = ny + ((v$ = "4") * 8) - ((v$ = "6") * 8)
IF POINT(ny + 3, 185) <> 14 THEN GOTO Dead
PUT (ny, 183), a, XOR
IF v$ = "8" THEN GOSUB Fire
IF inv = -3 THEN wet = wet + 1: hb = 0
IF v$ = "#" THEN GOTO 9000
IF wet > 100 THEN GOTO 5
IF bux = 500 THEN GOTO Ignof
PUT (bux, 8), n, XOR
bux = bux + bud
IF bux > 304 AND wet = 0 THEN bux = 304: bud = -8
IF bux > 304 AND wet > 0 THEN bux = 500: GOTO Ignof
IF bux < 0 THEN bux = 0: bud = 8
PUT (bux, 8), n, XOR
hb = hb + t
IF hb > 320 AND lev > 3 THEN GOSUB Tch:
IF t = 20 THEN
         PUT (bux + 8, 16), l, XOR
         PUT (bux + 8, 16), l, XOR
         IF ASC(MID$(p$, ((bux / 8) + 1), 1)) > 65 THEN
                                                   GOSUB Pcl
                                                   LOCATE 23 - INT((ASC(MID$(p$, ((bux / 8) + 1), 1)) - 65)), INT((bux / 8) + 1)
                                                   PRINT " "
                                                   GOSUB Pcl
                                                   GOSUB Deca: o = o - 1
         END IF
END IF
COLOR t / 2
LINE (0, 199)-(hb, 199)
COLOR 3
IF hb > 400 THEN hb = 400
Ignof:
LOCATE 1, 1
PRINT "SCORE:";
PRINT USING "######"; sc
GOTO 1
Moc:
RETURN
Tch:
COLOR 0
LINE (0, 199)-(320, 199)
hb = 0
IF t = 20 THEN t = 2: RETURN
IF t = 2 THEN t = 20
RETURN
Pcl:
FOR i = 1 TO 4
IF y(i) < 192 THEN PUT (x(i), y(i)), z, XOR
NEXT i
RETURN
Dead:
PLAY "mbl64o0abagbgabgfedccedc"
GOSUB Pcl:
GOSUB Moc:
FOR e = 0 TO 1
COLOR 6 + (8 * e)
hy = ny
FOR i = 0 TO 160 STEP 1
LINE (hy, 183)-(hy - i, 183)
LINE (hy, 183)-(hy + i, 183)
LINE (hy, 184)-(hy - i * 2, 184)
LINE (hy, 184)-(hy + i * 2, 184)
LINE (hy, 185)-(hy - i * 3, 185)
LINE (hy, 185)-(hy + i * 3, 185)
LINE (hy, 186)-(hy - i * 4, 186)
LINE (hy, 186)-(hy + i * 4, 186)
LINE (hy, 187)-(hy - i * 4, 187)
LINE (hy, 187)-(hy + i * 4, 187)
LINE (hy, 188)-(hy - i * 3, 188)
LINE (hy, 188)-(hy + i * 3, 188)
LINE (hy, 189)-(hy - i * 2, 189)
LINE (hy, 189)-(hy + i * 2, 189)
LINE (hy, 190)-(hy - i, 190)
LINE (hy, 190)-(hy + i, 190)
NEXT i
NEXT e
PUT (100 + (li * 16), 0), a, XOR
li = li - 1
IF li = 0 THEN GOTO 1000
SLEEP 1
SLEEP 2
GOTO Start
STOP
5  a$ = "         " + CHR$(201) + STRING$(20, 205) + CHR$(187)
b$ = "         " + CHR$(186) + STRING$(20, 32) + CHR$(186)
c$ = "         " + CHR$(199) + STRING$(20, 196) + CHR$(182)
d$ = "         " + CHR$(200) + STRING$(20, 205) + CHR$(188)
COLOR 3
LOCATE 5, 1
PRINT a$, b$, c$, b$, b$, b$, c$, b$, d$
COLOR lev
LOCATE 6, 11
PRINT "MISSION"; lev; "COMPLETED!"
COLOR 15
LOCATE 8, 18
PRINT "BONUS:"
b1 = 0
FOR i = 1 TO bad
LOCATE 10, 12
PRINT "INVADERS X10="; b1
b1 = b1 + 10
PLAY "mfl64n1"
NEXT i
PLAY "mfl6o3c"
PLAY "mfp3"
b2 = 0
LOCATE 10, 26
PRINT "0   "
FOR i = 0 TO o STEP 2
LOCATE 10, 12
PRINT "INTEGRITYX10="; b2;
b2 = b2 + 20
PLAY "mfl64n1"
NEXT i
PLAY "mfl6o3c"
PLAY "mfp3"
LOCATE 10, 12
b3 = 0
LOCATE 10, 26
PRINT "     "
FOR i = 0 TO lev
LOCATE 10, 12
PRINT "LEVELX1000="; b3
b3 = b3 + 1000
PLAY "mfl64n1"
NEXT i
PLAY "mfl6o3c"
PLAY "mfp3"
LOCATE 10, 12
PRINT "   TOTAL:         "
LOCATE 10, 21
PRINT b1 + b2 + b3
PLAY "mfmsl10o3cl6o3c"
LOCATE 12, 14
COLOR 4
PRINT "Press any key"
SLEEP 0
lev = lev + 1
sc = sc + b1 + b2 + b3
IF lev = 9 THEN GOTO 5000
GOTO Start
Fire:
ly = ny + 4
PUT (ly, 0), l, XOR
GOSUB Scan
PUT (ly, 0), l, XOR
RETURN
Scan:
GOSUB Moc:
FOR i = 1 TO 4
IF y(i) = 200 THEN GOTO 10
th = 0
FOR J = x(i) TO x(i) + 7
th = th + POINT(J, y(i) + 3)
NEXT J
IF th <> lev * 8 THEN
                 SOUND 38, 1
                 PLAY "mbp64"
                 PUT (x(i), y(i)), z, XOR
                 inv = inv - 1
                 sc = sc + 10
                 y(i) = 200
END IF
10 NEXT i
GOSUB Moc
RETURN
Clb:
h = INT(y(i) / 8)
b = INT(x(i) / 8)
LOCATE h + 2, b + 1
IF h < 22 THEN PRINT " ": o = o - 1: GOSUB Deca
f = 2
RETURN
chcol:
FOR i = 1 TO 64
z(i) = p(c, i)
NEXT i
RETURN
Decor:
LOCATE 1, 1
COLOR 3
PRINT "SCORE:";
PRINT USING "######"; sc
FOR i = 1 TO li
PUT (100 + (i * 16), 0), a, PSET
NEXT i
FOR i = 200 TO 191 STEP -1
IF INT(i / 2) = i / 2 THEN
                      k = 13
                      ELSE
                      k = 12
END IF
COLOR k
LINE (0, i)-(320, i)
NEXT i
FOR i = 6 TO 1 STEP -1
PSET (20 + (50 * i), 100 + (i * 10)), 14
COLOR 14
FOR J = -((7 - i) * 20) TO ((7 - i) * 20)
LINE (20 + (50 * i), 100 + (i * 10))-((20 + (50 * i)) + J, 190)
NEXT J
NEXT i
o = 127
FOR Q = 1 TO 40
FOR w = 1 TO 21
IF SCREEN(w, Q) <> 32 THEN o = o + 1
NEXT w
NEXT Q
RETURN
1000 FOR J = 1 TO 4:
FOR i = 15 TO 0 STEP -1
SOUND (38 + i) + J, 1
COLOR 7, i
NEXT i
NEXT J
COLOR 15
a$ = CHR$(201) + STRING$(10, 205) + CHR$(187)
b$ = CHR$(186) + "          " + CHR$(186)
c$ = CHR$(200) + STRING$(10, 205) + CHR$(188)
LOCATE 11, 15
PRINT a$
LOCATE 12, 15
PRINT b$
LOCATE 13, 15
PRINT c$
COLOR 12
LOCATE 12, 16
PRINT "GAME  OVER"
FOR i = 119 TO 201
FOR h = 85 TO 97
IF POINT(i, h) <> 12 THEN PSET (i, h), 1
NEXT h
NEXT i
SLEEP 1
WHILE INKEY$ = ""
WEND
RUN
Clw:
FOR i = 2 TO 13
LOCATE i, 1
PRINT STRING$(40, 32)
NEXT i
RETURN
5000 STOP
Spec:
p$ = STRING$(40, 65)
FOR i = 1 TO 40
FOR J = 23 TO 3 STEP -1
IF SCREEN(J, i) <> 32 THEN GOSUB Inca:
NEXT J
NEXT i
RETURN
Inca:
i$ = MID$(p$, i, 1)
az = ASC(i$)
az = az + 1
i$ = CHR$(az)
MID$(p$, i, 1) = i$
RETURN
Deca:
i$ = MID$(p$, b + 1, 1)
az = ASC(i$)
az = az - 1
i$ = CHR$(az)
MID$(p$, b + 1, 1) = i$
RETURN
9000 LOCATE 1, 1
INPUT qwe
lev = qwe - 1
GOTO 5





