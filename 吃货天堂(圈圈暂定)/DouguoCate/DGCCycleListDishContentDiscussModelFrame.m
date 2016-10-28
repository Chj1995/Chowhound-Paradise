//
//  DGCCycleListDishContentDiscussModelFrame.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/18.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleListDishContentDiscussModelFrame.h"
#import "NSString+Size.h"
#import "DGCConfig.h"

#define ktextSize 15
@implementation DGCCycleListDishContentDiscussModelFrame

-(void)setModel:(DGCCycleListDishContentDiscussModel *)model
{
    _model = model;
    /**
     头像
     */
    _userAvatarRect = CGRectMake(10, 10, 25, 25);
    /**
     用户名
     */
    CGFloat userNameWidth = [_model.nickname sizeWithFontSize:ktextSize maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    _userNameRect = CGRectMake(CGRectGetMaxX(_userAvatarRect) + 5, 2, userNameWidth, 20);
    /**
     发表时间
     */
    _timeRect  =CGRectMake(CGRectGetMaxX(_userAvatarRect) + 5, CGRectGetMaxY(_userNameRect) + 5, kScreenWidth/2, 20);
    
    /**
     发布内容
     */
    CGSize contentSize = [_model.content sizeWithFontSize:ktextSize maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _contentRect = CGRectMake(10, CGRectGetMaxY(_userAvatarRect) + 30, kScreenWidth - 20, contentSize.height);
    
    /**
     cell的高度
     */
    _cellHeight = CGRectGetMaxY(_contentRect) + 20;
}
@end
