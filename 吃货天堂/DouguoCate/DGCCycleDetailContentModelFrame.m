//
//  DGCCycleDetailContentModelFrame.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/15.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleDetailContentModelFrame.h"
#import "NSString+Size.h"
#import "DGCConfig.h"

@implementation DGCCycleDetailContentModelFrame
-(void)setModel:(DGCCycleDetailContentModel *)model
{
    _model = model;
    
    /**
     消息Frame
     */
    CGFloat activityContentHeight = [_model.activityContent sizeWithFontSize:15 maxSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)].height;
    _activityContentRect = CGRectMake(10, 10, kScreenWidth - 20, activityContentHeight);
    /**
     图片Frame
     */
    _activityContentPicUrlRect = CGRectMake(10, CGRectGetMaxY(_activityContentRect)+5, kScreenWidth - 20, kADViewHeight);
    /**
     cell的高度
     */
    if (_model.activityContentPicUrl.length != 0) {
        
        _cellHeight = CGRectGetMaxY(_activityContentPicUrlRect) + 10;
    }else
    {
        _cellHeight = CGRectGetMaxY(_activityContentRect) + 10;
    }
    
}
@end
