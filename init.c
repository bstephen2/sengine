
/*
 *	init.c
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
 *	This is the module that hold and initialises all the global static
 *	data.
 */

#include "sengine.h"

static const int knightsq[] = { -17, -15, -10, -6, 6, 10, 15, 17 };
static const int bishopsq[] = { -9, -7, 7, 9 };
static const int rooksq[] = { -8, -1, 1, 8 };

BITBOARD setMask[64];
BITBOARD clearMask[64];
BITBOARD king_attacks[64];
BITBOARD knight_attacks[64];
BITBOARD bishop_attacks[64];
BITBOARD rook_attacks[64];
BITBOARD pawn_attacks[2][64];
BITBOARD pawn_moves[2][64];
BBOARD rook_commonAttacks[64][64];
BBOARD bishop_commonAttacks[64][64];
uint64_t hash_added;
uint64_t hash_hit;
uint64_t board_del;
uint64_t boardlist_del;
uint64_t position_del;

//kvec_t( POSITION * ) pos_pool;

static void init_masks ( void );
static void init_kingattacks ( void );
static void init_knightattacks ( void );
static void init_bishopattacks ( void );
static void init_bishopcommonattacks ( void );
static void init_rookattacks ( void );
static void init_rookcommonattacks ( void );
static void init_pawnmoves ( void );

static int meson_max ( int a, int b )
{
	return ( ( a > b ) ? a : b );
}

static int meson_min ( int a, int b )
{
	return ( ( a < b ) ? a : b );
}

static int fileDistance ( int a, int b )
{
	return abs ( FILE ( a ) - FILE ( b ) );
}

static int rankDistance ( int a, int b )
{
	return abs ( RANK ( a ) - RANK ( b ) );
}

static int distance ( int a, int b )
{
	return meson_max ( fileDistance ( a, b ), rankDistance ( a, b ) );
}

static bool isEdge ( int a )
{
	int i = RANK ( a );

	if ( ( i == 0 ) || ( i == 7 ) ) {
		return true;
	}

	i = FILE ( a );

	if ( ( i == 0 ) || ( i == 7 ) ) {
		return true;
	}

	return false;
}

static bool isRookEdge ( int dir, int pos )
{
	int xPos = FILE ( pos );

	if ( ( dir == -1 ) && ( xPos == 0 ) ) {
		return true;
	}

	if ( ( dir == 1 ) && ( xPos == 7 ) ) {
		return true;
	}

	xPos = RANK ( pos );

	if ( ( dir == -8 ) && ( xPos == 0 ) ) {
		return true;
	}

	if ( ( dir == 8 ) && ( xPos == 7 ) ) {
		return true;
	}

	return false;
}

void init ( void )
{

	init_masks(  );
	init_kingattacks(  );
	init_knightattacks(  );
	init_bishopattacks(  );
	init_bishopcommonattacks(  );
	init_rookattacks(  );
	init_rookcommonattacks(  );
	init_pawnmoves(  );

	return;
}

static void init_masks ( void )
{
	int i;

	for ( i = 0; i < 64; i++ ) {
		setMask[i] = ( BITBOARD ) 1 << i;
		clearMask[i] = ~setMask[i];
	}

	return;
}

static void init_kingattacks ( void )
{
	int i, j;

	( void ) memset ( king_attacks, '\0', sizeof ( BITBOARD ) * 64 );

	for ( i = 0; i < 64; i++ ) {
		for ( j = 0; j < 64; j++ ) {
			if ( distance ( i, j ) == 1 ) {
				king_attacks[i] = king_attacks[i] | setMask[j];
			}
		}
	}

	return;
}

static void init_knightattacks ( void )
{
	int i, j;

	( void ) memset ( knight_attacks, '\0', sizeof ( BITBOARD ) * 64 );

	for ( i = 0; i < 64; i++ ) {
		int frank = RANK ( i );
		int ffile = FILE ( i );

		for ( j = 0; j < 8; j++ ) {
			int sq = i + knightsq[j];

			if ( ( sq < 0 ) || ( sq > 63 ) ) {
				continue;
			}

			int trank = RANK ( sq );
			int tfile = FILE ( sq );

			if ( ( abs ( frank - trank ) > 2 ) || ( abs ( ffile - tfile ) > 2 ) ) {
				continue;
			}

			knight_attacks[i] = knight_attacks[i] | setMask[sq];
		}
	}

	return;
}

static void init_bishopattacks ( void )
{
	int i, j;

	( void ) memset ( bishop_attacks, '\0', sizeof ( BITBOARD ) * 64 );

	for ( i = 0; i < 64; i++ ) {
		int iFile = FILE ( i );
		int iRank = RANK ( i );

		for ( j = 0; j < 4; j++ ) {
			int inc = bishopsq[j];

			if ( ( iFile == 0 ) && ( ( inc == 7 ) || ( inc == -9 ) ) ) {
				continue;
			}

			if ( ( iFile == 7 ) && ( ( inc == 9 ) || ( inc == -7 ) ) ) {
				continue;
			}

			if ( ( iRank == 0 ) && ( inc < 0 ) ) {
				continue;
			}

			if ( ( iRank == 7 ) && ( inc > 0 ) ) {
				continue;
			}

			int pos = i + inc;

			assert ( ( pos >= 0 ) && ( pos <= 63 ) );
			bishop_attacks[i] |= setMask[pos];

			while ( isEdge ( pos ) == false ) {
				pos = pos + inc;
				assert ( ( pos >= 0 ) && ( pos <= 63 ) );
				bishop_attacks[i] |= setMask[pos];
			}
		}
	}

	return;
}

