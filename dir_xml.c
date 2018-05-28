
/*
 *	dir_xml.c
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
 *	This is the module for preparing the xml output for directmates.
 */

#include "sengine.h"
#include "genx.h"

extern bool opt_meson;
extern char* opt_kings;
extern char* opt_gbr;
extern char* opt_pos;
extern enum SOUNDNESS sound;
extern enum STIP opt_stip;
extern enum AIM opt_aim;
extern int opt_moves;
extern int opt_sols;
extern char* opt_castling;
extern char* opt_ep;
extern bool opt_set;
extern bool opt_tries;
extern int opt_refuts;
extern bool opt_trivialtries;
extern bool opt_actual;
extern enum THREATS opt_threats;
extern bool opt_fleck;
extern bool opt_shortvars;

static genxWriter w;
static const unsigned char ms[] = "MesonSolution";
static const unsigned char solvetime[] = "SolvingTime";
static const unsigned char program[] = "Program";
static const unsigned char author[] = "Author";
static const unsigned char soundel[] = "Soundness";
static const unsigned char diag[] = "Diagram";
static const unsigned char keysel[] = "Keys";
static const unsigned char setsel[] = "Sets";
static const unsigned char trysel[] = "Tries";
static const unsigned char optsel[] = "options";
static const unsigned char statsel[] = "stats";
static const unsigned char wmel[] = "wm";
static const unsigned char bmel[] = "bm";
static const unsigned char threl[] = "thr";
static const unsigned char stipel[] = "stip";
static const unsigned char movesel[] = "moves";
static const unsigned char solsel[] = "sols";
static const unsigned char castel[] = "castling";
static const unsigned char epel[] = "ep";
static const unsigned char setel[] = "set";
static const unsigned char triesel[] = "tries";
static const unsigned char refutsel[] = "refuts";
static const unsigned char trivialtriesel[] = "trivialtries";
static const unsigned char actualel[] = "actual";
static const unsigned char threatsel[] = "threats";
static const unsigned char fleckel[] = "fleck";
static const unsigned char shortvarsel[] = "shortvars";
static const unsigned char addedel[] = "hash_added";
static const unsigned char hitnullel[] = "hash_hit_null";
static const unsigned char hitlistel[] = "hash_hit_list";
static const unsigned char compel[] = "compiler";
static const unsigned char platform[] = "platform";

void getWmoveXML(BOARDLIST*);
void getBmoveXML(BOARDLIST*);

void start_dir(void)
{
    char progText[200];
    w = genxNew(NULL, NULL, NULL);
    (void) genxStartDocFile(w, stdout);
    (void) genxStartElementLiteral(w, NULL, ms);
    (void) genxStartElementLiteral(w, NULL, program);
    (void) sprintf(progText, "%s (v. %s, %s)", PROGRAM_NAME, PROGRAM_VERSION,
                   PROGRAM_YEAR);
    (void) genxAddText(w, (unsigned char*) progText);
    (void) genxEndElement(w);

    if (opt_meson == false) {
        (void) genxStartElementLiteral(w, NULL, author);
        (void) genxAddText(w, (unsigned char*) PROGRAM_AUTHOR);
        (void) genxEndElement(w);
        (void) genxStartElementLiteral(w, NULL, compel);
        (void) sprintf(progText, "%s (v %s)", COMP, CV);
        (void) genxAddText(w, (unsigned char*) progText);
        (void) genxEndElement(w);
        (void) genxStartElementLiteral(w, NULL, platform);
        (void) genxAddText(w, (unsigned char*) PLATFORM);
        (void) genxEndElement(w);
    }

    (void) genxStartElementLiteral(w, NULL, diag);
    (void) sprintf(progText, "%s:%s:%s", opt_kings, opt_gbr, opt_pos);
    (void) genxAddText(w, (unsigned char*) progText);
    (void) genxEndElement(w);
    (void) genxStartElementLiteral(w, NULL, soundel);

    switch (sound) {
    case UNSET:
        (void) genxAddText(w, (unsigned char*) "UNSET");
        break;

    case SHORT_SOLUTION:
        (void) genxAddText(w, (unsigned char*) "SHORT_SOLUTION");
        break;

    case SOUND:
        (void) genxAddText(w, (unsigned char*) "SOUND");
        break;

    case COOKED:
        (void) genxAddText(w, (unsigned char*) "COOKED");
        break;

    case NO_SOLUTION:
        (void) genxAddText(w, (unsigned char*) "NO_SOLUTION");
        break;

    case MISSING_SOLUTION:
        (void) genxAddText(w, (unsigned char*) "MISSING_SOLUTION");
        break;

    default:
        (void) fputs("Invalid soundess  indicator\n", stderr);
        exit(1);
        break;
    }

    (void) genxEndElement(w);
    return;
}
void add_dir_set(BOARDLIST* bml)
{
    (void) genxStartElementLiteral(w, NULL, setsel);
    getBmoveXML(bml);
    (void) genxEndElement(w);
    return;
}

