//
//  DGCCycleADViewCell.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleADViewCell.h"
#import "DGCConfig.h"
#import "UIImageView+WebCache.h"

@interface DGCCycleADViewCell ()
{
    UIImageView *imageView;
}

@end
@implementation DGCCycleADViewCell

-(void)setModel:(DGCCycleADViewModel *)model
{
    [imageView removeFromSuperview];
    
    _model = model;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kADViewHeight)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:[UIImage imageNamed:@"photo"]];
    [self.contentView addSubview:imageView];
}

@end
