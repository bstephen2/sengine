
/*
 *	boardlist.c
 *	(c) 2017, Brian Stephenson
 *	brian@bstephen.me.uk
 *
 *	A program to test orthodox chess problems of the types:
 *
 *		directmates
 *		selfmates
 *		relfexmates
 *		helpmates
 *
 *	Input is taken from the program options and output is xml on stdout.
 *
 *
 *	This is the module that includes all routines to do with boardlists.
 */

#include "sengine.h"
static int refutCompare(void*, void*);

void putRefutsToEnd(BOARDLIST* bml)
{
    LL_SORT(bml->vektor, refutCompare);
    return;
}

static int refutCompare(void* a, void* b)
{
    BOARD* aa = (BOARD*) a;
    BOARD* bb = (BOARD*) b;
    int ia;
    int ib;
    ia = (aa->tag == '!') ? 1 : 0;
    ib = (bb->tag == '!') ? 1 : 0;

    if (ia == ib) {
        return 0;
    } else {
        return (ia < ib) ? -1 : 1;
    }
}

bool bListEquals(BOARDLIST* ibl, BOARDLIST* obl)
{
    int counto, counti;
    BOARD* tmp;
    BOARD* tmp1;
    BOARD* a;
    BOARD* b;
    assert(obl != NULL);
    assert(ibl != NULL);
    //assert(obl->vektor != NULL);
    //assert(ibl->vektor != NULL);
    LL_COUNT(ibl->vektor, tmp, counti);
    LL_COUNT(obl->vektor, tmp1, counto);

    if (counti != counto) {
        return false;
    }

    if (counti == 0) {
        return true;
    }

    a = ibl->vektor->next;
    b = obl->vektor->next;

    while (a != NULL) {
        assert(b != NULL);

        if (deepEquals(a, b) == false) {
            return false;
        }

        a = a->next;
        b = b->next;
    }

    return true;
}

void weedOutShortVars(BOARDLIST* ml, unsigned char maxstip)
{
#ifdef TRACE
    (void) fputs("boardlist::weedOutShortVars() starting\n", stderr);
#endif
    BOARDLIST* bl;
    BOARD* b;
    BOARD* tmp;
    LL_FOREACH_SAFE(ml->vektor, b, tmp) {
        bl = b->nextply;

        if (bl != NULL) {
            if (bl->stipIn < maxstip) {
                LL_DELETE(ml->vektor, b);
                freeBoard(b);
            }
        }
    }
#ifdef TRACE
    (void) fputs("boardlist::weedOutShortVars() ending\n", stderr);
#endif
    return;
}

void weedOutLongVars(BOARDLIST* thisml)
{
#ifdef TRACE
    (void) fputs("boardlist::weedOutLongVars() starting\n", stderr);
#endif
    BOARDLIST* ml;
    BOARD* m;
    BOARD* tmp;
    LL_FOREACH_SAFE(thisml->vektor, m, tmp) {
        ml = m->nextply;

        if (ml != NULL) {
            if (ml->stipIn > thisml->minStip) {
                LL_DELETE(thisml->vektor, m);
                freeBoard(m);
            }
        }
    }
#ifdef TRACE
    (void) fputs("boardlist::weedOutLonvVars() ending\n", stderr);
#endif
    return;
}
