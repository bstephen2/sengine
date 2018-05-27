#!/bin/bash
set -x
sengine \
    --kings=b1h1 \
    --pos=h3a1g4h4d5f5g6h5b2b3d6f6g7h6h2 \
    --gbr=0042.47 \
    --actual \
    --moves=9 \
    --stip=# \
    --threats=NONE
echo $?
exit 0

