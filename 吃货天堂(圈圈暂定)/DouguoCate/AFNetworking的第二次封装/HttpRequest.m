//
//  HttpRequest.m
//  02-爱限免首页
//
//  Created by vera on 16/9/2.
//  Copyright © 2016年 deli. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"

@implementation HttpRequest

/**
 *  get请求
 *
 *  @param urlstring url
 *  @param paramters 参数
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)GET:(NSString *)urlstring paramters:(NSDictionary *)paramters success:(HttpRequestSuccessCallBack)success failure:(HttpRequestFailureCallBack)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //发送异步请求
    /**
     发送异步请求：
     参数1：url
     参数2：参数
     参数3：进度回调
     参数4：请求成功的回调
     参数5：请求失败的回调
     */
    [manager GET:urlstring parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success)
        {
            //成功的回调
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure)
        {
            //失败回调
            failure(error);
        }
    }];
    
}
+ (void)Post:(NSString *)urlString paramters:(id)paramters dictionary:(NSDictionary*)headerRequest success:(HttpRequestSuccessCallBack)success failure:(HttpRequestFailureCallBack)failure
{
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求方法，默认 request.HTTPMethod = @"GET";
    mutableRequest.HTTPMethod = @"POST";
    
    if (headerRequest != nil) {
        
        for (NSString *key in headerRequest)
        {
            [mutableRequest addValue:headerRequest[key] forHTTPHeaderField:key];
        }  
    }
    
    //超时时间，默认60s
    mutableRequest.timeoutInterval = 20;
    
    //添加参数,注意：post请求，参数放到请求体(httpBody)里面
    mutableRequest.HTTPBody = [paramters dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:mutableRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data == nil) {
            
            return ;
        }
        
        id  resopject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (success)
        {
            //成功的回调
            success(resopject);
        }
        
        if (connectionError) {
            
            if (failure)
            {
                //失败的回调
                failure(connectionError);
            }
        }
    }];
}
@end
