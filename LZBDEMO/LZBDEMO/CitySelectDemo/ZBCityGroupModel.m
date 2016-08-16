//
//  ZBCityGroupModel.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/16.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBCityGroupModel.h"

@implementation ZBCityGroupModel

-(instancetype)initWithGroupWithCityArray:(NSArray *)cityArray andGroupTitle:(NSString *)groupTitle {
    if (self = [super init]) {
        _cityArray = [cityArray copy];
        _titleHeader = groupTitle;
    }
    return self;
}

@end
