//
//  GoodsDetailCollHeaderView.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/16.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GoodsDetailCollHeaderView.h"
#import <Masonry.h>
#import <SDCycleScrollView.h>
#import <UIImageView+WebCache.h>
#import "EvaluateModel.h"
#import "EvaluateTabCell.h"


@interface GoodsDetailCollHeaderView () <UITableViewDataSource, UITableViewDelegate ,SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleView;
@property (nonatomic, strong) UIView *goodsNameView;            // 名称/价格
@property (nonatomic, strong) UIView *goodsServiceView;         // 服务
@property (nonatomic, strong) UIView *goodsSpecView;            // 规格
@property (nonatomic, strong) UIView *goodsEvaluateView;        // 评价
@property (nonatomic, strong) UIView *goodsShopView;            // 店铺

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *marketPriceLabel;
//@property (nonatomic, strong) UICollectionView *recommendView;  // 推荐商品
//@property (nonatomic, strong) UIView *bottomView;               // 底部视图

@end

@implementation GoodsDetailCollHeaderView

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
    
    [self.marketPriceLabel layoutIfNeeded];
}

- (void)setGoodsModel:(GoodsDetailModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    [self initUI];
}
- (void)initUI
{
    [self setBackgroundColor:viewControllerBgColor];
    
    [self addCycleView];
    
    // 名称
    [self addGoodsNameView];
    
    // 服务/分销
    [self addServiceView];
    
    // 规格
    [self addSpecView];
    
    // 评价
    [self addEvaluateView];
    
    // 店铺信息
    [self addShopView];
    
    [self addCollectionHeaderView];
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

- (void)addShopView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.goodsEvaluateView.mas_bottom).offset(self.goodsModel.evaluateArray.count > 0 ? fScreen(20) : 0);
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

- (void)addEvaluateView
{
    // 计算高度
    CGFloat height ;
    
    if (self.goodsModel.evaluateArray.count > 0) {
        
        height = fScreen(80 * 2);
        
        for (EvaluateModel *evaModel in self.goodsModel.evaluateArray) {
            
            height += evaModel.rowHeight - fScreen(10);
        }
    }
    else {
        height = 1;
    }
    
    [self addSubview:self.goodsEvaluateView];
    [self.goodsEvaluateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.goodsSpecView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(height);
    }];
}

- (void)addSpecView
{
    NSInteger specCount = self.goodsModel.showSpecArray.count;
    CGFloat viewHeight = specCount * fScreen(28 + 20) + fScreen(20);
    
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.goodsServiceView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(viewHeight);
    }];
    self.goodsSpecView = view;
    
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(specButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(view);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"icon_more1"]];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.right.equalTo(view).offset(-fScreen(28));
        make.height.mas_equalTo(fScreen(30));
        make.width.mas_equalTo(fScreen(17));
    }];
    
    CGFloat x = fScreen(28);
    CGFloat y = fScreen(20);
    CGFloat width = kAppWidth - fScreen(28 * 2);
    CGFloat height = fScreen(28);
    for (NSInteger index = 0; index < specCount; index++) {
        UILabel *label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [label setTextColor:HexColor(0x666666)];
        [label setText:[NSString stringWithFormat:@"%@",[self.goodsModel.showSpecArray objectAtIndex:index]]];
        CGRect frame = CGRectMake(x, y, width, height);
        [label setFrame:frame];
        [view addSubview:label];
        
        y += height + fScreen(20);
    }
}

