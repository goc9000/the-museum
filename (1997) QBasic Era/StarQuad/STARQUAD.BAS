
SCREEN 8
PHOTON = 0
PHOTONY = 0
PHOTONX = 0
KEY(1) ON
ON KEY(1) GOSUB HELP
TRICHE = 0
TAHEC = 1:
GZ = 3
Y$ = "oooo"
GZA = .01
E = 80
SPECL = 0
UFOSEL = 1
CLS
a$ = "00011000011111101111111110101010111111110111111000011000"
b$ = "01000010100000011001100111100111101001011001100101000010"
C$ = "20000002010000100011110001211210001111000100001020000002"
CRS = 1
LOCATE 8, 1
COLOR 15, 15
PRINT "     ,.....  ,.....  ,.....  ,....         ,.....  ,.  ,.  ,.....  ,..."
PRINT "     ,.        ,.    ,.  ,.  ,.  ,.        ,.  ,.  ,.  ,.  ,.  ,.  ,. ,."
PRINT "     ,.....    ,.    ,.....  ,....         ,.  ,.  ,.  ,.  ,.....  ,. ,."
PRINT "         ,.    ,.    ,.  ,.  ,.  ,.        ,.  ,.  ,.  ,.  ,.  ,.  ,. ,."
PRINT "     ,.....    ,.    ,.  ,.  ,.  ,.        ,.....  ,.....  ,.  ,.  ,... "
PRINT "                                                ,."
FOR J = 1 TO 80
FOR I = 8 TO 13
IF SCREEN(I, J) = ASC(".") THEN LOCATE I, J: COLOR I + 1: PRINT CHR$(219)
IF SCREEN(I, J) = ASC(",") THEN LOCATE I, J: COLOR I - 7: PRINT CHR$(219)
NEXT I
NEXT J
FOR I = 15 TO 0 STEP -1
COLOR 15, I
NEXT I
WRX = 4
WRY = 100
REM PLAY "MLO1L4GP30MLL6GP64GO2L2CL4GL2C"
der = 5
MESSAGE$ = "                                    o aventura spatiala programata de *dinu cristian mircea.("
GOSUB scrie
der = 9
SLEEP 0
KEY(1) OFF
CLS
I$ = STRING$(80, 219)
Z = 1
D$ = "    "
CLS
FOR I = 1 TO 8
FOR J = 1 TO 16 STEP 2
IF MID$(a$, Z, 1) = "1" THEN PSET (99 + J, 99 + I), 2: PSET (100 + J, 99 + I), 3: PSET (99 + J, I - 1), I: PSET (100 + J, I - 1), I
IF MID$(b$, Z, 1) = "1" THEN PSET (199 + J, 99 + I), 6: PSET (200 + J, 99 + I), 4
IF MID$(C$, Z, 1) = "1" THEN PSET (199 + J, I - 1), 8: PSET (200 + J, I - 1), 9
IF MID$(C$, Z, 1) = "2" THEN LINE (199 + J, I - 1)-(200 + J, I - 1), 4
Z = Z + 1
NEXT J
NEXT I
DIM o(128)
DIM b(128)
DIM V(128)
DIM F(128)
GET (100, 0)-(115, 15), V
GET (200, 0)-(215, 15), F
GET (100, 100)-(115, 115), o
GET (200, 100)-(215, 115), b
DIM L(20)
DIM C(20)
t = TIMER
CLS
RANDOMIZE TIMER
FOR I = 1 TO 20
L(I) = INT(RND * 200)
C(I) = INT(RND * 640)
NEXT I
DIM N(129)
GET (1, 1)-(16, 16), N
UFC = 0
DIM W(15, 2)
FOR I = 1 TO 15
W(I, 1) = INT(RND * 640)
W(I, 2) = INT(RND * 200)
NEXT I
BAS = 4
STS = 2
nc = 0
FT = 0
BAM = 0
LUR = 4
UFK = 0
EFRR = 1
UFR = 20
K$ = "    "
1 REM
CRS = CRS + .1
IF CRS > 15 THEN CRS = 1
IF CRS < 8 THEN EFRR = -1
IF CRS > 7 THEN EFRR = 1
D = 0
UFK = 0
UFR = 20
FOR I = 1 TO 20
IF L(I) = 3000 AND TAHEC <> 3 THEN UFK = UFK + 1: UFR = UFR - 1: GOTO 3
IF L(I) > 0 AND L(I) < 180 AND C(I) > 0 AND C(I) < 620 THEN PUT (C(I), L(I)), N, PSET
S = INT(RND * 7) + 2
IF BAIT > 0 AND BAM = 0 THEN GOSUB ATR: GOTO 2
IF BAIT > 0 AND BAM = 1 THEN GOSUB RES: GOTO 2
IF MID$(D$, 1, 1) = "L" THEN GOSUB NATR:
IF TAHEC = 1 OR TAHEC = 3 THEN C(I) = 320: L(I) = 100: GZ = 0
IF TAHEC = 2 THEN GZ = 0
IF TAHEC = 2 THEN C(I) = C(I) + SIN(I) * 4
IF TAHEC = 2 THEN L(I) = L(I) + COS(I) * 2
IF TAHEC = 4 THEN GZ = 1
IF TAHEC = 4 THEN C(I) = C(I) + SIN(CRS) * I
IF TAHEC = 4 AND (INT(I / 2) = I / 2) THEN L(I) = L(I) + COS(CRS) * I
IF TAHEC = 4 AND (INT(I / 2) <> I / 2) THEN L(I) = L(I) + EFRR
C(I) = C(I) + (INT(RND * S)) * GZ
C(I) = C(I) - (INT(RND * S)) * GZ
L(I) = L(I) + (INT(RND * S)) * GZ
L(I) = L(I) - (INT(RND * S)) * GZ
2 C(I) = C(I) + MC * 10
L(I) = L(I) + ML * 10
D = D + ABS(100 - L(I))
D = D + ABS(160 - C(I))
IF RND > .95 AND E <> 20 AND FT = 0 AND TAHEC <> 1 AND TRICHE2 = 0 THEN FT = 21: FTL = L(I): FTC = C(I)
IF L(I) > 0 AND L(I) < 180 AND C(I) > 0 AND C(I) < 620 THEN GOSUB ptozn
3 NEXT I
IF TAHEC = 1 THEN TAHEC = 2
IF TAHEC = 3 THEN TAHEC = 4
FOR I = 1 TO 15
PSET (W(I, 1), W(I, 2)), 0
W(I, 1) = W(I, 1) + MC * 10
 W(I, 2) = W(I, 2) + ML * 10
