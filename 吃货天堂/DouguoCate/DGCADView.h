//
//  DGCADView.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 点击cell时的回调

 @param picId <#picId description#>
 */
typedef void(^DGCADViewSelectedCallback)(NSString* picId);

@interface DGCADView : UIView

@property(nonatomic,copy)DGCADViewSelectedCallback adViewSelectedCallback;
-(void)setAdViewSelectedCallback:(DGCADViewSelectedCallback)adViewSelectedCallback;


@property(nonatomic,strong)NSArray *adArray;

@end