static void init_bishopcommonattacks ( void )
{
	int i, j;

	( void ) memset ( bishop_commonAttacks, '\0', sizeof ( BBOARD ) * 64 * 64 );

	for ( i = 0; i < 64; i++ ) {
		for ( j = 0; j < 64; j++ ) {
			if ( i != j ) {
				if ( ( bishop_attacks[i] & setMask[j] ) != 0 ) {
					int a = meson_min ( i, j );
					int b = meson_max ( i, j );
					BITBOARD temp = 0;

					if ( ( FILE ( a ) > FILE ( b ) ) ) {
						/*
						   diagonal to the left
						 */
						a += 7;

						while ( a != b ) {
							temp |= setMask[a];
							a += 7;
						}
					} else {
						/*
						   diagonal to the right
						 */
						a += 9;

						while ( a != b ) {
							temp |= setMask[a];
							a += 9;
						}
					}

					bishop_commonAttacks[i][j].used = true;
					bishop_commonAttacks[i][j].bb = temp;
				}
			}
		}
	}

	return;
}

static void init_rookattacks ( void )
{
	int i, j;

	( void ) memset ( rook_attacks, '\0', sizeof ( BITBOARD ) * 64 );

	for ( i = 0; i < 64; i++ ) {
		int iFile = FILE ( i );
		int iRank = RANK ( i );

		for ( j = 0; j < 4; j++ ) {
			int inc = rooksq[j];

			if ( ( iFile == 0 ) && ( inc == -1 ) ) {
				continue;
			}

			if ( ( iFile == 7 ) && ( inc == 1 ) ) {
				continue;
			}

			if ( ( iRank == 0 ) && ( inc == -8 ) ) {
				continue;
			}

			if ( ( iRank == 7 ) && ( inc == 8 ) ) {
				continue;
			}

			int pos = i + inc;

			rook_attacks[i] |= setMask[pos];

			while ( isRookEdge ( inc, pos ) == false ) {
				pos = pos + inc;
				rook_attacks[i] |= setMask[pos];
			}
		}
	}

	return;
}

static void init_rookcommonattacks ( void )
{
	int i, j;

	( void ) memset ( rook_commonAttacks, '\0', sizeof ( BBOARD ) * 64 * 64 );

	for ( i = 0; i < 64; i++ ) {
		for ( j = 0; j < 64; j++ ) {

			if ( i != j ) {

				if ( RANK ( i ) == RANK ( j ) ) {
					/*
					   Horizontal line
					 */
					BITBOARD temp = rook_attacks[i] & rook_attacks[j];
					int a = meson_min ( i, j );
					int b = meson_max ( i, j );

					while ( FILE ( a ) != 0 ) {
						a--;
						temp &= clearMask[a];
					}

					while ( FILE ( b ) != 7 ) {
						b++;
						temp &= clearMask[b];
					}

					rook_commonAttacks[i][j].used = true;
					rook_commonAttacks[i][j].bb = temp;
				} else if ( FILE ( i ) == FILE ( j ) ) {
					/*
					   Vertical line
					 */
					BITBOARD temp = rook_attacks[i] & rook_attacks[j];
					int a = meson_min ( i, j );
					int b = meson_max ( i, j );

					while ( RANK ( a ) != 0 ) {
						a = a - 8;
						temp &= clearMask[a];
					}

					while ( RANK ( b ) != 7 ) {
						b = b + 8;
						temp &= clearMask[b];
					}

					rook_commonAttacks[i][j].used = true;
					rook_commonAttacks[i][j].bb = temp;
				}
			}
		}
	}

	return;
}

static void init_pawnmoves ( void )
{
	int leftCap;
	int rightCap;
	int firstStep;
	int secondStep;
	int iFile;
	int i;
	enum COLOUR c;

	( void ) memset ( pawn_moves, '\0', sizeof ( BITBOARD ) * 2 * 64 );
	( void ) memset ( pawn_attacks, '\0', sizeof ( BITBOARD ) * 2 * 64 );

	for ( c = WHITE; c <= BLACK; c++ ) {

		if ( c == WHITE ) {
			leftCap = 7;
			rightCap = 9;
			firstStep = 8;
			secondStep = 16;
		} else {
			leftCap = -9;
			rightCap = -7;
			firstStep = -8;
			secondStep = -16;
		}

		for ( i = 0; i < 8; i++ ) {
			iFile = FILE ( i );

			if ( c == WHITE ) {

				if ( iFile != 0 ) {
					pawn_attacks[c][i] |= setMask[i + leftCap];
				}

				if ( iFile != 7 ) {
					pawn_attacks[c][i] |= setMask[i + rightCap];
				}
			}
		}

		for ( i = 56; i < 64; i++ ) {
			iFile = FILE ( i );

			if ( c == BLACK ) {

				if ( iFile != 0 ) {
					pawn_attacks[c][i] |= setMask[i + leftCap];
				}

				if ( iFile != 7 ) {
					pawn_attacks[c][i] |= setMask[i + rightCap];
				}
			}
		}

		for ( i = 8; i < 56; i++ ) {
			iFile = FILE ( i );
			int iRank = RANK ( i );

			if ( iFile != 0 ) {
				pawn_attacks[c][i] |= setMask[i + leftCap];
			}

			if ( iFile != 7 ) {
				pawn_attacks[c][i] |= setMask[i + rightCap];
			}

			pawn_moves[c][i] |= setMask[i + firstStep];

			if ( ( c == WHITE ) && ( iRank == 1 ) ) {
				pawn_moves[c][i] |= setMask[i + secondStep];
			}

			if ( ( c == BLACK ) && ( iRank == 6 ) ) {
				pawn_moves[c][i] |= setMask[i + secondStep];
			}
		}
	}

	return;
}
