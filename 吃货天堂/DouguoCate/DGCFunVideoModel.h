//
//  DGCFunVideoModel.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/18.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGCFunVideoModel : NSObject

/**
 图片
 */
@property(nonatomic,strong)NSString *imageUrl;

/**
 视频链接
 */
@property(nonatomic,strong)NSString *videoUrl;

/**
 观看次数
 */
@property(nonatomic,strong)NSString *videoCount;

/**
 标题
 */
@property(nonatomic,strong)NSString *title;

/**
 用户头像
 */
@property(nonatomic,strong)NSString *userIcon;

/**
 是否认证
 */
@property(nonatomic,strong)NSString *verified;

/**
 用户名
 */
@property(nonatomic,strong)NSString *userName;

/**
 图片Id
 */
@property(nonatomic,strong)NSString *imageId;

@end
