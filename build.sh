#!/bin/bash

cd ubuntu-kernel

#VFIO patches
echo Applying patches
patch -p1 < ../patches/vfio/0001-i915-Add-module-option-to-support-VGA-arbiter-on-HD-.patch
patch -p1 < ../patches/vfio/0001-pci-Enable-overrides-for-missing-ACS-capabilities-4..patch

#Configs
echo Copying configs
cp -r -f -v config/** ubuntu-kernel/debian.master/config/

#Build
echo Building
fakeroot debian/rules clean
fakeroot make-kpkg -j N --initrd --append-to-version=enas-1.0 kernel-image kernel-headers
#fakeroot debian/rules binary-headers binary-generic binary-perarch

echo Done!