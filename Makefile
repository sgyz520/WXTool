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

internal-after-install::
	install.exec "killall -9 SpringBoard"

THEOS_DEVICE_IP = 192.168.31.227
THEOS_DEVICE_PORT = 22

clean::
	@echo -e "\033[31m==>\033[0m Cleaning packages…"
	@rm -rf .theos
	@rm -rf packages/*