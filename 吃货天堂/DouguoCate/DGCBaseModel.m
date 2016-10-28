//
//  DGCBaseModel.m
//  DouguoCate
//
//  Created by qianfeng on 16/10/5.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "DGCBaseModel.h"

@implementation DGCBaseModel

+(id)modelWithDictionary:(NSDictionary *)dictionary
{
    DGCBaseModel *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dictionary];
    
    return model;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
