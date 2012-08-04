REM Joc. Shift+X pentru iesire.

DECLARE SUB CHENAR (culb!)
DECLARE SUB CLSIN ()
DECLARE SUB SALVSCOR ()
DECLARE SUB IASCOR ()
COMMON SHARED ent.x, ent.y, ent.unghi, ent.rot, ent.scut, ent.vit, ent.bum
COMMON SHARED inm.x, inm.y, inm.unghi, inm.rot, inm.scut, inm.vit, inm.bum
COMMON SHARED plasma.e, plasma.x, plasma.y, plasma.ax, plasma.ay
COMMON SHARED lovit, incerc, vatrage, convrad, franeaza, spreel, torpsun, camuf, puncte, record
COMMON SHARED enterprise$, kling$, romul$, vezirec, ch AS STRING * 1, torp$, faz$, dis$, buum$
COMMON SHARED o.ent.vit, o.ent.man, o.inm.prec, o.inm.vit, o.inamic, o.coliz
DECLARE FUNCTION STN$ (num!)
DECLARE FUNCTION ST0$ (num!)
DECLARE FUNCTION STR0! (num!)
DECLARE SUB MENIU ()
DECLARE SUB INM.FUGE ()
DECLARE SUB MISCA.PLASMA ()
DECLARE SUB FOC.PLASMA ()
DECLARE SUB RML.AFIS ()
DECLARE SUB OPTIUNI ()
DECLARE SUB ENT.AFIS ()
DECLARE SUB KLG.AFIS ()
DECLARE SUB INM.FOC ()
DECLARE SUB ENT.FOC ()
DECLARE SUB INM.CAUTA ()
DECLARE SUB INM.MISCA ()
DECLARE SUB ENT.MISCA ()
DECLARE SUB CRASTI ()
DECLARE FUNCTION DISTANTA! (x1!, y1!, x2!, y2!)
DECLARE SUB CPRINT (sir$)
DECLARE SUB BARASTARE (scut1!, scut2!, scor!)
DECLARE SUB MESAJ (tip!)
DECLARE SUB EXPLOZIE (expx!, expy!, expi!)
DECLARE SUB MINIEXP (expx!, expy0, expi!)
CONST mes.crasti = 1
CONST mes.bravo = 2
CONST mes.mort = 3
CONST klingon = 1
CONST romulan = 2
DIM SHARED s(30, 2)
camuf = 0
o.inamic = klingon
o.ent.man = 1
o.ent.vit = 1
o.inm.prec = 1
o.inm.vit = 1
o.coliz = 1
SCREEN 12
VIEW
IASCOR
puncte = 0
restart:
enterprise$ = "bd5l3d5l2u11r2d4r2u5m-2,-1m-2,-2m-1,-2m+0,-2m+1,-2m+2,-2m+2,-1m+2,0m+2,0m+2,1m+2,2m+1,2m+0,2m-1,2m-2,2m-2,1d5r2u4r2d11l2u5l4"
kling$ = "bd5l4m-4,2d2l2u9r2d2m+5,-4u9h1u1m+2,-2m+2,2d1g1d9m+5,4u2r2d9l2u2m-4,-2l4"
romul$ = "bd5l3m-6,-4d3l2u12r2d3m+4,2m+2,-2m+2,-1m+2,0m+2,1m+2,2m+4,-2u3r2d12l2u3m-6,4l3"
vezirec = 1
MENIU
vezirec = 0
rest2:
ent.x = 620
ent.y = 429
ent.unghi = 45
ent.vit = 0
ent.rot = 0
ent.scut = 22
ent.bum = 0
inm.x = 15
inm.y = 15
inm.unghi = 225
inm.vit = 0
inm.rot = 0
inm.scut = 22
inm.bum = 0
spreel = 0
plasma.e = 0
plasma.x = 0
plasma.y = 0
plasma.ax = 0
plasma.ay = 0
convrad = 6.28 / 360
lovit = 0
focfazr = 0
vatrage = 0
incerc = 0
CHENAR 10
VIEW (1, 17)-(638, 462)
FOR i = 1 TO 30
s(i, 1) = INT(RND * 640)
s(i, 2) = 16 + INT(RND * 448)
NEXT i
PLAY "MLMBL64T128"
faz$ = "N62N61N60N61"
dis$ = "": r = 40: WHILE r > 2: dis$ = dis$ + "N" + STR$(INT(r)): r = r - 3: WEND
1
BARASTARE ent.scut, inm.scut, puncte
CLS
DEF SEG = 0
kbdflag = PEEK(&H417)
IF (kbdflag AND 1) = 1 THEN ent.vit = ent.vit + 1 + o.ent.vit * 2
IF (kbdflag AND 8) = 8 THEN ent.unghi = ent.unghi + (6 + o.ent.man * 6)
IF (kbdflag AND 4) = 4 THEN ent.unghi = ent.unghi - (6 + o.ent.man * 6)
j$ = INKEY$
IF j$ = "X" THEN STOP
IF j$ = "p" THEN ent.rot = ent.rot - 7
IF j$ = "o" THEN ent.rot = ent.rot + 7
IF j$ = "q" THEN ent.vit = ent.vit + 10
IF j$ = "a" THEN ent.vit = ent.vit - 10
ent.vit = ent.vit * .9
IF j$ = " " THEN focfazr = 4
IF ent.scut = 0 THEN focfazr = 0
IF ent.scut > 0 THEN ENT.MISCA
IF inm.scut > 0 THEN INM.MISCA

