//
//  DGCHomeModelFrame.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/9.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCHomeModelFrame.h"
#import "DGCConfig.h"
#import "NSString+Size.h"

@implementation DGCHomeModelFrame

-(void)setModel:(DGCHomeModel *)model
{
    _model = model;
    
    /**
     1.图片Frame
     */
    _picRect = CGRectMake(0, 0, kScreenWidth, kScreenWidth/2 + 20);
    
    /**
     2.标题Frame
     */
    CGFloat picHeight = [_model.picTitle sizeWithFontSize:17 maxSize:CGSizeMake(kScreenWidth, MAXFLOAT)].height;
    
    _picTitleRect = CGRectMake(0,CGRectGetMaxY(_picRect) + 5, kScreenWidth, picHeight);
    
    /**
     3.用户头像frame
     */
    CGFloat userIsonWidth = 25;
    CGFloat userIconHeight = 25;
    _userAvatarRect = CGRectMake(kScreenWidth/3, CGRectGetMaxY(_picTitleRect) + 5, userIsonWidth, userIconHeight);
    
    /**
     4.用户名frame
     */
    _userNameRect = CGRectMake(CGRectGetMaxX(_userAvatarRect) + 5, CGRectGetMinY(_userAvatarRect) + CGRectGetHeight(_userAvatarRect)/4, kScreenWidth/2, 20);
    
    /**
     5.描述frame
     */
    CGFloat descLabelHeight = [_model.desc sizeWithFontSize:13 maxSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)].height;
    
    if (_model.userAvatar) {
        
        _descRect = CGRectMake(10, CGRectGetMaxY(_userAvatarRect) + 10, kScreenWidth - 20, descLabelHeight);
    }else
    {
        _descRect = CGRectMake(10, CGRectGetMaxY(_picTitleRect) + 10, kScreenWidth - 20, descLabelHeight);
    }
    
    /**
     6.cell高度
     */
    
        if (_model.desc) {
            
            _cellHeight = CGRectGetMaxY(_descRect) + 20;
        }else
        {
            _cellHeight = CGRectGetMaxY(_userAvatarRect) + 20;
        }
}
@end
