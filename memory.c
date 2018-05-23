
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

//static kvec_t( BOARD * ) board_stack;
//static kvec_t( POSITION * ) position_stack;
//static kvec_t( BOARDLIST * ) boardlist_stack;

uint64_t positions_got = 0;
uint64_t boards_got = 0;
uint64_t boardlists_got = 0;
uint64_t positions_freed = 0;
uint64_t boards_freed = 0;
uint64_t boardlists_freed = 0;

void init_mem ( void )
{

	//kv_init( board_stack );
	//kv_init( position_stack );
	//kv_init( boardlist_stack );

	return;
}

void close_mem ( void )
{
	//kv_destroy( board_stack );
	//kv_destroy( position_stack );
	//kv_destroy( boardlist_stack );

	return;
}

BOARD *getBoard ( POSITION * ppos, unsigned char played, unsigned char move )
{
	BOARD *rpbrd;

	boards_got++;

	//if ( kv_size( board_stack ) > 0 ) {
	//rpbrd = kv_pop( board_stack );
	//( void ) MEMSET( ( void * ) rpbrd, '\0', sizeof( BOARD ) );
	//} else {
	//rpbrd = calloc( 1, sizeof( BOARD ) );

	//if ( rpbrd == NULL ) {
	//( void ) fprintf( stderr, "SENGINE ERROR (%s, %d): Out of memory\n",
	//__FILE__, __LINE__ );
	//exit( 1 );
	//}
	// }

	rpbrd->pos = getPosition ( ppos );
	rpbrd->tag = '*';
	rpbrd->side = played;
	rpbrd->ply = move;
	rpbrd->qualifier[0] = '\0';
	rpbrd->use_count = 1;

	return rpbrd;
}

BOARD *cloneBoard ( BOARD * inBrd )
{
	BOARD *rpbrd;

	boards_got++;

	//if ( kv_size( board_stack ) > 0 ) {
	//rpbrd = kv_pop( board_stack );
	//} else {
	//rpbrd = malloc( sizeof( BOARD ) );

	//if ( rpbrd == NULL ) {
	//( void ) fprintf( stderr, "SENGINE ERROR (%s, %d): Out of memory\n",
	//__FILE__, __LINE__ );
	//exit( 1 );
	// }
	//}

	//( void ) MEMCPY( ( void * ) rpbrd, ( void * ) inBrd, sizeof( BOARD ) );
	//rpbrd->next = NULL;

	return rpbrd;
}

POSITION *getPosition ( POSITION * ppos )
{
	POSITION *rpos;

	positions_got++;

	//if ( kv_size( position_stack ) > 0 ) {
	//rpos = kv_pop( position_stack );
	//} else {
	// rpos = ( POSITION * ) malloc( sizeof( POSITION ) );

	//if ( rpos == NULL ) {
	//( void ) fprintf( stderr, "SENGINE ERROR (%s, %d): Out of memory\n",
	//__FILE__, __LINE__ );
	//exit( 1 );
	//}
	//}

	( void ) memcpy ( rpos, ppos, sizeof ( POSITION ) );

	return rpos;
}

KILLERHASHVALUE *getKillerHashValue ( void )
{

	KILLERHASHVALUE *khv = calloc ( 1, sizeof ( HASHVALUE ) );

	if ( khv == NULL ) {
		( void ) fprintf ( stderr, "SENGINE ERROR (%s, %d): Out of memory\n",
		                   __FILE__, __LINE__ );
		exit ( 1 );
	}

	return khv;
}

HASHVALUE *getHashValue ( void )
{

	HASHVALUE *hv = calloc ( 1, sizeof ( HASHVALUE ) );

	if ( hv == NULL ) {
		( void ) fprintf ( stderr, "SENGINE ERROR (%s, %d): Out of memory\n",
		                   __FILE__, __LINE__ );
		exit ( 1 );
	}

	return hv;
}

BOARDLIST *getBoardlist ( unsigned char tplay, unsigned char move )
{

	BOARDLIST *pbl;

	boardlists_got++;

	//if ( kv_size( boardlist_stack ) > 0 ) {
	//pbl = kv_pop( boardlist_stack );
	//( void ) MEMSET( ( void * ) pbl, '\0', sizeof( BOARDLIST ) );
	//} else {
	// pbl = calloc( 1, sizeof( BOARDLIST ) );

	//if ( pbl == NULL ) {
	//( void ) fprintf( stderr, "SENGINE ERROR (%s, %d): Out of memory\n",
	//__FILE__, __LINE__ );
	//exit( 1 );
	//}
	//}

	pbl->toPlay = tplay;
	pbl->moveNumber = move;
	pbl->use_count = 1;
	pbl->vektor = ( BOARD * ) NULL;

	return pbl;
}

void freeBoard ( BOARD * pbrd )
{

	assert ( pbrd != NULL );

	pbrd->use_count--;

	if ( pbrd->use_count == 0 ) {

		boards_freed++;

		if ( pbrd->pos != NULL ) {
			freePosition ( pbrd->pos );
		}

		if ( pbrd->nextply != NULL ) {
			freeBoardlist ( pbrd->nextply );
		}

		if ( pbrd->threat != NULL ) {
			freeBoardlist ( pbrd->threat );
		}

		//if ( kv_size( board_stack ) < MAX_BOARD_POOL ) {
		//kv_push( struct BOARD *, board_stack, pbrd );
		//} else {
		//free( pbrd );
		//}
	}

	return;
}

void freePosition ( POSITION * ppos )
{

	assert ( ppos != NULL );

	positions_freed++;

	//if ( kv_size( position_stack ) < MAX_POS_POOL ) {
	//kv_push( POSITION *, position_stack, ppos );
	//} else {
	//free( ppos );
	//}


	return;
}

void freeBoardlist ( BOARDLIST * pbl )
{

	assert ( pbl != NULL );

	pbl->use_count--;

	if ( pbl->use_count == 0 ) {
		boardlists_freed++;

		BOARD *b;
		BOARD *tmp;

		LL_FOREACH_SAFE ( pbl->vektor, b, tmp ) {
			LL_DELETE ( pbl->vektor, b );
			freeBoard ( b );
		}

		//if ( kv_size( boardlist_stack ) < MAX_BOARDLIST_POOL ) {
		//kv_push( BOARDLIST *, boardlist_stack, pbl );
		//} else {
		//free( pbl );
		//}
	}

	return;
}