avanx = 0 - SIN(ent.unghi * convrad) * ent.vit
avany = 0 - COS(ent.unghi * convrad) * ent.vit
iax = 0 - SIN(inm.unghi * convrad) * inm.vit
iay = 0 - COS(inm.unghi * convrad) * inm.vit

tendx = avanx / 4
tendy = avany / 4
FOR i = 1 TO 30
s(i, 1) = s(i, 1) - tendx
s(i, 2) = s(i, 2) - tendy
IF s(i, 1) < 0 THEN s(i, 1) = 639: s(i, 2) = INT(RND * 480)
IF s(i, 1) > 639 THEN s(i, 1) = 0: s(i, 2) = INT(RND * 480)
IF s(i, 2) < 0 THEN s(i, 1) = INT(RND * 640): s(i, 2) = 479
IF s(i, 2) > 479 THEN s(i, 1) = INT(RND * 640): s(i, 2) = 0
NEXT i

IF o.inamic = klingon THEN INM.CAUTA
IF o.inamic = romulan THEN IF fugi = 0 AND plasma.e = 0 THEN INM.CAUTA
IF o.inamic = romulan THEN IF plasma.e > 0 OR fugi = 1 THEN INM.FUGE
IF plasma.e > 0 THEN camufleaza = 1
IF camufleaza THEN camuf = camuf + 1 ELSE camuf = camuf - 1
IF camuf > 9 THEN camuf = 9
IF camuf < 0 THEN camuf = 0
IF ent.bum > 0 THEN ent.bum = ent.bum + 3
IF inm.bum > 0 THEN inm.bum = inm.bum + 3
IF ent.bum > 100 THEN MESAJ mes.mort: GOTO restart
IF inm.bum > 100 THEN MESAJ mes.bravo: o.inamic = 3 - o.inamic: GOTO rest2
IF inm.scut = 0 AND inm.bum = 0 THEN inm.bum = 1
IF ent.scut = 0 AND ent.bum = 0 THEN ent.bum = 1
selupta = 0: IF ent.scut > 0 AND inm.scut > 0 THEN selupta = 1
distant = ABS(inm.x - ent.x) + ABS(inm.y - ent.y)
IF o.coliz = 1 THEN IF selupta = 1 THEN IF distant < 25 THEN CRASTI: GOTO restart
franeaza = 0
razap = 180
camufleaza = 0
IF plasma.e = 0 AND o.inamic = romulan AND selupta = 1 THEN IF distant < razap THEN FOC.PLASMA
fugi = 0
razaf = 100
IF plasma.e = 0 AND o.inamic = romulan AND selupta = 1 THEN IF distant < razaf THEN fugi = 1
IF o.inamic = romulan AND selupta = 1 THEN IF distant > 220 THEN camufleaza = 1
IF selupta = 1 AND o.coliz = 1 AND distant < 48 THEN puncte = puncte + 500
FOR i = 1 TO 30
j$ = INKEY$
PSET (INT(s(i, 1)), INT(s(i, 2))), 15
NEXT i
IF ent.scut > 0 THEN ENT.AFIS
IF o.inamic = klingon AND inm.scut > 0 THEN KLG.AFIS
IF o.inamic = romulan AND inm.scut > 0 THEN RML.AFIS
IF ent.scut = 0 THEN EXPLOZIE ent.x, ent.y, ent.bum
IF inm.scut = 0 THEN EXPLOZIE inm.x, inm.y, inm.bum
IF focfazr > 0 AND ent.scut > 0 THEN ENT.FOC: focfazr = focfazr - 1
IF o.inamic = klingon AND inm.scut > 0 THEN INM.FOC
MISCA.PLASMA
IF focfazr > 0 THEN IF PLAY(0) = 0 THEN PLAY faz$
GOSUB pause
GOTO 1
pause:
DEF SEG = 0
oval = PEEK(&H46C)
WHILE PEEK(&H46C) = oval
WEND
RETURN

