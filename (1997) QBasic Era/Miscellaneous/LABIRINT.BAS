SCREEN 7
CLS
COLOR 4
FOR i = 0 TO 320 STEP 4
FOR j = 0 TO 200 STEP 4
z = INT(RND * 2)
IF z = 1 THEN LINE (i, j)-(i + 4, j + 4)
IF z = 0 THEN LINE (i + 4, j)-(i, j + 4)
NEXT j
NEXT i



