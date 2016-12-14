//
//  FeedBackController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/4.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "FeedBackController.h"
#import <Masonry.h>
#import "MYProgressHUD.h"
#import "HDTextView.h"

@interface FeedBackController () <UITextViewDelegate>

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UILabel *textNumberLabel;

@end

@implementation FeedBackController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideTabBar];
    [self hideNavigationBar];
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
    
    [self addInputView];
}

- (void)addTitleView
{
    self.titleView = [self addTitleViewWithTitle:@"意见反馈"];
    
    UIButton *commitButton = [[UIButton alloc] init];
    [commitButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [commitButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:commitButton];
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.titleView);
        make.height.mas_equalTo(fScreen(88));
        CGSize textSize = [commitButton.titleLabel.text sizeForFontsize:fScreen(32)];
        make.width.mas_equalTo(textSize.width + fScreen(30) * 2);
    }];
}

- (void)addInputView
{
    UIView *inputView = [[UIView alloc] init];
    [inputView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(380));
    }];
    
    UILabel *numberLabel = [[UILabel alloc] init];
    [numberLabel setFont:[UIFont systemFontOfSize:fScreen(20)]];
    [numberLabel setTextColor:HexColor(0x999999)];
    [numberLabel setText:@"0/200"];
    [numberLabel setTextAlignment:NSTextAlignmentRight];
    [inputView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputView.mas_right).offset(-fScreen(20));
        make.left.equalTo(inputView.mas_left).offset(fScreen(20));
        make.bottom.equalTo(inputView.mas_bottom).offset(-fScreen(20));
        CGSize textSize = [numberLabel.text sizeForFontsize:fScreen(20)];
        make.height.mas_equalTo(textSize.height);
    }];
    self.textNumberLabel = numberLabel;
    
    HDTextView *textView = [[HDTextView alloc] init];
    textView.placeholder = @"有什么想对我说的，敬请说出来吧";
    [textView setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [textView setTextColor:HexColor(0x666666)];
    [textView setPlaceholderFontSize:fScreen(24)];
    [textView setTintColor:HexColor(0xe44a62)];
    [textView setDelegate:self];
    [inputView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputView.mas_left).offset(fScreen(20));
        make.top.equalTo(inputView.mas_top).offset(fScreen(20));
        make.right.equalTo(inputView.mas_right).offset(-fScreen(20));
        make.bottom.equalTo(numberLabel.mas_top).offset(-fScreen(20));
    }];
}

#pragma mark - textView delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 200) {
        [MYProgressHUD showAlertWithMessage:@"最多只能输入200个字哦~"];
        
        // 删除多余的字
        NSString *newText = [textView.text substringToIndex:200];
        
        textView.text = newText;
        
        [self.textNumberLabel setText:@"200/200"];
        return;
    }
    
    [self.textNumberLabel setText:[NSString stringWithFormat:@"%ld/200", textView.text.length]];
}

#pragma mark - button click
- (void)commitButtonClick:(UIButton *)sender
{
    if (YES) {
        [MYProgressHUD showAlertWithMessage:@"意见提交成功!"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

@end
