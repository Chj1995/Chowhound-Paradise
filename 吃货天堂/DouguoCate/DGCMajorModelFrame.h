//
//  DGCMajorModelFrame.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/11.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCMajorModel.h"
#import <CoreGraphics/CoreGraphics.h>

@interface DGCMajorModelFrame : NSObject

@property(nonatomic,strong)DGCMajorModel *model;

/**
 食材名字Frame
 */
@property(nonatomic,readonly)CGRect major_titleRect;

/**
 食材数量Frame
 */
@property(nonatomic,readonly)CGRect major_noteRect;

/**
 cell高度
 */
@property(nonatomic,assign,readonly)CGFloat cellHeight;

@end
