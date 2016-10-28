//
//  DGCADView.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCADView.h"
#import "DGCADViewCell.h"
#import "DGCConfig.h"

/**
 滚动条的宽度
 */
#define kScrollBarWidth self.frame.size.width/_adArray.count
/**
 滚动条的高度
 */
#define kScrollBarHeight 2

@interface DGCADView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,weak)UICollectionView *collectionView;

/**
 滚动条
 */
@property(nonatomic,weak)UIImageView *scrollBar;

@end

@implementation DGCADView
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
    
        //关闭弹簧效果
        collectionView.bounces = NO;
        
        //关闭滚动条
        collectionView.showsHorizontalScrollIndicator = NO;
        
        //开启翻页模式
        collectionView.pagingEnabled = YES;

        [self addSubview:collectionView];
        
        [collectionView registerClass:[DGCADViewCell class] forCellWithReuseIdentifier:@"cell"];
        
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
-(void)setAdArray:(NSArray *)adArray
{
    _adArray = adArray;
    
    [self.collectionView reloadData];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [self scrollBar];
    return _adArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DGCADViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = _adArray[indexPath.item];
    
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
-(void)selectedCallback:(NSString *)picId
{
    if (_adViewSelectedCallback) {
        
        _adViewSelectedCallback(picId);
    }
}
#pragma mark - 点击时触发
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DGCADModel *model = _adArray[indexPath.item];
    
    [self selectedCallback:model.picId];
}


@end
