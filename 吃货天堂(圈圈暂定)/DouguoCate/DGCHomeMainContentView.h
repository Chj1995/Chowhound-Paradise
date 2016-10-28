//
//  DGCHomeMainContentView.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 点击物品跳转界面的回调
 */
typedef void(^DGCHomeMainContentViewChangeViewCtrollerCallback)(NSString *type,NSString *picId);
/**
 点击广告栏cell的回调
 */
typedef void(^DGCHomeMainContentViewSelectedCallback)(NSString* picId);

/**
 下拉刷新
 */
typedef void(^DGCHomeMainContentViewHeaderUpdateCallback)(void);
/**
 上拉刷新
 */
typedef void(^DGCHomeMainContentViewFootUpdateCallback)(void);

@interface DGCHomeMainContentView : UIView
/**
 点击物品跳转界面的回调
 */
@property(nonatomic,copy)DGCHomeMainContentViewChangeViewCtrollerCallback homeMainContentViewChangeViewCtrollerCallback;
-(void)setHomeMainContentViewChangeViewCtrollerCallback:(DGCHomeMainContentViewChangeViewCtrollerCallback)homeMainContentViewChangeViewCtrollerCallback;

/**
 点击广告栏cell的回调
 */
@property(nonatomic,copy)DGCHomeMainContentViewSelectedCallback homeMainContentViewSelectedCallback;
-(void)setHomeMainContentViewSelectedCallback:(DGCHomeMainContentViewSelectedCallback)homeMainContentViewSelectedCallback;

/**
 下拉刷新
 */
@property(nonatomic,copy)DGCHomeMainContentViewHeaderUpdateCallback homeMainContentViewHeaderUpdateCallback;
-(void)setHomeMainContentViewHeaderUpdateCallback:(DGCHomeMainContentViewHeaderUpdateCallback)homeMainContentViewHeaderUpdateCallback;
/**
 上拉刷新
 */
@property(nonatomic,copy)DGCHomeMainContentViewFootUpdateCallback homeMainContentViewFootUpdateCallback;
-(void)setHomeMainContentViewFootUpdateCallback:(DGCHomeMainContentViewFootUpdateCallback)homeMainContentViewFootUpdateCallback;

@property(nonatomic,strong)NSArray *adArray;

@property(nonatomic,strong)NSArray *adToolArray;

@property(nonatomic,strong)NSArray *goodsArray;
/**
 结束刷新
 */
-(void)endRefresh;

@end
