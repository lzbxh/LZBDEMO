//
//  ZBNetWorkAgent.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseRequest;

//请求代理类，用于真正执行操作
@interface ZBNetWorkAgent : NSObject

+(ZBNetWorkAgent *)shareInstance;

//添加并开始一个请求
-(void)addRequest:(BaseRequest *)request;

//取消并停止一个请求
-(void)cancelRequest:(BaseRequest *)request;

//取消并停止所有请求
-(void)cancelAllRequests;

//根据request和networkConfig构建url
-(NSString *)buildRequestUrl:(BaseRequest *)request;

@end
