#! /bin/bash


src=ffmpeg-android/lib/armv7
dst=/opt/qt5/android-armv7/lib
for mfile in $src/*.so; do
    echo $mfile
    if [ ! -f "$dst/${mfile##*/}" ]; then
        echo "not found"
        sudo cp $mfile $dst
    fi
done

