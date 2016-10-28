//
//  DGCChooseListViewController.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCChooseListViewController.h"
#import "HttpRequest.h"
#import "DGCChooseLisetModelOne.h"
#import "DGCChooseLisetModelOneFrame.h"
#import "DGCChooseListCellOne.h"
#import "DGCHomeCellTwo.h"
#import "MJRefresh.h"
#import "DGCDescViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "MyNavigationBarView.h"
#import "DGCConfig.h"

@interface DGCChooseListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _currentPage;
    UILabel *label;
    UIButton *button;
}
@property(nonatomic,weak)UITableView *tableView;

/**
 头部数据
 */
@property(nonatomic,strong)NSMutableArray *headerDataSource;

/**
 菜谱数据
 */
@property(nonatomic,strong)NSMutableArray *listDataSource;

@end

@implementation DGCChooseListViewController
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, self.view.frame.size.height - 70) style:UITableViewStylePlain];
        
        tb.delegate = self;
        tb.dataSource = self;
        tb.showsVerticalScrollIndicator = NO;
        [tb registerClass:[DGCChooseListCellOne class] forCellReuseIdentifier:@"cell"];
        [tb registerClass:[DGCHomeCellTwo class] forCellReuseIdentifier:@"cellTwo"];
        
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //刷新
        tb.mj_header = [self header];
        tb.mj_footer = [self foot];
        
        [self.view addSubview:tb];
        
        _tableView = tb;
    }
    return _tableView;
}
-(NSMutableArray *)headerDataSource
{
    if (!_headerDataSource) {
    
        _headerDataSource = [NSMutableArray array];
    }
    return _headerDataSource;
}
-(NSMutableArray *)listDataSource
{
    if (!_listDataSource) {
        _listDataSource = [NSMutableArray array];
    }
    return _listDataSource;
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
           //有网络
            /**
             请求网络数据
             */
            [self requestDataFromNetWorking];
        }else
        {
            //无网络
            [self setupFailNetWorking];
        }
        
    }];
    [manager startMonitoring];
    
    _currentPage = 0;
    
}
#pragma mark - 自定义导航栏
-(void)setupMyNavigationBarView
{
    MyNavigationBarView *navigationBarView = [[MyNavigationBarView alloc] initWithFrame:CGRectMake(0, 20,kScreenWidth, 50)];
    navigationBarView.backgroundColor = [UIColor whiteColor];
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
    NSDictionary *headerRequest = @{@"lon":@"113.961878",
                                 @"client":@"4",
                                 @"imei":@"99000566557828",
                                 @"mac":@"0c:1d:af:d9:f0:5b",
                                 @"resolution":@"1920*1080",
                                 @"Connection":@"Keep-Alive",
                                 @"cid":@"401",
                                 @"version":@"624.2",
                                 @"device":@"MI 4C",
                                 @"sdk":@"19,4.4.4",
                                 @"dpi":@"3.0",
                                 @"Content-Type":@"application/x-www-form-urlencoded;charset=utf-8",
                                 @"channel":@"UC",
                                 @"lat":@"22.580049",
                                 @"Cookie":@"duid=47404332",
                                 @"User-Agent":@"Dalvik/1.6.0 (Linux; U; Android 4.4.4; MI 4C MIUI/V7.1.5.0.KXDCNCK) Paros/3.2.13",
                                 @"Host":@"api.douguo.net",
                                 @"Content-Length":@"8"};
   //头部数据
    NSMutableString *urlStr1 = [NSMutableString stringWithFormat:@"http://api.douguo.net/recipe/menu/%@",_picId];
    
    [HttpRequest Post:urlStr1 paramters:@"client=4" dictionary:headerRequest success:^(id responseObject) {
        
        [self handleHeaderDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    
    //菜谱数据
    NSMutableString *urlStr2 = [NSMutableString stringWithFormat:@"http://api.douguo.net/recipe/mrecipe/%@/%ld/10",_picId,_currentPage];
    [HttpRequest Post:urlStr2 paramters:@"client=4" dictionary:headerRequest success:^(id responseObject) {
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self handleListDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 封装数据

/**
 头部数据
 */
-(void)handleHeaderDataWithObject:(id)responseObject
{
    [self.headerDataSource removeAllObjects];
    
    NSDictionary *menu = responseObject[@"result"][@"menu"];
    
    DGCChooseLisetModelOne *modelOne = [DGCChooseLisetModelOne modelWithDictionary:menu];
    
    modelOne.avatar_medium = menu[@"author"][@"avatar_medium"];
    modelOne.nickname = menu[@"author"][@"nickname"];
    modelOne.verified = [NSString stringWithFormat:@"%@",menu[@"author"][@"verified"]];
    DGCChooseLisetModelOneFrame *modelFrame = [[DGCChooseLisetModelOneFrame alloc] init];
    modelFrame.model = modelOne;
    [self.headerDataSource addObject:modelFrame];
    [self.tableView reloadData];
    
}

/**
 菜谱数据
 */
-(void)handleListDataWithObject:(id)responseObject
{
    if (_currentPage == 0) {
        
        [self.listDataSource removeAllObjects];
    }
    
    NSArray *recipes = responseObject[@"result"][@"recipes"];
    
    for (NSDictionary *dic in recipes)
    {
        DGCHomeModel *model = [[DGCHomeModel alloc] init];
        model.picUrl = dic[@"p"];
        model.vc = dic[@"vc"];
        model.fc = dic[@"fc"];
        model.picTitle = dic[@"n"];
        
        if ([dic[@"cookstory"] isEqualToString:@""])
        {
            model.desc = nil;
            
        }else
        {
            model.desc = dic[@"cookstory"];
        }
        model.picId = dic[@"id"];
        model.userAvatar = dic[@"a"][@"p"];
        model.userVip = [NSString stringWithFormat:@"%@",dic[@"a"][@"v"]];
        model.userName = dic[@"a"][@"n"];
        
        DGCHomeModelFrame *modelFrame = [[DGCHomeModelFrame alloc] init];
        modelFrame.model = model;
        
        [self.listDataSource addObject:modelFrame];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return self.headerDataSource.count;
    }
    return self.listDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        //头部
        DGCChooseListCellOne *cellOne = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cellOne.modelFrame = self.headerDataSource[indexPath.row];
        
        cell = cellOne;
    }else
    {
        //菜谱
        DGCHomeCellTwo *cellTwo = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        cellTwo.modelFrame = self.listDataSource[indexPath.row];
        cellTwo.backgroundColor = [UIColor lightGrayColor];
        cell = cellTwo;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    
    if (indexPath.section == 0) {
        //头部
        DGCChooseLisetModelOneFrame *modelFrame = self.headerDataSource[indexPath.row];
        height = modelFrame.cellHeight;
        
    }else
    {
        //菜谱
        DGCHomeModelFrame *homeModelFrame = self.listDataSource[indexPath.row];
        
        height = homeModelFrame.cellHeight;
    }
    
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        DGCHomeModelFrame *modelFrame = self.listDataSource[indexPath.row];
        DGCHomeModel *homeModel = modelFrame.model;
        [self changeToDescViewCtrollerWithPicId:homeModel.picId];
    }
    
}
#pragma mark - 跳转界面
/**
 跳转到介绍界面
 
 @param picId <#picId description#>
 */
-(void)changeToDescViewCtrollerWithPicId:(NSString*)picId
{
    DGCDescViewController *descViewCtrl = [[DGCDescViewController alloc] init];
    
    descViewCtrl.picId = [picId integerValue];
    
    [self.navigationController pushViewController:descViewCtrl animated:YES];
}

@end
