#!/bin/bash
# kernel build script by thehacker911

KERNEL_DIR=$(pwd)
BUILD_USER="$USER"
BUILD_JOB_NUMBER=`grep processor /proc/cpuinfo|wc -l`
BUILD_CROSS_COMPILE=$TOOLCHAIN_DIR/$TOOLCHAIN


#vars
TOOLCHAIN_DIR=/home/$BUILD_USER/android/toolchains
TOOLCHAIN=/arm-eabi-4.8/bin/arm-eabi-
KERNEL_DEFCONFIG=markus_defconfig
KERNEL_VER="test_kernel"


BUILD_KERNEL()
{	
	echo ""
	echo "=============================================="
	echo "START: MAKE CLEAN"
	echo "=============================================="
	echo ""
	

	make clean
	find . -name "*.dtb" -exec rm {} \;

	echo ""
	echo "=============================================="
	echo "END: MAKE CLEAN"
	echo "=============================================="
	echo ""

	echo ""
	echo "=============================================="
	echo "START: BUILD_KERNEL"
	echo "=============================================="
	echo ""
	echo "$KERNEL_VER" 
	
	export LOCALVERSION=-`echo $KERNEL_VER`
	export ARCH=arm
	export KBUILD_BUILD_USER=thehacker911
	export KBUILD_BUILD_HOST=smartlounge.eu
	export CROSS_COMPILE=$BUILD_CROSS_COMPILE
	make VARIANT_DEFCONFIG=apq8084_sec_trlte_eur_defconfig apq8084_sec_defconfig $KERNEL_DEFCONFIG  SELINUX_DEFCONFIG=selinux_defconfig SELINUX_LOG_DEFCONFIG=selinux_log_defconfig TIMA_DEFCONFIG=tima_defconfig DMVERITY_DEFCONFIG=dmverity_defconfig
	make -j$BUILD_JOB_NUMBER
	
	echo ""
	echo "================================="
	echo "END: BUILD_KERNEL"
	echo "================================="
	echo ""

	if [ -e $KERNEL_DIR/arch/arm/boot/zImage ]; then
	      
	      echo ""
	      echo "================================="
	      echo "END: KERNEL BUILD FINISH"
	      echo "================================="
	      echo ""
	      
	else
	
	      echo ""
	      echo "================================="
	      echo "END: FAIL KERNEL BUILD!"
	      echo "================================="
	      echo ""
	      exit 0;
	fi;
	
}




# MAIN FUNCTION
rm -rf ./build.log
(
	START_TIME=`date +%s`
	BUILD_DATE=`date +%m-%d-%Y`
	BUILD_KERNEL

	END_TIME=`date +%s`
	let "ELAPSED_TIME=$END_TIME-$START_TIME"
	echo "Total compile time is $ELAPSED_TIME seconds"
) 2>&1	 | tee -a ./build.log

# Credits:
# Samsung
# google
# osm0sis
# cyanogenmod
# kylon 
