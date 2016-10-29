//
//  DGCCycleListContentViewTwo.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleListContentViewTwo.h"
#import "DGCCyCleListHeaderView.h"
#import "DGCConfig.h"
#import "DGCCyCleListContentDetailCell.h"
#import "MJRefresh.h"
#import "DGCCycleListContentModel.h"

@interface DGCCycleListContentViewTwo ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UITableView *tableView;

/**
 返回顶部
 */
@property(nonatomic,weak)UIButton *backToTopButton;

@end
@implementation DGCCycleListContentViewTwo
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //注册cell
        [tableView registerClass:[DGCCyCleListContentDetailCell class] forCellReuseIdentifier:@"cell"];
        
        //表头
        DGCCyCleListHeaderView *headerView = [[DGCCyCleListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        headerView.isCollectionView = NO;
        //点击表头按钮的回调
        [headerView setCyCleListHeaderViewChangeViewCallBack:^(NSInteger tag) {
           
            [self headerViewChangeViewCallBack:tag];
        }];
        tableView.tableHeaderView = headerView;
        
        //刷新
        tableView.mj_header = [self header];
        tableView.mj_footer = [self foot];
        
        _tableView = tableView;
    }
    return _tableView;
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
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //2.偏移量设为0
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGPoint offset = self.tableView.contentOffset;
        offset.y = 0;
        self.tableView.contentOffset = offset;
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
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - setter方法
-(void)setListDataSource:(NSArray *)listDataSource
{
    _listDataSource = listDataSource;
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listDataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGCCyCleListContentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = _listDataSource[indexPath.row];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kListDishCellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGCCycleListContentModel *model = _listDataSource[indexPath.row];
    
    [self changeToDishContentViewCtrlWithDishId:model.dishId];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = self.tableView.contentOffset;
    
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array =  tableView.indexPathsForVisibleRows;
    NSIndexPath *firstIndexPath = array[0];
    
    //设置anchorPoint
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    //为了防止cell视图移动，重新把cell放回原来的位置
    cell.layer.position = CGPointMake(0, cell.layer.position.y);
    
    //设置cell 按照z轴旋转90度，注意是弧度
    if (firstIndexPath.row < indexPath.row) {
        cell.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1.0);
    }else{
        cell.layer.transform = CATransform3DMakeRotation(- M_PI_2, 0, 0, 1.0);
    }
    
    cell.alpha = 0.0;
    
    [UIView animateWithDuration:1 animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1.0;
    }];
}
#pragma mark - 回调
//点击头部按钮的回调
-(void)headerViewChangeViewCallBack:(NSInteger)tag
{
    if (_cycleListContentViewTwoChangeViewCallBack) {
        
        _cycleListContentViewTwoChangeViewCallBack(tag);
    }
}
/**
 下拉刷新回调
 */
-(void)headerUpdateCallBack
{
    if (_cycleListContentViewTwoHeaderUpdateCallBack) {
        
        _cycleListContentViewTwoHeaderUpdateCallBack();
    }
}
/**
 上拉刷新回调
 */
-(void)footUpdateCallBack
{
    if (_cycleListContentViewTwoFootUpdateCallBack) {
        
        _cycleListContentViewTwoFootUpdateCallBack();
    }
}
/**
 跳转到写食派内容界面
 */
-(void)changeToDishContentViewCtrlWithDishId:(NSString *)dishId
{
    if (_cycleListContentViewTwoChangeToDishContentViewCtrlCallBack) {
        
        _cycleListContentViewTwoChangeToDishContentViewCtrlCallBack(dishId);
    }
}
@end
