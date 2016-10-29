//
//  DGCVideoViewController.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/11.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCVideoViewController.h"
#import "HttpRequest.h"
#import "DGCConfig.h"
#import "DGCVideoView.h"
#import "DGCHomeCellTwo.h"
#import "DGCHomeModelFrame.h"
#import "DGCHomeModel.h"
#import "DGCVideoPlayViewController.h"
#import "DGCDescViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "MyNavigationBarView.h"

@interface DGCVideoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *label;
    UIButton *button;
}

@property(nonatomic,weak)UITableView *tableView;


/**
 返回顶部
 */
@property(nonatomic,weak)UIButton *backToTopButton;

/**
 显示数据源
 */
@property(nonatomic,strong)NSMutableArray *listsDataSource;

/**
 最热数据源
 */
@property(nonatomic,strong)NSMutableArray *hotDataSource;

/**
 最新数据源
 */
@property(nonatomic,strong)NSMutableArray *NewDataSource;


/**
 烘焙数据源
 */
@property(nonatomic,strong)NSMutableArray *hongBeiDataSource;

/**
 家常数据源
 */
@property(nonatomic,strong)NSMutableArray *miaoChuDataSource;

/**
 宝宝菜数据源
 */
@property(nonatomic,strong)NSMutableArray *bbCaiDataSource;

/**
 异国菜数据源
 */
@property(nonatomic,strong)NSMutableArray *xiCanDataSource;


@end

