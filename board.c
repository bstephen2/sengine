
/*
 *	board.c
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
 *	This is the module that includes all routines to do with boards.
 */
#include "sengine.h"
extern char* opt_castling;
extern char* opt_ep;
extern char* opt_kings;
extern char* opt_gbr;
extern char* opt_pos;
extern BITBOARD setMask[64];
extern BITBOARD clearMask[64];
extern BITBOARD king_attacks[64];
extern BITBOARD knight_attacks[64];
extern BITBOARD bishop_attacks[64];
extern BITBOARD rook_attacks[64];
extern BITBOARD pawn_attacks[2][64];
extern BITBOARD pawn_moves[2][64];
extern BBOARD rook_commonAttacks[64][64];
extern BBOARD bishop_commonAttacks[64][64];

static const enum PIECE proms[] = { QUEEN, KNIGHT, BISHOP, ROOK };

static const char pcArray[] = "**SBRQK";
static const char fileArray[] = "abcdefgh";
static const char numbers[] = "0123456789";
static const char squares[] =
    "a1b1c1d1e1f1g1h1a2b2c2d2e2f2g2h2a3b3c3d3e3f3g3h3a4b4c4d4e4f4g4h4a5b5c5d5e5f5g5h5a6b6c6d6e6f6g6h6a7b7c7d7e7f7g7h7a8b8c8d8e8f8g8h8";

#ifdef MOVESTAT

char* toSquare(unsigned char ins)
{
    int i = (ins * 2);
    char* rsq = calloc(1, 3);
    rsq[0] = squares[i];
    rsq[1] = squares[i + 1];
    rsq[2] = '\0';
    return rsq;
}

#endif

int tzcount(BITBOARD inBrd)
{
    if (inBrd == 0) {
        return 64;
    }

    return __builtin_ctzll(inBrd);
}

void getKillerHashKey(BOARD* bd, KILLERKEY* kk)
{
    kk->kkey[0] = bd->from;
    kk->kkey[1] = bd->to;
    kk->kkey[2] = (unsigned char) bd->promotion;
    return;
}

void getHashKey(BOARD* bd, HASHKEY* hk)
{
    md5_state_t pms;
    md5_init(&pms);
    md5_append(&pms, & (bd->ply), 1);
    md5_append(&pms, & (bd->pos->flags), 1);
    md5_append(&pms, (unsigned char*) & (bd->pos->bitBoard), 112);
    md5_finish(&pms, hk->hashkey);
    return;
}

bool boardEquals(BOARD* ibd, BOARD* obd)
{
    assert(obd != NULL);
    assert(ibd != NULL);
    assert(ibd != obd);

    if (obd->mover != ibd->mover) {
        return false;
    }

    if (obd->from != ibd->from) {
        return false;
    }

    if (obd->to != ibd->to) {
        return false;
    }

    if (obd->captured != ibd->captured) {
        return false;
    }

    if (obd->check != ibd->check) {
        return false;
    }

    if (obd->tag != ibd->tag) {
        return false;
    }

    if (obd->ep != ibd->ep) {
        return false;
    }

    return true;
}

bool deepEquals(BOARD* ibd, BOARD* obd)
{
    BOARDLIST* bl1;
    BOARDLIST* bl2;
    assert(ibd != NULL);
    assert(obd != NULL);

    if (boardEquals(ibd, obd) == false) {
        return false;
    } else {
        if ((obd->nextply != NULL) && (ibd->nextply != NULL)) {
            bl1 = obd->nextply;
            bl2 = ibd->nextply;

            if (bListEquals(bl1, bl2) == false) {
                return false;
            }
        } else if ((obd->nextply == NULL) && (ibd->nextply == NULL)) {
        } else {
            return false;
        }

        if ((obd->threat != NULL) && (ibd->threat != NULL)) {
            bl1 = obd->threat;
            bl2 = ibd->threat;

            if (bListEquals(bl1, bl2) == false) {
                return false;
            }
        } else if ((obd->threat == NULL) && (ibd->threat == NULL)) {
        } else {
            return false;
        }
    }

    return true;
}

bool isKey(BOARD* b)
{
    bool rb = false;

    if ((b->tag == '!') || (b->tag == '#') || (b->tag == '=')) {
        rb = true;
    }

    return rb;
}

