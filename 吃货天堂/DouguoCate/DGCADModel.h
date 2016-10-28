//
//  DGCADModel.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCBaseModel.h"

@interface DGCADModel : DGCBaseModel

/**
 图片
 */
@property(nonatomic,strong)NSString *picUrl;

/**
 图片Id
 */
@property(nonatomic,strong)NSString *picId;

/**
 图片名称
 */
@property(nonatomic,strong)NSString *picTitle;

/**
 用户Id
 */
@property(nonatomic,strong)NSString *userId;

/**
 用户头像
 */
@property(nonatomic,strong)NSString *userAvatar;

/**
 用户昵称
 */
@property(nonatomic,strong)NSString *userName;

/**
 用户是否是vip
 */
@property(nonatomic,strong)NSString *userVip;

@end
