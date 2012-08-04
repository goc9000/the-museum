size = 24
DIM t(576)
DIM p(24, 24)                   'Pentru a rula programul apasa Shift+F5
has = 10                         'Daca apare vreo eroare si nu ti-ai salvat
                                'sprite-ul curent, apasa F6 ca sa treci in
                                'fereastra Immediate si scrie acolo:
                                'GOTO 1 si apasa <enter>. Paleta va aparea
                                '"busita" dar nu te speria si incearca sa
                                'salvezi din nou (citeste in text)
                                'Tot cu F6 revii la fereastra normala.
proto = 0
path$ = "C:\GRAPHICS\"          'Inlocuieste sirul acesta cu calea spre"
                                'directorul in care isi va tine imaginile
                                'jocul tau. Exemplu:
                                'path$ = "C:\STEFAN\PROIECTE\SPR\"
file$ = "untitled"
DIM h(576)
DIM e(576)
hres = 0
SCREEN 13 - hres
sizx = 24
sizy = 24
jojo = 0
x = 0
y = 0
DIM n(sizx + 1, sizy + 1)
DIM q(sizx + 1, sizy + 1)
DIM w(sizx * sizy)
DIM f(sizx, sizy)
DIM x(32, 32)
DIM u(sizx, sizy)
DIM a(576)
DIM s(576)
DIM d(576)
DIM g(576)
CLS
FOR i = 0 TO 255
OUT &H3C8, i
OUT &H3C9, 0
OUT &H3C9, 0
OUT &H3C9, 0
NEXT i
GET (0, 0)-(23, 23), x
GET (0, 0)-(23, 23), u
FOR i = 1 TO sizx
x = x + 7
FOR j = 1 TO sizy
y = y + 7
LINE (x, y)-(x + 7, y + 7), 20, B
NEXT j
y = 0
NEXT i
realx = 1
realy = 1
curcol = 16
ccdir = 2
FOR i = 7 TO 180 STEP 56
LINE (i, 7)-(i, 175), 15
LINE (7, i)-(175, i), 15
NEXT i
colour = 0
bright = 0
GOSUB restorepalette
LINE (180, 9)-(274, 70), 26, B
LINE (178, 7)-(276, 72), 20, B
linex = 255
liney = 255
radius = 11


REM GOTO yuu
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
OUT &H3C9, i * 8
OUT &H3C8, 32 + i
OUT &H3C9, 0
OUT &H3C9, i * 8
OUT &H3C9, 0
OUT &H3C8, 48 + i
OUT &H3C9, 0
OUT &H3C9, i * 8
OUT &H3C9, i * 8
OUT &H3C8, 64 + i
OUT &H3C9, i * 8
OUT &H3C9, 0
OUT &H3C9, 0
OUT &H3C8, 80 + i
OUT &H3C9, i * 8
OUT &H3C9, 0
OUT &H3C9, i * 8
OUT &H3C8, 96 + i
OUT &H3C9, i * 8
OUT &H3C9, i * 4
OUT &H3C9, 0
OUT &H3C8, 112 + i
OUT &H3C9, i * 8
OUT &H3C9, i * 8
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
OUT &H3C9, 63
OUT &H3C9, 35 + i * 4
OUT &H3C9, i * 9
OUT &H3C8, 112 + 8 + i
OUT &H3C9, 63
OUT &H3C9, 63
OUT &H3C9, i * 9
NEXT i

