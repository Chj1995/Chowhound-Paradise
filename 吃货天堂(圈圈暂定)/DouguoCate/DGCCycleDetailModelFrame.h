//
//  DGCCycleDetailModelFrame.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCCycleDetailModel.h"
#import <CoreGraphics/CoreGraphics.h>

@interface DGCCycleDetailModelFrame : NSObject

@property(nonatomic,strong)DGCCycleDetailModel *model;

/**
 头像Frame
 */
@property(nonatomic,readonly)CGRect userAvatarRect;
/**
 用户名Frame
 */
@property(nonatomic,readonly)CGRect userNameRect;
/**
 发表时间Frame
 */
@property(nonatomic,readonly)CGRect timeRect;

/**
 cell的高度
 */
@property(nonatomic,readonly)CGFloat cellHeight;

@end
