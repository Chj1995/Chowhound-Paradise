//
//  DGCCycleDetailViewController.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleDetailViewController.h"
#import "HttpRequest.h"
#import "DGCCycleDetailModel.h"
#import "DGCCycleDetailModelFrame.h"
#import "DGCCycleDetailCell.h"
#import "MJRefresh.h"
#import "DGCCycleDetailContentModel.h"
#import "DGCCycleDetailContentModelFrame.h"
#import "MyNavigationBarView.h"
#import "DGCConfig.h"
#import "AFNetworkReachabilityManager.h"

@interface DGCCycleDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _currentPage;
    NSInteger _currentKf;
    UILabel *label;
    UIButton *button;
}
@property(nonatomic,strong)NSMutableArray *fsDataSource;

@property(nonatomic,strong)NSMutableArray *pDataSource;

@property(nonatomic,weak)UITableView *tableView;

@end

@implementation DGCCycleDetailViewController
#pragma mark - 懒加载
-(NSMutableArray *)pDataSource
{
    if (!_pDataSource) {
        
        _pDataSource = [NSMutableArray array];
    }
    return _pDataSource;
}
-(NSMutableArray *)fsDataSource
{
    if (!_fsDataSource) {
        
        _fsDataSource = [NSMutableArray array];
    }
    return _fsDataSource;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, self.view.frame.size.height - 70) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        tableView.mj_header = [self header];
        tableView.mj_footer = [self foot];
        
        [tableView registerClass:[DGCCycleDetailCell class] forCellReuseIdentifier:@"detailCell"];
        
        _tableView = tableView;
    }
    return _tableView;
}
#pragma mark - 刷新
/**
 下拉刷新
 */
- (MJRefreshNormalHeader *)header
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currentPage = 0;
        _currentKf = 1;
        if ([self.picU hasPrefix:@"recipes://"]) {
            
            [self requestDataFromNetWorkingWithPicU:[self stringWithString:self.picU]];
        }else
        {
            [self requestDataFromNetWorkingWithPicU:self.picU];
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
        
        _currentPage += 18;
        _currentKf = 0;
        if ([self.picU hasPrefix:@"recipes://"]) {
            
            [self requestDataFromNetWorkingWithPicU:[self stringWithString:self.picU]];
        }else
        {
            [self requestDataFromNetWorkingWithPicU:self.picU];
        }

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
    _currentKf = 1;
    [self setupMyNavigationBarView];
    
    [self setupButtonAndLabel];
    
    //判断有无网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status != AFNetworkReachabilityStatusNotReachable) {
            //有网络
            /*
             请求网络数据
             */
            if ([self.picU hasPrefix:@"recipes://"]) {
                
                [self requestDataFromNetWorkingWithPicU:[self stringWithString:self.picU]];
            }else
            {
                [self requestDataFromNetWorkingWithPicU:self.picU];
            }
        }else
        {
            //无网络
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
    [navigationBarView setupTitleLableWithTitle:@"帖子详情" TitleSize:17];
    [navigationBarView setNavigationBarViewGoToBackCallback:^{
        [self goBack];
    }];
    [self.view addSubview:navigationBarView];
}
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 剪切字符串
-(NSString *)stringWithString:(NSString *)string
{
    NSRange rang = [string rangeOfString:@"?" options:NSBackwardsSearch];
    NSRange rang2 = [string rangeOfString:@"&" options:NSBackwardsSearch];
    NSString *str = [string substringWithRange:NSMakeRange(rang.location + 4, rang2.location - rang.location - 4)];
    return str;
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
    if ([self.picU hasPrefix:@"recipes://"]) {
        
        [self requestDataFromNetWorkingWithPicU:[self stringWithString:self.picU]];
    }else
    {
        [self requestDataFromNetWorkingWithPicU:self.picU];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        label.text = @"数据加载失败，再试试";
    });
}

