//
//  DGCChooseLisetModelOneFrame.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCChooseLisetModelOneFrame.h"
#import "NSString+Size.h"
#import "DGCConfig.h"

@implementation DGCChooseLisetModelOneFrame

-(void)setModel:(DGCChooseLisetModelOne *)model
{
    _model = model;
    
    /**
     标题Frame
     */
    CGFloat height = [_model.title sizeWithFontSize:20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    
    _titleLabelRect = CGRectMake(0, 10, kScreenWidth, height);
    
    
    /**
     头像Frame
     */
    
    _userAvatarImageRect = CGRectMake(kScreenWidth/3, CGRectGetMaxY(_titleLabelRect) + 10, 25, 25);
    
    /**
     昵称Frame
     */
    
    _userNameLabelRect = CGRectMake(CGRectGetMaxX(_userAvatarImageRect) + 5, CGRectGetMaxY(_titleLabelRect) + 15, kScreenWidth/2, 20);
    
    /**
     描述Frame
     */
    CGFloat descLabelHeight = [_model.desc sizeWithFontSize:13 maxSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)].height;
    
    _descLabelRect = CGRectMake(10, CGRectGetMaxY(_userAvatarImageRect) + 10, kScreenWidth - 20, descLabelHeight);
    
    /**
     菜谱数Frame
     */
    
    _cLabelRect = CGRectMake(0, CGRectGetMaxY(_descLabelRect) + 20, kScreenWidth, 20);
    
    /**
     cell高度
     */
    _cellHeight = CGRectGetMaxY(_cLabelRect) + 10;
    
    
}

@end
