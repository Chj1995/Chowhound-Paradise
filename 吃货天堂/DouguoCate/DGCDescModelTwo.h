//
//  DGCDescModelTwo.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/7.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCBaseModel.h"
@interface DGCDescModelTwo : DGCBaseModel

/**
 操作步骤介绍
 */
@property(nonatomic,strong)NSString *content;

/**
 操作步骤的图片
 */
@property(nonatomic,strong)NSString *image;

/**
 操作步骤的序数
 */
@property(nonatomic,strong)NSString *position;

@property(nonatomic,strong)NSString *thumb;

@end