SUB BARASTARE (scut1, scut2, scor)
LOCATE 1, 1
COLOR 15
PRINT "ENTERPRISE:";
FOR ci = 1 TO 21
COLOR 4
IF ci > 4 THEN COLOR 14
IF ci > 10 THEN COLOR 10
IF scut1 < ci THEN COLOR 8
PRINT CHR$(254);
NEXT ci
COLOR 15
IF vezirec = 0 THEN
               PRINT "  PUNCTE:";
               PRINT ST0(puncte);
               END IF
IF vezirec = 1 THEN
               PRINT "  RECORD:";
               PRINT ST0(record);
               END IF
PRINT "  ";
PRINT "ADVERSAR :";
FOR ci = 1 TO 21
COLOR 4
IF ci > 4 THEN COLOR 14
IF ci > 10 THEN COLOR 10
IF scut2 < ci THEN COLOR 8
PRINT CHR$(254);
NEXT ci
COLOR 15

END SUB

SUB CHENAR (culb)
LINE (0, 16)-(639, 463), culb, B
END SUB

SUB CLSIN
LINE (1, 17)-(638, 462), 0, BF
END SUB

SUB CPRINT (sir$)
LOCATE CSRLIN, (41 - INT(LEN(sir$) / 2)): PRINT sir$
END SUB

SUB CRASTI
FOR j = 1 TO 80 STEP 2
BARASTARE 0, 0, puncte
CLS
FOR i = 1 TO 30
PSET (INT(s(i, 1)), INT(s(i, 2))), 15
NEXT i
EXPLOZIE ent.x, ent.y, j
EXPLOZIE inm.x, inm.y, j

DEF SEG = 0
oval = PEEK(&H46C)
WHILE PEEK(&H46C) = oval
WEND

NEXT j
MESAJ mes.crasti
END SUB

FUNCTION DISTANTA (x1, y1, x2, y2)
rez = SQR((ABS(x1 - x2) * ABS(x1 - x2)) + (ABS(y1 - y2) * ABS(y1 - y2)))
DISTANTA = rez
END FUNCTION

SUB ENT.AFIS
PSET (ent.x, ent.y), 0
a$ = "ta" + STR$(INT(ent.unghi)) + "c15" + enterprise$
DRAW a$
END SUB

SUB ENT.FOC
fx = ent.x
fy = ent.y
fax = 0 - SIN(ent.unghi * convrad) * 20
fay = 0 - COS(ent.unghi * convrad) * 20
lovit = 0
FOR i = 1 TO 40
fx = fx + fax
fy = fy + fay
IF (ABS(inm.x - fx) + ABS(inm.y - fy)) < 30 THEN lovit = 1
NEXT i
IF inm.scut = 0 THEN lovit = 0: EXIT SUB
PSET (ent.x, ent.y), 15
fdist = 640
IF lovit = 1 THEN fdist = INT(DISTANTA(ent.x, ent.y, inm.x, inm.y)) - 40
IF fdist < 5 THEN fdist = 5
f$ = "ta" + STR$(INT(ent.unghi)) + "c4" + "br1bu15nu" + STR$(fdist) + "br2u" + STR$(fdist)
DRAW f$
IF lovit = 1 THEN
             puncte = puncte + 20
             IF o.inamic = klingon THEN inm.scut = inm.scut + INT(RND * 2)
             inm.scut = inm.scut - 1
             IF camuf > 0 AND o.inamic = romulan THEN inm.scut = inm.scut - INT(RND * 2)
             END IF
