//
//  HDImageScrollView.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/7.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDCarouselPicView.h"

#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface HDCarouselPicView () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIPageControl    *pageControl;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *imageViewsArray;
@property (nonatomic, copy) NSString *placeholderName;

@property (nonatomic, strong) NSTimer *timer;

@end

static NSString *identity = @"HDCarouselPicViewCellIdentity";

@implementation HDCarouselPicView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray placeholder:(NSString *)placeholderName
{
    if (self = [super initWithFrame:frame]) {
        
        [self initDataWithArray:dataArray placeholderName:placeholderName];
        
        [self initUI];
    }
    return self;
}

- (void)initDataWithArray:(NSArray *)array placeholderName:(NSString *)placeholderName
{
//    NSMutableArray *tempArray = [NSMutableArray array];
//    NSInteger count = [array count];
//    
//    CGRect imageFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
//    for (NSInteger index = 0; index < count; index++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:array[index]] placeholderImage:[UIImage imageNamed:placeholderName]];
    
//        if (index%2 == 0) {
//            [imageView setBackgroundColor:[UIColor redColor]];
//        }
//        else if (index%3 == 0) {
//            [imageView setBackgroundColor:[UIColor blueColor]];
//        }
//        else {
//            [imageView setBackgroundColor:[UIColor greenColor]];
//        }
        
//        [tempArray addObject:imageView];
//    }
//    
//    self.imageViewsArray = tempArray;
    
    self.imageViewsArray = array;
    self.placeholderName = placeholderName;
}

- (void)initUI
{
    // collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CGRect collRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collRect collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[HDCarouselPicViewCell class] forCellWithReuseIdentifier:identity];
    collectionView.contentOffset = CGPointMake(self.frame.size.width, 0);
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    // pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.imageViewsArray.count;
    pageControl.currentPage = 0;
    CGSize pageSize = [pageControl sizeForNumberOfPages:pageControl.numberOfPages];
    self.pageControl = pageControl;
    [self addSubview:self.pageControl];
    
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(pageSize.width);
        make.height.mas_equalTo(pageSize.height);
    }];
    
    [self addTimerWithOffset:0];
}

#pragma mark - collectionView dataSource & delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imageViewsArray count] + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HDCarouselPicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        NSString *urlString = [NSString stringWithFormat:@"%@",[self.imageViewsArray objectAtIndex:self.imageViewsArray.count - 1]];
        
        [cell.imageShowView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:self.placeholderName]];
    }
    else if (indexPath.item == self.imageViewsArray.count + 2 - 1) {
        NSString *urlString = [NSString stringWithFormat:@"%@",[self.imageViewsArray objectAtIndex:0]];
        
        [cell.imageShowView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:self.placeholderName]];
    }
    else {
        
        NSString *urlString = [NSString stringWithFormat:@"%@",[self.imageViewsArray objectAtIndex:indexPath.item - 1]];
        
        [cell.imageShowView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:self.placeholderName]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.carouselPicClickBlock) {
        self.carouselPicClickBlock(self);
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger number = [[NSNumber numberWithFloat:offsetX/self.frame.size.width] integerValue];
    
    if (number == 0) {
        self.collectionView.contentOffset = CGPointMake((self.imageViewsArray.count - 1) * self.frame.size.width, 0);
        self.pageControl.currentPage = self.imageViewsArray.count - 1;
    }
    else if (number == self.imageViewsArray.count + 2 - 1) {
        self.collectionView.contentOffset = CGPointMake(self.frame.size.width, 0);
        self.pageControl.currentPage = 0;
    }
    else {
        self.pageControl.currentPage = number - 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimerWithOffset:scrollView.contentOffset.x];
}

- (void)addTimerWithOffset:(CGFloat)offset
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(toNext:) userInfo:nil repeats:YES];
}

- (void)toNext:(NSInteger)currOffset
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.collectionView setContentOffset:CGPointMake(currOffset + self.frame.size.width, 0)];
    }];
}

@end


/**
    HDImageScrollViewCell
 */

@implementation HDCarouselPicViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageShowView = imageView;
        [self addSubview:self.imageShowView];
    }
    return self;
}

- (void)setImageShowView:(UIImageView *)imageShowView
{
    _imageShowView.backgroundColor = imageShowView.backgroundColor;
}

@end