IF W(I, 1) < 0 THEN W(I, 1) = 640: W(I, 2) = INT(RND * 200)
IF W(I, 1) > 640 THEN W(I, 1) = 0: W(I, 2) = INT(RND * 200)
IF W(I, 2) < 0 THEN W(I, 2) = 200: W(I, 1) = INT(RND * 640)
IF W(I, 2) > 200 THEN W(I, 2) = 0: W(I, 1) = INT(RND * 640)
PSET (W(I, 1), W(I, 2)), 15
NEXT I
LOCATE 23, 1
COLOR 3
IF MID$(D$, 2, 1) = "T" THEN COLOR 0
IF D < 99999 THEN PRINT USING "#####"; D
LOCATE 23, 7
PRINT "     "; CHR$(236);
PRINT USING "##"; UFR;
IF UFR = 0 AND TAHEC = 0 THEN TAHEC = 3
LOCATE 23, 76
PRINT USING "####"; TIMER - t
IF INT(TIMER - t) = 2 THEN TAHEC = 0
V$ = INKEY$
V$ = UCASE$(V$)
IF V$ = "Y" THEN MC = MC + 1
IF V$ = "U" THEN MC = MC - 1
IF V$ = "Q" THEN ML = ML + 1
IF V$ = "A" THEN ML = ML - 1
IF V$ = "T" THEN PHOTON = 20: PHOTONX = 320: PHOTONY = 100
IF V$ = "|" THEN SPECL = 1
IF V$ = "~" AND SPECL = 1 THEN TRICHE = 1
IF V$ = "@" AND TRICHE = 1 THEN TRICHE2 = 1
IF V$ <> "Y" AND V$ <> "U" AND V$ <> "Q" AND V$ <> "A" THEN MC = MC / 1.3: ML = ML / 1.3
IF MID$(D$, 4, 1) = "N" THEN MC = MC + MZC / 9: ML = ML + MZL / 9
IF V$ = " " AND MID$(D$, 1, 1) <> "L" AND UFC = 0 AND TAHEC <> 2 THEN UFC = 5
IF LUR < 1 THEN GOTO NOBT
IF MID$(D$, 3, 1) = "S" OR LUR < 1 THEN GOTO NOBT
IF V$ = "Z" AND BAIT = 0 THEN LUR = LUR - 1: BAIT = 20: BAM = 0: BAY = 100: BAX = 320
IF V$ = "X" AND BAIT = 0 THEN LUR = LUR - 1: BAIT = 40: BAM = 1: BAY = 100: BAX = 320
NOBT:
IF ZG > 0 THEN MC = MZC: ML = MZL: ZG = ZG - 1
IF BAIT = 0 THEN GOTO 4
IF BAX > -20 AND BAX < 660 AND BAY > -20 AND BAY < 220 THEN PUT (BAX - 4, BAY - 4), N, PSET
BAX = BAX + (MC * 10)
BAY = BAY + (ML * 10)
BAIT = BAIT - 1
IF BAIT = 0 THEN GOTO 4
IF BAX > -20 AND BAY < 660 AND BAY > -20 AND BAY < 220 THEN PUT (BAX - 4, BAY - 4), F, PSET
4 IF FT = 0 THEN FT = 0: GOTO 5
IF FTL > -20 AND FTL < 220 AND FTC > -20 AND FTC < 660 THEN
                                                        FOR b = 0 TO 22 - FT
                                                        CIRCLE (FTC, FTL), b, 0
                                                        NEXT b
