#!/bin/bash 
echo "Cloning dependencies"
sudo apt update
sudo apt upgrade
sudo apt install --no-install-recommends -y bc bison curl ccache ca-certificates flex gcc git glibc-doc jq libxml2 libtinfo5 libc6-dev libssl-dev libstdc++6 make openssl python rclone ssh tar tzdata wget zip
git clone --depth=1 https://github.com/CyanogenMod/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9 gcc
git clone https://github.com/dragonroad99/AnyKernel3  --depth=1 AnyKernel

echo "Done"
KERNEL_DIR=$(pwd)
IMAGE="${KERNEL_DIR}/arch/arm/boot/Image"
TANGGAL=$(date +"%Y%m%d-%H%M")
PATH="${KERNEL_DIR}/gcc/bin:${PATH}"
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=Darknius
export KBUILD_BUILD_HOST=Gitpod

make ARCH=arm lineageos_vivalto3gvn_defconfig

# Compile plox
compile() {
    make -j$(nproc) ARCH=arm \
                    CROSS_COMPILE=arm-linux-androideabi-
}


# Zipping
zipping() {
    cd AnyKernel || exit 1
    cp ../arch/arm/boot/Image .
    zip -r9 Darkforce-vivalto-${TANGGAL}.zip *
    cd ..
}

# Upload
upload() {
    cd AnyKernel && curl -sL https://git.io/file-transfer | sh && ./transfer wet *.zip
    cd ..
}

compile
module
zipping
upload