BOARD* setup_diagram(enum COLOUR played)
{
    BOARD* rb;
    POSITION pos;
    POSITION* ppos = &pos;
    int i, p;
    char* po;
    div_t qr;
    (void) memset(&pos, '\0', sizeof(POSITION));
    pos.flags = (unsigned char)(played ^ 1);

    // Castling

    if (opt_castling != NULL) {
        if (strchr(opt_castling, 'k') != NULL) {
            pos.flags |= B_KING_CASTLING;
        }

        if (strchr(opt_castling, 'q') != NULL) {
            pos.flags |= B_QUEEN_CASTLING;
        }

        if (strchr(opt_castling, 'K') != NULL) {
            pos.flags |= W_KING_CASTLING;
        }

        if (strchr(opt_castling, 'Q') != NULL) {
            pos.flags |= W_QUEEN_CASTLING;
        }
    }

    // Kings
    i = SQUARE_TO_INT(opt_kings);
    pos.kingsq[WHITE] = (char) i;
    pos.bitBoard[WHITE][KING] |= setMask[i];
    pos.bitBoard[WHITE][OCCUPIED] |= setMask[i];
    i = SQUARE_TO_INT(opt_kings + 2);
    pos.kingsq[BLACK] = (char) i;
    pos.bitBoard[BLACK][KING] |= setMask[i];
    pos.bitBoard[BLACK][OCCUPIED] |= setMask[i];
    // Rest of position
    po = opt_pos;
    // Queens
    p = opt_gbr[0] - '0';
    qr = div(p, 3);
    p = qr.rem;

    while (p != 0) {
        i = SQUARE_TO_INT(po);
        pos.bitBoard[WHITE][QUEEN] |= setMask[i];
        pos.bitBoard[WHITE][OCCUPIED] |= setMask[i];
        p--;
        po += 2;
    }

    p = qr.quot;

    while (p != 0) {
        i = SQUARE_TO_INT(po);
        pos.bitBoard[BLACK][QUEEN] |= setMask[i];
        pos.bitBoard[BLACK][OCCUPIED] |= setMask[i];
        p--;
        po += 2;
    }

    // Rooks
    p = opt_gbr[1] - '0';
    qr = div(p, 3);
    p = qr.rem;

    while (p != 0) {
        i = SQUARE_TO_INT(po);
        pos.bitBoard[WHITE][ROOK] |= setMask[i];
        pos.bitBoard[WHITE][OCCUPIED] |= setMask[i];
        p--;
        po += 2;
    }

    p = qr.quot;

    while (p != 0) {
        i = SQUARE_TO_INT(po);
        pos.bitBoard[BLACK][ROOK] |= setMask[i];
        pos.bitBoard[BLACK][OCCUPIED] |= setMask[i];
        p--;
        po += 2;
    }

    // Bishops
    p = opt_gbr[2] - '0';
    qr = div(p, 3);
    p = qr.rem;

    while (p != 0) {
        i = SQUARE_TO_INT(po);
        pos.bitBoard[WHITE][BISHOP] |= setMask[i];
        pos.bitBoard[WHITE][OCCUPIED] |= setMask[i];
        p--;
        po += 2;
    }

    p = qr.quot;

    while (p != 0) {
        i = SQUARE_TO_INT(po);
        pos.bitBoard[BLACK][BISHOP] |= setMask[i];
        pos.bitBoard[BLACK][OCCUPIED] |= setMask[i];
        p--;
        po += 2;
    }

    // Knights
    p = opt_gbr[3] - '0';
    qr = div(p, 3);
    p = qr.rem;

    while (p != 0) {
        i = SQUARE_TO_INT(po);
        pos.bitBoard[WHITE][KNIGHT] |= setMask[i];
        pos.bitBoard[WHITE][OCCUPIED] |= setMask[i];
        p--;
        po += 2;
    }

    p = qr.quot;

    while (p != 0) {
        i = SQUARE_TO_INT(po);
        pos.bitBoard[BLACK][KNIGHT] |= setMask[i];
        pos.bitBoard[BLACK][OCCUPIED] |= setMask[i];
        p--;
        po += 2;
    }

    // White Pawns
    p = opt_gbr[5] - '0';

    while (p > 0) {
        i = SQUARE_TO_INT(po);
        pos.bitBoard[WHITE][PAWN] |= setMask[i];
        pos.bitBoard[WHITE][OCCUPIED] |= setMask[i];
        p--;
        po += 2;
    }

    // Black Pawns
    p = opt_gbr[6] - '0';

    while (p > 0) {
        i = SQUARE_TO_INT(po);
        pos.bitBoard[BLACK][PAWN] |= setMask[i];
        pos.bitBoard[BLACK][OCCUPIED] |= setMask[i];
        p--;
        po += 2;
    }

    rb = getBoard(ppos, (unsigned char) played, 0);

    // Ep

    if (opt_ep != NULL) {
        rb->epSquare = (char) SQUARE_TO_INT(opt_ep);
    }

#ifdef SHOWTZCOUNT
    (void) fprintf(stderr, "0 => %d\n", tzcount(0));
    (void) fprintf(stderr, "1 => %d\n", tzcount(1));
    (void) fprintf(stderr, "2 => %d\n", tzcount(2));
    (void) fprintf(stderr, "4 => %d\n", tzcount(4));
    (void) fprintf(stderr, "1<< 31 => %d\n", tzcount(setMask[31]));
    (void) fprintf(stderr, "1<< 32 => %d\n", tzcount(setMask[32]));
    (void) fprintf(stderr, "1<< 33 => %d\n", tzcount(setMask[33]));
    (void) fprintf(stderr, "1<< 63 => %d\n", tzcount(setMask[63]));
#endif
    return rb;
}

bool attacks(POSITION* pos, unsigned char square, enum COLOUR colour)
{
    BITBOARD qb;
    BITBOARD qr;
    BITBOARD occupied;
    BBOARD temp;
    int i;

    // (1) Attack by King?

    if ((king_attacks[square] & pos->bitBoard[colour][KING]) != 0) {
        return true;
    }

    // (2) Atack by a Pawn?

    if ((pawn_attacks[colour ^ 1][square] & pos->bitBoard[colour][PAWN]) !=
            0) {
        return true;
    }

    // (3) Attack by a Knight?

    if ((knight_attacks[square] & pos->bitBoard[colour][KNIGHT]) != 0) {
        return true;
    }

    // (4) Attack by bishop/queen?
    qb = pos->bitBoard[colour][BISHOP] | pos->bitBoard[colour][QUEEN];
    occupied = pos->bitBoard[WHITE][OCCUPIED] | pos->bitBoard[BLACK][OCCUPIED];

    if ((bishop_attacks[square] & qb) != 0) {
        i = tzcount(qb);

        while (i < 64) {
            temp = bishop_commonAttacks[i][square];

            if (temp.used == true) {
                if ((occupied & temp.bb) == 0) {
                    return true;
                }
            }

            qb &= clearMask[i];
            i = tzcount(qb);
        }
    }

    // (5) Attack by rook/queen?
    qr = pos->bitBoard[colour][ROOK] | pos->bitBoard[colour][QUEEN];

    if ((rook_attacks[square] & qr) != 0) {
        i = tzcount(qr);

        while (i < 64) {
            temp = rook_commonAttacks[i][square];

            if (temp.used == true) {
                if ((occupied & temp.bb) == 0) {
                    return true;
                }
            }

            qr &= clearMask[i];
            i = tzcount(qr);
        }
    }

    return false;
}

int validate_board(BOARD* inBrd)
{
    int rc = 0;
    bool wcheck;
    bool bcheck;
#ifdef SHOWBOARD
    display_board(inBrd);
#endif
    wcheck = ISWHITEINCHECK(inBrd->pos);
    bcheck = ISBLACKINCHECK(inBrd->pos);

    if ((inBrd->side == BLACK) && (bcheck == true)) {
        rc = 1;
        (void) fputs("sengine ERROR: White to play and Black in check\n",
                     stderr);
    } else if ((inBrd->side == WHITE) && (wcheck == true)) {
        rc = 1;
        (void) fputs("sengine ERROR: Black to play and White in check\n",
                     stderr);
    }

    if (rc == 0) {
        if ((inBrd->side == BLACK) && (wcheck == true)) {
            inBrd->check = wcheck;
        } else if ((inBrd->side == WHITE) && (bcheck == true)) {
            inBrd->check = bcheck;
        }
    }

    return rc;
}

