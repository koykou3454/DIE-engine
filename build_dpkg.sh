#!/bin/bash -x

// https://askubuntu.com/questions/1345/what-is-the-simplest-debian-packaging-guide
RELEASE_VERSION=$(cat "release_version.txt")
ARCHITECTURE=$(uname -m)
REVISION=$(date "+%Y%m%d")
echo $RELEASE_VERSION
SOURCE_PATH=$PWD

if [[ $ARCHITECTURE == *"x86_64"* ]]; then
    ARCHITECTURE="amd64"
fi

BUILD_NAME=die_${RELEASE_VERSION}_${ARCHITECTURE}-${REVISION}

cd $SOURCE_PATH

function makeproject
{
    cd $SOURCE_PATH/$1
    
    qmake $1.pro -spec linux-g++
    make -f Makefile clean
    make -f Makefile

    rm -rf Makefile
    rm -rf Makefile.Release
    rm -rf Makefile.Debug
    rm -rf object_script.*     

    cd $SOURCE_PATH
}

rm -rf $SOURCE_PATH/build

makeproject build_libs
makeproject gui_source
makeproject console_source

cd $SOURCE_PATH/gui_source
lupdate gui_source_tr.pro
cd $SOURCE_PATH

mkdir -p $SOURCE_PATH/release
rm -rf $SOURCE_PATH/release/$BUILD_NAME
mkdir -p $SOURCE_PATH/release/$BUILD_NAME
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/DEBIAN
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr/bin
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr/lib
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/signatures

cp -R $SOURCE_PATH/build/release/die                     		$SOURCE_PATH/release/$BUILD_NAME/usr/bin/
cp -R $SOURCE_PATH/build/release/diec                     		$SOURCE_PATH/release/$BUILD_NAME/usr/bin/

cp -R $SOURCE_PATH/DEBIAN/control                     		    $SOURCE_PATH/release/$BUILD_NAME/DEBIAN/
cp -Rf $SOURCE_PATH/XStyles/qss/ $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/
cp -Rf $SOURCE_PATH/Detect-It-Easy/info/ $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/
cp -Rf $SOURCE_PATH/Detect-It-Easy/db/ $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/

$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/die_de.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang/die_de.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/die_ja.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang/die_ja.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/die_pl.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang/die_pl.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/die_pt_BR.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang/die_pt_BR.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/die_fr.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang/die_fr.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/die_ru.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang/die_ru.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/die_vi.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang/die_vi.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/die_zh.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang/die_zh.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/die_zh_TW.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang/die_zh_TW.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/die_es.ts -qm $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang/die_es.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/die_it.ts -qm $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang/die_it.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/die_ko.ts -qm $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang/die_ko.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/die_tr.ts -qm $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang/die_tr.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/die_he.ts -qm $SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/lang/die_he.qm

cp -R $SOURCE_PATH/signatures/crypto.db                     		$SOURCE_PATH/release/$BUILD_NAME/usr/lib/die/signatures/

chown root:root -R $SOURCE_PATH/release/$BUILD_NAME
chmod 0755 $SOURCE_PATH/release/$BUILD_NAME/usr/bin/die
chmod 0755 $SOURCE_PATH/release/$BUILD_NAME/usr/bin/diec

dpkg -b $SOURCE_PATH/release/$BUILD_NAME

rm -rf release/$BUILD_NAME
