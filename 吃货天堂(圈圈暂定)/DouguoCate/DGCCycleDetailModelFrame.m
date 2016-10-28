//
//  DGCCycleDetailModelFrame.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleDetailModelFrame.h"
#import "NSString+Size.h"
#import "DGCConfig.h"

#define ktextSize 15

@implementation DGCCycleDetailModelFrame

-(void)setModel:(DGCCycleDetailModel *)model
{
    _model = model;
    
    /**
     头像
     */
    _userAvatarRect = CGRectMake(10, 10, 30, 30);
    /**
     用户名
     */
    CGFloat userNameWidth = [_model.userName sizeWithFontSize:ktextSize maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    _userNameRect = CGRectMake(CGRectGetMaxX(_userAvatarRect) + 5, 5, userNameWidth, 20);
    /**
     发表时间
     */
    CGFloat timeWidth = [_model.time sizeWithFontSize:ktextSize maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    _timeRect  =CGRectMake(CGRectGetMaxX(_userAvatarRect) + 5, CGRectGetMaxY(_userNameRect) + 5, timeWidth, 20);
    
    _cellHeight = CGRectGetMaxY(_timeRect);
    
}
@end
