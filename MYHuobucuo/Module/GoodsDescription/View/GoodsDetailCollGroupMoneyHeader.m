//
//  GoodsDetailCollGroupMoneyHeader.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/8.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GoodsDetailCollGroupMoneyHeader.h"
#import <Masonry.h>
#import <SDCycleScrollView.h>
#import <UIImageView+WebCache.h>
#import "EvaluateModel.h"
#import "EvaluateTabCell.h"
#import "HDLabel.h"
#import "GoodsGroupOhterGroupTabView.h"

@interface GoodsDetailCollGroupMoneyHeader () <UITableViewDataSource, UITableViewDelegate ,SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleView;
@property (nonatomic, strong) UIView *goodsNameView;            // 名称/价格
@property (nonatomic, strong) UIView *goodsServiceView;         // 服务
@property (nonatomic, strong) UIView *goodsEvaluateView;        // 评价
@property (nonatomic, strong) UIView *goodsShopView;            // 店铺

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *commBgView;

@property (nonatomic, strong) GoodsGroupOhterGroupTabView *otherGroupsView;          // 其他拼团
@property (nonatomic, strong) UIView *rulesView;                // 规则视图

// 倒计时
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger time;

@end

@implementation GoodsDetailCollGroupMoneyHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(priceChange:) name:kGoodsSpecSelectPriceChangeNoti object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)priceChange:(NSNotification *)infoDict
{
    NSString *price = [NSString stringWithFormat:@"¥%@",[infoDict.userInfo objectForKey:@"price"]];
    
    NSString *priceText = price;
    NSMutableAttributedString *priceAttrString = [[NSMutableAttributedString alloc] initWithString:priceText];
    NSDictionary *priceAttr = @{ NSFontAttributeName : [UIFont systemFontOfSize:fScreen(20)]};
    [priceAttrString addAttributes:priceAttr range:NSMakeRange(0, 1)];
    self.priceLabel.attributedText = priceAttrString;
    
    [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        CGSize priceSize = [priceText sizeForFontsize:fScreen(40)];
        make.width.mas_equalTo(priceSize.width);
    }];
}

- (void)setNavigationController:(UINavigationController *)navigationController
{
    _navigationController = navigationController;
    
    self.otherGroupsView.navController = _navigationController;
}

- (void)setGoodsModel:(GoodsDetailModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    [self initUI];
}

- (void)endTimer
{
    [self.timer invalidate];
    [((GoodsGroupOhterGroupTabView *)self.otherGroupsView) endTimer];
}

- (void)initUI
{
    [self setBackgroundColor:viewControllerBgColor];
    
    [self addCycleView];
    
    // 名称
    [self addGoodsNameView];
    
    // 服务/分销
    [self addServiceView];
    
    // 同类团购
    [self addOtherGroupsView];
    
    // 规则
    [self addRuleView];
    
    // 评价
    [self addEvaluateView];
    
    // 店铺信息
    [self addShopView];
    
    [self addCollectionHeaderView];
}

- (void)addOtherGroupsView
{
    [self addSubview:self.otherGroupsView];
    [self.otherGroupsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.goodsServiceView.mas_bottom).offset(fScreen(10));
        make.height.mas_equalTo(fScreen(52 + (127 + 20)*self.goodsModel.otherGroupsArray.count));
    }];
}

