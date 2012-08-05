REM Demo vizual.

ng = 80
DIM mem(ng, 4)
SCREEN 13
x = INT(RND * 160)
y = INT(RND * 100)

col = 1
rk = 0
fac = .1
ruuk = 0
1
rx = mem(1, 1)
ry = mem(1, 2)
rx1 = mem(1, 3)
ry1 = mem(1, 4)
ruuk = ruuk + 1
IF ruuk > 5 THEN rukk = 0
rk = rk + fac
IF RND > .95 THEN fac = fac + ((-.5 + RND))
IF fac < -.2 THEN fac = -.2
IF fac > .2 THEN fac = .2
IF rk > 6.28 THEN rk = rk - 6.28
x1 = x + (SIN(rk) * 3)
y1 = y + (COS(rk) * 3)
IF x1 < 0 THEN x1 = 319
IF y1 < 0 THEN y1 = 199
IF x1 > 319 THEN x1 = 0
IF y1 > 199 THEN y1 = 0
col = col + 1
IF col > 56 THEN col = 40
LINE (rx, ry)-(rx1, ry1), 0
LINE (319 - rx, ry)-(319 - rx1, ry1), 0
LINE (rx, 199 - ry)-(rx1, 199 - ry1), 0
LINE (319 - rx, 199 - ry)-(319 - rx1, 199 - ry1), 0
LINE (x, y)-(x1, y1), col
LINE (319 - x, y)-(319 - x1, y1), col
LINE (x, 199 - y)-(x1, 199 - y1), col
LINE (319 - x, 199 - y)-(319 - x1, 199 - y1), col
FOR z = 1 TO ng - 1
mem(z, 1) = mem(z + 1, 1)
mem(z, 2) = mem(z + 1, 2)
mem(z, 3) = mem(z + 1, 3)
mem(z, 4) = mem(z + 1, 4)
NEXT z
mem(ng, 1) = x
mem(ng, 2) = y
mem(ng, 3) = x1
mem(ng, 4) = y1
x = x1
y = y1
IF INKEY$ <> CHR$(27) THEN GOTO 1

