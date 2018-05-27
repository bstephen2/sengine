
/*
 *	direct.c
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
 *	This is the module for solving directmates.
 */

#include "sengine.h"

extern unsigned int opt_moves;
extern bool opt_set;
extern bool opt_tries;
extern bool opt_actual;
extern unsigned int opt_sols;
extern bool opt_trivialtries;
extern enum SOUNDNESS sound;
extern enum THREATS opt_threats;
extern enum AIM opt_aim;
extern unsigned int opt_refuts;
extern bool opt_shortvars;
extern bool opt_fleck;

static void sortStrongBlackMoves(BOARDLIST*);
static void sortWhiteMoves(BOARDLIST*);
static BOARDLIST* norm_final_move(BOARD*, int);
static BOARDLIST* gloss_final_move(BOARD*, int);
static BOARDLIST* gloss_first_move(BOARD*, int);
static BOARDLIST* gloss_blackMidMove(BOARD*, int, int);
static BOARDLIST* gloss_blackMove(BOARD*, int);
static BOARDLIST* norm_first_move(BOARD*);
static BOARDLIST* gloss_whiteMidMove(BOARD*, int, int);
static void calculateThreats(BOARDLIST*);
static void sortTriesKeys(DIR_SOL*);
static void deTrivialise(BOARDLIST*);
static BOARDLIST* calculateSetPlay(BOARD*);
static void calculateSetThreats(BOARDLIST*);
static BOARDLIST* norm_whiteMidMove(BOARD*, int);
static BOARDLIST* blackMove(BOARD*);
static BOARDLIST* norm_blackMidMove(BOARD*, int);
static void walkWBoardList(BOARDLIST*);

static bool isFlight(BOARD*);
static bool isCheck(BOARD*);
static bool isGiver(BOARD*);
static bool isCapture(BOARD*);
static bool isKiller(BOARD*);
static bool isProm(BOARD*);
static int blackMoveCompare(void*, void*);
static int whiteMoveCompare(void*, void*);

static enum STATUS state;
static unsigned int hash_added = 0;
static unsigned int hash_hit_null = 0;
static unsigned int hash_hit_list = 0;
static HASHVALUE* transtable = NULL;
static KILLERHASHVALUE* killers = NULL;

static int whiteMoveCompare(void* a, void* b)
{
    BOARD* aa = (BOARD*) a;
    BOARD* bb = (BOARD*) b;
    int ia;
    int ib;

    if (isCheck(aa) == true) {
        ia = 1;
    } else if (isCapture(aa) == true) {
        ia = 2;
    } else if (isProm(aa) == true) {
        ia = 3;
    } else {
        ia = 4;
    }

    if (isCheck(bb) == true) {
        ib = 1;
    } else if (isCapture(bb) == true) {
        ib = 2;
    } else if (isProm(bb) == true) {
        ib = 3;
    } else {
        ib = 4;
    }

    if (ia == ib) {
        return 0;
    } else {
        return (ia < ib) ? -1 : 1;
    }
}

static int blackMoveCompare(void* a, void* b)
{
    BOARD* aa = (BOARD*) a;
    BOARD* bb = (BOARD*) b;
    int ia;
    int ib;

    if (isCheck(aa) == true) {
        ia = 1;
    } else if (isGiver(aa) == true) {
        ia = 2;
    } else if (isFlight(aa) == true) {
        ia = 3;
    } else if (isKiller(aa) == true) {
        ia = 4;
    } else if (isCapture(aa) == true) {
        ia = 5;
    } else if (isProm(aa) == true) {
        ia = 6;
    } else {
        ia = 7;
    }

    if (isCheck(bb) == true) {
        ib = 1;
    } else if (isGiver(bb) == true) {
        ib = 2;
    } else if (isFlight(bb) == true) {
        ib = 3;
    } else if (isKiller(bb) == true) {
        ib = 4;
    } else if (isCapture(bb) == true) {
        ib = 5;
    } else if (isProm(bb) == true) {
        ib = 6;
    } else {
        ib = 7;
    }

    if (ia == ib) {
        return 0;
    } else {
        return (ia < ib) ? -1 : 1;
    }
}

static void sortStrongBlackMoves(BOARDLIST* ibl)
{
    LL_SORT(ibl->vektor, blackMoveCompare);
    return;
}

static void sortWhiteMoves(BOARDLIST* ibl)
{
    LL_SORT(ibl->vektor, whiteMoveCompare);
    return;
}

static bool isKiller(BOARD* bd)
{
    return bd->killer;
}

static bool isFlight(BOARD* bd)
{
    return (bd->mover == KING) ? true : false;
}

static bool isCheck(BOARD* bd)
{
    return bd->check;
}

static bool isGiver(BOARD* bd)
{
    return (bd->flights > 0) ? true : false;
}

static bool isCapture(BOARD* bd)
{
    return bd->captured;
}

/*
static bool isKiller( BOARD * bd ) {
   return bd->killer;
}
*/
static bool isProm(BOARD* bd)
{
    return (bd->promotion == NOPIECE) ? false : true;
}

/*
static int partition( BOARDLIST * bbl, int start, bool( *pred ) ( BOARD * ) ) {

      int lastind = kv_size( bbl->vektor ) - 1;
      int i = start;
      int rc = start;
      int j, k;
      BOARD *t;

      while ( i < lastind ) {
      t = kv_A( bbl->vektor, i );

      if ( ( pred ) ( t ) == true ) {
      i++;
      } else {
      break;
      }
      }

      if ( i == lastind ) {
      return i;
      }

      for ( j = i; j < lastind; j++ ) {
      t = kv_A( bbl->vektor, j );
      if ( ( pred ) ( t ) == false ) {
      for ( k = j + 1; k <= lastind; k++ ) {
      t = kv_A( bbl->vektor, k );

      if ( ( pred ) ( t ) == true ) {
      kv_A( bbl->vektor, k ) = kv_A( bbl->vektor, j );
      kv_A( bbl->vektor, j ) = t;
      rc = j + 1;
      break;
      }
      }
      }
      }
   return 0;
}
*/
BOARDLIST* generateRefutations(BOARD*, int);
void qualifyMove(BOARDLIST*, BOARD*);

