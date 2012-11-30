/* trav.c     -- Grupa: 311CB -- Nume: Dinu Cristian Mircea -- Materia: II */

/* Proiect anul I, semestrul I. Clona Frogger cu ceva adaugiri.

   Instructiuni: ajuta broscuta sa traverseze strada si raul. La nivelele
   superioare, culege chei pentru a deschide usile din partea de sus a
   ecranului. Prinde mustele rosii pentru puncte in plus. Puncte in plus se
   primesc si pentru manevre riscante, adica trecerea prin fata unei masini.*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "datetrav.h"
#include "graftrav.h"
#include "diverse.h"

/* stari joc */
enum { ST_INIT = 0, ST_NORMAL, ST_LOVIT, ST_SUCCES, ST_GATA, ST_DEMO };

void InitCheie(AGlobale joc);
void InitMusca(AGlobale joc);

/* ------------------------------------------------------------------------ */
/*        Grup functii high-level pentru desenarea campului de joc.         */
/* ------------------------------------------------------------------------ */

void DesCase(AGlobale joc)
/* Deseneaza locatiile-destinatie de sus si cheia, daca exista. */
{
    int x = 9, casute = joc->casute;
    char usa[4] = { CA_USA, CA_USA, CA_USA, 0 };

    while (x < 80) {
         if (!(casute & 1))
             PutSAt(joc->memvid, x, 2, joc->cheite ? usa : "   ", ATR_USA);
         casute >>= 1; x += 20;
    }
}

void DesMusca(AGlobale joc)
/* Deseneaza musca daca nu suntem in mod demonstrativ. */
{
    if ((joc->musc < TI_MUSCA) && (joc->vieti) && (!(joc->contor & 16)))
        PutCAt(joc->memvid, joc->musx, joc->musy, CA_MUSCA, ATR_MUSCA);
}

void DesCheie(AGlobale joc)
/* Deseneaza cheia daca nu suntem in mod demonstrativ. */
{
    int d = joc->chec >> 4;

    if ((joc->cheite) && (joc->vieti)) {
        if (joc->chec)
            Evidentiere(joc->memvid, joc->chex, joc->chey, 1 + (d << 1), d,
                        0x00FF);
        if (joc->contor & 16)
            PutCAt(joc->memvid, joc->chex, joc->chey, CA_CHEIE, ATR_CHEIE);
    }
}

int DesBroasca(AGlobale joc)
/* Deseneaza broasca si returneaza 1 daca aceasta a fost lovita. */
{
    int car = (IaCaract(joc->memvid, joc->brox, joc->broy) & 0x00FF);
    int lovit = ((car != ' ') && (car != CA_CHEIE) && (car != CA_MUSCA));

    if (joc->vieti) {
        PutCAt(joc->memvid, joc->brox, joc->broy, CA_BROASCA1 + (joc->moriz
               != 0), ATR_BROASCA);
    }
    return lovit;
}

void ScrieScor(AGlobale joc)
/* Scrie informatiile (scor, vieti, etc.) din bara din partea de jos a
   ecranului. */
{
    char descris[30];

    PutCAt(joc->memvid, 20, 23, 48 + joc->vieti, ATR_SCOR); /* vieti */
    PutCAt(joc->memvid, 63, 23, 48 + (joc->vieti ? joc->nivel : joc->nivels),
           ATR_SCOR); /* nivel */
    memset(descris, CA_TIMP, 30); /* timpul */
    *(descris + (int)((double) (joc->vieti ? joc->timp : 0) /
        joc->timpmax * 27.9)) = 0;
    PutSAt(joc->memvid, 28, 23, descris, ATR_SCOR);
    sprintf(descris, "%06li", joc->scor); /* scor */
    PutSAt(joc->memvid, 6, 23, descris, ATR_SCOR);
    sprintf(descris, "%06li", joc->record); /* record */
    PutSAt(joc->memvid, 73, 23, descris, ATR_SCOR);
}

