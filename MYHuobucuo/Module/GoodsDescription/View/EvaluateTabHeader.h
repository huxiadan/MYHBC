//
//  EvaluateTabHeader.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/17.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EvaluateTypeButtonClickBlock)(EvaluateType tag);

@interface EvaluateTabHeader : UIView

@property (nonatomic, copy) EvaluateTypeButtonClickBlock buttonBlock;

@end
