# Inherit AOSP device configuration for glacier
$(call inherit-product, device/htc/glacier/full_glacier.mk)

# Inherit some common stuff.
$(call inherit-product, vendor/aospx/products/common.mk)

# Inherit proprietary qcom stuff.
$(call inherit-product, vendor/qcom/proprietary/qcom-vendor.mk)

# Include GSM stuff
$(call inherit-product, vendor/aospx/products/gsm.mk)

#
# Setup device specific product configuration.
#
PRODUCT_NAME := aospx_glacier
PRODUCT_BRAND := full_glacier
PRODUCT_DEVICE := glacier
PRODUCT_MODEL := MyTouch 4G
PRODUCT_MANUFACTURER := HTC
PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=htc_glacier BUILD_ID=IMM76L BUILD_FINGERPRINT=google/yakju/maguro:4.0.4/IMM76I/330937:user/release-keys PRIVATE_BUILD_DESC="yakju-user 4.0.4 IMM76I 330937 release-keys"

# Release name and versioning
PRODUCT_RELEASE_NAME := MT4G
