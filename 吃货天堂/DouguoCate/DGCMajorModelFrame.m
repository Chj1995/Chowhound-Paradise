//
//  DGCMajorModelFrame.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/11.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCMajorModelFrame.h"
#import "DGCConfig.h"
#import "NSString+Size.h"

@implementation DGCMajorModelFrame

-(void)setModel:(DGCMajorModel *)model
{
    _model = model;
    
    /**
     食材名字Frame
     */
    CGFloat major_titleHeight = [_model.major_title sizeWithFontSize:17 maxSize:CGSizeMake(kScreenWidth/2, MAXFLOAT)].height;
    
    _major_titleRect = CGRectMake(0, 10, kScreenWidth/2, major_titleHeight);
    
    /**
     食材数量Frame
     */
    CGFloat major_noteHeight = [_model.major_note sizeWithFontSize:17 maxSize:CGSizeMake(kScreenWidth/3 - 10, MAXFLOAT)].height;
    
    _major_noteRect = CGRectMake(kScreenWidth/3*1.8, 10, kScreenWidth/3 - 10, major_noteHeight);
    
    /**
     cell高度
     */
    _cellHeight = MAX(CGRectGetMaxY(_major_titleRect), CGRectGetMaxY(_major_noteRect)) + 10;
    
}
@end
