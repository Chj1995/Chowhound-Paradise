//
//  DGCCycleHeaderView.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleHeaderView.h"
#import "DGCCycleADViewCell.h"
#import "DGCCycleADViewModel.h"
#import "DGCConfig.h"

/**
 滚动条的宽度
 */
#define kScrollBarWidth kScreenWidth/_bsArray.count
/**
 滚动条的高度
 */
#define kScrollBarHeight 2

@interface DGCCycleHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,weak)UICollectionView *collectionView;

/**
 滚动条
 */
@property(nonatomic,weak)UIImageView *scrollBar;

@end
@implementation DGCCycleHeaderView
#pragma mark - 懒加载
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        
        //横向滚动
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        //设置Cell的大小
        layout.itemSize = self.frame.size;
        
        //清空行距
        layout.minimumLineSpacing = 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        
        //关闭弹簧效果
        collectionView.bounces = NO;
        
        //关闭滚动条
        collectionView.showsHorizontalScrollIndicator = NO;
        
        //开启翻页模式
        collectionView.pagingEnabled = YES;
        
        [self addSubview:collectionView];
        
        [collectionView registerClass:[DGCCycleADViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}
-(UIImageView *)scrollBar
{
    if (!_scrollBar) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kScrollBarHeight, kScrollBarWidth, kScrollBarHeight)];
        imageView.backgroundColor  = [UIColor redColor];
        [self addSubview:imageView];
        _scrollBar = imageView;
    }
    return _scrollBar;
}
#pragma mark - setter方法
-(void)setBsArray:(NSArray *)bsArray
{
    _bsArray = bsArray;
    
    [self.collectionView reloadData];
    
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_bsArray.count > 1)
    {
        [self scrollBar];
    }
    
    return _bsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DGCCycleADViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = _bsArray[indexPath.item];
    return cell;
}
#pragma mark - 滚动时触发
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.5 animations:^{
        
        CGPoint offset = self.collectionView.contentOffset;
        
        CGFloat index = offset.x / CGRectGetWidth(self.collectionView.frame);
        
        CGRect frame  = self.scrollBar.frame;
        
        frame.origin.x = index * kScrollBarWidth;
        
        self.scrollBar.frame = frame;
    }];
}
#pragma mark - 回调
-(void)changToDetailViewCtrlCallbackWithPicU:(NSString *)picU
{
    if (_cycleHeaderViewChangeToDetailViewCtrlCallback) {
        
        _cycleHeaderViewChangeToDetailViewCtrlCallback(picU);
    }
}

#pragma mark - 点击跳转
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DGCCycleADViewModel *model = _bsArray[indexPath.item];
    
    [self changToDetailViewCtrlCallbackWithPicU:model.picU];
}
@end