END IF
FTL = FTL + 10 * ML
FTC = FTC + 10 * MC
FT = FT - .5
IF FT < 1 THEN FT = 0: GOSUB FTCL: GOTO 5
IF FTL > -20 AND FTL < 220 AND FTC > -20 AND FTC < 660 THEN
                                                        FOR b = 0 TO 22 - FT
                                                        CIRCLE (FTC, FTL), b, K
                                                        NEXT b
END IF
5 IF PHOTON = 0 THEN PHOTON = 0: GOTO 6
IF PHOTONY > -20 AND PHOTONY < 220 AND PHOTONX > -20 AND PHOTONX < 660 THEN
                                                        FOR b = 0 TO PHOTON
                                                        CIRCLE (PHOTONX, PHOTONY), b, 0
                                                        NEXT b
END IF
PHOTONY = PHOTONY + 10 * ML
PHOTONX = PHOTONX + 10 * MC
PHOTON = PHOTON - .5
IF PHOTON < 1 THEN PHOTON = 0: GOSUB PHCL: GOTO 6
IF PHOTONY > -20 AND PHOTONY < 220 AND PHOTONX > -20 AND PHOTONX < 660 THEN
                                                        FOR b = 0 TO PHOTON
                                                        CIRCLE (PHOTONX, PHOTONY), b, K
                                                        NEXT b
END IF
6 IF MC <> 0 OR ML <> 0 THEN EN = EN + 1
OS = 0
DMC = 15
IF EX > 30 THEN EX = 30
IF MID$(D$, 2, 1) = "B" THEN DMC = 0
IF POINT(320, 100) = 10 THEN OS = 1
IF DMC = 0 THEN OS = 0
CIRCLE (320, 100), 16, DMC





