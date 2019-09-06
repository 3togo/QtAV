#! /bin/bash
QT5=$HOME/android/pkgs/qt5/
if [ -d $QT5 ]; then
    rm $QT5 -Rf
fi
now=$(date +"%Y_%m_%d")
tar czvf $HOME/android_$now.tar.gz -C $HOME $HOME/android
