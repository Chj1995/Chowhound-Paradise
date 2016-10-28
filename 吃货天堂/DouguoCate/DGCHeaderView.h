//
//  DGCHeaderView.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DGCHeaderViewSelectedCallback)(NSString* picId);

@interface DGCHeaderView : UIView

@property(nonatomic,copy)DGCHeaderViewSelectedCallback headerViewSelectedCallback;
-(void)setHeaderViewSelectedCallback:(DGCHeaderViewSelectedCallback)headerViewSelectedCallback;

@property(nonatomic,strong)NSArray *adArray;

@property(nonatomic,strong)NSArray *adToolArray;

@end