GOSUB EVUFPOS:
PSET (320, 95), DMC1
PSET (320, 105), DMC2
PSET (309, 100), DMC3
PSET (331, 100), DMC4




IF UFC = 1 THEN
           COLOR 0
           LINE (180, 140)-(240, 120)
           LINE (460, 140)-(400, 120)
           PLAY "MBP55"
           GOSUB SCAN
           LINE (300, 80)-(340, 120), 0, BF
END IF
IF UFC = 2 THEN COLOR 0: LINE (120, 160)-(180, 140): LINE (520, 160)-(460, 140): COLOR 14: LINE (180, 140)-(240, 120): LINE (460, 140)-(400, 120)
IF UFC = 3 THEN COLOR 0: LINE (60, 180)-(120, 160): LINE (580, 180)-(520, 160): COLOR 14: LINE (120, 160)-(180, 140): LINE (520, 160)-(460, 140)
IF UFC = 4 THEN COLOR 0: LINE (0, 200)-(60, 180): LINE (640, 200)-(580, 180): COLOR 14: LINE (60, 180)-(120, 160): LINE (580, 180)-(520, 160)
IF UFC = 5 THEN COLOR 14: LINE (0, 200)-(60, 180): LINE (640, 200)-(580, 180)
UFC = UFC - 1: IF UFC = -1 THEN UFC = 0
IF INT(EX) > -1 AND EX < 16 THEN COLOR 15, INT(EX): EX = EX - 1
IF EX > 15 THEN COLOR 15, 14 + INT(RND * 2): EX = EX - 1
K = K + 1: IF K = 15 THEN K = 1
MZC = INT(RND * 3)
MZC = MZC - 1
MZL = INT(RND * 3)
MZL = MZL - 1
nc = nc + MC
IF D > 20000 AND STS <> 2 AND BAS > -1 THEN GOSUB stat
LOCATE 1, 1
COLOR 2
IF E < 58 THEN STS = 14
IF E < 45 THEN STS = 4
IF K < 8 THEN COLOR 2
IF K > 9 THEN COLOR STS
PRINT I$
LOCATE 23, 38
COLOR K
PRINT D$
IF E < 41 THEN EX = EX + 1.05: ZG = 50: IF EX > 20 THEN GOTO 2000
GZ = GZ + GZA
IF GZ > 6 THEN GZA = -.01
IF GZ = 0 THEN GZA = .01
GZ = 1
GOTO 1



