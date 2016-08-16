//
//  ZBCityGroupModel.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/16.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

//用于将city分组的model
#import <Foundation/Foundation.h>
#import "ZBCityModel.h"

@interface ZBCityGroupModel : NSObject

@property(strong ,nonatomic)NSArray<ZBCityGroupModel *> *cityArray;     //该组下的city

@property(strong ,nonatomic)NSString *titleHeader;                      //拼音首字母

-(instancetype)initWithGroupWithCityArray:(NSArray *)cityArray andGroupTitle:(NSString *)groupTitle;

@end
