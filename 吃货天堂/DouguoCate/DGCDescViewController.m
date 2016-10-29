//
//  DGCDescViewController.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/6.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCDescViewController.h"
#import "DGCDescModel.h"
#import "DGCDescCell.h"
#import "DGCConfig.h"
#import "DGCDGCDescModelFrame.h"
#import "DGCDescCellTwo.h"
#import "DGCDescModelTwo.h"
#import "DGCDescCellThree.h"
#import "DGCDescModelTwoFrame.h"
#import "HttpRequest.h"
#import "DGCMajorModel.h"
#import "DGCMajorModelFrame.h"
#import "AFNetworkReachabilityManager.h"
#import "MyNavigationBarView.h"

@interface DGCDescViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *label;
    UIButton *button;
    MyNavigationBarView *navigationBarView;
}

@property(nonatomic,weak)UITableView *tableView;

/**
 头部数据源
 */
@property(nonatomic,strong)NSMutableArray *dataSource;

/**
 食材数据源
 */
@property(nonatomic,strong)NSMutableArray *majorDataSource;


/**
 烹饪步骤数据源
 */
@property(nonatomic,strong)NSMutableArray *cookStepDataSource;

@end

@implementation DGCDescViewController
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, self.view.frame.size.height - 70) style:UITableViewStylePlain];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.backgroundColor = [UIColor whiteColor];
        
        //注册cell
        [tableView registerClass:[DGCDescCell class] forCellReuseIdentifier:@"cell"];
        [tableView registerClass:[DGCDescCellTwo class] forCellReuseIdentifier:@"cellTwo"];
        [tableView registerClass:[DGCDescCellThree class] forCellReuseIdentifier:@"cellThree"];
        
        tableView.tableFooterView = [[UIView alloc] init];
        
        _tableView = tableView;
    }
    return _tableView;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray *)majorDataSource
{
    if (!_majorDataSource) {
        
        _majorDataSource = [NSMutableArray array];
    }
    return _majorDataSource;
}
-(NSMutableArray *)cookStepDataSource
{
    if (!_cookStepDataSource) {
        
        _cookStepDataSource = [NSMutableArray array];
    }
    return _cookStepDataSource;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupButtonAndLabel];
    [self setupMyNavigationBarView];
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
    __weak DGCDescViewController *weakSelf = self;
    navigationBarView = [[MyNavigationBarView alloc] initWithFrame:CGRectMake(0, 20,kScreenWidth, 50)];
    navigationBarView.backgroundColor = [UIColor whiteColor];
    [navigationBarView setNavigationBarViewGoToBackCallback:^{
        
        [weakSelf goBack];
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
    NSDictionary *headerRequest = @{@"lon":@"113.961851",
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
                                @"lat":@"22.58007",
                                @"Cookie":@"duid=47404332",
                                @"User-Agent":@"Dalvik/1.6.0 (Linux; U; Android 4.4.4; MI 4C MIUI/V7.1.5.0.KXDCNCK) Paros/3.2.13",
                                @"Host":@"api.douguo.net",
                                @"Content-Length":@"8",
                                @"client":@"4"};
    
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://api.douguo.net/recipe/detail/"];
    
    [urlStr appendFormat:@"%ld",_picId];
    
    [HttpRequest Post:urlStr paramters:nil dictionary:headerRequest success:^(id responseObject) {
        [self handleDataWithObject:responseObject];
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark - 封装数据
-(void)handleDataWithObject:(id)responseObject
{
    NSDictionary *recipe = responseObject[@"result"][@"recipe"];
    
    DGCDescModel *descModel = [[DGCDescModel alloc] init];
    descModel.picUrl = recipe[@"photo_path"];
    descModel.picTitle = recipe[@"title"];
    descModel.vc = recipe[@"vc"];
    descModel.vu = recipe[@"vu"];
    descModel.favo_counts = recipe[@"favo_counts"];
    descModel.dish_count = recipe[@"dish_count"];
    
    if (![recipe[@"cookstory"] isEqualToString:@""]) {
        
        descModel.cookstory = recipe[@"cookstory"];
    }else
    {
        descModel.cookstory = nil;
    }
    
    descModel.user_photo = recipe[@"user"][@"user_photo"];
    descModel.verified = [NSString stringWithFormat:@"%@",recipe[@"user"][@"verified"]];
    descModel.userName = recipe[@"user"][@"nickname"];
    descModel.time = recipe[@"cook_time"];
    descModel.grade = recipe[@"cook_difficulty"];
    descModel.advice = recipe[@"advice"][@"at"];
    
    DGCDGCDescModelFrame *modelFrame = [[DGCDGCDescModelFrame alloc] init];
    modelFrame.model = descModel;
    
    [self.dataSource addObject:modelFrame];
    
    //食材清单
    NSArray *major = recipe[@"major"];
    
    for (NSDictionary *dic in major)
    {
        DGCMajorModel *descModel2 = [[DGCMajorModel alloc] init];
        
        descModel2.major_title = dic[@"title"];
        descModel2.major_note = dic[@"note"];
        
        DGCMajorModelFrame *modelFrame2 = [[DGCMajorModelFrame alloc] init];
        modelFrame2.model = descModel2;
        
        [self.majorDataSource addObject:modelFrame2];
    }
    //烹饪步骤
    NSArray *cookstep = recipe[@"cookstep"];
    for (NSDictionary *dic in cookstep)
    {
        DGCDescModelTwo *modelTwo = [DGCDescModelTwo modelWithDictionary:dic];
        
        DGCDescModelTwoFrame *modelFrame = [[DGCDescModelTwoFrame alloc] init];
        modelFrame.model = modelTwo;
        [self.cookStepDataSource addObject:modelFrame];
        
    }
    
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return self.dataSource.count;
        
    }else if(section == 1)
    {
        return self.majorDataSource.count;
    }
    return self.cookStepDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        //头部
        DGCDescCell *cellOne = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cellOne.modelFrame = self.dataSource[indexPath.row];
        cellOne.backgroundColor = [UIColor whiteColor];
        cell = cellOne;

    }
    else if (indexPath.section == 1)
    {
        
        //食材清单
        DGCDescCellTwo *cellTwo = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        cellTwo.modelFrame = self.majorDataSource[indexPath.row];
        cellTwo.backgroundColor = [UIColor lightGrayColor];
        cell = cellTwo;

    }else
    {
         //烹饪步骤
        DGCDescCellThree *cellThree = [tableView dequeueReusableCellWithIdentifier:@"cellThree"];
        cellThree.modelFrame = self.cookStepDataSource[indexPath.row];
        cell = cellThree;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 cell的高度

 @param tableView <#tableView description#>
 @param indexPath <#indexPath description#>

 @return <#return value description#>
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    
    if (indexPath.section == 0)
    {
        //头部
        DGCDGCDescModelFrame *modelFrame = self.dataSource[indexPath.row];
        
        height = modelFrame.cellHeight + 50;
    }
    else if (indexPath.section == 1)
    {
        //食材清单
        DGCMajorModelFrame *modelFrameTwo = self.majorDataSource[indexPath.row];
        height = modelFrameTwo.cellHeight;
        
    }else
    {
        //烹饪步骤
        DGCDescModelTwoFrame *modelFrameThree = self.cookStepDataSource[indexPath.row];
        height = modelFrameThree.cellHeight;
    }
    
    return height;
}
@end
