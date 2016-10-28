//
//  DGCCycleListCell.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/15.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleListCell.h"
#import "DGCConfig.h"
#import "UIImageView+WebCache.h"
#import "NSString+Size.h"

@interface DGCCycleListCell ()
{
    UIView *subView;
    UIImageView *titleImageView;
    UILabel *titleLabel;
    UILabel *capLabel;
    UILabel *descLabel;
    UIImageView *signImageView;
}
@end
@implementation DGCCycleListCell
-(void)setModel:(DGCListModel *)model
{
    [subView removeFromSuperview];
    
    _model = model;
    //子视图
    [self setupSubView];
    //标题图片
    [self setupTitleImageView];
    //标题
    [self setupTitleLabel];
    //围观人数
    [self setupCapLabel];
    //描述
    [self setupDescLabel];
    //标记图片
    if (_model.ri.length != 0) {
        
        [self setupSignImageView];
    }
}

/**
 创建子视图
 */
-(void)setupSubView
{
    subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kListCellHeight - 1)];
    subView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:subView];
}

/**
 创建标题图片
 */
-(void)setupTitleImageView
{
    titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kListCellHeight - 20, kListCellHeight - 20)];
    [titleImageView sd_setImageWithURL:[NSURL URLWithString:_model.u] placeholderImage:[UIImage imageNamed:@"photo"]];
    [subView addSubview:titleImageView];
}

/**
 创建标题
 */
-(void)setupTitleLabel
{
    CGFloat titleWidth = [_model.t sizeWithFontSize:17 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleImageView.frame) + 5, 10, titleWidth, 20)];
    titleLabel.text = _model.t;
    [subView addSubview:titleLabel];
}

/**
 创建围观人数
 */
-(void)setupCapLabel
{
 
    CGFloat capWidth = [_model.cap sizeWithFontSize:13 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    capLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 10, 10 + 7, capWidth, 10)];
    capLabel.textColor = [UIColor orangeColor];
    capLabel.text = _model.cap;
    capLabel.font = [UIFont systemFontOfSize:13];
    [subView addSubview:capLabel];
}

/**
 创建描述
 */
-(void)setupDescLabel
{
    CGFloat descWidth = [_model.st sizeWithFontSize:13 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    
    descLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleImageView.frame) - 10, descWidth, 10)];
    descLabel.text = _model.st;
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.font = [UIFont systemFontOfSize:13];
    [subView addSubview:descLabel];
}

/**
 创建标记图片
 */
-(void)setupSignImageView
{
    signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 50, CGRectGetMinY(capLabel.frame), 30, 30)];
    [signImageView sd_setImageWithURL:[NSURL URLWithString:_model.ri] placeholderImage:[UIImage imageNamed:@"photo"]];
    [subView addSubview:signImageView];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
