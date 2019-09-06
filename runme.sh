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
            read answer
            if [ "$answer" != "${answer#[Yy]}" ] ;then
                sudo apt-get uninstall $mpkg
            fi
        fi
    done
fi
if [ ! -f "$HOME/.local/qt5/armv7/bin/qmake" ]; then
	INSTALL_QT5="y"
else
	echo "Do you want to reinstall qt5 for android?"
	read answer 
	[[ "$answer" != "${answer#[Yy]}" ]] && INSTALL_QT5="y"
fi
[[ "$INSTALL_QT5" == "y" ]] && $QTAV/build_qt5_android.sh
$QTAV/housekeeping.sh
find $QTAV -name Makefile -print0|xargs -0 rm
rm -rf $QTAV/build_android-armv7
echo "press enter to start building QMLPlayer"
read answer
cd $QTAV
$QTAV/build_android-armv7.sh
