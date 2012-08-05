1 DIM SCOL(8): SCHR$ = "GATC": FOR i = 1 TO 8: READ C: SCOL(i) = C: NEXT i: DATA 8,1,4,5,10,11,14,15
2 alf$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ.!? -(0123456789[": DIM stats(LEN(alf$))
10 SCREEN 9
20 CLS : COLOR 15: CLS : PRINT "G.A.T.C. MESSAGE CODER 1.00 by D.C.M. SOFT"
30 PRINT "Type message to encode then <CR>. Special commands are as follows:"
31 PRINT ">exit - quit program": PRINT ">stat - character frequency analysis (>rstat to reset)"
32 PRINT ">cls - clear screen"
40 PRINT
50 a = CSRLIN
55 IF a = 22 THEN LOCATE 23, 1: PRINT "Press any key to clear the screen": SLEEP 0: GOSUB 330: GOTO 50
60 LINE INPUT "", a$
65 IF a$ = ">cls" OR a$ = ">CLS" OR a$ = ">Cls" THEN GOSUB 330: GOTO 50
66 IF a$ = ">exit" OR a$ = ">EXIT" OR a$ = ">Exit" THEN GOTO 320
67 IF a$ = ">stat" OR a$ = ">STAT" OR a$ = ">Stat" THEN GOSUB 370: GOTO 50
68 IF a$ = ">rstat" OR a$ = ">RSTAT" OR a$ = ">Rstat" THEN FOR k = 1 TO LEN(alf$): stats(k) = 0: NEXT k: PRINT "Frequency analysis reset.": GOTO 50
70 LOCATE a, 1
75 IF a$ = "" THEN GOTO 50
80 FOR i = 1 TO LEN(a$)
90 b$ = MID$(a$, i, 1)
100 IF b$ >= "a" AND b$ <= "z" THEN b$ = CHR$((ASC(b$) - 32))
110 IF b$ = ")" THEN b$ = "("
115 IF b$ = CHR$(34) THEN b$ = "("
120 IF (NOT (b$ >= "A" AND b$ <= "Z")) AND b$ <> "!" AND b$ <> "?" AND b$ <> "." AND b$ <> "-" AND b$ <> "(" AND (NOT (b$ >= "0" AND b$ <= "9")) THEN b$ = " "
130 MID$(a$, i, 1) = b$
135 FOR k = 1 TO LEN(alf$)
136 IF b$ = MID$(alf$, k, 1) THEN stats(k) = stats(k) + 1
137 NEXT k
140 PRINT b$;
150 NEXT i
160 FOR i = 0 TO 9: j = STICK(1): NEXT i'delay



170 LOCATE a, 1
180 FOR i = 1 TO LEN(a$)
190 b$ = MID$(a$, i, 1)
200 IF b$ >= "A" AND b$ <= "Z" THEN X = ASC(b$) - 65: COLOR (SCOL(INT(X / 4) + 1)): PRINT MID$(SCHR$, (X MOD 4) + 1, 1);
210 IF b$ >= "0" AND b$ <= "4" THEN X = ASC(b$) - 47: COLOR (SCOL(X)): PRINT CHR$(249);
220 IF b$ >= "5" AND b$ <= "9" THEN X = ASC(b$) - 52: COLOR (SCOL(X)): PRINT ":";
230 IF b$ = " " THEN COLOR (SCOL(8)): PRINT "A";
240 IF b$ = "!" THEN COLOR (SCOL(8)): PRINT "G";
250 IF b$ = "-" THEN COLOR (SCOL(8)): PRINT "T";
260 IF b$ = "(" THEN COLOR (SCOL(8)): PRINT "C";
270 IF b$ = "." THEN COLOR (SCOL(7)): PRINT "T";
280 IF b$ = "?" THEN COLOR (SCOL(7)): PRINT "C";
290 NEXT i
300 COLOR (SCOL(1)): PRINT ">": COLOR 15
310 GOTO 50
320 CLS : STOP
330 CLS : COLOR 15: PRINT "G.A.T.C. MESSAGE CODER 1.00 by D.C.M. SOFT"
340 PRINT "Type message to encode then <CR>. Special commands are as follows:"
341 PRINT ">exit - quit program": PRINT ">stat - character frequency analysis (>rstat to reset)"
342 PRINT ">cls - clear screen"
350 PRINT
360 RETURN
370 GOSUB 330
380 let$ = alf$: plc = 0: omax = -1
390 FOR i = 1 TO LEN(alf$) - 1
395 max = 0: maxl = 0
400 FOR j = 1 TO LEN(alf$)
410 IF MID$(let$, j, 1) = "/" THEN GOTO 430
420 IF stats(j) > max THEN max = stats(j): maxl = j
425 IF stats(j) = max AND maxl = 0 THEN maxl = j
430 NEXT j
440 MID$(let$, maxl, 1) = "/": IF max <> omax THEN plc = plc + 1
450 PRINT USING "##"; plc;
451 IF plc >= 10 AND plc <= 19 THEN PRINT "th "; : GOTO 470
457 IF plc MOD 10 = 0 THEN PRINT "th ";
458 IF plc MOD 10 = 1 THEN PRINT "st ";
459 IF plc MOD 10 = 2 THEN PRINT "nd ";
460 IF plc MOD 10 = 3 THEN PRINT "rd ";
465 IF plc MOD 10 > 3 THEN PRINT "th ";
470 PRINT "place: '"; MID$(alf$, maxl, 1); "' ("; : PRINT USING "###"; max; : PRINT " occurances)"
480 IF CSRLIN = 22 THEN LOCATE 23, 1: PRINT "Press any key to clear the screen": SLEEP 0: GOSUB 330
490 omax = max
500 NEXT i
510 PRINT : GOTO 50

