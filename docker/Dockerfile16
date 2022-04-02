FROM msojocs/ubuntu16-qt5:15.2

WORKDIR /workspace

RUN sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    apt update && \
    apt install -y libgsettings-qt-dev libgsettings-qt1 librsvg2-dev \
    libxi-dev libxcb-util-dev libstartup-notification0-dev libcups2-dev \
    git libgl-dev wget \
    # for theme
    libmtdev-dev && apt clean cache &&\
    # 修正安装路径 /home/qt/work/install -----> /opt/Qt/5.15.2/gcc_64
    mkdir -p /home/qt/work && ln -s /opt/Qt/5.15.2/gcc_64 /home/qt/work/install &&\
    # CMAKE
    cd /tmp && wget https://hub.fastgit.xyz/Kitware/CMake/releases/download/v3.15.4/cmake-3.15.4-Linux-x86_64.tar.gz &&\
    tar -xzvf cmake-3.15.4-Linux-x86_64.tar.gz &&\
    mv cmake-3.15.4-Linux-x86_64 /opt/cmake-3.15.4 && \
    rm -rf cmake-3.15.4-Linux-x86_64.tar.gz &&\
    ln -sf /opt/cmake-3.15.4/bin/* /usr/bin/ && \
    cmake --version
ENV PATH="/opt/Qt/5.15.2/gcc_64/bin:$PATH"
# dtk
# dtkcommon
RUN mkdir -p /workplace/dtk && cd /workplace/dtk &&\
    git clone https://hub.fastgit.xyz/linuxdeepin/dtkcommon.git && \
    cd dtkcommon && qmake && make && make install &&\
    # dtkcore
    mkdir -p /workplace/dtk && cd /workplace/dtk &&\
    git clone https://hub.fastgit.xyz/linuxdeepin/dtkcore.git && \
    cd dtkcore && qmake && make -nomake tests && make install &&\
    # dtkgui
    mkdir -p /workplace/dtk && cd /workplace/dtk &&\
    git clone https://hub.fastgit.xyz/linuxdeepin/dtkgui.git && \
    cd dtkgui && qmake && make -nomake tests && make install &&\
    # dtkwidget
    mkdir -p /workplace/dtk && cd /workplace/dtk &&\
    git clone https://hub.fastgit.xyz/linuxdeepin/dtkwidget.git &&\
    cd dtkwidget && qmake QMAKE_INCDIR=/usr/include/x86_64-linux-gnu/qt5 && make -nomake tests && make install
# theme
RUN mkdir -p /workplace/dtk && cd /workplace/dtk &&\
    git clone https://hub.fastgit.xyz/lxqt/lxqt-build-tools.git &&\
    cd lxqt-build-tools && git checkout tags/0.10.0 && \
    mkdir build && cd build && cmake .. && make && make install &&\
    # libqtxdg
    mkdir -p /workplace/dtk && cd /workplace/dtk &&\
    git clone https://hub.fastgit.xyz/lxqt/libqtxdg.git &&\
    cd /workplace/dtk/libqtxdg && git checkout tags/3.8.0 && \
    mkdir build && cd build && cmake .. && make && make install &&\
    # googletest
    mkdir -p /workplace/other && cd /workplace/other &&\
    git clone --single-branch --branch release-1.11.0 https://hub.fastgit.xyz/google/googletest.git &&\
    cd /workplace/other/googletest && \
    mkdir build && cd build && cmake .. && make && make install &&\
    # qt5integration
    mkdir -p /workplace/dtk && cd /workplace/dtk &&\
    git clone https://hub.fastgit.xyz/linuxdeepin/qt5integration.git && \
    export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig:/opt/Qt/5.15.2/gcc_64/lib/pkgconfig:$PKG_CONFIG_PATH" && \
    cd /workplace/dtk/qt5integration && \
    mkdir build && cd build && qmake .. && make && make install && \
    # gosu
    apt install -y gosu && \
    gosu nobody true
# 以下，deepin-music
RUN mkdir -p /workplace/other && cd /workplace/other &&\
    git clone https://hub.fastgit.xyz/sailfishos/qtmpris.git &&\
    cd qtmpris && qmake && make && make install
RUN mkdir -p /workplace/other && cd /workplace/other &&\
    git clone https://hub.fastgit.xyz/linuxdeepin/udisks2-qt5.git &&\
    cd udisks2-qt5 && qmake QMAKE_CXXFLAGS=-fno-sized-deallocation QMAKE_CFLAGS=-fno-sized-deallocation && make && make install
RUN apt install -y libvlc-dev libvlccore-dev libtag1-dev libodbc1 libpq5 \
    qtbase5-dev libkf5codecs-dev libicu-dev libfuse2 \
    gcc g++
RUN mkdir -p /workplace/other && cd /workplace/other &&\
    git clone https://github.com/sailfishos/qtdbusextended.git &&\
    cd qtdbusextended && qmake && make && make install
RUN apt install -y python3
RUN mkdir -p /workplace/other && cd /workplace/other &&\
    git clone https://github.com/linuxdeepin/dde-qt-dbus-factory.git &&\
    cd dde-qt-dbus-factory && qmake && make && make install
RUN apt install -y software-properties-common && \
    add-apt-repository ppa:savoury1/ffmpeg4 &&\
    add-apt-repository ppa:savoury1/multimedia &&\
    add-apt-repository ppa:savoury1/graphics &&\
    add-apt-repository ppa:savoury1/vlc3 &&\
    apt update && apt upgrade -y && \
    apt install -y libavcodec-dev libavformat-dev libpulse-mainloop-glib0

# RUN tail -f /etc/issue
    # libdbusextended-qt5-dev libdframeworkdbus-dev libicu60