#ifdef SHOWBOARD

char* getSquares(BITBOARD inLong)
{
    int i;
    int c = 0;
    char n[100];
    char* rs = (char*) malloc(100);
    *rs = '\0';
    BITBOARD iTos = inLong;
    i = tzcount(iTos);

    while (i < 64) {
        if (c != 0) {
            (void) strcat(rs, ", ");
        }

        c++;
        sprintf(n, "%d", i);
        (void) strcat(rs, n);
        iTos &= clearMask[i];
        i = tzcount(iTos);
    }

    return rs;
}
#endif

static void nMakeMove(POSITION* ppos, enum COLOUR colour, enum PIECE pic,
                      int inFrom, int inTo)
{
    BITBOARD clearFrom = clearMask[inFrom];
    BITBOARD setTo = setMask[inTo];
    BITBOARD clearTo = clearMask[inTo];
    ppos->bitBoard[colour][pic] &= clearFrom;
    ppos->bitBoard[colour][pic] |= setTo;
    ppos->bitBoard[colour][OCCUPIED] &= clearFrom;
    ppos->bitBoard[colour][OCCUPIED] |= setTo;
    ppos->bitBoard[colour ^ 1][OCCUPIED] &= clearTo;
    ppos->bitBoard[colour ^ 1][PAWN] &= clearTo;
    ppos->bitBoard[colour ^ 1][KNIGHT] &= clearTo;
    ppos->bitBoard[colour ^ 1][BISHOP] &= clearTo;
    ppos->bitBoard[colour ^ 1][ROOK] &= clearTo;
    ppos->bitBoard[colour ^ 1][QUEEN] &= clearTo;
    return;
}

static void recordMove(BOARD* bd, enum COLOUR colour, enum PIECE pic,
                       int inFrom, int inTo, enum PIECE inProm, BOARD* fbd)
{
    assert(fbd != NULL);
    assert(bd != NULL);
    assert(bd != fbd);
    bd->mover = (unsigned char) pic;
    bd->from = (unsigned char) inFrom;
    bd->to = (unsigned char) inTo;
    bd->promotion = inProm;

    if ((fbd->pos->bitBoard[colour ^ 1][OCCUPIED] & setMask[inTo]) != 0) {
        bd->captured = true;
    } else {
        bd->captured = false;
    }

    bd->check = attacks(bd->pos, bd->pos->kingsq[colour ^ 1], colour);
    bd->ep = false;
    bd->epSquare = 0;

    if (colour == WHITE) {
        bd->pos->flags |= BLACK;
    } else {
        bd->pos->flags |= WHITE;
    }

    return;
}

void generateKingMoves(BOARD* bd, enum COLOUR colour, BOARDLIST* bl)
{
    int i, iFrom;
    BITBOARD iTos, occupied;
    BOARD* nb;
    POSITION npos;
    assert(bd != NULL);
    assert(bl != NULL);
    assert(bd->pos != NULL);
    iFrom = bd->pos->kingsq[colour];
    iTos = king_attacks[iFrom];
    i = tzcount(iTos);
    occupied = bd->pos->bitBoard[colour][OCCUPIED];

    while (i < 64) {
        if ((occupied & setMask[i]) == 0) {
            npos = * (bd->pos);
            nMakeMove(&npos, colour, KING, iFrom, i);
            npos.kingsq[colour] = (unsigned char) i;

            if (attacks(&npos, (unsigned char) i, (colour ^ 1)) == false) {
                nb = getBoard(&npos, (unsigned char) colour, bl->moveNumber);
                recordMove(nb, colour, KING, iFrom, i, NOPIECE, bd);

                if (colour == WHITE) {
                    nb->pos->flags &= ~(W_KING_CASTLING);
                    nb->pos->flags &= ~(W_QUEEN_CASTLING);
                } else {
                    nb->pos->flags &= ~(B_KING_CASTLING);
                    nb->pos->flags &= ~(B_QUEEN_CASTLING);
                }

                LL_APPEND(bl->vektor, nb);
            }
        }

        iTos &= clearMask[i];
        i = tzcount(iTos);
    }

    return;
}

void generateKnightMoves(BOARD* bd, enum COLOUR colour, BOARDLIST* bl)
{
    int i, j;
    BOARD* nb;
    BITBOARD temp, occupied;
    BITBOARD jtemp;
    POSITION npos;
    assert(bl != NULL);
    temp = bd->pos->bitBoard[colour][KNIGHT];
    occupied = bd->pos->bitBoard[colour][OCCUPIED];
    i = tzcount(temp);

    while (i < 64) {
        // Found a knight at i.
        jtemp = knight_attacks[i];
        j = tzcount(jtemp);

        while (j < 64) {
            // Found an attacked square at j.
            if ((occupied & setMask[j]) == 0) {
                // Not occupied by a friendly piece.
                npos = * (bd->pos);
                nMakeMove(&npos, colour, KNIGHT, i, j);

                if (attacks(&npos, npos.kingsq[colour], (colour ^ 1)) == true) {
                    if (bd->check == false) {
                        /*
                           Not in check before this move, so knight must be pinned.
                         */
                        break;
                    }
                } else {
                    nb = getBoard(&npos, (unsigned char) colour, bl->moveNumber);
                    recordMove(nb, colour, KNIGHT, i, j, NOPIECE, bd);
                    LL_APPEND(bl->vektor, nb);
                }
            }

            jtemp &= clearMask[j];
            j = tzcount(jtemp);
        }

        temp &= clearMask[i];
        i = tzcount(temp);
    }

    return;
}

void generateBishopLikeMoves(BOARD* bd, enum COLOUR colour, BOARDLIST* bl,
                             enum PIECE pic)
{
    int i, j;
    BOARD* nb;
    BITBOARD occupied;
    BITBOARD ptemp;
    BITBOARD jtemp;
    BBOARD bboard;
    POSITION npos;
    assert(bl != NULL);
    occupied =
        bd->pos->bitBoard[WHITE][OCCUPIED] | bd->pos->bitBoard[BLACK][OCCUPIED];
    BITBOARD coccupied = bd->pos->bitBoard[colour][OCCUPIED];
    ptemp = bd->pos->bitBoard[colour][pic];
    i = tzcount(ptemp);

