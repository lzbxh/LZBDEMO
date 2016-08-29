//
//  ZBNetWorkConfig.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZBBaseRequest;

//url采集器
@protocol ZBUrlFilterProtocol <NSObject>

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(ZBBaseRequest *)request;

@end

@interface ZBNetWorkConfig : NSObject

@property(strong ,nonatomic)NSString *baseUrl;
@property(strong ,nonatomic ,readonly)NSArray *urlFilters;
@property(strong ,nonatomic)AFSecurityPolicy *securityPolicy;

+(ZBNetWorkConfig *)shareInstance;

//填充采集器
-(void)addUrlFilter:(id<ZBUrlFilterProtocol>)filter;

@end
