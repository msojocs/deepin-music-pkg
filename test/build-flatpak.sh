#!/bin/bash
set -e
export HTTP_PROXY="http://127.0.0.1:7890"
export HTTPS_PROXY="http://127.0.0.1:7890"
root_dir=$(cd `dirname $0`/.. && pwd -P)


cd $root_dir
flatpak-builder build/flatpak deepin-music.yml --force-clean --install --user
flatpak run org.deepin.deepin-music
