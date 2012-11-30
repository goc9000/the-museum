/* diverse.c  -- Grupa: 311CB -- Nume: Dinu Cristian Mircea -- Materia: II */

/* Unitate pentru diverse functii de tastatura si cronometrare. */

#include <conio.h>
#include <time.h>
#include "x86stub.h"

#define NULL 0

char InKey(void)
/* Returneaza codul tastei apasate sau NULL daca nu e niciuna */
{
    return kbhit() ? getch() : 0;
}

void Asteapta(unsigned long int ms)
/* Asteapta ms milisecunde. Daca este apelat cu ms = 0, calibreaza sistemul
   de intarziere. */
#define MULT 2000000000ul
{
    static unsigned long int tix_h, tix_l, i, j;
    int tix_m;
    time_t ceas;

    if (!ms) {
        time(&ceas);
        while (ceas == time(NULL)); /* asteapta pana se schimba secunda */
        time(&ceas);
        tix_h = tix_l = tix_m = 0;
        do { /* bucla calibrare */
            if (++tix_m == 1000) {
                tix_m = 0;
                if (++tix_l == MULT) {
                    tix_l = 0;
                    if (++tix_h == MULT) return;
                }
            }
        } while (ceas == time(NULL));
        return;
    }
    /* functionare normala */
    while (ms--) {
        for (i = tix_h; i--; ) for (j = MULT; j--; ) ceas = time(NULL);
        for (j = tix_l; j--; ) ceas = time(NULL);
    }
}