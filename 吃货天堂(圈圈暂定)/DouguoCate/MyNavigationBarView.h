//
//  SWNavigationBarView.h
//  StarWardrobes
//
//  Created by qianfeng on 16/9/30.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 返回按钮的回调
 */
typedef void(^MyNavigationBarViewGoToBackCallback)(void);

@interface MyNavigationBarView : UIView
/**
 返回按钮的回调
 */
@property(nonatomic,copy)MyNavigationBarViewGoToBackCallback navigationBarViewGoToBackCallback;
-(void)setNavigationBarViewGoToBackCallback:(MyNavigationBarViewGoToBackCallback)navigationBarViewGoToBackCallback;

/**
 创建主题

 @param title         主题
 @param titleFontSize 主题字的大小
 */
-(void)setupTitleLableWithTitle:(NSString *)title TitleSize:(CGFloat)titleFontSize;

@end
