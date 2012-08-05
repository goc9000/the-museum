REM Generator labirint.

DECLARE FUNCTION ISPAIR! (num!)
DECLARE FUNCTION CAN.GO! (currx!, curry!, direc!)
DECLARE FUNCTION ADDX! (direc!)
DECLARE FUNCTION ADDY! (direc!)
DECLARE SUB SPAWN.HALL (startx!, starty!, startd!, maxturns!, canspawn!)
DIM posmoves(4)
SCREEN 13
CLS
size = 100
LINE (0, 0)-(size - 2, size - 2), 10, B
tx = 2
ty = 2
genlab:
canmove = 0
PSET (tx, ty), 15
FOR tti = 1 TO 4
IF CAN.GO(tx, ty, tti) = 1 THEN SPAWN.HALL tx, ty, tti, 255, 2: tti = 4
NEXT tti
tx = 0
ty = 0
FOR i = 0 + 1 TO (INT(size / 2) - 1) - 1
FOR j = 0 + 1 TO (INT(size / 2) - 1) - 1
IF POINT(i * 2, j * 2) = 0 THEN tx = i * 2: ty = j * 2
NEXT j
NEXT i
IF tx > 0 AND ty > 0 THEN GOTO genlab
donelab:
SOUND 1000, 1
FOR i = 0 TO size - 2
FOR j = 0 TO size - 2
IF POINT(i, j) <> 0 THEN PSET (i, j), 0 ELSE PSET (i, j), 7
NEXT j
NEXT i
SLEEP 0
STOP

FUNCTION ADDX (direc)
IF direc = 2 THEN ADDX = 1
IF direc = 4 THEN ADDX = -1
IF direc <> 2 AND direc <> 4 THEN ADDX = 0
END FUNCTION

FUNCTION ADDY (direc)
IF direc = 1 THEN ADDY = -1
IF direc = 3 THEN ADDY = 1
IF direc <> 1 AND direc <> 3 THEN ADDY = 0
END FUNCTION

FUNCTION CAN.GO (currx, curry, direc)
imgx = currx + ADDX(direc)
imgy = curry + ADDY(direc)
neigh = 0
IF POINT(imgx - 1, imgy - 1) <> 0 THEN neigh = neigh + 1
IF POINT(imgx + 0, imgy - 1) <> 0 THEN neigh = neigh + 1
IF POINT(imgx + 1, imgy - 1) <> 0 THEN neigh = neigh + 1
IF POINT(imgx - 1, imgy + 0) <> 0 THEN neigh = neigh + 1
IF POINT(imgx + 1, imgy + 0) <> 0 THEN neigh = neigh + 1
IF POINT(imgx - 1, imgy + 1) <> 0 THEN neigh = neigh + 1
IF POINT(imgx + 0, imgy + 1) <> 0 THEN neigh = neigh + 1
IF POINT(imgx + 1, imgy + 1) <> 0 THEN neigh = neigh + 1
IF POINT(imgx, imgy) <> 0 THEN neigh = 99
IF neigh > 2 THEN CAN.GO = 0 ELSE CAN.GO = 1
END FUNCTION

FUNCTION ISPAIR (num)
IF num MOD 2 = 0 THEN ISPAIR = 1 ELSE ISPAIR = 0
END FUNCTION

SUB SPAWN.HALL (startx, starty, startd, maxturns, canspawn)
DIM posmoves(4)
hallx = startx
hally = starty
halld = startd
hallt = maxturns
hallsp = canspawn
GOTO domove
mainloop:
canmove = 0
posmv = 0
FOR i = 1 TO 4: posmoves(i) = 0: NEXT i
FOR i = 1 TO 4
IF CAN.GO(hallx, hally, i) = 1 THEN canmove = 1: posmv = posmv + 1: posmoves(posmv) = i
NEXT i
IF canmove = 0 THEN GOTO done
moveloop:
IF CAN.GO(hallx, hally, halld) = 0 THEN
                                   IF maxturns = 0 THEN GOTO done
                                   IF maxturns < 255 THEN maxturns = maxturns - 1
                                   halld = posmoves(INT(RND * posmv) + 1): GOTO moveloop
                                   END IF
x = INT(RND * 4)
IF RND > .7 AND CAN.GO(hallx, hally, x) = 1 AND ISPAIR(hallx) AND ISPAIR(hally) THEN
                                             IF maxturns = 0 THEN GOTO done
                                             IF maxturns < 255 THEN maxturns = maxturns - 1
                                             halld = x: GOTO moveloop
                                             END IF
FOR i = 1 TO 4
IF i <> halld AND CAN.GO(hallx, hally, i) = 1 AND (RND > .95) AND ISPAIR(hallx) AND ISPAIR(hally) AND hallsp > 0 THEN SPAWN.HALL hallx, hally, i, 1, hallsp - 1
NEXT i
domove:
hallx = hallx + ADDX(halld)
hally = hally + ADDY(halld)
PSET (hallx, hally), 10 + canspawn
GOTO mainloop
done:
END SUB

