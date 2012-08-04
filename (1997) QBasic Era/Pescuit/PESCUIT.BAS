v$ = "a"
SCREEN 7
COLOR 15, 0
PALETTE 15, 0
SLEEP 1
br = 9
10 DIM p(20, 20), d(20, 20)
20 FOR i = 1 TO 20: FOR j = 1 TO 20
30 p(i, j) = .7 * RND(1)
40 d(i, j) = INT(RND(1) * 5 + 1)
50 NEXT j, i
60 p(1, 1) = 0: k = 0: r = 1: c = 1
LOCATE 11, 13: PRINT "HAI SA PESCUIM !": PALETTE 15, 8: j = STICK(1): PALETTE 15, 7: j = STICK(1): PALETTE 15, 15: j = STICK(1): SLEEP 0: PALETTE 15, 7: j = STICK(1): PALETTE 15, 8: j = STICK(1): PALETTE 15, 0: j = STICK(1): PALETTE 15, 0
CLS
dead = 0
150 FOR t = 0 TO 6 STEP .05
IF r > 20 OR c > 20 OR r < 1 OR c < 1 THEN LOCATE 11, 3: PRINT "TE-AI LOVIT DE MAL SI TE-AI FRIPT !!": PALETTE 15, 8: j = STICK(1): PALETTE 15, 7: j = STICK(1): PALETTE 15, 15: j = STICK(1): SLEEP 0: PALETTE 15, 7: j = STICK(1): PALETTE 15, 8: j = STICK(1): PALETTE 15, 0: GOTO 550
IF dead = 1 THEN LOCATE 11, 2: PRINT "NU TE PRICEPI, MAESTRE; AI ABANDONAT !": PALETTE 15, 8: j = STICK(1): PALETTE 15, 7: j = STICK(1): PALETTE 15, 15: j = STICK(1): SLEEP 0: PALETTE 15, 7: j = STICK(1): PALETTE 15, 8: j = STICK(1): PALETTE 15, 0: j = STICK(1): PALETTE 15, 0: GOTO 550
160 IF RND(1) > p(r, c) OR d(r, c) < 1 THEN LOCATE br, 16: PRINT "NU MUSCA !": GOTO 220
170 N = INT(RND(1) * d(r, c) + 1)
180 g = INT(RND(1) * (r / 3) * (c / 3)) + 1
190 k = k + N * g
200 LOCATE br, 2: PRINT "URA ! AI PRINS"; N; "PESTI A CITE ";
201 PRINT USING "##"; g;
202 PRINT " KG !"
220 LOCATE br + 1, 8: PRINT "ESTI IN SECTORUL X ";
221 PRINT USING "##"; c;
222 PRINT "-Y ";
223 PRINT USING "##"; r
230 LOCATE br + 2, 12: PRINT "AI ";
231 PRINT USING "###"; k;
232 PRINT " KG DE PESTI"
233 mes$ = ""
330 IF RND(1) < t / 60 THEN mes$ = "FURTUNA - AI PIERDUT 1/2 ORA !": t = t + .5: GOTO 361
340 j = INT(100 * RND(1)) + 1
345 IF r = 1 AND c = 1 THEN j = 5
350 IF j > 4 THEN GOTO 361
360 ON j GOSUB 600, 700, 800, 900
361 :
369 LOCATE br + 3, 21 - (INT(LEN(mes$) / 2)): minou = t - FIX(t): PRINT mes$
LOCATE br + 1, 8: PRINT "ESTI IN SECTORUL X ";
PRINT USING "##"; c;
PRINT "-Y ";
PRINT USING "##"; r
LOCATE br + 2, 12: PRINT "AI ";
PRINT USING "###"; k;
PRINT " KG DE PESTI"
370 LOCATE br + 4, 10: PRINT "TIMP RAMAS:"; 5 - FIX(t); "H"; 60 - INT(60 * minou); "MIN"
380 LOCATE br + 5, 4: PRINT "NUMPAD=MISCARE, P=PESCUIT, Q=RESET"
PALETTE 15, 8: j = STICK(1): PALETTE 15, 7: j = STICK(1): PALETTE 15, 15: j = STICK(1)
390 v$ = INKEY$: IF v$ = "" THEN GOTO 390
hit = 0
400 IF v$ = "7" THEN hit = 1: r = r - 1: c = c - 1
401 IF v$ = "8" THEN hit = 1: r = r - 1: c = c + 0
402 IF v$ = "9" THEN hit = 1: r = r - 1: c = c + 1
403 IF v$ = "4" THEN hit = 1: r = r + 0: c = c - 1
404 IF v$ = "6" THEN hit = 1: r = r + 0: c = c + 1
405 IF v$ = "1" THEN hit = 1: r = r + 1: c = c - 1
406 IF v$ = "2" THEN hit = 1: r = r + 1: c = c + 0
407 IF v$ = "3" THEN hit = 1: r = r + 1: c = c + 1
408 IF v$ = "p" THEN hit = 1
409 IF v$ = "q" THEN hit = 1: dead = 1
IF hit = 0 THEN GOTO 390
PALETTE 15, 7: j = STICK(1): PALETTE 15, 8: j = STICK(1): PALETTE 15, 0: j = STICK(1): CLS
450 IF r = 1 AND c = 1 THEN GOTO 500
460 NEXT t
LOCATE 10, 1: PRINT "            FIR-AR SA FIE !!            "
LOCATE 11, 1: PRINT "TI-AI DEPASIT TIMPUL, SOARELE E LA APUS."
LOCATE 12, 1: PRINT "  JUMATATE DIN PRADA TI SE CONFISCA !!  "
k = INT(k / 2)
PALETTE 15, 8: j = STICK(1): PALETTE 15, 7: j = STICK(1): PALETTE 15, 15: j = STICK(1)
SLEEP 0
PALETTE 15, 7: j = STICK(1): PALETTE 15, 8: j = STICK(1): PALETTE 15, 0: j = STICK(1)
500 IF t = 0 THEN CLS : LOCATE 11, 6: PRINT "TI-E FRICA SA PLECI, MAESTRE ?": PALETTE 15, 8: j = STICK(1): PALETTE 15, 7: j = STICK(1): PALETTE 15, 15: j = STICK(1): SLEEP 0: PALETTE 15, 7: j = STICK(1): PALETTE 15, 8: j = STICK(1): PALETTE 15, 0: j = STICK(1): CLS : GOTO 550
CLS : LOCATE 10, 1: PRINT "AI REVENIT LA DOC DUPA"; INT(t);
LOCATE 10, 25: PRINT " ORE DE PESCUIT."
LOCATE 11, 2: PRINT "AI PRINS IN TOTAL ";
PRINT USING "###"; k;
PRINT " KILOGRAME PESTI."
LOCATE 12, 2: PRINT "RATA TA DE PESCUIT ESTE DE ";
PRINT USING "###"; INT(k / 5);
PRINT " PUNCTE."
PALETTE 15, 8: j = STICK(1): PALETTE 15, 7: j = STICK(1): PALETTE 15, 15: j = STICK(1)
SLEEP 0
PALETTE 15, 7: j = STICK(1): PALETTE 15, 8: j = STICK(1): PALETTE 15, 0: j = STICK(1)
550 CLS : LOCATE 11, 7: PRINT "GAME OVER - MAI JOCI ? (D/N)"
PALETTE 15, 8: j = STICK(1): PALETTE 15, 7: j = STICK(1): PALETTE 15, 15: j = STICK(1)
560 v$ = INKEY$: IF v$ <> "d" AND v$ <> "n" THEN GOTO 560
IF v$ = "d" THEN PALETTE 15, 7: j = STICK(1): PALETTE 15, 8: j = STICK(1): PALETTE 15, 0: j = STICK(1): CLS : GOTO 20
PALETTE 15, 7: j = STICK(1): PALETTE 15, 8: j = STICK(1): PALETTE 15, 0: j = STICK(1): CLS
STOP
600 IF r + c < 18 THEN RETURN
610 mes$ = "RECHINII AU SPERIAT PESTII !"
630 FOR i = 1 TO 8: FOR j = 1 TO 8: p(i, j) = p(i, j) - .1: NEXT j, i
660 RETURN
700 mes$ = "PESCARUSII FURA MOMEALA !"
729 FOR i = 1 TO 8: FOR j = 1 TO 8: d(i, j) = d(i, j) - 1: NEXT j, i: RETURN
800 mes$ = "VALURILE TE IMPING LA X"
810 r = INT(19 * RND(1) + 1): IF r < 10 THEN mes$ = mes$ + " "
811 mes$ = mes$ + STR$(r) + "-Y"
820 c = INT(19 * RND(1) + 1): IF c < 10 THEN mes$ = mes$ + " "
821 mes$ = mes$ + STR$(c)
840 t = t + .2
850 RETURN
900 mes$ = "AI PRINS UN RECHIN DE 50 KG !"
910 k = k + 50
930 RETURN

