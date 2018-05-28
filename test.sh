#!/bin/bash
set -x
sengine \
    --kings=c7d5 \
    --pos=a1c6e8h3g2h6g6f7b2c3d2e2f2a4c4e4f6g4g7 \
    --gbr=1274.56 \
    --moves=2 \
    --stip=# \
    --actual \
    --tries \
    --set | kfilter
echo $?
exit 0

