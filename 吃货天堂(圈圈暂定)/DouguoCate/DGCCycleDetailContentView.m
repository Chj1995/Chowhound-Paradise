//
//  DGCCycleDetailContentView.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/15.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleDetailContentView.h"
#import "DGCConfig.h"
#import "DGCCycleDetailContentModelFrame.h"
#import "DGCCycleDetailContentCell.h"

@interface DGCCycleDetailContentView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UITableView *tableView;

@end
@implementation DGCCycleDetailContentView
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        tableView.scrollEnabled = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[DGCCycleDetailContentCell class] forCellReuseIdentifier:@"cell"];
        _tableView = tableView;
    }
    return _tableView;
}
#pragma mark - setter
-(void)setContentArray:(NSArray *)contentArray
{
    _contentArray = contentArray;
    
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _contentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGCCycleDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.modelFrame = _contentArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGCCycleDetailContentModelFrame *modelFrame = _contentArray[indexPath.row];
    
    return modelFrame.cellHeight;
}
@end
