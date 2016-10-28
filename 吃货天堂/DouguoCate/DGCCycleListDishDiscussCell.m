//
//  DGCCycleListDishDiscussCell.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/18.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleListDishDiscussCell.h"
#import "DGCCycleListDishContentDiscussModel.h"
#import "DGCConfig.h"
#import "UIImageView+WebCache.h"

@interface DGCCycleListDishDiscussCell ()
{
    DGCCycleListDishContentDiscussModel *_model;
    UIView *subView;
    UIImageView *userIcon;
    UILabel *userNameLabel;
    UILabel *timeLabel;
    UIImageView *userVip;
    UILabel *contentLabel;
}

@end
@implementation DGCCycleListDishDiscussCell
-(void)setModelFrame:(DGCCycleListDishContentDiscussModelFrame *)modelFrame
{
     [subView removeFromSuperview];
    
    _modelFrame = modelFrame;
    
    _model = modelFrame.model;
    
    //子视图
    [self setupSubView];
    //头像
    [self setupUserIcon];
    
    if ([[NSString stringWithFormat:@"%@",_model.verified] isEqualToString:@"1"]) {
        
        [self setupUserVip];
    }
    
    //昵称
    [self setupUserNameLable];
    //创建发布时间
    [self setupTimeLabel];
    //创建评价内容
    [self setupContentLabel];

}
/**
 创建子视图
 */
-(void)setupSubView
{
    subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _modelFrame.cellHeight - 0.5)];
    subView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:subView];
}
/**
 创建头像
 */
-(void)setupUserIcon
{
    userIcon = [[UIImageView alloc] initWithFrame:_modelFrame.userAvatarRect];
    [userIcon sd_setImageWithURL:[NSURL URLWithString:_model.user_photo] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    userIcon.layer.cornerRadius = _modelFrame.userAvatarRect.size.width / 2;
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
    userNameLabel = [[UILabel alloc] initWithFrame:_modelFrame.userNameRect];
    userNameLabel.text = _model.nickname;
    userNameLabel.font = [UIFont systemFontOfSize:14];
    [subView addSubview:userNameLabel];
}

/**
 创建发布时间
 */
-(void)setupTimeLabel
{
    timeLabel = [[UILabel alloc] initWithFrame:_modelFrame.timeRect];
    
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

/**
 评价内容
 */
-(void)setupContentLabel
{
    contentLabel = [[UILabel alloc] initWithFrame:_modelFrame.contentRect];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.text = _model.content;
    contentLabel.numberOfLines = 0;
    [subView addSubview:contentLabel];
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
