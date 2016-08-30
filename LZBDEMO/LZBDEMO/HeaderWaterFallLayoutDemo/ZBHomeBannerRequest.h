//
//  ZBHomeBannerRequest.h
//  LZBDEMO
//
//  Created by 刘智滨 on 16/8/30.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBBaseRequest.h"

@interface ZBHomeBannerRequest : ZBBaseRequest

@property (nonatomic,copy)NSString *userId;

-(instancetype)initRequestWithUserId:(NSString *)userId;

@end
