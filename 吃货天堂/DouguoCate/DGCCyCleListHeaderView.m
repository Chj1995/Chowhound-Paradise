//
//  DGCCollectionHeaderView.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCyCleListHeaderView.h"
#import "DGCConfig.h"

@interface DGCCyCleListHeaderView ()
{
    UILabel *label;
    UIButton *buttonOne;
    UIButton *buttonTwo;
}

@end
@implementation DGCCyCleListHeaderView
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupSubView];
}
-(void)setupSubView
{
    [label removeFromSuperview];
    [buttonOne removeFromSuperview];
    [buttonTwo removeFromSuperview];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 20)];
    label.text = @"全部";
    label.font = [UIFont systemFontOfSize:20];
    [self addSubview:label];
    
    CGFloat buttonWidth = 20;
    CGFloat buttonHeight = 20;
    CGFloat buttonSpace = 15;
    
    //按钮1
    buttonOne = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonOne.frame  =CGRectMake(kScreenWidth - buttonSpace * 2 - 2 * buttonWidth, 10, buttonWidth, buttonHeight);
    buttonOne.tag = 1000;
    [buttonOne addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonOne];
    
    //按钮2
    buttonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonTwo.frame = CGRectMake(kScreenWidth - buttonSpace - buttonWidth, 10, buttonWidth, buttonHeight);

    buttonTwo.tag = 2000;
    [buttonTwo addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:buttonTwo];
    
    if (_isCollectionView)
    {
        [buttonOne setBackgroundImage:[UIImage imageNamed:@"dish_simple_selected"] forState:UIControlStateNormal];
        [buttonTwo setBackgroundImage:[UIImage imageNamed:@"dish_detail_unselected"] forState:UIControlStateNormal];
    }
    else
    {
        [buttonOne setBackgroundImage:[UIImage imageNamed:@"dish_simple_unselected"] forState:UIControlStateNormal];
        [buttonTwo setBackgroundImage:[UIImage imageNamed:@"dish_detail_selected"] forState:UIControlStateNormal];
    }
}
#pragma mark - 按钮点击跳转界面
-(void)buttonClick:(UIButton *)sender
{

    if (_cyCleListHeaderViewChangeViewCallBack) {
        
        _cyCleListHeaderViewChangeViewCallBack(sender.tag);
    }
}
@end
