#! /bin/bash
BNAME=$0
BNAME=${BNAME##*/}
BNAME=${BNAME%%.*}
ARCH=${BNAME##*_}
ARCH_SHORT=${ARCH##*-}
QtAV=$PWD
FFMPEG=$QtAV/ffmpeg-android
#QTARM=`find -L "/opt/qt5" -maxdepth 2 -type d -name "$ARCH"`
#QTARM=${QTARM##*[[:space:]]}
QTARM="$HOME/android/qt5/$ARCH_SHORT"
QMAKE="$QTARM/bin/qmake"


fix_qt5_arm_ffmpeg() {

    if [[ ! -d "$QTARM" ]]; then
        echo "QT for $ARCH is not installed"
        echo "pls install it into $QTARM"
        echo "according to https://wiki.qt.io/Android"
        echo "and remember to add prefix to configure --prefix=$QTARM"
        echo "so that $QTARM/bin/qmake could be found"
        exit
    fi


    if [[ ! -e "$QMAKE" ]]; then
        echo "$QMAKE does not exist!"
        exit
    fi


    src="$QtAV/ffmpeg-android/lib/$ARCH_SHORT"
    dst="$QTARM/lib"
    echo $src
    echo $dst
	mfiles=$src/*.so
	if [ -z "$mfiles" ]; then
		echo "$src does not contain any *.so"
		exit
	fi
    for mfile in $mfiles; do
        echo $mfile
        dst_file="$dst/${mfile##*/}"
        if [ ! -f $dst_file ]; then
            echo "$dst_file is not found"
            sudo cp $mfile $dst
        fi
    done
}
fix_gradle() {
    BUILD_GRADLE=$1
    WRAPPER=$2
    if [ -z $3 ]; then
        SED="sed"
    else
        SED="sudo sed"
    fi
    if [ ! -f $BUILD_GRADLE ]; then
        echo "$BUILD_GRADLE does not exist"
        exit
    fi
    if ! grep -q "google()" $BUILD_GRADLE; then
        cmd="$SED -i 's/jcenter()/jcenter()\n\t\tgoogle()\n/g' $BUILD_GRADLE"
        echo "$cmd"
        eval "$cmd"
    fi
    cmd="$SED -i \"s/gradle\:.*/gradle\:3\.5\.0'/g\" $BUILD_GRADLE"
    echo "$cmd"
    eval "$cmd"
    cmd="$SED -i 's/gradle[^/]*zip/gradle\-5\.4\.1\-all\.zip/g' $WRAPPER"
    echo "$cmd"
    eval "$cmd"

}

#fix qt5 arm first
fix_qt5_arm_ffmpeg
fix_gradle $QTARM/src/android/templates/build.gradle $QTARM/src/3rdparty/gradle/gradle/wrapper/gradle-wrapper.properties sudo


#MAKE="$HOME/android/android-ndk-r18b/prebuilt/linux-x86_64/bin/make"
MAKE=make
ROOTDIR=$QtAV

#disable VideoDecoderMediaCodec
sed -i 's/^[^#]*codec\/video\/VideoDecoderMediaCodec\.cpp/#&/' src/libQtAV.pro


BUILDDIR=$ROOTDIR/$BNAME
[[ ! -d $BUILDDIR ]] && mkdir $BUILDDIR
cd $BUILDDIR
QPSUBDIR=examples/QMLPlayer
SRCDIR=$ROOTDIR/$QPSUBDIR
#PRO=$ROOTDIR/QtAV.pro
PRO=$SRCDIR/QMLPlayer.pro
export CPATH=~/git/QtAV/ffmpeg-android/include:$CPATH
$QMAKE $ROOTDIR/QtAV.pro -spec android-clang CONFIG+=debug CONFIG+=qml_debug
#$QMAKE $ROOTDIR/QtAV.pro CONFIG+=debug CONFIG+=qml_debug

#export LIBRARY_PATH=~/git/QtAV/ffmpeg-android/lib/armv7:$LIBRARY_PATH
#export LD_LIBRARY_PATH=~/git/QtAV/ffmpeg-android/lib/armv7:$LD_LIBRARY_PATH
#export CC=clang

$MAKE -f $BUILDDIR/Makefile qmake_all
$MAKE -j `nproc`

#fix lib link
dirs=("$BUILDDIR/$QPSUBDIR" "$ROOTDIR/$QPSUBDIR")
for mdir in ${dirs[@]}; do
    mdir="$mdir/out"
    [[ ! -d $mdir ]] && mkdir -p $mdir
    cmd="ln -sf $BUILDDIR/lib_android_arm_llvm $mdir/lib_android__llvm"
    echo $cmd
    $cmd
done


BUILDDIR2=$BUILDDIR/$QPSUBDIR/$BNAME
[[ ! -d $BUILDDIR2 ]] && mkdir $BUILDDIR2
OUTDIR=$BUILDDIR2/android-build
MAKEFILE=$BUILDDIR2/Makefile
EXE_IN=$BUILDDIR/bin/libQMLPlayer.so
EXE_OUT=$OUTDIR/libs/armeabi-v7a/libQMLPlayer.so
JSON=android-libQMLPlayer.so-deployment-settings.json
cd $BUILDDIR2
cmd="$QMAKE $PRO -spec android-clang CONFIG+=debug CONFIG+=qml_debug"
echo "--------------$cmd---------------"
$cmd
echo $MAKEFILE
$MAKE -f $MAKEFILE qmake_all
$MAKE -j `nproc`

$MAKE INSTALL_ROOT=$OUTDIR install
$QMAKE -install qinstall -exe $EXE_IN $EXE_OUT

echo "---------- running androiddeployqt now ------------"
"$QTARM/bin/androiddeployqt" --input $JSON --output $OUTDIR --android-platform android-29 --jdk /usr/lib/jvm/java-8-openjdk-amd64 --gradle
fix_gradle $BUILDDIR2/android-build/build.gradle $BUILDDIR2/android-build/gradle/wrapper/gradle-wrapper.properties

cd $BUILDDIR2/android-build
./gradlew assembleDebug
cd $ROOTDIR
find . |grep -i "\.apk"



