#!/bin/bash

root_dir=$(cd `dirname $0`/.. && pwd -P)

export LD_LIBRARY_PATH=""
EXE_FILE="$root_dir/build/out/src/music-player/deepin-music"
result=$( ldd $EXE_FILE | grep "not found" )
echo $result
result=${result//=> not found/}
echo $result
echo "==========for============"
for item in $result;do
  echo $item
done