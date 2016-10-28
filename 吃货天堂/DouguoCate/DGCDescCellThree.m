//
//  DGCDescCellThree.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCDescCellThree.h"
#import "UIImageView+WebCache.h"
#import "DGCConfig.h"
#import "DGCDescModelTwo.h"

@interface DGCDescCellThree ()
{
    UILabel *titleLabel;
    UIImageView *imageView;
    UILabel *contentLabel;
    DGCDescModelTwo *_model;
}
@end
@implementation DGCDescCellThree

-(void)setModelFrame:(DGCDescModelTwoFrame *)modelFrame
{
    [imageView removeFromSuperview];
    [contentLabel removeFromSuperview];
    [titleLabel removeFromSuperview];
    
    _modelFrame = modelFrame;
    
    _model = modelFrame.model;
    
    /**
     创建标题
     */
    if ([_model.position isEqualToString:@"1"]) {
        
        [self setupTitleLabel];
    }
    if (![_model.image isEqualToString:@""]) {
        
        /**
         1.创建图片
         */
        [self setupImageView];
    }
    
    /**
     2.创建描述
     */
    [self setupContentLabel];
}

/**
 1.创建图片
 */
-(void)setupImageView
{
    if ([_model.position isEqualToString:@"1"]) {
        
       imageView = [[UIImageView alloc] initWithFrame:_modelFrame.imageViewRect];
    }else
    {
        imageView = [[UIImageView alloc] initWithFrame:_modelFrame.imageViewRect];
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:[UIImage imageNamed:@"photo"]];
    [self.contentView addSubview:imageView];
}

/**
 2.创建描述
 */
-(void)setupContentLabel
{
    contentLabel = [[UILabel alloc] initWithFrame:_modelFrame.contentLabelRect];
    contentLabel.text = [NSString stringWithFormat:@"%@ %@",_model.position,_model.content];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
}

/**
 创建标题
 */
-(void)setupTitleLabel
{
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 40)];
    titleLabel.text = @"- 烹饪步骤 -";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
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
