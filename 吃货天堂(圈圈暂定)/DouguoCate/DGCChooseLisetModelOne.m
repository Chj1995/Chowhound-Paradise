//
//  DGCChooseLisetModelOne.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCChooseLisetModelOne.h"

@implementation DGCChooseLisetModelOne

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        
        self.desc = value;
        
    }
}

@end
