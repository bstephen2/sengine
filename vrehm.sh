#!/bin/bash
set -x
valgrind --leak-check=full \
sengine \
    --kings=b7e5 \
    --pos=g1b6g4g2h7c8g8e7b8h5f1h4b2b5c7d3h3d4d5f3f6f7\
    --gbr=3878.55 \
    --actual \
    --moves=5 \
    --stip=#
echo $?
exit 0

