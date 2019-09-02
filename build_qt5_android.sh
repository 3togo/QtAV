#!/bin/bash
GIT=$HOME/git
wkdir=$HOME/android
cfg=$HOME/.android/repositories.cfg
ndkVersion="r18b"
sdkBuildToolsVersion="28.0.3"
sdkApiLevel="android-28"
toolsVersion="r26.1.1"
arch="armv7"
repository=https://dl.google.com/android/repository
toolsFile=sdk-tools-linux-4333796.zip
toolsFolder=$wkdir/android-sdk-tools
ndkFile=android-ndk-$ndkVersion-linux-x86_64.zip
ndkFolder=$wkdir/android-ndk-$ndkVersion


qt5_prebuild() {
    [[ ! -d $wkdir ]] && mkdir $wkdir
    [[ ! -f $cfg ]] && touch $cfg
    #rm -rf $toolsFolder
    #rm -rf $ndkFolder
    cd $wkdir
    if [ ! -f $toolsFile ]; then
        echo "Downloading SDK tools from $repository"
        wget -q $repository/$toolsFile

    fi
    echo "unzip sdk"
    unzip -o $toolsFile -d $toolsFolder
    ln -sf $toolsFolder sdk
    if [ ! -f $ndkFile ]; then
        echo "Downloading NDK from $repository"
        wget -q $repository/$ndkFile
    fi
    echo "unzip ndk"
    unzip -o $ndkFile -d $wkdir
    ln -sf $ndkFile ndk
    #rm $toolsFile
    #rm $ndkFile

    echo "Configuring environment"
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
    export PATH=$PATH:$JAVA_HOME/bin

    # Optional workaround for issue with certain JDK/JRE versions
    #cp $toolsFolder/tools/bin/sdkmanager $toolsFolder/tools/bin/sdkmanager.backup
    #sed -i 's/^DEFAULT_JVM_OPTS.*/DEFAULT_JVM_OPTS='"'\"-Dcom.android.sdklib.toolsdir=\$APP_HOME\" -XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'"'/' \
    #        $toolsFolder/tools/bin/sdkmanager

    echo "Installing SDK packages"
    cd $toolsFolder/tools/bin
    cmd="./sdkmanager platforms;$sdkApiLevel platform-tools build-tools;$sdkBuildToolsVersion"
    echo $cmd
    echo "y" |  $cmd
    cmd="./sdkmanager --install emulator"
    echo $cmd
    img="system-images;android-21;google_apis;x86"
    echo "y" |  $cmd
    cmd="./sdkmanager --install '$img'"
    echo $cmd
    echo "----------------------------"
    echo "y" |  eval "$cmd"

    cmd="./avdmanager create avd -n x86emulator -k '$img' -c 2048M -f"
    echo $cmd
    echo 'no'  | eval "$cmd"
    #cmd="./avdmanager create avd -n x86emulator -k 'system-images;android-21;google_apis;x86' -c 2048M -f"
    #$cmd
    #echo "no" | $cmd
    #echo $cmd

    #echo "Provisioniong complete. Here's the list of packages and avd devices:"
    #./sdkmanager --list
    #./avdmanager list avd
}
qt5_build() {
    #reset bash
    echo "start build qt5"
    #bash
    [[ ! -d $GIT ]] && mkdir $GIT
    if [ ! -d $GIT/qt5 ]; then
        cd $GIT
        git clone git://code.qt.io/qt/qt5.git qt5
    fi
    cd $GIT/qt5
    git pull
    exit
    sudo apt-get install openjdk-8-jdk  libc6-i386 build-essential android-sdk android-sdk-platform-23 -y
    perl init-repository
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
    export PATH=$PATH:$JAVA_HOME/bin
    #CONFIGURE="./configure -xplatform android-clang --disable-rpath -nomake tests -nomake examples -android-ndk $ndkFolder -android-sdk $toolsFolder -android-ndk-host linux-x86_64 -skip qttranslations -skip qtserialport -no-warnings-are-errors --prefix=$wkdir/qt5/armv7"
    CONFIGURE="./configure -xplatform android-clang --disable-rpath -nomake tests -nomake examples -android-ndk $wkdir/ndk -android-sdk $wkdir/sdk -android-ndk-host linux-x86_64 -skip qttranslations -skip qtserialport -no-warnings-are-errors --prefix=$wkdir/qt5/$arch"
    $CONFIGURE
    echo $CONFIGURE
    make -j `nproc`
    make install
}


qt5_prebuild
qt5_build
#wget https://liquidtelecom.dl.sourceforge.net/project/avbuild/android/ffmpeg-4.2-android-clang.tar.xz



