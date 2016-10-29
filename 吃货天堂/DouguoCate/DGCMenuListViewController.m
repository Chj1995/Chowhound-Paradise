//
//  DGCMenuListViewController.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCMenuListViewController.h"
#import "HttpRequest.h"
#import "MJRefresh.h"
#import "DGCHomeModel.h"
#import "DGCHomeCellOne.h"
#import "DGCConfig.h"
#import "DGCChooseListViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "MyNavigationBarView.h"

@interface DGCMenuListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _currentPage;
    UILabel *label;
    UIButton *button;
}
@property(nonatomic,weak)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *menuDataSource;

/**
 返回顶部
 */
@property(nonatomic,weak)UIButton *backToTopButton;


@end

@implementation DGCMenuListViewController
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, self.view.frame.size.height - 70) style:UITableViewStylePlain];
        
        tb.delegate = self;
        tb.dataSource = self;
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tb];
        
        [tb registerClass:[DGCHomeCellOne class] forCellReuseIdentifier:@"cell"];
        
        //刷新
        tb.mj_header = [self header];
        tb.mj_footer = [self foot];
        
        _tableView = tb;
    }
    return _tableView;
}
-(NSMutableArray *)menuDataSource
{
    if (!_menuDataSource) {
        
        _menuDataSource = [NSMutableArray array];
    }
    return _menuDataSource;
}
-(UIButton *)backToTopButton
{
    if (!_backToTopButton) {
        
        CGFloat buttonWidth = 40;
        CGFloat buttonHeight = 40;
        
        UIButton *backToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backToTopButton.frame = CGRectMake(kScreenWidth - 60, kScreenHeight/1.2, buttonWidth, buttonHeight);
        backToTopButton.alpha  = 0;
        backToTopButton.backgroundColor = kAppTintColor;
        backToTopButton.layer.cornerRadius = buttonHeight/2;
        backToTopButton.clipsToBounds = YES;
        [backToTopButton setImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
        [backToTopButton addTarget:self action:@selector(backToTopButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backToTopButton];
        
        _backToTopButton = backToTopButton;
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
        
        _currentPage = 0;
        [self requestDataFromNetWorking];
        
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
        
        _currentPage += 20;
        [self requestDataFromNetWorking];
        
    }];
    
    [foot setTitle:@"上拉刷新" forState:MJRefreshStateIdle];
    [foot setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [foot setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    
    return foot;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _currentPage = 0;
    [self setupMyNavigationBarView];
    [self setupButtonAndLabel];
    
    //判断有无网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status != AFNetworkReachabilityStatusNotReachable) {
            
            /**
             请求网络数据
             */
            [self requestDataFromNetWorking];
        }else
        {
            [self setupFailNetWorking];
        }
        
    }];
    [manager startMonitoring];
}
#pragma mark - 自定义导航栏
-(void)setupMyNavigationBarView
{
    MyNavigationBarView *navigationBarView = [[MyNavigationBarView alloc] initWithFrame:CGRectMake(0, 20,kScreenWidth, 50)];
    navigationBarView.backgroundColor = [UIColor whiteColor];
    [navigationBarView setupTitleLableWithTitle:@"精品菜单" TitleSize:17];
    [navigationBarView setNavigationBarViewGoToBackCallback:^{
        [self goBack];
    }];
    [self.view addSubview:navigationBarView];
}
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建按钮和label
-(void)setupButtonAndLabel
{
    //创建重新加载按钮
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 150, 30);
    button.center  = self.view.center;
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.view addSubview:button];
    
    //设置提示label
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(button.frame) - 40, self.view.frame.size.width, 20)];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"正在加载数据....";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [button setTitle:@"重新加载" forState:UIControlStateNormal];
        //设置边框
        [button.layer setBorderWidth:0.5];
        [button.layer setBorderColor:[UIColor orangeColor].CGColor];
        
        label.text = @"别着急，网有点慢，再试试";
        
    });
    
}
#pragma mark - 网络请求失败的界面
/**
 没有网络情况下
 */
-(void)setupFailNetWorking
{
    [button setTitle:@"重新加载" forState:UIControlStateNormal];
    //设置边框
    [button.layer setBorderWidth:0.5];
    [button.layer setBorderColor:[UIColor orangeColor].CGColor];
    label.text = @"没有网络，请打开网络。。。";
}

-(void)buttonClick
{
    label.text = @"请稍等，正在加载数据。。。";
    /**
     请求网络数据
     */
    [self requestDataFromNetWorking];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        label.text = @"数据加载失败，再试试";
    });
}
#pragma mark - 请求网络数据
-(void)requestDataFromNetWorking
{
    
    NSDictionary *headerRequest = @{@"lon":@"113.961879",
                                    @"client":@"4",
                                    @"imei":@"99000566557828",
                                    @"mac":@" 0c:1d:af:d9:f0:5b",
                                    @"resolution":@"1920*1080",
                                    @"Connection":@"Keep-Alive",
                                    @"cid":@"401",
                                    @"version":@"624.2",
                                    @"device":@"MI 4C",
                                    @"sdk":@"19,4.4.4",
                                    @"dpi":@"3.0",
                                    @"Content-Type":@"application/x-www-form-urlencoded; charset=utf-8",
                                    @"channel":@"UC",
                                    @"lat":@"22.580052",
                                    @"Cookie":@"duid=47404332",
                                    @"User-Agent":@"Dalvik/1.6.0 (Linux; U; Android 4.4.4; MI 4C MIUI/V7.1.5.0.KXDCNCK) Paros/3.2.13",
                                    @"Host":@"api.douguo.net",
                                    @"Content-Length":@"17"};
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"http://api.douguo.net/recipe/menus/%ld/20",_currentPage];
    
    [HttpRequest Post:urlStr paramters:@"type=256&client=4" dictionary:headerRequest success:^(id responseObject) {
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self handleDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 封装数据
-(void)handleDataWithObject:(id)responseObject
{
    if (_currentPage == 0) {
        
        [self.menuDataSource removeAllObjects];
    }
    
    NSArray *list = responseObject[@"result"][@"list"];
    
    for (NSDictionary *dic in list) {
        
        DGCHomeModel *model = [[DGCHomeModel alloc] init];
        model.picId = dic[@"m"][@"id"];
        model.picUrl = dic[@"m"][@"b"];
        model.desc = dic[@"m"][@"c"];
        model.picTitle = dic[@"m"][@"t"];
        model.userName = dic[@"m"][@"a"][@"n"];
        model.type = dic[@"type"];
        
        [self.menuDataSource addObject:model];
    }

    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.menuDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGCHomeCellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.menuDataSource[indexPath.row];
    cell.backgroundColor = kCellBackGroundColor;
    return cell;
}
#pragma mark - cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = kScreenWidth - 130;
    
    return height;
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
/**
 在cell显示之前增加动画
 
 @param tableView <#tableView description#>
 @param cell      <#cell description#>
 @param indexPath <#indexPath description#>
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#pragma mark - 点击选择触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGCHomeModel *model = self.menuDataSource[indexPath.row];
    
    [self changeToChooseListViewCtrlWithPicId:model.picId];
}
#pragma mark - 跳转界面
-(void)changeToChooseListViewCtrlWithPicId:(NSString *)picId
{
    DGCChooseListViewController *chooseListViewCtrl = [[DGCChooseListViewController alloc] init];
    
    chooseListViewCtrl.picId = picId;
    
    [self.navigationController pushViewController:chooseListViewCtrl animated:YES];
}
@end
