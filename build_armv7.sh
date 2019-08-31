#! /bin/bash
BNAME=$0
BNAME=${BNAME##*/}
BNAME=${BNAME%%.*}
ARCH=${BNAME##*_}
QtAV=$PWD
QTARM="/opt/qt5/$ARCH/4.9/"
QMAKE="$QTARM/bin/qmake"
MAKE="$HOME/android-ndk-r18b/prebuilt/linux-x86_64/bin/make"
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

$QMAKE $ROOTDIR/QtAV.pro -spec android-clang CONFIG+=debug CONFIG+=qml_debug
$MAKE -f $BUILDDIR/Makefile qmake_all
$MAKE -j `nproc`

#fix lib link
ln -sf $BUILDDIR/lib_android_arm_llvm $BUILDDIR/$QPSUBDIR/out/lib_android__llvm


BUILDDIR2=$BUILDDIR/$QPSUBDIR/build_armv7
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
sed -i "s/gradle\:.*/gradle\:2\.3\.3'/g" $BUILDDIR2/android-build/build.gradle
sed -i 's/gradle[^/]*zip/gradle\-3\.3\-all\.zip/g'  $BUILDDIR2/android-build/gradle/wrapper/gradle-wrapper.properties
cd $BUILDDIR2/android-build
./gradlew assembleDebug
find . |grep -i apk



