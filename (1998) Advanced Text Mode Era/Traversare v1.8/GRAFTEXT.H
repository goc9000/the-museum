/* graftext.h -- Grupa: 311CB -- Nume: Dinu Cristian Mircea -- Materia: II */

/* Header-ul pentru unitatea de grafica in mod text. */

#ifndef H_GRAFTEXT_H
#define H_GRAFTEXT_H

void SetLinii(unsigned char lin);
void ModText(unsigned char mod);
void SetClipi(unsigned char cli);
void FaraCursor(void);
void IncarcaFont(const char* adrfont, unsigned char car, unsigned char prim);
void DefCuloare(unsigned char idx, unsigned char rgbRGB);
unsigned char CitCuloare(unsigned char idx);
void InitVideo(void);
void GataVideo(void);
void Comite(char *memvid);

#endif