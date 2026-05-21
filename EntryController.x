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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"enableMediaStack"]) {
        [defaults setBool:YES forKey:@"enableMediaStack"];
    }
    if (![defaults objectForKey:@"enableAntiRecall"]) {
        [defaults setBool:YES forKey:@"enableAntiRecall"];
    }
    [defaults synchronize];
}

- (void)joinQQGroup {
    NSString *urlString = @"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=123456789";
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end