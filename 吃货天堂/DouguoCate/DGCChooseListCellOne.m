//
//  DGCChooseListCellOne.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCChooseListCellOne.h"
#import "DGCChooseLisetModelOne.h"
#import "UIImageView+WebCache.h"

@interface DGCChooseListCellOne ()
{
    DGCChooseLisetModelOne *_model;
    UILabel *titleLabel;
    UIImageView *userAvatarImageView;
    UIImageView *userVip;
    UILabel *userNameLabel;
    UILabel *descLabel;
    UILabel *cLabel;
    
}
@end
@implementation DGCChooseListCellOne

-(void)setModelFrame:(DGCChooseLisetModelOneFrame *)modelFrame
{

    [titleLabel removeFromSuperview];
    [userAvatarImageView removeFromSuperview];
    [userVip removeFromSuperview];
    [userNameLabel removeFromSuperview];
    [descLabel removeFromSuperview];
    [cLabel removeFromSuperview];
    
    _modelFrame = modelFrame;
    
    _model = modelFrame.model;
    
    /**
     1.标题
     */
    [self setupTitleLabel];
    
    /**
     2.用户头像
     */
    [self setupUserAvatarImageView];
    
    /**
     3.创建用户VIP
     */
    if ([_model.verified isEqualToString:@"1"]) {
        
        [self setupUserVip];
    }
    /**
     4.创建用户昵称
     */
    [self setupUserNameLable];
    /**
     5.创建描述
     */
    [self setupDescLabel];
    
    /**
     6.菜谱数
     */
    [self setupCLabel];
}

/**
 1.标题
 */
-(void)setupTitleLabel
{
    titleLabel = [[UILabel alloc] initWithFrame:_modelFrame.titleLabelRect];
    titleLabel.text = _model.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20 weight:1];
    [self.contentView addSubview:titleLabel];
}

/**
 2.用户头像
 */
-(void)setupUserAvatarImageView
{
    userAvatarImageView = [[UIImageView alloc] initWithFrame:_modelFrame.userAvatarImageRect];
    [userAvatarImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar_medium] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    userAvatarImageView.layer.cornerRadius = _modelFrame.userAvatarImageRect.size.width/2;
    userAvatarImageView.clipsToBounds = YES;
    [self.contentView addSubview:userAvatarImageView];
}
/**
 3.创建用户VIP
 */
-(void)setupUserVip
{
    CGFloat userVipWidth = 11;
    CGFloat userVipHeight = 11;
    
    userVip = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userAvatarImageView.frame) - userVipWidth, CGRectGetMaxY(userAvatarImageView.frame) - userVipHeight, userVipWidth, userVipHeight)];
    userVip.image = [UIImage imageNamed:@"add_chefs"];
    [self.contentView addSubview:userVip];
}
/**
 4.创建用户昵称
 */
-(void)setupUserNameLable
{
    userNameLabel = [[UILabel alloc] initWithFrame:_modelFrame.userNameLabelRect];
    userNameLabel.textColor = [UIColor lightGrayColor];
    userNameLabel.text = _model.nickname;
    userNameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:userNameLabel];
}
/**
 5.创建描述
 */
-(void)setupDescLabel
{
    descLabel = [[UILabel alloc] initWithFrame:_modelFrame.descLabelRect];
    descLabel.text = _model.desc;
    descLabel.numberOfLines = 0;
    descLabel.font = [UIFont systemFontOfSize:13];
    descLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:descLabel];
}

/**
 6.菜谱数
 */
-(void)setupCLabel
{
    cLabel = [[UILabel alloc] initWithFrame:_modelFrame.cLabelRect];
    cLabel.textAlignment = NSTextAlignmentCenter;
    cLabel.text = [NSString stringWithFormat:@"- %@道菜谱 -",_model.c];
    cLabel.font = [UIFont systemFontOfSize:20 weight:1];
    [self.contentView addSubview:cLabel];
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