@implementation DGCVideoViewController
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderViewHeight + 71, kScreenWidth, self.view.frame.size.height - kHeaderViewHeight - 71) style:UITableViewStylePlain];
        
        tb.delegate = self;
        tb.dataSource = self;
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tb];
        
        tb.showsVerticalScrollIndicator = NO;
        
        [tb registerClass:[DGCHomeCellTwo class] forCellReuseIdentifier:@"cell"];
        _tableView = tb;
    }
    return _tableView;
}
-(NSMutableArray *)listsDataSource
{
    if (!_listsDataSource) {
        
        _listsDataSource = [NSMutableArray array];
    }
    return _listsDataSource;
}
-(NSMutableArray *)hotDataSource
{
    if (!_hotDataSource) {
        
        _hotDataSource = [NSMutableArray array];
    }
    return _hotDataSource;
}
-(NSMutableArray *)NewDataSource
{
    if (!_NewDataSource) {
        
        _NewDataSource = [NSMutableArray array];
    }
    return _NewDataSource;
}
-(NSMutableArray *)hongBeiDataSource
{
    if (!_hongBeiDataSource) {
        
        _hongBeiDataSource = [NSMutableArray array];
    }
    return _hongBeiDataSource;
}
-(NSMutableArray *)miaoChuDataSource
{
    if (!_miaoChuDataSource) {
        
        _miaoChuDataSource = [NSMutableArray array];
    }
    return _miaoChuDataSource;
}
-(NSMutableArray *)bbCaiDataSource
{
    if (!_bbCaiDataSource) {
        
        _bbCaiDataSource = [NSMutableArray array];
    }
    return _bbCaiDataSource;
}
-(NSMutableArray *)xiCanDataSource
{
    if (!_xiCanDataSource) {
        
        _xiCanDataSource = [NSMutableArray array];
    }
    return _xiCanDataSource;
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

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupMyNavigationBarView];
    [self setupButtonAndLabel];
    [self setupHeaderView];
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
    [navigationBarView setupTitleLableWithTitle:@"视频专区" TitleSize:17];
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
#pragma mark - 创建头视图
-(void)setupHeaderView
{
    NSArray *toolArray = @[@"最热",@"最新",@"烘焙",@"家常",@"宝宝菜",@"异国"];
    
    DGCVideoView *headerView = [[DGCVideoView alloc] initWithFrame:CGRectMake(0, 71, kScreenWidth, kHeaderViewHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView setVideoViewCellSelectedCallback:^(NSInteger index) {
       
        [self changDataSourceWithIndex:index];
        
    }];
    headerView.toolArray = toolArray;
    
    [self.view addSubview:headerView];
}
#pragma mark - 请求网络数据
-(void)requestDataFromNetWorking
{
    NSDictionary *headerRequest = @{@"Host":@"m.douguo.com",
                                    @"Proxy-Connection":@"26",
                                    @"Accept":@"application/json, text/javascript, */*; q=0.01",
                                    @"Origin":@"http://m.douguo.com",
                                    @"X-Requested-With":@"XMLHttpRequest",
                                    @"User-Agent":@"Mozilla/5.0 (Linux; Android 4.4.4; MI 4C Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36 Paros/3.2.13",
                                    @"Content-Type":@"application/x-www-form-urlencoded; charset=UTF-8",
                                    @"Referer":@"http://m.douguo.com/video/showlist?open=1",
                                    @"Accept-Language":@"zh-CN,en-US;q=0.8",
                                    @"Cookie":@"wapdg_auths=a%3A4%3A%7Bs%3A10%3A%22session_id%22%3Bs%3A32%3A%22872673d0e50bb87eed8cab0e0c30559b%22%3Bs%3A10%3A%22ip_address%22%3Bs%3A13%3A%22192.168.1.228%22%3Bs%3A10%3A%22user_agent%22%3Bs%3A50%3A%22Mozilla%2F5.0+%28Linux%3B+Android+4.4.4%3B+MI+4C+Build%2FKTU%22%3Bs%3A13%3A%22last_activity%22%3Bi%3A1476186213%3B%7D2f663215f1948b7e904e85c899a7ecfb"};
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"http://m.douguo.com/video/ajaxshowlist"];
    //最热
    [HttpRequest Post:urlStr paramters:@"type=hot&offset=0&limit=10" dictionary:headerRequest success:^(id responseObject) {
        
        [self handleHotDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    //最新
    [HttpRequest Post:urlStr paramters:@"type=new&offset=0&limit=10" dictionary:headerRequest success:^(id responseObject) {
        
        [self handleNewDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
        if (error != NULL) {
            
        }
    }];
    //烘焙
    [HttpRequest Post:urlStr paramters:@"type=hongbei&offset=0&limit=10" dictionary:headerRequest success:^(id responseObject) {
        
        [self handleHongBeiDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
        if (error != NULL) {
            
        }
    }];
    //家常
    [HttpRequest Post:urlStr paramters:@"type=miaochu&offset=0&limit=10" dictionary:headerRequest success:^(id responseObject) {
        
        [self handleMiaoChuDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
        if (error != NULL) {
            
        }
    }];
    //宝宝菜
    [HttpRequest Post:urlStr paramters:@"type=baobaocai&offset=0&limit=10" dictionary:headerRequest success:^(id responseObject) {
        
        [self handlebbCaiDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
        if (error != NULL) {
            
        }
    }];
    //异国
    [HttpRequest Post:urlStr paramters:@"type=xican&offset=0&limit=10" dictionary:headerRequest success:^(id responseObject) {
        
        [self handleXiCanDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
        if (error != NULL) {
                        
        }
    }];
}
#pragma mark - 更换数据源
-(void)changDataSourceWithIndex:(NSInteger)index
{
    [self.listsDataSource removeAllObjects];
    
    switch (index) {
        case 0:
            [self.listsDataSource addObjectsFromArray:self.hotDataSource];
            break;
        case 1:
            [self.listsDataSource addObjectsFromArray:self.NewDataSource];
            break;
        case 2:
            [self.listsDataSource addObjectsFromArray:self.hongBeiDataSource];
            break;
        case 3:
            [self.listsDataSource addObjectsFromArray:self.miaoChuDataSource];
            break;
        case 4:
            [self.listsDataSource addObjectsFromArray:self.bbCaiDataSource];
            break;
        case 5:
            [self.listsDataSource addObjectsFromArray:self.xiCanDataSource];
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}
#pragma mark - 封装数据

/**
 最热
 */
-(void)handleHotDataWithObject:(id)responseObject
{
    [self.hotDataSource addObjectsFromArray:[self handleDataWithObject:responseObject]];
    
    [self.listsDataSource addObjectsFromArray:self.hotDataSource];
    
    [self.tableView reloadData];
}
/**
 最新
 */
-(void)handleNewDataWithObject:(id)responseObject
{
    [self.NewDataSource addObjectsFromArray:[self handleDataWithObject:responseObject]];
}
/**
 烘焙
 */
-(void)handleHongBeiDataWithObject:(id)responseObject
{
    [self.hongBeiDataSource addObjectsFromArray:[self handleDataWithObject:responseObject]];
    
}
/**
 家常
 */
-(void)handleMiaoChuDataWithObject:(id)responseObject
{
    [self.miaoChuDataSource addObjectsFromArray:[self handleDataWithObject:responseObject]];
}
/**
 宝宝菜
 */
-(void)handlebbCaiDataWithObject:(id)responseObject
{
    [self.bbCaiDataSource addObjectsFromArray:[self handleDataWithObject:responseObject]];
    
}
/**
 异国
 */
-(void)handleXiCanDataWithObject:(id)responseObject
{
    [self.xiCanDataSource addObjectsFromArray:[self handleDataWithObject:responseObject]];
    
}

#pragma mark - 处理数据
-(NSArray *)handleDataWithObject:(id)responseObject
{
    NSMutableArray *mutaArray = [NSMutableArray array];
    
    NSArray *lists = responseObject[@"data"][@"lists"];
    
    for (NSDictionary *dic in lists) {
        
        DGCHomeModel *model = [[DGCHomeModel alloc] init];
        model.picUrl = dic[@"pic"];
        model.picId = dic[@"id"];
        model.picTitle = dic[@"name"];
        model.userAvatar = dic[@"author_pic"];
        model.userName = dic[@"author_name"];
        model.vu = dic[@"video_url"];
        DGCHomeModelFrame *modelFrame = [[DGCHomeModelFrame alloc] init];
        modelFrame.model = model;
        [mutaArray addObject:modelFrame];
    }
    return mutaArray;
}
#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.listsDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DGCHomeCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.modelFrame = self.listsDataSource[indexPath.row];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGCHomeModelFrame *modelFrame = self.listsDataSource[indexPath.row];
    
    return modelFrame.cellHeight;
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

#pragma mark - 选中触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGCHomeModelFrame *modelFrame = self.listsDataSource[indexPath.row];
    
    if ([modelFrame.model.vu hasPrefix:@"http://"])
    {
        
        [self changeToViedeoPlayViewCtrollerWithUrl:modelFrame.model.vu];
    }else
    {
        [self changeToDescViewCtrollerWithPicId:modelFrame.model.picId];
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

#pragma mark - 跳转界面

/**
 跳转到视频播放界面

 @param url <#url description#>
 */
-(void)changeToViedeoPlayViewCtrollerWithUrl:(NSString *)url
{
    DGCVideoPlayViewController *videoPlayViewCtrl = [[DGCVideoPlayViewController alloc] init];
    videoPlayViewCtrl.url = url;
    [self.navigationController pushViewController:videoPlayViewCtrl animated:YES];
}
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