- (void)addServiceView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.goodsNameView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(148));
    }];
    self.goodsServiceView = view;
    
    UIView *subView1 = [self makeServiceViewCellWithTag:0];
    [view addSubview:subView1];
    [subView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(view);
        make.bottom.equalTo(view.mas_centerY).offset(1);
    }];
    
    UIView *subView2 = [self makeServiceViewCellWithTag:1];
    [view addSubview:subView2];
    [subView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(view);
        make.top.equalTo(view.mas_centerY).offset(1);
    }];
}

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
        make.top.equalTo(nameLabel.mas_bottom).offset(fScreen(26));
        CGSize priceSize = [priceText sizeForFontsize:fScreen(40)];
        make.height.mas_equalTo(fScreen(40) - 2);
        make.width.mas_equalTo(priceSize.width - fScreen(15));
    }];
    
    height += fScreen(40 + 20);
    
    // 佣金
    UILabel *commissionLabel = [[UILabel alloc] init];
    [commissionLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [commissionLabel setTextColor:HexColor(0xe44a62)];
    [commissionLabel setTextAlignment:NSTextAlignmentRight];
    
    NSString *marketStr = [NSString stringWithFormat:@"返佣:￥%@",self.goodsModel.commission];
    NSMutableAttributedString *commissionAttrString = [[NSMutableAttributedString alloc] initWithString:marketStr];
    NSDictionary *marketAttr1 = @{NSFontAttributeName: [UIFont systemFontOfSize:fScreen(24)]};
    [commissionAttrString addAttributes:marketAttr1 range:NSMakeRange(0, 4)];
    
    NSDictionary *marketAttr2 = @{NSForegroundColorAttributeName : HexColor(0x666666)};
    [commissionAttrString addAttributes:marketAttr2 range:NSMakeRange(0, 3)];
    
    NSRange range = [marketStr rangeOfString:@"."];
    if (range.location < marketStr.length - 1) {
        [commissionAttrString addAttributes:marketAttr1 range:NSMakeRange(range.location, marketStr.length - range.location)];
    }
    [commissionLabel setAttributedText:commissionAttrString];
    
    [view addSubview:commissionLabel];
    [commissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-fScreen(28));
        make.bottom.equalTo(priceLabel);
        make.height.mas_equalTo(fScreen(32));
        CGSize textSize = [marketStr sizeForFontsize:fScreen(32)];
        make.width.mas_equalTo(textSize.width);
    }];
    
    // 原价
    UILabel *marketPriceLabel = [[UILabel alloc] init];
    self.marketPriceLabel = marketPriceLabel;
    
    [marketPriceLabel setFont:[UIFont systemFontOfSize:fScreen(20)]];
    [marketPriceLabel setTextColor:HexColor(0x666666)];
    NSMutableAttributedString *marketAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价:￥%@",self.goodsModel.marketPrice]];
    [marketAttrString addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)} range:NSMakeRange(0, marketAttrString.length)];
    [marketPriceLabel setAttributedText:marketAttrString];
    
    [view addSubview:marketPriceLabel];
    [marketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.mas_right).offset(fScreen(10));
        make.bottom.equalTo(priceLabel);
        make.height.mas_equalTo(fScreen(20));
        make.right.equalTo(commissionLabel.mas_left).offset(-fScreen(20));
    }];
    
    // 横线
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(priceLabel.mas_bottom).offset(fScreen(20));
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
    
    height += fScreen(54) + 2 + fScreen(20);
    
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.cycleView.mas_bottom);
        make.height.mas_equalTo(height);
    }];
    self.goodsNameView = view;
}

- (void)addCycleView
{
    SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"img_load_rect"]];
    
    cycleView.imageURLStringsGroup = self.goodsModel.goodsImageURLArray;
    
    [self addSubview:cycleView];
    
    [cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kAppWidth);
    }];
    
    self.cycleView = cycleView;
}

#pragma mark - button click
// 显示规格选择界面
- (void)specButtonClick:(UIButton *)sender
{
    if (self.specSelectBlock) {
        self.specSelectBlock();
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
- (CGFloat)adjustNameLabel:(UILabel *)label
                   text:(NSString *)text
               fontSize:(CGFloat)fontSize
{
    [label setText:text];
    
    CGFloat labelWidth = kAppWidth - fScreen(30 + 30);;
    
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
        imageName = @"服务";
        labelText = @"正常情况下拍下48小时内发货.";
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
        imageName = @"分销";
        labelText = @"分享赚钱,分享还可以获得返佣哦~";
    }
    [imageView setImage:[UIImage imageNamed:imageName]];
    [label setText:labelText];
    
    return cellView;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{

}

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
        make.height.mas_equalTo(fScreen(fScreen(40)));
        make.width.mas_equalTo(fScreen(20));
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

#pragma mark - button click
- (void)toEvaluateView:(UIButton *)sender
{
    if (self.toEvaluteBlock) {
        self.toEvaluteBlock();
    }
}

@end
