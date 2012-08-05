RANDOMIZE TIMER
SCREEN 13
r = 0
FOR i = 0 TO 15
FOR j = 0 TO 15
COLOR r
y = i * 7
x = j * 7
LINE (x, y)-(x + 7, y + 7), 17, B
LINE (x + 1, y + 1)-(x + 6, y + 6), r, BF
r = r + 1
NEXT j
NEXT i
x = 0
y = 0
1
py = y * 7
px = x * 7
LINE (px, py)-(px + 7, py + 7), 17, B
v$ = INKEY$
IF v$ = "o" AND x > 0 THEN x = x - 1
IF v$ = "p" AND x < 15 THEN x = x + 1
IF v$ = "q" AND y > 0 THEN y = y - 1
IF v$ = "a" AND y < 15 THEN y = y + 1
py = y * 7
px = x * 7
LINE (px, py)-(px + 7, py + 7), 25, B
u = POINT(px + 3, py + 3)
LINE (161, 0)-(272, 111), 15, B
LINE (160, 1)-(271, 112), 7, B
LINE (163, 3)-(269, 109), u, BF
LOCATE 23, 1
COLOR 15
PRINT u; "         "
SLEEP 1
GOTO 1
REM 6,42,114,186,41,113,185
REM 46,118,191

