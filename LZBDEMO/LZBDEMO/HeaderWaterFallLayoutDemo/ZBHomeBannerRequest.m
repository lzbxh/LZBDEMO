//
//  ZBHomeBannerRequest.m
//  LZBDEMO
//
//  Created by 刘智滨 on 16/8/30.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBHomeBannerRequest.h"

@implementation ZBHomeBannerRequest

-(instancetype)initRequestWithUserId:(NSString *)userId
{
    if (self = [super init]) {
        self.userId = userId;
    }
    return self;
}

- (NSString *)requestUrl {
    return HOME_BANNER_API;
}

@end
