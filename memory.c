
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

typedef struct board_rec {
    BOARD* block;
    struct board_rec* next;
} BOARD_REC;

typedef struct position_rec {
    POSITION* block;
    struct position_rec* next;
} POSITION_REC;

typedef struct boardlist_rec {
    BOARDLIST* block;
    struct boardlist_rec* next;
} BOARDLIST_REC;

static BOARD_REC* board_stack;
static POSITION_REC* position_stack;
static BOARDLIST_REC* boardlist_stack;

void init_mem(void)
{
    board_stack = NULL;
    position_stack = NULL;
    boardlist_stack = NULL;
    return;
}

void close_mem(void)
{
    BOARD_REC* br_elt;
    BOARD_REC* br_tmp;
    POSITION_REC* pr_elt;
    POSITION_REC* pr_tmp;
    BOARDLIST_REC* blr_elt;
    BOARDLIST_REC* blr_tmp;
    LL_FOREACH_SAFE(board_stack, br_elt, br_tmp) {
        LL_DELETE(board_stack, br_elt);
        free(br_elt->block);
        free(br_elt);
    }
    LL_FOREACH_SAFE(position_stack, pr_elt, pr_tmp) {
        LL_DELETE(position_stack, pr_elt);
        free(pr_elt->block);
        free(pr_elt);
    }
    LL_FOREACH_SAFE(boardlist_stack, blr_elt, blr_tmp) {
        LL_DELETE(boardlist_stack, blr_elt);
        free(blr_elt->block);
        free(blr_elt);
    }
    return;
}

BOARD* getBoard(POSITION* ppos, unsigned char played, unsigned char move)
{
    BOARD* rpbrd;
    BOARD_REC* elt;
    int len;
    LL_COUNT(board_stack, elt, len);

    if (len > 0) {
        rpbrd = board_stack->block;
        memset((void*) rpbrd, '\0', sizeof(BOARD));
        elt = board_stack;
        LL_DELETE(board_stack, elt);
        free(elt);
    } else {
        rpbrd = calloc(1, sizeof(BOARD));
        SENGINE_MEM_ASSERT(rpbrd);
    }

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
    BOARD_REC* elt;
    int len;
    LL_COUNT(board_stack, elt, len);

    if (len > 0) {
        rpbrd = board_stack->block;
        elt = board_stack;
        LL_DELETE(board_stack, elt);
        free(elt);
    } else {
        rpbrd = malloc(sizeof(BOARD));
        SENGINE_MEM_ASSERT(rpbrd);
    }

    memcpy((void*) rpbrd, (void*) inBrd, sizeof(BOARD));
    rpbrd->next = NULL;
    return rpbrd;
}

POSITION* getPosition(POSITION* ppos)
{
    POSITION* rpos;
    POSITION_REC* elt;
    int len;
    LL_COUNT(position_stack, elt, len);

    if (len > 0) {
        rpos = position_stack->block;
        elt = position_stack;
        LL_DELETE(position_stack, elt);
        free(elt);
    } else {
        rpos = (POSITION*) malloc(sizeof(POSITION));
        SENGINE_MEM_ASSERT(rpos);
    }

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
    BOARDLIST_REC* elt;
    int len;
    LL_COUNT(boardlist_stack, elt, len);

    if (len > 0) {
        pbl = boardlist_stack->block;
        elt = boardlist_stack;
        LL_DELETE(boardlist_stack, elt);
        free(elt);
        memset((void*) pbl, '\0', sizeof(BOARDLIST));
    } else {
        pbl = calloc(1, sizeof(BOARDLIST));
        SENGINE_MEM_ASSERT(pbl);
    }

    pbl->toPlay = tplay;
    pbl->moveNumber = move;
    pbl->use_count = 1;
    pbl->vektor = (BOARD*) NULL;
    return pbl;
}

void freeBoard(BOARD* pbrd)
{
    int len;
    BOARD_REC* elt;
    assert(pbrd != NULL);
    pbrd->use_count--;

    if (pbrd->use_count == 0) {
        if (pbrd->pos != NULL) {
            freePosition(pbrd->pos);
        }

        if (pbrd->nextply != NULL) {
            freeBoardlist(pbrd->nextply);
        }

        if (pbrd->threat != NULL) {
            freeBoardlist(pbrd->threat);
        }

        LL_COUNT(board_stack, elt, len);

        if (len < MAX_BOARD_POOL) {
            BOARD_REC* tmp = malloc(sizeof(BOARD_REC));
            SENGINE_MEM_ASSERT(tmp);
            tmp->block = pbrd;
            LL_APPEND(board_stack, tmp);
        } else {
            free(pbrd);
        }
    }

    return;
}

void freePosition(POSITION* ppos)
{
    int len;
    POSITION_REC* elt;
    assert(ppos != NULL);
    LL_COUNT(position_stack, elt, len);

    if (len < MAX_POS_POOL) {
        POSITION_REC* tmp = malloc(sizeof(POSITION_REC));
        SENGINE_MEM_ASSERT(tmp);
        tmp->block = ppos;
        LL_APPEND(position_stack, tmp);
    } else {
        free(ppos);
    }

    return;
}

void freeBoardlist(BOARDLIST* pbl)
{
    int len;
    BOARDLIST_REC* elt;
    assert(pbl != NULL);
    pbl->use_count--;

    if (pbl->use_count == 0) {
        BOARD* b;
        BOARD* tmp;
        LL_FOREACH_SAFE(pbl->vektor, b, tmp) {
            LL_DELETE(pbl->vektor, b);
            freeBoard(b);
        }
        LL_COUNT(boardlist_stack, elt, len);

        if (len < MAX_BOARDLIST_POOL) {
            BOARDLIST_REC* tmp = malloc(sizeof(BOARDLIST_REC));
            SENGINE_MEM_ASSERT(tmp);
            tmp->block = pbl;
            LL_APPEND(boardlist_stack, tmp);
        } else {
            free(pbl);
        }
    }

    return;
}
