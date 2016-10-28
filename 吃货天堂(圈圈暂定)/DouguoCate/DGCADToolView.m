//
//  DGCADToolView.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCADToolView.h"
#import "DGCConfig.h"
#import "DGCADToolViewCell.h"
#import "DGCADToolViewModel.h"

@interface DGCADToolView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,weak)UICollectionView *collectionView;

@end
@implementation DGCADToolView
#pragma mark - 懒加载
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        //横向滚动
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        //清空行距
        layout.minimumLineSpacing = 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        //关闭弹簧效果
        collectionView.bounces = NO;
        
        //开启翻页模式
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:collectionView];
        
        [collectionView registerClass:[DGCADToolViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}
#pragma mark - setter方法
-(void)setAdToolArray:(NSArray *)adToolArray
{
    _adToolArray = adToolArray;
    
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _adToolArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DGCADToolViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = _adToolArray[indexPath.item];

    return cell;
}

/**
 设置cell的大小

 @param collectionView       <#collectionView description#>
 @param collectionViewLayout <#collectionViewLayout description#>
 @param indexPath            <#indexPath description#>

 @return <#return value description#>
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = kScreenWidth / _adToolArray.count;
    CGFloat height = self.frame.size.height;
    return CGSizeMake(width, height);
}
#pragma mark - 回调
-(void)selectedCallback:(NSString *)picId
{
    if (_aDToolViewDisSelectedCallback) {
        
        _aDToolViewDisSelectedCallback(picId);
    }
}
#pragma mark - 点击时触发
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DGCADToolViewModel *model = _adToolArray[indexPath.item];
    
    [self selectedCallback:model.picId];
}
@end
