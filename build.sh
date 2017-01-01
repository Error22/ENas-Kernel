#!/bin/bash

#---- Settings ----
#Version
if [ -z ${BUILD_NUMBER+x} ]; then
	echo Build number found!
	version=-enas-1.$BUILD_NUMBER
else
	echo No build number, custom build
	version=-enas-1-custom
fi

#Core count
if [ -z ${CORE_COUNT+x} ]; then
	echo Core count found
	corecount=$CORE_COUNT
else
	echo Looking up core count
	corecount=$(grep -c ^processor /proc/cpuinfo)
fi

#---- Body ----
cd ubuntu-kernel

#VFIO patches
echo Applying patches
patch -p1 < ../patches/vfio/0001-i915-Add-module-option-to-support-VGA-arbiter-on-HD-.patch
patch -p1 < ../patches/vfio/0001-pci-Enable-overrides-for-missing-ACS-capabilities-4..patch

#Configs
echo Copying configs
cp -r -f -v config/** ubuntu-kernel/debian.master/config/

#Build
echo Build
fakeroot debian/rules clean
fakeroot make -j$corecount olddefconfig bindeb-pkg LOCALVERSION=$version

echo Done!