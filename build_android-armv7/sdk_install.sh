mkdir -p /opt/jbuild/qt5/armv7/include/QtAV/
cp -f /home/eli/android/QtAV/build_android-armv7/lib_android_arm_llvm/*Qt*AV*.so* /opt/jbuild/qt5/armv7/lib/
cp -f /home/eli/android/QtAV/build_android-armv7/lib_android_arm_llvm/libQtAV.so /opt/jbuild/qt5/armv7/lib/libQt5AV.so
cp -f /home/eli/android/QtAV/build_android-armv7/lib_android_arm_llvm/libQtAV.so /opt/jbuild/qt5/armv7/lib/libQt5AV.so
cp -f /home/eli/android/QtAV/build_android-armv7/tools/install_sdk/mkspecs/features/av.prf /opt/jbuild/qt5/armv7/mkspecs/features/av.prf
cp -f /home/eli/android/QtAV/build_android-armv7/tools/install_sdk/mkspecs/modules/qt_lib_av*.pri /opt/jbuild/qt5/armv7/mkspecs/modules/
mkdir -p /opt/jbuild/qt5/armv7/include/QtAVWidgets/
cp -f /home/eli/android/QtAV/build_android-armv7/lib_android_arm_llvm/*Qt*AV*.so* /opt/jbuild/qt5/armv7/lib/
cp -f /home/eli/android/QtAV/build_android-armv7/lib_android_arm_llvm/libQtAVWidgets.so /opt/jbuild/qt5/armv7/lib/libQt5AVWidgets.so
cp -f /home/eli/android/QtAV/build_android-armv7/lib_android_arm_llvm/libQtAVWidgets.so /opt/jbuild/qt5/armv7/lib/libQt5AVWidgets.so
cp -f /home/eli/android/QtAV/build_android-armv7/tools/install_sdk/mkspecs/features/avwidgets.prf /opt/jbuild/qt5/armv7/mkspecs/features/avwidgets.prf
cp -f /home/eli/android/QtAV/build_android-armv7/tools/install_sdk/mkspecs/modules/qt_lib_avwidgets*.pri /opt/jbuild/qt5/armv7/mkspecs/modules/
cp -f /home/eli/android/QtAV/tools/install_sdk/../../src/QtAV/*.h /opt/jbuild/qt5/armv7/include/QtAV/
cp -f /home/eli/android/QtAV/tools/install_sdk/../../src/QtAV/QtAV /opt/jbuild/qt5/armv7/include/QtAV/
cp -f /home/eli/android/QtAV/tools/install_sdk/../../widgets/QtAVWidgets/*.h /opt/jbuild/qt5/armv7/include/QtAVWidgets/
cp -f /home/eli/android/QtAV/tools/install_sdk/../../widgets/QtAVWidgets/QtAVWidgets /opt/jbuild/qt5/armv7/include/QtAVWidgets/
mkdir -p /opt/jbuild/qt5/armv7/include/QtAV/5.12.5/QtAV/
cp -f -R /home/eli/android/QtAV/tools/install_sdk/../../src/QtAV/private /opt/jbuild/qt5/armv7/include/QtAV
cp -f -R /home/eli/android/QtAV/tools/install_sdk/../../src/QtAV/private /opt/jbuild/qt5/armv7/include/QtAV/5.12.5/QtAV
cp -f -R /home/eli/android/QtAV/build_android-armv7/bin/QtAV /opt/jbuild/qt5/armv7/qml
cp -f /home/eli/android/QtAV/tools/install_sdk/../../qml/plugins.qmltypes /opt/jbuild/qt5/armv7/qml/QtAV/
