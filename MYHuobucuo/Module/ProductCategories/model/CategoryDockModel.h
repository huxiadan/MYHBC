//
//  CategoryDockModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryDockModel : NSObject

@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *dockId;

- (void)setValueWithDict:(NSDictionary *)dict;

@end
