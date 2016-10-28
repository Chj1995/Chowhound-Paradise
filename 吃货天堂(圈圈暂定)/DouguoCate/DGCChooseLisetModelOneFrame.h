//
//  DGCChooseLisetModelOneFrame.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCChooseLisetModelOne.h"
#import <CoreGraphics/CoreGraphics.h>

@interface DGCChooseLisetModelOneFrame : NSObject

@property(nonatomic,strong)DGCChooseLisetModelOne *model;

/**
 标题Frame
 */
@property(nonatomic,readonly)CGRect titleLabelRect;


/**
 头像Frame
 */
@property(nonatomic,readonly)CGRect userAvatarImageRect;


/**
 昵称Frame
 */
@property(nonatomic,readonly)CGRect userNameLabelRect;


/**
 描述Frame
 */
@property(nonatomic,readonly)CGRect descLabelRect;

/**
 菜谱数Frame
 */
@property(nonatomic,readonly)CGRect cLabelRect;

/**
 cell高度
 */
@property(nonatomic,assign)CGFloat cellHeight;

@end
