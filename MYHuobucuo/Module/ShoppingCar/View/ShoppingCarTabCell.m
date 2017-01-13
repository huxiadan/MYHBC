
//
//  ShoppingCarTabCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/27.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "ShoppingCarTabCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "NSAttributedString+HD.h"
#import "HDLabel.h"
#import "MYProgressHUD.h"
#import "MYSingleTon.h"

@interface ShoppingCarTabCell () <UIAlertViewDelegate>

@property (nonatomic, strong) UIButton *selectButton;       // 选中按钮
@property (nonatomic, strong) UIImageView *goodsImageView;  // 商品图片
@property (nonatomic, strong) HDLabel *goodsNameLabel;      // 商品名称
@property (nonatomic, strong) UILabel *goodsSpecLabel;      // 商品规格
@property (nonatomic, strong) UILabel *goodsPriceLabel;     // 商品单价
@property (nonatomic, strong) UILabel *goodsNumberLabel;    // 商品数量

// 编辑状态的视图
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *numberView;
@property (nonatomic, strong) UILabel *editNumberLabel;

@end

@implementation ShoppingCarTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.height.equalTo(@1);
        make.left.equalTo(self.mas_left).offset(fScreen(30 + 40 + 30));
    }];
    
    // 选中按钮
    UIButton *selectButton = [[UIButton alloc] init];
    [selectButton setImage:[UIImage imageNamed:@"icon_choose_s"] forState:UIControlStateSelected];
    [selectButton setImage:[UIImage imageNamed:@"icon_choose_n"] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(fScreen(30 - 10));
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(fScreen(40 + 10*2));
        make.height.mas_equalTo(fScreen(40 + 10*2));
    }];
    self.selectButton = selectButton;
    
    // 图片
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setBackgroundColor:[UIColor redColor]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectButton.mas_right).offset(fScreen(30 - 10));
        make.centerY.equalTo(selectButton.mas_centerY);
        make.width.mas_equalTo(fScreen(160));
        make.height.mas_equalTo(fScreen(160));
    }];
    self.goodsImageView = imageView;
    
    // 名称
    HDLabel *nameLabel = [[HDLabel alloc] init];
    [nameLabel setNumberOfLines:2];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [nameLabel setTextColor:HexColor(0x333333)];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(fScreen(20));
        make.right.equalTo(self.mas_right).offset(-fScreen(28));
        make.top.equalTo(imageView.mas_top);
        CGSize textSize = [@"高度" sizeForFontsize:fScreen(28)];
        make.height.mas_equalTo(textSize.height);
    }];
    self.goodsNameLabel = nameLabel;
    
    // 规格
    UILabel *specLabel = [[UILabel alloc] init];
    [specLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [specLabel setTextColor:HexColor(0x666666)];
    [self addSubview:specLabel];
    [specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(nameLabel);
        make.centerY.equalTo(imageView.mas_centerY);
        CGSize textSize = [@"高度" sizeForFontsize:fScreen(24)];
        make.height.mas_equalTo(textSize.height);
    }];
    self.goodsSpecLabel = specLabel;
    
    // 单价
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [priceLabel setTextColor:HexColor(0xe44a62)];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(fScreen(20));
        make.bottom.equalTo(imageView.mas_bottom);
        CGSize textSize = [@"高度" sizeForFontsize:fScreen(28)];
        make.height.mas_equalTo(textSize.height);
        make.width.mas_equalTo(fScreen(250));
    }];
    self.goodsPriceLabel = priceLabel;
    
    // 数量
    UILabel *numberLabel = [[UILabel alloc] init];
    [numberLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [numberLabel setTextColor:HexColor(0x666666)];
    [numberLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-fScreen(28));
        make.left.equalTo(priceLabel.mas_right).offset(fScreen(20));
        make.height.bottom.equalTo(priceLabel);
    }];
    self.goodsNumberLabel = numberLabel;
    
    
    // 删除
    UIButton *deleteButton = [[UIButton alloc] init];
    [deleteButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [deleteButton setTitle:@"删\n除" forState:UIControlStateNormal];
    [deleteButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [deleteButton.titleLabel setTextColor:[UIColor whiteColor]];
    [deleteButton setBackgroundColor:HexColor(0xe44a62)];
    [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    [deleteButton setFrame:CGRectMake(kAppWidth, 0, fScreen(109), kShoppingCarTabCellHeight - 1)];
    self.deleteButton = deleteButton;
    
    
    // 数量编辑
    [self addSubview:self.numberView];
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(75));
        make.bottom.equalTo(imageView.mas_bottom);
        make.width.mas_equalTo(fScreen(338));
    }];
    [self.numberView setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)adjustNameLabel:(NSString *)text isEdit:(BOOL)isEdit
{
    [self.goodsNameLabel setText:text];
    
    CGFloat labelWidth = kAppWidth - fScreen(30 + 40 + 30 + 160 + 20 + 30);;
    if (isEdit) {
        labelWidth -= fScreen(109);
    }
    
    CGSize labelSize = CGSizeMake(labelWidth, MAXFLOAT);
    CGSize textSize = [self.goodsNameLabel.text boundingRectWithSize:labelSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.goodsNameLabel.font} context:nil].size;
    
    [self.goodsNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textSize.height > fScreen(70) ? fScreen(70) : textSize.height);
        if (isEdit) {
            make.right.equalTo(self.mas_right).offset(-fScreen(109 + 20));
        }
        else {
            make.right.equalTo(self.mas_right).offset(-fScreen(30));
        }
    }];
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 删除 model
        if (self.deleteBlock) {
            self.deleteBlock(self.orderModel);
        }
    }
}

