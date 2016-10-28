//
//  DGCCycleListContentViewTwo.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 跳转到写食派内容界面
 */
typedef void(^DGCCycleListContentViewTwoChangeToDishContentViewCtrlCallBack)(NSString *dishId);
/**
 上拉刷新
 */
typedef void(^DGCCycleListContentViewTwoFootUpdateCallBack)(void);
/**
 下拉刷新
 */
typedef void(^DGCCycleListContentViewTwoHeaderUpdateCallBack)(void);

/**
 点击表头按钮切换界面的回调
 */
typedef void(^DGCCycleListContentViewTwoChangeViewCallBack)(NSInteger tag);

@interface DGCCycleListContentViewTwo : UIView
/**
 跳转到写食派内容界面
 */
@property(nonatomic,copy)DGCCycleListContentViewTwoChangeToDishContentViewCtrlCallBack cycleListContentViewTwoChangeToDishContentViewCtrlCallBack;
-(void)setCycleListContentViewTwoChangeToDishContentViewCtrlCallBack:(DGCCycleListContentViewTwoChangeToDishContentViewCtrlCallBack)cycleListContentViewTwoChangeToDishContentViewCtrlCallBack;

/**
 上拉刷新
 */
@property(nonatomic,copy)DGCCycleListContentViewTwoFootUpdateCallBack cycleListContentViewTwoFootUpdateCallBack;
-(void)setCycleListContentViewTwoFootUpdateCallBack:(DGCCycleListContentViewTwoFootUpdateCallBack)cycleListContentViewTwoFootUpdateCallBack;
/**
 下拉刷新
 */
@property(nonatomic,copy)DGCCycleListContentViewTwoHeaderUpdateCallBack cycleListContentViewTwoHeaderUpdateCallBack;
-(void)setCycleListContentViewTwoHeaderUpdateCallBack:(DGCCycleListContentViewTwoHeaderUpdateCallBack)cycleListContentViewTwoHeaderUpdateCallBack;
/**
 点击表头按钮切换界面的回调
 */
@property(nonatomic,copy)DGCCycleListContentViewTwoChangeViewCallBack cycleListContentViewTwoChangeViewCallBack;
-(void)setCycleListContentViewTwoChangeViewCallBack:(DGCCycleListContentViewTwoChangeViewCallBack)cycleListContentViewTwoChangeViewCallBack;

@property(nonatomic,strong)NSArray *listDataSource;



//结束刷新
-(void)endFresh;

@end