// 规则
- (void)addRuleView
{
    UIView *ruleView = [[UIView alloc] init];
    [ruleView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:ruleView];
    self.rulesView = ruleView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [titleLabel setTextColor:HexColor(0x333333)];
    [titleLabel setText:@"秒杀团规则"];
    [ruleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ruleView).offset(fScreen(28));
        make.top.equalTo(ruleView).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(24));
        make.right.equalTo(ruleView.mas_centerX);
    }];
    
    // 倒计时
    // 秒
    UILabel *secondLabel = [self timeLabel];
    [ruleView addSubview:secondLabel];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ruleView).offset(-fScreen(28));
        make.centerY.equalTo(titleLabel);
        make.width.mas_equalTo(fScreen(30));
        make.height.mas_equalTo(fScreen(30));
    }];
    self.secondLabel = secondLabel;
    
    UILabel *colonView1 = [[UILabel alloc] init];
    [colonView1 setText:@":"];
    [colonView1 setTextColor:HexColor(0xe44a62)];
    [colonView1 setTextAlignment:NSTextAlignmentCenter];
    
    [ruleView addSubview:colonView1];
    [colonView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(secondLabel.mas_left);
        make.centerY.equalTo(secondLabel);
        make.width.mas_equalTo(fScreen(18));
        make.height.mas_equalTo(fScreen(30));
    }];
    
    // 分
    UILabel *minLabel = [self timeLabel];
    [ruleView addSubview:minLabel];
    [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(colonView1.mas_left);
        make.centerY.width.height.equalTo(secondLabel);
    }];
    self.minLabel = minLabel;
    
    UILabel *colonView2 = [[UILabel alloc] init];
    [colonView2 setText:@":"];
    [colonView2 setTextColor:HexColor(0xe44a62)];
    [colonView2 setTextAlignment:NSTextAlignmentCenter];
    
    [ruleView addSubview:colonView2];
    [colonView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(minLabel.mas_left);
        make.centerY.width.height.equalTo(colonView1);
    }];
    
    // 小时
    UILabel *hourLabel = [self timeLabel];
    [ruleView addSubview:hourLabel];
    [hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(colonView2.mas_left);
        make.centerY.width.height.equalTo(secondLabel);
    }];
    self.hourLabel = hourLabel;
    
    UILabel *limitLabel = [[UILabel alloc] init];
    [limitLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [limitLabel setTextColor:HexColor(0x333333)];
    [limitLabel setTextAlignment:NSTextAlignmentRight];
    [limitLabel setText:@"还剩"];
    [ruleView addSubview:limitLabel];
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(hourLabel.mas_left).offset(-fScreen(16));
        make.centerY.equalTo(titleLabel);
        make.height.mas_equalTo(fScreen(24));
        make.width.mas_equalTo(fScreen(100));
    }];
    
    // 规则
    CGFloat y = fScreen(20 + 24 + 28);
    for (NSString *rule in self.goodsModel.rulesArray) {
        UIView *ruleSubView = [self makeSingleRuleViewWithText:rule];
        [ruleView addSubview:ruleSubView];
        CGFloat height = ruleSubView.frame.size.height;
        [ruleSubView setFrame:CGRectMake(0, y, kAppWidth, height)];
        
        y += height + fScreen(10);
    }
    
    // 开启倒计时
    self.time = self.goodsModel.endTime;
    [self starTimer];
    
    
    [ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.otherGroupsView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(y + fScreen(12));
    }];
}

- (UIView *)makeSingleRuleViewWithText:(NSString *)text
{
    UIView *view = [[UIView alloc] init];
    
    UIView *point = [[UIView alloc] init];
    [point.layer setCornerRadius:fScreen(8/2)];
    [point setBackgroundColor:HexColor(0x999999)];
    [view addSubview:point];
    [point mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(fScreen(28));
        make.height.mas_equalTo(fScreen(8));
        make.width.mas_equalTo(fScreen(8));
        make.top.equalTo(view).offset(fScreen(24 - 8)/2);
    }];
    
    HDLabel *label = [[HDLabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [label setTextColor:HexColor(0x999999)];
    [label setWidth:kAppWidth - fScreen(28 * 2 + 18)];
    [label setLineSpace:fScreen(10)];
    [label setNumberOfLines:0];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setText:text];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.left.equalTo(point.mas_right).offset(fScreen(10));
        make.right.equalTo(view).offset(-fScreen(28));
        make.height.mas_equalTo(label.textHeight);
    }];
    
    [view setFrame:CGRectMake(0, 0, 0, label.textHeight)];
    
    return view;
}

- (UILabel *)timeLabel
{
    UILabel *label = [[UILabel alloc] init];
    [label setBackgroundColor:HexColor(0xe44a62)];
    [label setFont:[UIFont systemFontOfSize:fScreen(20)]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label.layer setCornerRadius:fScreen(8)];
    [label.layer setMasksToBounds:YES];
    
    return label;
}

- (void)addCollectionHeaderView
{
    UIView *bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.goodsShopView.mas_bottom).offset(fScreen(20));
        make.bottom.equalTo(self.mas_bottom).offset(-fScreen(20));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [label setTextColor:HexColor(0x333333)];
    [label setText:@"同店好货推荐"];
    
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(bgView);
        make.left.equalTo(bgView.mas_left).offset(fScreen(28));
    }];
}

