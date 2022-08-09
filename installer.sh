#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL freeserver
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/emil237/freeserver/main/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
VERSION="8.0.4"
TMPDIR='/tmp'
PACKAGE='enigma2-plugin-extensions-freeserver'
MY_URL='https://raw.githubusercontent.com/emil237/freeserver/main'
PYTHON_VERSION=$(python -c"import sys; print(sys.version_info.major)")

#########################
if [ -f /etc/opkg/opkg.conf ]; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
    OPKGLIST='opkg list-installed'
    OPKGREMOV='opkg remove --force-depends'
elif [ -f /etc/apt/apt.conf ]; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
    OPKGLIST='apt-get list-installed'
    OPKGREMOV='apt-get purge --auto-remove'
    DPKINSTALL='dpkg -i --force-overwrite'
fi

#########################

rm -rf $TMPDIR/"${PACKAGE:?}"* >/dev/null 2>&1

#########################
if [ "$CHECK_VERSION" = "$VERSION" ]; then
    echo " You are use the laste Version: $VERSION"
    exit 1
elif [ -z "$CHECK_VERSION" ]; then
    echo
    clear
else
    $OPKGREMOV $PACKAGE
fi

########################
install() {
    if grep -qs "Package: $1" $STATUS; then
        echo
    else
        $OPKG >/dev/null 2>&1
        echo "   >>>>   Need to install $1   <<<<"
        echo
        $OPKGINSTAL "$1"
        sleep 1
        clear
    fi
}

########################
if [ "$PYTHON_VERSION" -eq 3 ]; then
    for i in python3-codecs python3-core python3-json python3-netclient; do
        install $i
    done
else
    for i in python-codecs python-core python-json python-netclient; do
        install $i
    done
    if [ $OSTYPE = "DreamOS" ]; then
        for d in gstreamer1.0-plugins-base-meta gstreamer1.0-plugins-good-spectrum; do
            install $d
        done
    fi
fi

########################
echo "Insallling freeserver plugin Please Wait ......"
if [ $OSTYPE = "Opensource" ]; then
    wget $MY_URL/${PACKAGE}_{VERSION}"_all.ipk -qP $TMPDIR
    $OPKGINSTAL $TMPDIR/${PACKAGE}_{VERSION}"_all.ipk
else
    wget $MY_URL/${PACKAGE}_{VERSION}"_all.deb -qP $TMPDIR
    $DPKINSTALL $TMPDIR/${PACKAGE}_{VERSION}"_all.deb
    $OPKGINSTAL -f -y
fi

########################
rm -rf $TMPDIR/"${PACKAGE:?}"*

echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       freeserver    : $VERSION                            *"
echo "**                       Uploaded by: Emil_Nabil                     *"                                                            
echo "***********************************************************************"
echo ""

if [ $OSTYPE = "Opensource" ]; then
    killall -9 enigma2
else
    systemctl restart enigma2
fi

exit 0
