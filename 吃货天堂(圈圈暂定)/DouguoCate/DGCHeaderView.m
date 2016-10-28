//
//  DGCHeaderView.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCHeaderView.h"
#import "DGCADView.h"
#import "DGCADToolView.h"
#import "DGCConfig.h"
@interface DGCHeaderView ()
{
    DGCADView *adView;
    DGCADToolView *adToolView;
}

@end
@implementation DGCHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        __weak DGCHeaderView *weekSelf = self;
        
        //广告栏
        adView = [[DGCADView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kADViewHeight)];
        [adView setAdViewSelectedCallback:^(NSString* picId) {
            
            [weekSelf selectedCallbackWithPicId:picId];
            
        }];
        [self addSubview:adView];
        
        adToolView = [[DGCADToolView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(adView.frame), kScreenWidth, self.frame.size.height - CGRectGetMaxY(adView.frame))];
        
        [adToolView setADToolViewDisSelectedCallback:^(NSString *picId) {
            
            [weekSelf selectedCallbackWithPicId:picId];
            
        }];
        [self addSubview:adToolView];
    }
    return self;
}
#pragma mark - 回调
-(void)selectedCallbackWithPicId:(NSString *)picId
{
    if (_headerViewSelectedCallback) {
        
        _headerViewSelectedCallback(picId);
    }
}
#pragma mark - setter方法
-(void)setAdArray:(NSArray *)adArray
{
    _adArray = adArray;
    adView.adArray = adArray;
}
-(void)setAdToolArray:(NSArray *)adToolArray
{
    _adToolArray = adToolArray;
    adToolView.adToolArray = adToolArray;
}

@end