void solve_direct(DIR_SOL* dsol, BOARD* startpos)
{
    bool shortsol = false;
    unsigned int m;
    sound = UNSET;

    if ((opt_actual == true) && (opt_moves == 1)) {
        int ct;
        BOARD* bd;
        dsol->keys = norm_final_move(startpos, 1);
        LL_COUNT(dsol->keys->vektor, bd, ct);

        if (ct == 0) {
            sound = NO_SOLUTION;
        } else if (ct < (int) opt_sols) {
            sound = MISSING_SOLUTION;
        } else if (ct == (int) opt_sols) {
            sound = SOUND;
        } else {
            sound = COOKED;
        }
    } else if ((opt_actual == true) || (opt_tries == true)) {
        for (m = 1; m < opt_moves; m++) {
            int ct;
            BOARD* b;
            BOARDLIST* ml;
#ifdef MOVESTAT
            (void) fprintf(stderr, "Gloss %d\n", m);
            (void) fflush(stderr);
#endif

            if (m == 1) {
                ml = gloss_final_move(startpos, 1);
            } else {
                ml = gloss_first_move(startpos, m);
            }

            LL_COUNT(ml->vektor, b, ct);

            if (ct > 0) {
                shortsol = true;
                dsol->keys = ml;
                sound = SHORT_SOLUTION;
                break;
            } else {
                freeBoardlist(ml);
            }
        }

        if (shortsol == false) {
            int ct;
            BOARD* b;
            state = TRIESKEYS;
            dsol->trieskeys = norm_first_move(startpos);

            if (opt_threats != NONE) {
#ifdef MOVESTAT
                (void) fputs("Threats\n", stderr);
                (void) fflush(stderr);
#endif
                state = THREATS;
                calculateThreats(dsol->trieskeys);
            }

            sortTriesKeys(dsol);
            //dsol->keys = dsol->trieskeys;

            if ((opt_tries == true) && (opt_trivialtries == false)) {
                deTrivialise(dsol->tries);
            }

            LL_COUNT(dsol->keys->vektor, b, ct);

            if (ct == 0) {
                sound = NO_SOLUTION;
            } else if (ct < (int) opt_sols) {
                sound = MISSING_SOLUTION;
            } else if (ct == (int) opt_sols) {
                sound = SOUND;
            } else {
                sound = COOKED;
            }
        }
    }

    if ((shortsol == false) && (opt_moves > 1) && (opt_set == true)
            && (startpos->check == false)) {
#ifdef MOVESTAT
        (void) fputs("Set play\n", stderr);
        (void) fflush(stderr);
#endif
        state = SETPLAY;
        dsol->set = calculateSetPlay(startpos);

        if (opt_threats != NONE) {
            state = THREATS;
            calculateSetThreats(dsol->set);
        }
    }

    if (opt_moves > 4) {
        HASHVALUE* cu;
        HASHVALUE* tmp;
        HASH_ITER(hh, transtable, cu, tmp) {
            HASH_DEL(transtable, cu);
            free(cu);
        }
    }

    {
        KILLERHASHVALUE* cu;
        KILLERHASHVALUE* tmp;
        HASH_ITER(hh, killers, cu, tmp) {
            HASH_DEL(killers, cu);
            free(cu);
        }
    }

    dsol->hash_added = hash_added;
    dsol->hash_hit_null = hash_hit_null;
    dsol->hash_hit_list = hash_hit_list;
    return;
}

static BOARDLIST* gloss_blackMidMove(BOARD* inBrd, int move, int lastmove)
{
    BOARDLIST* bml;
    BOARDLIST* wml;
    BOARD* b1;
    BOARD* tmp;
    BOARD* m;
    bool finished = false;
    unsigned char minStip = NOSTIP;
    unsigned char maxStip = 0;
    unsigned char mateIn;
    unsigned int flights;
    assert(inBrd != NULL);
    bml = generateBlackBoardlist(inBrd, move, &flights);

    if (inBrd->check != true) {
        LL_FOREACH(bml->vektor, b1) {
            int ct;
            BOARDLIST* bbl = getBoardlist(BLACK, 2);
            generateKingMoves(b1, BLACK, bbl);
            LL_COUNT(bbl->vektor, tmp, ct);

            if (ct > (int) flights) {
                b1->flights = (unsigned char) ct;
            }

            freeBoardlist(bbl);
        }
        sortStrongBlackMoves(bml);
    }

    LL_FOREACH(bml->vektor, m) {
        if ((move + 1) == lastmove) {
            wml = gloss_final_move(m, lastmove);
            mateIn = wml->stipIn;
        } else {
            wml = gloss_whiteMidMove(m, move + 1, lastmove);
            mateIn = wml->stipIn;
        }

        if (mateIn == NOSTIP) {
            finished = true;
            freeBoardlist(wml);
            break;
        } else {
            minStip = (mateIn < minStip) ? mateIn : minStip;
            maxStip = (mateIn > maxStip) ? mateIn : maxStip;
            m->nextply = wml;
            qualifyMove(bml, m);
            freePosition(m->pos);
            m->pos = NULL;
        }
    }

    if (finished == false) {
        bml->minStip = minStip;
        bml->maxStip = maxStip;
        bml->stipIn = maxStip;
    } else {
        bml->minStip = NOSTIP;
        bml->maxStip = NOSTIP;
        bml->stipIn = NOSTIP;
    }

    return bml;
}

