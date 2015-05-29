#!/bin/bash +x

# aik_tools is the Android Image Kitchen working directory.  Used for boot.img creation
# from the compiled zImage and a ramdisk folder

# AIK scripting by osm0sis@xda-developers
# This build script by g.lewarne (xda)
clear
echo
echo


echo -n "Checking for defconfig............................."
if [ -f "arch/arm64/configs/Vindicator_defconfig" ]; then
	echo "Found"
else
	echo "Not found!"
	echo -n "Creating new default defconfig...................."
	cp arch/arm64/configs/exynos7420-zeroflte_defconfig arch/arm64/configs/Vindicator_defconfig
	echo "Done"
fi

echo

# Cleanup old files from build environment
echo -n "Cleanup build environment.........................."
rm -rf ../aik_tools/*.img
rm -rf ../aik_tools/*.gz
rm -rf ../aik_tools/split_img/boot.img-zImage
rm -rf ../aik_tools/ramdisk
rm -rf ../VindicatorS6_Out/*.img
rm -rf ../VindicatorS6_Out/*.zip
rm -rf ../VindicatorS6_Out/*.tar
rm -rf arch/arm64/boot/Image
echo "Done"

echo -n "Prepare build environment.........................."
# Copy our ramdisk to the aik_tools working directory
cp -R ramdisk/ ../aik_tools/ramdisk

# Set build environment variables
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=Xile
export KBUILD_BUILD_HOST=Xile
export ccache=ccache
export USE_SEC_FIPS_MODE=true
export KCONFIG_NOTIMESTAMP=true
echo "Done"

echo

echo -n "Creating default .config............................."
make ARCH=arm64 Vindicator_defconfig
cp .config arch/arm64/configs/Vindicator_defconfig
echo "Done"

echo


# Compile the kernel
echo -n "Compiling Kernel..................................."
make ARCH=arm64 -j5
if [ -f "arch/arm64/boot/Image" ]; then
	echo "Done"
else
	clear
	echo
	echo "Compilation failed!"
	echo
	while true; do
    		read -p "Do you want to run a Make command to check the error?  (y/n) > " yn
    		case $yn in
        		[Yy]* ) make; echo ; exit;;
        		[Nn]* ) echo; exit;;
        	 	* ) echo "Please answer yes or no.";;
    		esac
	done
fi

echo -n "Copy compiled zImage to AIK-Tools.................."
# Copy zImage and Modules to working ramdisk directory in AIK Image tools
cp arch/arm64/boot/Image ../aik_tools/split_img/boot.img-zImage
echo "Done"

echo

# Run the AIK-tools boot.img creation script with our new zImage
echo -n "Running AIK-Tools to create boot.img..............."
cd ../aik_tools
./repackimg.sh
echo "Done"


# Copy the new boot.img to the output directory
cp image-new.img ../VindicatorS6_Out/boot.img

# Create the flashable .zip of the new kernel boot.img
echo -n "Create flashable .zip.............................."
cd ../VindicatorS6_Out
zip -r Vindicator.R.x.zip *
echo "Done"

echo

# Return to the kernel source directory
cd ../VindicatorS6

echo "Build completed"
echo
#build script ends
