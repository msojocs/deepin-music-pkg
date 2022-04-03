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


# test
install_lib (){
  lib_name=$1
  echo "find lib: $lib_name"

  for path in /usr/lib/x86_64-linux-gnu /usr/lib /lib/x86_64-linux-gnu /opt/Qt/5.15.2/gcc_64/lib;do
    if ls "$path/$lib_name"* 1>/dev/null 2>&1;then
      echo "find $path"
      return
    fi
  done
  echo "库文件不存在 0"
  
}

install_lib libffi
if ls "/usr/lib/libffi"* 1>/dev/null 2>&1;then
  echo "ok"
fi