static BOARDLIST* gloss_whiteMidMove(BOARD* inBrd, int move, int lastmove)
{
    BOARDLIST* wml;
    BOARDLIST* bml;
    BOARD* tmp;
    BOARD* tmp1;
    BOARD* m;
    bool bcheck;
    bool shortStipAchieved = false;
    bool stipAchieved = false;
    unsigned char maxStip = 0;
    unsigned char minStip = NOSTIP;
    int ct;
    assert(inBrd != NULL);
    wml = generateWhiteBoardlist(inBrd, move);
    {
        if (opt_aim == MATE) {
            LL_FOREACH_SAFE(wml->vektor, m, tmp) {
                if (shortStipAchieved == true) {
                    LL_DELETE(wml->vektor, m);
                    freeBoard(m);
                } else {
                    if (m->check == true) {
                        bml = generateRefutations(m, move);
                        LL_COUNT(bml->vektor, tmp1, ct);

                        if (ct == 0) {
                            shortStipAchieved = true;
                            m->tag = '#';
                            freePosition(m->pos);
                            m->pos = NULL;
                        } else {
                            LL_DELETE(wml->vektor, m);
                            freeBoard(m);
                        }

                        freeBoardlist(bml);
                    } else {
                        LL_DELETE(wml->vektor, m);
                        freeBoard(m);
                    }
                }
            }
        } else {
            LL_FOREACH_SAFE(wml->vektor, m, tmp) {
                if (shortStipAchieved == true) {
                    LL_DELETE(wml->vektor, m);
                    freeBoard(m);
                } else {
                    if (m->check == false) {
                        bml = generateRefutations(m, move);
                        LL_COUNT(bml->vektor, tmp1, ct);

                        if (ct == 0) {
                            shortStipAchieved = true;
                            m->tag = '=';
                            freePosition(m->pos);
                            m->pos = NULL;
                        } else {
                            LL_DELETE(wml->vektor, m);
                            freeBoard(m);
                        }

                        freeBoardlist(bml);
                    } else {
                        LL_DELETE(wml->vektor, m);
                        freeBoard(m);
                    }
                }
            }
        }

        if (shortStipAchieved == true) {
            wml->minStip = (unsigned char) move;
            wml->maxStip = maxStip;
            wml->stipIn = (unsigned char) move;
            BOARDLIST* uml = generateWhiteBoardlist(inBrd, move);
            BOARD* b;
            LL_FOREACH(wml->vektor, b) {
                qualifyMove(uml, b);
            }
            freeBoardlist(uml);
            return wml;
        }
    }
    freeBoardlist(wml);
    wml = generateWhiteBoardlist(inBrd, move);
    sortWhiteMoves(wml);
    LL_FOREACH_SAFE(wml->vektor, m, tmp) {
        if (stipAchieved == true) {
            LL_DELETE(wml->vektor, m);
            freeBoard(m);
        } else {
            bcheck = m->check;
            bml = gloss_blackMidMove(m, move, lastmove);
            assert(bml != NULL);
            LL_COUNT(bml->vektor, tmp1, ct);

            if ((ct == 0) && (opt_aim == STALEMATE)
                    && (bcheck == true)) {
                freeBoardlist(bml);
                LL_DELETE(wml->vektor, m);
                freeBoard(m);
            } else if ((ct == 0) && (opt_aim == MATE)
                       && (bcheck == false)) {
                freeBoardlist(bml);
                LL_DELETE(wml->vektor, m);
                freeBoard(m);
            } else if (bml->stipIn == NOSTIP) {
                freeBoardlist(bml);
                LL_DELETE(wml->vektor, m);
                freeBoard(m);
            } else {
                stipAchieved = true;
                m->nextply = bml;
                maxStip = (bml->stipIn > maxStip) ? bml->stipIn : maxStip;
                minStip = (bml->stipIn < minStip) ? bml->stipIn : minStip;
            }
        }
    }

    if (stipAchieved == true) {
        wml->minStip = minStip;
        wml->maxStip = maxStip;
        wml->stipIn = minStip;
        BOARDLIST* uml = generateWhiteBoardlist(inBrd, move);
        BOARD* b;
        LL_FOREACH(wml->vektor, b) {
            qualifyMove(uml, b);
        }
        freeBoardlist(uml);
    } else {
        wml->minStip = NOSTIP;
        wml->maxStip = NOSTIP;
        wml->stipIn = NOSTIP;
    }

    return wml;
}

static BOARDLIST* gloss_blackMove(BOARD* inBrd, int moves)
{
    BOARDLIST* bml;
    BOARDLIST* wml;
    BOARD* tmp;
    BOARD* b1;
    BOARD* b;
    unsigned char minStip = NOSTIP;
    unsigned char maxStip = 0;
    unsigned char mateIn;
    bool stipAchieved = true;
    unsigned int flights;
    int ct;
    assert(inBrd != NULL);
    bml = generateBlackBoardlist(inBrd, 1, &flights);

    if (inBrd->check != true) {
        LL_FOREACH(bml->vektor, b1) {
            BOARDLIST* bbl = getBoardlist(BLACK, 2);
            generateKingMoves(b1, BLACK, bbl);
            LL_COUNT(bbl->vektor, tmp, ct);

            if (ct > (int) flights) {
                b1->flights = (unsigned char) ct;
            }

            freeBoardlist(bbl);
        }
        sortStrongBlackMoves(bml);
    }

    LL_FOREACH(bml->vektor, b) {
        if (moves == 2) {
            wml = gloss_final_move(b, 2);
        } else {
            wml = gloss_whiteMidMove(b, 2, moves);
        }

        mateIn = wml->stipIn;

        if (mateIn == NOSTIP) {
            stipAchieved = false;
            freeBoardlist(wml);
            break;
        } else {
            minStip = (mateIn < minStip) ? mateIn : minStip;
            maxStip = (mateIn > maxStip) ? mateIn : maxStip;
            qualifyMove(bml, b);
            b->nextply = wml;
            freePosition(b->pos);
            b->pos = NULL;
        }
    }

    if (stipAchieved == true) {
        bml->minStip = minStip;
        bml->maxStip = maxStip;
        bml->stipIn = maxStip;
    } else {
        bml->minStip = NOSTIP;
        bml->maxStip = NOSTIP;
        bml->stipIn = NOSTIP;
    }

    return bml;
}

