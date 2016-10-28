//
//  DGCCyCleListContentSimpleCell.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCyCleListContentSimpleCell.h"
#import "UIImageView+WebCache.h"


@interface DGCCyCleListContentSimpleCell ()
{
    UIImageView *imageView;
}

@end
@implementation DGCCyCleListContentSimpleCell

-(void)setModel:(DGCCycleListContentModel *)model
{
    [imageView removeFromSuperview];
    
    _model = model;
    
    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:[UIImage imageNamed:@"photo"]];
    [self.contentView addSubview:imageView];
    
    
}
@end
