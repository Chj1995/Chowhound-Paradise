//
//  DGCCyclesViewController.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCyclesViewController.h"
#import "HttpRequest.h"
#import "DGCCycleADViewModel.h"
#import "DGCCycleHeaderView.h"
#import "DGCConfig.h"
#import "DGCCycleDetailViewController.h"
#import "MJRefresh.h"
#import "DGCListModel.h"
#import "DGCCycleListCell.h"
#import "DGCListDescViewController.h"
#import "DGCCycleFunVideoViewController.h"
#import "DGCCycleListAllDataViewController.h"
#import "DGCAllDataModel.h"
#import "DGCAllDataModelFrame.h"
#import "DGCCycleListAllDataCell.h"
#import "AFNetworkReachabilityManager.h"

@interface DGCCyclesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _currentPage;
    UILabel *label;
    UIButton *button;
}

@property(nonatomic,weak)UITableView *tableView;

/**
 返回顶部
 */
@property(nonatomic,weak)UIButton *backToTopButton;

/**
 广告栏数据源
 */
@property(nonatomic,strong)NSMutableArray *bsDataSource;

/**
 数据源
 */
@property(nonatomic,strong)NSMutableArray *gsDataSource;

/**
 热门帖子
 */

@property(nonatomic,strong)NSMutableArray *listDataSource;

/**
 *  时间格式化类
 */
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DGCCyclesViewController
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, self.view.frame.size.height - 60) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.mj_header = [self header];
        tableView.mj_footer = [self foot];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        //列表(写食派....)
        [tableView registerClass:[DGCCycleListCell class] forCellReuseIdentifier:@"cell"];
        
        //热门帖子
        [tableView registerClass:[DGCCycleListAllDataCell class] forCellReuseIdentifier:@"cellTwo"];
        //热门帖子标题
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellThree"];
        
        if (self.bsDataSource.count > 0)
        {
            //表头(广告栏)
            DGCCycleHeaderView *headerView = [[DGCCycleHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kADViewHeight)];
            headerView.backgroundColor = [UIColor whiteColor];
            headerView.bsArray = self.bsDataSource;
            
            //广告栏跳转到帖子详情的回调
            [headerView setCycleHeaderViewChangeToDetailViewCtrlCallback:^(NSString *picU) {
                [self changToDetailViewCtrollerWithPicU:picU];
            }];
            tableView.tableHeaderView = headerView;
        }
        
        _tableView = tableView;
    }
    return _tableView;
}
-(NSMutableArray *)bsDataSource
{
    if (!_bsDataSource) {
        
        _bsDataSource = [NSMutableArray array];
    }
    return _bsDataSource;
}
-(NSMutableArray *)gsDataSource
{
    if (!_gsDataSource) {
        _gsDataSource = [NSMutableArray array];
    }
    return _gsDataSource;
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
        
        _currentPage += 18;
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
    
}
#pragma mark - 自定义导航栏
-(void)setupMyNavigationBarView
{
    UIView *navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 20,kScreenWidth, 40)];
    navigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationBarView];
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 20)];
    titleLabel.text = @"圈圈";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationBarView addSubview:titleLabel];
    
    //分割线
    UIImageView *lineBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
    lineBackImageView.backgroundColor = [UIColor lightGrayColor];
    [navigationBarView addSubview:lineBackImageView];
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
/**
 请求网络数据
 */
-(void)requestDataFromNetWorking
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
    
    [HttpRequest Post:[NSString stringWithFormat:@"http://api.douguo.net/group/indexv2/%ld/20/",_currentPage] paramters:@"lut=1476443227&client=4&tpid=248559" dictionary:headerRequest success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self handleDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
        
        
    }];
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

