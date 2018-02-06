#/bin/bash -e

PWD=`dirname $0`

# configuration
mac=false;
linux=false;
wsl=false;
cygwin=false;
case "`uname`" in
  Linux*) linux=true;;
  Darwin*) mac=true;;
  CYGWIN*) cygwin=true;;
esac
if $linux ; then
  if grep -q Microsoft /proc/version; then
      wsl=true
      linux=false
  fi
fi

if $mac ; then
    BITWIG_STUDIO='/Applications/Bitwig Studio.app'
    BITWIG_JAR="${BITWIG_STUDIO}/Contents/Java/bitwig.jar"
    BITWIG_LIB_EXT="${BITWIG_STUDIO}/Contents/PlugIns/JavaVM.plugin/Contents/Home/lib/ext"
    PYTHON=/usr/bin/python
fi

if $cygwin ; then
    BITWIG_STUDIO='/cygdrive/c/Program Files/Bitwig Studio'
    BITWIG_JAR="${BITWIG_STUDIO}/bin/bitwig.jar"
    BITWIG_LIB_EXT="${BITWIG_STUDIO}/jre/lib/ext"
    PYTHON=/usr/bin/python2
fi

if $wsl ; then
    BITWIG_STUDIO='/mnt/c/Program Files/Bitwig Studio'
    BITWIG_JAR="${BITWIG_STUDIO}/bin/bitwig.jar"
    BITWIG_LIB_EXT="${BITWIG_STUDIO}/jre/lib/ext"
    PYTHON=/usr/bin/python2
fi

if $linux ; then
    BITWIG_STUDIO='/opt/Bitwig Studio'
    BITWIG_JAR="${BITWIG_STUDIO}/bin/bitwig.jar"
    BITWIG_LIB_EXT="${BITWIG_STUDIO}/lib/jre/lib/ext"
    PYTHON=/usr/bin/python2
fi

WORK_DIR=/tmp/bitwig-studio-japanese-font
MGEN_PLUS_ZIP='mgenplus-2p-20150602.zip'
MGEN_PLUS_ZIP_URL="https://ja.osdn.net/downloads/users/8/8595/mgenplus-2p-20150602.zip"
MGEN_PLUS_ZIP_SHA256='33cbb75eec8569d27a0e1a5c4f2a5f7737d20060c7565eb96e2641a8636a097c'
OPENSSL=`which openssl`
DIST_ZIP=bitwig-japanese-fonts.zip


merge_fonts () {
    fontforge -c '
import fontforge
font = fontforge.open("'"${1}"'")
font.mergeFonts("'"${2}"'")
font.generate("'"${3}"'")
'
}

# uninstall
if [ "${1}x" = "uninstallx" ]; then
    if $wsl ; then
        rm "${BITWIG_LIB_EXT}/${DIST_ZIP}"
    elif $cygwin ; then
        cygstart --action=runas rm ${DIST_ZIP} \"${BITWIG_LIB_EXT}/${DIST_ZIP}\"
    elif $linux ; then
        sudo rm "${BITWIG_LIB_EXT}/${DIST_ZIP}"
    elif $mac ; then
        rm "${BITWIG_LIB_EXT}/${DIST_ZIP}"
    fi
    exit 0
fi

# work folder
if [ -d "#{WORK_DIR}" ]; then
    rm -rf "#{WORK_DIR}"
fi
mkdir -p "${WORK_DIR}"
cd "${WORK_DIR}"

# extract original font files
unzip "${BITWIG_JAR}" fonts/SourceSansPro-*.ttf

# download mgen+ font
# http://jikasei.me/font/mgenplus/
if [ ! -e ${MGEN_PLUS_ZIP} ]; then
    curl -L -O ${MGEN_PLUS_ZIP_URL}
fi
# validate download file
if [ ! -z "${OPENSSL}" ]; then
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
merge_fonts fonts/SourceSansPro-Black.ttf      jp/mgenplus-2cp-black.ttf   dist/fonts/SourceSansPro-Black.ttf
merge_fonts fonts/SourceSansPro-Bold.ttf       jp/mgenplus-2cp-bold.ttf    dist/fonts/SourceSansPro-Bold.ttf
merge_fonts fonts/SourceSansPro-Semibold.ttf   jp/mgenplus-2cp-medium.ttf  dist/fonts/SourceSansPro-Semibold.ttf
merge_fonts fonts/SourceSansPro-Regular.ttf    jp/mgenplus-2cp-regular.ttf dist/fonts/SourceSansPro-Regular.ttf
merge_fonts fonts/SourceSansPro-Light.ttf      jp/mgenplus-2cp-light.ttf   dist/fonts/SourceSansPro-Light.ttf
merge_fonts fonts/SourceSansPro-ExtraLight.ttf jp/mgenplus-2cp-thin.ttf    dist/fonts/SourceSansPro-ExtraLight.ttf

# create zip archive
cd dist
zip -r ../${DIST_ZIP} .
cd -

# install font
if $wsl ; then
    cp ${DIST_ZIP} "${BITWIG_LIB_EXT}"
elif $cygwin ; then
    cygstart --action=runas cp ${DIST_ZIP} \"${BITWIG_LIB_EXT}\"
elif $linux ; then
    sudo cp ${DIST_ZIP} "${BITWIG_LIB_EXT}"
elif $mac ; then
    cp ${DIST_ZIP} "${BITWIG_LIB_EXT}"
fi

# exit work folder
cd -

# cleanup
rm -rf "${WORK_DIR}"
