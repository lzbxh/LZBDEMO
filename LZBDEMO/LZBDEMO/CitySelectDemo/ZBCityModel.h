//
//  ZBCityModel.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/16.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

//
#import <Foundation/Foundation.h>

@interface ZBCityModel : NSObject

@property(strong ,nonatomic)NSString *cityName;     //城市名

@property(strong ,nonatomic)NSString *cityID;       //城市ID（用于保存后端给来的cityID）

@property(strong ,nonatomic)NSString *titleHeader;  //拼音首字母

-(instancetype)initWithCityName:(NSString *)cityName;

@end