GOTO lpo
yuu:
GOSUB restorebyimage
OPEN "C:\GRAPHICS\spec128.pal" FOR INPUT AS #1
h = 1
FOR i = 0 TO 127
a$ = INPUT$(1, 1)
er = ASC(a$)
a$ = INPUT$(1, 1)
ge = ASC(a$)
a$ = INPUT$(1, 1)
be = ASC(a$)
OUT &H3C8, i
OUT &H3C9, er
OUT &H3C9, ge
OUT &H3C9, be
NEXT i
CLOSE #1
lpo:
1
GET (201, 79)-(216, 79 + 15), t
IF tile = 1 THEN PUT (200, 20), t, PSET
IF tile = 1 THEN PUT (216, 20), t, PSET
IF tile = 1 THEN PUT (200, 36), t, PSET
IF tile = 1 THEN PUT (216, 36), t, PSET
cholor = (colour * 16) + bright
LINE (201, 112)-(224, 136), filc, BF
LINE (200, 111)-(225, 137), filb, B
LINE (199, 110)-(226, 138), 20, B
LINE (240, 77)-(268, 104), 20, B
LINE (240, 110)-(268, 138), 20, B
PUT (242, 112), u, PSET
PUT (242, 79), x, PSET
gridx = realx * 7
gridy = realy * 7
lgridx = linex * 7
lgridy = liney * 7
LINE (gridx + 1, gridy + 1)-(gridx + 6, gridy + 6), 0, B
v$ = INKEY$
IF v$ = "*" THEN GOSUB ksave
IF v$ = "$" THEN GOSUB merge
IF v$ = "\" THEN GOSUB dismerge
IF v$ = "%" THEN tile = 1 - tile
IF v$ = ")" THEN GOSUB exclude
IF v$ = "F" THEN GOSUB fisiere
IF v$ = "<" THEN radius = 10
IF v$ = "m" THEN GET (200, 79)-(225, 102), u
IF v$ = "U" THEN PUT (200, 79), u, PSET: GOSUB restorebyimage
IF v$ = "N" THEN GOSUB clr: file$ = "untitled"
IF v$ = "W" THEN GOSUB wetpaint
IF v$ = "`" THEN GOSUB spray
IF v$ = "~" THEN GOSUB sprayn
IF v$ = "!" THEN GOSUB statick
IF v$ = "v" THEN GOSUB flipv
IF v$ = "h" THEN GOSUB fliph
IF v$ = "p" THEN realx = realx + 1
IF v$ = "o" THEN realx = realx - 1
IF v$ = "a" THEN realy = realy + 1
IF v$ = "q" THEN realy = realy - 1
IF v$ = "E" THEN GOSUB regress
IF v$ = "l" THEN GOSUB load
IF v$ = "H" THEN fg = 1: GOSUB animat
IF v$ = "A" THEN fg = 0: GOSUB animat
IF v$ = "j" THEN filc = cholor
IF v$ = "k" THEN filb = cholor
IF realx > sizx THEN realx = sizx
IF realy > sizy THEN realy = sizy
IF realx < 1 THEN realx = 1
IF realy < 1 THEN realy = 1
gridx = realx * 7
gridy = realy * 7
LINE (gridx + 1, gridy + 1)-(gridx + 6, gridy + 6), curcol, B
IF linex <> 255 AND liney <> 255 THEN LINE (lgridx + 1, lgridy + 1)-(lgridx + 6, lgridy + 6), curcol, B
curcol = curcol + ccdir
IF curcol > 31 THEN curcol = 31: ccdir = -4
IF curcol < 20 THEN curcol = 20: ccdir = 4
IF v$ = "" THEN GOTO skipcol
IF ASC(v$) > 47 AND ASC(v$) < 56 THEN colour = (ASC(v$) - 48): GOSUB restorepalette
skipcol:
IF v$ = "w" AND linex = 255 THEN linex = realx: liney = realy
IF v$ = "L" AND linex <> 255 THEN GOSUB linet
IF v$ = "O" AND linex <> 255 THEN GOSUB circlet
IF v$ = "@" AND linex <> 255 THEN GOSUB linetbr
IF v$ = "#" AND linex <> 255 THEN GOSUB linetdr
IF v$ = "r" AND linex <> 255 THEN GOSUB rect
IF v$ = "R" AND linex <> 255 THEN GOSUB frect
IF v$ = "_" THEN GOSUB midget
IF v$ = CHR$(13) THEN GOSUB eyedrop
IF v$ = CHR$(8) AND linex <> 255 THEN GOSUB clearm
IF v$ = "X" AND linex <> 255 THEN GOSUB cut:
IF v$ = "C" AND linex <> 255 THEN GOSUB copym:
IF v$ = "V" THEN GOSUB paste
IF v$ = ">" THEN GOSUB rotate
IF v$ = "+" THEN bright = bright + 1: GOSUB restorepalette
IF bright > 15 THEN bright = 15
IF bright < 0 THEN bright = 0
IF v$ = "-" THEN bright = bright - 1: GOSUB restorepalette
LINE (199, 77)-(226, 104), 17, B
IF v$ = " " THEN GOSUB plot
IF v$ = "M" THEN GOSUB mutate

