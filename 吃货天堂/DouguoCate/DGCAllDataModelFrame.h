//
//  DGCAllDataModelFrame.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/19.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCAllDataModel.h"
#import <CoreGraphics/CoreGraphics.h>
@interface DGCAllDataModelFrame : NSObject

@property(nonatomic,strong)DGCAllDataModel *model;

/**
 用户头像
 */
@property(nonatomic,readonly)CGRect userIconRect;

/**
 用户昵称
 */
@property(nonatomic,readonly)CGRect userNameRect;

/**
 发布时间
 */
@property(nonatomic,readonly)CGRect pulishTimeRect;

/**
 内容图片
 */
@property(nonatomic,readonly)CGRect contentImageRect;

/**
 显示内容
 */
@property(nonatomic,readonly)CGRect contentRect;

/**
 cell高度
 */
@property(nonatomic,assign)CGFloat cellHeight;

@end
