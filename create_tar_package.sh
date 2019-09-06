#! /bin/bash
mdirs="$HOME/android/pkgs/qt5/ $HOME/android/QtAV/build_android-armv7"
for mdir in $mdirs; do 
	echo $mdir
	if [ -d $mdir ]; then
		echo "removing $mdir"
		rm $mdir -Rf
	fi
done
now=$(date +"%Y_%m_%d")
tar czvf $HOME/android_$now.tar.gz -C $HOME android
