//
//  DGCCycleDetailContentModel.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/15.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGCCycleDetailContentModel : NSObject

/**
 消息
 */
@property(nonatomic,strong)NSString *activityContent;

/**
 图片
 */
@property(nonatomic,strong)NSString *activityContentPicUrl;

/**
 视频链接
 */
@property(nonatomic,strong)NSString *vu;

@end
