//
//  DGCCycleListContentView.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleListContentView.h"
#import "DGCConfig.h"
#import "DGCCyCleListHeaderView.h"
#import "DGCCyCleListContentSimpleCell.h"
#import "MJRefresh.h"
#import "DGCCycleListContentModel.h"

@interface DGCCycleListContentView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,weak)UICollectionView *collectionView;

/**
 返回顶部
 */
@property(nonatomic,weak)UIButton *backToTopButton;

@end
@implementation DGCCycleListContentView
#pragma mark - 懒加载
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
       //cell的大小
        layout.itemSize = CGSizeMake(kScreenWidth/3 - 2, kScreenWidth/3 - 2);
        
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
    
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:collectionView];
        
        collectionView.showsVerticalScrollIndicator = NO;
        
        //注册cell
        [collectionView registerClass:[DGCCyCleListContentSimpleCell class] forCellWithReuseIdentifier:@"cell"];
        
        //注册表头
        [collectionView registerClass:[DGCCyCleListHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        //刷新
        collectionView.mj_header = [self header];
        collectionView.mj_footer = [self foot];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}
-(UIButton *)backToTopButton
{
    if (!_backToTopButton) {
        
        CGFloat buttonWidth = 40;
        CGFloat buttonHeight = 40;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kScreenWidth - 60, kScreenHeight/1.5, buttonWidth, buttonHeight);
        button.alpha  = 0;
        button.backgroundColor = kAppTintColor;
        button.layer.cornerRadius = buttonHeight/2;
        button.clipsToBounds = YES;
        [button setImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backToTopButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        _backToTopButton = button;
    }
    return _backToTopButton;
}
#pragma mark - 返回顶部按钮点击事件
-(void)backToTopButtonClick
{
    //1.滚动到头部
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
    //2.偏移量设为0
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGPoint offset = self.collectionView.contentOffset;
        offset.y = 0;
        self.collectionView.contentOffset = offset;
    });
}

#pragma mark - 刷新
/**
 下拉刷新
 */
- (MJRefreshNormalHeader *)header
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        [self headerUpdateCallBack];
    }];
    
    //隐藏上次刷新时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    
    return header;
}
/**
 上拉刷新
 */
-(MJRefreshBackNormalFooter *)foot
{
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self footUpdateCallBack];
        
    }];
    
    [foot setTitle:@"上拉刷新" forState:MJRefreshStateIdle];
    [foot setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [foot setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    
    return foot;
}
//结束刷新
-(void)endFresh
{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark - setter方法
-(void)setListDataSource:(NSArray *)listDataSource
{
    _listDataSource = listDataSource;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _listDataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DGCCyCleListContentSimpleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = _listDataSource[indexPath.item];

    return cell;
}
#pragma mark - UICollectionViewDelegate

/**
 表头

 @param collectionView <#collectionView description#>
 @param kind           <#kind description#>
 @param indexPath      <#indexPath description#>

 @return <#return value description#>
 */
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DGCCyCleListHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    headerView.isCollectionView = YES;
    //点击表头按钮切换界面的回调
    [headerView setCyCleListHeaderViewChangeViewCallBack:^(NSInteger tag) {
        
        [self headerViewChangViewCallBack:tag];
    }];
    
    return headerView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 40);
}
//点击
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DGCCycleListContentModel *model = _listDataSource[indexPath.item];
    
    [self changeToDishContentViewCtrlWithDishId:model.dishId];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = self.collectionView.contentOffset;
    
    [UIView animateWithDuration:1 animations:^{
        
        if (offset.y > kScreenHeight * 2)
        {
            self.backToTopButton.alpha = 0.6;
            
        }else
        {
            self.backToTopButton.alpha = 0;
        }
    }];
    
}

#pragma mark - 回调
/**
 点击头部按钮的回调
 */
-(void)headerViewChangViewCallBack:(NSInteger)tag
{
    if (_cycleListContentViewChangeViewCallBack) {
        
        _cycleListContentViewChangeViewCallBack(tag);
    }
}

/**
 下拉刷新回调
 */
-(void)headerUpdateCallBack
{
    if (_cycleListContentViewHeaderUpdateCallBack) {
        
        _cycleListContentViewHeaderUpdateCallBack();
    }
}
/**
 上拉刷新回调
 */
-(void)footUpdateCallBack
{
    if (_cycleListContentViewFootUpdateCallBack) {
        
        _cycleListContentViewFootUpdateCallBack();
    }
}

/**
 跳转到写食派内容界面
 */
-(void)changeToDishContentViewCtrlWithDishId:(NSString *)dishId
{
    if (_cycleListContentViewChangeToDishContentViewCtrlCallBack) {
        
        _cycleListContentViewChangeToDishContentViewCtrlCallBack(dishId);
    }
}
@end
