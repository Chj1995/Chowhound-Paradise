//
//  DGCCollectionHeaderView.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 切换界面的回调
 */
typedef void(^DGCCyCleListHeaderViewChangeViewCallBack)(NSInteger tag);

@interface DGCCyCleListHeaderView : UICollectionReusableView

/**
 切换界面的回调
 */
@property(nonatomic,copy)DGCCyCleListHeaderViewChangeViewCallBack cyCleListHeaderViewChangeViewCallBack;
-(void)setCyCleListHeaderViewChangeViewCallBack:(DGCCyCleListHeaderViewChangeViewCallBack)cyCleListHeaderViewChangeViewCallBack;

@property(nonatomic)BOOL isCollectionView;

@end