void ScrieMesaje(AGlobale joc)
/* Scrie mesajele de joc. */
{
    static const char* mesaje[NUMINSTRUCT] = {
        "Apasa SPATIU pentru a incepe jocul",
        "Apasa N pentru a alege nivelul de pornire",
        "Apasa C pentru a schimba culorile",
        "Apasa P pentru a face o pauza de la joc",
        "Ajuta broscuta sa traverseze strada si raul",
        "Culege cheile pentru a descuia iesirile",
        "Prinde mustele pentru a castiga puncte"
    };
    char descris[60];
    int i;

    if (joc->gamov) {
        sprintf(descris, "     JOC TERMINAT -- SCOR FINAL: %06li     ", joc->
                scor);
        PutSAt(joc->memvid, -1, 11, descris, 0x00CF);
    }

    if (joc->pauza)
        PutSAt(joc->memvid, -1, 11, "    Pauza - Apasa ENTER pentru a "
            "continua    ", 0x009F);

    if ((joc->stare == ST_NORMAL) && (joc->anuntn & 32)) {
        sprintf(descris, "NIVEL %i", joc->nivel);
        PutSAt(joc->memvid, -1, 12, descris, 0xF009);
    }

    if (joc->stare == ST_DEMO)
        PutSAt(joc->memvid, -1, 12, mesaje[joc->contor >> 9], 0xF000);
}

void DesMasini(AGlobale joc)
/* Deseneaza masinile in memoria video. */
{
    AMasina mas = joc->masini - 1;

    while ((++mas) != joc->ultmas)
        DesMas(joc->memvid, mas->x, mas->b->y, mas->m->desc, mas->c &
               mas->m->ocul | (mas->m->ocul >> 4));
}

void DesAnac(AGlobale joc)
/* Deseneaza anaconda de pe linia de mijloc. */
{
    int x = joc->anax, l = joc->anal;

    if (!joc->anad)
        PutCAt(joc->memvid, x++, 12, CA_ANACO + 2 + (x & 1), ATR_ANACO);
    while (l--) PutCAt(joc->memvid, x++, 12, CA_ANACO + (x & 1), ATR_ANACO);
    if (joc->anad)
        PutCAt(joc->memvid, x++, 12, CA_ANACO + 2 + (x & 1), ATR_ANACO);
}

/* ------------------------------------------------------------------------ */
/*                  Grup functii pentru 'fizica' jocului.                   */
/* ------------------------------------------------------------------------ */

void MiscaMasini(AGlobale joc)
/* Misca toate masinile in mod corespunzator. */
{
    AMasina mas = joc->masini - 1, ultmas = joc->ultmas;
    ABanda ban = joc->benzi - 1, ultban = joc->benzi + NUMBENZI;

    /* actualizeaza informatiile benzilor */
    while (++ban != ultban) {
        ban->contor = (ban->contor & 0x00ff) + ban->viteza;
        if ((ban->contor & 0xff00) && (ban->ocupat)) ban->ocupat--;
    }
    /* misca masinile */
    while (++mas != ultmas) if (mas->b->contor & 0xff00) {
        mas->x += ((mas->b->dir) << 1);
        /* a depasit masina marginile ? */
        if ((--mas->x >= 80) || (mas->x <= -mas->m->l))
            *(mas--) = *(--ultmas); /* distruge masina */
    }
    joc->ultmas = ultmas;
}

void MiscaAnac(AGlobale joc)
/* Miscarea anacondei */
{
    joc->anac = (joc->anac & 0x00ff) + joc->anav;
    if (joc->anac & 0xff00) {
        if ((joc->anax += (joc->anad << 1) - 1) > 80) joc->anad = 0;
        if (joc->anax < -joc->anal) joc->anad = 1;
    }
}

