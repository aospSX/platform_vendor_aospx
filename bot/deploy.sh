#!/bin/bash

# script locked, loaded, and ready to deploy on build day
# examples of use: ./vendor/aospx/bot/deploy.sh
#      make clean: ./vendor/aospx/bot/deploy.sh -c
# only sync+lunch: ./vendor/aospx/bot/deploy.sh -s

BUILD_ROOT=`pwd`
cd $BUILD_ROOT
repo sync
. build/envsetup.sh

# parse options
while getopts ":c :o: :s" opt
do
    case "$opt" in
        c) CLEAN=true;;
        s) STOP=true;;
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

# execute lunch
lunch
    # build_device <lunch combo>
    if [ "$STOP" = "true" ]; then
        echo "stopping from full deployment"
    else
        ./vendor/aospx/bot/build_device.sh
    fi
