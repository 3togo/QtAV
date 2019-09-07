#! /bin/bash
#install missing apk
pkgs=( "libqt5svg5-dev" "qt5-default" )
for mpkg in ${pkgs[@]}; do 
    dpkg -s $mpkg 2>/dev/null >/dev/null || sudo apt-get -y install $mpkg
done
BNAME=$0
BNAME=${BNAME##*/}
BNAME=${BNAME%%.*}
ARCH=${BNAME##*_}
QtAV=$PWD
BUILDDIR=$QtAV/$BNAME
[[ ! -d $BUILDDIR ]] && mkdir -p $BUILDDIR 
cd $BUILDDIR
echo $PWD
qmake ../QtAV.pro
make -j `nproc`
#only install /usr/lib/x86_64-linux-gnu/libQtAV.so
PREFIX=$HOME/.local
make INSTALL_ROOT=$PREFIX install 
cp bin $PREFIX -Rf
cmd=$PREFIX/bin/Player
echo "running $cmd"
$cmd
