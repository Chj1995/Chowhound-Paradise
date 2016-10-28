//
//  SWNavigationBarView.m
//  StarWardrobes
//
//  Created by qianfeng on 16/9/30.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "MyNavigationBarView.h"
#import "NSString+Size.h"
#import "DGCConfig.h"

@interface MyNavigationBarView ()
{
    UIView *titleView;
}

@end
@implementation MyNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

/**
 创建导航栏视图
 */
-(void)setupView
{
   titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, 50)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:titleView];
    
    UIImageView *lineBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, self.frame.size.width, 1)];
    lineBackImageView.backgroundColor = [UIColor lightGrayColor];
    [titleView addSubview:lineBackImageView];
    
    
    //返回按钮
    UIImage *btnImage = [UIImage imageNamed:@"tab_icon_back"];
    CGSize imageSize = btnImage.size;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, titleView.frame.size.height/2 - imageSize.width/2, imageSize.width, imageSize.height);
    [backBtn setImage:btnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:backBtn];
}

/**
 设置主题名

 @param title         <#title description#>
 @param titleFontSize <#titleFontSize description#>
 */
-(void)setupTitleLableWithTitle:(NSString *)title TitleSize:(CGFloat)titleFontSize
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, kScreenWidth/2, 20);
    titleLabel.center = titleView.center;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:titleFontSize weight:1];
    [titleView addSubview:titleLabel];
}
-(void)goToBack
{
    if (_navigationBarViewGoToBackCallback) {
        
        _navigationBarViewGoToBackCallback();
    }
}

@end
