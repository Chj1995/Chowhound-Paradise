//
//  DGCCycleListAllDataCell.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/18.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleListAllDataCell.h"
#import "DGCAllDataModel.h"
#import "DGCConfig.h"
#import "UIImageView+WebCache.h"

@interface DGCCycleListAllDataCell ()
{
    DGCAllDataModel *_model;
    UIView *subView;
    UIImageView *userIcon;
    UILabel *userNameLabel;
    UILabel *timeLabel;
    UIImageView *userVip;
    UIImageView *contentImageView;
    UILabel *imageCountLabel;
    UIView *imageCountBackView;
    UILabel *contentLabel;
}
@end
@implementation DGCCycleListAllDataCell
-(void)setModelFrame:(DGCAllDataModelFrame *)modelFrame
{
    [subView removeFromSuperview];
    
    _modelFrame = modelFrame;
    _model = modelFrame.model;
    
    //子视图
    [self setupSubView];
    
    //头像
    [self setupUserIcon];
    
    if ([_model.verified isEqualToString:@"1"]) {
        
        [self setupUserVip];
        
    }
    
    //昵称
    [self setupUserNameLable];
    //创建发布时间
    [self setupTimeLabel];
    if (_model.imageUrl.length != 0) {
        
        //内容图片
        [self setupContentImageView];
        
        if (_model.imageCount.integerValue>1) {
            
            [self setupImageCountLabel];
        }
    }
    
    //创建评价内容
    [self setupContentLabel];
}
/**
 创建子视图
 */
-(void)setupSubView
{
    subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _modelFrame.cellHeight - 1)];
    subView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:subView];
}
/**
 创建头像
 */
-(void)setupUserIcon
{
    userIcon = [[UIImageView alloc] initWithFrame:_modelFrame.userIconRect];
    [userIcon sd_setImageWithURL:[NSURL URLWithString:_model.userIcon] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    userIcon.layer.cornerRadius = _modelFrame.userIconRect.size.width / 2;
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
    userNameLabel.text = _model.userName;
    userNameLabel.font = [UIFont systemFontOfSize:14];
    [subView addSubview:userNameLabel];
}

/**
 创建发布时间
 */
-(void)setupTimeLabel
{
    timeLabel = [[UILabel alloc] initWithFrame:_modelFrame.pulishTimeRect];
    
    if ([_model.pulishTime isEqualToString:@"0:0"]) {
        
        timeLabel.text = @"刚刚";
    }else
    {
        NSRange rang = [_model.pulishTime rangeOfString:@":"];
        
        NSString *time = [_model.pulishTime substringToIndex:rang.location];
        
        if ([time isEqualToString:@"0"]) {
            
            timeLabel.text = [NSString stringWithFormat:@"%@分钟前",[_model.pulishTime substringFromIndex:rang.location + 1]];
            
        }else
        {
            if (time.integerValue > 24)
            {
                timeLabel.text = _model.pulishTimeSecond;
            }else
            {
                timeLabel.text = [NSString stringWithFormat:@"%@小时前",[_model.pulishTime substringToIndex:rang.location]];
            }
            
        }
    }
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.font = [UIFont systemFontOfSize:13];
    [subView addSubview:timeLabel];
}

/**
 内容图片
 */
-(void)setupContentImageView
{
    contentImageView = [[UIImageView alloc] initWithFrame:_modelFrame.contentImageRect];
    [contentImageView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl] placeholderImage:[UIImage imageNamed:@"photo"]];
    [subView addSubview:contentImageView];
}

/**
 图片张数
 */
-(void)setupImageCountLabel
{
    CGFloat imageCountLabelWidth = 15;
    CGFloat imageCountLabelHeight = 15;
    
    imageCountBackView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_modelFrame.contentImageRect) - imageCountLabelWidth, CGRectGetMaxY(_modelFrame.contentImageRect) - imageCountLabelHeight, imageCountLabelWidth, imageCountLabelHeight)];
    imageCountBackView.backgroundColor = [UIColor blackColor];
    imageCountBackView.alpha = 0.4;
    [subView addSubview:imageCountBackView];
    
    imageCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_modelFrame.contentImageRect) - imageCountLabelWidth, CGRectGetMaxY(_modelFrame.contentImageRect) - imageCountLabelHeight, imageCountLabelWidth, imageCountLabelHeight)];
    imageCountLabel.text = _model.imageCount;
    imageCountLabel.textColor = [UIColor whiteColor];
    imageCountLabel.textAlignment = NSTextAlignmentCenter;
    imageCountLabel.font = [UIFont systemFontOfSize:10];
    [subView addSubview:imageCountLabel];
    
    
}
/**
 评价内容
 */
-(void)setupContentLabel
{
    contentLabel = [[UILabel alloc] initWithFrame:_modelFrame.contentRect];
    contentLabel.font = [UIFont systemFontOfSize:17];
    contentLabel.text = _model.title;
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
