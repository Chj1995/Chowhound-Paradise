//
//  DGCAllDataViewController.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/18.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleListAllDataViewController.h"
#import "HttpRequest.h"
#import "DGCAllDataModel.h"
#import "DGCAllDataModelFrame.h"
#import "DGCCycleListAllDataCell.h"
#import "DGCCycleDetailViewController.h"
#import "MJRefresh.h"
#import "MyNavigationBarView.h"
#import "DGCConfig.h"
#import "AFNetworkReachabilityManager.h"

@interface DGCCycleListAllDataViewController ()<UITableViewDelegate,UITableViewDataSource>
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
 数据源
 */
@property(nonatomic,strong)NSMutableArray *dataSource;

/**
 *  时间格式化类
 */
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DGCCycleListAllDataViewController
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, self.view.frame.size.height - 70) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        
        tableView.showsVerticalScrollIndicator = NO;
        
        tableView.mj_header = [self header];
        tableView.mj_footer = [self foot];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //注册cell
        [tableView registerClass:[DGCCycleListAllDataCell class] forCellReuseIdentifier:@"cell"];
        
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
        
        _currentPage += 20;
        [self requestDataFromNetWorking];
    }];
    
    [foot setTitle:@"上拉刷新" forState:MJRefreshStateIdle];
    [foot setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [foot setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    
    return foot;
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
    MyNavigationBarView *navigationBarView = [[MyNavigationBarView alloc] initWithFrame:CGRectMake(0, 20,kScreenWidth, 50)];
    navigationBarView.backgroundColor = [UIColor whiteColor];

    NSString *title;
    switch (self.imageId.integerValue) {
        case 6:
            title = @"学烘焙";
            break;
        case 16:
            title = @"玖号厨房";
            break;
        case 26:
            title = @"食色";
            break;
        case 27:
            title = @"三分食刻";
            break;
        case 1:
            title = @"get技能";
            break;
        case 4:
            title = @"孕妈育儿";
            break;
        case 3:
            title = @"美丽控";
            break;
        default:
            break;
    }
    [navigationBarView setupTitleLableWithTitle:title TitleSize:17];
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
    //http://api.douguo.net/group/posts/0/20
    
    NSDictionary *headerRequest = @{@"lon":@"113.961889",
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
                                    @"lat":@"22.580073",
                                    @"Cookie":@"duid=47404332",
                                    @"User-Agent":@"Dalvik/1.6.0 (Linux; U; Android 4.4.4; MI 4C MIUI/V7.1.5.0.KXDCNCK) Paros/3.2.13",
                                    @"Host":@"api.douguo.net",
                                    @"Content-Length":@"25"};
    [HttpRequest Post:[NSString stringWithFormat:@"http://api.douguo.net/group/posts/%ld/20",_currentPage] paramters:[NSString stringWithFormat:@"id=%@&client=4&nd=1&sort=0",self.imageId] dictionary:headerRequest success:^(id responseObject) {
        
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
        
        [self.dataSource removeAllObjects];
    }
    
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
            [self.dataSource addObject:modelFrame];
            
        }
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
    
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGCCycleListAllDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.modelFrame = self.dataSource[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGCAllDataModelFrame *modelFrame = self.dataSource[indexPath.row];
    
    return modelFrame.cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGCAllDataModelFrame *modelFrame = self.dataSource[indexPath.row];
    
    [self changToDetailViewCtrollerWithListId:modelFrame.model.listId];
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

#pragma mark - 跳转界面
-(void)changToDetailViewCtrollerWithListId:(NSString *)listId
{
    DGCCycleDetailViewController *detailViewCtrl = [[DGCCycleDetailViewController alloc] init];
    detailViewCtrl.picU = listId;
    [self.navigationController pushViewController:detailViewCtrl animated:YES];
}
@end