// 店铺
- (void)addShopView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.goodsEvaluateView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(160));
    }];
    self.goodsShopView = view;
    
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(toShopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.equalTo(view);
    }];
    
    UIImageView *shopIcon = [[UIImageView alloc] init];
    [shopIcon sd_setImageWithURL:[NSURL URLWithString:self.goodsModel.shopIconUrl] placeholderImage:[UIImage imageNamed:@"img_load_square"]];
    [view addSubview:shopIcon];
    [shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(view.mas_left).offset(fScreen(28));
        make.width.mas_equalTo(fScreen(122));
        make.height.mas_equalTo(fScreen(122));
    }];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more2"]];
    [view addSubview:arrowView];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-fScreen(28));
        make.centerY.equalTo(view.mas_centerY);
        make.width.mas_equalTo(fScreen(14));
        make.height.mas_equalTo(fScreen(24));
    }];
    
    UILabel *toShopLabel = [[UILabel alloc] init];
    [toShopLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [toShopLabel setTextColor:HexColor(0x666666)];
    [toShopLabel setTextAlignment:NSTextAlignmentRight];
    [toShopLabel setText:@"进店逛逛"];
    [view addSubview:toShopLabel];
    [toShopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowView.mas_left).offset(-fScreen(10));
        make.centerY.equalTo(view.mas_centerY);
        make.height.mas_equalTo(fScreen(24));
        make.width.mas_equalTo(fScreen(100));
    }];
    
    UILabel *shopNameLabel = [[UILabel alloc] init];
    [shopNameLabel setFont:[UIFont systemFontOfSize:fScreen(30)]];
    [shopNameLabel setTextColor:HexColor(0x666666)];
    [shopNameLabel setText:self.goodsModel.shopName];
    [view addSubview:shopNameLabel];
    [shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopIcon.mas_right).offset(fScreen(20));
        make.top.equalTo(view).offset(fScreen(38));
        make.right.equalTo(toShopLabel.mas_left).offset(-fScreen(10));
        make.height.mas_equalTo(fScreen(30));
    }];
    
    UIImageView *approveImage = [[UIImageView alloc] init];
    [approveImage setImage:[UIImage imageNamed:@"goods_shop_icon"]];
    [view addSubview:approveImage];
    [approveImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopIcon.mas_right).offset(fScreen(20));
        make.bottom.equalTo(view).offset(-fScreen(40));
        make.height.mas_equalTo(fScreen(34));
        make.width.mas_equalTo(fScreen(118));
    }];
}

// 评价
- (void)addEvaluateView
{
    // 计算高度
    CGFloat height = fScreen(80 * 2);
    
    for (EvaluateModel *evaModel in self.goodsModel.evaluateArray) {
        
        height += evaModel.rowHeight - fScreen(10);
    }
    
    [self addSubview:self.goodsEvaluateView];
    [self.goodsEvaluateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.rulesView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(height);
    }];
}


