#!/bin/bash

cd ubuntu-kernel

#VFIO patches
echo Applying patches
patch -p1 < ../patches/vfio/0001-i915-Add-module-option-to-support-VGA-arbiter-on-HD-.patch
patch -p1 < ../patches/vfio/0001-pci-Enable-overrides-for-missing-ACS-capabilities-4..patch

#Configs
echo Copying configs
cp -r -f -v config/** ubuntu-kernel/debian.master/config/

#Version
cd debian.master
cp changelog ../changelog.original
(sed 0,/\)/{s/\)/+enas-1.0\)/} changelog ) > changelog.temp
cp changelog.temp changelog
rm changelog.temp
cd ../

#Build
echo Building
fakeroot make olddefconfig
fakeroot debian/rules clean
fakeroot debian/rules binary-headers binary-generic binary-perarch skipabis=true

#Reset Version
cd debian.master
rm changelog
cp ../changelog.original changelog 
cd ../
rm changelog.original

echo Done!