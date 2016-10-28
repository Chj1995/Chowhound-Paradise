//
//  DGCDescModel.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/7.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGCDescModel : NSObject

/**
 图片url
 */
@property(nonatomic,strong)NSString *picUrl;

/**
 标题
 */
@property(nonatomic,strong)NSString *picTitle;

/**
 浏览人数
 */
@property(nonatomic,strong)NSString *vc;

/**
 收藏人数
 */
@property(nonatomic,strong)NSString *favo_counts;

/**
 做过人数
 */
@property(nonatomic,strong)NSString *dish_count;

/**
 故事
 */
@property(nonatomic,strong)NSString *cookstory;

/**
 用户头像
 */
@property(nonatomic,strong)NSString *user_photo;

/**
 用户vip
 */
@property(nonatomic,strong)NSString *verified;

/**
 用户昵称
 */
@property(nonatomic,strong)NSString *userName;

/**
 时间
 */
@property(nonatomic,strong)NSString *time;

/**
 难度
 */
@property(nonatomic,strong)NSString *grade;

/**
 建议
 */
@property(nonatomic,strong)NSString *advice;

/**
 食材名字
 */
@property(nonatomic,strong)NSString *major_title;

/**
 食材数量
 */
@property(nonatomic,strong)NSString *major_note;

/**
 视频链接
 */
@property(nonatomic,strong)NSString *vu;


@end