IF v$ = "e" THEN GOSUB embold
IF v$ = "Z" THEN GOSUB skew
IF v$ = "s" THEN GOTO process
IF v$ = "f" THEN GOSUB fill
IF v$ = "i" THEN GOSUB zed
IF v$ = "I" THEN GOSUB interchange
IF v$ = "d" THEN GOSUB darken
IF v$ = "b" THEN GOSUB lighten
IF v$ = CHR$(27) THEN GOTO 99
IF v$ = "G" THEN GOSUB grayscale
IF v$ = "g" THEN GOSUB ungrayscale
LOCATE 23, 2
COLOR 28 - (20 * hres)
PRINT file$; " ("; size; ")         "
GOSUB restorepalette
GOTO 1
eyedrop:
getcol = q(realx, realy)
colour = FIX(getcol / 16)
bright = getcol MOD 16
RETURN
plot:
LINE (gridx + 2, gridy + 2)-(gridx + 6, gridy + 6), cholor, BF
IF cholor = 0 THEN LINE (gridx + 2, gridy + 2)-(gridx + 6, gridy + 6), 4
q(realx, realy) = cholor: PSET (200 + realx, 78 + realy), cholor
RETURN
midget:
FOR i = 2 TO 24 STEP 2
FOR j = 2 TO 24 STEP 2
p(i / 2, j / 2) = q(i, j)
NEXT j
NEXT i
FOR i = 1 TO 12
FOR j = 1 TO 12
q(i, j) = p(i, j)
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN
exclude:
FOR i = 1 TO 24
FOR j = 1 TO 24
IF q(i, j) <> cholor THEN q(i, j) = 0
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN

skew:
FOR i = 1 TO 24
FOR j = 1 TO 24
n(j, i) = 0
NEXT j
NEXT i

FOR i = 1 TO 1
g = 1
FOR j = 7 TO 24
n(g, i) = q(j, i)
g = g + 1
NEXT j
NEXT i
FOR i = 2 TO 3
g = 1
FOR j = 6 TO 24
n(g, i) = q(j, i)
g = g + 1
NEXT j
NEXT i
FOR i = 4 TO 5
g = 1
FOR j = 5 TO 24
n(g, i) = q(j, i)
g = g + 1
NEXT j
NEXT i
FOR i = 6 TO 7
g = 1
FOR j = 4 TO 24
n(g, i) = q(j, i)
g = g + 1
NEXT j
NEXT i
FOR i = 8 TO 9
g = 1
FOR j = 3 TO 24
n(g, i) = q(j, i)
g = g + 1
NEXT j
NEXT i
FOR i = 10 TO 11
g = 1
FOR j = 2 TO 24
n(g, i) = q(j, i)
g = g + 1
NEXT j
NEXT i
FOR i = 12 TO 13
g = 1
FOR j = 1 TO 24
n(g, i) = q(j, i)
g = g + 1
NEXT j
NEXT i
FOR i = 14 TO 15
g = 2
FOR j = 1 TO 23
n(g, i) = q(j, i)
g = g + 1
NEXT j
NEXT i
FOR i = 16 TO 17
g = 3
FOR j = 1 TO 22
n(g, i) = q(j, i)
g = g + 1
NEXT j
NEXT i
FOR i = 18 TO 19
g = 4
FOR j = 1 TO 21
n(g, i) = q(j, i)
g = g + 1
NEXT j
NEXT i
FOR i = 20 TO 21
g = 5
FOR j = 1 TO 20
n(g, i) = q(j, i)
g = g + 1
NEXT j
NEXT i
FOR i = 22 TO 23
g = 6
FOR j = 1 TO 19
n(g, i) = q(j, i)
g = g + 1
NEXT j
NEXT i
FOR i = 24 TO 24
g = 7
FOR j = 1 TO 18
n(g, i) = q(j, i)
g = g + 1
NEXT j
NEXT i






