//
//  DGCDGCDescModelFrame.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/7.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCDGCDescModelFrame.h"
#import "DGCConfig.h"
#import "NSString+Size.h"

@implementation DGCDGCDescModelFrame

-(void)setModel:(DGCDescModel *)model
{
    _model = model;
    
    /**
     1.图片Frame
     */
    _picImageViewRect = CGRectMake(0, 0, kScreenWidth, kScreenWidth/3*2);
    
    /**
     2.标题Frame
     */
    CGFloat space = 20;
    CGFloat titleLabelFontSize = 24;
    CGFloat titleLabelHeight = [_model.picTitle sizeWithFontSize:titleLabelFontSize maxSize:CGSizeMake(kScreenWidth - space*2, MAXFLOAT)].height;
    _titleLabelRect = CGRectMake(space, CGRectGetMaxY(_picImageViewRect) + 5, kScreenWidth - space*2, titleLabelHeight);
    /**
     3.描述Frame
     */
    _descLabelRect = CGRectMake(0, CGRectGetMaxY(_titleLabelRect) + 10, kScreenWidth, 20);
    /**
     4.故事内容Frame
     */
    CGFloat cookstoryLabelFontSize = 14;
    
    CGFloat cookstoryLabelHeight = [_model.cookstory sizeWithFontSize:cookstoryLabelFontSize maxSize:CGSizeMake(CGRectGetWidth(_titleLabelRect), MAXFLOAT)].height;
    _cookstoryLabelRect = CGRectMake(CGRectGetMinX(_titleLabelRect), CGRectGetMaxY(_descLabelRect) + 10, CGRectGetWidth(_titleLabelRect), cookstoryLabelHeight);
    /**
     5.用户头像
     */
    if (![_model.cookstory isEqualToString:@""])
    {
        _userIconRect = CGRectMake(CGRectGetMinX(_cookstoryLabelRect), CGRectGetMaxY(_cookstoryLabelRect) + 20, 30, 30);
    }else
    {
        _userIconRect = CGRectMake(CGRectGetMinX(_descLabelRect), CGRectGetMaxY(_descLabelRect) + 20, 30, 30);
    }
    
    /**
     6.用户昵称
     */
    _userNameRect = CGRectMake(CGRectGetMaxX(_userIconRect) + 5, CGRectGetMinY(_userIconRect) + 5, kScreenWidth/2, 20);
    
    /**
     7.时间Frame
     */
    CGFloat imageViewWidth = 15;
    CGFloat imageViewHeight = 15;
    CGFloat imageViewSpace = 25;
    
    if (![_model.time isEqualToString:@""])
    {
        _timeImageViewRect = CGRectMake(CGRectGetMinX(_userIconRect), CGRectGetMaxY(_userIconRect) + imageViewSpace, imageViewWidth, imageViewHeight);
    }
    
    
    /**
     7.难度Frame
     */
    if (![_model.grade isEqualToString:@""])
    {
       _gradeImageViewRect = CGRectMake(kScreenWidth/2, CGRectGetMinY(_timeImageViewRect), imageViewWidth, imageViewHeight);
    }
    
    /**
     8.建议Frame
     */
    if (_model.advice != nil)
    {
        if (![_model.time isEqualToString:@""])
        {
            _adviceImageViewRect = CGRectMake(CGRectGetMinX(_timeImageViewRect), CGRectGetMaxY(_timeImageViewRect) + imageViewSpace, imageViewWidth, imageViewHeight);
        }else
        {
            _adviceImageViewRect = CGRectMake(CGRectGetMinX(_userIconRect), CGRectGetMaxY(_userIconRect) + imageViewSpace, imageViewWidth, imageViewHeight);
        }
    }
    
    /**
     *  9.cell的高度
     */
    if (_model.advice != nil) {//有建议
        
        _cellHeight = CGRectGetMaxY(_adviceImageViewRect);
    }else
    {
        if (![_model.time isEqualToString:@""]) {//没建议，有时间
            
            _cellHeight = CGRectGetMaxY(_timeImageViewRect);
        }else
        {
//            if (_model.cookstory != nil) {//没建议，没时间，有描述
//                
//                _cellHeight = CGRectGetMaxY(_cookstoryLabelRect);
//            }else
//            {
//                //没建议，没时间，没描述
                _cellHeight = CGRectGetMaxY(_userIconRect);
//            }
        }
    }
    
}
@end