IF inm.scut < 0 THEN inm.scut = 0
IF inm.scut = 0 THEN puncte = puncte + 10000
IF lovit = 1 THEN CIRCLE (inm.x, inm.y), 24, 11, , , 1
END SUB

SUB ENT.MISCA
ent.rot = ent.rot * SQR(.9)
ent.unghi = ent.unghi + ent.rot / 2
IF ent.unghi > 359 THEN ent.unghi = ent.unghi - 360
IF ent.unghi < 0 THEN ent.unghi = ent.unghi + 360
avanx = 0 - SIN(ent.unghi * convrad) * ent.vit
avany = 0 - COS(ent.unghi * convrad) * ent.vit
ent.x = ent.x + avanx / 2
ent.y = ent.y + avany / 2
IF ent.x < 0 THEN ent.x = 0
IF ent.x > 640 THEN ent.x = 640
IF ent.y < 0 THEN ent.y = 0
IF ent.y > 444 THEN ent.y = 444
END SUB

SUB EXPLOZIE (expx, expy, expi)
FOR expj = 1 TO 40
cul = 14 + INT(RND * 2)
IF expj < 20 THEN cul = 11
ci = (36 - expi) * 2
IF expi < 25 THEN ci = expi
IF expi > 35 THEN ci = 0
adx = (-20 + INT(RND * 40)) * (1 + INT(RND * 4))
ady = (-20 + INT(RND * 40)) * (1 + INT(RND * 4))
mins = ci / 20
maxs = ci / 10
IF expi < 36 THEN LINE (expx + adx * mins, expy + ady * mins)-(expx + adx * maxs, expy + ady * maxs), cul
NEXT expj
IF expi > 25 THEN CIRCLE (expx, expy), (expi - 25) * 10, 11, , , 1
z$ = ""
FOR B = 1 TO 4
z = INT(22 / ((expi / 5) + 1)) + INT(RND * B)
IF expi > 90 OR z < 0 THEN z = 0
z$ = z$ + "N" + STR$(z)
NEXT B
IF PLAY(0) = 0 THEN PLAY z$
END SUB

SUB FOC.PLASMA
fx = inm.x
fy = inm.y
tinta.x = ent.x - SIN(ent.unghi * convrad) * 2 * ent.vit
tinta.y = ent.y - COS(ent.unghi * convrad) * 2 * ent.vit
fax = 0 - SIN(inm.unghi * convrad) * 6
fay = 0 - COS(inm.unghi * convrad) * 6
lovit = 0
FOR i = 1 TO 80
fx = fx + fax
fy = fy + fay
IF (ABS(tinta.x - fx) + ABS(tinta.y - fy)) < 25 THEN lovit = 1
NEXT i
IF ent.scut = 0 THEN lovit = 0
IF lovit = 0 THEN EXIT SUB
inm.vit = 0
plasma.x = inm.x
plasma.y = inm.y
plasma.e = 20
plasma.ax = 0 - SIN(inm.unghi * convrad) * 22
plasma.ay = 0 - COS(inm.unghi * convrad) * 22
END SUB

SUB IASCOR
OPEN "lupttrek.rec" FOR INPUT AS #1
INPUT #1, n$
CLOSE #1
record = VAL(n$)
END SUB

SUB INM.CAUTA
ant.dist = 4 + o.inm.prec * 3
ant.dev = 10
deviatie = 3
ant.c.x = (inm.x - SIN(inm.unghi * convrad) * ant.dist)
ant.c.y = (inm.y - COS(inm.unghi * convrad) * ant.dist)
ant.s.x = (inm.x - SIN((inm.unghi - ant.dev) * convrad) * ant.dist)
ant.s.y = (inm.y - COS((inm.unghi - ant.dev) * convrad) * ant.dist)
ant.d.x = (inm.x - SIN((inm.unghi + ant.dev) * convrad) * ant.dist)
ant.d.y = (inm.y - COS((inm.unghi + ant.dev) * convrad) * ant.dist)
ant.c.dist = ABS(ent.x - ant.c.x) + ABS(ent.y - ant.c.y)
ant.s.dist = ABS(ent.x - ant.s.x) + ABS(ent.y - ant.s.y)
ant.d.dist = ABS(ent.x - ant.d.x) + ABS(ent.y - ant.d.y)
spreel = 1
IF ant.s.dist < ant.c.dist THEN inm.rot = inm.rot - deviatie: spreel = 0
IF ant.d.dist < ant.c.dist THEN inm.rot = inm.rot + deviatie: spreel = 0
END SUB

