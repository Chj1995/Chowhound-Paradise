//
//  DGCCycleListContentView.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 跳转到写食派内容界面
 */
typedef void(^DGCCycleListContentViewChangeToDishContentViewCtrlCallBack)(NSString *dishId);
/**
 上拉刷新的回调
 */
typedef void(^DGCCycleListContentViewFootUpdateCallBack)(void);
/**
 下拉刷新的回调
 */
typedef void(^DGCCycleListContentViewHeaderUpdateCallBack)(void);
/**
 点击表头按钮，切换界面的回调
 */
typedef void(^DGCCycleListContentViewChangeViewCallBack)(NSInteger tag);

@interface DGCCycleListContentView : UIView
/**
 跳转到写食派内容界面
 */
@property(nonatomic,copy)DGCCycleListContentViewChangeToDishContentViewCtrlCallBack cycleListContentViewChangeToDishContentViewCtrlCallBack;
-(void)setCycleListContentViewChangeToDishContentViewCtrlCallBack:(DGCCycleListContentViewChangeToDishContentViewCtrlCallBack)cycleListContentViewChangeToDishContentViewCtrlCallBack;
/**
 上拉刷新的回调
 */
@property(nonatomic,copy)DGCCycleListContentViewFootUpdateCallBack cycleListContentViewFootUpdateCallBack;
-(void)setCycleListContentViewFootUpdateCallBack:(DGCCycleListContentViewFootUpdateCallBack)cycleListContentViewFootUpdateCallBack;

/**
 下拉刷新的回调
 */
@property(nonatomic,copy)DGCCycleListContentViewHeaderUpdateCallBack cycleListContentViewHeaderUpdateCallBack;
-(void)setCycleListContentViewHeaderUpdateCallBack:(DGCCycleListContentViewHeaderUpdateCallBack)cycleListContentViewHeaderUpdateCallBack;
/**
 点击表头按钮，切换界面的回调
 */
@property(nonatomic,copy)DGCCycleListContentViewChangeViewCallBack cycleListContentViewChangeViewCallBack;
-(void)setCycleListContentViewChangeViewCallBack:(DGCCycleListContentViewChangeViewCallBack)cycleListContentViewChangeViewCallBack;


@property(nonatomic,strong)NSArray *listDataSource;



//结束刷新
-(void)endFresh;

@end
