#import <Foundation/Foundation.h>

#pragma mark - Version Compatibility

#define WC_SUPPORTED_WECHAT_VERSION @"8.0.62+"

#pragma mark - Feature Identifiers

#define WCFEATURE_MEDIA_STACK   @"MediaStack"
#define WCFEATURE_ANTI_RECALL   @"AntiRecall"

#pragma mark - Unified Logging

#ifdef DEBUG
#define WCLog(feature, fmt, ...) \
    NSLog(@"[WXTool][%@] " fmt, feature, ##__VA_ARGS__)
#else
#define WCLog(feature, fmt, ...)
#endif