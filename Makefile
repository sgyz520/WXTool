SYSROOT = $(THEOS)/sdks/iPhoneOS16.5.sdk
TARGET = iphone:clang:16.5:14.0
ARCHS = arm64 arm64e

export DEBUG = 0

INSTALL_TARGET_PROCESSES = WeChat

PACKAGE_VERSION = 1.1.0
TWEAK_NAME = WXTool

WXTool_CFLAGS = -fobjc-arc \
                -DVERSION_STRING=\"$(PACKAGE_VERSION)\"

WXTool_FILES = Tweak.x

WXTool_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

# Bundle configuration
BUNDLE_NAME = WXToolPrefs
$(BUNDLE_NAME)_FILES = EntryController.x
$(BUNDLE_NAME)_FRAMEWORKS = UIKit Foundation Preferences
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc -DVERSION_STRING=\"$(PACKAGE_VERSION)\"
$(BUNDLE_NAME)_LDFLAGS = -F/System/Library/PrivateFrameworks
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles

include $(THEOS_MAKE_PATH)/bundle.mk

internal-after-install::
	install.exec "killall -9 SpringBoard"

THEOS_DEVICE_IP = 192.168.31.227
THEOS_DEVICE_PORT = 22

clean::
	@echo -e "\033[31m==>\033[0m Cleaning packages…"
	@rm -rf .theos
	@rm -rf packages/*