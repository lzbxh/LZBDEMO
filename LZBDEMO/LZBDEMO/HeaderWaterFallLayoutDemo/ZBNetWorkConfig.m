//
//  ZBNetWorkConfig.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBNetWorkConfig.h"

@implementation ZBNetWorkConfig {
    NSMutableArray *_urlFilters;
}

+(ZBNetWorkConfig *)shareInstance {
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc]init];
    });
    return shareInstance;
}

-(instancetype)init {
    if (self = [super init]) {
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
        _urlFilters = [NSMutableArray array];
    }
    return self;
}

-(void)addUrlFilter:(id<ZBUrlFilterProtocol>)filter {
    [_urlFilters addObject:filter];
}

-(NSArray *)urlFilters {
    return [_urlFilters copy];
}

@end
