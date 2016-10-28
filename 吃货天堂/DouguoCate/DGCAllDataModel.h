//
//  DGCAllDataModel.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/18.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGCAllDataModel : NSObject

/**
 用户头像
 */
@property(nonatomic,strong)NSString *userIcon;

/**
 认证
 */
@property(nonatomic,strong)NSString *verified;

/**
 用户昵称
 */
@property(nonatomic,strong)NSString *userName;

/**
 发表时间
 */
@property(nonatomic,strong)NSString *pulishTime;

/**
 发表时间用来显示年月日
 */
@property(nonatomic,strong)NSString *pulishTimeSecond;

/**
 标题
 */
@property(nonatomic,strong)NSString *title;

/**
 图片
 */
@property(nonatomic,strong)NSString *imageUrl;

/**
 图片张数
 */
@property(nonatomic,strong)NSString *imageCount;

/**
 Id
 */
@property(nonatomic,strong)NSString *listId;

@end
