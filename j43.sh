#!/bin/bash
set -x
sengine \
    --kings=e3e5 \
    --pos=f2c2b7c7d2a2b2c5c6g6 \
    --gbr=0112.15 \
    --moves=6 \
    --stip=# \
    --actual
echo $?
exit 0