- (void)addServiceView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.goodsNameView.mas_bottom).offset(1);
        make.height.mas_equalTo(fScreen(148));
    }];
    self.goodsServiceView = view;
    
    // 急速
    UIView *subView1 = [self makeServiceViewCellWithTag:0];
    [view addSubview:subView1];
    [subView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(view);
        make.bottom.equalTo(view.mas_centerY).offset(1);
    }];
    
    // 促销
    UIView *subView2 = [self makeServiceViewCellWithTag:1];
    [view addSubview:subView2];
    [subView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(view);
        make.top.equalTo(view.mas_centerY).offset(1);
    }];
    
    // 我要参加
    UIButton *joinButton = [[UIButton alloc] init];
    [joinButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [joinButton setTitle:@"我要参加" forState:UIControlStateNormal];
    [joinButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
    [joinButton.layer setBorderColor:HexColor(0xe44a62).CGColor];
    [joinButton.layer setBorderWidth:1.f];
    [joinButton.layer setCornerRadius:4.f];
    [joinButton addTarget:self action:@selector(joinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [subView2 addSubview:joinButton];
    [joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(subView2).offset(-fScreen(42));
        make.centerY.equalTo(subView2);
        make.height.mas_equalTo(fScreen(46));
        make.width.mas_equalTo(fScreen(124));
    }];
}

// 名称/价格/说明等
- (void)addGoodsNameView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat height = fScreen(20);
    
    // 名称
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setNumberOfLines:2];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [nameLabel setTextColor:HexColor(0x333333)];
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(fScreen(28));
        make.top.equalTo(view).offset(fScreen(20));
        make.right.equalTo(view).offset(-fScreen(28));
        make.height.mas_equalTo(fScreen(32));
    }];
    height += [self adjustNameLabel:nameLabel text:self.goodsModel.goodsName fontSize:fScreen(32)];
    
    // 价格 分享按钮/已有参团人数的视图
    UIView *priceView = [[UIView alloc] init];
    [priceView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:priceView];
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(nameLabel.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(62));
    }];
    
    {
        // 分享按钮
        UIButton *shareButton = [[UIButton alloc] init];
        [shareButton setImage:[UIImage imageNamed:@"icon_share_red"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [priceView addSubview:shareButton];
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(priceView).offset(-fScreen(28));
            make.height.mas_equalTo(fScreen(44));
            make.width.mas_equalTo(fScreen(44));
            make.centerY.equalTo(priceView);
        }];
        
        // 竖线
        UIView *verLine = [[UIView alloc] init];
        [verLine setBackgroundColor:HexColor(0x999999)];
        [priceView addSubview:verLine];
        [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(priceView);
            make.right.equalTo(shareButton.mas_left).offset(-fScreen(20));
            make.width.mas_equalTo(1);
        }];
        
        
        // 佣金团
        UILabel *commissionGroupLabel = [[UILabel alloc] init];
        [commissionGroupLabel setFont:[UIFont systemFontOfSize:fScreen(20)]];
        [commissionGroupLabel setTextColor:[UIColor whiteColor]];
        [commissionGroupLabel setBackgroundColor:HexColor(0xe44a62)];
        [commissionGroupLabel setTextAlignment:NSTextAlignmentCenter];
        [commissionGroupLabel.layer setCornerRadius:fScreen(4.f)];
        [commissionGroupLabel.layer setMasksToBounds:YES];
        [commissionGroupLabel setText:@"佣金团"];
        [priceView addSubview:commissionGroupLabel];
        [commissionGroupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(verLine.mas_left).offset(-fScreen(20));
            make.top.equalTo(priceView);
            make.height.mas_equalTo(fScreen(32));
            make.width.mas_equalTo(fScreen(76));
        }];
        
        // 已有参团
        UILabel *groupHavePersonLabel = [[UILabel alloc] init];
        [groupHavePersonLabel setFont:[UIFont systemFontOfSize:fScreen(20)]];
        [groupHavePersonLabel setTextColor:HexColor(0x666666)];
        [groupHavePersonLabel setTextAlignment:NSTextAlignmentRight];
        NSString *groupHasNumberString = [NSString stringWithFormat:@"已有%ld人参团", self.goodsModel.hasNumber];
        [groupHavePersonLabel setText:groupHasNumberString];
        [view addSubview:groupHavePersonLabel];
        [groupHavePersonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(commissionGroupLabel);
            make.height.mas_equalTo(fScreen(20));
            make.bottom.equalTo(priceView);
            make.width.mas_equalTo(fScreen(180));
        }];
        
        // 价格
        UILabel *priceLabel = [[UILabel alloc] init];
        [priceLabel setFont:[UIFont systemFontOfSize:fScreen(40)]];
        [priceLabel setTextColor:HexColor(0xe44a62)];
        self.priceLabel = priceLabel;
        
        NSString *priceText = [NSString stringWithFormat:@"￥%@",self.goodsModel.goodsPrice];
        NSMutableAttributedString *priceAttrString = [[NSMutableAttributedString alloc] initWithString:priceText];
        NSDictionary *priceAttr = @{ NSFontAttributeName : [UIFont systemFontOfSize:fScreen(20)]};
        [priceAttrString addAttributes:priceAttr range:NSMakeRange(0, 1)];
        priceLabel.attributedText = priceAttrString;
        
        [view addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(fScreen(28));
            make.baseline.equalTo(groupHavePersonLabel);
            CGSize priceSize = [priceText sizeForFontsize:fScreen(40)];
            make.height.mas_equalTo(fScreen(40));
            make.width.mas_equalTo(priceSize.width - fScreen(15));
        }];
        
        // 佣金
        UIImage *commBgImage = [[UIImage imageNamed:@"icon_yongjin"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, fScreen(10), 1, fScreen(45))];
        
        UIImageView *commBgView = [[UIImageView alloc] initWithImage:commBgImage];
        self.commBgView = commBgView;
        
        NSString *commissionString = [NSString stringWithFormat:@"¥%@", self.goodsModel.commission];
        CGSize commisSize = [commissionString sizeForFontsize:fScreen(16)];
        
        UILabel *commLabel = [[UILabel alloc] init];
        [commLabel setFont:[UIFont systemFontOfSize:fScreen(16)]];
        [commLabel setTextColor:[UIColor whiteColor]];
        [commLabel setText:commissionString];
        [commBgView addSubview:commLabel];
        [commLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commBgView).offset(fScreen(10));
            make.right.equalTo(commBgView).offset(-fScreen(45));
            make.height.mas_equalTo(fScreen(16));
            make.centerY.equalTo(commBgView);
        }];
        
        [priceView addSubview:commBgView];
        [commBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceLabel.mas_right).offset(fScreen(10));
            make.bottom.equalTo(priceView);
            make.height.mas_equalTo(fScreen(25));
            make.width.mas_equalTo(commisSize.width + 2 + fScreen(10 + 45));
        }];
    }
    
    height += fScreen(62 + 20);
    
    
    // 说明文字
    HDLabel *goodsInfoLabel = [[HDLabel alloc] init];
    [goodsInfoLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [goodsInfoLabel setTextColor:HexColor(0x999999)];
    [goodsInfoLabel setNumberOfLines:0];
    [goodsInfoLabel setWidth:kAppWidth - fScreen(28*2)];
    [goodsInfoLabel setLineSpace:fScreen(8)];
    [goodsInfoLabel setAdjustsFontSizeToFitWidth:YES];
    [goodsInfoLabel setText:self.goodsModel.goodsInfoString];
    [view addSubview:goodsInfoLabel];
    [goodsInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(fScreen(28));
        make.right.equalTo(view).offset(-fScreen(28));
        make.top.equalTo(priceView.mas_bottom).offset(fScreen(18));
        make.height.mas_equalTo(goodsInfoLabel.textHeight);
    }];
    
    height += fScreen(20) + goodsInfoLabel.textHeight + fScreen(20);
    
    // 免运费
    UILabel *fromPlaceLabel = [[UILabel alloc] init];
    [fromPlaceLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [fromPlaceLabel setTextAlignment:NSTextAlignmentCenter];
    [fromPlaceLabel setTextColor:HexColor(0x999999)];
    [fromPlaceLabel setBackgroundColor:RGB(245, 245, 245)];
    [fromPlaceLabel.layer setCornerRadius:fScreen(6.f)];
    [fromPlaceLabel.layer setMasksToBounds:YES];
    [fromPlaceLabel setText:[NSString stringWithFormat:@"从%@发货", self.goodsModel.fromPlace]];
    [view addSubview:fromPlaceLabel];
    [fromPlaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(goodsInfoLabel);
        make.top.equalTo(goodsInfoLabel.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(50));
    }];
    
    UILabel *mianyunfeiLabel = [[UILabel alloc] init];
    [mianyunfeiLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [mianyunfeiLabel setTextColor:fromPlaceLabel.textColor];
    [mianyunfeiLabel setText:@"免运费"];
    [view addSubview:mianyunfeiLabel];
    [mianyunfeiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fromPlaceLabel).offset(fScreen(30));
        make.top.bottom.right.equalTo(fromPlaceLabel);
    }];
    
    height += fScreen(52 + 20);
    
    // 横线
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(fromPlaceLabel.mas_bottom).offset(fScreen(20));
        make.height.equalTo(@1);
    }];
    
    // 厂家/包邮/正品
    CGFloat x = fScreen(28);
    CGFloat width = fScreen(148);
    for (NSInteger index = 0; index < 3; index++) {
        UIView *iconView = [self makeIconViewWithTag:index];
        [view addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.left.equalTo(view).offset(x);
            make.top.equalTo(lineView.mas_bottom).offset(1);
            make.height.mas_equalTo(fScreen(54));
        }];
        x += fScreen(30) + width;
    }
    
    height += fScreen(54) + 2;
    
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.cycleView.mas_bottom);
        make.height.mas_equalTo(height);
    }];
    self.goodsNameView = view;
}

