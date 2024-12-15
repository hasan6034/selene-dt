LOCAL_PATH := prebuilts/vndk

include $(CLEAR_VARS)
LOCAL_MODULE := libui-v32
LOCAL_SRC_FILES := v32/arm64/arch-arm-armv8-a/shared/vndk-core/libui.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
LOCAL_VENDOR_MODULE := true
LOCAL_REQUIRED_MODULES := \
	android.hardware.graphics.common-V2-ndk_platform-v32 \
	android.hardware.common-V2-ndk_platform-v32 \
	libstagefright_bufferqueue_helper-v32
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := android.hardware.graphics.common-V2-ndk_platform-v32
LOCAL_MODULE_STEM := android.hardware.graphics.common-V2-ndk_platform
LOCAL_SRC_FILES := v32/arm64/arch-arm-armv8-a/shared/vndk-sp/android.hardware.graphics.common-V2-ndk_platform.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
LOCAL_VENDOR_MODULE := true
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := android.hardware.common-V2-ndk_platform-v32
LOCAL_MODULE_STEM := android.hardware.common-V2-ndk_platform
LOCAL_SRC_FILES := v32/arm64/arch-arm-armv8-a/shared/vndk-sp/android.hardware.common-V2-ndk_platform.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
LOCAL_VENDOR_MODULE := true
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := libstagefright_bufferqueue_helper-v32
LOCAL_MODULE_STEM := libstagefright_bufferqueue_helper
LOCAL_SRC_FILES := v32/arm64/arch-arm-armv8-a/shared/vndk-core/libstagefright_bufferqueue_helper.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
LOCAL_VENDOR_MODULE := true
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_SHARED_LIBRARIES := libhidltransport
LOCAL_MODULE := android.hidl.base@1.0_system
LOCAL_INSTALLED_MODULE_STEM := android.hidl.base@1.0.so
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SHARED_LIBRARIES := libhidltransport
LOCAL_MODULE := android.hidl.manager@1.0_system
LOCAL_INSTALLED_MODULE_STEM := android.hidl.manager@1.0.so
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
include $(BUILD_SHARED_LIBRARY)
