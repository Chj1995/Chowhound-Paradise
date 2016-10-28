//
//  DGCCycleListDishContentViewController.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/18.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleListDishContentViewController.h"
#import "HttpRequest.h"
#import "DGCCycleListContentModel.h"
#import "DGCCycleListDishContentCell.h"
#import "DGCConfig.h"
#import "DGCCycleListDishContentDiscussModel.h"
#import "DGCCycleListDishContentDiscussModelFrame.h"
#import "DGCCycleListDishDiscussCell.h"
#import "MyNavigationBarView.h"
#import "AFNetworkReachabilityManager.h"

@interface DGCCycleListDishContentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *label;
    UIButton *button;
}

@property(nonatomic,weak)UITableView *tableView;

/**
 用户信息数据源
 */
@property(nonatomic,strong)NSMutableArray *authorDataSource;
/**
 评价数据源
 */
@property(nonatomic,strong)NSMutableArray *discussDataSource;

/**
 *  时间格式化类
 */
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DGCCycleListDishContentViewController
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, self.view.frame.size.height - 70) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        //用户信息
        [tableView registerClass:[DGCCycleListDishContentCell class] forCellReuseIdentifier:@"cell"];
        //评论
        //有评论
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"discussCellOne"];
        //无评论
        [tableView registerClass:[DGCCycleListDishDiscussCell class] forCellReuseIdentifier:@"discussCellTwo"];

        _tableView = tableView;
    }
    return _tableView;
}
-(NSMutableArray *)authorDataSource
{
    if (!_authorDataSource) {
        
        _authorDataSource = [NSMutableArray array];
    }
    return _authorDataSource;
}
-(NSMutableArray *)discussDataSource
{
    if (!_discussDataSource) {
        
        _discussDataSource = [NSMutableArray array];
    }
    return _discussDataSource;
}
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        //时间格式
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
    }
    
    return _dateFormatter;
}
#pragma mark - 计算当前时间和超时时间差
- (NSString *)currentBetweenExpireFormatterWithExpireDateString:(NSString *)expireDateString
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSDate *expireDate = [self.dateFormatter dateFromString:expireDateString];
    
    //计算剩余时间---两个指定时间相差的总秒数
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:expireDate];
    
    
    int h = interval / 3600;
    int m = (interval - h * 3600)/60;
    
    return [NSString stringWithFormat:@"%d:%d",h,m];
    
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
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
            [self requestDataFromNetWorking];
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
    NSDictionary *headerRequest = @{@"lon":@"113.96189",
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
                                    @"lat":@"22.580061",
                                    @"Cookie":@"duid=47404332",
                                    @"User-Agent":@"Dalvik/1.6.0 (Linux; U; Android 4.4.4; MI 4C MIUI/V7.1.5.0.KXDCNCK) Paros/3.2.13",
                                    @"Host":@"api.douguo.net",
                                    @"Content-Length":@"8"};
    
    [HttpRequest Post:[NSString stringWithFormat:@"http://api.douguo.net/recipe/dish/%@/0/20",self.dishId] paramters:@"client=4" dictionary:headerRequest success:^(id responseObject) {
       
        
        [self handleDataFromNetWorkingWithObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 封装数据
-(void)handleDataFromNetWorkingWithObject:(id)responseObject
{
    
    NSDictionary *dish = responseObject[@"result"][@"dish"];
    //用户信息
    DGCCycleListContentModel *listContentModel = [DGCCycleListContentModel modelWithDictionary:dish[@"author"]];
    listContentModel.image = dish[@"image"];
    listContentModel.publishtime = [self currentBetweenExpireFormatterWithExpireDateString:dish[@"publishtime"]];
    [self.authorDataSource addObject:listContentModel];
    
    //评价
    NSArray *cs = dish[@"cs"];
    
    for (NSDictionary *dic in cs)
    {
        DGCCycleListDishContentDiscussModel *discussModel = [DGCCycleListDishContentDiscussModel modelWithDictionary:dic[@"author"]];
        discussModel.publishtime = [self currentBetweenExpireFormatterWithExpireDateString:dic[@"time"]];
        discussModel.publishtimeSecond = [dic[@"time"] substringToIndex:10];
        discussModel.content = dic[@"content"];
        discussModel.verified = dic[@"author_verified"];
        
        DGCCycleListDishContentDiscussModelFrame *discussModelFrame = [[DGCCycleListDishContentDiscussModelFrame alloc] init];
        discussModelFrame.model = discussModel;
        [self.discussDataSource addObject:discussModelFrame];
        
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
    NSInteger num = 0;
    
    if (section == 0) {
        //用户信息
        num = self.authorDataSource.count;
    }
    else
    {
        if (self.discussDataSource.count == 0) {
            
            num = 1;
        }else
        {
            //评价
            num = self.discussDataSource.count;

        }
    }
    return num;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0)
    {
        //用户信息
        DGCCycleListDishContentCell *cellOne = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cellOne.model = self.authorDataSource[indexPath.row];
        cellOne.backgroundColor = [UIColor lightGrayColor];
        cell = cellOne;
    }else
    {
        if (self.discussDataSource.count == 0) {
            
            UITableViewCell *discussCellOne = [tableView dequeueReusableCellWithIdentifier:@"discussCellOne"];
            discussCellOne.textLabel.text = @"暂无评价";
            discussCellOne.textLabel.textAlignment = NSTextAlignmentCenter;
            discussCellOne.textLabel.textColor = [UIColor lightGrayColor];
            cell = discussCellOne;
        }else
        {
            //评价
            DGCCycleListDishDiscussCell *discussCellTwo = [tableView dequeueReusableCellWithIdentifier:@"discussCellTwo"];
            discussCellTwo.modelFrame = self.discussDataSource[indexPath.row];
            discussCellTwo.backgroundColor = [UIColor lightGrayColor];
            cell = discussCellTwo;
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0.0;
    if (indexPath.section == 0) {
        //用户信息
        cellHeight = kListDishCellHeight;
    }else
    {
        if (self.discussDataSource.count == 0)
        {
            
            cellHeight = 60;
            
        }else
        {
            //评价
            DGCCycleListDishContentDiscussModelFrame *modelFrame =self.discussDataSource[indexPath.row];
            cellHeight = modelFrame.cellHeight;
            
        }
    }
    return cellHeight;
}
@end
