/* graftrav.h -- Grupa: 311CB -- Nume: Dinu Cristian Mircea -- Materia: II */

/* Header-ul pentru unitatea de grafica. Tot aici se definesc si culorile
   pentru diverse elemente ale jocului. */

#ifndef H_GRAFTRAV_H
#define H_GRAFTRAV_H

#define ATR_TRANS 0xFF00 /* atribut 'transparent' */
#define ATR_SCOR 0xF00B
#define ATR_BROASCA 0xF002
#define ATR_USA 0xF00D
#define ATR_CHEIE 0xF00D
#define ATR_ANACO 0xF002
#define ATR_MUSCA 0xF00C

void PutSAt(char *memvid, int x, int y, const char *stg, int atr);
void PutCAt(char *memvid, int x, int y, unsigned char c, int atr);
void DesMas(char *memvid, int x, int y, const char *stg, char cul);
void DesFundal(char *memvid, const short int BENZIF[]);
void Dreptunghi(char *memvid, int x, int y, int u, int v, int tipar);
void Cataplof(char* memvid, int x, int y, int s, int tipar, int anti);
void Evidentiere(char* memvid, int x, int y, int dx, int dy, int cul);
int IaCaract(char *memvid, int x, int y);
void InitGraf(const char* adrfont);
void SetPaleta(int normal);
void GataGraf(void);
void GataCadru(char *memvid);

#endif