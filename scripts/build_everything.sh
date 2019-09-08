QTAV=$HOME/android/QtAV
is_sudoer=`sudo -nv 2>&1`
is_sudoer=${is_sudoer%%,*}
if [[ `sudo -nv 2>&1` =~ "password" ]]; then
    pkgs='git build-essential default-jre openjdk-8-jdk-headless android-sdk android-sdk-platform-23 libc6-i386 openjdk-8-jdk libc6-i386'
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

$QTAV/scripts/build_everything_actual.sh
