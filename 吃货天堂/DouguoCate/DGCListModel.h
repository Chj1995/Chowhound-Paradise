//
//  DGCListModel.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/15.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCBaseModel.h"
@interface DGCListModel : DGCBaseModel

/**
 围观人数
 */
@property(nonatomic,strong)NSString *cap;

/**
 标记图片
 */
@property(nonatomic,strong)NSString *ri;

/**
 描述
 */
@property(nonatomic,strong)NSString *st;

/**
 标题
 */
@property(nonatomic,strong)NSString *t;

/**
 标题图片
 */
@property(nonatomic,strong)NSString *u;

/**
 Id
 */
@property(nonatomic,strong)NSString *imageId;

@end
