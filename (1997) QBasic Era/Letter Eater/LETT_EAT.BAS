       '******** Shift+F5 pentru pornire             **************
       '******** Alt+X pentru iesire                 **************
       '******** NU stergeti fisierul "lett_eat.cfg" **************
       '*** Varianta a jocului 'Run Away' din programul WinType ***



path$ = "D:\DEVELOP\QBASIC\JOCURI\" '<-- scrieti intre ghilimele
                                    '    locatia fisierului lett_eat.cfg



DIM stat(1500)
FOR i = 1 TO 1500: stat(i) = INT(RND * 2) * 2: NEXT i
GOSUB loadconfig
SCREEN 7
GOSUB getsysspeed
FOR i = 0 TO 15
PALETTE i, 0
NEXT i
DIM letr(77, 4)
LOCATE 1, 1
COLOR 9
PRINT CHR$(201); STRING$(38, 205); CHR$(187)
FOR i = 1 TO 19
PRINT CHR$(186);
COLOR 15
PRINT STRING$(38, 32);
COLOR 9
PRINT CHR$(186);
NEXT i
PRINT CHR$(200); CHR$(203); STRING$(14, 205); CHR$(203); STRING$(2, 205); CHR$(203); STRING$(18, 205); CHR$(203); CHR$(188)
PRINT " "; CHR$(200); CHR$(181);
COLOR 11
PRINT "SCORE ";
COLOR 15
PRINT "000000";
COLOR 9
PRINT CHR$(198); CHR$(188); "  "; CHR$(200); CHR$(181);
COLOR 11
PRINT "HIGHSCORE ";
COLOR 15
PRINT "000000";
COLOR 9
PRINT CHR$(198); CHR$(188)
FOR i = 0 TO 15
PALETTE i, i
NEXT i
3 :
FOR i = 1 TO 77
letr(i, 3) = 0
NEXT i
st = 50
x = 3
y = 3
ex = 37
ey = 16
mek = 10
maxmovb = 20
mvb = maxmovb
COLOR 15
LOCATE 22, 10
IF score < 100000 THEN PRINT "0";
IF score < 10000 THEN PRINT "0";
IF score < 1000 THEN PRINT "0";
IF score < 100 THEN PRINT "0";
IF score < 10 THEN PRINT "0";
PRINT MID$(STR$(score), 2, LEN(STR$(score)) - 1)

COLOR 15
LOCATE 22, 32
IF hiscore < 100000 THEN PRINT "0";
IF hiscore < 10000 THEN PRINT "0";
IF hiscore < 1000 THEN PRINT "0";
IF hiscore < 100 THEN PRINT "0";
IF hiscore < 10 THEN PRINT "0";
PRINT MID$(STR$(hiscore), 2, LEN(STR$(hiscore)) - 1)

