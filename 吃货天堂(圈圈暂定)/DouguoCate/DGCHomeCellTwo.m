//
//  DGCHomeCellTwo.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/6.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCHomeCellTwo.h"
#import "UIImageView+WebCache.h"
#import "DGCConfig.h"
#import "DGCHomeModel.h"
#import "NSString+Size.h"

@interface DGCHomeCellTwo ()
{
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *descLabel;
    UIView *subView;
    UIImageView *userIcon;
    UIImageView *userVip;
    UIImageView *watchCountImageView;
    UILabel *watchCountLabel;
    UIImageView *dishCountImageView;
    UILabel *dishCountLabel;
    UILabel *userNameLabel;
    UIView *videoView;
    UIImageView *videoImageView;
    DGCHomeModel *_model;
}
@end

@implementation DGCHomeCellTwo

-(void)setModelFrame:(DGCHomeModelFrame *)modelFrame
{
    [subView removeFromSuperview];
    
    _modelFrame = modelFrame;
    
    _model = modelFrame.model;
    
    /**
     1.创建子视图
     */
    [self setupSubView];
    
    /**
     2.创建图片
     */
    [self setupImageView];
    
    /**
     3.创建标题
     */
    [self setupTitleLabel];
    
#if 1
    
    /**
     创建用户信息
     */
    if (_model.userAvatar) {
        
        /**
         4.创建用户头像
         */
        [self setupUserIcon];
        /**
         5.创建用户VIP
         */
        if ([_model.userVip  isEqualToString:@"1"])
        {
            
            [self setupUserVip];
        }
        
        /**
         6.创建用户昵称
         */
        [self setupUserNameLable];
        
        if (_model.vc) {
            
            /**
             7.创建动手次数
             */
            [self setupDishCountImageView];
            [self setupDishCountLabel];
            
            /**
             8.创建查看次数
             */
            [self setupWatchCountLabel];
            [self setupWatchCountImageView];
        }
        
        
    }
    
    /**
     9.创建描述
     */
    if (_model.desc) {
        
        [self setupDescLabel];
    }
    
    /**
     10.创建视频播放按钮图片
     */
    if (_model.vu) {
        
        [self setupVideoView];
    }
    
#endif

}
/**
 1.创建子视图
 */
-(void)setupSubView
{
    subView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, _modelFrame.cellHeight - 10)];
    
    subView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:subView];
}

/**
 2.创建图片
 */
-(void)setupImageView
{
    imageView = [[UIImageView alloc] initWithFrame:_modelFrame.picRect];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:[UIImage imageNamed:@"photo"]];
    
    [subView addSubview:imageView];
    
}

/**
 3.创建标题
 */
-(void)setupTitleLabel
{
    titleLabel = [[UILabel alloc] initWithFrame:_modelFrame.picTitleRect];
    titleLabel.text = _model.picTitle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [subView addSubview:titleLabel];
}
/**
 4.设置用户头像
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
 5.创建用户VIP
 */
-(void)setupUserVip
{
    CGFloat userVipWidth = 11;
    CGFloat userVipHeight = 11;
    
    userVip = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userIcon.frame) - userVipWidth + 2, CGRectGetMaxY(userIcon.frame) - userVipHeight + 2, userVipWidth, userVipHeight)];
    userVip.image = [UIImage imageNamed:@"add_chefs"];
    [subView addSubview:userVip];
}
/**
 6.创建用户昵称
 */
-(void)setupUserNameLable
{
    userNameLabel = [[UILabel alloc] initWithFrame:_modelFrame.userNameRect];
    userNameLabel.textColor = [UIColor lightGrayColor];
    userNameLabel.text = _model.userName;
    userNameLabel.font = [UIFont systemFontOfSize:13];
    [subView addSubview:userNameLabel];
}
/**
 7.创建动手次数
 */
-(void)setupDishCountImageView
{
    dishCountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/5*4, CGRectGetHeight(imageView.frame) - 25, 15, 15)];
    dishCountImageView.image = [UIImage imageNamed:@"recipe_icon_favo"];
    [imageView addSubview:dishCountImageView];
}
-(void)setupDishCountLabel
{
    NSString *text  = [NSString stringWithFormat:@"%@",_model.fc];
    
    CGFloat dishCountLabelWidth = [text sizeWithFontSize:12 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    
    dishCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dishCountImageView.frame) + 3, CGRectGetMinY(dishCountImageView.frame), dishCountLabelWidth + 10, 15)];
    dishCountLabel.text = text;
    dishCountLabel.textColor = [UIColor whiteColor];
    dishCountLabel.font = [UIFont systemFontOfSize:12 weight:1];
    [imageView addSubview:dishCountLabel];
}
/**
 8.创建查看次数
 */
-(void)setupWatchCountLabel
{
    NSString *text  = [NSString stringWithFormat:@"%@",_model.vc];
    CGFloat watchCountLabelWidth = [text sizeWithFontSize:12 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    
    watchCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(dishCountImageView.frame)- 12 - watchCountLabelWidth, CGRectGetMinY(dishCountImageView.frame), watchCountLabelWidth + 10, 15)];
    watchCountLabel.textColor = [UIColor whiteColor];
    watchCountLabel.font = [UIFont systemFontOfSize:12 weight:1];
    watchCountLabel.text = [NSString stringWithFormat:@"%@",_model.vc];
    [imageView addSubview:watchCountLabel];
}
-(void)setupWatchCountImageView
{
    watchCountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(watchCountLabel.frame) - 17, CGRectGetMinY(dishCountImageView.frame), 15, 15)];
    watchCountImageView.image = [UIImage imageNamed:@"recipe_icon_view"];
    [imageView addSubview:watchCountImageView];
}

/**
 9.创建描述
 */
-(void)setupDescLabel
{
    if (_model.userAvatar) {
        
        descLabel = [[UILabel alloc] initWithFrame:_modelFrame.descRect];
    }else
    {
        descLabel = [[UILabel alloc] initWithFrame:_modelFrame.descRect];
    }
    
    descLabel.text = _model.desc;
    descLabel.numberOfLines = 0;
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.font = [UIFont systemFontOfSize:13];
    descLabel.textColor = [UIColor lightGrayColor];
    [subView addSubview:descLabel];
}
/**
 10.创建视频播放按钮图片
 */
-(void)setupVideoView
{
    videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    videoView.center = imageView.center;
    videoView.backgroundColor = [UIColor whiteColor];
    videoView.alpha = 0.9;
    videoView.layer.cornerRadius = 30;
    videoView.clipsToBounds = YES;
    [imageView addSubview:videoView];
    
    videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    videoImageView.center = imageView.center;
    videoImageView.image = [UIImage imageNamed:@"recipe_list_video"];
    [imageView addSubview:videoImageView];
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
