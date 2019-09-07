
reinstall_ndk_sdk() {
    for mzip in $NDK_ZIP $SDK_ZIP; do
        if [ -z "$mzip" ]; then
            echo "$mzip was not found"
            exit
        fi
    done
    echo "----------unzip $NDK----------"
    unzip $NDK_ZIP -o -d $PKGS
    echo "----------unzip $SDK----------"
    unzip $SDK_ZIP -o -d $PKGS/android-sdk-tools

    QT5=$PKGS/qt5
}

build_qt5() {
    if [ ! -f $QT5_ZIP]; then
        echo "$QT5_ZIP cannot be found"
        exit
    fi
    tar zxvf $QT5_ZIP -C $PKGS

    if [ ! -d $QT5 ]; then
        echo "$QT5 directory cannot be found"
    fi
    cd $QT5
    export ANDROID_NDK_ROOT=$HOME/android/ndk
    export ANDROID_SDK_ROOT=$HOME/android/sdk
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
    export PATH=$PATH:$JAVA_HOME/bin
    ./configure -opensource -confirm-license -xplatform android-clang -nomake tests -nomake examples -android-ndk $HOME/android/ndk -android-sdk $HOME/android/sdk -android-ndk-host linux-x86_64 -skip qttranslations -skip qtserialport -no-warnings-are-errors --prefix=$PREFIX
    echo -n "OK to do 'make' ?"
    read -t 5 answer
    answer=${answer:-y}
    if [ "$answer" != "${answer#[Yy]}" ] ; then
        make -j `nproc`
        make install
    fi
}

PREFIX=$HOME/.local/qt5/armv7
PKGS=$HOME/android/pkgs
QT5_ZIP=$PKGS/zips/qt5.tar.gz
NDK_ZIP=$(find $PKGS -name "android-ndk*.zip" -print -quit)
SDK_ZIP=$(find $PKGS -name "sdk-tool*.zip" -print -quit)
echo "NDK_ZIP=$NDK_ZIP"
echo "SDK_ZIP=$SDK_ZIP"

reinstall_ndk_sdk
build_qt5
