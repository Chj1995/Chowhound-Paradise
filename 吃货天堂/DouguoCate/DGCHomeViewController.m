//
//  DGCHomeViewController.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCHomeViewController.h"
#import "DGCHomeMainContentView.h"
#import "DGCADModel.h"
#import "DGCADToolViewModel.h"
#import "DGCHomeModel.h"
#import "DGCDescViewController.h"
#import "DGCSpecialViewController.h"
#import "HttpRequest.h"
#import "DGCHomeModelFrame.h"
#import "DGCMenuListViewController.h"
#import "DGCVideoViewController.h"
#import "DGCChooseListViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "DGCConfig.h"
@interface DGCHomeViewController ()
{
    NSInteger _currentPage;
    UIButton *button;
    UILabel *label;
}
@property(nonatomic,weak)DGCHomeMainContentView *homeMainContentView;

/**
 广告栏数据源
 */
@property(nonatomic,strong)NSMutableArray *adDataSource;

/**
 工具栏数据源
 */
@property(nonatomic,strong)NSMutableArray *adToolDataSource;

/**
 物品数据源
 */
@property(nonatomic,strong)NSMutableArray *goodsDataSource;

@end

@implementation DGCHomeViewController
#pragma mark - 懒加载
-(DGCHomeMainContentView *)homeMainContentView
{
    if (!_homeMainContentView) {
        __weak DGCHomeViewController *weekSelf = self;
        
        DGCHomeMainContentView *mainContentView = [[DGCHomeMainContentView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, self.view.frame.size.height - 60)];
        
        //下拉刷新
        [mainContentView setHomeMainContentViewHeaderUpdateCallback:^{
            
            _currentPage = 0;
            [weekSelf requestDataFromNetWorking];
        }];
        //上拉刷新
        [mainContentView setHomeMainContentViewFootUpdateCallback:^{
            _currentPage += 20;
            [weekSelf requestDataFromNetWorking];
        }];
        
        //点击广告栏cell的回调
        [mainContentView setHomeMainContentViewSelectedCallback:^(NSString* picId) {
            
            if ([picId isEqualToString:@"simplerecipelist"])
            {
                [weekSelf changeToSpecialViewControllerWithPicId:picId];
                
            }else if ([picId isEqualToString:@"menulist"])
            {
                [weekSelf changeToMenuListViewControllerWithPicId:picId];
            }
            else if ([picId isEqualToString:@"showlist"])
            {
                [weekSelf changeToVideoViewControllerWithPicId:picId];
                
            }
            else
            {
                //点击广告栏cell的回调
                [weekSelf changeToDescViewCtrollerWithPicId:picId];
            }
        }];
        //点击物品的回调
        [mainContentView setHomeMainContentViewChangeViewCtrollerCallback:^(NSString *type, NSString *picId) {
           
            switch ([type integerValue]) {
                case 2:
                    [weekSelf changeToDescViewCtrollerWithPicId:picId];
                    break;
                case 3:
                    [weekSelf changeToChooseListViewCtrlWithPicId:picId];
                    break;
                    
                default:
                    break;
            }
            
        }];
        
        [self.view addSubview:mainContentView];
        _homeMainContentView = mainContentView;
    }
    return _homeMainContentView;
}
-(NSMutableArray *)adDataSource
{
    if (!_adDataSource) {
        
        _adDataSource = [NSMutableArray array];
    }
    return _adDataSource;
}
-(NSMutableArray *)adToolDataSource
{
    if (!_adToolDataSource) {
        
        _adToolDataSource = [NSMutableArray array];
    }
    return _adToolDataSource;
}
-(NSMutableArray *)goodsDataSource
{
    if (!_goodsDataSource) {
        
        _goodsDataSource = [NSMutableArray array];
    }
    return _goodsDataSource;
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
    
        _currentPage = 0;
}

#pragma mark - 自定义导航栏
-(void)setupMyNavigationBarView
{
    UIView *navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 20,kScreenWidth, 40)];
    navigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationBarView];
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 20)];
    titleLabel.text = @"首页";
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
    
    [HttpRequest Post:[NSString stringWithFormat:@"http://api.douguo.net/recipe/home/%ld/20/1678",_currentPage] paramters:nil dictionary:headerRequest success:^(id responseObject) {
        
        [self handleDataWithObject:responseObject];
        [self.homeMainContentView endRefresh];
        
    } failure:^(NSError *error) {
    
        
    }];
}
#pragma mark - 截取字符串

/**
 截取广告栏部分的字符串

 @param string <#string description#>

 @return <#return value description#>
 */
