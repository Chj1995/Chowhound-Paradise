//
//  DGCCycleDetailModel.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGCCycleDetailModel : NSObject

/**
 用户名
 */
@property(nonatomic,strong)NSString *userName;


/**
 头像
 */
@property(nonatomic,strong)NSString *userAvatar;


/**
 认证
 */
@property(nonatomic,strong)NSString *verified;

/**
 是否是楼主
 */
@property(nonatomic,strong)NSString *fl;

/**
 发表时间
 */
@property(nonatomic,strong)NSString *time;

/**
 楼层数
 */
@property(nonatomic,strong)NSString *f;

/**
 内容数据源
 */
@property(nonatomic,strong)NSMutableArray *contentArray;


@end