void add_dir_tries(BOARDLIST* wml)
{
    (void) genxStartElementLiteral(w, NULL, trysel);
    getWmoveXML(wml);
    (void) genxEndElement(w);
    return;
}

void getBmoveXML(BOARDLIST* bList)
{
    BOARDLIST* wList;
    BOARD* brd;
    char* ptr;
    assert(bList != NULL);
    LL_FOREACH(bList->vektor, brd) {
        assert(brd != NULL);
        (void) genxStartElementLiteral(w, NULL, bmel);
        ptr = toStr(brd);
        (void) genxAddText(w, (unsigned char*) ptr);
        free(ptr);
        wList = brd->nextply;

        if (wList != NULL) {
            getWmoveXML(wList);
        }

        (void) genxEndElement(w);
    }
    return;
}

void getWmoveXML(BOARDLIST* wbl)
{
    BOARDLIST* thList;
    BOARDLIST* bList;
    BOARD* brd;
    char* ptr;
    assert(wbl != NULL);
    LL_FOREACH(wbl->vektor, brd) {
        assert(brd != NULL);
        (void) genxStartElementLiteral(w, NULL, wmel);
        ptr = toStr(brd);
        (void) genxAddText(w, (unsigned char*) ptr);
        free(ptr);
        thList = brd->threat;

        if (thList != NULL) {
            (void) genxStartElementLiteral(w, NULL, threl);
            getWmoveXML(thList);
            (void) genxEndElement(w);
        }

        bList = brd->nextply;

        if (bList != NULL) {
            getBmoveXML(bList);
        }

        (void) genxEndElement(w);
    }
    return;
}

void add_dir_keys(BOARDLIST* wml)
{
    (void) genxStartElementLiteral(w, NULL, keysel);
    getWmoveXML(wml);
    (void) genxEndElement(w);
    return;
}

