//
//  UserInfoViewController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/3.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "UserInfoViewController.h"
#import <Masonry.h>
#import "EditUserNameController.h"

#define kOptionCellButtonTag 1024

@interface UserInfoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIView *addressView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *userIcon;

@property (nonatomic, strong) UIView *actionSheetCover;

@end

@implementation UserInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideTabBar];
    [self hideNavigationBar];
    
    if (self.nameLabel) {
        [self.nameLabel setText:[NSString stringWithFormat:@"%@",[HDUserDefaults objectForKey:cUserName] == nil ? @"" : [NSString stringWithFormat:@"%@", [HDUserDefaults objectForKey:cUserName]]]];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    [self addTitleView];
    
    [self addInfoView];
    
    [self addAddressView];
}

- (void)addTitleView
{
    self.titleView = [self addTitleViewWithTitle:@"个人资料"];
}

- (void)addInfoView
{
    UIView *infoView = [[UIView alloc] init];
    [infoView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(88 * 4) - 1);  // 遮挡底部的横线
    }];
    self.infoView = infoView;
    
    CGFloat width = kAppWidth;
    CGFloat height = fScreen(88);
    
    // 头像
    UIImageView *userIcon = [[UIImageView alloc] init];
    [userIcon setBackgroundColor:[UIColor grayColor]];
    [userIcon.layer setCornerRadius:fScreen(58)/2];
    [userIcon.layer setMasksToBounds:YES];
    [userIcon setImage:[UIImage imageNamed:[HDUserDefaults objectForKey:cUserIcon]]];
    self.userIcon = userIcon;
    
    UIView *userHeaderView = [self makeOptionCellWithTitle:@"头像" tag:kOptionCellButtonTag + 0 hasArrow:YES rightView:userIcon];
    
    // 昵称
    UILabel *userNameLabel = [self makeRightViewLabel:[HDUserDefaults objectForKey:cUserName] == nil ?
                              [NSString stringWithFormat:@"用户%@", [HDUserDefaults objectForKey:cUserid]] :
                              [NSString stringWithFormat:@"%@", [HDUserDefaults objectForKey:cUserName]]];
    
    self.nameLabel = userNameLabel;
    UIView *userNameView = [self makeOptionCellWithTitle:@"昵称" tag:kOptionCellButtonTag + 1 hasArrow:YES rightView:userNameLabel];
    
    // 性别
    UILabel *userSexLabel = [self makeRightViewLabel:[NSString stringWithFormat:@"%@", [HDUserDefaults objectForKey:cUserSex]]];
    UIView *userSexView = [self makeOptionCellWithTitle:@"性别" tag:kOptionCellButtonTag + 2 hasArrow:YES rightView:userSexLabel];
    
    // 背景图片
    UIView *backgroundImageView = [self makeOptionCellWithTitle:@"背景图片" tag:kOptionCellButtonTag + 3 hasArrow:YES rightView:nil];
    
    [userHeaderView setFrame:CGRectMake(0, 0, width, height)];
    [userNameView setFrame:CGRectMake(0, height, width, height)];
    [userSexView setFrame:CGRectMake(0, height * 2, width, height)];
    [backgroundImageView setFrame:CGRectMake(0, height * 3, width, height)];
    
    [infoView addSubview:userHeaderView];
    [infoView addSubview:userNameView];
    [infoView addSubview:userSexView];
    [infoView addSubview:backgroundImageView];
}

- (void)addAddressView
{
    UIView *addressView = [self makeOptionCellWithTitle:@"收货地址管理" tag:kOptionCellButtonTag + 100 hasArrow:NO rightView:nil];
    [self.view addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.infoView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(88));
    }];
}

- (UILabel *)makeRightViewLabel:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    [label setText:[HDUserDefaults objectForKey:text]];
    [label setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [label setTextColor:HexColor(0x999999)];
    [label setTextAlignment:NSTextAlignmentRight];
    return label;
}


/**
 创建 cell

 @param title     左侧标题
 @param tag       按钮的 tag 值
 @param hasArrow  是否有箭头
 @param rightView 右侧的自定义视图
 */
- (UIView *)makeOptionCellWithTitle:(NSString *)title
                                tag:(NSInteger)tag
                           hasArrow:(BOOL)hasArrow
                          rightView:(UIView *)rightView
{
    UIView *cellView = [[UIView alloc] init];
    [cellView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [titleLabel setTextColor:HexColor(0x666666)];
    [titleLabel setText:title];
    [cellView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellView.mas_left).offset(fScreen(30));
        make.top.right.bottom.equalTo(cellView);
    }];
    
    // 是否有箭头
    if (hasArrow) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more"]];
        [cellView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cellView.mas_right).offset(-fScreen(30));
            make.centerY.equalTo(cellView.mas_centerY);
            make.width.mas_equalTo(fScreen(14));
            make.height.mas_equalTo(fScreen(24));
        }];
    }
    
    if (rightView) {
        [cellView addSubview:rightView];
        
        if ([rightView isKindOfClass:[UILabel class]]) {
            [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cellView.mas_right).offset(-fScreen(30 + 14 + 20));
                make.top.bottom.equalTo(cellView);
                make.width.mas_equalTo(fScreen(400));
            }];
        }
        else if ([rightView isKindOfClass:[UIImageView class]]) {
            [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cellView.mas_right).offset(-fScreen(30 + 14 + 20));
                make.centerY.equalTo(cellView.mas_centerY);
                make.width.mas_equalTo(fScreen(58));
                make.height.mas_equalTo(fScreen(58));
            }];
        }
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [cellView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellView.mas_left).offset(fScreen(30));
        make.bottom.right.equalTo(cellView);
        make.height.equalTo(@1);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:tag];
    [cellView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(cellView);
    }];
    
    return cellView;
}

