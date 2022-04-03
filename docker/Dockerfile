FROM msojocs/ubuntu16-dtk-env:v1.0

# 以下，deepin-music
RUN apt install -y libvlc-dev libvlccore-dev libtag1-dev libodbc1 libpq5 \
    qtbase5-dev libkf5codecs-dev libicu-dev libfuse2 \
    gcc g++ python3 software-properties-common && \
    add-apt-repository ppa:savoury1/ffmpeg4 &&\
    add-apt-repository ppa:savoury1/multimedia &&\
    add-apt-repository ppa:savoury1/graphics &&\
    add-apt-repository ppa:savoury1/vlc3 &&\
    apt update && apt upgrade -y && \
    apt install -y libavcodec-dev libavformat-dev libpulse-mainloop-glib0 libpq5 libpcre3 libvlc-dev libidn11 \
    libwebp6 libcrystalhd3 vlc-plugin-base \
    libshine3 libssh-gcrypt-4 vlc-plugin-qt \
    libvlc5 libvlc-bin libvlccore9 libudfread0 librabbitmq4 \
    libsrt1.4-gnutls libcodec2-0.9 libxcb-xinerama0 glib-networking \
    libhogweed6 idn2
RUN mkdir -p /workplace/other && cd /workplace/other &&\
    git clone https://hub.fastgit.xyz/sailfishos/qtmpris.git &&\
    cd qtmpris && qmake && make && make install &&\
    mkdir -p /workplace/other && cd /workplace/other &&\
    git clone https://hub.fastgit.xyz/linuxdeepin/udisks2-qt5.git &&\
    cd udisks2-qt5 && qmake QMAKE_CXXFLAGS=-fno-sized-deallocation QMAKE_CFLAGS=-fno-sized-deallocation && \
    make && make install &&\
    mkdir -p /workplace/other && cd /workplace/other &&\
    git clone https://hub.fastgit.xyz/sailfishos/qtdbusextended.git &&\
    cd qtdbusextended && qmake && make && make install && \
    mkdir -p /workplace/other && cd /workplace/other &&\
    git clone https://hub.fastgit.xyz/linuxdeepin/dde-qt-dbus-factory.git &&\
    cd dde-qt-dbus-factory && qmake && make && make install

# RUN tail -f /etc/issue
    # libdbusextended-qt5-dev libdframeworkdbus-dev libicu60

