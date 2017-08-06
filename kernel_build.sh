#!/bin/bash

# Version 2.0.5, Adapted for XPerience.

# We don't allow scrollback buffer
echo -e '\0033\0143'
clear

# Get current path
DIR=$(pwd)
OUT="$(readlink $DIR/out)"
[ -z "${OUT}" ] && OUT="${DIR}/out"
DATE=$(date +"%Y%m%d")

# Prepare output customization commands
red=$(tput setaf 1)             #  red
grn=$(tput setaf 2)             #  green
blu=$(tput setaf 4)             #  blue
cya=$(tput setaf 6)             #  cyan
txtbld=$(tput bold)             #  Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgrn=${txtbld}$(tput setaf 2) #  green
bldblu=${txtbld}$(tput setaf 4) #  blue
bldcya=${txtbld}$(tput setaf 6) #  cyan
txtrst=$(tput sgr0)             # Reset

# Local defaults, can be overriden by environment
: ${PREFS_FROM_SOURCE:="false"}
if [ `uname -s` == "Darwin" ]; then
: ${THREADS:="$(sysctl -n machdep.cpu.core_count)"}
else
: ${THREADS:="$(cat /proc/cpuinfo | grep "^processor" | wc -l)"}
fi

# Import command line parameters
DEVICE="$1"

# Get build version
MAJOR=$(cat $DIR/vendor/XPe/vendor.mk | grep 'PRODUCT_VERSION_MAJOR := *' | sed  's/PRODUCT_VERSION_MAJOR := //g')
MINOR=$(cat $DIR/vendor/XPe/vendor.mk | grep 'PRODUCT_VERSION_MINOR := *' | sed  's/PRODUCT_VERSION_MINOR := //g')
MAINTENANCE=$(cat $DIR/vendor/XPe/vendor.mk | grep 'PRODUCT_VERSION_MAINTENANCE := *' | sed  's/PRODUCT_VERSION_MAINTENANCE := //g')
TAG=$(cat $DIR/vendor/XPe/vendor.mk | grep 'PRODUCT_VERSION_TAG := *' | sed  's/PRODUCT_VERSION_TAG := //g')

if [ -n "$TAG" ]; then
        VERSION=$MAJOR.$MINOR$MAINTENANCE-$TAG
else
        VERSION=$MAJOR.$MINOR$MAINTENANCE
fi

# Get start time
res1=$(date +%s.%N)

echo -e "${cya}Building ${bldcya}Kernel $VERSION for $DEVICE ${txtrst}";
echo -e "${bldgrn}Start time: $(date) ${txtrst}"

echo -e ""

export DEVICE=$DEVICE

# Fetch latest sources
if [ "$SYNC" == "true" ]; then
        echo -e ""
        echo -e "${bldblu}Fetching latest sources${txtrst}"
        repo sync -j"$THREADS"
        echo -e ""
fi

if [ ! -r "${DIR}/out/versions_checked.mk" ] && [ -n "$(java -version 2>&1 | grep -i openjdk)" ]; then
        echo -e "${bldcya}Your java version still not checked and is candidate to fail, masquerading.${txtrst}"
        JAVA_VERSION="java_version=${JVER}"
fi

if [ -n "${INTERACTIVE}" ]; then
        echo -e "${bldblu}Dropping to interactive shell${txtrst}"
        echo -en "${bldblu}Remeber to lunch you device:"
        if [ "${VENDOR}" == "XPe" ]; then
                echo -e "[${bldgrn}lunch xpe_$DEVICE-userdebug${bldblu}]${txtrst}"
        else
                echo -e "[${bldgrn}lunch full_$DEVICE-userdebug${bldblu}]${txtrst}"
        fi
        bash --init-file build/envsetup.sh -i
else
        # Setup environment
        echo -e ""
        echo -e "${bldblu}Setting up environment${txtrst}"
        . build/envsetup.sh
        echo -e ""

        # lunch/brunch device
        echo -e "${bldblu}Lunching device [$DEVICE] ${cya}(Includes dependencies sync)${txtrst}"
        export PREFS_FROM_SOURCE
        lunch "xpe_$DEVICE-userdebug";

        echo -e "${bldblu}Starting compilation${txtrst}"
        mka bootzip -j4
fi
echo -e ""

# Get elapsed time
res2=$(date +%s.%N)
echo -e "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds)${txtrst}"

if [ -f $DIR/out/target/product/$DEVICE/XPerience-$DEVICE-kernel-signed.zip ]; then
   mv $DIR/out/target/product/$DEVICE/XPerience-$DEVICE-kernel-signed.zip $DIR/out/target/product/$DEVICE/XPerience-$DEVICE-$VERSION-kernel-$DATE-signed.zip
else
   echo "file does not exist or wrong directory located"
fi
