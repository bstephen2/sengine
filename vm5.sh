#!/bin/bash
set -x
valgrind --leak-check=full \
sengine \
    --kings=a8d5\
    --pos=h3c1e2e4c3g4c6e5h6\
    --gbr=0121.23\
    --actual \
    --moves=5 \
    --stip=#
echo $?
exit 0