SUB INM.FOC
fx = inm.x
fy = inm.y
fax = 0 - SIN(inm.unghi * convrad) * 20
fay = 0 - COS(inm.unghi * convrad) * 20
lovit = 0
FOR i = 1 TO 40
fx = fx + fax
fy = fy + fay
IF (ABS(ent.x - fx) + ABS(ent.y - fy)) < 30 THEN lovit = 1
IF (ABS(ent.x - fx) + ABS(ent.y - fy)) < 40 THEN incerc = 2
NEXT i
IF ent.scut = 0 THEN lovit = 0
lovit = lovit * INT(RND * 2)
IF lovit = 0 AND incerc = 0 THEN EXIT SUB
IF PLAY(0) = 0 THEN PLAY dis$
incerc = incerc - 1
PSET (inm.x, inm.y), 15
fdist = 640
IF lovit = 1 THEN fdist = INT(DISTANTA(ent.x, ent.y, inm.x, inm.y)) - 40
IF fdist < 5 THEN fdist = 5
f$ = "ta" + STR$(INT(inm.unghi)) + "c10" + "bl1bu14nu" + STR$(fdist) + "br1u" + STR$(fdist)
DRAW f$
IF lovit = 1 THEN ent.scut = ent.scut - 1
IF ent.scut < 0 THEN ent.scut = 0
IF lovit = 1 THEN CIRCLE (ent.x, ent.y), 24, 11, , , 1
IF torpsun < 10 THEN torpsun = ffoc
END SUB

SUB INM.FUGE
ant.dist = 15 + o.inm.prec * 3
ant.dev = 15
deviatie = 18
ant.c.x = (inm.x - SIN(inm.unghi * convrad) * ant.dist)
ant.c.y = (inm.y - COS(inm.unghi * convrad) * ant.dist)
ant.s.x = (inm.x - SIN((inm.unghi - ant.dev) * convrad) * ant.dist)
ant.s.y = (inm.y - COS((inm.unghi - ant.dev) * convrad) * ant.dist)
ant.d.x = (inm.x - SIN((inm.unghi + ant.dev) * convrad) * ant.dist)
ant.d.y = (inm.y - COS((inm.unghi + ant.dev) * convrad) * ant.dist)
ant.c.dist = ABS(ent.x - ant.c.x) + ABS(ent.y - ant.c.y)
ant.s.dist = ABS(ent.x - ant.s.x) + ABS(ent.y - ant.s.y)
ant.d.dist = ABS(ent.x - ant.d.x) + ABS(ent.y - ant.d.y)
IF ant.s.dist > ant.c.dist THEN inm.rot = inm.rot - deviatie
IF ant.d.dist > ant.c.dist THEN inm.rot = inm.rot + deviatie
END SUB

SUB INM.MISCA
IF NOT franeaza THEN inm.vit = inm.vit + 1 / 2 + o.inm.vit / 2
inm.rot = inm.rot * SQR(.9)
inm.vit = inm.vit * SQR((.9 - .5 * franeaza))
inm.unghi = inm.unghi + inm.rot / 2
IF inm.unghi > 359 THEN inm.unghi = inm.unghi - 360
IF inm.unghi < 0 THEN inm.unghi = inm.unghi + 360
avanx = 0 - SIN(inm.unghi * convrad) * inm.vit
avany = 0 - COS(inm.unghi * convrad) * inm.vit
iax = avanx
iay = avany
inm.x = inm.x + avanx / 2
inm.y = inm.y + avany / 2
IF inm.x < 0 THEN inm.x = 0
IF inm.x > 640 THEN inm.x = 640
IF inm.y < 0 THEN inm.y = 0
IF inm.y > 444 THEN inm.y = 444
END SUB

