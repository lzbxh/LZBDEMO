//
//  ZBBaseRequest.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBBaseRequest.h"
#import "ZBNetWorkPrivate.h"
#import "ZBNetWorkAgent.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ZBBaseRequest

/******** 以下方法由子类继承来覆盖默认值 ********/
/// 请求成功的回调
- (void)requestCompleteFilter{}

/// 请求失败的回调
- (void)requestFailedFilter{}

/// 请求的URL
- (NSString *)requestUrl {
    return @"";
}

/// 请求的CdnURL
- (NSString *)cdnUrl {
    return @"";
}

/// 请求的BaseURL
- (NSString *)baseUrl {
    return @"";
}

/// 请求的连接超时时间，默认为60秒
- (NSTimeInterval)requestTimeoutInterval {
    return 60;
}

/// 请求的参数列表
- (id)requestArgument {
    return nil;
}

/// 用于在cache结果，计算cache文件名时，忽略掉一些指定的参数
- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    return argument;
}

/// Http请求的方法
- (NetWorkRequestMethod)requestMethod {
    return NetWorkRequestMethodPost;
}

/// 请求的SerializerType
- (NetWorkSerializerType)requestSerializerType {
    return NetWorkSerializerTypeHttp;
}

/// 请求的Server用户名和密码
- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

/// 在HTTP报头添加的自定义参数
- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

/// 构建自定义的UrlRequest，
/// 若这个方法返回非nil对象，会忽略requestUrl, requestArgument, requestMethod, requestSerializerType
- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

/// 是否使用CDN的host地址
- (BOOL)useCDN {
    return NO;
}

/// 用于检查JSON是否合法的对象
- (id)jsonValidator {
    return nil;
}

/// 用于检查Status Code是否正常的方法
- (BOOL)statusCodeValidator {
    //    NSInteger statusCode = [self responseStatusCode];
    //    if (statusCode >= 200 && statusCode <=299) {
    //        return YES;
    //    } else {
    //        return NO;
    //    }

    return YES;
}

/// 当POST的内容带有文件等富文本时使用
- (AFConstructingBlock)constructingBodyBlock {
    return nil;
}
/******** 以上方法由子类继承来覆盖默认值 ********/

- (NSString *)resumableDownloadPath {
    return nil;
}

-(void)start {
    [self toggleAccessoriesWillStartCallBack];
    [[ZBNetWorkAgent shareInstance]addRequest:self];        //使用代理类执行某种操作
}

-(void)stop {
    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [[ZBNetWorkAgent shareInstance]cancelRequest:self];
    [self toggleAccessoriesDidStopCallBack];
}

-(void)clearCompletionBlock {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

-(void)startWithCompletionBlockWithSuccess:(RequestCompletionBlock)success
                                   failure:(RequestCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

-(void)setCompletionBlockWithSuccess:(RequestCompletionBlock)success
                             failure:(RequestCompletionBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

-(id)responseJSONObject {
    return self.requestDataTask.response;
}

-(void)addAccessory:(id<RequestAccescory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}

@end
























