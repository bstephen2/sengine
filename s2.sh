#!/bin/bash
set -x
sengine \
    --kings= \
    --pos= \
    --gbr= \
    --castling=KQ \
    --moves=2 \
    --stip=# \
    --actual \
    --set \
    --tries | kfilter
echo $?
exit 0

