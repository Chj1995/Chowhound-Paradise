//
//  DGCCycleDetailContentModelFrame.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/15.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCCycleDetailContentModel.h"
#import <CoreGraphics/CoreGraphics.h>

@interface DGCCycleDetailContentModelFrame : NSObject

@property(nonatomic,strong)DGCCycleDetailContentModel *model;
/**
 消息Frame
 */
@property(nonatomic,readonly)CGRect activityContentRect;
/**
 图片Frame
 */
@property(nonatomic,readonly)CGRect activityContentPicUrlRect;

/**
 cell的高度
 */
@property(nonatomic,readonly)CGFloat cellHeight;

@end
