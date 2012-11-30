/* graftrav.c -- Grupa: 311CB -- Nume: Dinu Cristian Mircea -- Materia: II */

/* Unitate pentru grafica specifica acestui joc. Aici sunt tinute functii
   de nivel MEDIU (nu folosesc direct variabilele globale ale jocului). */

#include <string.h>
#include "graftrav.h"
#include "datetrav.h"
#include "graftext.h"
#include "graftext.c"

void PutSAt(char *memvid, int x, int y, const char *stg, int atr)
/* Printeaza un string in memoria video (x = -1 pt mesaj centrat orizontal),
   cu atributele atr. Culoarea curenta se AND-uieste cu byte-ul superior al
   atributului si se OR-uieste cu cel inferior.  */
{
    register int *iptr;
    register unsigned char c;

    if (x < 0) x = (80 - strlen(stg)) >> 1;
    iptr = (int*) memvid + ((80 * y) + x);
    while (c = *(stg++))
        *(iptr++) = (*iptr) & atr & 0xFF00 | (atr << 8) | c;
}

void PutCAt(char *memvid, int x, int y, unsigned char c, int atr)
/* Pune caracterul c la locatia x, y cu atributul atr, facand verificari
   NUMAI pe coordonata x. */
{
    register int *iptr = (int*) memvid + ((80 * y) + x);

    if ((x < 0) || (x >= 80)) return;
    *(iptr++) = (*iptr) & atr & 0xFF00 | (atr << 8) | c;
}

void DesMas(char *memvid, int x, int y, const char *stg, char cul)
/* Deseneaza o masina la (x,y) cu descriptorul in stg. */
/* Cul e culoarea propusa (poate fi override-ata). */
{
    register char *bptr;
    unsigned char c;

    bptr = memvid + (((80 * y) + (x--)) << 1);
    while (c = *(stg++)) {
        if (((++x) < 0) || (x >= 80)) {
            ++bptr; ++bptr; continue;
        }
        *(bptr++) = c | 128;
        *(bptr++) = ((*bptr) & 0xF0) + cul;
    }
}

void DesFundal(char *memvid, const short int BENZIF[])
/* Deseneaza fundalul in memoria video. */
{
    register short int *wptr;
    register short int elem;
    int i, j;

    /* deseneaza toate benzile simple */
    wptr = (short int*) memvid;
    j = 0;
    while (j < 25) {
        elem = BENZIF[j++];
        i = 80; while (i--) *(wptr++) = elem;
    }
    /* traseaza benzile strazii */
    wptr = (short int*) memvid + (i = 80) * 15;
    while (i--) *(wptr++) = (i & 2) ? CA_BANDA + 0x0E00 : 0x0E00;
    wptr += (i = 80);
    while (i--) *(wptr++) = (i & 2) ? CA_2BENZI + 0x0E00 : 0x0E00;
    wptr += (i = 80);
    while (i--) *(wptr++) = (i & 2) ? CA_BANDA + 0x0E00 : 0x0E00;
    /* titlu */
    PutSAt(memvid, -1, 0, "Traversare v1.8", ATR_TRANS);
    PutSAt(memvid, -1, 1, "Realizat de Dinu Cristian Mircea, Nov 2004",
           ATR_TRANS);
    PutSAt(memvid, 0, 23, " SCOR:        VIETI:   TIMP:                    "
                          "         NIVEL:   RECORD:       ", ATR_TRANS);
}

void InitGraf(const char* adrfont)
/* Initializeaza modul video si incarca fontul. */
{
    InitVideo();
    IncarcaFont(adrfont, NUMCARACT, 160);
}

void SetPaleta(int pale)
/* Seteaza paleta. */
{
    unsigned char palete[2][16] = {
        { 000, 001, 002, 003, 004, 005, 024, 007,
          070, 071, 072, 073, 074, 075, 076, 077 },
        { 000, 011, 002, 013, 004, 005, 024, 007,
          046, 031, 022, 033, 044, 055, 066, 077 }
    };
    int i;

    for (i = 0; i < 16; i++) DefCuloare(i, palete[pale][i]);
}

int IaCaract(char *memvid, int x, int y)
/* Ia caracterul si atributul de la x, y. */
{
    return *((int*) memvid + x + (80 * y));
}

void Dreptunghi(char *memvid, int x, int y, int u, int v, int tipar)
/* Deseneaza un dreptunghi intre (x,y)-(u,v) inclusiv, cu tiparul tipar. Daca
   x>u sau y>v, nu se deseneaza nimic. Alte verificari nu se fac ! Un 'tipar'
   este o pereche caracter-atribut (caracterul e in byte-ul inferior). */
{
    register int *iptr = ((int*) memvid) + (x + (y * 80));
    register int *maxip;

    if ((x > u) || (y > v)) return;
    while (y++ <= v) {
        *iptr = tipar;
        maxip = iptr + (u - x) + 1;
        while (iptr != maxip) *(iptr++) = tipar;
        iptr += 79 - (u - x);
    }
}

void Cataplof(char* memvid, int x, int y, int s, int tipar, int anti)
/* Un efect vizual in jurul unui punct x, y, de progresie s (80 e maximul),
   cu tiparul vizual tipar, si un parametru suplimentar anti. Daca s>80, se
   considera maxim 80. */
{
    int r = (s > 80) ? 80 : s;
    int a = (double) x * (1 - (double) r/80);
    int b = 2 + (double) (y-2) * (1 - (double) r/80);
    int c = x + (double) (79-x) * ((double) r/80);
    int d = y + (double) (22-y) * ((double) r/80);

    switch (anti) {
        case 0: Dreptunghi(memvid, a, b, c, d, tipar);
                break;
        case 1: Dreptunghi(memvid, 0, 2, 79, b - 1, tipar);
                Dreptunghi(memvid, 0, d + 1, 79, 22, tipar);
                Dreptunghi(memvid, 0, b,  a - 1,  d, tipar);
                Dreptunghi(memvid, c + 1, b, 79,  d, tipar);
    }
}

void CorAtr(char *memvid, int x, int y, int atr)
/* Functie interna. Corecteaza atributul de la x, y si verifica coord. */
{
    register int *iptr = (int*) memvid + ((80 * y) + x);

    if ((x < 0) || (x > 79) || (y < 2) || (y > 22)) return;
    *(iptr++) = (*iptr) & atr & 0xFFFF | (atr << 8);
}

void Evidentiere(char *memvid, int x, int y, int dx, int dy, int cul)
/* Evidentiere (un dreptunghi de culoare cul), in jurul unui punct x, y. */
{
    int i;

    for (i = -dx; i <= dx; i++) {
        CorAtr(memvid, x + i, y - dy, cul);
        CorAtr(memvid, x + i, y + dy, cul);
    }

    for (i = -dy; i <= dy; i++) {
        CorAtr(memvid, x - dx, y + i, cul);
        CorAtr(memvid, x - dx + 1, y + i, cul);
        CorAtr(memvid, x + dx - 1, y + i, cul);
        CorAtr(memvid, x + dx, y + i, cul);
    }
}

void GataGraf(void)
/* Wrapper pentru GataVideo(). */
{
    GataVideo();
}

void GataCadru(char *memvid)
/* Wrapper pentru Comite(). */
{
    Comite(memvid);
}