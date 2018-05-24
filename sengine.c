
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
 *	This is the main control module that contains the 'main' function.
 */

#include "sengine.h"
extern enum STIP opt_stip;
extern uint64_t positions_got;
extern uint64_t boards_got;
extern uint64_t boardlists_got;
extern uint64_t positions_freed;
extern uint64_t boards_freed;
extern uint64_t boardlists_freed;

static clock_t prog_start, prog_end;
static double run_time;
enum SOUNDNESS sound;

void end_clock(void)
{
    prog_end = clock();
    run_time = (double)(prog_end - prog_start) / CLOCKS_PER_SEC;
    return;
}

int main(int argc, char* argv[])
{
    int rc;
    prog_start = clock();
    rc = do_options(argc, argv);
    exit(0);

    if (rc == 0) {
        BOARD* init_pos;
        init();
        init_mem();

        if (opt_stip == HELP) {
            init_pos = setup_diagram(WHITE);
        } else {
            init_pos = setup_diagram(BLACK);
        }

        rc = validate_board(init_pos);

        if (rc == 0) {
            switch (opt_stip) {
            case DIRECT: {
                DIR_SOL* dir_sol;
                dir_sol = (DIR_SOL*) calloc(1, sizeof(DIR_SOL));
                solve_direct(dir_sol, init_pos);
                start_dir();

                if (dir_sol->set != NULL) {
                    add_dir_set(dir_sol->set);
                }

                if (dir_sol->tries != NULL) {
                    add_dir_tries(dir_sol->tries);
                }

                if (dir_sol->keys != NULL) {
                    add_dir_keys(dir_sol->keys);
                }

                add_dir_options();
                add_dir_stats(dir_sol);
                end_clock();
                time_dir(run_time);
                end_dir();
                break;
            }

            case SELF:
                (void) fputs("sengine ERROR: Can't solve selfmates yet!",
                             stderr);
                exit(1);
                break;

            case REFLEX:
                (void) fputs("sengine ERROR: Can't solve reflexmates yet!",
                             stderr);
                exit(1);
                break;

            case HELP:
                (void) fputs("sengine ERROR: Can't solve helpmates yet!",
                             stderr);
                exit(1);
                break;

            default:
                (void) fputs("sengine ERROR: impossible invalid stipulation!!",
                             stderr);
                exit(1);
                break;
            }

            close_mem();
        } else {
            close_mem();
            prog_end = clock();
            run_time = (double)(prog_end - prog_start) / CLOCKS_PER_SEC;
            (void) fprintf(stderr, "Running Time = %f\n", run_time);
        }
    }

    return rc;
}

int tzcount(BITBOARD inBrd)
{
    if (inBrd == 0) {
        return 64;
    }

    return __builtin_ctzll(inBrd);
}
