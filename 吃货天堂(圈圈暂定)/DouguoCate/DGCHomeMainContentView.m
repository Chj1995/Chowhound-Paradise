//
//  DGCHomeMainContentView.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCHomeMainContentView.h"
#import "DGCHeaderView.h"
#import "DGCConfig.h"
#import "DGCHomeCellOne.h"
#import "DGCHomeModel.h"
#import "DGCHomeCellTwo.h"
#import "MJRefresh.h"


@interface DGCHomeMainContentView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UITableView *tableView;

/**
 返回顶部
 */
@property(nonatomic,weak)UIButton *backToTopButton;

@end
@implementation DGCHomeMainContentView
#pragma mark - 懒加载

- (UITableView *)tableView
{
    if (!_tableView)
    {
        
        __weak DGCHomeMainContentView *weekSelf = self;
        
        UITableView *tb = [[UITableView alloc] initWithFrame:self.bounds];
        tb.delegate = self;
        tb.dataSource = self;
        [self addSubview:tb];
        tb.showsVerticalScrollIndicator = NO;
        [tb registerClass:[DGCHomeCellOne class] forCellReuseIdentifier:@"cellOne"];
        [tb registerClass:[DGCHomeCellTwo class] forCellReuseIdentifier:@"cellTwo"];
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //表头(广告栏部分)
        DGCHeaderView *headerView = [[DGCHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3 + 90)];
        
        [headerView setHeaderViewSelectedCallback:^(NSString* picId) {
            
            [weekSelf selectedCallbackWithPicId:picId];
            
        }];
        headerView.adArray = _adArray;
        headerView.adToolArray = _adToolArray;
        tb.tableHeaderView = headerView;
        
        tb.showsVerticalScrollIndicator = NO;
        
        //刷新
        tb.mj_header = [self header];
        tb.mj_footer = [self foot];
        
        _tableView = tb;
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
#pragma mark - 回调
-(void)selectedCallbackWithPicId:(NSString*)picId
{
    if (_homeMainContentViewSelectedCallback) {
        
        _homeMainContentViewSelectedCallback(picId);
    }
}
#pragma mark - 刷新
/**
 下拉刷新
 */
- (MJRefreshNormalHeader *)header
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (_homeMainContentViewHeaderUpdateCallback) {
            _homeMainContentViewHeaderUpdateCallback();
        }
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
        
        if (_homeMainContentViewFootUpdateCallback) {
            
            _homeMainContentViewFootUpdateCallback();
        }
    }];
    
    [foot setTitle:@"上拉刷新" forState:MJRefreshStateIdle];
    [foot setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [foot setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    
    return foot;
}

/**
 结束刷新
 */
-(void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - setter方法
-(void)setAdArray:(NSArray *)adArray
{
    _adArray = adArray;
    
}
-(void)setAdToolArray:(NSArray *)adToolArray
{
    _adToolArray = adToolArray;
}
-(void)setGoodsArray:(NSArray *)goodsArray
{
    _goodsArray = goodsArray;
    
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _goodsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    DGCHomeModelFrame *modelFrame = _goodsArray[indexPath.row];
    DGCHomeModel *homeModel = modelFrame.model;
    
    if ([homeModel.type integerValue] == 3)
    {
        //菜谱
        DGCHomeCellOne *homeCellOne = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
        homeCellOne.model = modelFrame.model;
        homeCellOne.backgroundColor = kCellBackGroundColor;
        homeCellOne.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = homeCellOne;
    }else
    {
        //
        DGCHomeCellTwo *homeCellTwo = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        homeCellTwo.modelFrame = _goodsArray[indexPath.row];
        homeCellTwo.backgroundColor = kCellBackGroundColor;
        homeCellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = homeCellTwo;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = kScreenWidth - 130;
    
    DGCHomeModelFrame *modelFrame = _goodsArray[indexPath.row];
    DGCHomeModel *homeModel = modelFrame.model;
    
    if ([homeModel.type integerValue] != 3)
    {
        height = modelFrame.cellHeight;
    }

    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGCHomeModelFrame *modelFrame = _goodsArray[indexPath.row];
    NSString *type = modelFrame.model.type;
    NSString *picId = modelFrame.model.picId;
    
    if (_homeMainContentViewChangeViewCtrollerCallback) {
        
        _homeMainContentViewChangeViewCtrollerCallback(type,picId);
    }
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
@end
