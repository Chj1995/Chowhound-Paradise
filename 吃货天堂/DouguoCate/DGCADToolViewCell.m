//
//  DGCADToolViewCell.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/6.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCADToolViewCell.h"
#import "UIImageView+WebCache.h"

@interface DGCADToolViewCell ()
{
    UIImageView *imageView;
    UILabel *titleLabel;
}
@end
@implementation DGCADToolViewCell

-(void)setModel:(DGCADToolViewModel *)model
{
    [imageView removeFromSuperview];
    [titleLabel removeFromSuperview];
    
    _model = model;
    
    /**
     1.设置图片
     */
    [self setupImageView];
    /**
     2.创建标题
     */
    [self setupTitleLabel];
}

/**
 1.设置图片
 */
-(void)setupImageView
{
    CGFloat imageViewWidth = self.frame.size.width/2;
    CGFloat imageViewHeight = self.frame.size.height/4*2;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame)/2 - imageViewWidth/2, 10, imageViewWidth, imageViewHeight)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:[UIImage imageNamed:@"photo"]];
    imageView.layer.cornerRadius = imageViewHeight/2;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
}

/**
 2.创建标题
 */
-(void)setupTitleLabel
{
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, self.contentView.frame.size.width, 20)];
    titleLabel.text = _model.picTitle;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
}
@end
