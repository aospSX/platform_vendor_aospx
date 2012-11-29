#!/bin/bash

BUILD_ROOT=`pwd`
cd $BUILD_ROOT
repo sync
. build/envsetup.sh

# parse options
while getopts ":c :o:" opt
do
    case "$opt" in
        c) CLEAN=true;;
        o)
             THEME_VENDOR="$OPTARG"
             echo "using $THEME_VENDOR vendorsetup.sh"
        ;;
        \?)
             echo "invalid option: -$OPTARG"
             echo "exiting..."
             exit 1
        ;;
    esac
done

# check for clean
if [ "$CLEAN" = "true" ]; then
    echo "sanitizing build enviornment"
    rm -rf out
fi

# Check for add_kernel_manifest (mostly just for aokp).
if [ -f platform_manifest/add_kernel_manifest.sh ]; then
	echo "kernel manifest exists, syncing kernel sources"
	./platform_manifest/add_kernel_manifest.sh
fi

# build packages
#
# read the file and execute lunch
  lunch $1
    # build_device <lunch combo>
      ./vendor/aospx/bot/build_device.sh
done
