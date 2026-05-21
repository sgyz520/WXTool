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
        
        PSSpecifier *group1 = [PSSpecifier emptyGroupSpecifier];
        [group1 setProperty:@"功能开关" forKey:@"label"];
        [group1 setProperty:@"修改后需要重启微信生效" forKey:@"footerText"];
        [array addObject:group1];
        
        PSSpecifier *switch1 = [PSSpecifier preferenceSpecifierNamed:@"图片堆叠" target:nil set:nil get:nil detail:nil cell:@"PSSwitchCell" edit:nil];
        [switch1 setProperty:@"com.shizhujianliang.wxtool" forKey:@"defaults"];
        [switch1 setProperty:@"enableMediaStack" forKey:@"key"];
        [switch1 setProperty:@YES forKey:@"default"];
        [switch1 setProperty:@"com.shizhujianliang.wxtool/settingsChanged" forKey:@"PostNotification"];
        [array addObject:switch1];
        
        PSSpecifier *switch2 = [PSSpecifier preferenceSpecifierNamed:@"消息防撤回" target:nil set:nil get:nil detail:nil cell:@"PSSwitchCell" edit:nil];
        [switch2 setProperty:@"com.shizhujianliang.wxtool" forKey:@"defaults"];
        [switch2 setProperty:@"enableAntiRecall" forKey:@"key"];
        [switch2 setProperty:@YES forKey:@"default"];
        [switch2 setProperty:@"com.shizhujianliang.wxtool/settingsChanged" forKey:@"PostNotification"];
        [array addObject:switch2];
        
        PSSpecifier *group2 = [PSSpecifier emptyGroupSpecifier];
        [group2 setProperty:@"关于" forKey:@"label"];
        [array addObject:group2];
        
        PSSpecifier *version = [PSSpecifier preferenceSpecifierNamed:@"版本" target:nil set:nil get:nil detail:nil cell:@"PSStaticTextCell" edit:nil];
        [version setProperty:@"1.1.0" forKey:@"labelValue"];
        [array addObject:version];
        
        PSSpecifier *author = [PSSpecifier preferenceSpecifierNamed:@"作者" target:nil set:nil get:nil detail:nil cell:@"PSStaticTextCell" edit:nil];
        [author setProperty:@"施主见谅" forKey:@"labelValue"];
        [array addObject:author];
        
        PSSpecifier *button = [PSSpecifier preferenceSpecifierNamed:@"加入 QQ 交流群" target:self set:nil get:nil detail:nil cell:@"PSButtonCell" edit:nil];
        [button setProperty:@"joinQQGroup" forKey:@"action"];
        [array addObject:button];
        
        PSSpecifier *group3 = [PSSpecifier emptyGroupSpecifier];
        [group3 setProperty:@"公众号：施主见谅" forKey:@"footerText"];
        [array addObject:group3];
        
        _specifiers = [array retain];
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