stat:
COLOR 0, 0
LINE (300, 80)-(340, 120), 0, BF
LUR = 4
FOR I = 1 TO 15
PSET (W(I, 1), W(I, 2)), 15
NEXT I
LOCATE 1, 1
COLOR 2
PRINT I$
COLOR 11
BATS = 3
FOR I = 1 TO 40
FOR J = 1 TO I + 10
CIRCLE (320, 100), J, 11
NEXT J
LINE (320, 100)-(320 + 6 * I, 100), 1
LINE (320, 100)-(320 - 6 * I, 100), 1
FOR H = 1 TO 10
GOSUB TIMERP
NEXT H
NEXT I
GOSUB REFUEL
FOR I = 50 TO 1 STEP -1
CIRCLE (320, 100), I, 0
LINE (320, 100)-(320 + 5 * I, 100), 1
LINE (320, 100)-(320 - 5 * I, 100), 1
LINE (320 + 6 * I, 100)-(320 + 5 * I, 100), 0
LINE (320 - 6 * I, 100)-(320 - 5 * I, 100), 0
FOR J = 1 TO 20
GOSUB TIMERP
NEXT J
NEXT I
CLS
EN = 0
MC = 0
ML = 0
I$ = STRING$(80, 219)
E = 80
D$ = "    "
STS = 2
BAS = BAS - 1
RETURN
BAMS:
IF BAM = 0 THEN BAM = 1: RETURN
IF BAM = 1 THEN BAM = 0
RETURN
SCAN:
FOR I = 1 TO 20
DL = ABS(96 - L(I))
DC = ABS(312 - C(I))
HIJ = 16
IF PARA = 1 THEN HIJ = 64: DL = ABS(PHOTONY - 4 - L(I)): DC = ABS(PHOTONX - 8 - C(I))
IF DC < HIJ AND DL < HIJ / 2 THEN LINE (C(I), L(I))-(C(I) + 8, L(I) + 8), 0, BF: EX = EX + 15: L(I) = 3000: ufodown = ufodown + 1
NEXT I
IF PARA = 1 THEN LINE (280, 60)-(360, 140), 0, BF
RETURN
ATR:
L(I) = L(I) + (SGN(BAY - L(I)) * 10)
C(I) = C(I) + (SGN(BAX - C(I)) * 10)
RETURN
RES:
L(I) = L(I) - (SGN(BAY - L(I)) * 8)
C(I) = C(I) - (SGN(BAX - C(I)) * 8)
RETURN
NATR:
L(I) = L(I) + (SGN(100 - L(I)) * 2)
C(I) = C(I) + (SGN(320 - C(I)) * 2)
RETURN
1000 COLOR 15, 0
STOP
FTCL:
IF FTL < -50 OR FTL > 250 OR FTC < -50 OR FTC > 690 THEN RETURN
FOR I = 1 TO 22
CIRCLE (FTC, FTL), I, 0
NEXT I
IF FTL > 0 AND FTL < 200 AND FTC > 0 AND FTC < 640 THEN EX = EX + 18: ZG = 20: GOSUB EDR
RETURN










