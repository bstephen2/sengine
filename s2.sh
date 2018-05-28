#!/bin/bash
set -x
sengine \
    --kings=a5g4 \
    --pos=c3b4h1h5e8e6h4g1g5f2e4e5f3h6h7 \
    --gbr=1518.15 \
    --moves=2 \
    --stip=# \
    --actual
echo $?
exit 0

