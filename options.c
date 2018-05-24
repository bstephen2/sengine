
/*
 *	options.c
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
 *	This is the module that processes the program options (input).
 */

#include "sengine.h"
#include "options.h"

static ARG_HASH_ENTRY* arghash = NULL;
static STIPREC_HASH_ENTRY* stiphash = NULL;

static int val_squares(char* instr)
{
    int rc = 1;
    char* ptr = instr;
    char* p;

    /*
     * Should follow the pattern:
     * /^([a-h][1-8])+$/
     * with no duplicate squares
     */

    if ((strlen(instr) % 2) == 0) {
        rc = 0;

        while (*ptr != '\0') {
            if ((*ptr < 'a') || (*ptr > 'h')) {
                rc = 1;
                break;
            }

            if ((* (ptr + 1) < '1') || (* (ptr + 1) > '8')) {
                rc = 1;
                break;
            }

            if (ptr > instr) {
                p = instr;

                while (p != ptr) {
                    if ((*p == *ptr) && (* (p + 1) == * (ptr + 1))) {
                        rc = 1;
                        break;
                    }

                    p += 2;
                }
            }

            if (rc != 0)
                break;

            ptr += 2;
        }
    }

    return rc;
}

static int val_kings(char* instr, ARGUMENT* arg)
{
    int rc = 1;
    char* ptr;
    /*
     * Pattern after '--kings' should be:
     * /^=[a-h][1-8][a-h][1-8]$/
     * and the squares should not be the same or adjacent.
     */
    ptr = instr + 7;
    opt_kings = ptr + 1;

    if (*ptr == '=') {
        ptr++;

        if (strlen(ptr) == 4) {
            if (val_squares(ptr) == 0) {
                rc = 0;
            }
        }
    }

    if (rc == 0) {
        int f, r;
        f = (int) * ptr - * (ptr + 2);
        r = (int) * (ptr + 1) - * (ptr + 3);

        if ((abs(f) == 1) && (abs(r) == 1)) {
            rc = 1;
        } else if ((abs(f) + abs(r)) == 1) {
            rc = 1;
        }
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return 0;
}

static int val_gbr(char* instr, ARGUMENT* arg)
{
    int rc = 1;
    char* ptr;
    /*
     * After '--gbr', pattern should be:
     *    /^=[0-4][0-8][0-8][0-8][.][0-8][0-8]$/
     */
    ptr = instr + 5;
    opt_gbr = ptr + 1;

    if (strlen(ptr) == 8) {
        if ((*ptr == '=') && (* (ptr + 5) == '.')) {
            if ((* (ptr + 1) >= '0') && (* (ptr + 1) <= '4')) {
                if ((* (ptr + 2) >= '0') && (* (ptr + 2) <= '8')) {
                    if ((* (ptr + 3) >= '0') && (* (ptr + 3) <= '8')) {
                        if ((* (ptr + 4) >= '0') && (* (ptr + 4) <= '8')) {
                            if ((* (ptr + 6) >= '0') && (* (ptr + 6) <= '8')) {
                                if ((* (ptr + 7) >= '0')
                                        && (* (ptr + 7) <= '8')) {
                                    rc = 0;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return rc;
}

static int val_pos(char* instr, ARGUMENT* arg)
{
    int rc = 1;
    char* ptr;
    /*
     * Pattern after '--pos' should be:
     * /^=([a-h][1-8])+$/
     * and the squares should not be duplicated.
     */
    ptr = instr + 5;
    opt_pos = ptr + 1;

    if (*ptr == '=') {
        rc = val_squares(ptr + 1);
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return rc;
}

static int val_castling(char* instr, ARGUMENT* arg)
{
    int rc = 1;
    char cast[] = "KQkq";
    int len;
    int i, j;
    char* ptr;
    ptr = instr + 10;
    opt_castling = ptr + 1;

    if (*ptr == '=') {
        rc = 0;
        ptr++;
        len = strlen(ptr);

        if (len > 0) {
            if (strspn(ptr, cast) == len) {
                if (len > 1) {
                    for (i = 0; i < len; i++) {
                        for (j = 0; j < len; j++) {
                            if (i != j) {
                                if (* (ptr + i) == * (ptr + j)) {
                                    rc = 1;
                                }
                            }
                        }
                    }
                }
            } else {
                rc = 1;
            }
        } else {
            rc = 1;
        }
    } else {
        rc = 1;
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return rc;
}

static int val_ep(char* instr, ARGUMENT* arg)
{
    int rc = 1;
    char* ptr;
    ptr = instr + 4;
    opt_ep = ptr + 1;

    if (*ptr == '=') {
        if (strlen(ptr + 1) == 2) {
            rc = val_squares(ptr + 1);
        }
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return 0;
}

static int val_hash(char* instr, ARGUMENT* arg)
{
    int rc = 1;
    char* ptr;
    char numbers[] = "0123456789";
    int h;
    ptr = instr + 6;

    if (*ptr == '=') {
        ptr++;

        if (*ptr != '\0') {
            if (strspn(ptr, numbers) == strlen(ptr)) {
                h = atoi(ptr);

                if (h < MAX_HASH_SIZE) {
                    rc = 0;
                    opt_hash = h;
                }
            }
        }
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return rc;
}

static int val_stip(char* instr, ARGUMENT* arg)
{
    int rc = 1;
    char* ptr;
    STIPREC_HASH_ENTRY* s;
    STIPREC_HASH_ENTRY* tmp;
    ptr = instr + 6;

    if ((*ptr == '=') && (* (ptr + 1) != '\0')) {
        int i;
        ptr++;

        for (i = 0; i < NUMSTIPS; i++) {
            s = (STIPREC_HASH_ENTRY*) malloc(sizeof(STIPREC_HASH_ENTRY));
            SENGINE_MEM_ASSERT(s);
            s->name = stips[i].name;
            s->aim = stips[i].aim;
            s->stip = stips[i].stip;
            HASH_ADD_KEYPTR(hh, stiphash, s->name, strlen(s->name), s);
        }

#ifndef NDEBUG
        int ct = HASH_COUNT(stiphash);
#endif
        HASH_FIND_STR(stiphash, ptr, s);

        if (s != NULL) {
            opt_aim = s->aim;
            opt_stip = s->stip;
            rc = 0;
        }

        HASH_ITER(hh, stiphash, s, tmp) {
            HASH_DEL(stiphash, s);
            free(s);
        }
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return rc;
}

static int val_threats(char* instr, ARGUMENT* arg)
{
    int rc = 1;
    char* ptr;
    ptr = instr + 9;

    if (*ptr == '=') {
        ptr++;

        if (strlen(ptr) != 0) {
            if (strcmp(ptr, "SHORTEST") == 0) {
                rc = 0;
                opt_threats = SHORTEST;
            } else if (strcmp(ptr, "NONE") == 0) {
                rc = 0;
                opt_threats = NONE;
            } else if (strcmp(ptr, "ALL") == 0) {
                rc = 0;
                opt_threats = ALL;
            }
        }
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return rc;
}

static int val_number(char* instr, ARGUMENT* arg)
{
    int rc = 1;
    char* ptr;
    ptr = strchr(instr, '=');

    if (ptr != NULL) {
        ptr++;

        if (* (ptr + 1) == '\0') {
            if ((*ptr >= '1') && (*ptr <= '9')) {
                int* iptr = (int*) arg->target;
                *iptr = (int) * ptr - '0';
                rc = 0;
            }
        }
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return rc;
}

static int val_actual(char* instr, ARGUMENT* arg)
{
    int rc = 1;

    if (strlen(instr) == 8) {
        rc = 0;
        opt_actual = true;
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return rc;
}

static int val_help(char* instr, ARGUMENT* arg)
{
    int rc = 1;

    if (strlen(instr) == 6) {
        rc = 0;
        opt_help = true;
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return 1;
}

static int val_set(char* instr, ARGUMENT* arg)
{
    int rc = 1;

    if (strlen(instr) == 5) {
        rc = 0;
        opt_set = true;
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return rc;
}

static int val_tries(char* instr, ARGUMENT* arg)
{
    int rc = 1;

    if (strlen(instr) == 7) {
        rc = 0;
        opt_tries = true;
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return rc;
}

static int val_trivialtries(char* instr, ARGUMENT* arg)
{
    int rc = 1;

    if (strlen(instr) == 14) {
        rc = 0;
        opt_trivialtries = true;
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return rc;
}

static int val_shortvars(char* instr, ARGUMENT* arg)
{
    int rc = 1;

    if (strlen(instr) == 11) {
        rc = 0;
        opt_shortvars = true;
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return rc;
}

static int val_fleck(char* instr, ARGUMENT* arg)
{
    int rc = 1;

    if (strlen(instr) == 7) {
        rc = 0;
        opt_fleck = true;
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return rc;
}

static int val_meson(char* instr, ARGUMENT* arg)
{
    int rc = 1;

    if (strlen(instr) == 7) {
        rc = 0;
        opt_meson = true;
    }

    if (rc != 0) {
        (void) fprintf(stderr, "sengine ERROR: invalid option => %s\n",
                       instr);
    }

    return rc;
}

static int val_unimplemented(char* instr, ARGUMENT* arg)
{
    (void) fprintf(stderr,
                   "sengine ERROR: option => %s not yet implemented\n",
                   instr);
    return 1;
}

static void set_up_argtable(void)
{
    int i;
    int ret;
    ARGUMENT args[ARGTYPES] = {
        {"--kings", true, &opt_kings, val_kings},
        {"--gbr", true, &opt_gbr, val_gbr},
        {"--pos", true, &opt_pos, val_pos},
        {"--castling", false, &opt_castling, val_castling},
        {"--ep", false, &opt_ep, val_ep},
        {"--hash", false, &opt_hash, val_hash},
        {"--stip", false, &opt_stip, val_stip},
        {"--threats", false, &opt_threats, val_threats},
        {"--moves", false, &opt_moves, val_number},
        {"--sols", false, &opt_sols, val_number},
        {"--refuts", false, &opt_refuts, val_number},
        {"--help", false, &opt_help, val_help},
        {"--threads", false, &opt_threads, val_unimplemented},
        {"--set", false, &opt_set, val_set},
        {"--tries", false, &opt_tries, val_tries},
        {"--trivialtries", false, &opt_trivialtries, val_trivialtries},
        {"--actual", false, &opt_actual, val_actual},
        {"--shortvars", false, &opt_shortvars, val_shortvars},
        {"--fleck", false, &opt_fleck, val_fleck},
        {"--meson", false, &opt_meson, val_meson},
        {"--virtualthreats", false, &opt_virtualthreats, val_unimplemented},
        {"--intelligent", false, &opt_intelligent, val_unimplemented},
        {"--postkeyplay", false, &opt_postkeyplay, val_unimplemented},
        {"--classify", false, &opt_classify, val_unimplemented},
    };

    for (i = 0; i < ARGTYPES; i++) {
        ARG_HASH_ENTRY* s = (ARG_HASH_ENTRY*) malloc(sizeof(ARG_HASH_ENTRY));
        SENGINE_MEM_ASSERT(s);
        memcpy(s, &args[i], sizeof(ARGUMENT));
        HASH_ADD_KEYPTR(hh, arghash, s->name, strlen(s->name), s);
    }

#ifndef NDEBUG
    int ct = HASH_COUNT(arghash);
#endif
    return;
}

static int scan_and_val_arguments(int argc, char** argv)
{
    int rc = 0;
    int i;
    char* ptr;
    char* arg;
    ARG_HASH_ENTRY* s;

    for (i = 1; i < argc; i++) {
        arg = argv[i];
        ptr = strchr(arg, '=');

        if (ptr != NULL) {
            *ptr = '\0';
        }

        HASH_FIND_STR(arghash, arg, s);

        if (ptr != NULL) {
            *ptr = '=';
        }

        if (s != NULL) {
            ARGUMENT ag;
            memcpy(&ag, s, sizeof(ARGUMENT));
            rc += (s->val)(arg, &ag);
        } else {
            rc++;
            (void) fprintf(stderr, "sengine ERROR: unknown option => %s\n",
                           arg);
        }
    }

    return rc;
}

static int val_combinations(void)
{
    int rc = 0;

    if (opt_stip == HELP) {
        if (opt_tries == true) {
            rc++;
            fputs("sengine ERROR: --tries not valid for helpmates", stderr);
        }

        if (opt_fleck == true) {
            rc++;
            fputs("sengine ERROR: --fleck not valid for helpmates", stderr);
        }

        if (opt_postkeyplay == true) {
            rc++;
            fputs("sengine ERROR: --postkeyplay not valid for helpmates",
                  stderr);
        }

        if (opt_trivialtries == true) {
            rc++;
            fputs("sengine ERROR: --trivialtries not valid for helpmates",
                  stderr);
        }

        if (opt_shortvars == true) {
            rc++;
            fputs("sengine ERROR: --shortvars not valid for helpmates", stderr);
        }
    } else {
        if (opt_postkeyplay == true) {
            if (opt_set == true) {
                rc++;
                fputs("sengine ERROR: --set not valid with --postkeyplay",
                      stderr);
            }

            if (opt_tries == true) {
                rc++;
                fputs("sengine ERROR --tries not valid with --postkeyplay",
                      stderr);
            }

            if (opt_refuts > 0) {
                rc++;
                fputs("sengine ERROR --refuts not valid with --postkeyplay",
                      stderr);
            }

            if (opt_moves == 1) {
                rc++;
                fputs("sengine ERROR --moves=1 not valid with --postkeyplay",
                      stderr);
            }
        }

        if ((opt_fleck == true) && (opt_threats == NONE)) {
            rc++;
            fputs("sengine ERROR: --fleck and --threats==NONE invalid", stderr);
        }

        if ((opt_refuts > 0) && (opt_tries == false)) {
            rc++;
            fputs("sengine ERROR: --refuts only valid with --tries", stderr);
        }

        if ((opt_tries == true) && (opt_refuts == 0)) {
            opt_refuts = 1;
        }
    }

    // kings and pos must be compatible
    {
        char kg[3];
        strncat(kg, opt_kings, 2);

        if (strstr(opt_pos, kg) != NULL) {
            rc++;
            fputs("sengine ERROR: square in --kings duplicated in --pos",
                  stderr);
        } else {
            if (strstr(opt_pos, & (opt_kings[2])) != NULL) {
                rc++;
                fputs("sengine ERROR: square in --kings duplicated in --pos",
                      stderr);
            }
        }
    }
    // gbr and pos must be compatible
    {
        int pc = 0;
        int i;
        int p;
        div_t dt;

        for (i = 0; i < 4; i++) {
            p = (int) opt_gbr[i] - '0';
            dt = div(p, 3);
            pc += dt.quot;
            pc += dt.rem;
        }

        for (i = 5; i < 7; i++) {
            p = (int) opt_gbr[i] - '0';
            pc += p;
        }

        if ((pc * 2) != strlen(opt_pos)) {
            rc++;
            fputs("sengine ERROR: --gbr and --pos not compatible", stderr);
        }
    }
    return rc;
}

static int val_mandatories(void)
{
    int rc = 0;
    //khiter_t k;
    ARGUMENT arg;
    char** ptr;
    //for ( k = kh_begin( harg ); k != kh_end( harg ); ++k ) {
    //if ( kh_exist( harg, k ) ) {
    //arg = kh_value( harg, k );
    //if ( arg.mandatory == true ) {
    //ptr = ( char ** ) arg.target;
    //if ( *ptr == NULL ) {
    //rc++;
    //( void ) fprintf( stderr, "sengine ERROR: %s option mandatory\n",
    //arg.name );
    //}
    //}
    //}
    //}
    return rc;
}

void do_usage(void)
{
    (void) fputs("USAGE: kalulu\n", stderr);
    (void) fputs(" --kings=s          king positions - eg. a1b4\n", stderr);
    (void) fputs(" --gbr=s            GBR code - eg. 1888.23\n", stderr);
    (void) fputs(" --pos=s            position\n", stderr);
    (void) fputs(" [--stip=s]         Stipulation valid is =, #, H=, H#, R=, R#, S=, S# (default = #)\n", stderr);
    (void) fputs(" [--moves=i]        Moves (default = 2) 1-9 are valid\n", stderr);
    (void) fputs(" [--sols=i]         Solutions (default = 1) 1-9 are valid\n", stderr);
    (void) fputs(" [--castling=s]     Castling rights - eg. KQkq for full castling\n", stderr);
    (void) fputs(" [--ep=s]           Square of a pawn that can be taken ep\n", stderr);
    (void) fputs(" [--refuts=i]       Number of refutations for tries (default = 0) 1-9 are valid\n", stderr);
    (void) fputs(" [--threats=s]      Calculate threats - NONE, SHORTEST (the default) or ALL\n", stderr);
    (void) fputs(" [--hash=n]         Set size (max 150,000), in number of entries, for hash table\n", stderr);
    (void) fputs(" [--help]           Display this help message\n", stderr);
    (void) fputs(" [--set]            Calculate set play\n", stderr);
    (void) fputs(" [--tries]          Calculate tries\n", stderr);
    (void) fputs(" [--trivialtries]   Include trivial tries\n", stderr);
    (void) fputs(" [--actual]         Calculate actual play\n", stderr);
    (void) fputs(" [--shortvars]      Include short variations\n", stderr);
    (void) fputs(" [--fleck]          Retain variations that allow some (but not all) of the threats\n", stderr);
    (void) fputs(" [--meson]          Running from Meson database, default is false\n", stderr);
    return;
}

int do_options(int argc, char** argv)
{
    int rc;
    ARG_HASH_ENTRY* s;
    ARG_HASH_ENTRY* tmp;
    set_up_argtable();
    rc = scan_and_val_arguments(argc, argv);

    if (opt_help == false) {
        rc += val_mandatories();
    }

    if ((rc == 0) || (opt_help == false)) {
        rc += val_combinations();
    }

    if (opt_help == true) {
        do_usage();
    } else if (rc != 0) {
        (void) fputs("\nTry sengine --help for help\n", stderr);
    }

    HASH_ITER(hh, arghash, s, tmp) {
        HASH_DEL(arghash, s);
        free(s);
    }
    return rc;
}

#ifdef OPTIONS
void show_options()
{
    (void) fputs("options::show_options() starting\n", stderr);
    (void) fprintf(stderr, "opt_kings          => /%s/\n", opt_kings);
    (void) fprintf(stderr, "opt_gbr            => /%s/\n", opt_gbr);
    (void) fprintf(stderr, "opt_pos            => /%s/\n", opt_pos);
    (void) fprintf(stderr, "opt_castling       => /%s/\n", opt_castling);
    (void) fprintf(stderr, "opt_ep             => /%s/\n", opt_ep);
    (void) fprintf(stderr, "opt_hash           => /%d/\n", opt_hash);
    (void) fprintf(stderr, "opt_aim            => /%d/\n", opt_aim);
    (void) fprintf(stderr, "opt_threats        => /%d/\n", opt_threats);
    (void) fprintf(stderr, "opt_stip           => /%d/\n", opt_stip);
    (void) fprintf(stderr, "opt_moves          => /%d/\n", opt_moves);
    (void) fprintf(stderr, "opt_sols           => /%d/\n", opt_sols);
    (void) fprintf(stderr, "opt_refuts         => /%d/\n", opt_refuts);
    (void) fprintf(stderr, "opt_help           => /%d/\n", opt_help);
    (void) fprintf(stderr, "opt_threads        => /%d/\n", opt_threads);
    (void) fprintf(stderr, "opt_set            => /%d/\n", opt_set);
    (void) fprintf(stderr, "opt_tries          => /%d/\n", opt_tries);
    (void) fprintf(stderr, "opt_trivialtries   => /%d/\n", opt_trivialtries);
    (void) fprintf(stderr, "opt_actual         => /%d/\n", opt_actual);
    (void) fprintf(stderr, "opt_shortvars      => /%d/\n", opt_shortvars);
    (void) fprintf(stderr, "opt_fleck          => /%d/\n", opt_fleck);
    (void) fprintf(stderr, "opt_virtualthreats => /%d/\n",
                   opt_virtualthreats);
    (void) fprintf(stderr, "opt_intelligent    => /%d/\n", opt_intelligent);
    (void) fprintf(stderr, "opt_postkeyplay    => /%d/\n", opt_postkeyplay);
    (void) fprintf(stderr, "opt_classify       => /%d/\n", opt_classify);
    (void) fprintf(stderr, "opt_meson          => /%d/\n", opt_meson);
    (void) fputs("options::show_options() ending\n", stderr);
    return;
}
#endif