a$ = "LETTER EATER"
b$(1) = "012101210121"
b$(2) = "121012101210"
b$(3) = "210121012101"
b$(4) = "101210121012"
kor = 1
COLOR 10
LOCATE 3, 14
PRINT CHR$(218); STRING$(12, 196); CHR$(191)
LOCATE 4, 14
PRINT CHR$(179); STRING$(12, 32); CHR$(179)
LOCATE 5, 14
PRINT CHR$(192); STRING$(12, 196); CHR$(217)
COLOR 10
LOCATE 9, 15
PRINT "1) PLAY GAME"
COLOR 14
LOCATE 11, 15
PRINT "2) SOUNDS:"
COLOR 12
LOCATE 13, 15
PRINT "3) LEVEL:"
COLOR 13
LOCATE 15, 15
PRINT "4) GAME HELP"
COLOR 9
LOCATE 17, 15
PRINT "5) EXIT GAME"
4 :
kor = kor + 1
IF kor > 4 THEN kor = 1
LOCATE 4, 15
FOR i = 1 TO 12
IF MID$(b$(kor), i, 1) = "0" THEN COLOR 5
IF MID$(b$(kor), i, 1) = "1" THEN COLOR 13
IF MID$(b$(kor), i, 1) = "2" THEN COLOR 15
PRINT MID$(a$, i, 1);
NEXT i
LOCATE 11, 26
COLOR 12
IF sounds = 1 THEN COLOR 10
IF sounds = 0 THEN PRINT "X"
IF sounds = 1 THEN PRINT CHR$(251)
COLOR 15
LOCATE 13, 25
IF level < 10 THEN PRINT "0";
PRINT MID$(STR$(level), 2, LEN(STR$(level)) - 1)
GOSUB delay
v$ = INKEY$
IF v$ = "2" THEN sounds = 1 - sounds
IF v$ = "3" THEN level = level + 1: IF level > 20 THEN level = 0
IF v$ = "4" THEN GOTO heeelp
IF v$ = "5" THEN GOSUB savecfg: CLS : GOTO ENDR
IF v$ = "~" THEN hiscore = 0: hiname$ = "NOBODY": GOSUB savecfg: COLOR 15: LOCATE 22, 32: PRINT "000000"
hearg = hearg + 1
IF hearg > 60 THEN hearg = 0
LOCATE 22, 22
COLOR 11
IF hearg < 30 THEN PRINT "HIGHSCORE"
COLOR 15
IF hearg > 29 THEN PRINT "BY "; hiname$
IF v$ <> "1" THEN GOTO 4
GOSUB savecfg
GOSUB sfx1
COLOR 9
LOCATE 2, 1
FOR i = 1 TO 19
PRINT CHR$(186);
COLOR 15
PRINT STRING$(38, 32);
COLOR 9
PRINT CHR$(186);
NEXT i
score = 0
maxmovb = 22 - level
movb = maxmovb
LOCATE 22, 22
COLOR 11
PRINT "HIGHSCORE ";
1
st = st - 5
IF st < 0 THEN st = 50
spawn = 0
IF st = 50 AND RND > .5 THEN spawn = 1 + INT(RND * 77): st = 49
FOR i = 1 TO 77
IF spawn > 0 AND letr(spawn, 3) = 0 THEN
                                        letr(spawn, 1) = INT(RND * 38) + 2
                                        letr(spawn, 2) = INT(RND * 17) + 2
                                        letr(spawn, 3) = 1
                                        letr(spawn, 4) = 200
                                        IF SCREEN(letr(spawn, 2), letr(spawn, 1)) <> 32 THEN letr(spawn, 3) = 0
                                    END IF
IF letr(i, 3) = 1 AND ex = letr(i, 1) AND ey = letr(i, 2) THEN letr(i, 3) = 0
IF letr(i, 3) = 1 THEN GOSUB printletr
IF letr(i, 3) = 0 THEN FOR h = 1 TO 10: NEXT h
GOSUB moove
NEXT i
LOCATE y, x
COLOR 14
PRINT CHR$(2)
LOCATE ey, ex
COLOR 4
PRINT CHR$(2)
mvb = mvb - 1
IF mvb = 0 THEN GOSUB movebad: mvb = maxmovb
IF maxmovb < 2 THEN maxmovb = 2
COLOR 15
LOCATE 22, 32
IF hiscore < 100000 THEN PRINT "0";
IF hiscore < 10000 THEN PRINT "0";
IF hiscore < 1000 THEN PRINT "0";
IF hiscore < 100 THEN PRINT "0";
IF hiscore < 10 THEN PRINT "0";
PRINT MID$(STR$(hiscore), 2, LEN(STR$(hiscore)) - 1)
COLOR 15
LOCATE 22, 10
IF score < 100000 THEN PRINT "0";
IF score < 10000 THEN PRINT "0";
IF score < 1000 THEN PRINT "0";
IF score < 100 THEN PRINT "0";
IF score < 10 THEN PRINT "0";
PRINT MID$(STR$(score), 2, LEN(STR$(score)) - 1)
IF x = ex AND y = ey THEN GOTO 2
GOTO 1
2 :
PALETTE 6, 0
FOR i = 2 TO 11
LOCATE i, 2
COLOR 6
PRINT STRING$(38, 219);
LOCATE 22 - i, 2
COLOR 6
PRINT STRING$(38, 219);
NEXT i
FOR i = 1 TO 5
FOR h = 1 TO 500: NEXT h
PALETTE 6, 15
GOSUB sfx3
FOR h = 1 TO 500: NEXT h
PALETTE 6, 0
GOSUB sfx3
NEXT i
GOSUB theend
GOTO 3
END
printletr:
LOCATE letr(i, 2), letr(i, 1)
IF letr(i, 4) = 200 THEN COLOR 1
IF letr(i, 4) = 199 THEN COLOR 9
IF letr(i, 4) = 198 THEN COLOR 11
IF letr(i, 4) = 197 THEN COLOR 3
IF letr(i, 4) = 196 THEN COLOR 2
IF letr(i, 4) = 195 THEN COLOR 10
IF letr(i, 4) > 5 AND letr(i, 4) < 195 THEN COLOR 10
IF letr(i, 4) = 5 THEN COLOR 14
IF letr(i, 4) = 4 THEN COLOR 12
IF letr(i, 4) = 3 THEN COLOR 4
IF letr(i, 4) = 2 THEN COLOR 5
IF letr(i, 4) = 1 THEN COLOR 1
PRINT CHR$(49 + i);
letr(i, 4) = letr(i, 4) - 1
IF letr(i, 4) = 0 THEN letr(i, 3) = 0: LOCATE letr(i, 2), letr(i, 1): PRINT " "
RETURN
movebad:
COLOR 15
LOCATE ey, ex
PRINT " "
IF ex > x THEN ex = ex - 1
IF ex < x THEN ex = ex + 1
IF ey > y THEN ey = ey - 1
IF ey < y THEN ey = ey + 1
LOCATE ey, ex
COLOR 4
PRINT CHR$(2)
GOSUB sfx2
RETURN
movegood:
COLOR 15
LOCATE y, x
PRINT " "
IF letr(indj, 3) = 1 THEN
                     x = letr(indj, 1)
                     y = letr(indj, 2)
                     letr(indj, 3) = 0
                   GOSUB sfx1
                   ji = INT(level / 4)
                   IF ji = 0 THEN ji = 1
                   score = score + letr(indj, 4) * ji
                   IF score > 999999 THEN score = 999999
                   mek = mek - 1
                   IF mek = 0 THEN mek = 10: maxmovb = maxmovb - 1
                   END IF