static BOARDLIST* norm_blackMidMove(BOARD* inBrd, int move)
{
    BOARDLIST* bml;
    BOARDLIST* wml = NULL;
    BOARD* m;
    BOARD* b1;
    BOARD* tmp;
    unsigned char minStip = NOSTIP;
    unsigned char maxStip = 0;
    unsigned char mateIn;
    bool refutationFound = false;
    bool ishash = false;
    unsigned int flights;
    int ct;
    HASHKEY kp;
    assert(inBrd != NULL);
    bml = generateBlackBoardlist(inBrd, move, &flights);

    if (inBrd->check == false) {
        LL_FOREACH(bml->vektor, b1) {
            BOARDLIST* bbl = getBoardlist(BLACK, 2);
            generateKingMoves(b1, BLACK, bbl);
            LL_COUNT(bbl->vektor, tmp, ct);

            if (ct > (int) flights) {
                b1->flights = (unsigned char) ct;
            }

            freeBoardlist(bbl);
        }
        sortStrongBlackMoves(bml);
    }

    LL_FOREACH(bml->vektor, m) {
        qualifyMove(bml, m);

        if ((move + 1) == opt_moves) {
            wml = norm_final_move(m, opt_moves);
            mateIn = wml->stipIn;
        } else {
            if ((opt_moves > 4) && ((move == 2) || (move == 3))) {
                HASHVALUE* ptr;
                ishash = true;
                getHashKey(m, &kp);
                HASH_FIND(hh, transtable, &kp, MD5_LEN, ptr);

                if (ptr != NULL) {
                    if (ptr->cont == NULL) {
                        refutationFound = true;
                        hash_hit_null++;
                        break;
                    } else {
                        hash_hit_list++;
                        ptr->cont->use_count++;
                        mateIn = ptr->cont->stipIn;
                        minStip = (mateIn < minStip) ? mateIn : minStip;
                        maxStip = (mateIn > maxStip) ? mateIn : maxStip;
                        m->nextply = ptr->cont;
                        continue;
                    }
                } else {
                    wml = norm_whiteMidMove(m, move + 1);
                    mateIn = wml->stipIn;
                }
            } else {
                wml = norm_whiteMidMove(m, move + 1);
                mateIn = wml->stipIn;
            }
        }

        if (mateIn == NOSTIP) {
            refutationFound = true;
            freeBoardlist(wml);
            wml = NULL;

            if (ishash == true) {
                HASHVALUE* hv = getHashValue();
                hv->cont = NULL;
                (void) memcpy((void*) hv->hashkey, (void*) & (kp.hashkey),
                              MD5_LEN);
                HASH_ADD(hh, transtable, hashkey, MD5_LEN, hv);
                hash_added++;
            }

            break;
        } else {
            if (ishash == true) {
                HASHVALUE* hv = getHashValue();
                hv->cont = wml;
                wml->use_count++;
                (void) memcpy((void*) hv->hashkey, (void*) & (kp.hashkey),
                              MD5_LEN);
                HASH_ADD(hh, transtable, hashkey, MD5_LEN, hv);
                hash_added++;
            }

            minStip = (mateIn < minStip) ? mateIn : minStip;
            maxStip = (mateIn > maxStip) ? mateIn : maxStip;
            m->nextply = wml;
        }

        freePosition(m->pos);
        m->pos = NULL;
    }

    if (refutationFound == false) {
        bml->minStip = minStip;
        bml->maxStip = maxStip;
        bml->stipIn = maxStip;
        LL_COUNT(bml->vektor, tmp, ct);

        if ((state != SETPLAY) && (ct != 0)
                && (opt_shortvars == false) && (minStip != maxStip)) {
            weedOutShortVars(bml, maxStip);
        }
    } else {
        bml->minStip = NOSTIP;
        bml->maxStip = NOSTIP;
        bml->stipIn = NOSTIP;
    }

    return bml;
}

