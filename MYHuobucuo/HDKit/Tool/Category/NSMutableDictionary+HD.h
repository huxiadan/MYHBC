//
//  NSMutableDictionary+HD.h
//  Huobucuo
//
//  Created by hudan on 16/8/31.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (HD)

- (void)setObjectSafe:(id)anObject forKey:(id<NSCopying>)aKey;

@end
