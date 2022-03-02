PRODUCT_BRAND ?= XPerience
# Versioning
-include vendor/xperience/config/version.mk

ifeq ($(TARGET_USES_OLD_BOOTANIMATION), true)
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ "$(TARGET_SCREEN_WIDTH)" -lt "$(TARGET_SCREEN_HEIGHT)" ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

 # get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,,$(shell ls -1 vendor/xperience/prebuilt/bootanimation | sort -rn))

 # find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then \
    if [ "$(1)" -le "$(TARGET_BOOTANIMATION_SIZE)" ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

PRODUCT_BOOTANIMATION := vendor/xperience/prebuilt/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip

# Use by default the new animation made in blender (im not graphic designer anyways xD)
PRODUCT_COPY_FILES += $(PRODUCT_BOOTANIMATION):$(TARGET_COPY_OUT_SYSTEM)/media/bootanimation.zip

endif
else
#We aren't using this old form anymore so for now i will use all other info with copy file then i will change it
PRODUCT_COPY_FILES += vendor/xperience/prebuilt/bootanimation/bootanimation.zip:$(TARGET_COPY_OUT_SYSTEM)/media/bootanimation.zip
endif

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Fixes: terminate called after throwing an instance of 'std::out_of_range' what(): basic_string::erase
# error with prop override
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true

# general properties
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.com.android.wifi-watchlist=GoogleGuest

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.build.selinux=1

PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.ringtone=XPerienceRing.ogg \
    ro.config.notification_sound=Reminder.ogg \
    ro.config.alarm_alert=Fuego.ogg

# IORap app launch prefetching using Perfetto traces and madvise
PRODUCT_PRODUCT_PROPERTIES += \
    ro.iorapd.enable=true

# Enable IORap I/O Prefetching
PRODUCT_SYSTEM_PROPERTIES += \
    persist.device_config.runtime_native_boot.iorap_perfetto_enable=true

# Disable blur on app-launch
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.launcher.blur.appLaunch=0

# Enable dex2oat64 to do dexopt
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    dalvik.vm.dex2oat64.enabled=true

# Disable async MTE on system_server
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    arm64.memtag.process.system_server=off

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true
endif

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/xperience/prebuilt/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/xperience/prebuilt/bin/50-hosts.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-hosts.sh

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/xperience/prebuilt/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/xperience/prebuilt/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/etc/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP and VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Charging sounds
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/media/audio/notifications/BatteryPlugged.ogg:$(TARGET_COPY_OUT_SYSTEM)/media/audio/ui/BatteryPlugged.ogg \
    vendor/xperience/prebuilt/media/audio/notifications/BatteryPlugged_48k.ogg:$(TARGET_COPY_OUT_SYSTEM)/media/audio/ui/BatteryPlugged_48k.ogg

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= true
ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    FaceUnlockService
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face_unlock_service.enabled=$(TARGET_FACE_UNLOCK_SUPPORTED)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# Fonts
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,vendor/xperience/prebuilt/fonts,$(TARGET_COPY_OUT_SYSTEM)/fonts)

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Include Common Qualcomm Device Tree.
$(call inherit-product, device/xperience/common/common.mk)

# Additional packages
-include vendor/xperience/config/packages.mk

# Include definitions for Snapdragon Clang
$(call inherit-product, vendor/qcom/sdclang/config/SnapdragonClang.mk)

# SELinux Policy
# -include vendor/xperience/sepolicy/sepolicy.mk

# GSM porque si
-include vendor/xperience/config/gsm.mk

# Themes and Theme overlays
#include vendor/themes/themes.mk

# Add our overlays
DEVICE_PACKAGE_OVERLAYS += vendor/xperience/overlay/common

# Exclude from RRO
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/xperience/overlay

# Include CM LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/xperience/overlay/dictionaries

# Squisher Location
SQUISHER_SCRIPT := vendor/xperience/tools/squisher

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Copy all xperience-specific init rc files
$(foreach f,$(wildcard vendor/xperience/prebuilt/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Optimize everything for preopt
PRODUCT_DEX_PREOPT_DEFAULT_COMPILER_FILTER := everything

# Skip boot JAR checks.
SKIP_BOOT_JARS_CHECK := true

# Increase volume level steps
PRODUCT_SYSTEM_PROPERTIES += \
    ro.config.media_vol_steps=30

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
