//
//  GoodsDetailPhotoController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/16.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GoodsDetailPhotoController.h"
#import "HDPageViewController.h"
#import "GoodsImagesController.h"
#import "GoodsSpecParamsController.h"
#import "GoodsRecommendController.h"
#import <Masonry.h>

@interface GoodsDetailPhotoController ()

@property (nonatomic, strong) HDPageViewController *pageViewController;

@property (nonatomic, strong) NSArray *imagesArray;     // 图片数组
@property (nonatomic, strong) NSArray *paramsArray;     // 参数数组

@end

@implementation GoodsDetailPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];

    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData
{
    // 图片数据
    NSArray *imageArray = @[@"http://cdn.duitang.com/uploads/item/201501/04/20150104111550_XvfrL.thumb.700_0.jpeg",
                            @"http://v1.qzone.cc/pic/201510/02/18/03/560e56604d210987.jpg%21600x600.jpg",
                            @"http://img3.duitang.com/uploads/item/201601/24/20160124175729_saBW3.thumb.700_0.jpeg",
                            @"http://img5.duitang.com/uploads/item/201509/03/20150903132822_JajfM.thumb.224_0.png",
                            @"http://cdn.duitang.com/uploads/item/201601/24/20160124175328_sReBE.thumb.700_0.jpeg",
                            @"http://cdn.duitang.com/uploads/item/201506/08/20150608224757_jkc5t.jpeg",
                            @"http://imgsrc.baidu.com/forum/w=580/sign=8050a3ae5fee3d6d22c687c373176d41/82083d6d55fbb2fb927be81b494a20a44723dc4a.jpg",
                            @"http://reso2.yiihuu.com/895579-z.jpg",
                            @"http://img3.imgtn.bdimg.com/it/u=2208144604,395398151&fm=21&gp=0.jpg",
                            @"http://cdn.duitang.com/uploads/item/201501/04/20150104111550_XvfrL.thumb.700_0.jpeg",
                            @"http://v1.qzone.cc/pic/201510/02/18/03/560e56604d210987.jpg%21600x600.jpg",
                            @"http://img3.duitang.com/uploads/item/201601/24/20160124175729_saBW3.thumb.700_0.jpeg",
                            @"http://img5.duitang.com/uploads/item/201509/03/20150903132822_JajfM.thumb.224_0.png",
                            @"http://cdn.duitang.com/uploads/item/201601/24/20160124175328_sReBE.thumb.700_0.jpeg",
                            @"http://cdn.duitang.com/uploads/item/201506/08/20150608224757_jkc5t.jpeg",
                            @"http://imgsrc.baidu.com/forum/w=580/sign=8050a3ae5fee3d6d22c687c373176d41/82083d6d55fbb2fb927be81b494a20a44723dc4a.jpg",
                            @"http://reso2.yiihuu.com/895579-z.jpg"];
    self.imagesArray = imageArray;
    
    // 参数数据
    NSArray *paramsArray = @[@[@"商品名称",@"大哥哥家达拉斯电视剧奥数的几率辣的省略号好哈利登录啊啊哈喽"],
                             @[@"产地",@"拉斯维加斯"],
                             @[@"适合年龄",@"二八姑娘"],
                             @[@"商品品牌",@"狂拽炫酷吊炸天"]];
    self.paramsArray = paramsArray;
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
  
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(1);
    }];
    
    // 添加竖线
    CGSize textSize = [@"规格参数" sizeForFontsize:fScreen(28)];
    
    UIView *lineViewLeft = [[UIView alloc] init];
    [lineViewLeft setBackgroundColor:viewControllerBgColor];
    [self.view addSubview:lineViewLeft];
    [lineViewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-(textSize.width/2 + fScreen(60)));
        make.height.mas_equalTo(fScreen(36));
        make.width.equalTo(@2);
        make.top.equalTo(self.view.mas_top).offset(fScreen(32));
    }];
    
    UIView *lineViewRight = [[UIView alloc] init];
    [lineViewRight setBackgroundColor:viewControllerBgColor];
    [self.view addSubview:lineViewRight];
    [lineViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(textSize.width/2 + fScreen(60));
        make.height.mas_equalTo(fScreen(36));
        make.width.equalTo(@2);
        make.top.equalTo(self.view.mas_top).offset(fScreen(32));
    }];
}

#pragma mark - button click
// 跳转店铺页面
- (void)toShopButtonClick:(UIButton *)sender
{

}


#pragma mark - Getter
- (HDPageViewController *)pageViewController
{
    if (!_pageViewController) {
        NSArray *titles = @[@"图文详情", @"规格参数" ,@"为你推荐"];
        
        GoodsImagesController *imagesVC = [[GoodsImagesController alloc] init];
        imagesVC.imagesArray = self.imagesArray;
        
        
        GoodsSpecParamsController *specParamsVC = [[GoodsSpecParamsController alloc] init];
        specParamsVC.textArray = self.paramsArray;
        
        GoodsRecommendController *recommendVC = [[GoodsRecommendController alloc] init];
        NSArray *controllers = @[imagesVC, specParamsVC, recommendVC];
        
//        CGSize textSize = [@"图文详情" sizeForFontsize:fScreen(28)];
        
        _pageViewController = [[HDPageViewController alloc] initWithFrame:CGRectZero titles:titles titleMargin:fScreen(60*2) titleHeight:fScreen(100) firstTitleMargin:fScreen(60) titleFontSize:fScreen(32) controllers:controllers];
        [_pageViewController setIsShowTitleLine:NO];
        [_pageViewController setNormalTitleColor:HexColor(0x666666)];
        [_pageViewController setCurrTitleColor:HexColor(0xe44a62)];
    }
    return _pageViewController;
}

@end
