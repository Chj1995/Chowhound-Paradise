//
//  DGCFunVideoCell.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/18.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCFunVideoCell.h"
#import "DGCConfig.h"
#import "UIImageView+WebCache.h"
#import "NSString+Size.h"

@interface DGCFunVideoCell ()
{
    UIView *subView;
    UIImageView *imageView;
    UIView *videoView;
    UIImageView *videoImageView;
    UIImageView *watchCountImageView;
    UILabel *watchCountLabel;
    UILabel *titleLabel;
    UIImageView *userIcon;
    UIImageView *userVip;
    UILabel *userNameLabel;
}

@end
@implementation DGCFunVideoCell
-(void)setModel:(DGCFunVideoModel *)model
{
    [subView removeFromSuperview];
    
    _model = model;
    
    //子视图
    [self setupSubView];
    //图片
    [self setupImageView];
    //播放按钮
    [self setupVideoView];
    //观看次数
    [self setupWatchCountLabel];
    //观看图片
    [self setupWatchCountImageView];
    //标题
    [self setupTitleLabel];
    //用户头像
    [self setupUserIcon];
    //用户认证标志
    [self setupUserVip];
    //用户昵称
    [self setupUserNameLable];
}

/**
 创建子视图
 */
-(void)setupSubView
{
    subView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, kFunVideoCellHeight - 10)];
    subView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:subView];
}

/**
 创建图片
 */
-(void)setupImageView
{
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kADViewHeight)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl] placeholderImage:[UIImage imageNamed:@"photo"]];
    [subView addSubview:imageView];
}
/**
 创建视频播放按钮图片
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
/**
 创建查看次数label
 */
-(void)setupWatchCountLabel
{
    NSString *text  = [NSString stringWithFormat:@"%@",_model.videoCount];
    CGFloat watchCountLabelWidth = [text sizeWithFontSize:12 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    
    watchCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 20 - watchCountLabelWidth, CGRectGetMaxY(imageView.frame) - 25, watchCountLabelWidth + 10, 15)];
    watchCountLabel.textColor = [UIColor whiteColor];
    watchCountLabel.font = [UIFont systemFontOfSize:12 weight:1];
    watchCountLabel.text = [NSString stringWithFormat:@"%@",_model.videoCount];
    [imageView addSubview:watchCountLabel];
}
/**
 创建查看次数imageview
 */
-(void)setupWatchCountImageView
{
    watchCountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(watchCountLabel.frame) - 17, CGRectGetMinY(watchCountLabel.frame), 15, 15)];
    watchCountImageView.image = [UIImage imageNamed:@"recipe_icon_view"];
    [imageView addSubview:watchCountImageView];
}

/**
 创建标题
 */
-(void)setupTitleLabel
{
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, kScreenWidth, 20)];
    titleLabel.text = _model.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [subView addSubview:titleLabel];
}
/**
 创建用户头像
 */
-(void)setupUserIcon
{
    CGFloat userIconWidth = 25;
    CGFloat userIconHeight = 25;
    
    userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/3, CGRectGetMaxY(titleLabel.frame) + 10, userIconWidth, userIconHeight)];
    [userIcon sd_setImageWithURL:[NSURL URLWithString:_model.userIcon] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    userIcon.layer.cornerRadius = userIconHeight/ 2;
    userIcon.clipsToBounds = YES;
    [subView addSubview:userIcon];
}

/**
 创建用户VIP
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
 创建用户昵称
 */
-(void)setupUserNameLable
{
    userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userIcon.frame) + 10, CGRectGetMaxY(titleLabel.frame) + 10, kScreenWidth/2, 20)];
    userNameLabel.textColor = [UIColor lightGrayColor];
    userNameLabel.text = _model.userName;
    userNameLabel.font = [UIFont systemFontOfSize:13];
    [subView addSubview:userNameLabel];
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
