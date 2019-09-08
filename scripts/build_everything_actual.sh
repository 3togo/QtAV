QTAV=$HOME/android/QtAV

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
    echo $makes|xargs rm
fi

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
