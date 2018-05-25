#!/bin/bash
set -x
sengine --kings=f5d4 --pos=f7a5b4h3d2b2c2g3f8a3b6c5f2f3g4h5b3b7c6d3e5g5 --gbr=1772.76 --moves=3 --stip=# --set --tries | kfilter
echo $?
exit 0

