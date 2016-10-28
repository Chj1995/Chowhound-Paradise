//
//  DGCChooseLisetModelOne.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCBaseModel.h"

@interface DGCChooseLisetModelOne : DGCBaseModel

/**
 标题
 */
@property(nonatomic,strong)NSString *title;


/**
 头像
 */
@property(nonatomic,strong)NSString *avatar_medium;

/**
 认证
 */
@property(nonatomic,strong)NSString *verified;

/**
 昵称
 */
@property(nonatomic,strong)NSString *nickname;

/**
 描述
 */
@property(nonatomic,strong)NSString *desc;

/**
 菜谱数目
 */
@property(nonatomic,strong)NSString *c;

@end