FOR i = 1 TO 24
FOR j = 1 TO 24
q(j, i) = n(j, i)
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN




circlet:
cirx = INT(realx + linex) / 2
ciry = INT(realy + liney) / 2
radius = ABS(realy - ciry)
CIRCLE (201 + cirx, 78 + ciry), radius, cholor, , , 1
GOSUB restorebyimage
RETURN
restorepalette:
FOR k = 0 TO 7
FOR l = 0 TO 15
px = (200 + l * 5)
py = (150 + k * 5)
sel = 0
IF colour = k AND bright = l THEN sel = 1
IF sel = 0 THEN LINE (px + 1, py + 1)-(px + 4, py + 4), (k * 16) + l, BF
IF sel = 1 THEN LINE (px + 1, py + 1)-(px + 4, py + 4), curcol, B
NEXT l
NEXT k
RETURN
process:
GET (201, 79)-(224, 102), w
LOCATE 3, 27
COLOR 2
PRINT "SAVE"
LOCATE 4, 25
COLOR 15
PRINT "Filename:";
LOCATE 5, 25
INPUT "", p$
LOCATE 6, 25
PRINT "Size:"
LOCATE 7, 25
INPUT "", size
LOCATE 4, 25
PRINT "          "
LOCATE 5, 25
PRINT "          "
LOCATE 6, 25
PRINT "          "
LOCATE 7, 25
PRINT "        "
LOCATE 3, 27
PRINT "    "
IF p$ = "" THEN GOTO 1
OPEN path$ + p$ + ".spr" FOR OUTPUT AS #1
t$ = ""
FOR i = 1 TO size
FOR j = 1 TO size
IF q(j, i) = 27 THEN q(j, i) = 28
writ = q(j, i)
PRINT #1, CHR$(writ);
NEXT j
NEXT i
CLOSE #1
file$ = p$
IF ask = 1 THEN RUN
GOTO 1
ksave:
p$ = file$
OPEN path$ + p$ + ".spr" FOR OUTPUT AS #1
t$ = ""
FOR i = 1 TO size
FOR j = 1 TO size
IF q(j, i) = 27 THEN q(j, i) = 28
writ = q(j, i)
PRINT #1, CHR$(writ);
NEXT j
NEXT i
CLOSE #1
file$ = p$
IF ask = 1 THEN RUN
GOTO 1
load:
COLOR 12
LOCATE 3, 27
PRINT "LOAD"
COLOR 15
LOCATE 4, 25
PRINT "Filename? "
LOCATE 5, 25
INPUT "", n$
LOCATE 4, 25
PRINT "          "
LOCATE 5, 25
PRINT "          "
LOCATE 3, 27
PRINT "    "
IF n$ = "" THEN GOTO 1
OPEN path$ + n$ + ".spr" FOR INPUT AS #1
FOR i = 1 TO 24
FOR j = 1 TO 24
PSET (200 + j, 78 + i), 0
NEXT j
NEXT i
si = 0
WHILE NOT EOF(1)
ryt = ASC(INPUT$(1, 1))
si = si + 1
WEND
SEEK #1, 1
size = SQR(si)
FOR i = 1 TO size
FOR j = 1 TO size
IF EOF(1) THEN GOTO ioo:
ryt = ASC(INPUT$(1, 1))
ioo:
PSET (200 + j, 78 + i), ryt
NEXT j
NEXT i
CLOSE #1
file$ = n$
inv = 0
restorebyimage:
LINE (200, 78)-(225, 103), 0, B
FOR i = 1 TO 24
FOR j = 1 TO 24
k = POINT(200 + i, 78 + j)
q(i, j) = k
gridx = i * 7
gridy = j * 7
IF q(i, j) <> -1 THEN LINE (gridx + 2, gridy + 2)-(gridx + 5, gridy + 5), k, BF
IF q(i, j) = 0 THEN LINE (gridx + 2, gridy + 2)-(gridx + 5, gridy + 5), 4
NEXT j
NEXT i
RETURN
restorebymatrix:
FOR i = 1 TO 24
FOR j = 1 TO 24
gridx = i * 7
gridy = j * 7
LINE (gridx + 2, gridy + 2)-(gridx + 5, gridy + 5), q(i, j), BF
IF q(i, j) = 0 THEN LINE (gridx + 2, gridy + 2)-(gridx + 5, gridy + 5), 4
PSET (200 + i, 78 + j), q(i, j)
NEXT j
NEXT i
RETURN
clr:
FOR i = 1 TO 24
FOR j = 1 TO 24
q(i, j) = 0
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN
flipv:
FOR i = 1 TO 24
FOR j = 1 TO 24
f(i, j) = q(i, 25 - j)
NEXT j
NEXT i
FOR i = 1 TO 24
FOR j = 1 TO 24
q(i, j) = f(i, j)
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN
fliph:
FOR i = 1 TO 24
FOR j = 1 TO 24
f(i, j) = q(25 - i, j)
NEXT j
NEXT i
FOR i = 1 TO 24
FOR j = 1 TO 24
q(i, j) = f(i, j)
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN
linet:
LINE (200 + linex, 78 + liney)-(200 + realx, 78 + realy), cholor
GOSUB restorebyimage
IF linex <> 255 AND liney <> 255 THEN LINE (lgridx + 1, lgridy + 1)-(lgridx + 6, lgridy + 6), 0, B
linex = 255: liney = 255
RETURN
linetbr:
LINE (200 + linex, 78 + liney)-(200 + realx, 78 + realy), 199
FOR i = 1 TO 24
FOR j = 1 TO 24
IF POINT(200 + i, 78 + j) = 199 THEN q(i, j) = q(i, j) + 1
NEXT j
NEXT i
GOSUB restorebymatrix
GOSUB restorebyimage
IF linex <> 255 AND liney <> 255 THEN LINE (lgridx + 1, lgridy + 1)-(lgridx + 6, lgridy + 6), 0, B
linex = 255: liney = 255
RETURN
linetdr:
LINE (200 + linex, 78 + liney)-(200 + realx, 78 + realy), 199
FOR i = 1 TO 24
FOR j = 1 TO 24
IF POINT(200 + i, 78 + j) = 199 THEN q(i, j) = q(i, j) - 1
NEXT j
NEXT i
GOSUB restorebymatrix
GOSUB restorebyimage
IF linex <> 255 AND liney <> 255 THEN LINE (lgridx + 1, lgridy + 1)-(lgridx + 6, lgridy + 6), 0, B
linex = 255: liney = 255
RETURN
99
CLS
STOP
fill:
LINE (200, 78)-(225, 103), filb, B
PAINT (200 + realx, 78 + realy), filc, filb
LINE (200, 78)-(225, 103), 0, B
GOSUB restorebyimage
RETURN
zed:
FOR i = 1 TO 24
FOR j = 1 TO 24
IF q(i, j) = filb THEN q(i, j) = filc
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN
mutate:
filbr = (FIX(filb / 16)) * 16
filcl = (FIX(filc / 16)) * 16
dif = (filc MOD 16) - (filb MOD 16)
FOR l = 0 TO 15
FOR i = 1 TO 24
FOR j = 1 TO 24
IF q(i, j) = filbr + l THEN q(i, j) = filcl + (l + dif)
NEXT j
NEXT i
NEXT l
GOSUB restorebymatrix
RETURN
lighten:
FOR i = 1 TO 24
FOR j = 1 TO 24
IF q(i, j) = 0 THEN GOTO skipthis
IF ((q(i, j) + 1) MOD 16) = 0 THEN GOTO skipthis
q(i, j) = q(i, j) + 1
skipthis:
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN
darken:
FOR i = 1 TO 24
FOR j = 1 TO 24
IF q(i, j) = 0 THEN GOTO gskipthis
q(i, j) = q(i, j) - 1
gskipthis:
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN
clearm:
LINE (gridx + 1, gridy + 1)-(gridx + 6, gridy + 6), 0, B
LINE (200 + linex, 78 + liney)-(200 + realx, 78 + realy), 0, BF
GOSUB restorebyimage
IF linex <> 255 AND liney <> 255 THEN LINE (lgridx + 1, lgridy + 1)-(lgridx + 6, lgridy + 6), 0, B
realx = linex
realy = liney
linex = 255: liney = 255
RETURN

