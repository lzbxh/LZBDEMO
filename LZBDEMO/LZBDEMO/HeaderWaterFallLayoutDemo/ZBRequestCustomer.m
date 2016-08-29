//
//  ZBRequestCustomer.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBRequestCustomer.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ZBRequestCustomer

#pragma mark -首页-
//FlowWater
+(void)requestFlowWater:(NSMutableDictionary *)optionalParam
                pageNUM:(NSString *)page_num pageLINE:(NSString *)page_line
               complete:(requestComplete)_complete {
    if (page_num == nil) {
        
    } else {
        [optionalParam setObject:page_num forKey:@"page_num"];
    }
    
    if (page_line == nil) {
        
    } else {
        [optionalParam setObject:page_line forKey:@"page_line"];
    }
    
    
}

#pragma mark -banner图片-
+(void) requestBanner:(NSString *)userID complete:(requestComplete)_complete {
    
}

+(void)postRequestParameters:(NSDictionary *)dicParameters
                         api:(NSString *)_typeApi
            andLastInterFace:(NSString *)_interface
        analysisDataComplete:(requestComplete)complete {
    AFHTTPSessionManager *manager = [ZBRequestCustomer managerCustom];
    NSMutableString *strURL = [[NSMutableString alloc]initWithString:BASE_URL];
    if ([_typeApi isEqualToString:@"Api"]) {
        [strURL appendString:@"Api/"];
    } else if ([_typeApi isEqualToString:@"HomeApi"]) {
        [strURL appendString:@"HomeApi/"];
    }
    
    [strURL appendString:[NSString stringWithFormat:@"%@/" ,_interface]];
    
    //状态栏转转显示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [manager POST:strURL parameters:dicParameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL successed = [ZBRequestCustomer errorSolution:responseObject];
        complete(successed ,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(NO ,WARN_NETWORK_FAILE);
    }];
}

+(AFHTTPSessionManager *)managerCustom {
    
    AFHTTPSessionManager   *manager    = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval   = 6;
    
    return manager;
}

+(BOOL)errorSolution:(id)responseObject {
    //数据data中没有error参数
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    BOOL successed = YES;
    //    if ([dicdatas isKindOfClass:[NSDictionary class]]) {
    //        NSString    *strError   = [dicdatas drObjectForKey:@"error"];
    //        if (![NSString isEmptyString:strError]) {
    //            succed = NO;
    //        }
    //    }

    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        //                NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        //                NSString    *status = [responseObject objectForKey:@"status"];
        //                if (![status isEqualToString:@"1"]) {
        //                    succed = NO;
        //                }
    }
    return successed;
}

+(NSMutableDictionary *)baseOption {
    NSMutableDictionary *dicBase = [[NSMutableDictionary alloc]init];
    return dicBase;
}

+(NSMutableDictionary *)userIdOption {
    NSMutableDictionary *dicBase = [[NSMutableDictionary alloc]init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [dicBase setObject:[userDefaults objectForKey:@"user_id"] forKey:@"user_id"];
    return dicBase;
}

+(NSString *)md5HexDigest:(NSString *)str {
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str ,(CC_LONG)strlen(original_str) ,result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X" ,result[i]];
    }
    return [hash lowercaseString];
}

@end
