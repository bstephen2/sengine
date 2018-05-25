#!/bin/bash
set -x
valgrind --leak-check=full sengine --kings=a4c4 --pos=g4h2g5e4f2a1a8f4g8d3g2d2b4b5c2b6h3 --gbr=4785.32 --moves=2 --stip=# --set --tries
echo $?
exit 0