cut:
LINE (gridx + 1, gridy + 1)-(gridx + 6, gridy + 6), 0, B
GOSUB clearclip
GET (200 + linex, 78 + liney)-(200 + realx, 78 + realy), x
LINE (200 + linex, 78 + liney)-(200 + realx, 78 + realy), 0, BF
GOSUB restorebyimage
IF linex <> 255 AND liney <> 255 THEN LINE (lgridx + 1, lgridy + 1)-(lgridx + 6, lgridy + 6), 0, B
realx = linex
realy = liney
linex = 255: liney = 255
RETURN
copym:
LINE (gridx + 1, gridy + 1)-(gridx + 6, gridy + 6), 0, B
GOSUB clearclip
GET (200 + linex, 78 + liney)-(200 + realx, 78 + realy), x
IF linex <> 255 AND liney <> 255 THEN LINE (lgridx + 1, lgridy + 1)-(lgridx + 6, lgridy + 6), 0, B
realx = linex
realy = liney
linex = 255: liney = 255
RETURN
paste:
PUT (200 + realx, 78 + realy), x, PSET
GOSUB restorebyimage
RETURN
clearclip:
LINE (241, 78)-(267, 103), 0, BF
RETURN
rect:
LINE (200 + linex, 78 + liney)-(200 + realx, 78 + realy), cholor, B
GOSUB restorebyimage
IF linex <> 255 AND liney <> 255 THEN LINE (lgridx + 1, lgridy + 1)-(lgridx + 6, lgridy + 6), 0, B
linex = 255: liney = 255
RETURN
frect:
LINE (200 + linex, 78 + liney)-(200 + realx, 78 + realy), cholor, BF
GOSUB restorebyimage
IF linex <> 255 AND liney <> 255 THEN LINE (lgridx + 1, lgridy + 1)-(lgridx + 6, lgridy + 6), 0, B
linex = 255: liney = 255
RETURN
rotate:
FOR i = 1 TO 24
FOR j = 1 TO 24
PSET (200 + (25 - j), 78 + i), q(i, j)
NEXT j
NEXT i
GOSUB restorebyimage
RETURN



