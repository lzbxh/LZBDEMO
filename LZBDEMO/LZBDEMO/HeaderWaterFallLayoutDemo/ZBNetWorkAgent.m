//
//  ZBNetWorkAgent.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBNetWorkAgent.h"
#import "ZBBaseRequest.h"
#import "ZBNetWorkConfig.h"
#import "ZBNetWorkPrivate.h"

@implementation ZBNetWorkAgent {
    AFHTTPSessionManager *_manager;
    ZBNetWorkConfig *_config;
    NSMutableDictionary *_requestsRecord;
}

+(ZBNetWorkAgent *)shareInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

-(instancetype)init {
    if (self = [super init]) {
        _config = [ZBNetWorkConfig shareInstance];
        _requestsRecord = [NSMutableDictionary dictionary];
        _manager = [AFHTTPSessionManager manager];
        _manager.operationQueue.maxConcurrentOperationCount = 4;
        _manager.securityPolicy = _config.securityPolicy;
    }
    return self;
}

//添加一个请求
-(void)addRequest:(ZBBaseRequest *)request {
    NetWorkRequestMethod method = [request requestMethod];
    NSString *url = [self buildRequestUrl:request];
    id param = request.requestArgument;
    AFConstructingBlock constructingBlock = [request constructingBodyBlock];
    
    //请求序列化
    if (request.requestSerializerType == NetWorkSerializerTypeHttp) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == NetWorkSerializerTypeJson) {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    _manager.requestSerializer.timeoutInterval =[request requestTimeoutInterval];
    
    //if api need server username and password
    NSArray *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
    
    //将用户名与密码拼接到 httpField Authorization 中
    if (authorizationHeaderFieldArray) {
        [_manager.requestSerializer setAuthorizationHeaderFieldWithUsername:(NSString *)authorizationHeaderFieldArray.firstObject
    password:(NSString *)authorizationHeaderFieldArray.lastObject];
    }
    
    //如果请求需要一些自定义的头部参数
    NSDictionary *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil) {
        for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
            id value = headerFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [_manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            } else {
                LOG(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }
    
    // if api build custom url request
    //自定义的url请求
    NSURLRequest *customerUrlRequest = [request buildCustomUrlRequest];
    if (customerUrlRequest) {       //自定义的请求
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:customerUrlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [self handleRequestResult:task responseObject:response];
        }];
        request.requestDataTask = task;
    }else {                         //没有自定义请求
        if (method == NetWorkRequestMethodGet) {        //GET
            request.requestDataTask = [_manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleRequestResult:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleRequestResult:task responseObject:error];
            }];
        } else if (method == NetWorkRequestMethodPost) {    //POST
            if (constructingBlock != nil) {
                request.requestDataTask = [_manager POST:url parameters:param constructingBodyWithBlock:constructingBlock progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleRequestResult:task responseObject:responseObject];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleRequestResult:task responseObject:error];
                }];
            } else {
                request.requestDataTask = [_manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleRequestResult:task responseObject:responseObject];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleRequestResult:task responseObject:error];
                }];
            }

        } else if (method == NetWorkRequestMethodHead) {
            request.requestDataTask = [_manager HEAD:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task) {
                [self handleRequestResult:task responseObject:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleRequestResult:task responseObject:error];
            }];
        } else if (method == NetWorkRequestMethodPut) {
            request.requestDataTask = [_manager PUT:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleRequestResult:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleRequestResult:task responseObject:error];
            }];
        } else if (method == NetWorkRequestMethodDelete) {
            request.requestDataTask = [_manager DELETE:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleRequestResult:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleRequestResult:task responseObject:error];
            }];
        } else if (method == NetWorkRequestMethodPatch) {
            request.requestDataTask = [_manager PATCH:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleRequestResult:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleRequestResult:task responseObject:error];
            }];
        } else {
            LOG(@"Error, unsupport method type");
            return;
        }
    }
    [self addOperation:request];
}

//取消一个请求
-(void)cancelRequest:(ZBBaseRequest *)request {
    [request.requestDataTask cancel];
    [self removeOperation:request.requestDataTask];
    [request clearCompletionBlock];
}

//取消所有请求
-(void)cancelAllRequests {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        ZBBaseRequest *request = copyRecord[key];
        [request stop];
    }
}

//根据request和networkConfig构建url
-(NSString *)buildRequestUrl:(ZBBaseRequest *)request {
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    
    //filter url ???
    NSArray *filters = [_config urlFilters];
    for (id<ZBUrlFilterProtocol> f in filters) {
        detailUrl = [f filterUrl:detailUrl withRequest:request];
    }
    
    NSString *baseUrl;
    if ([request baseUrl].length > 0) {
        baseUrl = [request baseUrl];
    } else {
        baseUrl = [_config baseUrl];
    }
    
    return [NSString stringWithFormat:@"%@%@" ,baseUrl ,detailUrl];
}

//请求结果操作
-(void)handleRequestResult:(NSURLSessionDataTask *)task responseObject:(id _Nullable)responseObject {
    NSString *key = [self requestHashKey:task];
    ZBBaseRequest *request = _requestsRecord[key];
    if (request) {
        BOOL succeed = [self checkResult:request];
        if (succeed) {      //请求成功
            //请求即将结束
            [request toggleAccessoriesWillStopCallBack];
            //请求成功回调
            [request requestCompleteFilter];
            if (request.delegate) {
                [request.delegate requestFinished:request];
            }
            if (request.successCompletionBlock) {
                request.successCompletionBlock(request ,responseObject);
            }
            [request toggleAccessoriesDidStopCallBack];
        }
    } else {                //请求失败
        [request toggleAccessoriesWillStopCallBack];
        [request requestFailedFilter];
        if (request.delegate) {
            [request.delegate requestFailed:request];
        }
        
        if (request.failureCompletionBlock) {
            request.failureCompletionBlock(request ,responseObject);
        }
        
        [request toggleAccessoriesDidStopCallBack];
    }
    [self removeOperation:task];
    [request clearCompletionBlock];
}

//得到请求的id
-(NSString *)requestHashKey:(NSURLSessionTask *)task {
    NSString *key = [NSString stringWithFormat:@"%lu" ,(unsigned long)[task taskIdentifier]];
    return key;
}

//检测结果是否合法
-(BOOL)checkResult:(ZBBaseRequest *)request {
    BOOL result = [request statusCodeValidator];        //得到状态码
    if (!result) {
        return result;
    }
    
    id validator = [request jsonValidator];     //检查json是否合法
    if (validator != nil) {
        id json = [request responseJSONObject];
        result = [ZBNetWorkPrivate checkJson:json withValidator:validator];
    }
    return result;
}

//添加一个task
-(void)addOperation:(ZBBaseRequest *)request {
    if (request.requestDataTask != nil) {
        NSString *key = [self requestHashKey:request.requestDataTask];
        @synchronized (self) {
            _requestsRecord[key] = request;
        }
    }
}

//移除一个task
-(void)removeOperation:(NSURLSessionTask *)task {
    NSString *key = [self requestHashKey:task];
    @synchronized (self) {
        [_requestsRecord removeObjectForKey:key];
    }
}

@end
















