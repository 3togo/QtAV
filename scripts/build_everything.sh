QTAV=$HOME/android/QtAV
is_sudoer=`sudo -nv 2>&1`
is_sudoer=${is_sudoer%%,*}
if [[ `sudo -nv 2>&1` =~ "password" ]]; then
    pkgs='build-essential default-jre openjdk-8-jdk-headless android-sdk android-sdk-platform-23 libc6-i386 openjdk-8-jdk libc6-i386'
    if ! dpkg -s $pkgs >/dev/null 2>&1; then
        sudo apt-get install $pkgs
    fi
    pkgs='openjdk-12-jdk openjdk-12-jre'
    for mpkg in $pkgs; do
        if dpkg -s $mpkg >/dev/null 2>&1; then
            echo "uninstall $mpkg because it might casue compilation error!(y/n)"
            read -t 5 answer
            answer=${answer:-y}
            if [ "$answer" != "${answer#[Yy]}" ] ;then
                sudo apt-get uninstall $mpkg
            fi
        fi
    done
fi
echo "update QtAV"
cd $QTAV
git config user.email nobody@nowhere.com
git config user.name nobody
git stash
git clean -f
git pull


if [ ! -f "$HOME/.local/qt5/armv7/bin/qmake" ]; then
    INSTALL_QT5="y"
else
    echo "Do you want to reinstall qt5 for android?"
    read -t 5 answer
    answer=${answer:-n}
    [[ "$answer" != "${answer#[Yy]}" ]] && INSTALL_QT5="y"
fi
[[ "$INSTALL_QT5" == "y" ]] && $QTAV/scripts/build_qt5_android.sh
$QTAV/scripts/housekeeping.sh
makes=`find $QTAV -name Makefile -print`
if [ ! -z "$makes" ];then
    echo "makefiles=$makes"
    echo $makes|xargs -0 rm
fi
exit
if [ -d $QTAV/build_android-armv7 ];then
    rm -rf $QTAV/build_android-armv7
fi
echo "press enter to start building QMLPlayer"
read -t 5 answer
answer=${answer:-y}
if [ "$answer" != "${answer#[Yy]}" ] ;then
    cd $QTAV
    $QTAV/scripts/build_android-armv7.sh
fi
