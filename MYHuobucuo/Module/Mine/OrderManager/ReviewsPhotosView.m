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

@interface ReviewsPhotosView () <LGPhotoPickerViewControllerDelegate,
                                 LGPhotoPickerBrowserViewControllerDelegate,
                                 LGPhotoPickerBrowserViewControllerDataSource>

@property (nonatomic, strong) NSArray<LGPhotoPickerBrowserPhoto *> *photosArray;       // 图片数组

@property (nonatomic, strong) NSArray<ReviewPhotoTmpObject *> *photosButtonArray;// 图片视图和对应的删除按钮的数组
@property (nonatomic, assign) LGShowImageType showType;

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
    for (NSInteger index = 0; index < 4; index++) {
        
        UIButton *imageButton = [[UIButton alloc] init];
        [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [imageButton setTag:index];
        [self addSubview:imageButton];
        
        ReviewPhotoTmpObject *tmpObject = [[ReviewPhotoTmpObject alloc] init];
        
        if (index == 0) {
            [imageButton setImage:[UIImage imageNamed:@"banner_sahngchuang"] forState:UIControlStateNormal];
        }
        else {
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
    if (sender.tag == 0 && self.photosArray.count < 4) {
        // 添加图片
        LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:LGShowImageTypeImagePicker];
        pickerVc.status = PickerViewShowStatusSavePhotos;
        pickerVc.maxCount = 4;   // 最多能选4张图片
        pickerVc.delegate = self;
        self.showType = LGShowImageTypeImagePicker;
        [self.navController pushViewController:pickerVc animated:YES];
    }
    else {
        // 浏览图片
        LGPhotoPickerBrowserViewController *BroswerVC = [[LGPhotoPickerBrowserViewController alloc] init];
        BroswerVC.delegate = self;
        BroswerVC.dataSource = self;
        BroswerVC.showType = LGShowImageTypeImageBroswer;
        self.showType = LGShowImageTypeImageBroswer;
        [self.navController pushViewController:BroswerVC animated:YES];
    }
}

- (void)deleteButtonClick:(UIButton *)sender
{
    NSInteger photoIndex = sender.tag;
    // 从数组移除删除的图片
    NSMutableArray *tmpPhotoArray = [NSMutableArray arrayWithArray:self.photosArray];
    [tmpPhotoArray removeObjectAtIndex:photoIndex];
    self.photosArray = tmpPhotoArray;
}

#pragma mark - LGPhotoPickerController delegate
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original
{
    if (assets.count > 0) {
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
        if (count == 4) {
            for (NSInteger index = 0; index < 4; index++) {
                ReviewPhotoTmpObject *tmpObj = [self.photosButtonArray objectAtIndex:index];
                LGPhotoPickerBrowserPhoto *photo = [photosArray objectAtIndex:index];
                [tmpObj.imageButton setImage:photo.photoImage forState:UIControlStateNormal];
                [tmpObj setHidden:NO];
            }
        }
        else if (count < 4){
            for (NSInteger index = 0; index < 4; index++) {
                
                ReviewPhotoTmpObject *tmpObj = [self.photosButtonArray objectAtIndex:index];
                
                if (index == 0) {
                    [tmpObj.imageButton setImage:[UIImage imageNamed:@"banner_sahngchuang"] forState:UIControlStateNormal];
                }
                else {
                    if (index + 1 <= count) {
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
        ReviewPhotoTmpObject *tmpObj = [self.photosButtonArray objectAtIndex:0];
        [tmpObj.imageButton setImage:[UIImage imageNamed:@"banner_sahngchuang"] forState:UIControlStateNormal];
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

@end
