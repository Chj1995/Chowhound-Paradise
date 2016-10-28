//
//  DGCContentsConfig.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#ifndef DGCContentsConfig_h
#define DGCContentsConfig_h

//屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

//屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//主题颜色
#define kAppTintColor [UIColor colorWithRed:246.0/255.0 green:95.0/255.0 blue:45.0/255.0 alpha:1]

//cell的背景颜色
#define kCellBackGroundColor [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1]

//视频专区头部视图的高度
#define kHeaderViewHeight 40

//广告栏的高度
#define kADViewHeight kScreenHeight/3

//列表的高度
#define kListCellHeight 80

//写食派tableview列表的cell高度
#define kListDishCellHeight kADViewHeight + 70

//趣视频cell的高度
#define kFunVideoCellHeight kADViewHeight + 100

//圈圈界面的趣视频后的显示全部界面cell的高度
#define kCycleAllDataCellHeight 100

#endif /* DGCContentsConfig_h */