// 轮播图
- (void)addCycleView
{
    SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"img_load_rect"]];
    NSArray *picArray = @[@"http://pic.58pic.com/58pic/17/37/33/29A58PICGX5_1024.jpg", @"http://pic.90sjimg.com/back_pic/00/04/27/49/d729357f0fdf8eaec3433cb495949ede.jpg", @"http://pic2.ooopic.com/12/80/79/89bOOOPICd2_1024.jpg"];
    cycleView.imageURLStringsGroup = picArray;
    [self addSubview:cycleView];
    [cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kAppWidth);
    }];
    self.cycleView = cycleView;
}

#pragma mark - button click

- (void)shareButtonClick:(UIButton *)sender
{
    if (self.shareBlock) {
        self.shareBlock();
    }
}

- (void)joinButtonClick:(UIButton *)sender
{
    if (self.joinBlock) {
        self.joinBlock();
    }
}

- (void)toEvaluateView:(UIButton *)sender
{
    if (self.toEvaluteBlock) {
        self.toEvaluteBlock();
    }
}

// 跳转店铺页面
- (void)toShopButtonClick:(UIButton *)sender
{
    if (self.toShopBlock) {
        self.toShopBlock(self.goodsModel.shopId);
    }
}

#pragma mark - helper
// 开启定时器,用于倒计时
- (void)starTimer
{
    if (!self.timer) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:@"" repeats:YES];
        self.timer = timer;
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
}

