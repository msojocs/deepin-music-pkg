# DEEPIN-MUSIC PACKAGE

## 构建

AppImage
---
使用Docker构建
`docker-compose up`

Flatpak
---
执行`flatpak-builder build/flatpak deepin-music.yml --force-clean --install --user`


## 打包兼容情况

AppImage
---
- [x] manjaro
- [x] deepin 20
- [x] mint19.3
- [x] ubuntu18.04
- [x] ubuntu16.04

flatpak
---
使用沙箱运行，应该都兼容
- [x] manjaro

## THANKS

[Rob Savoury](https://launchpad.net/~savoury1)