SUB KLG.AFIS
PSET (inm.x, inm.y), 0
a$ = "ta" + STR$(INT(inm.unghi)) + "c2" + kling$
DRAW a$
END SUB

SUB MENIU
VIEW
SALVSCOR
CLSIN
LOCATE 3, 1: COLOR 10
CPRINT "SIMULATOR LUPTA 'STAR TREK'"
COLOR 15
CPRINT "PROGRAMAT PE 10 IUNIE 2000 DE DINU CRISTIAN MIRCEA"
PRINT
CPRINT "OPTIUNI LUPTA"
COLOR 15: PRINT
CPRINT "1. VITEZA VIRARE ENTERPRISE   :      /       /     "
PRINT
CPRINT "2. VITEZA INAINTARE ENTERPRISE:      /       /     "
PRINT
CPRINT "3. PRECIZIE CAUTARE INAMIC    :      /       /     "
PRINT
CPRINT "4. VITEZA INAINTARE INAMIC    :      /       /     "
PRINT
CPRINT "5. ADVERSAR :         /        "
PRINT
PRINT "                           ARMAMENT   :"
PRINT
PRINT "                           PUTERE SCUT:"
PRINT
PRINT "                           TACTICI    :"
PRINT
PRINT
CPRINT "6. COLIZIUNI INTRE NAVE:    /   "
PRINT
CPRINT "TASTE: ALT=STANGA; CTRL=DREAPTA; SHIFT=INAINTE; SPATIU=FAZER (BUTONAT)"
CPRINT "APASA ENTER PENTRU A INCEPE LUPTA !"
CHENAR 9
SOUND 4000, .5
BARASTARE 0, 0, puncte
trot = 0
e2:
LOCATE 18, 41
IF o.inamic = klingon THEN PRINT "DISRUPTOR FRONTAL" ELSE PRINT "TORPILA CU PLASMA"
LOCATE 20, 41
IF o.inamic = klingon THEN PRINT "FACTOR=1.25               " ELSE PRINT "FACTOR=1 (0.75 CAMUFLAT)"
LOCATE 22, 41
IF o.inamic = klingon THEN PRINT "ATACA FARA FRICA" ELSE PRINT "ATACA DE APROAPE"
LOCATE 23, 41
IF o.inamic = klingon THEN PRINT "POATE FACE 'KAMIKAZE'    " ELSE PRINT "SE CAMUFLEAZA LA DISTANTA"

PSET (148, 320), 0
IF o.inamic = klingon THEN a$ = "s16ta" + STR$(INT(trot)) + "c0" + kling$ + "s4"
IF o.inamic = romulan THEN a$ = "s16ta" + STR$(INT(trot)) + "c0" + romul$ + "s4"
DRAW a$
trot = trot + 10
IF trot > 359 THEN trot = trot - 360
k$ = INKEY$
IF k$ = "X" THEN STOP
IF k$ = "5" THEN o.inamic = 3 - o.inamic: SOUND 4000, .25
IF k$ = "6" THEN o.coliz = 1 - o.coliz: SOUND 4000, .25
LOCATE 25, 50: COLOR 8: IF o.coliz = 1 THEN COLOR 15
PRINT ("DA")
LOCATE 25, 55: COLOR 8: IF o.coliz = 0 THEN COLOR 15
PRINT ("NU")
PSET (148, 320), 0
IF o.inamic = klingon THEN a$ = "s16ta" + STR$(INT(trot)) + "c2" + kling$ + "s4"
IF o.inamic = romulan THEN a$ = "s16ta" + STR$(INT(trot)) + "c15" + romul$ + "s4"
DRAW a$
wy = 8: opt = o.ent.man: GOSUB subsub1: o.ent.man = opt
wy = 10: opt = o.ent.vit: GOSUB subsub1: o.ent.vit = opt
wy = 12: opt = o.inm.prec: GOSUB subsub1: o.inm.prec = opt
wy = 14: opt = o.inm.vit: GOSUB subsub1: o.inm.vit = opt

