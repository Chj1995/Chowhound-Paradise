//
//  DGCHomeModel.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/6.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGCHomeModel : NSObject

/**
 图片
 */
@property(nonatomic,strong)NSString *picUrl;

/**
 图片ID
 */
@property(nonatomic,strong)NSString *picId;

/**
 标题
 */
@property(nonatomic,strong)NSString *picTitle;

/**
 描述
 */
@property(nonatomic,strong)NSString *desc;

/**
 用户名
 */
@property(nonatomic,strong)NSString *userName;

/**
 用户头像
 */
@property(nonatomic,strong)NSString *userAvatar;

/**
 用户vip
 */
@property(nonatomic,strong)NSString *userVip;

/**
 观看数
 */
@property(nonatomic,strong)NSString *vc;

/**
 收藏数
 */
@property(nonatomic,strong)NSString *fc;

/**
 跳转链接
 */
@property(nonatomic,strong)NSString *url;

/**
 观看视频链接
 */
@property(nonatomic,strong)NSString *vu;

/**
 类型
 */
@property(nonatomic,strong)NSString *type;

@end