void GenerMasini(AGlobale joc)
/* Rutina pentru aparitia masinilor noi. */
{
    AMasina umas = joc->ultmas;
    ABanda ba = joc->benzi + (rand() % NUMBENZI);

    if (((umas - joc->masini) < MAXMAS) && (!ba->ocupat)) {
        umas->b = ba;
        umas->m = joc->MODELE + ((ba->distrib[1 + rand() % ba->distrib[0]]
                  << 1) + ba->dir);
        ba->ocupat = 2 + 3 * ((rand() % 7) >> 1) + umas->m->l;
        umas->c = 1 + rand() % 15;
        umas->x = (ba->dir) ? (-umas->m->l) : 80;
        umas++;
    }
    joc->ultmas = umas;
}

int CitTaste(AGlobale joc, int risc)
/* Citeste tastatura si actioneaza in consecinta (muta broasca, incepe o noua
   partida, etc.) Returneaza 1 daca utilizatorul a apasat ESC. Rutina se ocupa
   de asemenea de pauzarea jocului. */
{
    int tasta = InKey(), oldx = joc->brox, oldy = joc->broy;

    /* Pauzare */
    if (joc->pauza)
        while (joc->pauza = ((tasta = InKey()) != 13));

    /* Controlul broscutei */
    if (joc->stare == ST_NORMAL) switch (tasta) {
        case TA_SUS:     joc->broy -= 4;
        case TA_JOS:     joc->broy += (joc->broy != 22) << 1;
                         joc->moriz = 0;
                         break;
        case TA_STANGA:  joc->brox -= (1 + (joc->brox != 0)) << 1;
        case TA_DREAPTA: joc->brox += (joc->brox != 78) << 1;
                         joc->moriz = TI_MORIZ;
    }
    /* Puncteaza riscul */
    if ((joc->brox != oldx) || (joc->broy != oldy))
        joc->scor += (long int) ((double) risc * SC_RISC);
    /* Alte taste */
    switch (tasta) {
        case ' '      : if (joc->stare == ST_DEMO) { /* incepe jocul */
                            joc->stare = ST_GATA; joc->contor = 0;
                        }
                        break;
        case 'n'      : if (joc->stare == ST_DEMO) /* schimba niv. pornire */
                            joc->nivels = 1 + joc->nivels % 9;
                        break;
        case 'c'      : SetPaleta(joc->paleta ^= 1);
                        break;
        case 'p'      : joc->pauza = (joc->stare == ST_NORMAL);
                        break;
        case TA_ESC   : joc->stare = ST_GATA; /* iese din program */
                        joc->contor = 0; return 1;
    }
    return 0;
}

int EvalRisc(AGlobale joc)
/* Determina 'riscul'. Daca broasca se afla in fata unei masini, 'riscul' e
   viteza acesteia (in general, nu depaseste 30). Altfel, e 0. */
{
    AMasina mas = joc->masini - 1;
    int x;

    while ((++mas) != joc->ultmas) {
        x = (mas->b->dir) ? (mas->x + mas->m->l) : (mas->x - ZONARISC);
        if ((joc->broy == mas->b->y) && (joc->brox >= x) && (joc->brox < (x +
            ZONARISC))) return mas->b->viteza;
    }

    x = (joc->anad) ? (joc->anax + joc->anal) : (joc->anax - ZONARISC);
    if ((joc->broy == 12) && (joc->brox >= x) && (joc->brox < (x + ZONARISC)))
        return joc->anav;

    return 0;
}