- (void)refreshLessTime
{
    self.time = --self.time;
}

- (CGFloat)adjustNameLabel:(UILabel *)label
                      text:(NSString *)text
                  fontSize:(CGFloat)fontSize
{
    [label setText:text];
    
//    CGFloat labelWidth = kAppWidth - fScreen(30 + 40 + 30 + 160 + 20 + 30);
    CGFloat labelWidth = kAppWidth - fScreen(30 + 30);
    
    CGSize labelSize = CGSizeMake(labelWidth, MAXFLOAT);
    CGSize textSize = [label.text boundingRectWithSize:labelSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil].size;
    
    CGFloat textHeight = [@"高度" sizeForFontsize:fontSize].height;
    CGFloat maxHeight = textHeight * 2 + fScreen(5);
    CGFloat height = textSize.height > maxHeight ? maxHeight : textSize.height;
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
    return height;
}

// 创建 厂家直供/全场包邮/正品保障 视图
- (UIView *)makeIconViewWithTag:(NSInteger)tag
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.width.mas_equalTo(fScreen(33));
        make.height.mas_equalTo(fScreen(33));
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [label setTextColor:HexColor(0x999999)];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(fScreen(10));
        make.centerY.equalTo(imageView.mas_centerY);
        make.right.equalTo(view);
        CGSize textSize = [@"" sizeForFontsize:fScreen(24)];
        make.height.mas_equalTo(textSize.height);
    }];
    
    NSString *imageName;
    NSString *labelText;
    if (tag == 0) {
        imageName = @"供应商";
        labelText = @"厂家直供";
    }
    else if (tag == 1) {
        imageName = @"物流";
        labelText = @"全场包邮";
    }
    else {
        imageName = @"盾牌(1)";
        labelText = @"正品保障";
    }
    
    [imageView setImage:[UIImage imageNamed:imageName]];
    [label setText:labelText];
    
    return view;
}

- (UIView *)makeServiceViewCellWithTag:(NSInteger)tag
{
    UIView *cellView = [[UIView alloc] init];
    [cellView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [cellView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cellView);
        make.left.equalTo(cellView).offset(fScreen(28));
        make.width.mas_equalTo(fScreen(54));
        make.height.mas_equalTo(fScreen(32));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [label setTextColor:HexColor(0x999999)];
    [cellView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(fScreen(10));
        make.right.equalTo(cellView).offset(-fScreen(28));
        make.top.bottom.equalTo(cellView);
    }];
    
    NSString *imageName;
    NSString *labelText;
    if (tag == 0) {
        imageName = @"icon_jisu";
        labelText = @"24小时内急速发货";
        UIView *lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:viewControllerBgColor];
        [cellView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellView.mas_left).offset(fScreen(28));
            make.right.equalTo(cellView.mas_right).offset(-fScreen(28));
            make.bottom.equalTo(cellView.mas_bottom);
            make.height.equalTo(@1);
        }];
    }
    else {
        imageName = @"icon_fenxiang";
        labelText = self.goodsModel.salePromote;
    }
    [imageView setImage:[UIImage imageNamed:imageName]];
    [label setText:labelText];
    
    return cellView;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}

