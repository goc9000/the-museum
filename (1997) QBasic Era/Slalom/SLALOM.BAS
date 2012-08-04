REM SKI
SCREEN 7
CLS
DIM f(256)
FOR i = 1 TO 16
FOR j = 1 TO 16
READ Q
PSET (j - 1, i - 1), Q
NEXT j
NEXT i
DATA 0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,2,2,2,2,0,0,0,0,0,0
DATA 0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0
DATA 0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,2,2,2,2,0,0,0,0,0,0
DATA 0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0
DATA 0,0,0,0,2,2,2,2,2,2,2,2,0,0,0,0
DATA 0,0,0,2,2,2,2,2,2,2,2,2,2,0,0,0
DATA 0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,2,2,2,2,0,0,0,0,0,0
DATA 0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0
DATA 0,0,0,0,2,2,2,2,2,2,2,2,0,0,0,0
DATA 0,0,0,2,2,2,2,2,2,2,2,2,2,0,0,0
DATA 0,0,2,2,2,2,2,2,2,2,2,2,2,2,0,0
DATA 0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0
DATA 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
LINE (6, 16)-(9, 23), 6, BF
SY = 100
DIM Z(384)
DIM M(256)
DIM B(9, 2)
GET (0, 0)-(15, 23), Z
CLS
DIM s(256)
FOR c = 0 TO 1
FOR i = 0 TO 15
FOR j = 0 TO 15
READ Q
PSET ((c * 20) + j, i), Q
NEXT j
NEXT i
NEXT c
DATA 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0
DATA 0,0,0,0,0,0,4,4,4,4,0,0,0,0,0,0
DATA 0,0,0,0,0,0,4,4,4,4,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,4,4,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,3,3,3,3,0,0,0,0,0,0
DATA 0,0,1,0,0,3,3,3,3,3,3,0,0,1,0,0
DATA 0,0,4,3,3,3,3,3,3,3,3,3,3,4,0,0
DATA 0,0,1,0,0,3,3,3,3,3,3,0,0,1,0,0
DATA 0,0,1,0,0,3,3,3,3,3,3,0,0,1,0,0
DATA 0,0,1,0,0,3,3,3,3,3,3,0,0,1,0,0
DATA 0,0,1,0,0,5,5,5,5,5,5,0,0,1,0,0
DATA 0,1,1,1,0,5,5,0,0,5,5,0,1,1,1,0
DATA 0,0,0,0,0,5,5,0,0,5,5,0,0,0,0,0
DATA 0,0,0,0,6,5,5,0,0,5,5,6,0,0,0,0
DATA 0,0,0,6,6,0,0,0,0,0,0,6,6,0,0,0
DATA 0,0,6,6,0,0,0,0,0,0,0,0,6,6,0,0
DATA 0,0,0,0,0,0,0,4,4,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,4,4,4,4,0,0,0,0,0,0
DATA 0,1,1,1,0,0,4,4,4,4,0,0,1,1,1,0
DATA 0,0,1,0,0,0,0,4,4,0,0,0,0,1,0,0
DATA 0,0,1,0,0,0,3,3,3,3,0,0,0,1,0,0
DATA 0,0,1,0,0,3,3,3,3,3,3,0,0,1,0,0
DATA 0,0,4,3,3,3,3,3,3,3,3,3,3,4,0,0
DATA 0,0,1,0,0,3,3,3,3,3,3,0,0,1,0,0
DATA 0,0,1,0,0,3,3,3,3,3,3,0,0,1,0,0
DATA 0,0,0,0,0,3,3,3,3,3,3,0,0,0,0,0
DATA 0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0
DATA 6,0,0,0,5,5,0,0,0,0,5,5,0,0,0,6
DATA 6,6,0,5,5,0,0,0,0,0,0,5,5,0,6,6
DATA 0,6,6,5,0,0,0,0,0,0,0,0,5,6,6,0
DATA 0,0,6,6,0,0,0,0,0,0,0,0,6,6,0,0
DATA 0,0,0,6,6,0,0,0,0,0,0,6,6,0,0,0
DATA 0,0,0,0,6,6,0,0,0,0,6,6,0,0,0,0
GET (0, 0)-(15, 15), s
GET (20, 0)-(35, 15), f
CLS
LINE (0, 0)-(0, 23), 11
LINE (1, 0)-(15, 5), 4
LINE (1, 8)-(15, 5), 4
LINE (1, 0)-(1, 8), 4
PAINT (2, 4), 4
GET (0, 0)-(15, 15), M
CLS
SKS = 3
STG:
FOR i = 0 TO 9
B(i, 1) = INT(RND * 260)
B(i, 2) = INT(RND * 150)
PUT (B(i, 1), B(i, 2)), Z, XOR
NEXT i
h = 150
L = 0
EX = 0
sx = 290
MX = INT(RND * 250)
MY = 0
KS = 0
PUT (MX, MY), M, XOR
PUT (MX + 48, MY), M, XOR
PUT (sx, 150), s, XOR
ST = 20
1 FOR i = 0 TO 9
PUT (B(i, 1), B(i, 2)), Z, XOR
B(i, 2) = B(i, 2) + 1
IF B(i, 2) > 150 THEN B(i, 2) = 0: B(i, 1) = INT(RND * 296)
PUT (B(i, 1), B(i, 2)), Z, XOR
NEXT i
PUT (MX, MY), M, XOR
PUT (MX + 48, MY), M, XOR
MY = MY + 1
IF MY > 150 THEN MY = 0: GOSUB PCT: MX = INT(RND * 250)
PUT (MX, MY), M, XOR
PUT (MX + 48, MY), M, XOR
v$ = INKEY$
PUT (sx, h), s, XOR
IF h < 128 THEN GOTO noht
IF POINT(sx, 158) <> 0 OR POINT(sx + 15, 158) <> 0 OR POINT(sx + 8, 150) <> 0 THEN PLAY "MBL64O0CDEDDECEDDCDDCCCECDCECD": GOTO 1000
noht:
IF v$ = "}" THEN en = 8: SD = 1
IF v$ = "{" THEN en = 8: SD = -1
IF v$ = "[" THEN en = 8: SD = -2
IF v$ = "]" THEN en = 8: SD = 2
IF v$ = "q" AND h = 150 THEN s = 29
IF s > 0 THEN h = h - 1
s = s - 1
IF s < 0 THEN s = 0: h = h + 2: IF h > 150 THEN h = 150
sx = sx + SD
IF sx > 296 THEN sx = 296
IF sx < 0 THEN sx = 0
en = en - 1: IF en < 0 THEN SD = 0: en = 0
PUT (sx, h), s, XOR
NOSK:
LOCATE 1, 1
PRINT USING "##"; ST
GOTO 1
PCT:
IF sx > MX AND sx < MX + 48 THEN PLAY "MBO3L20C": ST = ST - 1
RETURN
1000 PUT (sx, h), f, XOR
FOR i = 1 TO 2000
NEXT i
g = h
FOR i = h TO 170
IF g < 161 THEN PUT (sx, g), f, XOR
IF g > 160 THEN PUT (sx, g), f, XOR
IF g > 165 THEN PUT (sx, g), f, XOR
COLOR 0
LINE (sx, 165)-(sx + 15, 165)
g = g + 1
IF g < 161 THEN PUT (sx, g), f, XOR
IF g > 160 THEN PUT (sx, g), f, AND
IF g > 165 THEN PUT (sx, g), f, XOR
COLOR 0
LINE (sx, 165)-(sx + 15, 165)
j = STICK(1)
NEXT i




