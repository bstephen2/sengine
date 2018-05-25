#!/bin/bash
set -x
sengine \
    --kings=d6d4 \
    --pos=d1d5d7a2b3d3f3g2a3c3e3g3 \
    --gbr=1040.54 \
    --actual \
    --moves=5 \
    --stip=#
echo $?
exit 0