static BOARDLIST* blackMove(BOARD* inBrd)
{
    BOARDLIST* bml;
    BOARDLIST* wml;
    BOARD* b;
    BOARD* b1;
    BOARD* tmp;
    int ct;
    unsigned int refuts = 0;
    unsigned char minStip = NOSTIP;
    unsigned char maxStip = 0;
    unsigned char mateIn;
    unsigned int flights;
    unsigned int ks;
    assert(inBrd != NULL);
    bml = generateBlackBoardlist(inBrd, 1, &flights);

    if (inBrd->check == false) {
        LL_FOREACH(bml->vektor, b1) {
            BOARDLIST* bbl = getBoardlist(BLACK, 2);
            generateKingMoves(b1, BLACK, bbl);
            LL_COUNT(bbl->vektor, tmp, ct);

            if (ct > (int) flights) {
                b1->flights = (unsigned char) ct;
            }

            freeBoardlist(bbl);
        }
        ks = HASH_COUNT(killers);

        if (ks != 0) {
            int rmax = 0;
            KILLERKEY kmk;
            KILLERHASHVALUE* cu;
            KILLERHASHVALUE* tmp2;
            BOARD* ab;
            HASH_ITER(hh, killers, cu, tmp2) {
                if (cu->count > rmax) {
                    rmax = cu->count;
                    kmk.kkey[0] = cu->kkey[0];
                    kmk.kkey[1] = cu->kkey[1];
                    kmk.kkey[2] = cu->kkey[2];
                }
            }
            LL_FOREACH(bml->vektor, ab) {
                KILLERKEY k;
                getKillerHashKey(ab, &k);

                if (memcmp((void*) &k, (void*) & (kmk.kkey[0]), 3) == 0) {
                    ab->killer = true;
                }
            }
        }

        sortStrongBlackMoves(bml);
    }

    LL_FOREACH(bml->vektor, b) {
#ifdef MOVESTAT
        (void) fprintf(stderr,
                       "   1...%2d-%2d (added = %u, hit null = %u, hit_list = %u)\n",
                       b->from, b->to, hash_added,
                       hash_hit_null, hash_hit_list);
        (void) fflush(stderr);
#endif
        qualifyMove(bml, b);

        if (opt_moves == 2) {
            wml = norm_final_move(b, 2);
        } else {
            wml = norm_whiteMidMove(b, 2);
        }

        mateIn = wml->stipIn;

        if (mateIn == NOSTIP) {
            refuts++;
            freeBoardlist(wml);

            if ((b->mover != KING) && (b->check != true)
                    && (b->flights == 0)
                    && (b->captured == false)) {
                KILLERKEY kk;
                getKillerHashKey(b, &kk);
                KILLERHASHVALUE* khv;
                HASH_FIND(hh, killers, &kk, KILLERKEY_LEN, khv);

                if (khv == NULL) {
                    khv = getKillerHashValue();
                    khv->kkey[0] = kk.kkey[0];
                    khv->kkey[1] = kk.kkey[1];
                    khv->kkey[2] = kk.kkey[2];
                    khv->count = 0;
                    HASH_ADD(hh, killers, kkey, KILLERKEY_LEN, khv);
                } else {
                    khv->count++;
                }
            }

            if (refuts > opt_refuts) {
                break;
            } else {
                b->tag = '!';
            }
        } else {
            minStip = (mateIn < minStip) ? mateIn : minStip;
            maxStip = (mateIn > maxStip) ? mateIn : maxStip;
            freePosition(b->pos);
            b->pos = NULL;
            b->nextply = wml;
        }
    }

    if (refuts <= opt_refuts) {
        bml->minStip = minStip;
        bml->maxStip = maxStip;
        bml->stipIn = maxStip;

        if (refuts > 0) {
            bml->isTry = true;
        }

        if ((opt_shortvars == false) && (minStip != maxStip)) {
            weedOutShortVars(bml, (unsigned char) opt_moves);
        }
    } else {
        bml->minStip = NOSTIP;
        bml->maxStip = NOSTIP;
        bml->stipIn = NOSTIP;
    }

    return bml;
}

static BOARDLIST* norm_final_move(BOARD* inBrd, int move)
{
    BOARDLIST* wml;
    BOARDLIST* bml;
    BOARD* bd;
    BOARD* tmp;
    BOARD* tmp1;
    bool stipAchieved = false;
    int ct;
    assert(inBrd != NULL);
    wml = generateWhiteBoardlist(inBrd, opt_moves);

    if (opt_aim == MATE) {
        LL_FOREACH_SAFE(wml->vektor, bd, tmp) {
            if (bd->check == true) {
                bml = generateRefutations(bd, opt_moves);
                assert(bml != NULL);
                LL_COUNT(bml->vektor, tmp1, ct);

                if (ct == 0) {
                    stipAchieved = true;
                    bd->tag = '#';
                    freePosition(bd->pos);
                    bd->pos = NULL;
                } else {
                    LL_DELETE(wml->vektor, bd);
                    freeBoard(bd);
                }

                freeBoardlist(bml);
            } else {
                LL_DELETE(wml->vektor, bd);
                freeBoard(bd);
            }
        }
    } else {
        LL_FOREACH_SAFE(wml->vektor, bd, tmp) {
            if (bd->check == false) {
                bml = generateRefutations(bd, opt_moves);
                assert(bml != NULL);
                LL_COUNT(bml->vektor, tmp1, ct);

                if (ct == 0) {
                    stipAchieved = true;
                    bd->tag = '=';
                    freePosition(bd->pos);
                    bd->pos = NULL;
                } else {
                    LL_DELETE(wml->vektor, bd);
                    freeBoard(bd);
                }

                freeBoardlist(bml);
            } else {
                LL_DELETE(wml->vektor, bd);
                freeBoard(bd);
            }
        }
    }

    if (stipAchieved == true) {
        BOARDLIST* uml = generateWhiteBoardlist(inBrd, opt_moves);
        BOARD* b;
        LL_FOREACH(wml->vektor, b) {
            qualifyMove(uml, b);
        }
        freeBoardlist(uml);
    }

    wml->maxStip =
        (stipAchieved == true) ? (unsigned char) opt_moves : NOSTIP;
    wml->minStip =
        (stipAchieved == true) ? (unsigned char) opt_moves : NOSTIP;
    wml->stipIn =
        (stipAchieved == true) ? (unsigned char) opt_moves : NOSTIP;
    return wml;
}

