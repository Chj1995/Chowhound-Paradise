//
//  DGCAllDataModelFrame.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/19.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCAllDataModelFrame.h"
#import "NSString+Size.h"
#import "DGCConfig.h"

@implementation DGCAllDataModelFrame

-(void)setModel:(DGCAllDataModel *)model
{
    _model = model;
    
    /**
     用户头像
     */
    _userIconRect = CGRectMake(10, 10, 30, 30);
    
    /**
     用户昵称
     */
    _userNameRect = CGRectMake(CGRectGetMaxX(_userIconRect) + 10, 5, kScreenWidth/3, 20);
    
    /**
     发布时间
     */
    _pulishTimeRect = CGRectMake(CGRectGetMinX(_userNameRect), CGRectGetMaxY(_userNameRect) + 2, kScreenWidth/2, 20);
    
    /**
     内容图片
     */
    if (_model.imageUrl.length != 0)
    {
        
        CGFloat contentImageWidth = 70;
        CGFloat contentImageHeight = 70;
        _contentImageRect = CGRectMake(kScreenWidth - 10 - contentImageWidth, 15, contentImageWidth, contentImageHeight);
    }
    
    /**
     显示内容
     */
    CGFloat contentWith = 0.0;
    
    if (_model.imageUrl.length != 0)
    {
        contentWith = CGRectGetMinX(_contentImageRect) - 10 - 10;
    }else
    {
        contentWith = kScreenWidth - 10 - 10;
    }
    CGFloat contentHeight = [_model.title sizeWithFontSize:17 maxSize:CGSizeMake(contentWith, MAXFLOAT)].height;
    _contentRect = CGRectMake(10, CGRectGetMaxX(_userIconRect) + 20, contentWith, contentHeight);
    
    /**
     cell高度
     */
    _cellHeight = CGRectGetMaxY(_contentRect) + 30;
}

@end
