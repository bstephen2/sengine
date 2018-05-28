#!/bin/bash
set -x
sengine \
    --kings=h8e5 \
    --pos=f6d6d2f3d7b3h7b5c2c5d3e6g5 \
    --gbr=0455.23 \
    --moves=6 \
    --stip=# \
    --actual | kfilter
echo $?
exit 0

