REM Clona Minesweeper. Taste: 6,7,8,9,0, Q = abandon.

DECLARE SUB EXPLORE (wx!, wy!, flag!)
DECLARE SUB drawloc (locx!, locy!)
DECLARE FUNCTION GETNBRS! (locx!, locy!)
DIM SHARED a(40, 23)
DIM SHARED b(40, 23)
COMMON a, b
CLEAR , , 16384
SCREEN 13
RANDOMIZE TIMER
FOR i = 1 TO 100
a(1 + INT(RND * 40), 1 + INT(RND * 23)) = 1
NEXT i
FOR i = 1 TO 40
FOR j = 1 TO 23
x = i
y = j
drawloc x, y
NEXT j
NEXT i
cx = 1
cy = 1
anim = 0
1
anim = anim + 1
IF anim = 9 THEN anim = 1
IF anim < 5 THEN LOCATE cy, cx: COLOR 15: PRINT CHR$(219)
IF anim > 4 THEN x = cx: y = cy: drawloc x, y
v$ = INKEY$
IF (v$ = "0") OR (v$ >= "6" AND v$ <= "9") THEN x = cx: y = cy: drawloc x, y
IF v$ = "6" AND cx > 1 THEN cx = cx - 1
IF v$ = "7" AND cx < 40 THEN cx = cx + 1
IF v$ = "9" AND cy > 1 THEN cy = cy - 1
IF v$ = "8" AND cy < 23 THEN cy = cy + 1
IF v$ = "0" THEN EXPLORE cx, cy, 1
IF v$ = "q" THEN
            FOR i = 1 TO 40: FOR j = 1 TO 23: b(i, j) = 1: drawloc i, j: NEXT j: NEXT i
            SLEEP 0
            STOP
            END IF
IF (v$ = "0") OR (v$ >= "6" AND v$ <= "9") THEN LOCATE cy, cx: COLOR 15: PRINT CHR$(219)
j = STICK(1)
GOTO 1

SUB drawloc (locx, locy)
LOCATE locy, locx
IF b(locx, locy) = 0 THEN COLOR 7 + 8 * ((locx + locy) MOD 2): PRINT "?": GOTO es
nb = GETNBRS(locx, locy)
IF a(locx, locy) = 0 THEN
                     COLOR nb
                     PRINT CHR$(48 + nb)
                     ELSE
                     COLOR 7
                     PRINT "*"
                     END IF
es:
END SUB

SUB EXPLORE (wx, wy, flag)
IF wx < 1 OR wx > 40 OR wy < 1 OR wy > 23 THEN GOTO ep
IF b(wx, wy) = 1 THEN GOTO ep
b(wx, wy) = 1
drawloc wx, wy
IF GETNBRS(wx, wy) > 0 THEN GOTO ep
EXPLORE wx - 1, wy - 1, fg2
EXPLORE wx + 0, wy - 1, fg2
EXPLORE wx + 1, wy - 1, fg2
EXPLORE wx - 1, wy + 0, fg2
EXPLORE wx + 1, wy + 0, fg2
EXPLORE wx - 1, wy + 1, fg2
EXPLORE wx + 0, wy + 1, fg2
EXPLORE wx + 1, wy + 1, fg2
ep:
END SUB

FUNCTION GETNBRS (locx, locy)
nab = 0
FOR gx = -1 TO 1
FOR gy = -1 TO 1
nx = locx + gx
ny = locy + gy
IF nx < 1 OR nx > 40 OR ny < 1 OR ny > 23 THEN GOTO rej
IF a(nx, ny) = 1 THEN nab = nab + 1
rej:
NEXT gy
NEXT gx
GETNBRS = nab
END FUNCTION

