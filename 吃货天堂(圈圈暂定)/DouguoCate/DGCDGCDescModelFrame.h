//
//  DGCDGCDescModelFrame.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/7.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "DGCDescModel.h"
@interface DGCDGCDescModelFrame : NSObject

@property(nonatomic,strong)DGCDescModel *model;
/**
 1.图片Frame
 */
@property(nonatomic,readonly)CGRect picImageViewRect;
/**
 2.标题Frame
 */
@property(nonatomic,readonly)CGRect titleLabelRect;
/**
 3.描述Frame
 */
@property(nonatomic,readonly)CGRect descLabelRect;
/**
 4.故事内容Frame
 */
@property(nonatomic,readonly)CGRect cookstoryLabelRect;
/**
 5.用户头像
 */
@property(nonatomic,readonly)CGRect userIconRect;
/**
 6.用户昵称
 */
@property(nonatomic,readonly)CGRect userNameRect;

/**
 7.时间Frame
 */
@property(nonatomic,readonly)CGRect timeImageViewRect;
/**
 8.难度Frame
 */
@property(nonatomic,readonly)CGRect gradeImageViewRect;
/**
 9.建议Frame
 */
@property(nonatomic,readonly)CGRect adviceImageViewRect;

/**
 *  10.cell的高度
 */
@property (nonatomic) CGFloat cellHeight;


@end
