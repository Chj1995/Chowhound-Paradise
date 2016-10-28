//
//  DGCVideoView.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/11.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCVideoView.h"
#import "DGCConfig.h"
#import "NSString+Size.h"

@interface DGCVideoView ()

@property(nonatomic,weak)UIScrollView *scrollView;


@end
@implementation DGCVideoView
#pragma mark - 懒加载
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderViewHeight)];
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        _scrollView = scrollView;
        
        [self setupChildrenView];
    }
    return _scrollView;
}

#pragma mark - setter方法
-(void)setToolArray:(NSArray *)toolArray
{
    _toolArray = toolArray;
    
    [self scrollView];
}
#pragma mark - 创建子视图
-(void)setupChildrenView
{
    CGFloat width = kScreenWidth/5;
    
    for (int i = 0; i < _toolArray.count; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * (width+2), 0, width, kHeaderViewHeight)];
        view.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:view];
        
        //设置按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, width, kHeaderViewHeight - 3);
        [button setTitle:_toolArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        //设置下划线
        CGSize titleSize = [_toolArray[i] sizeWithFontSize:17 maxSize:CGSizeMake(kScreenWidth/5, 20)];
        UIImageView *scrollBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/10 - titleSize.width/2, button.frame.size.height - 3, titleSize.width, 2)];
        scrollBarImageView.backgroundColor  = [UIColor whiteColor];
        scrollBarImageView.tag = 2000 + i;
        [view addSubview:scrollBarImageView];
        
        if (i == 0) {
            
            button.selected = YES;
            scrollBarImageView.backgroundColor = [UIColor orangeColor];
        }
    }
    self.scrollView.contentSize = CGSizeMake(_toolArray.count * (width+2), kHeaderViewHeight);
}
-(void)buttonSelected:(UIButton *)sender
{
    for (int i = 0; i < _toolArray.count; i++) {
        
        UIButton *button = [self viewWithTag:1000+i];
        button.selected = NO;
        
        UIImageView *scrollBarImageView = [self viewWithTag:2000 + i];
        scrollBarImageView.backgroundColor = [UIColor whiteColor];
    }
    
    UIImageView *imageView = [self viewWithTag:sender.tag + 1000];
    sender.selected = !sender.isSelected;
    
    if (sender.selected) {
        
        imageView.backgroundColor = [UIColor orangeColor];
        
    }else
    {
        imageView.backgroundColor = [UIColor whiteColor];
    }
    
    [self buttonSelectedCallbackWithIndex:sender.tag - 1000];
}

#pragma mark - 回调
-(void)buttonSelectedCallbackWithIndex:(NSInteger)index
{
    if (_videoViewCellSelectedCallback) {
        
        _videoViewCellSelectedCallback(index);
    }
}
@end
