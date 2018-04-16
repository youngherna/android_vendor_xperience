#
# XPerience Audio Files
#

ALARM_PATH := vendor/xperience/prebuilt/common/media/audio/alarms
NOTIFICATION_PATH := vendor/xperience/prebuilt/common/media/audio/notifications
RINGTONE_PATH := vendor/xperience/prebuilt/common/media/audio/ringtones
UI_PATH := vendor/xperience/prebuilt/common/media/audio/ui

#UI 
PRODUCT_COPY_FILES += \
    $(UI_PATH)/boot.ogg:system/media/audio/ui/boot.ogg \
    $(UI_PATH)/LowBattery.ogg:system/media/audio/alarms/LowBattery.ogg

# Alarms
PRODUCT_COPY_FILES += \
    $(ALARM_PATH)/CyanAlarm.ogg:system/media/audio/alarms/CyanAlarm.ogg \
    $(ALARM_PATH)/NuclearLaunch.ogg:system/media/audio/alarms/NuclearLaunch.ogg \
    $(ALARM_PATH)/Fuego.ogg:system/media/audio/alarms/Fuego.ogg \
    $(ALARM_PATH)/xperia.ogg:system/media/audio/alarms/xperia.ogg \
    $(ALARM_PATH)/Xperia_alarm.ogg:system/media/audio/alarms/Xperia_alarm.ogg

# Notifications
PRODUCT_COPY_FILES += \
    $(NOTIFICATION_PATH)/CyanDoink.ogg:system/media/audio/notifications/CyanDoink.ogg \
    $(NOTIFICATION_PATH)/CyanMail.ogg:system/media/audio/notifications/CyanMail.ogg \
    $(NOTIFICATION_PATH)/CyanMessage.ogg:system/media/audio/notifications/CyanMessage.ogg \
    $(NOTIFICATION_PATH)/Laser.ogg:system/media/audio/notifications/Laser.ogg \
    $(NOTIFICATION_PATH)/Naughty.ogg:system/media/audio/notifications/Naughty.ogg \
    $(NOTIFICATION_PATH)/Pong.ogg:system/media/audio/notifications/Pong.ogg \
    $(NOTIFICATION_PATH)/Rang.ogg:system/media/audio/notifications/Rang.ogg \
    $(NOTIFICATION_PATH)/Stone.ogg:system/media/audio/notifications/Stone.ogg \
    $(NOTIFICATION_PATH)/Reminder.ogg:system/media/audio/notifications/Reminder.ogg

# Ringtones
ifeq ($(TARGET_NEEDS_BOOSTED_SOUNDS),true)
PRODUCT_COPY_FILES += \
	$(RINGTONE_PATH)/boosted/Boxbeat.ogg:system/media/audio/ringtones/Boxbeat.ogg \
	$(RINGTONE_PATH)/boosted/CyanTone.ogg:system/media/audio/ringtones/CyanTone.ogg \
	$(RINGTONE_PATH)/boosted/Highscore.ogg:system/media/audio/ringtones/Highscore.ogg \
	$(RINGTONE_PATH)/boosted/Lyon.ogg:system/media/audio/ringtones/Lyon.ogg \
	$(RINGTONE_PATH)/boosted/Rockin.ogg:system/media/audio/ringtones/Rockin.ogg
else
PRODUCT_COPY_FILES += \
    $(RINGTONE_PATH)/Boxbeat.ogg:system/media/audio/ringtones/Boxbeat.ogg \
    $(RINGTONE_PATH)/CyanTone.ogg:system/media/audio/ringtones/CyanTone.ogg \
    $(RINGTONE_PATH)/Highscore.ogg:system/media/audio/ringtones/Highscore.ogg \
    $(RINGTONE_PATH)/Lyon.ogg:system/media/audio/ringtones/Lyon.ogg \
    $(RINGTONE_PATH)/Rockin.ogg:system/media/audio/ringtones/Rockin.ogg \
    $(RINGTONE_PATH)/Sheep.mp3:system/media/audio/ringtones/Sheep.mp3 \
    $(RINGTONE_PATH)/Yukaay.ogg:system/media/audio/ringtones/Yukaay.ogg \
    $(RINGTONE_PATH)/XPerienceRing.ogg:system/media/audio/ringtones/XPerienceRing.ogg \
    $(RINGTONE_PATH)/Music_box.ogg:system/media/audio/ringtones/Music_box.ogg \
    $(RINGTONE_PATH)/generic_xperia.ogg:system/media/audio/ringtones/generic_xperia.ogg \
    $(RINGTONE_PATH)/garden_waltz.ogg:system/media/audio/ringtones/garden_waltz.ogg
endif
