//
//  DGCADViewCell.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCADViewCell.h"
#import "UIImageView+WebCache.h"
#import "DGCConfig.h"
@interface DGCADViewCell ()
{
    UIImageView *imageView;
    UILabel *descLabel;
    UIImageView *userIcon;
    UIImageView *userVip;
    UILabel *userNameLabel;
}

@end
@implementation DGCADViewCell
-(void)setModel:(DGCADModel *)model
{
    [imageView removeFromSuperview];
    [descLabel removeFromSuperview];
    [userIcon removeFromSuperview];
    [userVip removeFromSuperview];
    [userNameLabel removeFromSuperview];
    
    _model = model;
    
    /**
     1.创建图片
     */
    [self setupImageView];
    /**
     2.创建描述
     */
    [self setupDescLabel];
    /**
     3.设置用户头像
     */
    [self setupUserIcon];
    
    /**
     4.设置用户Vip
     */
    if ([_model.userVip integerValue]== 1) {
        
        [self setupUserVip];
    }
    /**
     5.创建用户昵称
     */
    [self setupUserNameLable];
}

/**
 1.创建图片
 */
-(void)setupImageView
{
    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:[UIImage imageNamed:@"photo"]];
    [self.contentView addSubview:imageView];
}

/**
 2.创建描述
 */
-(void)setupDescLabel
{
    descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/3*2, self.frame.size.width, 20)];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.text = _model.picTitle;
    descLabel.textColor = [UIColor whiteColor];
    descLabel.font = [UIFont systemFontOfSize:20 weight:6];
    [self.contentView addSubview:descLabel];
}

/**
 3.设置用户头像
 */
-(void)setupUserIcon
{
    CGFloat userIsonWidth = 30;
    CGFloat userIconHeight = 30;
    userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/3, CGRectGetMaxY(descLabel.frame) + 10, userIsonWidth, userIconHeight)];
    [userIcon sd_setImageWithURL:[NSURL URLWithString:_model.userAvatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    userIcon.layer.cornerRadius = userIsonWidth / 2;
    userIcon.clipsToBounds = YES;
    [self.contentView addSubview:userIcon];
}

/**
 4.创建用户VIP
 */
-(void)setupUserVip
{
    CGFloat userVipWidth = 11;
    CGFloat userVipHeight = 11;
    
    userVip = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userIcon.frame) - userVipWidth, CGRectGetMaxY(userIcon.frame) - userVipHeight, userVipWidth, userVipHeight)];
    userVip.image = [UIImage imageNamed:@"add_chefs"];
    [self.contentView addSubview:userVip];
}
/**
 5.创建用户昵称
 */
-(void)setupUserNameLable
{
    userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userIcon.frame) + 5, CGRectGetMinY(userIcon.frame) + CGRectGetHeight(userIcon.frame)/4, kScreenWidth/2, 20)];
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.text = _model.userName;
    userNameLabel.font = [UIFont systemFontOfSize:15 weight:1];
    [self.contentView addSubview:userNameLabel];
}
@end
