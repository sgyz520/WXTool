#import <UIKit/UIKit.h>

@interface PSListController : UIViewController
@end

@interface PSSpecifier : NSObject
@end

@interface WXRootListController : PSListController
- (void)joinQQGroup;
@end

@implementation WXRootListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WXTool";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"WXTool" 
                                                                   message:@"功能开关在此页面配置\n\n图片堆叠：开启后强制堆叠图片\n消息防撤回：开启后阻止撤回消息" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)joinQQGroup {
    NSURL *url = [NSURL URLWithString:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=123456789&card_type=group"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end