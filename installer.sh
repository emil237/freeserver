#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL FreeServer
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/emil237/freeserver/main/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
TEMPATH=/tmp
OPKGINSTALL="opkg install --force-overwrite"
MY_IPK="enigma2-plugin-extensions-freeserver_8.2.9_all.ipk"
MY_DEB="enigma2-plugin-extensions-freeserver_8.2.9_all.deb"
MY_URL="https://raw.githubusercontent.com/emil237/freeserver/main"
if [ -f /etc/apt/apt.conf ] ; then
    STATUS='/var/lib/dpkg/status'
    OS='DreamOS'
elif [ -f /etc/opkg/opkg.conf ] ; then
   STATUS='/var/lib/opkg/status'
   OS='Opensource'
fi

# remove old version #
opkg remove enigma2-plugin-extensions-freeserver
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/FreeServer

echo ""
# Download and install plugin
cd /tmp
set -e
 if which dpkg > /dev/null 2>&1; then
  wget "$MY_URL/$MY_DEB"
		dpkg -i --force-overwrite $MY_DEB; apt-get install -f -y
wait
rm -f $MY_DEB
	else
  wget "$MY_URL/$MY_IPK"
		$OPKGINSTALL $MY_IPK
wait
rm -f $MY_IPK
	fi
echo "================================="
set +e
cd ..
wait
	if [ $? -eq 0 ]; then
echo ">>>>  SUCCESSFULLY INSTALLED <<<<"
fi
		echo "********************************************************************************"
echo "   UPLOADED BY  >>>>   EMIL_NABIL "   
sleep 4;
echo "#########################################################"
sleep 2
exit 0
