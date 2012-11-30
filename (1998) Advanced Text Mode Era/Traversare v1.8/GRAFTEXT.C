/* graftext.c -- Grupa: 311CB -- Nume: Dinu Cristian Mircea -- Materia: II */

/* Unitate pentru grafica in mod text. Functiile nu sunt portabile. */

#include <conio.h>
#include "x86stub.h"

void SetLinii(unsigned char lin)
/* Seteaza numarul de scanlines in mod text. */
{
    union REGS regs;

    regs.h.ah = 0x12; /* 12h: Functii speciale */
    regs.h.bl = 0x30; /* Seteaza nr. de scanlines in mod text */
    regs.h.al = lin;  /* 0 = 200, 1 = 350, 2 = 400 */
    int86(0x10, &regs, &regs);
}

void ModText(unsigned char mod)
/* Seteaza modul text (nu e echivalent cu textmode). */
{
    union REGS regs;

    regs.h.ah = 0x00; /* 00h: Seteaza mod video */
    regs.h.al = mod;
    int86(0x10, &regs, &regs);
}

void SetClipi(unsigned char cli)
/* Activeaza clipirea caracterelor cand bitul 7 al atributului e 1. Daca
   clipirea e dezactivata, putem avea 16 culori pt fundal. */
{
    union REGS regs;

    regs.x.ax = 0x1003; /* 10h: Functii paleta, 03h: Seteaza clipire */
    regs.h.bl = cli;
    int86(0x10, &regs, &regs);
}

void FaraCursor(void)
/* Inlatura cursorul. */
{
    union REGS regs;

    regs.h.ah = 0x01; /* Seteaza dimensiunea cursorului */
    regs.h.ch = 0x20; /* Scanline inceput: 20h (fara cursor) */
    int86(0x10, &regs, &regs);
}

void IncarcaFont(const char* adrfont, unsigned char car, unsigned char prim)
/* Incarca fontul aflat la adresa adrfont, acolo fiind definite car caractere,
   primul corespunzand codului ASCII prim. */
{
    struct REGPACK regp;

    regp.r_ax = 0x1100; /* 11h: Functii font, 00h: Incarca font */
    regp.r_bx = 0x1000; /* 10h: Inaltime 16, 00h: Blocul 0 (curent) */
    regp.r_cx = car;
    regp.r_dx = prim;
    regp.r_es = ((unsigned long) adrfont) >> 16;
    regp.r_bp = ((unsigned long) adrfont) & 0xffff;

    intr(0x10, &regp);
}

void DefCuloare(unsigned char idx, unsigned char rgbRGB)
/* Redefineste culoarea cu indexul idx la specificatorul rgbRGB. */
{
    union REGS regs;

    regs.x.ax = 0x1000; /* 10h: Functii paleta, 00h: Seteaza un registru */
    regs.h.bl = idx;
    regs.h.bh = rgbRGB;
    int86(0x10, &regs, &regs);
}

unsigned char CitCuloare(unsigned char idx)
/* Citeste culoarea cu indexul idx, returnand specificatorul rgbRGB. */
{
    union REGS regs;

    regs.x.ax = 0x1007; /* 10h: Functii paleta, 07h: Citeste un registru */
    regs.h.bl = idx;
    int86(0x10, &regs, &regs);
    return regs.h.bh;
}

void InitVideo(void)
/* Initializeaza modul video. */
{
    SetLinii(1);
    ModText(3);
    SetClipi(0);
    FaraCursor();
}

void GataVideo(void)
/* Dezinitializeaza modul video. */
{
    SetLinii(2);
    ModText(3);
}

void Comite(char *memvid)
/* Pune datele dintr-o memorie video efectiv pe ecran. */
{
    puttext(1, 1, 80, 25, memvid);
}