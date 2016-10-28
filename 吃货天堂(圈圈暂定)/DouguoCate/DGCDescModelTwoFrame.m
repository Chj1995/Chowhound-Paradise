//
//  DGCDescModelTwoFrame.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCDescModelTwoFrame.h"
#import "NSString+Size.h"
#import "DGCConfig.h"

@implementation DGCDescModelTwoFrame
-(void)setModel:(DGCDescModelTwo *)model
{
    _model = model;
    
    //1.图片
    if ([_model.position isEqualToString:@"1"]) {
        
        _imageViewRect = CGRectMake(10, 50, kScreenWidth - 20, kScreenWidth/2);
    }else
    {
        _imageViewRect = CGRectMake(10, 10, kScreenWidth - 20, kScreenWidth/2);
    }
    //有图片情况
    if (![_model.image isEqualToString:@""]) {
        //2.描述
        CGSize contentLabelSize = [_model.content sizeWithFontSize:15 maxSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)];
        _contentLabelRect = CGRectMake(10, CGRectGetMaxY(_imageViewRect) + 5, kScreenWidth - 20, contentLabelSize.height);
    }else
    {
        if ([_model.position isEqualToString:@"1"]) {
            
            //2.描述
            CGSize contentLabelSize = [_model.content sizeWithFontSize:15 maxSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)];
            _contentLabelRect = CGRectMake(10, 50, kScreenWidth - 20, contentLabelSize.height);

        }else
        {
            //2.描述
            CGSize contentLabelSize = [_model.content sizeWithFontSize:15 maxSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)];
            _contentLabelRect = CGRectMake(10, 10, kScreenWidth - 20, contentLabelSize.height);

        }
            }
    
    //3.cell的高度
    _cellHeight = CGRectGetMaxY(_contentLabelRect) + 10;
    
}

@end
