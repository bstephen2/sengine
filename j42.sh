#!/bin/bash
set -x
sengine \
    --kings=e7d5 \
    --pos=h2a4d4a2e5g3e1h3e3b7c2f7g2 \
    --gbr=0358.14 \
    --moves=6 \
    --stip=# \
    --actual | kfilter
echo $?
exit 0

