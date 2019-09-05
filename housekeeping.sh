fix_gradle() {
    # 3.2 vs 4.6
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
    cmd="$SED -i 's/gradle[^/]*zip/gradle\-5\.6\.1\-all\.zip/g' $WRAPPER"
    echo "$cmd"
    eval "$cmd"

}

fix_qt5_arm_ffmpeg() {
    QTARM="$1"
    if [[ -z "$QTARM" ]]; then
        QTARM="../qt5/$ARCH"
    fi
    if [[ ! -d "$QTARM" ]]; then
        echo "QT for $ARCH is not installed"
        echo "pls install it into $QTARM"
        echo "according to https://wiki.qt.io/Android"
        echo "and remember to add prefix to configure --prefix=$QTARM"
        echo "so that /opt/qt5/bin/qmake could be found"
        exit
    fi

    QMAKE="$QTARM/bin/qmake"
    if [[ ! -e "$QMAKE" ]]; then
        echo "$QMAKE does not exist!"
        exit
    fi

    src="ffmpeg-android/lib/$ARCH"
    dst="$QTARM/lib"
    echo $src
    echo $dst

    for mfile in $src/*.so; do
        dst_file="$dst/${mfile##*/}"
        if [ ! -f $dst_file ]; then
            echo "$dst_file is not found"
            cmd="cp $mfile $dst"
            $cmd
            echo $cmd
        else
            echo "$mfile does not exist"
        fi
    done
}


ARCH="armv7"
QTARM="../qt5"
#fix_gradle $QTARM/src/android/templates/build.gradle $QTARM/src/3rdparty/gradle/gradle/wrapper/gradle-wrapper.properties sudo
fix_gradle examples/QMLPlayer/android/build.gradle examples/QMLPlayer/android/gradle/wrapper/gradle-wrapper.properties
fix_qt5_arm_ffmpeg
