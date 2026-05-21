#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface WXRootListController : PSListController
- (void)joinQQGroup;
@end

@implementation WXRootListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WXTool";
}

- (void)joinQQGroup {
    NSURL *url = [NSURL URLWithString:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=123456789&card_type=group"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end