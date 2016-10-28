//
//  DGCADToolView.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 点击cell的回调
 */
typedef void(^DGCADToolViewDisSelectedCallback)(NSString* picId);

@interface DGCADToolView : UIView
/**
 点击cell的回调
 */
@property(nonatomic,copy)DGCADToolViewDisSelectedCallback aDToolViewDisSelectedCallback;
-(void)setADToolViewDisSelectedCallback:(DGCADToolViewDisSelectedCallback)aDToolViewDisSelectedCallback;

@property(nonatomic,strong)NSArray *adToolArray;

@end
