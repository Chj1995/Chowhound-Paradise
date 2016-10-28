//
//  DGCBaseTabbarViewController.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCBaseTabbarViewController.h"

@interface DGCBaseTabbarViewController ()

@end

@implementation DGCBaseTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置tabBar上的颜色
    UIColor *color = [UIColor colorWithRed:246.0/255.0 green:95.0/255.0 blue:45.0/255.0 alpha:1];
    self.tabBar.tintColor = color;
    //将tabbar设置为不透明
    self.tabBar.translucent = NO;
    //初始化子控制器
    [self initChildrenControllers];
}

/**
 初始化子控制器
 */
-(void)initChildrenControllers
{
    NSArray *ctrlNames = @[@"DGCHomeViewController",
                           @"DGCCyclesViewController"];
    NSArray *titleNames = @[@"首页",@"圈圈"];
    
    NSArray *normalImageNames = @[@"tab_icon_cookbook_normal",
                                  @"tab_icon_events_normal"];
    
    NSArray *selectedImageNames = @[@"tab_icon_cookbook_hl",
                                    @"tab_icon_events_hl"];
    
    [ctrlNames enumerateObjectsUsingBlock:^(NSString *ctrName, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIViewController *ctrl = [[NSClassFromString(ctrName) alloc] init];
        
        ctrl.title = titleNames[idx];
        ctrl.tabBarItem.image = [UIImage imageNamed:normalImageNames[idx]];
        ctrl.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageNames[idx]];
        [self addChildViewController:ctrl];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
