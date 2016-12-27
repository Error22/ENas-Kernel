cd ubuntu-kernel

#VFIO patches
patch -p1 < ../patches/vfio/0001-i915-Add-module-option-to-support-VGA-arbiter-on-HD-.patch
patch -p1 < ../patches/vfio/0001-pci-Enable-overrides-for-missing-ACS-capabilities-4..patch

#Build
fakeroot debian/rules clean
fakeroot debian/rules binary-headers binary-generic binary-perarch