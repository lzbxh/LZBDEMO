//
//  ZBRequestCustomer.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WARN_NETWORK_FAILE  @"请检查您的网络"
#define WARN_UNKNOW_FAILE   @"未知错误"
#define BASE_URL            @"http://test.mokooapp.com/"
#define RESULT_DATAS        @"data"

typedef void(^requestComplete) (BOOL succed, id obj);

@interface ZBRequestCustomer : NSObject

+(void)requestFlowWater:(NSMutableDictionary *)optionalParam pageNUM:(NSString *)page_num pageLINE:(NSString *)page_line complete:(requestComplete)_complete ;
+(void) requestBanner:(NSString *)userID complete:(requestComplete)_complete;

@end