void end_dir(void)
{
    //( void ) puts( "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" );
    (void) genxEndElement(w);
    (void) genxEndDocument(w);
    genxDispose(w);
    printf("\n");
    return;
}
void add_dir_options(void)
{
    char stip[5];
    char moves[2];
    char sols[2];
    unsigned char on[] = "true";
    unsigned char off[] = "false";
    (void) genxStartElementLiteral(w, NULL, optsel);
    // stip
    stip[0] = '\0';

    switch (opt_stip) {
    case DIRECT:
        break;

    case HELP:
        stip[1] = 'H';
        break;

    case SELF:
        stip[1] = 'S';
        break;

    case REFLEX:
        stip[1] = 'R';
        break;

    default:
        break;
    }

    (void) strcat(stip, (opt_aim == MATE) ? "#" : "=");
    (void) genxStartElementLiteral(w, NULL, stipel);
    (void) genxAddText(w, (unsigned char*) stip);
    (void) genxEndElement(w);
    // moves
    (void) genxStartElementLiteral(w, NULL, movesel);
    moves[0] = (char) opt_moves + '0';
    moves[1] = '\0';
    (void) genxAddText(w, (unsigned char*) moves);
    (void) genxEndElement(w);
    // sols
    (void) genxStartElementLiteral(w, NULL, solsel);
    sols[0] = (char) opt_sols + '0';
    sols[1] = '\0';
    (void) genxAddText(w, (unsigned char*) sols);
    (void) genxEndElement(w);
    // castling
    (void) genxStartElementLiteral(w, NULL, castel);

    if (opt_castling != NULL) {
        (void) genxAddText(w, (unsigned char*) opt_castling);
    }

    (void) genxEndElement(w);
    // ep
    (void) genxStartElementLiteral(w, NULL, epel);

    if (opt_ep != NULL) {
        (void) genxAddText(w, (unsigned char*) opt_ep);
    }

    (void) genxEndElement(w);
    // set
    (void) genxStartElementLiteral(w, NULL, setel);

    if (opt_set == true) {
        (void) genxAddText(w, on);
    } else {
        (void) genxAddText(w, off);
    }

    (void) genxEndElement(w);
    // tries
    (void) genxStartElementLiteral(w, NULL, triesel);

    if (opt_tries == true) {
        (void) genxAddText(w, on);
    } else {
        (void) genxAddText(w, off);
    }

    (void) genxEndElement(w);
    // refuts
    (void) genxStartElementLiteral(w, NULL, refutsel);
    sols[0] = (char) opt_refuts + '0';
    sols[1] = '\0';
    (void) genxAddText(w, (unsigned char*) sols);
    (void) genxEndElement(w);
    // trivialtries
    (void) genxStartElementLiteral(w, NULL, trivialtriesel);

    if (opt_trivialtries == true) {
        (void) genxAddText(w, on);
    } else {
        (void) genxAddText(w, off);
    }

    (void) genxEndElement(w);
    // actual
    (void) genxStartElementLiteral(w, NULL, actualel);

    if (opt_actual == true) {
        (void) genxAddText(w, on);
    } else {
        (void) genxAddText(w, off);
    }

    (void) genxEndElement(w);
    // threats
    (void) genxStartElementLiteral(w, NULL, threatsel);

    switch (opt_threats) {
    case ALL:
        (void) genxAddText(w, (unsigned char*) "ALL");
        break;

    case NONE:
        (void) genxAddText(w, (unsigned char*) "NONE");
        break;

    case SHORTEST:
        (void) genxAddText(w, (unsigned char*) "SHORTEST");
        break;

    default:
        (void) genxAddText(w, (unsigned char*) "UNKNOWN");
        break;
    }

    (void) genxEndElement(w);
    // fleck
    (void) genxStartElementLiteral(w, NULL, fleckel);

    if (opt_fleck == true) {
        (void) genxAddText(w, on);
    } else {
        (void) genxAddText(w, off);
    }

    (void) genxEndElement(w);
    // shortvars
    (void) genxStartElementLiteral(w, NULL, shortvarsel);

    if (opt_shortvars == true) {
        (void) genxAddText(w, on);
    } else {
        (void) genxAddText(w, off);
    }

    (void) genxEndElement(w);
    (void) genxEndElement(w);
    return;
}

void add_dir_stats(DIR_SOL* dsol)
{
    char temp[20];
    (void) genxStartElementLiteral(w, NULL, statsel);
    (void) genxStartElementLiteral(w, NULL, addedel);
    (void) sprintf(temp, "%u", dsol->hash_added);
    (void) genxAddText(w, (unsigned char*) temp);
    (void) genxEndElement(w);
    (void) genxStartElementLiteral(w, NULL, hitnullel);
    (void) sprintf(temp, "%u", dsol->hash_hit_null);
    (void) genxAddText(w, (unsigned char*) temp);
    (void) genxEndElement(w);
    (void) genxStartElementLiteral(w, NULL, hitlistel);
    (void) sprintf(temp, "%u", dsol->hash_hit_list);
    (void) genxAddText(w, (unsigned char*) temp);
    (void) genxEndElement(w);
    (void) genxEndElement(w);
    return;
}

void time_dir(double st)
{
    char timeText[50];
    (void) genxStartElementLiteral(w, NULL, solvetime);
    (void) sprintf(timeText, "%f", st);
    (void) genxAddText(w, (unsigned char*) timeText);
    (void) genxEndElement(w);
    return;
}