#pragma mark - button Click
// 选择按钮
- (void)selectButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    self.orderModel.isSelect = sender.isSelected;
    
    if (self.selectBlock) {
        self.selectBlock(self.orderModel);
    }
}

// 删除按钮
- (void)deleteButtonClick:(UIButton *)sender
{
    if (self.deleteBlock) {
        self.deleteBlock(self.orderModel);
    }
}

// 数量减
- (void)desButtonClick:(UIButton *)sender
{
    NSInteger number = self.orderModel.goodsNumber;
    if (number == 1) {
        // 询问删除
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否要删除该商品" delegate:self cancelButtonTitle:@"点错了" otherButtonTitles:@"确定删除", nil];
        [alert show];
        return;
    }
    else {
        number--;
    }
    self.orderModel.goodsNumber = number;
    [self.editNumberLabel setText:[NSString stringWithFormat:@"%ld",number]];
}

// 数量加
- (void)addButtonClick:(UIButton *)sender
{
    NSInteger number = self.orderModel.goodsNumber;
    if (number == self.orderModel.maxNumber) {
        // 提示已经达到可购买最大数量
        [MYProgressHUD showAlertWithMessage:@"已经达到最大可购买数量"];
        return;
    }
    else {
        number++;
    }
    self.orderModel.goodsNumber = number;
    [self.editNumberLabel setText:[NSString stringWithFormat:@"%ld",number]];
}

#pragma mark - Setter
- (void)setOrderModel:(OrderModel *)orderModel
{
    _orderModel = orderModel;
    
    self.selectButton.selected = orderModel.isSelect;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:orderModel.goodsImageURL] placeholderImage:[UIImage imageNamed:@"img_load_square"]];
    
    [self.goodsPriceLabel setText:[NSString stringWithFormat:@"¥%@",orderModel.goodsPrice]];
    [self.goodsPriceLabel setHidden:orderModel.isEdit || orderModel.isEditAll];
    
    [self.goodsNumberLabel setText:[NSString stringWithFormat:@"x %ld",orderModel.goodsNumber]];
    [self.goodsNumberLabel setHidden:orderModel.isEdit || orderModel.isEditAll];
    
    [self.goodsSpecLabel setText:orderModel.goodsSpecification];
    [self.goodsSpecLabel setHidden:orderModel.isEdit || orderModel.isEditAll];

    [self.editNumberLabel setText:[NSString stringWithFormat:@"%ld",orderModel.goodsNumber]];
    
    if (orderModel.isEditAll) {
        [self.numberView setHidden:NO];
        [self.numberView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kAppWidth - fScreen(30 + 40 + 30 + 20 + 30 + 160));
        }];
    }
    else {
        [self.numberView setHidden:!orderModel.isEdit];
        [self.numberView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(fScreen(338));
        }];
        
        [self adjustNameLabel:orderModel.goodsName isEdit:orderModel.isEdit];
        
        if (orderModel.isEdit) {
            [UIView animateWithDuration:0.3f animations:^{
                CGRect frame = self.deleteButton.frame;
                frame.origin.x = kAppWidth - fScreen(109);
                [self.deleteButton setFrame:frame];
            }];
        }
        else {
            [UIView animateWithDuration:0.3f animations:^{
                CGRect frame = self.deleteButton.frame;
                frame.origin.x += fScreen(109);
                [self.deleteButton setFrame:frame];
            }];
        }
    }
}

#pragma mark - Getter
- (UIView *)numberView
{
    if (!_numberView) {
        UIView *editNumberView = [[UIView alloc] init];
        [editNumberView setBackgroundColor:viewControllerBgColor];

        UIButton *desButton = [[UIButton alloc] init];
        [desButton setImage:[UIImage imageNamed:@"icon_decrease"] forState:UIControlStateNormal];
        [desButton addTarget:self action:@selector(desButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [editNumberView addSubview:desButton];
        [desButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(editNumberView);
            make.width.mas_equalTo(fScreen(100));
        }];
        
        UIButton *addButton = [[UIButton alloc] init];
        [addButton setImage:[UIImage imageNamed:@"icon_augment"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [editNumberView addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(editNumberView);
            make.width.equalTo(desButton.mas_width);
        }];
        
        UIView *lineVieLeft = [[UIView alloc] init];
        [lineVieLeft setBackgroundColor:[UIColor whiteColor]];
        [editNumberView addSubview:lineVieLeft];
        [lineVieLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(desButton);
            make.left.equalTo(desButton.mas_right);
            make.width.equalTo(@2);
            make.height.mas_equalTo(fScreen(60));
        }];
        
        UIView *lineViewRight = [[UIView alloc] init];
        [lineViewRight setBackgroundColor:[UIColor whiteColor]];
        [editNumberView addSubview:lineViewRight];
        [lineViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.centerY.equalTo(lineVieLeft);
            make.right.equalTo(editNumberView.mas_right).offset(-fScreen(100));
        }];
        
        UILabel *editNumberLabel = [[UILabel alloc] init];
        [editNumberLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [editNumberLabel setTextColor:HexColor(0x333333)];
        [editNumberLabel setTextAlignment:NSTextAlignmentCenter];
        [editNumberView addSubview:editNumberLabel];
        [editNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineVieLeft.mas_right);
            make.right.equalTo(lineViewRight.mas_left);
            make.top.bottom.equalTo(editNumberView);
        }];
        self.editNumberLabel = editNumberLabel;
        
        _numberView = editNumberView;
    }
    return _numberView;
}

@end