LOCATE 16, 40: COLOR 8: IF o.inamic = klingon THEN COLOR 15
PRINT "KLINGON"
LOCATE 16, 50: COLOR 8: IF o.inamic = romulan THEN COLOR 15
PRINT "ROMULAN"
COLOR 15
PLAY "mfp24"
IF k$ <> CHR$(13) THEN GOTO e2
OPEN "lupttrek.bas" FOR BINARY AS #1
CLOSE #1
EXIT SUB
subsub1:
IF k$ <> "" THEN IF 6 + (ASC(k$) - 48) * 2 = wy THEN SOUND 4000, .25: opt = opt + 1: IF opt > 2 THEN opt = 0
LOCATE wy, 48: COLOR 8: IF opt = 0 THEN COLOR 15
PRINT "MICA"
LOCATE wy, 55: COLOR 8: IF opt = 1 THEN COLOR 15
PRINT "MEDIE"
LOCATE wy, 63: COLOR 8: IF opt = 2 THEN COLOR 15
PRINT "MARE"
RETURN
END SUB

SUB MESAJ (tip)
VIEW
CLSIN
PLAY "T128MBL40O4AO5EG+L20AO4B"
IF tip = mes.crasti THEN
                    LOCATE 12, 1: COLOR 10
                    CPRINT "SIMULARE TERMINATA !!!"
                    COLOR 15: PRINT
                    CPRINT "ENTERPRISE A FOST DISTRUSA IN URMA UNEI COLIZIUNI CU NAVA INAMICA !"
                    IF puncte <= record THEN CPRINT "AI ACUMULAT " + STN(puncte) + " PUNCTE LA UN RECORD DE " + STN(record) + "."
                    IF puncte > record THEN CPRINT "AI DEPASIT RECORDUL DE " + STN(record) + " CU CELE " + STN(puncte) + " PUNCTE ACUMULATE."
                    PRINT
                    CPRINT "APASA ORICE TASTA PENTRU A LUPTA DIN NOU."
                    IF puncte > record THEN record = puncte
                    puncte = 0
                    END IF
IF tip = mes.bravo THEN
                   LOCATE 12, 1: COLOR 10
                   CPRINT "VICTORIE !!!"
                   COLOR 15: PRINT
                   CPRINT "NAVA INAMICA A FOST DISTRUSA !!!"
                   IF puncte <= record THEN CPRINT "AI PANA ACUM " + STN(puncte) + " PUNCTE LA UN RECORD DE " + STN(record) + "."
                   IF puncte > record THEN CPRINT "AI DEPASIT RECORDUL DE " + STN(record) + " CU CELE " + STN(puncte) + " PUNCTE DETINUTE."
                   PRINT
                   CPRINT "APASA ORICE TASTA PENTRU A LUPTA IN CONTINUARE."
                   END IF
IF tip = mes.mort THEN
                   LOCATE 12, 1: COLOR 10
                   CPRINT "SIMULARE TERMINATA !!!"
                   COLOR 15: PRINT
                   CPRINT "ENTERPRISE A FOST DISTRUSA - ESTI INFRANT !"
                   IF puncte <= record THEN CPRINT "AI ACUMULAT " + STN(puncte) + " PUNCTE LA UN RECORD DE " + STN(record) + "."
                   IF puncte > record THEN CPRINT "AI DEPASIT RECORDUL DE " + STN(record) + " CU CELE " + STN(puncte) + " PUNCTE ACUMULATE."
                   PRINT
                   IF puncte > record THEN record = puncte
                   puncte = 0
                   CPRINT "APASA ORICE TASTA PENTRU A LUPTA DIN NOU."
                   END IF
IF tip = mes.crasti THEN CHENAR 14
IF tip = mes.bravo THEN CHENAR 10
IF tip = mes.mort THEN CHENAR 12
vezirec = 0
IF tip <> mes.bravo THEN vezirec = 1
BARASTARE 0, 0, puncte
vezirec = 0
e1:
k$ = INKEY$
IF k$ <> "" THEN GOTO e1
WHILE INKEY$ = "": WEND
END SUB

