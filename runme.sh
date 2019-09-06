QTAV=$HOME/android/QtAV
if [ ! -f "$HOME/.local/qt5/armv7/bin/qmake" ]; then
	INSTALL_QT5="y"
else
	echo "Do you want to reinstall qt5 for android?"
	read answer 
	[[ "$answer" != "${answer#[Yy]}" ]] && INSTALL_QT5="y"
fi
[[ "$INSTALL_QT5" == "y" ]] && $QTAV/build_qt5_android.sh
$QTAV/housekeeping.sh