#pragma mark
#pragma mark - 评论相关
#pragma mark - tableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsModel.evaluateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluateTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (!cell) {
        cell = [[EvaluateTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    EvaluateModel *model = [self.goodsModel.evaluateArray objectAtIndex:indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluateModel *model = [self.goodsModel.evaluateArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == self.goodsModel.evaluateArray.count - 1) {
        return model.rowHeight - fScreen(10) - 3;   // 最后一行的横线不显示
    }
    
    return model.rowHeight - fScreen(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *topLine = [[UIView alloc] init];
    [topLine setBackgroundColor:HexColor(0xcecece)];
    [headerView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(headerView);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    [infoLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [infoLabel setTextColor:HexColor(0x333333)];
    [infoLabel setText:[NSString stringWithFormat:@"商品评价(%ld人)", self.goodsModel.evaluateNumber]];
    [headerView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(headerView);
        make.left.equalTo(headerView).offset(fScreen(26));
    }];
    
    UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more1"]];
    [headerView addSubview:arrowImage];
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-fScreen(26));
        make.height.mas_equalTo(fScreen(fScreen(28)));
        make.width.mas_equalTo(fScreen(28/2));
        make.centerY.equalTo(headerView);
    }];
    
    UILabel *presentLabel = [[UILabel alloc] init];
    [presentLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [presentLabel setTextColor:HexColor(0xe44a62)];
    [presentLabel setTextAlignment:NSTextAlignmentRight];
    [presentLabel setText:[NSString stringWithFormat:@"%@%好评", self.goodsModel.goodEvaluatePre]];
    [headerView addSubview:presentLabel];
    [presentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImage.mas_left).offset(-fScreen(10));
        make.top.bottom.left.equalTo(headerView);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    [bottomLine setBackgroundColor:topLine.backgroundColor];
    [headerView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(fScreen(26));
        make.right.equalTo(headerView).offset(-fScreen(26));
        make.bottom.equalTo(headerView);
        make.height.mas_equalTo(0.5);
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return fScreen(80);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] init];
    [footer setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"查看全部评论" forState:UIControlStateNormal];
    [button setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [button.layer setBorderColor:HexColor(0xe44a62).CGColor];
    [button.layer setBorderWidth:1.f];
    [button.layer setCornerRadius:fScreen(8)];
    [button addTarget:self action:@selector(toEvaluateView:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(footer);
        make.height.mas_equalTo(fScreen(52));
        make.width.mas_equalTo(fScreen(186));
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:HexColor(0xcecece)];
    [footer addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(footer);
        make.height.mas_equalTo(1);
    }];
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return fScreen(80);
}

#pragma mark - Getter
- (UIView *)goodsEvaluateView
{
    if (!_goodsEvaluateView) {
        _goodsEvaluateView = [[UIView alloc] init];
        [_goodsEvaluateView setBackgroundColor:[UIColor whiteColor]];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [tableView setDataSource:self];
        [tableView setDelegate:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_goodsEvaluateView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(_goodsEvaluateView);
        }];
    }
    
    return _goodsEvaluateView;
}

- (GoodsGroupOhterGroupTabView *)otherGroupsView
{
    if (!_otherGroupsView) {
        GoodsGroupOhterGroupTabView *otherList = [[GoodsGroupOhterGroupTabView alloc] initWithData:self.goodsModel.otherGroupsArray];
        _otherGroupsView = otherList;
    }
    return _otherGroupsView;
}

#pragma mark - Setter
- (void)setTime:(NSUInteger)time
{
    _time = time;
    
    NSArray *timeArray = [self getTime:time];
    
    self.hourLabel.text   = [NSString stringWithFormat:@"%02ld", [timeArray[0] integerValue]];
    self.minLabel.text    = [NSString stringWithFormat:@"%02ld", [timeArray[1] integerValue]];
    self.secondLabel.text = [NSString stringWithFormat:@"%02ld", [timeArray[2] integerValue]];
}

- (NSArray *)getTime:(NSUInteger)seconds
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:3];
    
    NSUInteger hour = (NSUInteger)(seconds%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(seconds%(3600))/60;
    NSUInteger second = (NSUInteger)(seconds%60);
    
    [tmpArray addObject:[NSNumber numberWithInteger:hour]];
    [tmpArray addObject:[NSNumber numberWithInteger:min]];
    [tmpArray addObject:[NSNumber numberWithInteger:second]];
    
    return [tmpArray copy];
}

@end
