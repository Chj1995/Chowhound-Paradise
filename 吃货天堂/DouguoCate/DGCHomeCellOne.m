//
//  DGCHomeCell.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/6.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCHomeCellOne.h"
#import "UIImageView+WebCache.h"
#import "DGCConfig.h"

@interface DGCHomeCellOne ()
{
    UIImageView *imageView;
    UILabel *countLabel;
    UILabel *titleLabel;
    UILabel *userNameLabel;
}

@end
@implementation DGCHomeCellOne
-(void)setModel:(DGCHomeModel *)model
{
    [imageView removeFromSuperview];
    [countLabel removeFromSuperview];
    [titleLabel removeFromSuperview];
    [userNameLabel removeFromSuperview];
    
    _model = model;
    
    /**
     1.创建图片
     */
    [self setupImageView];
    /**
     2.创建菜数
     */
    [self setupCountLabel];
    /**
     3.创建标题
     */
    [self setupTitleLabel];
    /**
     4.创建用户名
     */
    [self setupUserNameLabel];
}

/**
 1.创建图片
 */
-(void)setupImageView
{
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenWidth - 140)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:[UIImage imageNamed:@"photo"]];
    
    [self.contentView addSubview:imageView];
}

/**
 2.创建菜数
 */
-(void)setupCountLabel
{
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(imageView.frame)/2, kScreenWidth, 20)];
    countLabel.text = [NSString stringWithFormat:@"*共%@道菜*",_model.desc];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.textColor = [UIColor whiteColor];
    countLabel.font = [UIFont systemFontOfSize:17 weight:1];
    [imageView addSubview:countLabel];
}

/**
 3.创建标题
 */
-(void)setupTitleLabel
{
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(countLabel.frame) + 5, kScreenWidth, 20)];
    titleLabel.text = _model.picTitle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20 weight:1];
    [imageView addSubview:titleLabel];
}

/**
 4.创建用户名
 */
-(void)setupUserNameLabel
{
    userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 5, kScreenWidth, 20)];
    userNameLabel.text = [NSString stringWithFormat:@"由%@创建",_model.userName];
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.font = [UIFont systemFontOfSize:17 weight:1];
    [imageView addSubview:userNameLabel];
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
