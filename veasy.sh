#!/bin/bash
set -x
valgrind --leak-check=full \
    sengine \
        --kings=c2a1 \
        --pos=g7 \
        --gbr=0000.10 \
        --moves=2 \
        --stip=# \
        --actual | kfilter
echo $?
exit 0

