//
//  DGCCycleListContentModel.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCBaseModel.h"
@interface DGCCycleListContentModel : DGCBaseModel

/**
 图片
 */
@property(nonatomic,strong)NSString *image;

/**
 用户头像
 */
@property(nonatomic,strong)NSString *user_photo;

/**
 是否认证
 */
@property(nonatomic,strong)NSString *verified;

/**
 用户名
 */
@property(nonatomic,strong)NSString *nickname;

/**
 发布时间
 */
@property(nonatomic,strong)NSString *publishtime;

/**
 发表时间用来显示年月日
 */
@property(nonatomic,strong)NSString *publishtimeSecond;

/**
 Id
 */
@property(nonatomic,strong)NSString *dishId;

@end
