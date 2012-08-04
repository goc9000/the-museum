SCREEN 13
COLOR 5
FOR i = 0 TO 15
OUT &H3C8, i
OUT &H3C9, i * 4
OUT &H3C9, i * 4
OUT &H3C9, i * 4
NEXT i
FOR i = 0 TO 7
OUT &H3C8, 16 + i
OUT &H3C9, 0
OUT &H3C9, 0
OUT &H3C9, i * 9
OUT &H3C8, 32 + i
OUT &H3C9, 0
OUT &H3C9, i * 9
OUT &H3C9, 0
OUT &H3C8, 48 + i
OUT &H3C9, 0
OUT &H3C9, i * 9
OUT &H3C9, i * 9
OUT &H3C8, 64 + i
OUT &H3C9, i * 9
OUT &H3C9, 0
OUT &H3C9, 0
OUT &H3C8, 80 + i
OUT &H3C9, i * 9
OUT &H3C9, 0
OUT &H3C9, i * 9
OUT &H3C8, 96 + i
OUT &H3C9, i * 8
OUT &H3C9, i * 4
OUT &H3C9, 0
OUT &H3C8, 112 + i
OUT &H3C9, i * 9
OUT &H3C9, i * 9
OUT &H3C9, 0
NEXT i
FOR i = 0 TO 7
OUT &H3C8, 16 + 8 + i
OUT &H3C9, i * 9
OUT &H3C9, i * 9
OUT &H3C9, 63
OUT &H3C8, 32 + 8 + i
OUT &H3C9, i * 9
OUT &H3C9, 63
OUT &H3C9, i * 9
OUT &H3C8, 48 + 8 + i
OUT &H3C9, i * 9
OUT &H3C9, 63
OUT &H3C9, 63
OUT &H3C8, 64 + 8 + i
OUT &H3C9, 63
OUT &H3C9, i * 9
OUT &H3C9, i * 9
OUT &H3C8, 80 + 8 + i
OUT &H3C9, 63
OUT &H3C9, i * 9
OUT &H3C9, 63
OUT &H3C8, 96 + 8 + i
OUT &H3C9, 60
OUT &H3C9, 28 + i * 5
OUT &H3C9, i * 9
OUT &H3C8, 112 + 8 + i
OUT &H3C9, 63
OUT &H3C9, 63
OUT &H3C9, i * 9
NEXT i
OPEN "spec128.pal" FOR OUTPUT AS #1
FOR h = 0 TO 127
OUT &H3C7, h
red = INP(&H3C9)
green = INP(&H3C9)
blue = INP(&H3C9)
PRINT "COLOR "; USING "###"; h;
PRINT " = "; USING "###"; red;
PRINT " "; USING "###"; green;
PRINT " "; USING "###"; blue
PRINT #1, CHR$(red); CHR$(green); CHR$(blue);
NEXT h
CLOSE #1