#pragma mark - 封装数据
-(void)handleDataWithObject:(id)responseObject
{
    if (_currentPage == 0) {
        
        [self.bsDataSource removeAllObjects];
        [self.gsDataSource removeAllObjects];
        [self.listDataSource removeAllObjects];
    }
    //广告栏
    NSArray *bs = responseObject[@"result"][@"bs"];
    
    for (NSDictionary *dic in bs)
    {
        DGCCycleADViewModel *model = [[DGCCycleADViewModel alloc] init];
        model.picUrl = dic[@"i"];
        model.picId = dic[@"id"];
        model.picU = dic[@"u"];
        
        if (![model.picU hasPrefix:@"http://"]) {
            
            [self.bsDataSource addObject:model];
        }
    }
    //列表
    NSArray *gs = responseObject[@"result"][@"gs"];
    
    for (NSDictionary *dic2 in gs) {
        
        DGCListModel *listModel = [DGCListModel modelWithDictionary:dic2];
        listModel.imageId = dic2[@"id"];
        [self.gsDataSource addObject:listModel];
    }
    //热门帖子
    NSArray *list = responseObject[@"result"][@"list"];
    
    for (NSDictionary *dic in list)
    {
        DGCAllDataModel *model = [[DGCAllDataModel alloc] init];
        model.userIcon = dic[@"gp"][@"a"][@"p"];
        model.userName = dic[@"gp"][@"a"][@"n"];
        model.verified = [NSString stringWithFormat:@"%@",dic[@"gp"][@"a"][@"v"]];
        model.listId = dic[@"gp"][@"id"];
        model.title = dic[@"gp"][@"n"];
        model.pulishTime = [self currentBetweenExpireFormatterWithExpireDateString:dic[@"gp"][@"lt"]];
        model.pulishTimeSecond = [dic[@"gp"][@"lt"] substringToIndex:10];
        model.imageUrl = dic[@"gp"][@"i"];
        model.imageCount = dic[@"gp"][@"ic"];
        DGCAllDataModelFrame *modelFrame = [[DGCAllDataModelFrame alloc] init];
        modelFrame.model = model;
        
        if (model.userName.length != 0)
        {
            [self.listDataSource addObject:modelFrame];
            
        }
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
    NSInteger num;
    if (section == 0) {
        
        num = self.gsDataSource.count;
    }else if (section == 1)
    {
        num = 1;
    }
    else
    {
        num = self.listDataSource.count;
    }
    return num;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0)
    {
        DGCCycleListCell *cellOne = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cellOne.model = self.gsDataSource[indexPath.row];
        cellOne.backgroundColor = [UIColor lightGrayColor];
        cell = cellOne;
    }else if (indexPath.section == 1)
    {
        UITableViewCell *cellThree = [tableView dequeueReusableCellWithIdentifier:@"cellThree"];
        cellThree.textLabel.text = @"热门帖子";
        cellThree.backgroundColor = [UIColor whiteColor];
        cell = cellThree;
    }
    else
    {
        DGCCycleListAllDataCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
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
    if (indexPath.section == 0)
    {
        
        height = kListCellHeight;
        
    }
    else if (indexPath.section == 1)
    {
        height = 50;
    }
    else
    {
        DGCAllDataModelFrame *modelFrame = self.listDataSource[indexPath.row];
        height = modelFrame.cellHeight;
    }
    return height;
}

/**
 选中触发

 @param tableView <#tableView description#>
 @param indexPath <#indexPath description#>
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            
            //跳转到写食派界面
            [self changeToListDescViewCtrl];
            
        }else if (indexPath.row == 1)
        {
            //跳转到趣视频界面
            [self changeToFunVideoViewCtrl];
        }else
        {
            //跳转到“全部”界面
            DGCListModel *listModel = self.gsDataSource[indexPath.row];
            [self changeToAllDataViewCtrlWithImageId:listModel.imageId];
        }
        
    }
    else if (indexPath.section == 2)
    {
        //跳转到帖子详情界面
        DGCAllDataModelFrame *modelFrame = self.listDataSource[indexPath.row];
        
        [self changToDetailViewCtrollerWithPicU:modelFrame.model.listId];
    }
}

/**
 热门帖子的段头

 @param tableView <#tableView description#>
 @param section   <#section description#>

 @return <#return value description#>
 */
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    
    if (section == 1) {
        
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        sectionHeaderView.backgroundColor = [UIColor lightGrayColor];
        headerView = sectionHeaderView;
    }
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.0;
    
    if (section == 1) {
        
        height = 10;
    }
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

#pragma mark - 界面跳转

/**
 帖子详情界面
 */
-(void)changToDetailViewCtrollerWithPicU:(NSString *)picU
{
    DGCCycleDetailViewController *detailViewCtrl = [[DGCCycleDetailViewController alloc] init];
    detailViewCtrl.picU = picU;
    [self.navigationController pushViewController:detailViewCtrl animated:YES];
}

/**
 跳转到写食派界面
 */
-(void)changeToListDescViewCtrl
{
    DGCListDescViewController *listDescViewCtrl = [[DGCListDescViewController alloc] init];
    
    [self.navigationController pushViewController:listDescViewCtrl animated:YES];
}
/**
 跳转到趣视频界面
 */
-(void)changeToFunVideoViewCtrl
{
    DGCCycleFunVideoViewController *funVideoViewCtrl = [[DGCCycleFunVideoViewController alloc] init];
    
    [self.navigationController pushViewController:funVideoViewCtrl animated:YES];
}
/**
 跳转到全部的界面
 */
-(void)changeToAllDataViewCtrlWithImageId:(NSString *)imageId
{
    DGCCycleListAllDataViewController *allDataViewCtrl = [[DGCCycleListAllDataViewController alloc] init];
    allDataViewCtrl.imageId = imageId;
    [self.navigationController pushViewController:allDataViewCtrl animated:YES];
}
@end
