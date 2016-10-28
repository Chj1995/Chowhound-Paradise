//
//  DGCListDescViewController.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCListDescViewController.h"
#import "HttpRequest.h"
#import "DGCCycleListContentView.h"
#import "DGCCycleListContentViewTwo.h"
#import "DGCCycleListContentModel.h"
#import "DGCCycleListDishContentViewController.h"
#import "MyNavigationBarView.h"
#import "DGCConfig.h"
#import "AFNetworkReachabilityManager.h"

@interface DGCListDescViewController ()
{
    //当前置于最前端的页面tag值
    NSInteger _tag;
    //当前页数
    NSInteger _currentPage;
    UILabel *label;
    UIButton *button;
}
//collectionView模式
@property(nonatomic,weak)DGCCycleListContentView *cycleListContentView;
//tableView模式
@property(nonatomic,weak)DGCCycleListContentViewTwo *cycleListContentViewTwo;

/**
 列表数据源
 */
@property(nonatomic,strong)NSMutableArray *listDataSource;

/**
 *  时间格式化类
 */
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DGCListDescViewController
#pragma mark - 懒加载
//collectionView模式
-(DGCCycleListContentView *)cycleListContentView
{
    if (!_cycleListContentView) {
        
        DGCCycleListContentView *listView = [[DGCCycleListContentView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, self.view.frame.size.height - 70)];
         //点击表头按钮的回调
        [listView setCycleListContentViewChangeViewCallBack:^(NSInteger tag) {
           
            [self changViewToFront:tag];
            _tag = tag;
        }];
        //下拉刷新的回调
        [listView setCycleListContentViewHeaderUpdateCallBack:^{
            
            _currentPage = 0;
            [self requestDataFromNetWorking];
        }];
        //上拉刷新的回调
        [listView setCycleListContentViewFootUpdateCallBack:^{
            
            _currentPage += 21;
            [self requestDataFromNetWorking];
        }];
        /**
         跳转到写食派内容界面
         */
        [listView setCycleListContentViewChangeToDishContentViewCtrlCallBack:^(NSString *dishId) {
            [self changToDishContentViewCtrl:dishId];
        }];
        [self.view addSubview:listView];
        _cycleListContentView = listView;
    }
    return _cycleListContentView;
}
//tableView模式
-(DGCCycleListContentViewTwo *)cycleListContentViewTwo
{
    if (!_cycleListContentViewTwo) {
        
        DGCCycleListContentViewTwo *listViewTwo = [[DGCCycleListContentViewTwo alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, self.view.frame.size.height - 70)];
        
        //点击表头按钮的回调
        [listViewTwo setCycleListContentViewTwoChangeViewCallBack:^(NSInteger tag) {
           
            [self changViewToFront:tag];
            _tag = tag;
        }];
        //下拉刷新的回调
        [listViewTwo setCycleListContentViewTwoHeaderUpdateCallBack:^{
            _currentPage = 0;
            [self requestDataFromNetWorking];
        }];
        //上拉刷新的回调
        [listViewTwo setCycleListContentViewTwoFootUpdateCallBack:^{
            _currentPage += 21;
            [self requestDataFromNetWorking];
        }];
        /**
         跳转到写食派内容界面
         */
        [listViewTwo setCycleListContentViewTwoChangeToDishContentViewCtrlCallBack:^(NSString *dishId) {
            [self changToDishContentViewCtrl:dishId];
        }];
        [self.view addSubview:listViewTwo];
        _cycleListContentViewTwo = listViewTwo;
    }
    
    return _cycleListContentViewTwo;
}
-(NSMutableArray *)listDataSource
{
    if (!_listDataSource) {
        
        _listDataSource = [NSMutableArray array];
    }
    return _listDataSource;
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

#pragma mark - 将页面置于最前端
-(void)changViewToFront:(NSInteger)tag
{
    switch (tag)
    {
        case 1000:
            [self.view bringSubviewToFront:self.cycleListContentView];
            break;
        case 2000:
            [self.view bringSubviewToFront:self.cycleListContentViewTwo];
            break;
            
        default:
            break;
    }
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tag = 1000;
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
    [navigationBarView setupTitleLableWithTitle:@"写食派" TitleSize:17];
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

#pragma mark - 请求数据
-(void)requestDataFromNetWorking
{
    //http://api.douguo.net/dish/homev2/0/21
    
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
                                    @"lat":@"22.580079",
                                    @"Cookie":@"duid=47404332",
                                    @"User-Agent":@"Dalvik/1.6.0 (Linux; U; Android 4.4.4; MI 4C MIUI/V7.1.5.0.KXDCNCK) Paros/3.2.13",
                                    @"Host":@"api.douguo.net",
                                    @"Content-Length":@"16"};
    
    [HttpRequest Post:[NSString stringWithFormat:@"http://api.douguo.net/dish/homev2/%ld/21",_currentPage] paramters:@"client=4&btmid=0" dictionary:headerRequest success:^(id responseObject) {
        //停止刷新
        [self.cycleListContentView endFresh];
        [self.cycleListContentViewTwo endFresh];
        
        [self handleDataWithObject:responseObject];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 封装数据
-(void)handleDataWithObject:(id)responseObject
{
    if (_currentPage == 0) {
        
        [self.listDataSource removeAllObjects];
    }
    
    NSArray *list = responseObject[@"result"][@"list"];
    
    for (NSDictionary *dic in list)
    {
        DGCCycleListContentModel *model = [DGCCycleListContentModel modelWithDictionary:dic[@"d"][@"author"]];
        model.image = dic[@"d"][@"image"];
        model.dishId = dic[@"d"][@"dish_id"];
        model.publishtime = [self currentBetweenExpireFormatterWithExpireDateString:dic[@"d"][@"publishtime"]];
        model.publishtimeSecond = [dic[@"d"][@"publishtime"] substringToIndex:10];
        [self.listDataSource addObject:model];
    }
    self.cycleListContentView.listDataSource = self.listDataSource;
    self.cycleListContentViewTwo.listDataSource = self.listDataSource;
    
    if (_tag == 1000)
    {
        [self.view bringSubviewToFront:self.cycleListContentView];
    }else if(_tag == 2000)
    {
        [self.view bringSubviewToFront:self.cycleListContentViewTwo];
    }
}
#pragma mark - 页面跳转

/**
 跳转到写食派内容介绍界面
 */
-(void)changToDishContentViewCtrl:(NSString *)dishId
{
    DGCCycleListDishContentViewController *dishContentViewCtrl = [[DGCCycleListDishContentViewController alloc] init];
    
    dishContentViewCtrl.dishId = dishId;
    [self.navigationController pushViewController:dishContentViewCtrl animated:YES];
}

@end
