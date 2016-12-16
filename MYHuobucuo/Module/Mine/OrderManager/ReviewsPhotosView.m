//
//  ReviewsPhotosView.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/15.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "ReviewsPhotosView.h"
#import <Masonry.h>
#import "LGPhoto.h"

#define photoMaxCount 4

@interface ReviewsPhotosView () <LGPhotoPickerViewControllerDelegate,
                                 LGPhotoPickerBrowserViewControllerDelegate,
                                 LGPhotoPickerBrowserViewControllerDataSource>

@property (nonatomic, strong) NSArray<LGPhotoPickerBrowserPhoto *> *photosArray;       // 图片数组

@property (nonatomic, strong) NSArray<ReviewPhotoTmpObject *> *photosButtonArray;// 图片视图和对应的删除按钮的数组

@end

@implementation ReviewsPhotosView

- (instancetype)init
{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    CGFloat x = fScreen(28);
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger index = 0; index < photoMaxCount; index++) {
        
        UIButton *imageButton = [[UIButton alloc] init];
        [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [imageButton setTag:index];
        [self addSubview:imageButton];
        
        ReviewPhotoTmpObject *tmpObject = [[ReviewPhotoTmpObject alloc] init];
        
        // 删除按钮
        
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setTag:index];
        [deleteButton setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageButton.mas_right);
            make.centerY.equalTo(imageButton.mas_top);
            make.width.height.mas_equalTo(fScreen(18*2 + 20*2));
        }];
        
        [deleteButton setHidden:YES];
        [imageButton setHidden:YES];
        
        tmpObject.deleteButton = deleteButton;
        
        if (index == 0) {
            [imageButton setImage:[UIImage imageNamed:@"banner_sahngchuang"] forState:UIControlStateNormal];
            [imageButton setHidden:NO];
        }

        tmpObject.imageButton = imageButton;
        
        [imageButton setFrame:CGRectMake(x, fScreen(20 + 18), fScreen(140), fScreen(140))];
        
        x += fScreen(140 + 20);
        
        [tmpArray addObject:tmpObject];
    }
    self.photosButtonArray = tmpArray;
}

#pragma mark - button click

- (void)imageButtonClick:(UIButton *)sender
{
    if (sender.tag == 0 && self.photosArray.count < photoMaxCount) {
        // 添加图片
        LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:LGShowImageTypeImagePicker];
        pickerVc.status = PickerViewShowStatusCameraRoll;
        pickerVc.maxCount = photoMaxCount - self.photosArray.count;   // 最多能选4张图片
        pickerVc.delegate = self;
        
        NSInteger index = self.navController.viewControllers.count - 1;
        UIViewController *vc = [self.navController.viewControllers objectAtIndex:index];
        [pickerVc showPickerVc:vc];
    }
    else {
        // 浏览图片
        LGPhotoPickerBrowserViewController *BroswerVC = [[LGPhotoPickerBrowserViewController alloc] init];
        BroswerVC.delegate = self;
        BroswerVC.dataSource = self;
        BroswerVC.showType = LGShowImageTypeImageBroswer;
        BroswerVC.currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        NSInteger index = self.navController.viewControllers.count - 1;
        UIViewController *vc = [self.navController.viewControllers objectAtIndex:index];
        [vc presentViewController:BroswerVC animated:YES completion:nil];
    }
}

- (void)deleteButtonClick:(UIButton *)sender
{
    NSInteger photoIndex = 0;
    
    if (self.photosArray.count == photoMaxCount) {
        photoIndex = sender.tag;
    }
    else {
        photoIndex = sender.tag - 1;
    }
    
    // 从数组移除删除的图片
    NSMutableArray *tmpPhotoArray = [NSMutableArray arrayWithArray:self.photosArray];
    [tmpPhotoArray removeObjectAtIndex:photoIndex];
    self.photosArray = tmpPhotoArray;
}

#pragma mark - LGPhotoPickerController delegate
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original
{
    if (assets.count > 0) {
        if (self.photosArray.count == 0) {
            NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:assets.count];
            
            for (LGPhotoAssets *asset in assets) {
                LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
                UIImage *image = [asset compressionImage];
                photo.photoImage = image;
                [tmpArray addObject:photo];
            }
            
            self.photosArray = tmpArray;
        }
        else {
            // 已经有图片了,累加
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.photosArray];
            
            for (LGPhotoAssets *asset in assets) {
                LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
                UIImage *image = [asset compressionImage];
                photo.photoImage = image;
                [tmpArray addObject:photo];
            }
            
            self.photosArray = tmpArray;
        }
    }
    else {
        self.photosArray = @[];
    }
}

#pragma mark - LGPhotoBrowser dataSource & delegate

- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section
{
    return self.photosArray.count;
}
//在这里，需要把图片包装成LGPhotoPickerBrowserPhoto对象，然后return即可。
- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.photosArray objectAtIndex:indexPath.item];
}

#pragma mark - Setter
- (void)setPhotosArray:(NSArray<LGPhotoPickerBrowserPhoto *> *)photosArray
{
    _photosArray = photosArray;
    
    // 更新 UI
    NSInteger count = photosArray.count;
    if (count > 0) {
        if (count == photoMaxCount) {
            for (NSInteger index = 0; index < photoMaxCount; index++) {
                ReviewPhotoTmpObject *tmpObj = [self.photosButtonArray objectAtIndex:index];
                LGPhotoPickerBrowserPhoto *photo = [photosArray objectAtIndex:index];
                [tmpObj.imageButton setImage:photo.photoImage forState:UIControlStateNormal];
                [tmpObj setHidden:NO];
            }
        }
        else if (count < photoMaxCount){
            for (NSInteger index = 0; index < photoMaxCount; index++) {
                
                ReviewPhotoTmpObject *tmpObj = [self.photosButtonArray objectAtIndex:index];
                
                // 不足4个,第一个永远是添加照片
                if (index == 0) {
                    [tmpObj setFirstAddButton];
                }
                else {
                    if (index <= count) {
                        LGPhotoPickerBrowserPhoto *photo = [photosArray objectAtIndex:(index - 1)];
                        [tmpObj.imageButton setImage:photo.photoImage forState:UIControlStateNormal];
                        [tmpObj setHidden:NO];
                    }
                    else {
                        [tmpObj setHidden:YES];
                    }
                }
            }
        }
        else {
            DLog(@"数组数量超过最大数量");
        }
    }
    else {
        // 只有第一个显示
        for (NSInteger index = 0; index < photoMaxCount; index++) {
            ReviewPhotoTmpObject *tmpObj = [self.photosButtonArray objectAtIndex:index];
            if (index == 0) {
                [tmpObj setFirstAddButton];
            }
            else {
                [tmpObj setHidden:YES];
            }
        }
    }
}

@end

#pragma mark
#pragma mark - reviewPhotoTmpObject
@implementation ReviewPhotoTmpObject

- (void)setHidden:(BOOL)hidden
{
    _hidden = hidden;
    
    [self.imageButton setHidden:hidden];
    [self.deleteButton setHidden:hidden];
}

- (void)setFirstAddButton
{
    [self.deleteButton setHidden:YES];
    [self.imageButton setImage:[UIImage imageNamed:@"banner_sahngchuang"] forState:UIControlStateNormal];
}

@end
