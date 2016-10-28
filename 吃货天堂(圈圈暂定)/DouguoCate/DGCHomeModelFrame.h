//
//  DGCHomeModelFrame.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/9.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCHomeModel.h"
#import <CoreGraphics/CoreGraphics.h>

@interface DGCHomeModelFrame : NSObject

@property(nonatomic,strong)DGCHomeModel *model;

/**
 图片Frame
 */
@property(nonatomic,readonly)CGRect picRect;

/**
 标题Frame
 */
@property(nonatomic,readonly)CGRect picTitleRect;

/**
 用户头像frame
 */
@property(nonatomic,readonly)CGRect userAvatarRect;

/**
 用户名frame
 */
@property(nonatomic,readonly)CGRect userNameRect;

/**
 描述frame
 */
@property(nonatomic,readonly)CGRect descRect;

/**
 cell高度
 */
@property(nonatomic,assign)CGFloat cellHeight;

@end