    while (i < 64) {
        jtemp = bishop_attacks[i];
        j = tzcount(jtemp);

        while (j < 64) {
            if ((coccupied & setMask[j]) == 0) {
                bboard = bishop_commonAttacks[i][j];
                assert(bboard.used == true);

                if ((occupied & bboard.bb) == 0) {
                    npos = * (bd->pos);
                    nMakeMove(&npos, colour, pic, i, j);

                    if (attacks(&npos, npos.kingsq[colour], (colour ^ 1)) ==
                            false) {
                        nb = getBoard(&npos, (unsigned char) colour,
                                      bl->moveNumber);
                        recordMove(nb, colour, pic, i, j, NOPIECE, bd);
                        LL_APPEND(bl->vektor, nb);
                    }
                }
            }

            jtemp &= clearMask[j];
            j = tzcount(jtemp);
        }

        ptemp &= clearMask[i];
        i = tzcount(ptemp);
    }

    return;
}

void generateRookLikeMoves(BOARD* bd, enum COLOUR colour, BOARDLIST* bl,
                           enum PIECE pic)
{
    int i, j;
    BOARD* nb;
    BBOARD temp;
    BITBOARD occupied =
        bd->pos->bitBoard[WHITE][OCCUPIED] | bd->pos->bitBoard[BLACK][OCCUPIED];
    BITBOARD coccupied = bd->pos->bitBoard[colour][OCCUPIED];
    BITBOARD ptemp = bd->pos->bitBoard[colour][pic];
    BITBOARD jtemp;
    POSITION npos;
    assert(bl != NULL);
    i = tzcount(ptemp);

    while (i < 64) {
        jtemp = rook_attacks[i];
        j = tzcount(jtemp);

        while (j < 64) {
            if ((coccupied & setMask[j]) == 0) {
                temp = rook_commonAttacks[i][j];
                assert(temp.used == true);

                if ((occupied & temp.bb) == 0) {
                    npos = * (bd->pos);
                    nMakeMove(&npos, colour, pic, i, j);

                    if (attacks(&npos, npos.kingsq[colour], (colour ^ 1)) ==
                            false) {
                        nb = getBoard(&npos, (unsigned char) colour,
                                      bl->moveNumber);
                        recordMove(nb, colour, pic, i, j, NOPIECE, bd);

                        if (pic == ROOK) {
                            if (colour == WHITE) {
                                if (i == 0) {
                                    nb->pos->flags &= ~(W_QUEEN_CASTLING);
                                } else if (i == 7) {
                                    nb->pos->flags &= ~(W_KING_CASTLING);
                                }
                            } else {
                                if (i == 56) {
                                    nb->pos->flags &= ~(B_QUEEN_CASTLING);
                                } else if (i == 63) {
                                    nb->pos->flags &= ~(B_KING_CASTLING);
                                }
                            }
                        }

                        LL_APPEND(bl->vektor, nb);
                    }
                }
            }

            jtemp &= clearMask[j];
            j = tzcount(jtemp);
        }

        ptemp &= clearMask[i];
        i = tzcount(ptemp);
    }

    return;
}

