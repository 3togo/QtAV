#! /bin/bash
BNAME=$0
BNAME=${BNAME##*/}
BNAME=${BNAME%%.*}
ARCH=${BNAME##*_}
ARCH_SHORT=${ARCH##*-}
QTAV=$PWD
FFMPEG=$PWD/ffmpeg-android
#bdir="/opt/jbuild"
bdir="$HOME/.local"
BARM=$bdir/qt5/$ARCH_SHORT
QMAKE=$BARM/bin/qmake
[[ ! -d $bdir ]] && sudo mkdir -p $bdir
[[ ! -d $bdir/ndk ]] &&  sudo ln -sf $PWD/../ndk $bdir/ndk
[[ ! -d $bdir/sdk ]] &&  sudo ln -sf $PWD/../sdk $bdir/sdk
#[[ ! -d $bdir/qt5 ]] &&  sudo ln -sf $PWD/../qt5 $bdir/qt5
export ANDROID_NDK_ROOT="$HOME/android/ndk"
export ANDROID_SDK_ROOT="$HOME/android/sdk"
echo "QMAKE = $QMAKE"
echo "ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT"
echo "ANDROID_NDK_ROOT=$ANDROID_NDK_ROOT"
###exit

echo "-------------------done fixing gradle---------------------"

MAKE=make

BUILDDIR=$PWD/$BNAME
[[ ! -d $BUILDDIR ]] && mkdir $BUILDDIR
cd $BUILDDIR
QPSUBDIR=examples/QMLPlayer
SRCDIR=$QTAV/$QPSUBDIR
PRO=$SRCDIR/QMLPlayer.pro
echo "PRO=$PRO"

#export CPATH=~/git/QtAV/ffmpeg-android/include:$CPATH
export CPATH=$FFMPEG/include:$CPATH
export LIBRARY_PATH=$FFMPEG/lib/armv7:$LIBRARY_PATH
export LD_LIBRARY_PATH=$FFMPEG/lib/armv7:$LD_LIBRARY_PATH
echo "CPATH=$CPATH"
job_1() {

cmd="$QMAKE $QTAV/QtAV.pro -spec android-clang CONFIG+=debug CONFIG+=qml_debug -config recheck"
#cmd="$QMAKE $PWD/QtAV.pro CONFIG+=debug CONFIG+=qml_debug -config recheck"
$cmd
echo $cmd
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
echo "CPATH=$CPATH"

$MAKE -f $BUILDDIR/Makefile qmake_all
$MAKE -j `nproc`

#fix lib link
dirs=("$BUILDDIR/$QPSUBDIR" "$QTAV/$QPSUBDIR")
for mdir in ${dirs[@]}; do
    mdir="$mdir/out"
    [[ ! -d $mdir ]] && mkdir -p $mdir
    cmd="ln -sf $BUILDDIR/lib_android_arm_llvm $mdir/lib_android__llvm"
    echo $cmd
    $cmd
done

   sdk_install="$BUILDDIR/sdk_install.sh"
    if [ ! -f $sdk_install ]; then
        echo "$sdk_install does not exist"
        exit
    fi
    cmd="sudo bash $sdk_install"
    $cmd
    echo "$cmd"
    echo "done adding libQtAV libraries to qtarm"

}

#CAN_I_RUN_SUDO=$(sudo -n uptime 2>&1|grep "load"|wc -l)
CAN_I_RUN_SUDO=$(sudo -n -v 2>&1|grep "Sorry"|wc -l)
if [ ${CAN_I_RUN_SUDO} -eq 0 ]; then
    echo "I can run the sudo command(${CAN_I_RUN_SUDO}"
    job_1
else
    echo "I can't run the Sudo command${CAN_I_RUN_SUDO}"
fi


BUILDDIR2=$BUILDDIR/$QPSUBDIR/$BNAME
[[ ! -d $BUILDDIR2 ]] && mkdir $BUILDDIR2
OUTDIR=$BUILDDIR2/android-build
MAKEFILE=$BUILDDIR2/Makefile
EXE_IN=$BUILDDIR/bin/libQMLPlayer.so
EXE_OUT=$OUTDIR/libs/armeabi-v7a/libQMLPlayer.so
JSON=android-libQMLPlayer.so-deployment-settings.json
EXE_OUT2=$BUILDDIR/$QPSUBDIR/out/bin/libQMLPlayer.so
JSON=android-libQMLPlayer.so-deployment-settings.json
cp $EXE_IN $EXE_OUT2
cd $BUILDDIR2
cmd="$QMAKE -d $PRO -spec android-clang CONFIG+=debug CONFIG+=qml_debug"
echo "--------------$cmd---------------"
$cmd

echo $MAKEFILE
$MAKE -f $MAKEFILE qmake_all
$MAKE -j `nproc`

$MAKE INSTALL_ROOT=$OUTDIR install
$QMAKE -install qinstall -exe $EXE_IN $EXE_OUT

echo "---------- running androiddeployqt now ------------"
"$BARM/bin/androiddeployqt" --input $JSON --output $OUTDIR --android-platform android-29 --jdk /usr/lib/jvm/java-8-openjdk-amd64 --gradle

cd $BUILDDIR2/android-build
./gradlew assembleDebug

cd $BUILDDIR
find . -type f -print|grep -i "\.apk"|xargs adb install



