//
//  DGCCycleDetailCell.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleDetailCell.h"
#import "DGCCycleDetailModel.h"
#import "UIImageView+WebCache.h"
#import "DGCConfig.h"
#import "DGCCycleDetailContentModelFrame.h"
#import "DGCCycleDetailContentView.h"

@interface DGCCycleDetailCell ()
{
    DGCCycleDetailModel *_model;
    
    UIView *subView;
    UIImageView *userIcon;
    UIImageView *userVip;
    UILabel *userNameLabel;
    UILabel *flLabel;
    UILabel *fLabel;
    UILabel *timeLabel;
    DGCCycleDetailContentView *contentView;
    CGFloat contentHeight;
   
}
@end
@implementation DGCCycleDetailCell

-(void)setModelFrame:(DGCCycleDetailModelFrame *)modelFrame
{
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    [subView removeFromSuperview];
    
    _modelFrame = modelFrame;
    _model = modelFrame.model;
    
    [self setupSubView];
    
    //创建用户图标
    [self setupUserIcon];
    
    //是否认证
    if ([_model.verified isEqualToString:@"1"]) {
        
        [self setupUserVip];
    }
    //创建用户名
     [self setupUserNameLable];
    
    //是否是楼主
    if ([_model.fl isEqualToString:@"1"]) {
        
        [self setupflLable];
    }
    //创建楼层
    [self setupfLable];
    //发表时间
    [self setupTimeLabel];
    //内容视图
    [self setupContentView];
}
-(void)setupSubView
{
    contentHeight = 0.0;
    
    for (int i = 0; i < _modelFrame.model.contentArray.count; i++)
    {
        DGCCycleDetailContentModelFrame *contentModelFrame = _modelFrame.model.contentArray[i];
        
        contentHeight += contentModelFrame.cellHeight;
    }
    
    subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _modelFrame.cellHeight + contentHeight - 0.5)];
    subView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:subView];
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
    [subView addSubview:userVip];
}

/**
 *设置用户头像
 */
-(void)setupUserIcon
{
    userIcon = [[UIImageView alloc] initWithFrame:_modelFrame.userAvatarRect];
    [userIcon sd_setImageWithURL:[NSURL URLWithString:_model.userAvatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    userIcon.layer.cornerRadius = _modelFrame.userAvatarRect.size.width / 2;
    userIcon.clipsToBounds = YES;
    [subView addSubview:userIcon];
}
/**
 *创建用户昵称
 */
-(void)setupUserNameLable
{
    userNameLabel = [[UILabel alloc] initWithFrame:_modelFrame.userNameRect];
    userNameLabel.text = _model.userName;
    userNameLabel.font = [UIFont systemFontOfSize:15];
    [subView addSubview:userNameLabel];
}
/**
 *创建是否是楼主
 */
-(void)setupflLable
{
    flLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userNameLabel.frame) + 5, userNameLabel.frame.origin.y + 2, 40, 15)];
    flLabel.text = @"楼主";
    flLabel.textAlignment = NSTextAlignmentCenter;
    flLabel.textColor = [UIColor whiteColor];
    flLabel.backgroundColor = [UIColor orangeColor];
    flLabel.font = [UIFont systemFontOfSize:13];
    flLabel.layer.cornerRadius = 3;
    flLabel.clipsToBounds = YES;
    [subView addSubview:flLabel];
}
/**
 *创建楼层
 */
-(void)setupfLable
{
    fLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 50, userNameLabel.frame.origin.y, 40, 20)];
    fLabel.text = [NSString stringWithFormat:@"%@楼",_model.f];
    fLabel.textAlignment = NSTextAlignmentCenter;
    fLabel.textColor = [UIColor lightGrayColor];
    fLabel.font = [UIFont systemFontOfSize:13];
    [subView addSubview:fLabel];
}

/**
 创建发表时间
 */
-(void)setupTimeLabel
{
    timeLabel = [[UILabel alloc] initWithFrame:_modelFrame.timeRect];
    timeLabel.text = _model.time;
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.textColor = [UIColor lightGrayColor];
    [subView addSubview:timeLabel];
}

/**
 创建内容视图
 */
-(void)setupContentView
{
    contentView = [[DGCCycleDetailContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLabel.frame), kScreenWidth, contentHeight)];
    contentView.contentArray = _model.contentArray;
    [subView addSubview:contentView];
}
@end
