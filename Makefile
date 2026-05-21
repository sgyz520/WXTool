SYSROOT = $(THEOS)/sdks/iPhoneOS16.5.sdk
TARGET = iphone:clang:16.5:14.0
ARCHS = arm64 arm64e

#export THEOS=/Users/shizhujianliang/theos

export DEBUG = 0

INSTALL_TARGET_PROCESSES = WeChat

PACKAGE_VERSION = 1.1.0
TWEAK_NAME = WXTool

# Feature flags (add -DENABLE_XXX to enable a feature)
WXTool_CFLAGS = -fobjc-arc \
                -DVERSION_STRING=\"$(PACKAGE_VERSION)\"

WXTool_FILES = Tweak.x

WXTool_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

# Preference Bundle
BUNDLE_NAME = WXTool
WXTool_FILES = EntryController.x
WXTool_FRAMEWORKS = UIKit
WXTool_INSTALL_PATH = /Library/PreferenceBundles

include $(THEOS_MAKE_PATH)/bundle.mk

internal-after-install::
	install.exec "killall -9 SpringBoard"

THEOS_DEVICE_IP = 192.168.31.227
THEOS_DEVICE_PORT = 22

clean::
	@echo -e "\033[31m==>\033[0m Cleaning packages…"
	@rm -rf .theos
	@rm -rf packages/*

after-package::
	@if [ "$(THEOS_PACKAGE_SCHEME)" = "rootless" ] && [ -z "$$CI" ]; then \
	echo -e "\033[31m==>\033[0m Installing package to device…"; \
	DEB_FILE=$$(ls -t packages/*.deb | head -1); \
	PACKAGE_NAME=$$(basename "$$DEB_FILE" | cut -d'_' -f1); \
	ssh root@$(THEOS_DEVICE_IP) "rm -rf /tmp/$${PACKAGE_NAME}.deb"; \
	scp "$$DEB_FILE" root@$(THEOS_DEVICE_IP):/tmp/$${PACKAGE_NAME}.deb; \
	ssh root@$(THEOS_DEVICE_IP) "dpkg -i --force-overwrite /tmp/$${PACKAGE_NAME}.deb && rm -f /tmp/$${PACKAGE_NAME}.deb"; \
	fi