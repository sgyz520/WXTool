SYSROOT = $(THEOS)/sdks/iPhoneOS16.5.sdk
TARGET = iphone:clang:16.5:14.0
ARCHS = arm64 arm64e

#export THEOS=/Users/shizhujianliang/theos

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

# Build bundle separately
after-package::
	@echo "==> Building Preference Bundle..."
	@$(MAKE) -f Makefile.bundle THEOS=$(THEOS)
	@mkdir -p layout/Library/PreferenceBundles/WXTool.bundle
	@cp -r $(THEOS)/obj/$(BUNDLE_NAME).bundle/* layout/Library/PreferenceBundles/WXTool.bundle/
	@cp Resources/entry.plist layout/Library/PreferenceLoader/Preferences/WXTool.plist

internal-after-install::
	install.exec "killall -9 SpringBoard"

THEOS_DEVICE_IP = 192.168.31.227
THEOS_DEVICE_PORT = 22

clean::
	@echo -e "\033[31m==>\033[0m Cleaning packages…"
	@rm -rf .theos
	@rm -rf packages/*