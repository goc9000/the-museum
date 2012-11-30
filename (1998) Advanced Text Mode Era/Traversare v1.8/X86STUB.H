/* x86stub.h  -- Grupa: 311CB -- Nume: Dinu Cristian Mircea -- Materia: II */

/* Cateva functii legate de interuperi, copiate selectiv din header-ul
   standard DOS.H */

#ifndef H_X86STUB_H
#define H_X86STUB_H

#if !defined(___DEFS_H)
#include <_defs.h>
#endif

#ifndef _REG_DEFS
#define _REG_DEFS

struct WORDREGS {
    unsigned int    ax, bx, cx, dx, si, di, cflag, flags;
};

struct BYTEREGS {
    unsigned char   al, ah, bl, bh, cl, ch, dl, dh;
};

union   REGS    {
    struct  WORDREGS x;
    struct  BYTEREGS h;
};

struct  SREGS   {
    unsigned int    es;
    unsigned int    cs;
    unsigned int    ss;
    unsigned int    ds;
};

struct  REGPACK {
    unsigned    r_ax, r_bx, r_cx, r_dx;
    unsigned    r_bp, r_si, r_di, r_ds, r_es, r_flags;
};

#endif  /* _REG_DEFS */

#ifdef __cplusplus
extern "C" {
#endif

int         _Cdecl int86( int __intno,
                          union REGS _FAR *__inregs,
                          union REGS _FAR *__outregs );
int         _Cdecl int86x( int __intno,
                           union REGS _FAR *__inregs,
                           union REGS _FAR *__outregs,
                           struct SREGS _FAR *__segregs );
void        _Cdecl intr( int __intno, struct REGPACK _FAR *__preg );

#ifdef __cplusplus
}
#endif

#endif  /* H_X86STUB_H */