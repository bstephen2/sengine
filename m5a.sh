#!/bin/bash
set -x
sengine \
    --kings=a4a1 \
    --pos=e7c3d1a2a5 \
    --gbr=0012.02 \
    --actual \
    --moves=5 \
    --stip=# | kfilter
echo $?
exit 0

