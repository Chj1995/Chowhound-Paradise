//
//  DGCDescCellTwo.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/7.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCDescCellTwo.h"
#import "DGCMajorModel.h"
#import "DGCConfig.h"

@interface DGCDescCellTwo ()
{
    DGCMajorModel *_model;
    UIView *subView;
    UIView *subView2;
    UIView *subView3;
    UILabel *titleLabel;
    UILabel *noteLabel;
}
@end
@implementation DGCDescCellTwo

-(void)setModelFrame:(DGCMajorModelFrame *)modelFrame
{
    [titleLabel removeFromSuperview];
    [noteLabel removeFromSuperview];
    [subView removeFromSuperview];
    [subView2 removeFromSuperview];
    [subView3 removeFromSuperview];
    
    _modelFrame = modelFrame;
    
    _model = modelFrame.model;
    
    //空白view
    subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, _modelFrame.cellHeight)];
    subView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:subView];
    
    subView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth - 40, _modelFrame.cellHeight - 1)];
    subView2.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:subView2];
    
    subView3 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 20, 0, 20, _modelFrame.cellHeight)];
    subView3.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:subView3];

    //食材
    titleLabel = [[UILabel alloc] initWithFrame:_modelFrame.major_titleRect];
    titleLabel.text = _model.major_title;
    titleLabel.numberOfLines = 0;
    [subView2 addSubview:titleLabel];
    
    //食材分量
    noteLabel = [[UILabel alloc] initWithFrame:_modelFrame.major_noteRect];
    noteLabel.text = _model.major_note;
    noteLabel.numberOfLines = 0;
    noteLabel.textColor = [UIColor lightGrayColor];
    [subView2 addSubview:noteLabel];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