static BOARDLIST* gloss_first_move(BOARD* brd, int moves)
{
    BOARDLIST* wml;
    BOARDLIST* bml;
    BOARD* b;
    BOARD* tmp;
    BOARD* tmp1;
    unsigned char minStip = NOSTIP;
    unsigned char maxStip = 0;
    bool bcheck;
    bool stipAchieved = false;
    int ct;
    wml = generateWhiteBoardlist(brd, 1);
    LL_FOREACH_SAFE(wml->vektor, b, tmp) {
        if (stipAchieved == true) {
            LL_DELETE(wml->vektor, b);
            freeBoard(b);
        } else {
            bcheck = b->check;
            bml = gloss_blackMove(b, moves);
            assert(bml != NULL);
            LL_COUNT(bml->vektor, tmp1, ct);

            if ((ct == 0) && (opt_aim == MATE)
                    && (bcheck == false)) {
                LL_DELETE(wml->vektor, b);
                freeBoard(b);
                freeBoardlist(bml);
            } else if ((ct == 0) && (opt_aim == STALEMATE)
                       && (bcheck == true)) {
                LL_DELETE(wml->vektor, b);
                freeBoard(b);
                freeBoardlist(bml);
            } else if (bml->stipIn == NOSTIP) {
                LL_DELETE(wml->vektor, b);
                freeBoard(b);
                freeBoardlist(bml);
            } else {
                stipAchieved = true;
                b->tag = '!';
                b->nextply = bml;
                minStip = (bml->stipIn < minStip) ? bml->stipIn : minStip;
                maxStip = (bml->stipIn > maxStip) ? bml->stipIn : maxStip;
            }
        }
    }

    if (stipAchieved == true) {
        wml->minStip = minStip;
        wml->maxStip = maxStip;
        wml->stipIn = minStip;
        BOARDLIST* uml = generateWhiteBoardlist(brd, 1);
        BOARD* bb;
        LL_FOREACH(wml->vektor, bb) {
            qualifyMove(uml, bb);
        }
        freeBoardlist(uml);
    } else {
        wml->minStip = NOSTIP;
        wml->maxStip = NOSTIP;
        wml->stipIn = NOSTIP;
    }

    return wml;
}

static BOARDLIST* norm_first_move(BOARD* brd)
{
    BOARDLIST* wml;
    BOARDLIST* bml;
    BOARD* b;
    BOARD* tmp;
    BOARD* tmp1;
    unsigned char minStip = NOSTIP;
    unsigned char maxStip = 0;
    bool stipAchieved = false;
    int ct;
    wml = generateWhiteBoardlist(brd, 1);
    LL_FOREACH_SAFE(wml->vektor, b, tmp) {
#ifdef MOVESTAT
        (void) fprintf(stderr,
                       "1.%2d-%2d (added = %u, hit_null = %u, hit_list = %u)\n",
                       b->from, b->to, hash_added, hash_hit_null,
                       hash_hit_list);
        (void) fflush(stderr);
#endif
        bml = blackMove(b);
        assert(bml != NULL);
        LL_COUNT(bml->vektor, tmp1, ct);

        if ((ct == 0) && (opt_aim == MATE)
                && (b->check == false)) {
            freeBoardlist(bml);
            LL_DELETE(wml->vektor, b);
            freeBoard(b);
            // Unwanted stalemate
        } else if ((ct == 0) && (opt_aim == STALEMATE)
                   && (b->check == true)) {
            freeBoardlist(bml);
            LL_DELETE(wml->vektor, b);
            freeBoard(b);
            // Unwanted mate
        } else if (bml->stipIn == NOSTIP) {
            // Not even a try
            freeBoardlist(bml);
            LL_DELETE(wml->vektor, b);
            freeBoard(b);
        } else if (bml->isTry == true) {
            stipAchieved = true;
            b->tag = '?';
            putRefutsToEnd(bml);
            b->nextply = bml;
            minStip = (bml->stipIn < minStip) ? bml->stipIn : minStip;
            maxStip = (bml->stipIn > maxStip) ? bml->stipIn : maxStip;
            /*
                     if ( opt_threats != NONE ) {
                        state = THREATS;
                        BOARDLIST *uml = getBoardlist( WHITE, 1 );

                        LL_APPEND( uml->vektor, b );
                        calculateThreats( uml );
                        state = TRIESKEYS;
                     }
            			*/
        } else {
            stipAchieved = true;
            b->tag = '!';
            b->nextply = bml;
            minStip = (bml->stipIn < minStip) ? bml->stipIn : minStip;
            maxStip = (bml->stipIn > maxStip) ? bml->stipIn : maxStip;
            /*
                     if ( opt_threats != NONE ) {
                        state = THREATS;
                        BOARDLIST *uml = getBoardlist( WHITE, 1 );

                        LL_APPEND( uml->vektor, b );
                        calculateThreats( uml );
                        state = TRIESKEYS;
                     }
            			*/
        }
    }

    if (stipAchieved == true) {
        wml->minStip = minStip;
        wml->maxStip = maxStip;
        wml->stipIn = minStip;
        BOARD* nb;
        BOARDLIST* uml = generateWhiteBoardlist(brd, 1);
        LL_FOREACH(wml->vektor, nb) {
            qualifyMove(uml, nb);
        }
        freeBoardlist(uml);
    } else {
        wml->minStip = NOSTIP;
        wml->maxStip = NOSTIP;
        wml->stipIn = NOSTIP;
    }

    return wml;
}

static void weedNonDefences(BOARDLIST* threats, BOARDLIST* bbl, bool fleck)
{
    BOARDLIST* wbl;
    unsigned int c;
    BOARD* bm;
    BOARD* tm;
    BOARD* wm;
    BOARD* tmp;
    BOARD* tmp1;
    assert(threats != NULL);
    assert(bbl != NULL);
    int ct;

    if (fleck == true) {
        LL_FOREACH_SAFE(bbl->vektor, bm, tmp) {
            if (bm->mover != KING) {
                wbl = bm->nextply;

                if (wbl != NULL) {
                    c = 0;
                    LL_FOREACH(threats->vektor, tm) {
                        LL_FOREACH(wbl->vektor, wm) {
                            if (deepEquals(wm, tm) == true) {
                                c++;
                            }
                        }
                    }
                    LL_COUNT(threats->vektor, tmp1, ct);

                    if (ct != c) {
                        LL_DELETE(bbl->vektor, bm);
                        freeBoard(bm);
                    }
                }
            }
        }
    } else {
        LL_FOREACH_SAFE(bbl->vektor, bm, tmp) {
            if (bm->mover != KING) {
                wbl = bm->nextply;

                if (wbl != NULL) {
                    c = 0;
                    LL_FOREACH(threats->vektor, tm) {
                        LL_FOREACH(wbl->vektor, wm) {
                            if (deepEquals(wm, tm) == true) {
                                c++;
                            }
                        }
                    }

                    if (c != 0) {
                        LL_DELETE(bbl->vektor, bm);
                        freeBoard(bm);
                    }
                }
            }
        }
    }

    return;
}

