
/*
 *	options.h
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
 *
 *	This is the header file that defines the program options.
 *
 */

#define ARGTYPES 24
#define NUMSTIPS 8

char* opt_kings = NULL;
char* opt_gbr = NULL;
char* opt_pos = NULL;
char* opt_castling = NULL;
char* opt_ep = NULL;
int opt_hash = MAX_HASH_SIZE;
enum AIM opt_aim = MATE;
enum THREATS opt_threats = SHORTEST;
enum STIP opt_stip = DIRECT;
unsigned int opt_moves = 2;
unsigned int opt_sols = 1;
unsigned int opt_refuts = 0;
bool opt_help = false;
bool opt_threads = false;
bool opt_set = false;
bool opt_tries = false;
bool opt_trivialtries = false;
bool opt_actual = false;
bool opt_shortvars = false;
bool opt_fleck = false;
bool opt_virtualthreats = false;
bool opt_intelligent = false;
bool opt_postkeyplay = false;
bool opt_classify = false;
bool opt_meson = false;

typedef struct argument {
    char* name;
    bool mandatory;
    void* target;
    int (*val)(char*, struct argument*);
} ARGUMENT;

typedef struct arg_hash_entry {
    char* name;
    bool mandatory;
    void* target;
    int (*val)(char*, struct argument*);
    UT_hash_handle hh;
} ARG_HASH_ENTRY;

typedef struct stiprec {
    char* name;
    enum AIM aim;
    enum STIP stip;
} STIPREC;

typedef struct stiprec_hash_entry {
    char* name;
    enum AIM aim;
    enum STIP stip;
    UT_hash_handle hh;
} STIPREC_HASH_ENTRY;

static STIPREC stips[] = { {"#", MATE, DIRECT},
    {"=", STALEMATE, DIRECT},
    {"H#", MATE, HELP},
    {"H=", STALEMATE, HELP},
    {"R#", MATE, REFLEX},
    {"R=", STALEMATE, REFLEX},
    {"S#", MATE, SELF},
    {"S=", STALEMATE, SELF},
};
