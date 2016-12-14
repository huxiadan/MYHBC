//
//  PartnetViewController.m
//  Huobucuo
//
//  Created by hudan on 16/9/8.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "PartnetViewController.h"

#import "MYTabBarController.h"

@implementation PartnetViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[MYTabBarController sharedTabBarController] setTabBarVisibItem:MYTabBarVisibStyleDistributor];
}

@end
