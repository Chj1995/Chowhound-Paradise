//
//  DGCVideoView.h
//  DouguoCate
//
//  Created by qianfeng on 16/10/11.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^DGCVideoViewCellSelectedCallback)(NSInteger index);

@interface DGCVideoView : UIView

@property(nonatomic,copy)DGCVideoViewCellSelectedCallback videoViewCellSelectedCallback;
-(void)setVideoViewCellSelectedCallback:(DGCVideoViewCellSelectedCallback)videoViewCellSelectedCallback;

@property(nonatomic,strong)NSArray *toolArray;

@end
