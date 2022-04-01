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
fi
# git fetch

# fix: crash for scan
sed -i 's#  register_all_function r#  // register_all_function r#' $src_dir/src/libdmusic/metadetector.cpp
sed -i 's#  register_all();#  // register_all();#' $src_dir/src/libdmusic/metadetector.cpp

##################### 构建 ###########################
mkdir -p $out_dir
cd $out_dir
sed -i 's#"-fPIC"#"-L/usr/lib/x86_64-linux-gnu -L/opt/Qt/5.15.2/gcc_64/lib -fno-sized-deallocation -fPIC"#' $src_dir/CMakeLists.txt
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
apt install -y libpq5 libpcre3 libvlc-dev libidn11 \
libswresample2 libwebp6 libcrystalhd3 libx265-146 \
libx264-152 libvpx5 libshine3 libssh-gcrypt-4 \
libvlc5 libvlc-bin libvlccore9 vlc-plugin-base \
vlc-plugin-qt 
# apt remove -y libvlccore9
cp -d /usr/lib/x86_64-linux-gnu/libicu*  $pkg_dir/usr/lib
cp -d /opt/Qt/5.15.2/gcc_64/lib/libdtk*so*  $pkg_dir/usr/lib
cp -d /usr/lib/libudisk*  $pkg_dir/usr/lib
cp -d /opt/Qt/5.15.2/gcc_64/lib/libmpris*  $pkg_dir/usr/lib
cp -d /opt/Qt/5.15.2/gcc_64/lib/libmpris*  $pkg_dir/usr/lib
cp -d /opt/Qt/5.15.2/gcc_64/lib/libQt5*  $pkg_dir/usr/lib
cp -d /opt/Qt/5.15.2/gcc_64/lib/libicu*  $pkg_dir/usr/lib
cp -dr /opt/Qt/5.15.2/gcc_64/plugins  $pkg_dir/usr
cp -d /usr/lib/x86_64-linux-gnu/libpq.s*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libvlc*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/vlc  $pkg_dir/usr/lib
cp -r /usr/lib/x86_64-linux-gnu/libKF5*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libav*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libswresample.s*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libwebp.s*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libcrystalhd.s*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libx265.s*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libx264.s*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libvpx.s*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libshine.s*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libssh-gcrypt.s*  $pkg_dir/usr/lib
cp -dr /lib/x86_64-linux-gnu/libidn.s*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libgsett*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libxcb*  $pkg_dir/usr/lib
# required by libavformat.so
cp -dr /usr/lib/x86_64-linux-gnu/libopenmpt*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libbluray*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libgme*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libchromaprint*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libva.s*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libva-*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libzvbi.s*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libxvidcore.s*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libsnappy.s*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libopenjp2.s*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libgsm*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libvdpau*  $pkg_dir/usr/lib
cp -dr /usr/lib/x86_64-linux-gnu/libsoxr*  $pkg_dir/usr/lib
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

tail -f /etc/issue