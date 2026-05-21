#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

@interface WXRootListController : PSListController
@end

@implementation WXRootListController

- (id)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"WXTool";
    }
    return self;
}

- (NSArray *)specifiers {
    if (!_specifiers) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if (![defaults objectForKey:@"enableMediaStack"]) {
            [defaults setBool:YES forKey:@"enableMediaStack"];
        }
        if (![defaults objectForKey:@"enableAntiRecall"]) {
            [defaults setBool:YES forKey:@"enableAntiRecall"];
        }
        [defaults synchronize];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        PSSpecifier *group1 = [[PSSpecifier alloc] initWithDictionary:@{@"cell": @"PSGroupCell", @"label": @"功能开关", @"footerText": @"修改后需要重启微信生效"}];
        [array addObject:group1];
        
        PSSpecifier *switch1 = [[PSSpecifier alloc] initWithDictionary:@{@"cell": @"PSSwitchCell", @"defaults": @"com.shizhujianliang.wxtool", @"key": @"enableMediaStack", @"default": @YES, @"label": @"图片堆叠", @"PostNotification": @"com.shizhujianliang.wxtool/settingsChanged"}];
        [array addObject:switch1];
        
        PSSpecifier *switch2 = [[PSSpecifier alloc] initWithDictionary:@{@"cell": @"PSSwitchCell", @"defaults": @"com.shizhujianliang.wxtool", @"key": @"enableAntiRecall", @"default": @YES, @"label": @"消息防撤回", @"PostNotification": @"com.shizhujianliang.wxtool/settingsChanged"}];
        [array addObject:switch2];
        
        PSSpecifier *group2 = [[PSSpecifier alloc] initWithDictionary:@{@"cell": @"PSGroupCell", @"label": @"关于"}];
        [array addObject:group2];
        
        PSSpecifier *version = [[PSSpecifier alloc] initWithDictionary:@{@"cell": @"PSStaticTextCell", @"label": @"版本", @"labelValue": @"1.1.0"}];
        [array addObject:version];
        
        PSSpecifier *author = [[PSSpecifier alloc] initWithDictionary:@{@"cell": @"PSStaticTextCell", @"label": @"作者", @"labelValue": @"施主见谅"}];
        [array addObject:author];
        
        PSSpecifier *button = [[PSSpecifier alloc] initWithDictionary:@{@"cell": @"PSButtonCell", @"label": @"加入 QQ 交流群", @"action": @"joinQQGroup"}];
        [button setTarget:self];
        [array addObject:button];
        
        PSSpecifier *group3 = [[PSSpecifier alloc] initWithDictionary:@{@"cell": @"PSGroupCell", @"footerText": @"公众号：施主见谅"}];
        [array addObject:group3];
        
        _specifiers = array;
    }
    return _specifiers;
}

- (void)joinQQGroup {
    NSString *urlString = @"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=123456789";
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end