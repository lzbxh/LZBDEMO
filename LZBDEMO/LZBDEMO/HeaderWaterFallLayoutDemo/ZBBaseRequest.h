//
//  ZBBaseRequest.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "BaseRequest.h"
#import "ZBURLMacro.h"

@interface ZBBaseRequest : BaseRequest

-(id)generateData:(NSDictionary *)dict;

@end