spray.off:
FOR i = 1 TO 24
FOR j = 1 TO 24
now = 0
FOR ux = -2 TO 2
FOR uy = -2 TO 2
IF (NOT (ux = 0 AND uy = 0)) AND POINT(200 + i + ux, 78 + j + uy) = cholor THEN now = 1
NEXT uy
NEXT ux
IF now = 0 AND RND > .8 THEN PSET (200 + i, 78 + j), cholor
ynono:
NEXT j
NEXT i
GOSUB restorebyimage
RETURN

spray:
FOR i = 1 TO 24
FOR j = 1 TO 24
IF RND > .6 THEN q(i, j) = cholor
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN
sprayn:
FOR i = 1 TO 24
FOR j = 1 TO 24
IF RND > .9 THEN q(i, j) = cholor
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN


statick:
has = 3
FOR i = 1 TO 24
FOR j = 1 TO 24
t:
plainc = cholor + (INT(RND * has) * 2)
IF inc > proto THEN GOTO allright
IF POINT(199 + i, 78 + j) = plainc THEN inc = inc + 1: GOTO t
IF POINT(200 + i, 77 + j) = plainc THEN inc = inc + 1: GOTO t
IF POINT(199 + i, 77 + j) = plainc THEN inc = inc + 1: GOTO t
IF POINT(199 + i, 79 + j) = plainc THEN inc = inc + 1: GOTO t
allright:
IF POINT(200 + i, 78 + j) = filc THEN PSET (200 + i, 78 + j), plainc
inc = 0
NEXT j
NEXT i
GOSUB restorebyimage
RETURN




