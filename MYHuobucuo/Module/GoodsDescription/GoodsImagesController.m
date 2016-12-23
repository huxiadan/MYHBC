//
//  GoodsImagesController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/16.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GoodsImagesController.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface GoodsImagesController ()

@property (nonatomic, strong) UIScrollView *imageListView;

@property (nonatomic, strong) NSArray *rowHeightArray;

@end

@implementation GoodsImagesController

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(fScreen(4));
        make.bottom.equalTo(self.view).offset(-fScreen(88) - 20);
    }];
    self.imageListView = scrollView;
    
    [self downloadImages];
}

- (void)downloadImages
{
    NSArray *imageArray = self.imagesArray;
    if (imageArray.count > 0) {
        
        __block CGFloat y = 0;
        
        for (NSInteger index = 0; index < imageArray.count; index++) {
            NSString *urlString = [NSString stringWithFormat:@"%@",[imageArray objectAtIndex:index]];
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setTag:index];
            [self.imageListView addSubview:imageView];
            
            __weak typeof(self) weakSelf = self;
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"img_load_square"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (image) {
                    if (image.size.width > 0 && image.size.height > 0) {
                        CGFloat imageHeight = kAppWidth*image.size.height/image.size.width;
                        [imageView setFrame:CGRectMake(0, y, kAppWidth, imageHeight)];
                        
                        [weakSelf.imageListView addSubview:imageView];
                        
                        y += imageHeight;
                        
                        CGFloat contentHeight = y + fScreen(112 + 20);
                        [weakSelf.imageListView setContentSize:CGSizeMake(0, contentHeight)];
                    }
                }
            }];
        };
    }
}

@end
