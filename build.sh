#!/bin/bash

#---- Settings ----
#Version
if [ -n "$BUILD_NUMBER" ]; then
	buildversion=b$BUILD_NUMBER
elif [ -n "$BUILD_NAME" ]; then
	buildversion=$BUILD_NAME
else
	echo No build number or name, custom build
	buildversion=custom
fi

majorversion=1
minorversion=0
version=enas-$majorversion.$minorversion-$buildversion

#Core count
if [ -n "$CORE_COUNT" ]; then
	corecount=$CORE_COUNT
else
	corecount=$(grep -c ^processor /proc/cpuinfo)
	((corecount-=1))
fi

echo ENAS Kernel Builder \(Version: $version Cores: $corecount\) 

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
fakeroot make -j$corecount olddefconfig bindeb-pkg LOCALVERSION=-$version

echo Done!