LOCATE y, x
COLOR 14
PRINT CHR$(2)
RETURN
moove:
v$ = INKEY$
IF v$ = CHR$(27) THEN GOTO 2
IF v$ = "" THEN indj = 999
IF v$ <> "" THEN indj = ASC(v$) - 49
IF indj > -1 AND indj < 78 THEN GOSUB movegood
RETURN
heeelp:
GOSUB sfx1
COLOR 9
LOCATE 2, 1
FOR i = 1 TO 19
PRINT CHR$(186);
COLOR 15
PRINT STRING$(38, 32);
COLOR 9
PRINT CHR$(186);
NEXT i
COLOR 13
LOCATE 3, 19
PRINT "HELP"
PALETTE 6, 0
COLOR 6
LOCATE 5, 3
PRINT "The object of this game is to eat up"
LOCATE 6, 3
PRINT "as many symbols as you can by typing"
LOCATE 7, 3
PRINT "the corresponding key/combination. A"
LOCATE 8, 3
PRINT "red smiley will try to catch you but"
LOCATE 9, 3
PRINT "you can avoid him: the yellow smiley"
LOCATE 10, 3
PRINT "will have to jump to a letter to eat"
LOCATE 11, 3
PRINT "it, hopefully leaving the red smiley"
LOCATE 12, 3
PRINT "behind. As time passes, symbols will"
LOCATE 13, 3
PRINT "eventually dissapear so eat'em fast!"
LOCATE 14, 3
PRINT "The fresher a symbol is when you eat"
LOCATE 15, 3
PRINT "it, the more points you get. As your"
LOCATE 16, 3
PRINT "score increases, the red smiley will"
LOCATE 17, 3
PRINT "get faster and faster so watch out !"
COLOR 6
LOCATE 19, 3
PRINT "Page 1 - Press any key for next page"
PALETTE 6, 15
SLEEP 0
GOSUB sfx2
PALETTE 6, 0
COLOR 6
LOCATE 5, 3
PRINT "The initial speed of the mean smiley"
LOCATE 6, 3
PRINT "can also be adjusted using the Level"
LOCATE 7, 3
PRINT "option in the main menu. Level 00 is"
LOCATE 8, 3
PRINT "the slowest, level 20 is the fastest"
LOCATE 9, 3
PRINT "(it's almost impossible). The sounds"
LOCATE 10, 3
PRINT "can be turned on/off if they are too"
LOCATE 11, 3
PRINT "loud or you don't like them. If your"
LOCATE 12, 3
PRINT "score is greater than the Highscore,"
LOCATE 13, 3
PRINT "it will be remembered until somebody"
LOCATE 14, 3
PRINT "achieves a score that is even higher"
LOCATE 15, 3
PRINT "than yours. If you want to reset the"
LOCATE 16, 3
PRINT "Hiscore, press tilde(~) at the menu."
LOCATE 17, 3
PRINT "   Good luck and happy playing !!   "
COLOR 6
LOCATE 19, 3
PRINT "Page 2 - Any key exits the game help"
PALETTE 6, 15
SLEEP 0
GOSUB sfx2
PALETTE 6, 0
COLOR 9
LOCATE 2, 1
FOR i = 1 TO 19
PRINT CHR$(186);
COLOR 15
PRINT STRING$(38, 32);
COLOR 9
PRINT CHR$(186);
NEXT i
GOTO 3
ENDR:
STOP
savecfg:
OPEN path$ + "lett_eat.cfg" FOR OUTPUT AS #1
WRITE #1, hiscore
WRITE #1, hiname$
WRITE #1, sounds
CLOSE #1
RETURN
loadconfig:
OPEN path$ + "lett_eat.cfg" FOR INPUT AS #1
INPUT #1, hiscore
INPUT #1, hiname$
INPUT #1, sounds
CLOSE #1
RETURN
theend:
COLOR 15
LOCATE 11, 16
PRINT " GOTCHA ! "
FOR j = 1 TO 10
FOR i = 1 TO 5000
NEXT i
NEXT j
COLOR 9
LOCATE 2, 1
FOR i = 1 TO 19
PRINT CHR$(186);
COLOR 15
PRINT STRING$(38, 32);
COLOR 9
PRINT CHR$(186);
NEXT i
IF score > hiscore THEN GOTO entname
RETURN
entname:
hiscore = score
COLOR 9
LOCATE 2, 1
FOR i = 1 TO 19
PRINT CHR$(186);
COLOR 15
PRINT STRING$(38, 32);
COLOR 9
PRINT CHR$(186);
NEXT i
hiname$ = "      "
COLOR 15
LOCATE 3, 16
PRINT "Well done!"
LOCATE 6, 10
PRINT "You beat the highscore"
LOCATE 7, 10
PRINT "Please enter your name"
LOCATE 11, 18
PRINT "------"
posn = 1
reent:
LOCATE 10, 18
PRINT hiname$
v$ = UCASE$(INKEY$)
IF v$ >= " " AND v$ <= "Z" THEN MID$(hiname$, posn, 1) = v$: posn = posn + 1: GOSUB sfx1
IF v$ = CHR$(8) AND posn > 1 THEN MID$(hiname$, posn - 1, 1) = " ": GOSUB sfx2: posn = posn - 1
IF v$ <> CHR$(13) AND posn < 7 THEN GOTO reent
LOCATE 10, 18
PRINT hiname$
GOSUB sfx2
COLOR 9
LOCATE 2, 1
FOR i = 1 TO 19
PRINT CHR$(186);
COLOR 15
PRINT STRING$(38, 32);
COLOR 9
PRINT CHR$(186);
NEXT i
RETURN
getsysspeed:
LOCATE 10, 15
PRINT "PLEASE WAIT"
t$ = TIME$
syss = 0
WHILE t$ = TIME$
WEND
t$ = TIME$
WHILE t$ = TIME$
syss = syss + 1
WEND
RETURN
delay:
FOR std = 1 TO syss / 10
NEXT std
RETURN
sfx1:
IF sounds = 0 THEN FOR hy = 1 TO 300: NEXT hy: RETURN
FOR si = 1 TO 30
wt = syss / (si * 120)
OUT &H61, 2 * sounds
FOR std = 1 TO wt: NEXT std
OUT &H61, 0
FOR std = 1 TO wt: NEXT std
wt = syss / (si * 60)
OUT &H61, 2 * sounds
FOR std = 1 TO wt: NEXT std
OUT &H61, 0
FOR std = 1 TO wt: NEXT std
NEXT si
RETURN
sfx2:
FOR si = 30 TO 1 STEP -1
wt = syss / (si * 120)
OUT &H61, 2 * sounds
FOR std = 1 TO wt: NEXT std
OUT &H61, 0
FOR std = 1 TO wt: NEXT std
wt = syss / (si * 60)
OUT &H61, 2 * sounds
FOR std = 1 TO wt: NEXT std
OUT &H61, 0
FOR std = 1 TO wt: NEXT std
NEXT si
RETURN
sfx3:
FOR si = 1 TO 1500
OUT &H61, stat(si)
IF si AND 3 = 0 THEN FOR std = 1 TO syss / 15000: NEXT std
NEXT si
RETURN

