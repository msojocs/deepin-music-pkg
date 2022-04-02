FROM msojocs/ubuntu16-dtk-env:v1.0

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

