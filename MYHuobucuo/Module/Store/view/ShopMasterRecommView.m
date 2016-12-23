//
//  ShopMasterRecommView.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "ShopMasterRecommView.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface ShopMasterRecommView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation ShopMasterRecommView

- (instancetype)initWithRecommendArray:(NSArray *)array
{
    if (self = [super init]) {
        self.dataList = array;
        
        [self addSubview:self.collection];
        [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - collectionView dataSource & delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShopMasterRecommViewCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopMasterRecommViewCollCellIdentity forIndexPath:indexPath];
    
    ShopRecommendModel *model = (ShopRecommendModel *)[self.dataList objectAtIndex:indexPath.item];
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.clickBlock) {
        ShopRecommendModel *model = (ShopRecommendModel *)[self.dataList objectAtIndex:indexPath.item];
        
        self.clickBlock(model.goodsId);
    }
}

#pragma mark - Getter
- (UICollectionView *)collection
{
    if (!_collection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        layout.itemSize = CGSizeMake(kAppWidth/3 - 1, fScreen(250 + 20 + 48 + 20 + 24 + 20) - 1);
        
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collection setDataSource:self];
        [_collection setDelegate:self];
        [_collection setBackgroundColor:viewControllerBgColor];
        [_collection setBounces:NO];
        [_collection registerClass:[ShopMasterRecommViewCollCell class] forCellWithReuseIdentifier:ShopMasterRecommViewCollCellIdentity];
    }
    return _collection;
}

@end



#pragma mark
#pragma mark - ShopMasterRecommViewCollCell

@interface ShopMasterRecommViewCollCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *saleCountLabel;

@end

@implementation ShopMasterRecommViewCollCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(1);
        make.right.equalTo(self).offset(-1);
        make.height.mas_equalTo(fScreen(250) - 1);
    }];
    self.goodsImageView = imageView;
    
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:fScreen(32)]];
    [priceLabel setTextColor:HexColor(0xe79433)];
    [priceLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(fScreen(32));
        make.top.equalTo(imageView.mas_bottom).offset(fScreen(20));
    }];
    self.priceLabel = priceLabel;
    
    
    UILabel *saleCountLabel = [[UILabel alloc] init];
    [saleCountLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [saleCountLabel setTextColor:HexColor(0x999999)];
    [saleCountLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:saleCountLabel];
    [saleCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(priceLabel.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(24));
    }];
    self.saleCountLabel = saleCountLabel;
}

- (void)setModel:(ShopRecommendModel *)model
{
    _model = model;
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageURL] placeholderImage:[UIImage imageNamed:@"img_load_square"]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", model.goodsPrice];
    self.saleCountLabel.text = [NSString stringWithFormat:@"售%ld",model.saleNumber];
}

@end
