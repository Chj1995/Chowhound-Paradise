//
//  DGCDescCell.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/7.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCDescCell.h"
#import "UIImageView+WebCache.h"
#import "DGCConfig.h"
#import "NSString+Size.h"
#import "DGCDescModel.h"
#import <WebKit/WebKit.h>

@interface DGCDescCell ()
{
    UIImageView *picImageView;
    UILabel *titleLabel;
    UILabel *descLabel;
    UILabel *cookstoryLabel;
    UIImageView *userIcon;
    UIImageView *userVip;
    UILabel *userNameLabel;
    UIButton *attentionButton;
    UIImageView *timeImageView;
    UILabel *timeLabel;
    UIImageView *gradeImageView;
    UILabel *gradeLabel;
    UIImageView *adviceImageView;
    UILabel *adviceLabel;
    DGCDescModel *_model;
    UILabel *listLabel;
    WKWebView *webView;
}
@end
@implementation DGCDescCell

-(void)setModelFrame:(DGCDGCDescModelFrame *)modelFrame
{
    [picImageView removeFromSuperview];
    [titleLabel removeFromSuperview];
    [descLabel removeFromSuperview];
    [cookstoryLabel removeFromSuperview];
    [userIcon removeFromSuperview];
    [userVip removeFromSuperview];
    [userNameLabel removeFromSuperview];
    [userVip removeFromSuperview];
    [attentionButton removeFromSuperview];
    [timeImageView removeFromSuperview];
    [timeLabel removeFromSuperview];
    [gradeImageView removeFromSuperview];
    [gradeLabel removeFromSuperview];
    [adviceImageView removeFromSuperview];
    [adviceLabel removeFromSuperview];
    [listLabel removeFromSuperview];
    [webView removeFromSuperview];
    _modelFrame = modelFrame;
    
    _model = modelFrame.model;
    
    /**
     1.创建图片
     */
    if (_model.vu.length != 0)
    {
        [self setupWebView];
        
    }else
    {
        [self setupPicImageView];
    }
    
    /**
     2.创建标题
     */
    [self setupTitleLabel];
    /**
     3.创建描述
     */
    [self setupDescLabel];
    /**
     4.创建故事内容
     */
    if (![_model.cookstory isEqualToString:@""]) {
        
        [self setupcookstoryLabel];
    }
    
    /**
     5.创建用户
     */
    [self setupUserIcon];
    
    if ([_model.verified isEqualToString:@"1"]) {
        
        [self setupUserVip];
    }
    
    [self setupUserNameLable];
    /**
     6.创建时间，难道和建议
     */
    [self setupTimeAndGradeAndAdviceImageViewAndLabel];
    
    /**
     7.创建食材清单
     */
    [self setupListLabel];
}

/**
 创建视频播放界面
 */
-(void)setupWebView
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    webView = [[WKWebView alloc] initWithFrame:_modelFrame.picImageViewRect configuration:config];
    webView.scrollView.scrollEnabled = NO;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_model.vu]]];
    [self.contentView addSubview:webView];
}
/**
 1.创建图片
 */
-(void)setupPicImageView
{
    picImageView = [[UIImageView alloc] initWithFrame:_modelFrame.picImageViewRect];
    [picImageView sd_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:[UIImage imageNamed:@"photo"]];
    [self.contentView addSubview:picImageView];
}

/**
 2.创建标题
 */
-(void)setupTitleLabel
{
    CGFloat titleLabelFontSize = 24;
    
    titleLabel = [[UILabel alloc] initWithFrame:_modelFrame.titleLabelRect];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:titleLabelFontSize weight:1];
        titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _model.picTitle;
    
    [self.contentView addSubview:titleLabel];
}

/**
 3.创建描述
 */
-(void)setupDescLabel
{
    descLabel = [[UILabel alloc] initWithFrame:_modelFrame.descLabelRect];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.text = [NSString stringWithFormat:@"%@人浏览 · %@人收藏 · %@人做过",_model.vc,_model.favo_counts,_model.dish_count];
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:descLabel];
}

/**
 4.创建故事内容
 */
