//
//  ZBHomeModel.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBHomeModel.h"

@implementation ZBHomeModel

+(instancetype)initHomeModelWithDict:(NSDictionary *)dict
{
    ZBHomeModel *model = [[self alloc]init];
    [model mj_setKeyValues:dict];
    return model;
}

@end
