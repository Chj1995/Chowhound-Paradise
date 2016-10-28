//
//  DGCCyCleListContentDetailCell.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCyCleListContentDetailCell.h"
#import "DGCConfig.h"
#import "UIImageView+WebCache.h"

@interface DGCCyCleListContentDetailCell ()
{
    UIImageView *imageView;
    UIImageView *userIcon;
    UILabel *userNameLabel;
    UILabel *timeLabel;
    UIView *subView;
    UIImageView *userVip;
}

@end
@implementation DGCCyCleListContentDetailCell

-(void)setModel:(DGCCycleListContentModel *)model
{
    [subView removeFromSuperview];
    
    _model = model;
    
    //子视图
    [self setupSubView];
    //图片
    [self setupImageView];
    //头像
    [self setupUserIcon];
    
    if ([[NSString stringWithFormat:@"%@",_model.verified] isEqualToString:@"1"]) {
        
        [self setupUserVip];
    }

    //昵称
    [self setupUserNameLable];
    //创建发布时间
    [self setupTimeLabel];
}

/**
 创建子视图
 */
-(void)setupSubView
{
    subView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, kADViewHeight + 60)];
    subView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:subView];
}
/**
 创建图片
 */
-(void)setupImageView
{
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kADViewHeight)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:[UIImage imageNamed:@"photo"]];
    [subView addSubview:imageView];
    
}

/**
 创建头像
 */
-(void)setupUserIcon
{
    CGFloat userIsonWidth = 30;
    CGFloat userIconHeight = 30;
    userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imageView.frame) + 10, userIsonWidth, userIconHeight)];
    [userIcon sd_setImageWithURL:[NSURL URLWithString:_model.user_photo] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    userIcon.layer.cornerRadius = userIsonWidth / 2;
    userIcon.clipsToBounds = YES;
    [subView addSubview:userIcon];
}
/**
 *创建用户VIP
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
 创建用户昵称
 */
-(void)setupUserNameLable
{
    userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userIcon.frame) + 10, CGRectGetMinY(userIcon.frame) - 2, kScreenWidth/2, 20)];
    userNameLabel.text = _model.nickname;
    userNameLabel.font = [UIFont systemFontOfSize:14];
    [subView addSubview:userNameLabel];
}

/**
 创建发布时间
 */
-(void)setupTimeLabel
{
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userIcon.frame) + 10, CGRectGetMidY(userIcon.frame) + 5, kScreenWidth/3, 10)];
    
    if ([_model.publishtime isEqualToString:@"0:0"]) {
        
        timeLabel.text = @"刚刚";
    }else
    {
        NSRange rang = [_model.publishtime rangeOfString:@":"];
        
        NSString *time = [_model.publishtime substringToIndex:rang.location];
    
        if ([time isEqualToString:@"0"]) {
            
            timeLabel.text = [NSString stringWithFormat:@"%@分钟前",[_model.publishtime substringFromIndex:rang.location + 1]];
            
        }else
        {
            if (time.integerValue > 24)
            {
                timeLabel.text = _model.publishtimeSecond;
            }else
            {
                timeLabel.text = [NSString stringWithFormat:@"%@小时前",[_model.publishtime substringToIndex:rang.location]];
            }
        }
    }
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.font = [UIFont systemFontOfSize:13];
    [subView addSubview:timeLabel];
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
