//
//  BaiXianBaiPinHeaderView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/22.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *headerIdentity = @"BaiXianBaiPinHeaderViewIdentity";

typedef void(^BaixianbaipinBannerBlock)(NSInteger index);

@interface BaiXianBaiPinHeaderView : UIView

@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, copy) BaixianbaipinBannerBlock bannerBlock;


@end
