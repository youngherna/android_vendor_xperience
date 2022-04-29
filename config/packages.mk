# Additional packages
# themes
# $(call inherit-product, vendor/themes/themes.mk)

# Include AOSP audio files
include vendor/xperience/config/aosp_audio.mk

# Include xperience audio files
include vendor/xperience/config/xpe_audio.mk

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# CellBroadcastReceiver
PRODUCT_PACKAGES += \
CellBroadcastReceiver

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Additional apps
# PRODUCT_PACKAGES += \
#    Etar \
#    ExactCalculator \
#    NightFallQuickStep \
#    OmniStyle \
#    Terminal \
#    XPeriaWeather \
#    Yunikon
PRODUCT_PACKAGES += \
    Seedvault \
    XPeriaWeather \
    Yunikon

# Repainter integration
PRODUCT_PACKAGES += \
    RepainterServicePriv

# Dummy for the weather
PRODUCT_PACKAGES += \
	com.sony.device

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# Wallet app for Power menu integration
# https://source.android.com/devices/tech/connect/quick-access-wallet
PRODUCT_PACKAGES += \
    QuickAccessWallet

# Use signing keys for only official builds
#ifeq ($(XPERIENCE_CHANNEL),OFFICIAL)
#    PRODUCT_DEFAULT_DEV_CERTIFICATE := .keys/releasekey
#    PRODUCT_OTA_PUBLIC_KEYS = .keys/otakey.x509.pem

# Only build OTA if official
PRODUCT_PACKAGES += \
    Updater

# XPerience postboot based on qcom file
#PRODUCT_PACKAGES += \
#    init.xperience.postboot.sh

#endif

PRODUCT_PACKAGES += \
    charger_res_images

ifneq ($(WITH_XPERIENCE_CHARGER),false)
PRODUCT_PACKAGES += \
    xperience_charger_animation
endif

# FS tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mount.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs

# Permissions
PRODUCT_PACKAGES += \
    privapp-permissions-xperience.xml \
    privapp-permissions-xperience-product.xml \
    privapp-permissions-xperience-system_ext.xml

# Exempt DeskClock from Powersave
PRODUCT_PACKAGES += \
    deskclock.xml

# Backup Services whitelist
PRODUCT_PACKAGES += \
    backup.xml

# Hidden API whitelist
PRODUCT_PACKAGES += \
    xperience-hiddenapi-package-whitelist.xml

# Themes
PRODUCT_PACKAGES += \
    ThemePicker \
    WallpaperPicker2 \
    XPerienceOverlayStub

#Coral cant include this due to lower superpartition size
ifneq ($(TARGET_DONT_INCLUDE_XPEWALLS), true)
PRODUCT_PACKAGES += \
    XPerienceWallpapers
endif

PRODUCT_PACKAGES += \
    NavigationBarMode2ButtonOverlay

# Dex preopt
#PRODUCT_DEXPREOPT_SPEED_APPS += \
#    SystemUI \
#    Settings \
#    NightFallQuickStep \
#    XPeriaWeather
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    Settings \
    XPeriaWeather

#-include vendor/qcom/common/perf/packages.mk

ifneq ($(strip $(TARGET_USES_RRO)),true)
# enable overlays to use our version of
# source/resources etc.
ifeq ($(TARGET_USE_QTI_BT_STACK),true)
DEVICE_PACKAGE_OVERLAYS += device/qcom/common/device/overlay
PRODUCT_PACKAGE_OVERLAYS += device/qcom/common/product/overlay
else
DEVICE_PACKAGE_OVERLAYS += vendor/xperience/overlay/qcom/common/device/overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/xperience/overlay/qcom/common/product/overlay
endif #TARGET_USE_QTI_BT_STACK
endif #TARGET_USES_RRO

# if exist track perf changes
-include vendor/extras/extras.mk

ifeq ($(WITH_GMS), true)

# -include vendor/gapps/pixel-gapps.mk
$(call inherit-product, vendor/gapps/common/common-vendor.mk)

PRODUCT_PACKAGES += \
    XPerienceSetupWizard

endif