animat:
GOSUB load
GET (201, 79)-(224, 103), a
GOSUB load
GET (201, 79)-(224, 103), s
GOSUB load
GET (201, 79)-(224, 103), d
GOSUB load
GET (201, 79)-(224, 103), g
nono:
speed = 100
pleznit = 0
cycle:
PUT (201, 79), a, PSET
FOR h = 1 TO speed * 10
GOSUB ast
NEXT h
PUT (201, 79), s, PSET
FOR h = 1 TO speed * 10
GOSUB ast
NEXT h
PUT (201, 79), d, PSET
FOR h = 1 TO speed * 10
GOSUB ast
NEXT h
IF nolastframe = 1 THEN GOTO hop
PUT (201, 79), g, PSET
FOR h = 1 TO speed * 10
GOSUB ast
NEXT h
hop:
IF fg = 1 THEN LINE (201, 79)-(201 + 15, 79 + 15), 0, BF
IF fg = 1 THEN SLEEP 0
IF pleznit = 0 THEN GOTO cycle
GOSUB restorebymatrix
RETURN
ast:
v$ = INKEY$
IF v$ = CHR$(13) THEN pleznit = 1
IF v$ = "]" THEN speed = speed - 1: IF speed < 0 THEN speed = 0
IF v$ = "[" THEN speed = speed + 1: IF speed > 1000 THEN speed = 1000
RETURN
interchange:
bord = filb
fill = filc
filc = 18
GOSUB zed
filb = fill
filc = bord
GOSUB zed
filb = 18
filc = fill
GOSUB zed
GOSUB restorebyimage
filb = bord
RETURN
grayscale:
FOR i = 1 TO 24
FOR j = 1 TO 24
q(i, j) = q(i, j) + 16
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN
ungrayscale:
FOR i = 1 TO 24
FOR j = 1 TO 24
q(i, j) = q(i, j) - 16
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN
wetpaint:
FOR k = 1 TO 16
FOR i = 1 TO 24
FOR j = 1 TO 24
xori = q(i, j)
jurat = j + 1
IF jurat > 24 THEN jurat = 0
IF RND > .85 THEN q(i, jurat) = xori
NEXT j
NEXT i
NEXT k
GOSUB restorebymatrix
GOSUB restorebyimage
RETURN
fisiere:
DEF SEG = &HA000
BSAVE "temphorr.dat", 0, &HFFFF
CLS
SCREEN 9
LOCATE 1, 1
PRINT "Files and directories in current path:"
FILES path$
SLEEP 0
CLS
SCREEN 13
BLOAD "temphorr.dat", 0
KILL "temphorr.dat"
RETURN
embold:
FOR i = 1 TO 24
FOR j = 1 TO 24
IF q(i, j) > 0 AND q(i, j) <> 254 THEN GOSUB uzi
NEXT j
NEXT i
FOR i = 1 TO 24
FOR j = 1 TO 24
IF q(i, j) = 254 THEN q(i, j) = cholor
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN
uzi:
IF q(i - 1, j) = 0 THEN q(i - 1, j) = 254
IF q(i + 1, j) = 0 THEN q(i + 1, j) = 254
IF q(i, j - 1) = 0 THEN q(i, j - 1) = 254
IF q(i, j + 1) = 0 THEN q(i, j + 1) = 254
RETURN
regress:
FOR i = 1 TO 24
FOR j = 1 TO 24
IF q(i, j) > 0 AND q(i, j) <> 254 THEN GOSUB uziy
NEXT j
NEXT i
FOR i = 1 TO 24
FOR j = 1 TO 24
IF q(i, j) = 254 THEN q(i, j) = cholor
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN
uziy:
IF q(i - 1, j) = 0 THEN q(i, j) = 254
IF q(i + 1, j) = 0 THEN q(i, j) = 254
IF q(i, j - 1) = 0 THEN q(i, j) = 254
IF q(i, j + 1) = 0 THEN q(i, j) = 254
RETURN
merge:
REM 242,79
FOR i = 0 TO 23
FOR j = 0 TO 23
IF q(i + 1, j + 1) = 0 THEN q(i + 1, j + 1) = POINT(242 + i, 79 + j)
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN
dismerge:
REM 242,79
FOR i = 0 TO 23
FOR j = 0 TO 23
IF POINT(242 + i, 79 + j) <> 0 THEN q(i + 1, j + 1) = POINT(242 + i, 79 + j)
NEXT j
NEXT i
GOSUB restorebymatrix
RETURN

