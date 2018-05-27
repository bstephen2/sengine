
/*
 *	sengine.c
 *	(c) 2017-2018, Brian Stephenson
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
 *	This is the module that contains all memory management
 */

#include "sengine.h"

void init_mem(void)
{
    return;
}

void close_mem(void)
{
    return;
}

BOARD* getBoard(POSITION* ppos, unsigned char played, unsigned char move)
{
    BOARD* rpbrd;
    rpbrd = calloc(1, sizeof(BOARD));
    SENGINE_MEM_ASSERT(rpbrd);
    rpbrd->pos = getPosition(ppos);
    rpbrd->tag = '*';
    rpbrd->side = played;
    rpbrd->ply = move;
    rpbrd->qualifier[0] = '\0';
    rpbrd->use_count = 1;
    return rpbrd;
}

BOARD* cloneBoard(BOARD* inBrd)
{
    BOARD* rpbrd;
    rpbrd = malloc(sizeof(BOARD));
    SENGINE_MEM_ASSERT(rpbrd);
    memcpy((void*) rpbrd, (void*) inBrd, sizeof(BOARD));
    rpbrd->next = NULL;
    return rpbrd;
}

POSITION* getPosition(POSITION* ppos)
{
    POSITION* rpos;
    rpos = (POSITION*) malloc(sizeof(POSITION));
    SENGINE_MEM_ASSERT(rpos);
    memcpy(rpos, ppos, sizeof(POSITION));
    return rpos;
}

KILLERHASHVALUE* getKillerHashValue(void)
{
    KILLERHASHVALUE* khv = calloc(1, sizeof(HASHVALUE));
    SENGINE_MEM_ASSERT(khv);
    return khv;
}

HASHVALUE* getHashValue(void)
{
    HASHVALUE* hv = calloc(1, sizeof(HASHVALUE));
    SENGINE_MEM_ASSERT(hv);
    return hv;
}

BOARDLIST* getBoardlist(unsigned char tplay, unsigned char move)
{
    BOARDLIST* pbl;
    pbl = calloc(1, sizeof(BOARDLIST));
    SENGINE_MEM_ASSERT(pbl);
    pbl->toPlay = tplay;
    pbl->moveNumber = move;
    pbl->use_count = 1;
    pbl->vektor = (BOARD*) NULL;
    return pbl;
}

void freeBoard(BOARD* pbrd)
{
    assert(pbrd != NULL);

    if (pbrd->pos != NULL) {
        freePosition(pbrd->pos);
    }

    if (pbrd->nextply != NULL) {
        freeBoardlist(pbrd->nextply);
    }

    if (pbrd->threat != NULL) {
        freeBoardlist(pbrd->threat);
    }

    free(pbrd);
    return;
}

void freePosition(POSITION* ppos)
{
    assert(ppos != NULL);
    free(ppos);
    return;
}

void freeBoardlist(BOARDLIST* pbl)
{
    assert(pbl != NULL);
    pbl->use_count--;

    if (pbl->use_count == 0) {
        BOARD* b;
        BOARD* tmp;
        LL_FOREACH_SAFE(pbl->vektor, b, tmp) {
            LL_DELETE(pbl->vektor, b);
            freeBoard(b);
        }
        free(pbl);
    }

    return;
}