SUB MINIEXP (expx, expy, expi)
FOR expj = 1 TO 15
cul = 14 + INT(RND * 2)
IF expj < 20 THEN cul = 11
ci = (36 - expi) * 2
IF expi < 25 THEN ci = expi
IF expi > 35 THEN ci = 0
adx = INT((-2 + (RND * 4)) * (1 + INT(RND * 4)))
ady = INT((-2 + (RND * 4)) * (1 + INT(RND * 4)))
mins = ci / 20
maxs = ci / 10
IF expi < 36 THEN LINE (expx + adx * mins, expy + ady * mins)-(expx + adx * maxs, expy + ady * maxs), cul
NEXT expj
IF expi > 25 THEN CIRCLE (expx, expy), (expi - 25), 11, , , 1
z$ = ""
FOR B = 1 TO 4
z = INT(22 / ((expi / 6) + 1)) + INT(RND * B)
IF expi > 90 OR z < 0 THEN z = 0
z$ = z$ + "N" + STR$(z)
NEXT B
IF PLAY(0) = 0 THEN PLAY z$
END SUB

SUB MISCA.PLASMA
IF plasma.e = 0 THEN EXIT SUB
IF plasma.e > 15 THEN
                 z$ = ""
                 r = FIX((plasma.e - 14) * 10)
                 FOR B = 1 TO 4
                 z$ = z$ + "N" + STR$(r)
                 r = r - (FIX(plasma.e) - 12)
                 IF r < 0 THEN r = 0
                 NEXT B
                 IF PLAY(0) = 0 THEN PLAY z$
                 END IF
plasma.e = plasma.e - .5
IF plasma.e > 12 THEN
                 plasma.x = plasma.x + plasma.ax / 2
                 plasma.y = plasma.y + plasma.ay / 2
                 IF plasma.x < ent.x THEN plasma.x = plasma.x + 2: plasma.ax = plasma.ax + .3
                 IF plasma.y < ent.y THEN plasma.y = plasma.y + 2: plasma.ay = plasma.ay + .3
                 IF plasma.x > ent.x THEN plasma.x = plasma.x - 2: plasma.ax = plasma.ax - .3
                 IF plasma.y > ent.y THEN plasma.y = plasma.y - 2: plasma.ay = plasma.ay - .3
END IF
IF plasma.e < 13 THEN MINIEXP plasma.x, plasma.y, (12 - plasma.e) * 4

IF plasma.x < 0 THEN plasma.e = 0
IF plasma.y < 16 THEN plasma.e = 0
IF plasma.x > 640 THEN plasma.e = 0
IF plasma.y > 480 THEN plasma.e = 0
PSET (plasma.x, plasma.y), 12
IF plasma.e > 12 THEN
                 FOR k = 1 TO 20
                 px = SIN(RND * 6.28) * 6
                 py = SIN(RND * 6.28) * 6
                 LINE (plasma.x, plasma.y)-(plasma.x + px, plasma.y + py), 4 + INT(RND * 2) * 8
                 NEXT k
                END IF
IF plasma.e < 0 THEN plasma.e = 0
IF plasma.e > 12 AND (ABS(plasma.x - ent.x) + ABS(plasma.y - ent.y) < 25) THEN
                                                                    plasma.e = 12
                                                                    ent.scut = ent.scut - 9 - INT(RND * 3)
                                                                    IF ent.scut < 0 THEN ent.scut = 0
                                                                    END IF
END SUB

SUB RML.AFIS
PSET (inm.x, inm.y), 0
kl = 0
IF INT(camuf / 3) = 0 THEN kl = 15
IF INT(camuf / 3) = 1 THEN kl = 7
IF INT(camuf / 3) = 2 THEN kl = 8
a$ = "ta" + STR$(INT(inm.unghi)) + "c" + STR$(kl) + romul$
DRAW a$
END SUB

SUB SALVSCOR
n$ = STN(record)
OPEN "lupttrek.rec" FOR OUTPUT AS #1
WRITE #1, n$
CLOSE #1
END SUB

FUNCTION ST0$ (num)
a$ = MID$(STR$(num), 2, LEN(STR$(num)) - 1)
WHILE LEN(a$) < 6: a$ = "0" + a$: WEND
ST0 = a$
END FUNCTION

FUNCTION STN$ (num)
a$ = MID$(STR$(num), 2, LEN(STR$(num)) - 1)
STN = a$
END FUNCTION

