#/bin/bash

# configuration

BITWIG_STUDIO='/Applications/Bitwig Studio.app'
BITWIG_JAR="${BITWIG_STUDIO}/Contents/Java/bitwig.jar"
MGEN_PLUS_ZIP='mgenplus-2p-20150602.zip'
MGEN_PLUS_ZIP_URL="https://ja.osdn.net/downloads/users/8/8595/mgenplus-2p-20150602.zip"
MGEN_PLUS_ZIP_SHA256='33cbb75eec8569d27a0e1a5c4f2a5f7737d20060c7565eb96e2641a8636a097c'
OPENSSL=`which openssl`
DIST_ZIP=bitwig-japanese-fonts.zip

# clean all
if [ "${1}x" = "cleanx" ]; then
    rm -rf dist
    rm -rf fonts
    rm -rf jp
    rm -f *.zip
    rm -f *~
    exit 0
fi

# clean all
if [ "${1}x" = "uninstallx" ]; then
    rm "${BITWIG_STUDIO}/Contents/PlugIns/JavaVM.plugin/Contents/Home/lib/ext/${DIST_ZIP}"
    exit 0
fi

# cleanup
if [ -e fonts ]; then
    rm -rf fonts
fi
if [ -e dist ]; then
    rm -rf dist
fi
if [ -e jp ]; then
    rm -rf jp
fi
rm ${DIST_ZIP}

unzip "${BITWIG_JAR}" fonts/SourceSansPro-*.ttf

# download mgen+ font
# http://jikasei.me/font/mgenplus/
if [ ! -e ${MGEN_PLUS_ZIP} ]; then
    curl -L -O ${MGEN_PLUS_ZIP_URL}
fi

# validate download file
if [ ! "${OPENSSL}x" = "x" ]; then
    sha256=`${OPENSSL} sha256 ${MGEN_PLUS_ZIP}`
    if [ ! "SHA256(${MGEN_PLUS_ZIP})= ${MGEN_PLUS_ZIP_SHA256}" = "${sha256}" ]; then
        echo "warning: file:${MGEN_PLUS_ZIP} checksum validation failed."
    fi
fi

mkdir -p jp
cd jp
unzip ../${MGEN_PLUS_ZIP} mgenplus-2cp-*.ttf
cd -

# merge jp font into original font.
mkdir -p dist/fonts
python merge-font.py fonts/SourceSansPro-Black.ttf      jp/mgenplus-2cp-black.ttf   dist/fonts/SourceSansPro-Black.ttf
python merge-font.py fonts/SourceSansPro-Bold.ttf       jp/mgenplus-2cp-bold.ttf    dist/fonts/SourceSansPro-Bold.ttf
python merge-font.py fonts/SourceSansPro-Semibold.ttf   jp/mgenplus-2cp-medium.ttf  dist/fonts/SourceSansPro-Semibold.ttf
python merge-font.py fonts/SourceSansPro-Regular.ttf    jp/mgenplus-2cp-regular.ttf dist/fonts/SourceSansPro-Regular.ttf
python merge-font.py fonts/SourceSansPro-Light.ttf      jp/mgenplus-2cp-light.ttf   dist/fonts/SourceSansPro-Light.ttf
python merge-font.py fonts/SourceSansPro-ExtraLight.ttf jp/mgenplus-2cp-thin.ttf    dist/fonts/SourceSansPro-ExtraLight.ttf

# create zip archive
cd dist
zip -r ../${DIST_ZIP} .
cd -

# install font
cp ${DIST_ZIP} "${BITWIG_STUDIO}/Contents/PlugIns/JavaVM.plugin/Contents/Home/lib/ext"