EDR:
IF E < 58 THEN GOSUB DMG
DMGE = 2
IF V$ = "E" THEN DMGE = 20
FOR M = 1 TO DMGE
FG = 178: MID$(I$, E, 1) = CHR$(FG): MID$(I$, 81 - E, 1) = CHR$(FG): E = E - 1
NEXT M
RETURN
DMG:
DG = INT(RND * 9)
IF DG = 1 THEN MID$(D$, 1, 1) = "L"
IF DG = 2 THEN MID$(D$, 2, 1) = "B"
IF DG = 3 THEN MID$(D$, 3, 1) = "S"
IF DG = 4 THEN MID$(D$, 4, 1) = "N"
RETURN
2000 COLOR 1
FOR I = 1 TO 5
FOR J = 15 TO 0 STEP -1
COLOR 4, J
FOR Q = 1 TO 100
X = (INT(RND * 23) + 1): Y = (INT(RND * 40) + 1): Y = Y * 2: Y = Y - 1
LOCATE X, Y
PRINT CHR$(219); CHR$(219)
NEXT Q
NEXT J
NEXT I
COLOR 0, 0
J = 1
COLOR 0, 0
FOR Q = 1 TO 5000
X = (INT(RND * 23) + 1): Y = (INT(RND * 40) + 1): Y = Y * 2: Y = Y - 1
LOCATE X, Y
PRINT CHR$(219); CHR$(219)
NEXT Q
CLS
WRX = 290
WRY = 50
MESSAGE$ = "jocul s[a terminat]]                              nava voastra a fost distrusa,iar invadadorii v[au ocupat planeta.]                       aveti noroc ca acesta e doar un simulator.mai incercati o data,poate reusiti."
GOSUB scrie
WRY = 80
WRX = 290
MESSAGE$ = "ozn[uri distruse *" + STR$(ufodown) + "(}ozn[uri ramase   *" + STR$(40 - ufodown) + "(}timp trecut      *" + STR$(INT(TIMER - t) - 5) + "(}scor total   *" + STR$(INT((ufodown * 500) / (TIMER - t))) + "(\*500"
GOSUB scrie
SLEEP 0
SLEEP 0
RUN
ptozn:
IF TAHEC <> 4 THEN PUT (C(I), L(I)), o, PSET
IF TAHEC = 4 AND INT(I / 2) = I / 2 THEN PUT (C(I), L(I)), V, PSET
IF TAHEC = 4 AND INT(I / 2) <> I / 2 THEN PUT (C(I), L(I)), b, PSET
RETURN
HELP:
MESSAGE$ = "sunteti pilotul unei nave de lupta,atacat din toate partile de catre forte ale raului.trebuie sa stiti cum sa va aparati,caci]in acest joc nu mai aveti a doua sansa.din fericire,aveti la dispozitie o nava puternica,care dispune de cele mai noi inven[]tii in domeniul armamentului."
WRX = 0: WRY = 120
GOSUB scrie
MESSAGE$ = "puteti comanda nava cu tastele[   *q [ (sus   *a [ (jos   *y [ (stinga   *u [ (dreapta   *spatiu [ (foc   *z(,*x [ (sonde *t [ (torpila]'sondele 'atrag sau resping inamicii depinzind de care este lansata.nava are la inceput *4 (sonde si torpile in total.]bara de sus reprezinta integritatea navei,contorul din stinga[jos reprezinta distanta medie a ozn[urilor fata de nava,cel din]mijloc,stricaciunile  la *l(aser *n(avigatie *s(onde *b(ord, iar cel din dreapta[jos,timpul de la lansare.puteti vizita o baza]pentru reparatii indepartindu[va de inamici la *2oooo (dar numai cind sunteti in alarma galbena sau rosie.]totul fiind spus,va urez succes.]                                               *apasati orice tasta pentru a porni"
WRX = 0: WRY = 140
GOSUB scrie
SLEEP 0
RETURN
scrie:
col = 11
FOR I = 1 TO LEN(MESSAGE$)
lr$ = MID$(MESSAGE$, I, 1)
IF lr$ = "]" THEN WRX = 0: WRY = WRY + 6
IF lr$ <> " " AND lr$ <> "}" AND lr$ <> "]" AND lr$ <> "," AND lr$ <> "^" AND lr$ <> "." THEN PSET (WRX, WRY), col
IF lr$ = "}" THEN WRX = 285: WRY = WRY + 6
IF lr$ = "," THEN LINE (WRX + 2, WRY + 4)-(WRX + 1, WRY + 5), 11
IF lr$ = "^" THEN WRY = WRY + 2
IF lr$ = "." THEN PSET (WRX + 2, WRY + 4), 11
IF lr$ = "*" THEN col = der: WRX = WRX - 5
IF lr$ = "(" THEN col = 11: WRX = WRX - 5
IF lr$ = "[" THEN PSET (WRX, WRY), 0: DRAW "c11bd2r3l3bu2c15"
IF lr$ = "a" THEN DRAW "r3d4u2l3d2u4"
IF lr$ = "p" THEN DRAW "r3d2l3u2d4u4"
IF lr$ = "l" THEN DRAW "d4r3l3u4"
IF lr$ = "n" THEN DRAW "d4u4r3d4u4l3"
IF lr$ = "e" THEN DRAW "r3l3d2r3l3d2r3l3u4"
IF lr$ = "t" THEN DRAW "r4l2d4u4l2"
IF lr$ = "r" THEN DRAW "r2d2l2u2d4u2r3d2u2l3u2"
IF lr$ = "s" THEN DRAW "r3l3d2r3d2l3bu4"
IF lr$ = "h" THEN DRAW "d4u2r3u2d4u2l3u2"
IF lr$ = "o" OR lr$ = "0" THEN DRAW "r3d4l3u4"
IF lr$ = "q" THEN DRAW "r3d5u1l3u4"
IF lr$ = "f" THEN DRAW "r3l3d2r2l2d2u4"
IF lr$ = "g" THEN DRAW "r3l3d4r3u2l1r1d2l3u4"
IF lr$ = "i" THEN DRAW "r2l1d4r1l2r1u4l1"
IF lr$ = "j" THEN DRAW "r3d4l3u1d1r3u4l3"
IF lr$ = "k" THEN DRAW "d4u2r2br0r1bu1u1bd4u1bu1bl2l1u2"
IF lr$ = "m" THEN DRAW "d4u4r4d4u4l2d3u3l2"
IF lr$ = "u" THEN DRAW "d4r3u4d4l3u4"
IF lr$ = "v" THEN DRAW "d4r2u1r1u3d3l1d1l2u4"
IF lr$ = "w" THEN DRAW "d4r4u4d4l2u3d3l2u4"
IF lr$ = "x" THEN DRAW "d1f1g1d1u1e1r1e1u1d1gfd1"
IF lr$ = "y" THEN DRAW "d2r4u2d2l2d2"
IF lr$ = "z" THEN DRAW "r3g3d1r3"
IF lr$ = "c" THEN DRAW "r3l3d4r3"
IF lr$ = "d" THEN DRAW "r2f1d3l3u4"
IF lr$ = "b" THEN DRAW "r2f1d3l3u2r3l3u2"
IF lr$ = "1" THEN DRAW "r1d4l1r2"
IF lr$ = "2" THEN DRAW "r3d1g3r3"
IF lr$ = "3" THEN DRAW "r3d2l2r2d2l3"
IF lr$ = "4" THEN DRAW "d2r3u2d4"
IF lr$ = "5" THEN DRAW "r3l3d2r3d2l3"
IF lr$ = "6" THEN DRAW "d4r3u2l2"
IF lr$ = "7" THEN DRAW "r3d4u2l1"
IF lr$ = "8" THEN DRAW "r3d2l2r2d2l3u4"
IF lr$ = "9" THEN DRAW "r3d4u2l3u2"
IF lr$ = "\" THEN DRAW "f4"
IF lr$ = "?" THEN DRAW "d1u1r4d2l1d1bd2r0"
WRX = WRX + 5
NEXT I
RETURN
REFUEL:
LOCATE 1, 1
FOR E = E TO 80
MID$(I$, E, 1) = CHR$(219)
MID$(I$, 81 - E, 1) = CHR$(219)
COLOR 2
LOCATE 1, 1
PRINT I$
FOR H = 1 TO 60
GOSUB TIMERP
NEXT H
NEXT E
FOR I = 38 TO 41
LOCATE 23, I
PRINT CHR$(251)
COLOR 3
FOR H = 1 TO 5
LOCATE 23, 76
PRINT USING "####"; TIMER - t
J = STICK(1)
NEXT H
NEXT I
RETURN
TIMERP:
COLOR 3
LOCATE 23, 76
PRINT USING "####"; TIMER - t
RETURN
EVUFPOS:
ZEKE:
DMC1 = 15: DMC2 = 15: DMC3 = 15: DMC4 = 15
IF MID$(D$, 2, 1) = "B" THEN DMC1 = 0: DMC2 = 0: DMC3 = 0: DMC4 = 0: RETURN
IF UFR = 0 OR TRICHE = 0 THEN RETURN
IF UFOSEL > 20 THEN RETURN
IF L(UFOSEL) = 3000 THEN UFOSEL = UFOSEL + 1: GOTO ZEKE
IF L(UFOSEL) < 100 THEN DMC1 = 4
IF L(UFOSEL) > 100 THEN DMC2 = 4
IF C(UFOSEL) < 320 THEN DMC3 = 4
IF C(UFOSEL) > 320 THEN DMC4 = 4
RETURN
PHCL:
FOR I = 1 TO 100 STEP 2
CIRCLE (PHOTONX, PHOTONY), I, 15
NEXT I
FOR I = 1 TO 100
CIRCLE (PHOTONX, PHOTONY), I, 0
NEXT I
PARA = 1
GOSUB SCAN
PARA = 0
RETURN