void generateWhiteCastlings(BOARD* bd, BOARDLIST* bl)
{
    BITBOARD occupied;
    BOARD* nb;
    assert(bl != NULL);
    occupied =
        (bd->pos->bitBoard[WHITE][OCCUPIED] | bd->pos->
         bitBoard[BLACK][OCCUPIED]);

    if ((bd->check == false) && (bd->pos->kingsq[WHITE] == 4)) {
        if ((bd->pos->flags & W_KING_CASTLING) == W_KING_CASTLING) {
            if ((bd->pos->bitBoard[WHITE][ROOK] & setMask[7]) != 0) {
                if ((occupied & setMask[5]) == 0) {
                    if ((occupied & setMask[6]) == 0) {
                        if (attacks(bd->pos, 5, BLACK) == false) {
                            if (attacks(bd->pos, 6, BLACK) == false) {
                                nb = getBoard(bd->pos, WHITE, bl->moveNumber);
                                nMakeMove(nb->pos, WHITE, KING, 4, 6);
                                nMakeMove(nb->pos, WHITE, ROOK, 7, 5);
                                nb->pos->kingsq[WHITE] = 6;
                                recordMove(nb, WHITE, KING, 4, 6, NOPIECE, bd);
                                nb->pos->flags &= ~(W_KING_CASTLING);
                                nb->pos->flags &= ~(W_QUEEN_CASTLING);
                                LL_APPEND(bl->vektor, nb);
                            }
                        }
                    }
                }
            }
        }

        if ((bd->pos->flags & W_QUEEN_CASTLING) == W_QUEEN_CASTLING) {
            if ((bd->pos->bitBoard[WHITE][ROOK] & setMask[0]) != 0) {
                if ((occupied & setMask[3]) == 0) {
                    if ((occupied & setMask[2]) == 0) {
                        if ((occupied & setMask[1]) == 0) {
                            if (attacks(bd->pos, 2, BLACK) == false) {
                                if (attacks(bd->pos, 3, BLACK) == false) {
                                    nb = getBoard(bd->pos, WHITE, bl->moveNumber);
                                    nMakeMove(nb->pos, WHITE, KING, 4, 2);
                                    nMakeMove(nb->pos, WHITE, ROOK, 0, 3);
                                    nb->pos->kingsq[WHITE] = 2;
                                    recordMove(nb, WHITE, KING, 4, 2, NOPIECE, bd);
                                    nb->pos->flags &= ~(W_KING_CASTLING);
                                    nb->pos->flags &= ~(W_QUEEN_CASTLING);
                                    LL_APPEND(bl->vektor, nb);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    return;
}

void generateBlackCastlings(BOARD* bd, BOARDLIST* bl)
{
    BITBOARD occupied;
    BOARD* nb;
    assert(bl != NULL);
    occupied =
        (bd->pos->bitBoard[WHITE][OCCUPIED] | bd->
         pos->bitBoard[BLACK][OCCUPIED]);

    if ((bd->check == false) && (bd->pos->kingsq[BLACK] == 60)) {
        if ((bd->pos->flags & B_KING_CASTLING) == B_KING_CASTLING) {
            if ((bd->pos->bitBoard[BLACK][ROOK] & setMask[63]) != 0) {
                if ((occupied & setMask[61]) == 0) {
                    if ((occupied & setMask[62]) == 0) {
                        if (attacks(bd->pos, 61, WHITE) == false) {
                            if (attacks(bd->pos, 62, WHITE) == false) {
                                nb = getBoard(bd->pos, BLACK, bl->moveNumber);
                                nMakeMove(nb->pos, BLACK, KING, 60, 62);
                                nMakeMove(nb->pos, BLACK, ROOK, 63, 61);
                                nb->pos->kingsq[BLACK] = 62;
                                recordMove(nb, BLACK, KING, 60, 62, NOPIECE, bd);
                                nb->pos->flags &= ~(B_KING_CASTLING);
                                nb->pos->flags &= ~(B_QUEEN_CASTLING);
                                LL_APPEND(bl->vektor, nb);
                            }
                        }
                    }
                }
            }
        }

        if ((bd->pos->flags & B_QUEEN_CASTLING) == B_QUEEN_CASTLING) {
            if ((bd->pos->bitBoard[BLACK][ROOK] & setMask[56]) != 0) {
                if ((occupied & setMask[59]) == 0) {
                    if ((occupied & setMask[58]) == 0) {
                        if ((occupied & setMask[57]) == 0) {
                            if (attacks(bd->pos, 59, WHITE) == false) {
                                if (attacks(bd->pos, 58, WHITE) == false) {
                                    nb = getBoard(bd->pos, BLACK, bl->moveNumber);
                                    nMakeMove(nb->pos, BLACK, KING, 60, 58);
                                    nMakeMove(nb->pos, BLACK, ROOK, 56, 59);
                                    nb->pos->kingsq[BLACK] = 58;
                                    recordMove(nb, BLACK, KING, 60, 58, NOPIECE, bd);
                                    nb->pos->flags &= ~(B_KING_CASTLING);
                                    nb->pos->flags &= ~(B_QUEEN_CASTLING);
                                    LL_APPEND(bl->vektor, nb);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    return;
}

void generateEP(BOARD* bd, enum COLOUR colour, BOARDLIST* bl)
{
    int iFile, from, to;
    BOARD* nb;
    assert(bl != NULL);
    iFile = FILE(bd->epSquare);

    if (iFile != 0) {
        from = bd->epSquare - 1;

        if ((bd->pos->bitBoard[colour][PAWN] & setMask[from]) != 0) {
            if (colour == WHITE) {
                to = bd->epSquare + 8;
            } else {
                to = bd->epSquare - 8;
            }

            nb = getBoard(bd->pos, (unsigned char) colour, bl->moveNumber);
            nb->pos->bitBoard[colour][PAWN] &= clearMask[from];
            nb->pos->bitBoard[colour][OCCUPIED] &= clearMask[from];
            nb->pos->bitBoard[colour][PAWN] |= setMask[to];
            nb->pos->bitBoard[colour][OCCUPIED] |= setMask[to];
            nb->pos->bitBoard[colour ^ 1][OCCUPIED] &= clearMask[bd->epSquare];
            nb->pos->bitBoard[colour ^ 1][PAWN] &= clearMask[bd->epSquare];

            if (attacks(nb->pos, nb->pos->kingsq[colour], (colour ^ 1)) ==
                    false) {
                recordMove(nb, colour, PAWN, from, bd->epSquare, NOPIECE, bd);
                nb->ep = true;
                LL_APPEND(bl->vektor, nb);
            } else {
                freeBoard(nb);
            }
        }
    }

    if (iFile != 7) {
        from = bd->epSquare + 1;

        if ((bd->pos->bitBoard[colour][PAWN] & setMask[from]) != 0) {
            if (colour == WHITE) {
                to = bd->epSquare + 8;
            } else {
                to = bd->epSquare - 8;
            }

            nb = getBoard(bd->pos, (unsigned char) colour, bl->moveNumber);
            nb->pos->bitBoard[colour][PAWN] &= clearMask[from];
            nb->pos->bitBoard[colour][OCCUPIED] &= clearMask[from];
            nb->pos->bitBoard[colour][PAWN] |= setMask[to];
            nb->pos->bitBoard[colour][OCCUPIED] |= setMask[to];
            nb->pos->bitBoard[colour ^ 1][OCCUPIED] &= clearMask[bd->epSquare];
            nb->pos->bitBoard[colour ^ 1][PAWN] &= clearMask[bd->epSquare];

            if (attacks(nb->pos, nb->pos->kingsq[colour], (colour ^ 1)) ==
                    false) {
                recordMove(nb, colour, PAWN, from, bd->epSquare, NOPIECE, bd);
                nb->ep = true;
                LL_APPEND(bl->vektor, nb);
            } else {
                freeBoard(nb);
            }
        }
    }

    return;
}

void makePromotion(BOARD* bd, enum COLOUR colour, int prom, int from, int to)
{
    bd->pos->bitBoard[colour][PAWN] &= clearMask[from];
    bd->pos->bitBoard[colour][OCCUPIED] &= clearMask[from];
    bd->pos->bitBoard[colour][prom] |= setMask[to];
    bd->pos->bitBoard[colour][OCCUPIED] |= setMask[to];
    bd->pos->bitBoard[colour ^ 1][OCCUPIED] &= clearMask[to];
    bd->pos->bitBoard[colour ^ 1][PAWN] &= clearMask[to];
    bd->pos->bitBoard[colour ^ 1][KNIGHT] &= clearMask[to];
    bd->pos->bitBoard[colour ^ 1][BISHOP] &= clearMask[to];
    bd->pos->bitBoard[colour ^ 1][ROOK] &= clearMask[to];
    bd->pos->bitBoard[colour ^ 1][QUEEN] &= clearMask[to];
    return;
}

void generatePawnMoves(BOARD* bd, enum COLOUR colour, BOARDLIST* bl)
{
    int i, j, iRank, prom;
    BOARD* nb;
    BITBOARD occupied;
    BITBOARD temp;
    BITBOARD jtemp;
    POSITION npos;
    assert(bl != NULL);
    temp = bd->pos->bitBoard[colour][PAWN];
    i = tzcount(temp);

    while (i < 64) {
        /*
           P found at i.
         */
        iRank = RANK(i);
        jtemp = pawn_attacks[colour][i];
        j = tzcount(jtemp);
        /*
           Find attacked squares (for captures) first.
         */

        while (j < 64) {
            /*
               Attack square found at j.
             */
            if ((bd->pos->bitBoard[colour ^ 1][OCCUPIED] & setMask[j]) != 0) {
                /*
                   Not empty or occupied by a friendly unit.
                 */
                if (((colour == WHITE) && (iRank == 6))
                        || ((colour == BLACK) && (iRank == 1))) {
                    /*
                       Ready to promote.
                     */
                    int jbds;

                    for (jbds = 0; jbds < 4; jbds++) {
                        prom = proms[jbds];
                        nb = getBoard(bd->pos, (unsigned char) colour,
                                      bl->moveNumber);
                        makePromotion(nb, colour, prom, i, j);

                        if (attacks
                                (nb->pos, nb->pos->kingsq[colour],
                                 (colour ^ 1)) == false) {
                            /*
                               Not self-check so record move and add to list
                             */
                            recordMove(nb, colour, PAWN, i, j, prom, bd);
                            LL_APPEND(bl->vektor, nb);
                        } else {
                            freeBoard(nb);
                        }
                    }
                } else {
                    /*
                       Ordinary pawn capture.
                     */
                    npos = * (bd->pos);
                    //nb = this.dup(colour, bl.moveNumber);
                    nMakeMove(&npos, colour, PAWN, i, j);

                    if (attacks(&npos, npos.kingsq[colour], (colour ^ 1)) ==
                            false) {
                        /*
                           Not self-check so record move and add to list.
                         */
                        nb = getBoard(&npos, (unsigned char) colour,
                                      bl->moveNumber);
                        recordMove(nb, colour, PAWN, i, j, NOPIECE, bd);
                        LL_APPEND(bl->vektor, nb);
                    }
                }
            }

            jtemp &= clearMask[j];
            j = tzcount(jtemp);
        }

        /*
           Now do pawn moves, not captures.
         */
        occupied =
            (bd->pos->bitBoard[colour][OCCUPIED] | bd->
             pos->bitBoard[colour ^ 1][OCCUPIED]);
        jtemp = pawn_moves[colour][i];
        j = tzcount(jtemp);

        while (j < 64) {
            if ((occupied & setMask[j]) == 0) {
                /*
                   Unoccupied square.
                 */
                if ((colour == BLACK) && (abs(i - j) == 16)) {
                    /*
                       Black double step.
                     */
                    if ((occupied & setMask[j + 8]) == 0) {
                        /*
                           Single-step square empty, so move ok.
                         */
                        npos = * (bd->pos);
                        nMakeMove(&npos, colour, PAWN, i, j);

                        if (attacks(&npos, npos.kingsq[colour], (colour ^ 1)) ==
                                false) {
                            nb = getBoard(&npos, (unsigned char) colour,
                                          bl->moveNumber);
                            recordMove(nb, colour, PAWN, i, j, NOPIECE, bd);
                            nb->epSquare = (unsigned char) j;
                            LL_APPEND(bl->vektor, nb);
                        }
                    }
                } else if ((colour == WHITE) && (abs(i - j) == 16)) {
                    /*
                       White double step.
                     */
                    if ((occupied & setMask[j - 8]) == 0) {
                        /*
                           Single-step square empty, so move ok.
                         */
                        npos = * (bd->pos);
                        nMakeMove(&npos, colour, PAWN, i, j);

                        if (attacks(&npos, npos.kingsq[colour], (colour ^ 1)) ==
                                false) {
                            nb = getBoard(&npos, (unsigned char) colour,
                                          bl->moveNumber);
                            recordMove(nb, colour, PAWN, i, j, NOPIECE, bd);
                            nb->epSquare = (unsigned char) j;
                            LL_APPEND(bl->vektor, nb);
                        }
                    }
                } else if (((colour == WHITE) && (iRank == 6))
                           || ((colour == BLACK)
                               && (iRank == 1))) {
                    /*
                       Promotion
                     */
                    int jbds;

                    for (jbds = 0; jbds < 4; jbds++) {
                        prom = proms[jbds];
                        nb = getBoard(bd->pos, (unsigned char) colour,
                                      bl->moveNumber);
                        makePromotion(nb, colour, prom, i, j);

                        if (attacks
                                (nb->pos, nb->pos->kingsq[colour],
                                 (colour ^ 1)) == false) {
                            recordMove(nb, colour, PAWN, i, j, prom, bd);
                            LL_APPEND(bl->vektor, nb);
                        } else {
                            freeBoard(nb);
                        }
                    }
                } else {
                    /*
                       Single-stip ordinary pawn move.
                     */
                    npos = * (bd->pos);
                    //nb = this.dup(colour, bl.moveNumber);
                    nMakeMove(&npos, colour, PAWN, i, j);

                    if (attacks(&npos, npos.kingsq[colour], (colour ^ 1)) ==
                            false) {
                        nb = getBoard(&npos, (unsigned char) colour,
                                      bl->moveNumber);
                        recordMove(nb, colour, PAWN, i, j, NOPIECE, bd);
                        LL_APPEND(bl->vektor, nb);
                    }
                }
            }

            jtemp &= clearMask[j];
            j = tzcount(jtemp);
        }

        temp &= clearMask[i];
        i = tzcount(temp);
    }

    return;
}

BOARDLIST* generateWhiteBoardlist(BOARD* inBrd, int ply)
{
    BOARDLIST* wbl;
    BOARD* elt;
    int count;
    wbl = getBoardlist(WHITE, (unsigned char) ply);
    generateKingMoves(inBrd, WHITE, wbl);

    if (inBrd->pos->bitBoard[WHITE][KNIGHT] != 0) {
        generateKnightMoves(inBrd, WHITE, wbl);
    }

    if (inBrd->pos->bitBoard[WHITE][BISHOP] != 0) {
        generateBishopLikeMoves(inBrd, WHITE, wbl, BISHOP);
    }

    if (inBrd->pos->bitBoard[WHITE][ROOK] != 0) {
        generateRookLikeMoves(inBrd, WHITE, wbl, ROOK);
    }

    if (inBrd->pos->bitBoard[WHITE][QUEEN] != 0) {
        generateBishopLikeMoves(inBrd, WHITE, wbl, QUEEN);
        generateRookLikeMoves(inBrd, WHITE, wbl, QUEEN);
    }

    if (inBrd->pos->bitBoard[WHITE][PAWN] != 0) {
        generatePawnMoves(inBrd, WHITE, wbl);
    }

    if ((inBrd->check == false)
            && (inBrd->pos->flags & (W_KING_CASTLING | W_QUEEN_CASTLING)) != 0) {
        generateWhiteCastlings(inBrd, wbl);
    }

    if (inBrd->epSquare != 0) {
        generateEP(inBrd, WHITE, wbl);
    }

    LL_COUNT(wbl->vektor, elt, count);
    wbl->legalMoves = (unsigned char) count;
    return wbl;
}

BOARDLIST* generateRefutations(BOARD* brd, int move)
{
    assert(brd != NULL);
    BOARDLIST* bbl;
    BOARD* elt;
    int count;
    bbl = getBoardlist(BLACK, (unsigned char) move);
    generateKingMoves(brd, BLACK, bbl);
    LL_COUNT(bbl->vektor, elt, count);

    if (count > 0) {
        return bbl;
    }

    if (brd->pos->bitBoard[BLACK][KNIGHT] != 0) {
        generateKnightMoves(brd, BLACK, bbl);
        LL_COUNT(bbl->vektor, elt, count);

        if (count > 0) {
            return bbl;
        }
    }

    if (brd->pos->bitBoard[BLACK][BISHOP] != 0) {
        generateBishopLikeMoves(brd, BLACK, bbl, BISHOP);
        LL_COUNT(bbl->vektor, elt, count);

        if (count > 0) {
            return bbl;
        }
    }

    if (brd->pos->bitBoard[BLACK][ROOK] != 0) {
        generateRookLikeMoves(brd, BLACK, bbl, ROOK);
        LL_COUNT(bbl->vektor, elt, count);

        if (count > 0) {
            return bbl;
        }
    }

    if (brd->pos->bitBoard[BLACK][QUEEN] != 0) {
        generateBishopLikeMoves(brd, BLACK, bbl, QUEEN);
        LL_COUNT(bbl->vektor, elt, count);

        if (count > 0) {
            return bbl;
        }

        generateRookLikeMoves(brd, BLACK, bbl, QUEEN);
        LL_COUNT(bbl->vektor, elt, count);

        if (count > 0) {
            return bbl;
        }
    }

    if (brd->pos->bitBoard[BLACK][PAWN] != 0) {
        generatePawnMoves(brd, BLACK, bbl);
        LL_COUNT(bbl->vektor, elt, count);

        if (count > 0) {
            return bbl;
        }
    }

    if ((brd->check == false)
            && (brd->pos->flags & (B_KING_CASTLING | B_QUEEN_CASTLING)) != 0) {
        generateBlackCastlings(brd, bbl);
        LL_COUNT(bbl->vektor, elt, count);

        if (count > 0) {
            return bbl;
        }
    }

    if (brd->epSquare != 0) {
        generateEP(brd, BLACK, bbl);
    }

    return bbl;
}

#ifdef SHOWBOARD
void display_board(BOARD* brd)
{
    (void) fprintf(stderr, "bitboard\n");
    (void) fprintf(stderr, "\t      WHITE PAWN => %s\n",
                   getSquares(brd->pos->bitBoard[WHITE][PAWN]));
    (void) fprintf(stderr, "\t    WHITE KNIGHT => %s\n",
                   getSquares(brd->pos->bitBoard[WHITE][KNIGHT]));
    (void) fprintf(stderr, "\t    WHITE BISHOP => %s\n",
                   getSquares(brd->pos->bitBoard[WHITE][BISHOP]));
    (void) fprintf(stderr, "\t      WHITE ROOK => %s\n",
                   getSquares(brd->pos->bitBoard[WHITE][ROOK]));
    (void) fprintf(stderr, "\t     WHITE QUEEN => %s\n",
                   getSquares(brd->pos->bitBoard[WHITE][QUEEN]));
    (void) fprintf(stderr, "\t      WHITE KING => %s\n",
                   getSquares(brd->pos->bitBoard[WHITE][KING]));
    (void) fprintf(stderr, "\t  WHITE OCCUPIED => %s\n",
                   getSquares(brd->pos->bitBoard[WHITE][OCCUPIED]));
    (void) fprintf(stderr, "\t      BLACK PAWN => %s\n",
                   getSquares(brd->pos->bitBoard[BLACK][PAWN]));
    (void) fprintf(stderr, "\t    BLACK KNIGHT => %s\n",
                   getSquares(brd->pos->bitBoard[BLACK][KNIGHT]));
    (void) fprintf(stderr, "\t    BLACK BISHOP => %s\n",
                   getSquares(brd->pos->bitBoard[BLACK][BISHOP]));
    (void) fprintf(stderr, "\t      BLACK ROOK => %s\n",
                   getSquares(brd->pos->bitBoard[BLACK][ROOK]));
    (void) fprintf(stderr, "\t     BLACK QUEEN => %s\n",
                   getSquares(brd->pos->bitBoard[BLACK][QUEEN]));
    (void) fprintf(stderr, "\t      BLACK KING => %s\n",
                   getSquares(brd->pos->bitBoard[BLACK][KING]));
    (void) fprintf(stderr, "\t  BLACK OCCUPIED => %s\n",
                   getSquares(brd->pos->bitBoard[BLACK][OCCUPIED]));
    (void) fprintf(stderr, "nextply           = %p\n", brd->nextply);
    (void) fprintf(stderr, "threat         = %p\n", brd->threat);
    (void) fprintf(stderr, "ply            = %d\n", (int) brd->ply);
    (void) fprintf(stderr, "side           = %d\n", (int) brd->side);
    (void) fprintf(stderr, "mover          = %d\n", (int) brd->mover);
    (void) fprintf(stderr, "from           = %d\n", (int) brd->from);
    (void) fprintf(stderr, "to             = %d\n", (int) brd->to);
    (void) fprintf(stderr, "qualifier      = %s\n", brd->qualifier);
    (void) fprintf(stderr, "captured       = %d\n", (int) brd->captured);
    (void) fprintf(stderr, "promotion      = %d\n", (int) brd->promotion);
    (void) fprintf(stderr, "check          = %d\n", (int) brd->check);
    (void) fprintf(stderr, "tag            = %c\n", brd->tag);
    (void) fprintf(stderr, "ep             = %d\n", (int) brd->ep);
    (void) fprintf(stderr, "kingsq[0]      = %d\n",
                   (int) brd->pos->kingsq[0]);
    (void) fprintf(stderr, "kingsq[1]      = %d\n",
                   (int) brd->pos->kingsq[1]);
    (void) fprintf(stderr, "epSquare       = %d\n", (int) brd->epSquare);
    (void) fprintf(stderr, "flags          = %d\n", (int) brd->pos->flags);
    return;
}
#endif

void qualifyMove(BOARDLIST* baseList, BOARD* brd)
{
    BOARD* ba[10];
    BOARD* ob;
    int c, j, xFile, yFile;
    assert(baseList != NULL);
    assert(brd != NULL);

    if ((brd->mover >= KNIGHT) && (brd->mover <= QUEEN)) {
        c = 0;
        LL_FOREACH(baseList->vektor, ob) {
            //ob = kv_A( baseList->vektor, i );
            if ((ob->from != brd->from) && (ob->mover == brd->mover)
                    && (ob->to == brd->to)) {
                assert(c <= 9);
                ba[c] = ob;
                c++;
            }
        }

        if (c == 1) {
            xFile = FILE((int) ba[0]->from);
            yFile = FILE((int) brd->from);
            j = brd->from * 2;

            if (xFile != yFile) {
                brd->qualifier[0] = squares[j];
            } else {
                brd->qualifier[0] = squares[j + 1];
            }

            brd->qualifier[1] = '\0';
        } else if (c > 1) {
            j = brd->from * 2;
            brd->qualifier[0] = squares[j];
            brd->qualifier[1] = squares[j + 1];
            brd->qualifier[2] = '\0';
        }
    }

    return;
}

char* toStr(BOARD* bd)
{
    int f;
    char tp[5];
    char* ret;
    ret = (char*) malloc(16);
    SENGINE_MEM_ASSERT(ret);
    ret[0] = numbers[bd->ply];
    ret[1] = '\0';

    if (bd->side == WHITE) {
        (void) strcat(ret, ".");
    } else {
        (void) strcat(ret, "...");
    }

    if (bd->mover == PAWN) {
        if (bd->captured == true) {
            f = FILE(bd->from);
            tp[0] = fileArray[f];
            tp[1] = 'x';
            f = bd->to * 2;
            tp[2] = squares[f];
            tp[3] = squares[f + 1];
            tp[4] = '\0';
            (void) strcat(ret, tp);

            if (bd->ep == true) {
                (void) strcat(ret, " ep");
            }
        } else {
            f = bd->to * 2;
            tp[0] = squares[f];
            tp[1] = squares[f + 1];
            tp[2] = '\0';
            (void) strcat(ret, tp);
        }

        if (bd->promotion != NOPIECE) {
            tp[0] = pcArray[bd->promotion];
            tp[1] = '\0';
            (void) strcat(ret, tp);
        }
    } else {
        if ((bd->mover == KING) && (bd->side == WHITE) && (bd->from == 4)
                && (bd->to == 6)) {
            (void) strcat(ret, "0-0");
        } else if ((bd->mover == KING) && (bd->side == WHITE)
                   && (bd->from == 4) && (bd->to == 2)) {
            (void) strcat(ret, "0-0-0");
        } else if ((bd->mover == KING) && (bd->side == BLACK)
                   && (bd->from == 60) && (bd->to == 62)) {
            (void) strcat(ret, "0-0");
        } else if ((bd->mover == KING) && (bd->side == BLACK)
                   && (bd->from == 60) && (bd->to == 58)) {
            (void) strcat(ret, "0-0-0");
        } else {
            tp[0] = pcArray[bd->mover];
            tp[1] = '\0';
            (void) strcat(ret, tp);

            if (bd->qualifier != '\0') {
                (void) strcat(ret, bd->qualifier);
            }

            if (bd->captured == true) {
                (void) strcat(ret, "x");
            }

            f = bd->to * 2;
            tp[0] = squares[f];
            tp[1] = squares[f + 1];
            tp[2] = '\0';
            (void) strcat(ret, tp);
        }
    }

    if ((bd->check == true) && (bd->tag != '#')) {
        (void) strcat(ret, "+");
    }

    if (bd->tag != '*') {
        tp[0] = bd->tag;
        tp[1] = '\0';
        (void) strcat(ret, tp);
    }

    return ret;
}

BOARDLIST* generateBlackBoardlist(BOARD* bd, int ply, unsigned int* flights)
{
    BOARDLIST* bbl;
    BOARD* elt;
    int count;
    bbl = getBoardlist(BLACK, (unsigned char) ply);
    generateKingMoves(bd, BLACK, bbl);
    LL_COUNT(bbl->vektor, elt, count);
    *flights = count;

    if (bd->pos->bitBoard[BLACK][QUEEN] != 0) {
        generateBishopLikeMoves(bd, BLACK, bbl, QUEEN);
        generateRookLikeMoves(bd, BLACK, bbl, QUEEN);
    }

    if (bd->pos->bitBoard[BLACK][ROOK] != 0) {
        generateRookLikeMoves(bd, BLACK, bbl, ROOK);
    }

    if (bd->pos->bitBoard[BLACK][BISHOP] != 0) {
        generateBishopLikeMoves(bd, BLACK, bbl, BISHOP);
    }

    if (bd->pos->bitBoard[BLACK][KNIGHT] != 0) {
        generateKnightMoves(bd, BLACK, bbl);
    }

    if (bd->pos->bitBoard[BLACK][PAWN] != 0) {
        generatePawnMoves(bd, BLACK, bbl);
    }

    if ((bd->check == false)
            && (bd->pos->flags & (B_KING_CASTLING | B_QUEEN_CASTLING)) != 0) {
        generateBlackCastlings(bd, bbl);
    }

    if (bd->epSquare != 0) {
        generateEP(bd, BLACK, bbl);
    }

    LL_COUNT(bbl->vektor, elt, count);
    bbl->legalMoves = (unsigned char) count;
    return bbl;
}
