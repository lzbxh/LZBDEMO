//
//  ZBBaseRequest.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBBaseRequest.h"

@implementation ZBBaseRequest

-(id)requestArgument {
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"1.0" forKey:@"version"];
    return [self generateData:postDict];
}

-(id)generateData:(NSDictionary *)dict {
    return dict;
}

-(NetWorkRequestMethod)requestMethod {
    return NetWorkRequestMethodPost;
}

@end
