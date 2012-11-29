#!/bin/bash

# $1 should be device name
# select device and prepare varibles
BUILD_ROOT=`pwd`
cd $BUILD_ROOT

#check if ccache is setup
if test ! -d /$HOME/.ccache ; then
    echo "You should look into using ccache."
else
    export USE_CCACHE=1
    export CCACHE_DIR=/$HOME/.ccache
    prebuilt/linux-x86/ccache/ccache -M 20G #adjust to your preference
fi

TARGET_VENDOR=$(echo $TARGET_PRODUCT | cut -f1 -d '_')

# build
    make -j$(($(grep processor /proc/cpuinfo | wc -l) * 2)) aospx 2>&1

# changelog
    ./changelog_gen.sh 10/17/2012

# finish
echo "$1 build complete"

# upload
echo "checking on upload reference file"

BUILDBOT=$BUILD_ROOT/vendor/$TARGET_VENDOR/bot/
cd $BUILDBOT
if test -x upload ; then
    echo "Upload file exists, executing now"
    cp upload $OUTD
    cd $OUTD
    # device and zip names are passed on for upload
    ./upload $1 $ZIP && rm upload
else
    echo "No upload file found (or set to +x), build complete."
fi

cd $BUILD_ROOT
