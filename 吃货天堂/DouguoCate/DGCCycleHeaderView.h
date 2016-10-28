//
//  DGCCycleHeaderView.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 跳转到帖子详情界面
 */
typedef void(^DGCCycleHeaderViewChangeToDetailViewCtrlCallback)(NSString *picU);

@interface DGCCycleHeaderView : UIView
/**
 跳转到帖子详情界面
 */
@property(nonatomic,copy)DGCCycleHeaderViewChangeToDetailViewCtrlCallback cycleHeaderViewChangeToDetailViewCtrlCallback;
-(void)setCycleHeaderViewChangeToDetailViewCtrlCallback:(DGCCycleHeaderViewChangeToDetailViewCtrlCallback)cycleHeaderViewChangeToDetailViewCtrlCallback;

@property(nonatomic,strong)NSArray *bsArray;

@end
