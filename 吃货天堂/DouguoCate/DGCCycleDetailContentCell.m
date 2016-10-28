//
//  DGCCycleDetailContentCell.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/15.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCCycleDetailContentCell.h"
#import "DGCCycleDetailContentModel.h"
#import "UIImageView+WebCache.h"
#import <WebKit/WebKit.h>

@interface DGCCycleDetailContentCell ()
{
    DGCCycleDetailContentModel *_model;
    UILabel *contentLabel;
    UIImageView *contentImageView;
    WKWebView *webView;
    
}
@end
@implementation DGCCycleDetailContentCell
-(void)setModelFrame:(DGCCycleDetailContentModelFrame *)modelFrame
{
    [contentLabel reloadInputViews];
    [contentImageView removeFromSuperview];
    [webView removeFromSuperview];
    
    _modelFrame = modelFrame;
    _model = modelFrame.model;
    
    //内容
    [self setupContentLabel];
    
    //图片
    if (_model.vu.length != 0) {
        
        [self setupWebView];
        
    }else
    {
        if (_model.activityContentPicUrl.length != 0) {
            
            [self setupContentImageView];
        }
    }
    
    
}
/**
 创建视频播放界面
 */
-(void)setupWebView
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    webView = [[WKWebView alloc] initWithFrame:_modelFrame.activityContentPicUrlRect configuration:config];
    webView.scrollView.scrollEnabled = NO;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_model.vu]]];
    [self.contentView addSubview:webView];
}

/**
 创建内容
 */
-(void)setupContentLabel
{
    contentLabel = [[UILabel alloc] initWithFrame:_modelFrame.activityContentRect];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [UIColor lightGrayColor];
    contentLabel.text = _model.activityContent;
    [self.contentView addSubview:contentLabel];
}

/**
 图片
 */
-(void)setupContentImageView
{
    contentImageView = [[UIImageView alloc] initWithFrame:_modelFrame.activityContentPicUrlRect];
    [contentImageView sd_setImageWithURL:[NSURL URLWithString:_model.activityContentPicUrl] placeholderImage:[UIImage imageNamed:@"photo"]];
    [self.contentView addSubview:contentImageView];
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
