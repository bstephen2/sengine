#!/bin/bash
set -x
valgrind --leak-check=full \
    sengine \
    --kings=c2a1 \
    --pos=e4 \
    --gbr=1000.00 \
    --moves=1 \
    --stip=# \
    --actual | kfilter
echo $?
exit 0