int Evenimente(AGlobale joc, int lovit)
/* Actualizeaza variabilele de stare ale jocului, actioneaza conform
   evenimentelor importante din joc (lovirea de catre masini, ajungerea in
   casutele de sus, etc. Returneaza valoarea fanionului 'gata' (care determina
   incheierea buclei principale). */
{
    if ((joc->cheite) &&    /* am cules o cheie ? */
        (joc->brox == joc->chex) && (joc->broy == joc->chey)) {
        InitCheie(joc);
        joc->scor += SC_CHEIE;
        --joc->cheite;
        joc->timp += joc->timpmax >> 2; /* reface 1/4 din timp */
        if (joc->timp > joc->timpmax) joc->timp = joc->timpmax;
    }
    if ((joc->musc < TI_MUSCA) &&    /* am mancat musca ? */
        (joc->brox == joc->musx) && (joc->broy == joc->musy)) {
        InitMusca(joc);
        joc->scor += SC_MUSCA;
    }
    /* mentine unele valori in limitele normale */
    if (joc->timp > joc->timpmax) joc->timp = joc->timpmax;
    if (joc->scor < 0) joc->scor = 0;
    if (joc->scor > 999999) joc->scor = 999999;
    /* contoare */
    if (joc->anuntn) --joc->anuntn;
    if (joc->moriz) --joc->moriz;
    if (joc->chec) --joc->chec;
    if (joc->musc) --joc->musc; else InitMusca(joc);
    ++joc->contor;
    switch (joc->stare) {
        case ST_INIT: Cataplof(joc->memvid, 39, 11, joc->contor << 1, 0x0020,
                               1);
                      if (joc->contor == 40) {
                          joc->contor = 0;
                          joc->stare = (joc->vieti) ? ST_NORMAL : ST_DEMO;
                      }
                      break;
        case ST_DEMO: if ((joc->contor >> 9) == NUMINSTRUCT) joc->contor = 0;
                      break;
        case ST_NORMAL: if (joc->timp) --joc->timp;
                        if (lovit || (!joc->timp)) {
                            joc->stare = ST_LOVIT; joc->contor = 0; break;
                        }
                        if (joc->broy == 2) {
                            joc->scor += SC_CASA;
                            joc->casute |= (1 << (joc->brox / 20));
                            joc->stare = ST_SUCCES; joc->contor = 0;
                        }
                        break;
        case ST_SUCCES: Cataplof(joc->memvid, joc->brox, joc->broy,
                                 joc->contor << 2, 0x0020, 0);
                        if (joc->contor == 60) return 1;
                        break;
        case ST_LOVIT:  Cataplof(joc->memvid, joc->brox, joc->broy,
                                 joc->contor << 2, ((joc->contor & 0x10) ?
                                 0x4020 : 0xF020), 0);
                        if (joc->contor == 240) {
                            --joc->vieti; return 1;
                        }
                        break;
        case ST_GATA: Cataplof(joc->memvid, 39, 11, 80 - (joc->contor << 1),
                               0x0020, 1);
                      if (joc->contor == 60) return 1;
    }
    return 0;
}

/* ------------------------------------------------------------------------ */
/*                    Grup functii pentru initializari.                     */
/* ------------------------------------------------------------------------ */

void InitBenzi(AGlobale joc)
/* Initializeaza benzile de masini. */
{
    ABanda ban = joc->benzi, ultban = joc->benzi + NUMBENZI;
    int vitu = -1, vitc;

    memcpy(ban, joc->BENZIO, NUMBENZI * sizeof(Banda));
    while (ban != ultban) {
        while ((vitc = rand() % 4) == vitu);
        ban->viteza = (2 + (vitu = vitc)) * (2 + joc->nivel / 2);
        ban->dir ^= (joc->nivel & 1);
        ban++;
    }
}

void InitMasini(AGlobale joc)
/* Initializeaza masinile. */
{
    int i;

    joc->ultmas = joc->masini;
    for (i = 0; i < 256*80; i++) {
        GenerMasini(joc);
        MiscaMasini(joc);
        MiscaAnac(joc);
    }
}

void InitCheie(AGlobale joc)
/* Plaseaza cheia intr-un loc aleator, departe de cel curent. */
{
    int oldy = joc->chey;

    do {
        joc->chex = 6 + ((rand() % 35) << 1);
        joc->chey = 4 + ((rand() % 9) << 1);
    } while (abs(joc->chey - oldy) < 6);
    joc->chec = 128;
}

void InitMusca(AGlobale joc)
/* Plaseaza musca intr-un loc aleator. */
{
    joc->musx = 6 + ((rand() % 35) << 1);
    joc->musy = 4 + ((rand() % 9) << 1);
    joc->musc = TI_MUSCA + TI_MINMUSCA + rand() % (1 + TI_MAXMUSCA -
                TI_MINMUSCA);
}

