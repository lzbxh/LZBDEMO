//
//  ZBLocationManager.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/17.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

typedef void(^LocationSever)(BOOL isUserCanLocation , NSString * pro ,NSString * area ,NSString * city);

#import <Foundation/Foundation.h>

@interface ZBLocationManager : NSObject

+(instancetype)shareInstance;

-(void)startLocationSeverWithBlock:(LocationSever)block;

-(void)stopLocationSever;

@end
