//
//  DGCADToolViewModel.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/6.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGCADToolViewModel : NSObject

/**
 内容个数
 */
@property(nonatomic,strong)NSString *content;

/**
 图片
 */
@property(nonatomic,strong)NSString *picUrl;

/**
 图片ID
 */
@property(nonatomic,strong)NSString *picId;

/**
 标题
 */
@property(nonatomic,strong)NSString *picTitle;

@end