static void walkBBoardList(BOARDLIST* bbl)
{
    BOARDLIST* wbl;
    BOARD* brd;
    assert(bbl != NULL);

    if ((opt_moves - bbl->moveNumber) > 1) {
        LL_FOREACH(bbl->vektor, brd) {
            wbl = brd->nextply;

            if (wbl != NULL) {
                walkWBoardList(wbl);
            }
        }
    }

    return;
}

static void walkWBoardList(BOARDLIST* wbl)
{
    BOARDLIST* bbl;
    BOARDLIST* tbl;
    BOARD* wb;
    BOARD* tmp;
    int move;
    bool check;
    int ct;
    assert(wbl != NULL);
    move = wbl->moveNumber;
    LL_FOREACH(wbl->vektor, wb) {
        check = wb->check;
        bbl = wb->nextply;

        if (bbl != NULL) {
            assert(bbl->legalMoves != 0);

            if ((move + 1) == opt_moves) {
                if ((check == false) && (bbl->legalMoves > 1)) {
                    tbl = norm_final_move(wb, opt_moves);
                    assert(tbl != NULL);
                    LL_COUNT(tbl->vektor, tmp, ct);

                    if (ct > 0) {
                        wb->threat = tbl;
                        weedNonDefences(tbl, bbl, opt_fleck);
                    } else {
                        freeBoardlist(tbl);
                    }
                }
            } else {
                if ((check == false) && (bbl->legalMoves > 1)) {
                    tbl = norm_whiteMidMove(wb, move + 1);
                    assert(tbl != NULL);
                    walkWBoardList(tbl);
                    walkBBoardList(bbl);
                    LL_COUNT(tbl->vektor, tmp, ct);

                    if (ct > 0) {
                        wb->threat = tbl;
                        weedNonDefences(tbl, bbl, opt_fleck);
                    } else {
                        freeBoardlist(tbl);
                    }
                } else {
                    walkBBoardList(bbl);
                }
            }
        }
    }
    return;
}

static void calculateThreats(BOARDLIST* wbl)
{
    walkWBoardList(wbl);
    return;
}

static void sortTriesKeys(DIR_SOL* ds)
{
    BOARD* b;
    BOARD* bc;
    BOARDLIST* g_keys = getBoardlist(WHITE, 1);
    BOARDLIST* g_tries = getBoardlist(WHITE, 1);
    LL_FOREACH(ds->trieskeys->vektor, b) {
        bc = cloneBoard(b);

        if (isKey(b) == true) {
            LL_APPEND(g_keys->vektor, bc);
        } else {
            LL_APPEND(g_tries->vektor, bc);
        }
    }
    ds->tries = g_tries;
    ds->keys = g_keys;
    return;
}

static void deTrivialise(BOARDLIST* wml)
{
    BOARDLIST* bml;
    BOARD* wm;
    BOARD* tmp;
    BOARD* tmp1;
    int ct;
    assert(wml != NULL);
    LL_FOREACH_SAFE(wml->vektor, wm, tmp) {
        bml = wm->nextply;

        if (bml != NULL) {
            LL_COUNT(bml->vektor, tmp1, ct);

            if (ct < 2) {
                LL_DELETE(wml->vektor, wm);
                freeBoard(wm);
            }
        }
    }
    return;
}

static BOARDLIST* calculateSetPlay(BOARD* inBrd)
{
    BOARDLIST* bList;
    BOARDLIST* wList;
    BOARD* ourBrd;
    BOARD* tmp;
    int stipIn;
    unsigned int flights;
    assert(inBrd != NULL);
    bList = generateBlackBoardlist(inBrd, 1, &flights);
    LL_FOREACH_SAFE(bList->vektor, ourBrd, tmp) {
        if (opt_moves > 2) {
            wList = norm_whiteMidMove(ourBrd, 2);
        } else {
            wList = norm_final_move(ourBrd, 2);
        }

        assert(wList != NULL);
        stipIn = wList->stipIn;

        if (stipIn != NOSTIP) {
            ourBrd->nextply = wList;
            qualifyMove(bList, ourBrd);
        } else {
            LL_DELETE(bList->vektor, ourBrd);
            freeBoard(ourBrd);
            freeBoardlist(wList);
        }
    }
    return bList;
}

static void calculateSetThreats(BOARDLIST* bml)
{
    walkBBoardList(bml);
    return;
}

static BOARDLIST* gloss_final_move(BOARD* inBrd, int moveno)
{
    BOARDLIST* wml;
    BOARDLIST* bml;
    BOARD* bd;
    BOARD* tmp;
    BOARD* tmp1;
    bool stipAchieved = false;
    int ct;
    assert(inBrd != NULL);
    wml = generateWhiteBoardlist(inBrd, moveno);

    if (opt_aim == MATE) {
        LL_FOREACH_SAFE(wml->vektor, bd, tmp) {
            if (stipAchieved == true) {
                LL_DELETE(wml->vektor, bd);
                freeBoard(bd);
            } else {
                if (bd->check == true) {
                    bml = generateRefutations(bd, moveno);
                    assert(bml != NULL);
                    LL_COUNT(bml->vektor, tmp1, ct);
                    freeBoardlist(bml);

                    if (ct == 0) {
                        stipAchieved = true;
                        bd->tag = '#';
                        freePosition(bd->pos);
                        bd->pos = NULL;
                    } else {
                        LL_DELETE(wml->vektor, bd);
                        freeBoard(bd);
                    }
                } else {
                    LL_DELETE(wml->vektor, bd);
                    freeBoard(bd);
                }
            }
        }
    } else {
        LL_FOREACH_SAFE(wml->vektor, bd, tmp) {
            if (stipAchieved == true) {
                LL_DELETE(wml->vektor, bd);
                freeBoard(bd);
            } else {
                if (bd->check == false) {
                    bml = generateRefutations(bd, moveno);
                    assert(bml != NULL);
                    LL_COUNT(bml->vektor, tmp1, ct);
                    freeBoardlist(bml);

                    if (ct == 0) {
                        stipAchieved = true;
                        bd->tag = '=';
                        freePosition(bd->pos);
                        bd->pos = NULL;
                    } else {
                        LL_DELETE(wml->vektor, bd);
                        freeBoard(bd);
                    }
                } else {
                    LL_DELETE(wml->vektor, bd);
                    freeBoard(bd);
                }
            }
        }
    }

    if (stipAchieved == true) {
        BOARDLIST* uml = generateWhiteBoardlist(inBrd, opt_moves);
        BOARD* b;
        LL_FOREACH(wml->vektor, b) {
            qualifyMove(uml, b);
        }
        freeBoardlist(uml);
    }

    wml->maxStip = (stipAchieved == true) ? (unsigned char) moveno : NOSTIP;
    wml->minStip = (stipAchieved == true) ? (unsigned char) moveno : NOSTIP;
    wml->stipIn = (stipAchieved == true) ? (unsigned char) moveno : NOSTIP;
    return wml;
}

