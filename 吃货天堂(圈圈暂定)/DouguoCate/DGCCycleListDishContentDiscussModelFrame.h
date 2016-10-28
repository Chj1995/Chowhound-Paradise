//
//  DGCCycleListDishContentDiscussModelFrame.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/18.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCCycleListDishContentDiscussModel.h"
#import <CoreGraphics/CoreGraphics.h>

@interface DGCCycleListDishContentDiscussModelFrame : NSObject

@property(nonatomic,strong)DGCCycleListDishContentDiscussModel *model;

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
 发布内容
 */
@property(nonatomic,readonly)CGRect contentRect;

/**
 cell的高度
 */
@property(nonatomic,readonly)CGFloat cellHeight;


@end
