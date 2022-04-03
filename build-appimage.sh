#!/bin/bash
set -e
notice() {
    echo -e "\033[36m $1 \033[0m "
}
fail() {
    echo -e "\033[41;37m 失败 \033[0m $1"
}

root_dir=$(cd `dirname $0` && pwd -P)
build_dir="$root_dir/build"
pkg_dir="$build_dir/AppDir"
tmp_dir="$build_dir/tmp"
out_dir="$build_dir/out"
src_dir="$build_dir/src"
rm -rf $pkg_dir

###################### 准备 ##########################
mkdir -p $src_dir
cd $src_dir
src_dir="$src_dir/deepin-music"
if [[ ! -d $src_dir ]];then
  git clone https://hub.fastgit.xyz/linuxdeepin/deepin-music.git
else
  cd $src_dir
  git checkout .
fi

cd $src_dir
git checkout tags/6.2.12

# fix: crash for scan, 此问题修正于：https://github.com/linuxdeepin/deepin-music/commit/36c7b09f5f9c25b8ac6c46f7d113950c05d2981f
sed -i 's#  register_all_function r#  // register_all_function r#' $src_dir/src/libdmusic/metadetector.cpp
sed -i 's#  register_all();#  // register_all();#' $src_dir/src/libdmusic/metadetector.cpp

##################### 构建 ###########################
mkdir -p $out_dir
cd $out_dir
sed -i 's#"-fPIC"#"-L/usr/lib/x86_64-linux-gnu -L/opt/Qt/5.15.2/gcc_64/lib -I/opt/Qt/5.15.2/gcc_64/include -fPIC"#' $src_dir/CMakeLists.txt
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig:/opt/Qt/5.15.2/gcc_64/lib/pkgconfig:$PKG_CONFIG_PATH"
cmake $src_dir
# export LD_LIBRARY_PATH="/usr/lib/gcc/x86_64-linux-gnu/5:$LD_LIBRARY_PATH"
# export CC=gcc-5
# export CPP=g++-5
# export CXX=g++-5
make # CC=gcc-5 CPP=g++-5 CXX=g++-5 LD=g++-5
make install DESTDIR=$pkg_dir

mkdir -p $pkg_dir $tmp_dir
mkdir -p $pkg_dir/usr/{bin,lib,share/applications,share/icons}
mkdir -p $pkg_dir/usr/share/icons/hicolor/scalable/apps

# desktop
# cp src/music-player/data/deepin-music.desktop $pkg_dir/usr/share/applications
cp $src_dir/src/music-player/data/deepin-music.desktop $pkg_dir
# icon
# cp src/music-player/icons/icons/deepin-music.svg $pkg_dir/usr/share/icons/hicolor/scalable/apps
cp $src_dir/src/music-player/icons/icons/deepin-music.svg $pkg_dir

cat > "$pkg_dir/AppRun" <<- 'EOF'
#!/bin/bash
export LD_LIBRARY_PATH="$APPDIR/usr/lib:$LD_LIBRARY_PATH"
if [[ -f ~/debug.sh ]];then
  echo "====DEBUG====="
  ~/debug.sh
fi
export QT_PLUGIN_PATH=$APPDIR/usr/lib/qt5/plugins
exec $APPDIR/usr/local/bin/deepin-music -platformtheme deepin -style chameleon
EOF
chmod +x "$pkg_dir/AppRun"

# lib

install_lib (){
  lib_name=$1
  notice "install lib: $lib_name"
  find=0
  for path in /usr/lib/x86_64-linux-gnu /usr/lib /lib/x86_64-linux-gnu /opt/Qt/5.15.2/gcc_64/lib;do
    if ls "$path/$lib_name"* 1>/dev/null 2>&1;then
      echo "found in $path"
      cp -dr "$path/$lib_name"*  $pkg_dir/usr/lib
      find=1
    fi
  done
  if [[ find == 0 ]];then
    fail "库文件不存在 0"
    exit 404
  fi
}
install_libs (){
  for lib in $@;do
    install_lib $lib
  done
}

# apt remove -y libvlccore9
install_libs libicu libdtk libudisk libmpris libQt5 libicu libpq.s \
            libvlc libKF5 libav libswresample.s libwebp.s libcrystalhd.s \
            libx265.s libx264.s libvpx.s libshine.s libssh-gcrypt.s \
            libgcrypt.s libgpg-error.s libidn.s libgsett libxcb libpcre16
            # required by libavformat.so
install_libs libopenmpt libbluray libgme libchromaprint libva.s libva- \
            libzvbi.s libxvidcore.s libsnappy.s libopenjp2.s libgsm \
            libvdpau libsoxr
            # ubuntu16
install_libs librabbitmq libsrt-gnutls libcodec2 libudfread libzmq \
            libwebpmux libdav1d libaom libmp3lame libSvtAv1Enc \
            libtwolame libmfx libOpenCL libmpg123 libssl libcrypto \
            libnettle libpng16 libnorm libpgm-5.2 libsodium libz. \
            libidn2 libunistring 
            # deepin20
install_libs libgnutls libhogweed

cp -dr /opt/Qt/5.15.2/gcc_64/plugins  $pkg_dir/usr
cp -dr /usr/lib/x86_64-linux-gnu/vlc  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/gio  $pkg_dir/usr/lib

# theme
mkdir -p $pkg_dir/usr/lib/qt5/plugins
cp -dr /opt/Qt/5.15.2/gcc_64/plugins/{iconengines,imageformats,platforms,platformthemes,styles} $pkg_dir/usr/lib/qt5/plugins
cp -dr /usr/local/lib/libQt5Xdg*  $pkg_dir/usr/lib
cd $pkg_dir/usr/lib && ln -s . x86_64-linux-gnu

# cp -r /opt/Qt/5.15.2/gcc_64/lib/lib*  $pkg_dir/usr/lib
# cp -r /lib/x86_64-linux-gnu/lib*  $pkg_dir/usr/lib
# cp /opt/Qt/5.15.2/gcc_64/lib/libicu*  $pkg_dir/usr/lib
# ls /opt/Qt/5.15.2/gcc_64/lib | grep
# ls /usr/lib/x86_64-linux-gnu | grep

notice "下载AppImage构建工具 ACTION_MODE:$ACTION_MODE"
if [[ $ACTION_MODE == 'true' ]]; then
  appimagetool_host="github.com"
else
  appimagetool_host="download.fastgit.org"
fi
if [ ! -f "$tmp_dir/appimagetool-x86_64.AppImage" ];then
  wget "https://$appimagetool_host/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" \
    -O "$tmp_dir/appimagetool-x86_64.AppImage"
fi
chmod a+x "$tmp_dir/appimagetool-x86_64.AppImage"

notice "MAKE APPIMAGE"
export  ARCH=x86_64
$tmp_dir/appimagetool-x86_64.AppImage --version
$tmp_dir/appimagetool-x86_64.AppImage "$pkg_dir" "$build_dir/deepin-music.AppImage"
chmod +x "$build_dir/deepin-music.AppImage"
# "$root_dir/build/deepin-music.AppImage"

#tail -f /etc/issue
