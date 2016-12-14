//
//  HDPhotoAlbum.h
//  HDKit
//
//  Created by 1233go on 16/7/29.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
 *  自定义相册
 */

#import <UIKit/UIKit.h>

@interface HDPhotoAlbum : UIViewController

/**
 *  获取所有相册的名称
 *
 *  @return 相册名称的数组
 */
- (NSArray *)getAlbumTitles;

/**
 *  根据相册名称获取相册中的资源
 *
 *  @param albumName 指定相册的名称
 *
 *  @return 指定相册内的资源
 */
- (NSArray *)getPhotosFromAlbum:(NSString *)albumName;

@end
