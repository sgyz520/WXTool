#import <UIKit/UIKit.h>

@interface WXRootListController : UIViewController
@end

@implementation WXRootListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"WXTool";
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 40)];
    titleLabel.text = @"WXTool";
    titleLabel.font = [UIFont boldSystemFontOfSize:28];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, self.view.bounds.size.width - 40, 30)];
    versionLabel.text = @"版本：1.1.0";
    versionLabel.font = [UIFont systemFontOfSize:16];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, self.view.bounds.size.width - 40, 30)];
    authorLabel.text = @"作者：施主见谅";
    authorLabel.font = [UIFont systemFontOfSize:16];
    authorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:authorLabel];
    
    UITextView *infoLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, 230, self.view.bounds.size.width - 40, 200)];
    infoLabel.text = @"功能说明：\n\n• 图片堆叠：强制开启微信图片堆叠\n• 消息防撤回：阻止对方撤回消息\n\n修改设置后需要重启微信生效";
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.editable = NO;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:infoLabel];
    
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeSystem];
    qqButton.frame = CGRectMake(20, 450, self.view.bounds.size.width - 40, 50);
    [qqButton setTitle:@"加入 QQ 交流群" forState:UIControlStateNormal];
    qqButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [qqButton addTarget:self action:@selector(joinQQGroup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqButton];
}

- (void)joinQQGroup {
    NSURL *url = [NSURL URLWithString:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=123456789&card_type=group"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end