-(NSString *)strintWithADString:(NSString *)string
{
    NSRange rang = [string rangeOfString:@"="];
    NSRange rang2 = [string rangeOfString:@"&" options:NSBackwardsSearch];
    NSString *str = [string substringWithRange:NSMakeRange(rang.location + 1, rang2.location - rang.location - 1)];
    return str;
}
-(NSString *)stringWithADToolString:(NSString *)string
{
    NSRange rang = [string rangeOfString:@"/" options:NSBackwardsSearch];
    NSRange rang2 = [string rangeOfString:@"?" options:NSBackwardsSearch];
    NSString *str = [string substringWithRange:NSMakeRange(rang.location + 1, rang2.location - rang.location - 1)];
    return str;
}
#pragma mark - 封装数据
-(void)handleDataWithObject:(id)responseObject
{
    if (_currentPage == 0) {
        
        [self.adDataSource removeAllObjects];
        [self.adToolDataSource removeAllObjects];
        [self.goodsDataSource removeAllObjects];
    }
    //广告栏
    NSArray *trs = responseObject[@"result"][@"header"][@"trs"];
    
    for (NSDictionary *dic in trs)
    {
        DGCADModel *adModel = [[DGCADModel alloc] init];
        adModel.picTitle = dic[@"t"];
        adModel.picUrl = dic[@"b"][@"i"];
        adModel.picId = [self strintWithADString:dic[@"b"][@"u"]];
        adModel.userId = dic[@"u"][@"id"];
        adModel.userName = dic[@"u"][@"n"];
        adModel.userAvatar = dic[@"u"][@"p"];
        adModel.userVip = dic[@"u"][@"v"];
        
        if (adModel.userName.length != 0)
        {
            
            [self.adDataSource addObject:adModel];
        }
        
    }
    
    self.homeMainContentView.adArray = self.adDataSource;
    
    //工具栏
    NSArray *header = responseObject[@"result"][@"header"][@"fs"];
    for (NSDictionary *dic in header)
    {
        DGCADToolViewModel *adToolModel = [[DGCADToolViewModel alloc] init];
        adToolModel.content = dic[@"content"];
        adToolModel.picUrl = dic[@"i"];
        adToolModel.picId = [self stringWithADToolString:dic[@"u"]];
        adToolModel.picTitle = dic[@"t"];
        [self.adToolDataSource addObject:adToolModel];
    }
    [self.adToolDataSource removeLastObject];
    self.homeMainContentView.adToolArray = self.adToolDataSource;
    
    //物品
    NSArray *list = responseObject[@"result"][@"list"];
    
    for (NSDictionary *dic in list)
    {
        DGCHomeModel *homeModel = [[DGCHomeModel alloc] init];
        homeModel.type = dic[@"type"];
        
        if (!dic[@"ta"]) {
            
            if (!dic[@"b"]) {
                
                if (dic[@"m"])
                {
                    homeModel.picId = dic[@"m"][@"id"];
                    homeModel.picUrl = dic[@"m"][@"b"];
                    homeModel.desc = dic[@"m"][@"c"];
                    homeModel.picTitle = dic[@"m"][@"t"];
                    homeModel.userName = dic[@"m"][@"a"][@"n"];
                }
                else if (dic[@"r"])
                {
                    homeModel.picId = dic[@"r"][@"id"];
                    homeModel.picUrl = dic[@"r"][@"p"];
                    if ([dic[@"r"][@"cookstory"] isEqualToString:@""]) {
                        
                        homeModel.desc = nil;
                    }else
                    {
                        homeModel.desc = dic[@"r"][@"cookstory"];
                    }
                    homeModel.picTitle = dic[@"r"][@"n"];
                    homeModel.userAvatar = dic[@"r"][@"a"][@"p"];
                    homeModel.userName = dic[@"r"][@"a"][@"n"];
                    homeModel.userVip = [NSString stringWithFormat:@"%@",dic[@"r"][@"a"][@"v"]];
                    homeModel.vc = dic[@"r"][@"vc"];
                    homeModel.vu = dic[@"r"][@"vu"];
                    homeModel.fc = dic[@"r"][@"fc"];
                }
                DGCHomeModelFrame *modelFrame = [[DGCHomeModelFrame alloc] init];
                modelFrame.model = homeModel;
                [self.goodsDataSource addObject:modelFrame];
            }
            
        }
        
    }
    self.homeMainContentView.goodsArray = self.goodsDataSource;
}
#pragma mark - 页面跳转

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

/**
 跳转到今日最新界面
 */
-(void)changeToSpecialViewControllerWithPicId:(NSString *)picId
{
    DGCSpecialViewController *specialViewCtrl = [[DGCSpecialViewController alloc] init];
    
    specialViewCtrl.picId = picId;
    
    [self.navigationController pushViewController:specialViewCtrl animated:YES];
}

/**
 跳转到精品菜单界面
 */
-(void)changeToMenuListViewControllerWithPicId:(NSString *)picId
{
    DGCMenuListViewController *menuListViewCtrl = [[DGCMenuListViewController alloc] init];
    menuListViewCtrl.picId = picId;
    [self.navigationController pushViewController:menuListViewCtrl animated:YES];
}

/**
 跳转到视频专区界面
 */
-(void)changeToVideoViewControllerWithPicId:(NSString *)picId
{
    DGCVideoViewController *videoViewCtrl = [[DGCVideoViewController alloc] init];
    
    videoViewCtrl.picId = picId;
    
    [self.navigationController pushViewController:videoViewCtrl animated:YES];
}

/**
 菜谱数界面
 */
-(void)changeToChooseListViewCtrlWithPicId:(NSString *)picId
{
    DGCChooseListViewController *chooseListViewCtrl = [[DGCChooseListViewController alloc] init];
    
    chooseListViewCtrl.picId = picId;
    
    [self.navigationController pushViewController:chooseListViewCtrl animated:YES];
}

@end
