//
//  ShareCommissionView.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "ShareCommissionView.h"
#import <Masonry.h>
#import "MYProgressHUD.h"
#import <MessageUI/MessageUI.h>

@interface ShareCommissionView () <MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSString *commissionText;

@end

@implementation ShareCommissionView

- (instancetype)initWithCommissionText:(NSString *)commissionText
{
    if (self = [super init]) {
        self.commissionText = commissionText;
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5f]];
    [self setFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer *tapGur = [[UITapGestureRecognizer alloc] init];
    [tapGur addTarget:self action:@selector(closeButtonClick:)];
    [self addGestureRecognizer:tapGur];
    
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(fScreen(680));
    }];
    
    // 分享 label
    UILabel *shareLabel = [[UILabel alloc] init];
    [shareLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:fScreen(32)]];
    [shareLabel setText:@"分享好友购买后每件最高可获"];
    [shareLabel setTextAlignment:NSTextAlignmentCenter];
    [shareLabel setTextColor:HexColor(0x333333)];
    [view addSubview:shareLabel];
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(view).offset(fScreen(58));
        make.height.mas_equalTo(fScreen(32));
    }];
    
    UILabel *commissionLabel = [[UILabel alloc] init];
    [commissionLabel setText:self.commissionText];
    [commissionLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:fScreen(32)]];
    [commissionLabel setTextAlignment:NSTextAlignmentCenter];
    [commissionLabel setTextColor:HexColor(0xe79433)];
    [view addSubview:commissionLabel];
    [commissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(shareLabel.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(32));
    }];

    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setImage:[UIImage imageNamed:@"icon_ext"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(view);
        make.height.mas_equalTo(fScreen(72));
        make.width.mas_equalTo(fScreen(52*2 + 34));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(fScreen(48));
        make.right.equalTo(view.mas_right).offset(-fScreen(48));
        make.height.equalTo(@1);
        make.top.equalTo(commissionLabel.mas_bottom).offset(fScreen(48));
    }];
    
    CGFloat x = fScreen(36);
    CGFloat y = fScreen(256);
    CGFloat width = fScreen(120);
    CGFloat height = fScreen(120);
    CGFloat margin = (kAppWidth - fScreen(36*2) - fScreen(120*4))/3;
    
    for (NSInteger index = 0; index < 5; index++) {
        UIView *shareButton = [self makeShareButtonWithType:index];
        CGRect frame = CGRectMake(x, y, width, height);
        [shareButton setFrame:frame];
        
        x += width + margin;
        
        if (index == 3) {
            x = fScreen(36);
            y += height + fScreen(10 + 28 + 40);
        }
        
        [view addSubview:shareButton];
    }
}

- (UIView *)makeShareButtonWithType:(ShareType)type
{
    UIView *shareCellView = [[UIView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    NSString *imageName;
    NSString *title;
    switch (type) {
        case ShareType_WeChat:
        default:
            imageName = @"icon_wei_share";
            title = @"微信";
            break;
        case ShareType_QQ:
            imageName = @"icon_QQ_share";
            title = @"QQ";
            break;
        case ShareType_Weibo:
            imageName = @"icon_weibo_share";
            title = @"微博";
            break;
        case ShareType_Message:
            imageName = @"icon_mess_share";
            title = @"短信";
            break;
        case ShareType_link:
            imageName = @"icon_link_share";
            title = @"链接";
            break;
    }
    
    [imageView setImage:[UIImage imageNamed:imageName]];
    
    [shareCellView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(shareCellView);
        make.height.mas_equalTo(fScreen(120));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [titleLabel setTextColor:HexColor(0x666666)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:title];
    [shareCellView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(fScreen(10));
        make.left.right.equalTo(shareCellView);
        CGSize textSize = [@"高度" sizeForFontsize:fScreen(28)];
        make.height.mas_equalTo(textSize.height);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTag:type];
    [button addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareCellView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(shareCellView);
    }];
    
    return shareCellView;
}

// 短信
- (void)showMessageView
{
    if( [MFMessageComposeViewController canSendText] )// 判断设备能不能发送短信
    {
        MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
        // 设置委托
        messageVC.messageComposeDelegate= self;
        // 默认信息内容
        messageVC.body = [NSString stringWithFormat:@"%@,%@", self.shareModel.shareContent, self.shareModel.shareURL];
        // 默认收件人(可多个)
        [self.currNaviController presentViewController:messageVC animated:YES completion:nil];
    }
    else
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        NSString *string = [NSString stringWithFormat:@"%@,%@",
                            self.shareModel.shareContent.length == 0 ? @"" : self.shareModel.shareContent,
                            self.shareModel.shareURL.length == 0? @"" : self.shareModel.shareURL];
        
        pasteboard.string = string;
        
        [MYProgressHUD showAlertWithMessage:@"分享内容已经复制到剪切板~"];
        
        // 不能定制短信内容
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:"]];
        });
    }
}

#pragma mark - button click
- (void)closeButtonClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)shareButtonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case ShareType_WeChat:
        default:
            DLog(@"微信");
            break;
        case ShareType_QQ:
            DLog(@"QQ");
            break;
        case ShareType_Weibo:
            DLog(@"微博");
            break;
        case ShareType_Message:
            DLog(@"短信");
            [self showMessageView];
            break;
        case ShareType_link:
            DLog(@"链接");
            // 复制到剪切板
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.shareModel.shareURL.length == 0 ? @"" :  self.shareModel.shareURL;
            [MYProgressHUD showAlertWithMessage:@"链接已经复制到剪切板~"];
            break;
    }
}

#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result){
        case MessageComposeResultCancelled:
            DLog(@"取消发送");
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultFailed:
            [MYProgressHUD showAlertWithMessage:@"发送失败"];
            break;
        case MessageComposeResultSent:
            [MYProgressHUD showAlertWithMessage:@"发送成功"];
            break;
            
        default:
            break;
    }
}

@end