static BOARDLIST* norm_whiteMidMove(BOARD* inBrd, int move)
{
    BOARDLIST* wml;
    BOARDLIST* bml;
    BOARD* m;
    BOARD* tmp;
    BOARD* tmp1;
    int ct;
    bool shortStipAchieved = false;
    bool stipAchieved = false;
    unsigned char maxStip = 0;
    unsigned char minStip = NOSTIP;
    assert(inBrd != NULL);
    wml = generateWhiteBoardlist(inBrd, move);

    if ((state != THREATS) || ((state == THREATS)
                               && (opt_threats == SHORTEST))) {
        if (opt_aim == MATE) {
            LL_FOREACH_SAFE(wml->vektor, m, tmp) {
                if (m->check == true) {
                    bml = generateRefutations(m, move);
                    assert(bml != NULL);
                    LL_COUNT(bml->vektor, tmp1, ct);
                    freeBoardlist(bml);

                    if (ct == 0) {
                        shortStipAchieved = true;
                        m->tag = '#';
                        //freePosition( m->pos );
                        //m->pos = NULL;
                    } else {
                        LL_DELETE(wml->vektor, m);
                        freeBoard(m);
                    }
                } else {
                    LL_DELETE(wml->vektor, m);
                    freeBoard(m);
                }
            }
        } else {
            LL_FOREACH_SAFE(wml->vektor, m, tmp) {
                if (m->check == false) {
                    bml = generateRefutations(m, move);
                    assert(bml != NULL);
                    LL_COUNT(bml->vektor, tmp1, ct);
                    freeBoardlist(bml);

                    if (ct == 0) {
                        shortStipAchieved = true;
                        m->tag = '=';
                        //freePosition( m->pos );
                        //m->pos = NULL;
                    } else {
                        LL_DELETE(wml->vektor, m);
                        freeBoard(m);
                    }
                } else {
                    LL_DELETE(wml->vektor, m);
                    freeBoard(m);
                }
            }
        }

        if (shortStipAchieved == true) {
            wml->minStip = (unsigned char) move;
            wml->maxStip = maxStip;
            wml->stipIn = (unsigned char) move;
            BOARD* nb;
            BOARDLIST* uml = generateWhiteBoardlist(inBrd, move);
            LL_FOREACH(wml->vektor, nb) {
                qualifyMove(uml, nb);
            }
            freeBoardlist(uml);
            return wml;
        }
    }

    freeBoardlist(wml);
    wml = generateWhiteBoardlist(inBrd, move);

    if (opt_moves > 3) {
        sortWhiteMoves(wml);
    }

    LL_FOREACH_SAFE(wml->vektor, m, tmp) {
        if ((state != THREATS) && (shortStipAchieved == true)) {
            LL_DELETE(wml->vektor, m);
            freeBoard(m);
        } else {
            bml = norm_blackMidMove(m, move);
            assert(bml != NULL);
            LL_COUNT(bml->vektor, tmp1, ct);

            if ((ct == 0) && (opt_aim == STALEMATE)
                    && (m->check == true)) {
                LL_DELETE(wml->vektor, m);
                freeBoard(m);
                freeBoardlist(bml);
            } else if ((ct == 0) && (opt_aim == MATE)
                       && (m->check == false)) {
                LL_DELETE(wml->vektor, m);
                freeBoard(m);
                freeBoardlist(bml);
            } else if (bml->stipIn == NOSTIP) {
                LL_DELETE(wml->vektor, m);
                freeBoard(m);
                freeBoardlist(bml);
            } else {
                stipAchieved = true;
                m->nextply = bml;
                maxStip = (bml->stipIn > maxStip) ? bml->stipIn : maxStip;
                minStip = (bml->stipIn < minStip) ? bml->stipIn : minStip;

                if (minStip < (unsigned char) opt_moves) {
                    shortStipAchieved = true;
                }
            }
        }
    }

    if (stipAchieved == true) {
        wml->minStip = minStip;
        wml->maxStip = maxStip;
        wml->stipIn = minStip;

        if (minStip != maxStip) {
            if ((state != THREATS) || ((state == THREATS)
                                       && (opt_threats == SHORTEST))) {
                weedOutLongVars(wml);
            }
        }

        BOARD* nb;
        BOARDLIST* uml = generateWhiteBoardlist(inBrd, move);
        LL_FOREACH(wml->vektor, nb) {
            qualifyMove(uml, nb);
        }
        freeBoardlist(uml);
    } else {
        wml->minStip = NOSTIP;
        wml->maxStip = NOSTIP;
        wml->stipIn = NOSTIP;
    }

    return wml;
}
