//
//  StoreGoodsItem.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "StoreGoodsItem.h"

@implementation StoreGoodsItem

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (self.tag >= 3) {
        if (self.isSelected) {
            self.itemLabel.textColor = HexColor(0xe44a62);
            
            if (self.tag - 3 == 1) {
                self.tag = 3 + 2;
                [self.itemImageView setImage:[UIImage imageNamed:@"icon_jiage_2"]];
            }
            else if (self.tag - 3 == 2 || self.tag == 3) {
                self.tag = 3 + 1;
                [self.itemImageView setImage:[UIImage imageNamed:@"icon_jiage_1"]];
            }
        }
        else {
            if (self.tag == 3 + 2) {
                self.tag = 3 + 1;
            }
            else {
                self.tag = 3 + 2;
            }
            
            self.itemLabel.textColor = HexColor(0x333333);
            [self.itemImageView setImage:[UIImage imageNamed:@"icon_jiage_n"]];
        }
    }
    else {
        if (self.isSelected) {
            self.itemLabel.textColor = HexColor(0xe44a62);
        }
        else {
            self.itemLabel.textColor = HexColor(0x333333);
        }
    }
    
}

@end
