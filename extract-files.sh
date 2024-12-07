#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=selene
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup {
    case "$1" in
        vendor/bin/hw/android.hardware.media.c2@1.2-mediatek)
            "$PATCHELF" --add-needed "libstagefright_foundation-v33.so" "$2"
            ;;
        system_ext/lib64/libsource.so)
            grep -q "libui_shim.so" "${2}" || "${PATCHELF}" --add-needed "libui_shim.so" "${2}"
            ;;
        vendor/lib64/libwifi-hal-mtk.so)
            "$PATCHELF" --set-soname libwifi-hal-mtk.so "${2}"
            ;;
	vendor/lib64/libmtkcam_stdutils.so)
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v32.so" "${2}"
            ;;
        vendor/lib*/hw/audio.primary.mt6768.so)
            "${PATCHELF}" --add-needed "libshim_audio.so" "${2}"
            "${PATCHELF}" --replace-needed "libalsautils.so" "libalsautils_legacy.so" "${2}"
            ;;
        vendor/lib*/hw/audio.usb.mt6768.so)
            "${PATCHELF}" --replace-needed "libalsautils.so" "libalsautils_legacy.so" "${2}"
	    ;;
        vendor/lib*/hw/dfps.mt6768.so)
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v32.so" "${2}"
            ;;
        vendor/lib*/hw/vendor.mediatek.hardware.pq@2.6-impl.so |\
        vendor/lib*/hw/android.hardware.thermal@2.0-impl.so)
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v32.so" "${2}"
            ;;
	vendor/lib64/libmi_watermark.so)
            "${PATCHELF}" --add-needed "libpiex_shim.so" "${2}"
            ;;
        vendor/lib64/libcam.halsensor.so)
            "${PATCHELF}" --add-needed "libshim_utils.so" "${2}"
            ;;
        vendor/lib64/libgf_hal.so)
            sed -i 's|\x00\x14\xa0\x83_\xb8\xfd{C\xa9\xff\x03\x01\x91\xc0\x03_\xd6\xff\x83\x01\xd1\xfd{\x05\xa9\xfdC\x01\x91|\x00\x14\xa0\x83_\xb8\xfd{C\xa9\xff\x03\x01\x91\xc0\x03_\xd6\x00\x00\xe0\xd2\xc0\x03_\xd6\xfdC\x01\x91|g' "${2}"
            ;;
        vendor/lib64/hw/fingerprint.selene.so)
            sed -i 's|\xc0\x03_\xd6\x00\x00\x00\x00\xff\x03\x01\xd1\xfd{\x02\xa9|\xc0\x03_\xd6\x00\x00\x00\x00\xc0\x03_\xd6\xfd{\x02\xa9|g' "${2}"
            ;;
        vendor/bin/hw/android.hardware.keymaster@4.0-service.beanpod)
            "${PATCHELF}" --add-needed "libshim_beanpod.so" "${2}"
            ;;
        vendor/bin/hw/vendor.mediatek.hardware.mtkpower@1.0-service)
            "${PATCHELF}" --replace-needed "android.hardware.power-V1-ndk_platform.so" "android.hardware.power-V1-ndk.so" "${2}"
            ;;
        vendor/lib/libMtkOmxVdecEx.so)
            "${PATCHELF}" --replace-needed "libui.so" "libui-v32.so" "$2"
            ;;
        vendor/lib*/hw/android.hardware.thermal@2.0-impl.so)
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v32.so" "${2}"
            ;;
        vendor/lib*/libaalservice.so|\
        vendor/lib64/libcam.utils.sensorprovider.so|\
        vendor/bin/mnld)
            grep -q "libshim_sensors.so" "$2" || "$PATCHELF" --add-needed "libshim_sensors.so" "$2"
            ;;
        vendor/lib64/hw/android.hardware.camera.provider@2.6-impl-mediatek.so)
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v32.so" "${2}"
            ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