-(void)setupcookstoryLabel
{
    CGFloat cookstoryLabelFontSize = 14;
    
    cookstoryLabel = [[UILabel alloc] initWithFrame:_modelFrame.cookstoryLabelRect];
    
    cookstoryLabel.font = [UIFont systemFontOfSize:cookstoryLabelFontSize];
    
    cookstoryLabel.numberOfLines = 0;
//     调整行间距
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_model.cookstory];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:6];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_model.cookstory length])];
//    cookstoryLabel.attributedText = attributedString;
    cookstoryLabel.text = _model.cookstory;

    [self.contentView addSubview:cookstoryLabel];
}

/**
 5.创建用户按钮
 */
/**
 *设置用户头像
 */
-(void)setupUserIcon
{
    userIcon = [[UIImageView alloc] initWithFrame:_modelFrame.userIconRect];
    [userIcon sd_setImageWithURL:[NSURL URLWithString:_model.user_photo] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    userIcon.layer.cornerRadius = _modelFrame.userIconRect.size.width / 2;
    userIcon.clipsToBounds = YES;
    [self.contentView addSubview:userIcon];
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
 *创建用户昵称
 */
-(void)setupUserNameLable
{
    userNameLabel = [[UILabel alloc] initWithFrame:_modelFrame.userNameRect];
    userNameLabel.text = _model.userName;
    userNameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:userNameLabel];
}


/**
 6.创建时间，难度和建议
 */
-(void)setupTimeAndGradeAndAdviceImageViewAndLabel
{
    CGFloat labelFontSize = 14;
    CGFloat labelHeight = 15;
    
    if (![_model.time isEqualToString:@""])
    {
        CGFloat labelWidth = [[NSString stringWithFormat:@"时间：%@",_model.time] sizeWithFontSize:labelFontSize maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        
        timeImageView = [[UIImageView alloc] initWithFrame:_modelFrame.timeImageViewRect];
        timeImageView.image = [UIImage imageNamed:@"recipe_time"];
        [self.contentView addSubview:timeImageView];
    
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeImageView.frame) + 10, CGRectGetMinY(timeImageView.frame), labelWidth, labelHeight)];
        timeLabel.text = [NSString stringWithFormat:@"时间：%@",_model.time];
        timeLabel.font = [UIFont systemFontOfSize:labelFontSize];
        timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:timeLabel];
    }
    
    if (![_model.grade isEqualToString:@""])
    {
        CGFloat labelWidth = [[NSString stringWithFormat:@"难度：%@",_model.grade] sizeWithFontSize:labelFontSize maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        
        gradeImageView = [[UIImageView alloc] initWithFrame:_modelFrame.gradeImageViewRect];
        gradeImageView.image = [UIImage imageNamed:@"recipe_grade"];
        [self.contentView addSubview:gradeImageView];
        
        gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gradeImageView.frame) + 10, CGRectGetMinY(gradeImageView.frame), labelWidth, labelHeight)];
        gradeLabel.text = [NSString stringWithFormat:@"难度：%@",_model.grade];
        gradeLabel.font = [UIFont systemFontOfSize:labelFontSize];
        gradeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:gradeLabel];

    }
    
    if (_model.advice != nil)
    {
        CGFloat labelWidth = [_model.advice sizeWithFontSize:labelFontSize maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        
        if (![_model.time isEqualToString:@""]) {
            
            adviceImageView = [[UIImageView alloc] initWithFrame:_modelFrame.adviceImageViewRect];
        }
        else
        {
            adviceImageView = [[UIImageView alloc] initWithFrame:_modelFrame.adviceImageViewRect];
        }
        
        adviceImageView.image = [UIImage imageNamed:@"recipe_advice"];
        [self.contentView addSubview:adviceImageView];
        
        adviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(adviceImageView.frame) + 10, CGRectGetMinY(adviceImageView.frame), labelWidth, labelHeight)];
        
        adviceLabel.text = [NSString stringWithFormat:@"%@",_model.advice];
        adviceLabel.font = [UIFont systemFontOfSize:labelFontSize];
        adviceLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:adviceLabel];
    }
}

/**
 7.创建食材清单
 */
-(void)setupListLabel
{
    
    listLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _modelFrame.cellHeight + 20, kScreenWidth, 20)];
    listLabel.text = [NSString stringWithFormat:@"- 食材清单 -"];
    listLabel.textAlignment = NSTextAlignmentCenter;
    listLabel.font = [UIFont systemFontOfSize:17 weight:1];
    [self.contentView addSubview:listLabel];
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
