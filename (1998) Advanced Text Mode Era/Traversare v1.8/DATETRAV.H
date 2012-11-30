/* datetrav.h -- Grupa: 311CB -- Nume: Dinu Cristian Mircea -- Materia: II */

/* Aici se tin: - informatii legate de constantele tabelare din datetrav.inc
                - noile tipuri de date
                - constante generale legate de joc */

#ifndef H_DATETRAV_H
#define H_DATETRAV_H

#define NUMCARACT 62      /* numarul de caractere din font */
#define NUMINSTRUCT 7     /* numarul de mesaje de instructiuni */
#define LMAXDISTRIB 128   /* (nr maxim de masini dintr-o distributie) - 1 */
#define MAXMAS 200        /* numar maxim de masini */
#define NUMBENZI 8        /* numarul benzilor de circulatie */
#define ZONARISC 2        /* lungimea zonei de risc din fata unei masini */
#define XB0 40            /* pozitia initiala a broscutei */
#define YB0 22            /* pozitia initiala a broscutei */
#define TI_TIMPMAX 8192   /* timpul maxim pt traversare */
#define TI_MUSCA 2000     /* cat timp sta o musca pe ecran */
#define TI_MINMUSCA 2000  /* timpul minim pana la o noua musca */
#define TI_MAXMUSCA 4000  /* timpul maxim pana la o noua musca */
#define TI_MORIZ 40       /* durata miscarii orizontale */
#define SC_RISC 0.25      /* scorul pentru o 'unitate de risc' */
#define SC_CHEIE 40       /* scorul pentru o cheie culeasa */
#define SC_MUSCA 500      /* scorul pentru o musca mancata */
#define SC_CASA 300       /* scorul pentru ajungerea intr-o casuta */
#define SC_NIV 2000       /* scorul pentru terminarea unui nivel */

typedef struct Model {
    char l;             /* lungimea modelului */
    unsigned char ocul; /* override culoare: culoare = (culoare AND
                           nibbleinf) OR nibblesup */
    const char* desc;   /* descriptor (caractere) */
} Model, *AModel;

typedef struct Banda {
    int y;              /* pozitia y pe ecran */
    const int *distrib; /* vectorul de distributie folosit */
    int dir;            /* directie (1=dreapta, 0=stanga) */
    int viteza;         /* viteza */
    int contor;         /* contor */
    int ocupat;         /* cat timp mai e pana mai putem baga o masina */
} Banda, *ABanda;

typedef struct Masina {
    int x;     /* pozitia x pe ecran */
    ABanda b;  /* banda de care apartine */
    AModel m;  /* model */
    char c;    /* culoare */
} Masina, *AMasina;

typedef struct Globale {
    char memvid[4000];      /* memoria video */
    ABanda BENZIO;          /* adresa constantei de benzi initiale */
    AModel MODELE;          /* adresa constantei de modele */
    Masina masini[MAXMAS];  /* vector masini, vehicule, etc. */
    Banda benzi[NUMBENZI];  /* vector benzi circulatie */
    AMasina ultmas;         /* adresa de dupa ultimul vehicul */
    int anax;           /* coordonata X a anacondei */
    int anav;           /* viteza anacondei */
    int anad;           /* directia anacondei (1 = dreapta) */
    int anac;           /* contor anaconda */
    int anal;           /* lungime anaconda */
    int musx;           /* coordonata X a mustei */
    int musy;           /* coordonata Y a mustei */
    int brox;           /* coordonata X a broastei */
    int broy;           /* coordonata Y a broastei */
    int moriz;          /* timpul pentru care broasca e afisata 'orizontal' */
    int casute;         /* bitul x = starea de ocupatie a casutei nr. x */
    int stare;          /* stare curenta a jocului */
    int contor;         /* parametru secundar al starii */
    int abandon;        /* fanion abandon program */
    int nivel;          /* nivelul curent */
    int cheite;         /* cate cheite mai sunt de gasit pt a iesi */
    int chex;           /* coordonata X a cheii */
    int chey;           /* coordonata Y a cheii */
    int chec;           /* contor evidentiere cheie */
    int vieti;          /* numarul de vieti ramase (0 = 'attract mode') */
    int nivels;         /* nivel de inceput al jocului */
    int anuntn;         /* timpul pentru care se anunta nivel */
    int gamov;          /* fanion de afisare 'game over' */
    int pauza;          /* fanion de pauza */
    int paleta;         /* ce paleta folosim (0 = normala, 1 = intensa) */
    long int scor;      /* scor curent */
    long int musc;      /* contor pentru afisarea mustei */
    long int timp;      /* timp ramas pana la expirarea vietii */
    long int timpmax;   /* timpul maxim pentru traversarea strazii */
    long int record;    /* record */
} Globale, *AGlobale;

enum { CA_ANACO = 207, CA_MUSCA = 211, CA_BROASCA1, CA_BROASCA2, CA_STUF,
       CA_MARGINE, CA_BANDA, CA_2BENZI, CA_MAL, CA_CHEIE, CA_USA, CA_TIMP };
       /* caractere speciale */

enum { MO_DACIA = 0, MO_TIR1, MO_TIR2, MO_MOTO, MO_TRABANT, MO_BUSTEAN,
       MO_CROCO1, MO_CROCO2, MO_TESTO }; /* modele */

#endif