#pragma mark - 请求数据
-(void)requestDataFromNetWorkingWithPicU:(NSString *)picU
{
    NSDictionary *headerRequest = @{@"lon":@"113.961892",
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
                                    @"Content-Type":@"application/x-www-form-urlencoded; charset=utf-8",
                                    @"channel":@"UC",
                                    @"lat":@"22.580036",
                                    @"Cookie":@"duid=47404332",
                                    @"User-Agent":@"Dalvik/1.6.0 (Linux; U; Android 4.4.4; MI 4C MIUI/V7.1.5.0.KXDCNCK) Paros/3.2.13",
                                    @"Host":@"api.douguo.net",
                                    @"Content-Length":@"35"};
    
    [HttpRequest Post:@"http://api.douguo.net/group/postreplies/" paramters:[NSString stringWithFormat:@"f=%ld&d=0&kf=%ld&client=4&nd=1&n=20&l=0&pid=%@&nw=5",_currentPage,_currentKf,picU] dictionary:headerRequest success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self handleDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 封装数据
-(void)handleDataWithObject:(id)responseObject
{
    [self.pDataSource removeAllObjects];
    
    if (_currentPage == 0)
    {
        [self.fsDataSource removeAllObjects];
    }
    
    //帖子详情标题
    NSDictionary *p = responseObject[@"result"][@"p"];
    
    [self.pDataSource addObject:p[@"n"]];
    
    NSArray *fs = responseObject[@"result"][@"fs"];
    
    for (NSDictionary *dic in fs)
    {
        DGCCycleDetailModel *model = [[DGCCycleDetailModel alloc] init];
        model.fl = [NSString stringWithFormat:@"%@",dic[@"fl"]];
        model.f = dic[@"f"];
        model.time = [dic[@"t"] substringToIndex:10];
        model.userName = dic[@"a"][@"n"];
        model.userAvatar = dic[@"a"][@"p"];
        model.verified = [NSString stringWithFormat:@"%@",dic[@"a"][@"v"]];
        
        //帖子详情内容
        NSArray *c = dic[@"c"];
        
        if ([self.picU hasPrefix:@"recipes://"]) {
            
            for (int i = 0; i < c.count; i+=2)
            {
                DGCCycleDetailContentModel *contentModel = [[DGCCycleDetailContentModel alloc] init];
                contentModel.activityContent = c[i][@"n"];
                
                if ((i+1)<= c.count - 1) {
                    
                    contentModel.activityContentPicUrl = c[i+1][@"i"];
                }
                
                DGCCycleDetailContentModelFrame *contentModelFrame = [[DGCCycleDetailContentModelFrame alloc] init];
                contentModelFrame.model = contentModel;
                [model.contentArray addObject:contentModelFrame];
            }

        }else
        {
            for (NSDictionary *dic2 in c)
            {
                DGCCycleDetailContentModel *contentModel = [[DGCCycleDetailContentModel alloc] init];
                
                contentModel.activityContent = dic2[@"n"];
                contentModel.activityContentPicUrl = dic2[@"i"];
                contentModel.vu = dic[@"vu"];
                DGCCycleDetailContentModelFrame *contentModelFrame = [[DGCCycleDetailContentModelFrame alloc] init];
                contentModelFrame.model = contentModel;
                [model.contentArray addObject:contentModelFrame];
            }
        }
        
        DGCCycleDetailModelFrame *modelFrame = [[DGCCycleDetailModelFrame alloc] init];
        modelFrame.model = model;
        [self.fsDataSource addObject:modelFrame];
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
    NSInteger num;
    if (section == 0) {
        num = self.pDataSource.count;
    }else
    {
        num = self.fsDataSource.count;
    }
    return num;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        //帖子详情标题
        UITableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cellOne.textLabel.text = self.pDataSource[indexPath.row];
        cellOne.textLabel.numberOfLines = 0;
        cellOne.textLabel.font = [UIFont systemFontOfSize:17 weight:1];
        cell = cellOne;
    }else
    {
        //帖子详情内容
        DGCCycleDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        detailCell.modelFrame = self.fsDataSource[indexPath.row];
        cell = detailCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0.0;
    
    if (indexPath.section == 0) {
        
        cellHeight = 50;
    }else
    {
        DGCCycleDetailModelFrame *modelFrame = self.fsDataSource[indexPath.row];
        
        CGFloat contentHeight = 0.0;
        
        for (int i = 0; i < modelFrame.model.contentArray.count; i++)
        {
            DGCCycleDetailContentModelFrame *contentModelFrame = modelFrame.model.contentArray[i];
            
            contentHeight += contentModelFrame.cellHeight;
        }
        
        cellHeight = modelFrame.cellHeight + contentHeight + 1;
    }
    
    return cellHeight;
}
@end
