//
//  ZBHomeRequest.m
//  LZBDEMO
//
//  Created by 刘智滨 on 16/8/30.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBHomeRequest.h"

@implementation ZBHomeRequest

-(instancetype)initRequestWithPageLine:(NSInteger)pageLine pageNum:(NSInteger)pageNum
{
    if (self = [super init]) {
        self.pageLine = pageLine;
        self.pageNum = pageNum;
    }
    return self;
}

- (NSString *)requestUrl {
    return HOME_API;
}
- (id)requestArgument {
    return @{
             @"page_num": [NSString stringWithFormat:@"%@",@(_pageNum)],
             @"page_line": [NSString stringWithFormat:@"%@",@(_pageLine)]
             };
}


@end
