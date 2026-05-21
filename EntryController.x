#import <UIKit/UIKit.h>

@interface WXRootListController : UIViewController {
    UISwitch *_mediaStackSwitch;
    UISwitch *_antiRecallSwitch;
}
@end

@implementation WXRootListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"WXTool";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL mediaStackEnabled = [defaults boolForKey:@"enableMediaStack"];
    if (![defaults objectForKey:@"enableMediaStack"]) {
        [defaults setBool:YES forKey:@"enableMediaStack"];
        [defaults synchronize];
        mediaStackEnabled = YES;
    }
    BOOL antiRecallEnabled = [defaults boolForKey:@"enableAntiRecall"];
    if (![defaults objectForKey:@"enableAntiRecall"]) {
        [defaults setBool:YES forKey:@"enableAntiRecall"];
        [defaults synchronize];
        antiRecallEnabled = YES;
    }
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat y = 20;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, 80)];
    headerView.backgroundColor = [UIColor colorWithRed:65/255.0 green:105/255.0 blue:225/255.0 alpha:1.0];
    [self.view addSubview:headerView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, width - 40, 30)];
    titleLabel.text = @"WXTool";
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, width - 40, 20)];
    subTitleLabel.text = @"微信工具箱 v1.1.0";
    subTitleLabel.font = [UIFont systemFontOfSize:14];
    subTitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    [headerView addSubview:subTitleLabel];
    
    y += 90;
    
    UIView *groupHeader1 = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, 40)];
    groupHeader1.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self.view addSubview:groupHeader1];
    
    UILabel *groupLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, width - 40, 16)];
    groupLabel1.text = @"功能开关";
    groupLabel1.font = [UIFont systemFontOfSize:13];
    groupLabel1.textColor = [UIColor grayColor];
    [groupHeader1 addSubview:groupLabel1];
    
    y += 40;
    
    UIView *cell1 = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, 60)];
    cell1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cell1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, width - 120, 20)];
    label1.text = @"图片堆叠";
    label1.font = [UIFont systemFontOfSize:16];
    [cell1 addSubview:label1];
    
    _mediaStackSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width - 80, 15, 51, 31)];
    _mediaStackSwitch.on = mediaStackEnabled;
    [_mediaStackSwitch addTarget:self action:@selector(mediaStackSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [cell1 addSubview:_mediaStackSwitch];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, width, 0.5)];
    line1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [cell1 addSubview:line1];
    
    y += 60;
    
    UIView *cell2 = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, 60)];
    cell2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cell2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, width - 120, 20)];
    label2.text = @"消息防撤回";
    label2.font = [UIFont systemFontOfSize:16];
    [cell2 addSubview:label2];
    
    _antiRecallSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width - 80, 15, 51, 31)];
    _antiRecallSwitch.on = antiRecallEnabled;
    [_antiRecallSwitch addTarget:self action:@selector(antiRecallSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [cell2 addSubview:_antiRecallSwitch];
    
    y += 60;
    
    UIView *footerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, 50)];
    footerView1.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self.view addSubview:footerView1];
    
    UILabel *footerLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, width - 40, 30)];
    footerLabel1.text = @"修改后需要重启微信生效";
    footerLabel1.font = [UIFont systemFontOfSize:12];
    footerLabel1.textColor = [UIColor lightGrayColor];
    footerLabel1.numberOfLines = 2;
    [footerView1 addSubview:footerLabel1];
    
    y += 50;
    
    UIView *groupHeader2 = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, 40)];
    groupHeader2.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self.view addSubview:groupHeader2];
    
    UILabel *groupLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, width - 40, 16)];
    groupLabel2.text = @"关于";
    groupLabel2.font = [UIFont systemFontOfSize:13];
    groupLabel2.textColor = [UIColor grayColor];
    [groupHeader2 addSubview:groupLabel2];
    
    y += 40;
    
    UIView *cell3 = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, 50)];
    cell3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cell3];
    
    UILabel *label3a = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 80, 20)];
    label3a.text = @"版本";
    label3a.font = [UIFont systemFontOfSize:16];
    [cell3 addSubview:label3a];
    
    UILabel *label3b = [[UILabel alloc] initWithFrame:CGRectMake(width - 120, 15, 100, 20)];
    label3b.text = @"1.1.0";
    label3b.font = [UIFont systemFontOfSize:16];
    label3b.textColor = [UIColor grayColor];
    label3b.textAlignment = NSTextAlignmentRight;
    [cell3 addSubview:label3b];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, width, 0.5)];
    line3.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [cell3 addSubview:line3];
    
    y += 50;
    
    UIView *cell4 = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, 50)];
    cell4.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cell4];
    
    UILabel *label4a = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 80, 20)];
    label4a.text = @"作者";
    label4a.font = [UIFont systemFontOfSize:16];
    [cell4 addSubview:label4a];
    
    UILabel *label4b = [[UILabel alloc] initWithFrame:CGRectMake(width - 120, 15, 100, 20)];
    label4b.text = @"施主见谅";
    label4b.font = [UIFont systemFontOfSize:16];
    label4b.textColor = [UIColor grayColor];
    label4b.textAlignment = NSTextAlignmentRight;
    [cell4 addSubview:label4b];
    
    y += 50;
    
    UIButton *joinButton = [[UIButton alloc] initWithFrame:CGRectMake(20, y, width - 40, 44)];
    [joinButton setTitle:@"加入 QQ 交流群" forState:UIControlStateNormal];
    [joinButton setTitleColor:[UIColor colorWithRed:65/255.0 green:105/255.0 blue:225/255.0 alpha:1.0] forState:UIControlStateNormal];
    joinButton.titleLabel.font = [UIFont systemFontOfSize:16];
    joinButton.backgroundColor = [UIColor whiteColor];
    joinButton.layer.borderColor = [UIColor colorWithRed:65/255.0 green:105/255.0 blue:225/255.0 alpha:1.0].CGColor;
    joinButton.layer.borderWidth = 1.0;
    joinButton.layer.cornerRadius = 22;
    [joinButton addTarget:self action:@selector(joinQQGroup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:joinButton];
    
    y += 60;
    
    UIView *footerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, 60)];
    footerView2.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self.view addSubview:footerView2];
    
    UILabel *footerLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, width - 40, 20)];
    footerLabel2.text = @"公众号：施主见谅";
    footerLabel2.font = [UIFont systemFontOfSize:12];
    footerLabel2.textColor = [UIColor lightGrayColor];
    footerLabel2.textAlignment = NSTextAlignmentCenter;
    [footerView2 addSubview:footerLabel2];
}

- (void)mediaStackSwitchChanged:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.on forKey:@"enableMediaStack"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.shizhujianliang.wxtool/settingsChanged" object:nil];
}

- (void)antiRecallSwitchChanged:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.on forKey:@"enableAntiRecall"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.shizhujianliang.wxtool/settingsChanged" object:nil];
}

- (void)joinQQGroup {
    NSString *urlString = @"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=123456789";
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end