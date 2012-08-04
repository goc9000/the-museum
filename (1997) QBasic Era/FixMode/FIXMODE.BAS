REM Un joc logic, fa toate patratele de aceeasi culoare, fiecare patrat
REM afecteaza alte 2 patrate.
REM Taste: Q,A,O,P,M, X = iesire.
REM Variabila SIZE determina dimensiunea tablei.

RANDOMIZE TIMER
size = 3
SCREEN 13
DIM points(size * size, 5)
FOR i = 1 TO size * size
points(i, 1) = 0
points(i, 2) = 18 + ((i - 1) MOD size) * 2
points(i, 3) = 10 + (INT((i - 1) / size)) * 2
points(i, 4) = INT(RND * (size * size)) + 1
points(i, 5) = INT(RND * (size * size)) + 1
NEXT i
FOR i = 1 TO 20
a = INT(RND * (size * size))
GOSUB keek
NEXT i
a = 0
c = 0
d = -1
e = 0
f = 0
1
f = 0
FOR i = 0 TO ((size * size) - 1)
x = points(i + 1, 2)
y = points(i + 1, 3)
LOCATE y, x
value = points(i + 1, 1)
IF value = 0 THEN COLOR 10: f = f + 1
IF value = 1 THEN COLOR 14
IF value = 2 THEN COLOR 12
PRINT CHR$(219)
NEXT i

IF f = size * size THEN GOTO 100

x = points(a + 1, 2)
y = points(a + 1, 3)
LOCATE y - 1, x - 1: COLOR 15: PRINT CHR$(218); CHR$(196); CHR$(191)
LOCATE y + 0, x - 1: COLOR 15: PRINT CHR$(179);
LOCATE y + 0, x + 1: COLOR 15: PRINT CHR$(179);
LOCATE y + 1, x - 1: COLOR 15: PRINT CHR$(192); CHR$(196); CHR$(217)


c = a
2
v$ = INKEY$
IF v$ = "o" THEN a = a - 1: GOTO 3
IF v$ = "p" THEN a = a + 1: GOTO 3
IF v$ = "m" THEN GOSUB keek: GOTO 1
IF v$ = "q" THEN a = a - size: GOTO 3
IF v$ = "a" THEN a = a + size: GOTO 3
IF v$ = "x" THEN STOP
GOTO 2
3
IF a < 0 THEN a = (size * size) - 1
IF a > ((size * size) - 1) THEN a = 0
FOR h = 1 TO 1000
NEXT h
x = points(c + 1, 2)
y = points(c + 1, 3)
LOCATE y - 1, x - 1: COLOR 15: PRINT "   "
LOCATE y + 0, x - 1: COLOR 15: PRINT " "
LOCATE y + 0, x + 1: COLOR 15: PRINT " "
LOCATE y + 1, x - 1: COLOR 15: PRINT "   "
GOTO 1

keek:
points(a + 1, 1) = points(a + 1, 1) + 1
points(a + 1, 1) = points(a + 1, 1) MOD 3
d = points(a + 1, 4)
points(d, 1) = points(d, 1) + 1
points(d, 1) = points(d, 1) MOD 3
d = points(a + 1, 5)
points(d, 1) = points(d, 1) + 1
points(d, 1) = points(d, 1) MOD 3
RETURN

100
sounds = 0
FOR i = 0 TO 200
SOUND sounds * 3960, .023
FOR h = 1 TO 5
NEXT h
SOUND sounds * (1960 - (SIN(i * 18) * 100)), .023
FOR h = 1 TO 5
NEXT h
NEXT i

