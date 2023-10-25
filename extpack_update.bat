#!/bin/bash
##--
##
## a bash script to help me automate the update of the extension pack used with my virtualbox vm's
##
##--
declare -a EXTPACKSARRAY

clear

echo "Attempting to update virtualbox extpack:"
echo ""

##test for correct user
USER=$(whoami)
USER="root"
if [ "$USER" != "root"  ]
then
	echo "FATAL: root user required"
	exit
fi


##test for vboxmanage command
if ! command -v vboxmanage &> /dev/null
then
	echo "FATAL: could  not find vboxmanage"
	exit
fi

##get version information
VERSIONLONG=$(vboxmanage -v)
VERSIONSHORT=${VERSIONLONG%r*}
EXTPACKS=$(vboxmanage list extpacks)
EXTPACKSARRAY=(${EXTPACKS[@]})
TESTVALUE1=${EXTPACKSARRAY[11]}
TESTVALUE2=${EXTPACKSARRAY[12]}
#TESTVALUE2="6.1.13"

##echo vars
echo "user:			$USER"
echo "vbox version:		$VERSIONLONG"
#echo "vbox version, short:	$VERSIONSHORT"
#echo "target value 1:		$TESTVALUE1"
echo "extpack installed:	$TESTVALUE2"
echo ""

##test for installed extpacks version
if [ $TESTVALUE1 != "Version:" ]
then
	echo "FATAL: installed version info not found"
	exit
fi
if [ $TESTVALUE2 = $VERSIONSHORT ] || [[ $TESTVALUE2 > $VERSIONSHORT ]]
then
	echo "FATAL: $TESTVALUE2 ( >=$VERSIONSHORT ) already installed"
	exit
fi

##switch to the root vm folder for download of the extension pack
cd /mnt/rootvmfolder/

echo "downloading extpack"
wget https://download.virtualbox.org/virtualbox/$VERSIONSHORT/Oracle_VM_VirtualBox_Extension_Pack-$VERSIONSHORT.vbox-extpack

echo ""
echo "installing extpack"
vboxmanage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-$VERSIONSHORT.vbox-extpack

echo ""
echo "Extpack update complete."