- (void)optionButtonClick:(UIButton *)sender
{
    UIViewController *toViewController;
    
    NSInteger tag = sender.tag - kOptionCellButtonTag;
    
    switch (tag) {
        case 0:
            // 头像
        {
            [self showActionSheet];
        }
            break;
        case 1:
            // 昵称
        {
            toViewController = [[EditUserNameController alloc] init];
            [self.navigationController pushViewController:toViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)showActionSheet
{
    if (!self.actionSheetCover) {
        UIView *cover = [[UIView alloc] init];
        [cover setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4f]];
        [self.view addSubview:cover];
        [cover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
        self.actionSheetCover = cover;
        
        UIView *optionView = [[UIView alloc] init];
        [optionView setBackgroundColor:[UIColor whiteColor]];
        [optionView.layer setCornerRadius:fScreen(26)];
        [optionView.layer setMasksToBounds:YES];
        [cover addSubview:optionView];
        [optionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cover.mas_left).offset(fScreen(20));
            make.right.equalTo(cover.mas_right).offset(-fScreen(20));
            make.height.mas_equalTo(fScreen(240));
            make.bottom.equalTo(cover.mas_bottom).offset(-fScreen(24 + 114 + 20));
        }];
        
        UIButton *button1 = [[UIButton alloc] init];
        [button1 setTag:0];
        [button1.titleLabel setFont:[UIFont systemFontOfSize:fScreen(36)]];
        [button1 setTitleColor:HexColor(0x333333) forState:UIControlStateNormal];
        [button1 setTitle:@"我的相册" forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(actionSheetClick:) forControlEvents:UIControlEventTouchUpInside];
        [optionView addSubview:button1];
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(optionView);
            make.height.mas_equalTo(fScreen(120));
        }];
        
        UIView *lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:HexColor(0xdadada)];
        [optionView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(optionView);
            make.height.equalTo(@1);
            make.centerY.equalTo(optionView.mas_centerY);
        }];
        
        UIButton *button2 = [[UIButton alloc] init];
        [button2 setTag:1];
        [button2.titleLabel setFont:[UIFont systemFontOfSize:fScreen(36)]];
        [button2 setTitleColor:HexColor(0x333333) forState:UIControlStateNormal];
        [button2 setTitle:@"相机" forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(actionSheetClick:) forControlEvents:UIControlEventTouchUpInside];
        [optionView addSubview:button2];
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(optionView);
            make.height.mas_equalTo(fScreen(120));
        }];

        
        UIButton *escButton = [[UIButton alloc] init];
        [escButton setBackgroundColor:[UIColor whiteColor]];
        [escButton.layer setCornerRadius:fScreen(26)];
        [escButton.layer setMasksToBounds:YES];
        [escButton setTitle:@"取消" forState:UIControlStateNormal];
        [escButton setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
        [escButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(36)]];
        [escButton setTag:2];
        [escButton addTarget:self action:@selector(actionSheetClick:) forControlEvents:UIControlEventTouchUpInside];
        [cover addSubview:escButton];
        [escButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(optionView);
            make.top.equalTo(optionView.mas_bottom).offset(fScreen(20));
            make.height.mas_equalTo(fScreen(114));
        }];
    }
    [self.actionSheetCover setHidden:NO];
    [self.actionSheetCover setAlpha:1];
}

- (void)actionSheetClick:(UIButton *)sender
{
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.allowsEditing = YES;
    pickerVC.delegate = self;
    
    switch (sender.tag) {
        case 0:
            // 我的相册
        {
            pickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
            break;
        case 1:
            // 相机
        {
            pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
            break;
        case 2:
        default:
            // 取消
            [self hideActionSheet];
            return;
            break;
    }
    [self presentViewController:pickerVC animated:YES completion:nil];
}

- (void)hideActionSheet
{
    [UIView animateWithDuration:0.3f animations:^{
        self.actionSheetCover.alpha = 0;
        [self.actionSheetCover setHidden:YES];
    }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageOrientation imageOrientation = image.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        self.userIcon.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    else {
        self.userIcon.image = image;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserHeaderIconChange object:nil];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self hideActionSheet];
}

@end
