//
//  DGCDescModelTwoFrame.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCDescModelTwo.h"
#import <CoreGraphics/CoreGraphics.h>

@interface DGCDescModelTwoFrame : NSObject

@property(nonatomic,strong)DGCDescModelTwo *model;

/**
 1.图片Frame
 */
@property(nonatomic,readonly)CGRect imageViewRect;

/**
 2.描述Frame
 */
@property(nonatomic,readonly)CGRect contentLabelRect;

/**
 *  3.cell的高度
 */
@property (nonatomic) CGFloat cellHeight;

@end
