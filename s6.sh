#!/bin/bash
set -x
sengine \
    --kings=g3e4 \
    --pos=a2e3g4c3d2c4c5d3g5 \
    --gbr=0012.24 \
    --actual \
    --moves=6 \
    --stip=# | kfilter
echo $?
exit 0