void InitMisiune(AGlobale joc)
/* Initializeaza variabilele pentru o noua misiune de traversare a strazii. */
{
    static int cheiniv[10] = { 0, 0, 1, 2, 2, 3, 3, 4, 4 };

    joc->cheite = cheiniv[joc->nivel - 1];
    joc->brox = XB0; joc->broy = YB0; joc->moriz = 0;
    joc->stare = ST_INIT; joc->contor = 0; joc->timp = joc->timpmax;
    InitCheie(joc);
    InitMusca(joc);
}

void InitAnac(AGlobale joc)
/* Initializeaza anaconda. */
{
    joc->anal = 6 + ((joc->nivel * 3) >> 1);
    joc->anax = -joc->anal;
    joc->anad = 1;
    joc->anac = 0;
    joc->anav = 10 + (joc->nivel << 1);
}

void InitPartida(AGlobale joc)
/* Incepe o noua partida. */
{
    joc->gamov = 0;
    joc->scor = -SC_NIV; joc->vieti = 5; joc->nivel = joc->nivels - 1;
    joc->casute = 15; /* forteaza initializarea nivelului */
}

void NouNivel(AGlobale joc)
/* Avanseaza la un nou nivel si face initializarile de rigoare. */
{
    joc->anuntn = 572;
    joc->scor += SC_NIV;
    joc->casute = 0;
    ++joc->nivel;
    if (joc->nivel > 9) joc->nivel = 9;
    joc->timpmax = TI_TIMPMAX;
    InitBenzi(joc);
    InitMasini(joc);
    InitAnac(joc);
}

/* ------------------------------------------------------------------------ */
/*                            PROGRAM PRINCIPAL                             */
/* ------------------------------------------------------------------------ */

int main()
{
#include "datetrav.inc"

    int i, gata, lovit, abandon = 0;
    long int li;
    Globale joc;

    printf("Asteptati va rog...\n");
    Asteapta(0L);
    fflush(stdin);
    InitGraf(CARACTERE);

    /* Initializeaza variabilele globale */
    joc.MODELE = MODELE;
    joc.BENZIO = (ABanda) BENZIO;
    joc.scor = -SC_NIV; joc.nivels = 1; joc.casute = 15; joc.stare = ST_INIT;
    joc.vieti = joc.gamov = joc.paleta = joc.pauza = joc. record =
        joc.nivel = 0;

    do {
        /* Bucla de 'misiune' (la fiecare iteratie se reincearca traversarea
           strazii incepand cu broscuta de jos) */
        if (!joc.vieti) /* Nu sunt vieti ? Atunci... */
            switch (joc.stare) {
                case ST_GATA: InitPartida(&joc); /* sfarsit demonstratie */
                              break;
                case ST_LOVIT: joc.gamov = 1; /* game over */
                               if (joc.scor > joc.record)
                                   joc.record = joc.scor;
            }
        if (joc.casute == 15) NouNivel(&joc);
        InitMisiune(&joc);
        gata = 0;

        while (!gata) {
            /* Bucla principala */
            DesFundal(joc.memvid, BENZIF);
            DesCase(&joc);
            DesCheie(&joc);
            DesMusca(&joc);
            GenerMasini(&joc);
            MiscaMasini(&joc);
            MiscaAnac(&joc);
            abandon |= CitTaste(&joc, EvalRisc(&joc));
            DesMasini(&joc);
            DesAnac(&joc);
            lovit = DesBroasca(&joc);
            ScrieMesaje(&joc);
            gata = Evenimente(&joc, lovit);
            ScrieScor(&joc);
            GataCadru(joc.memvid);
            Asteapta(6L);
        } /* sfarsit bucla principala */
    } while (!abandon); /* sfarsit bucla misiune */

    GataGraf();
    return 0;
}