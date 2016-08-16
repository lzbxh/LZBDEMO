//
//  ContanctModel.m
//  Contances
//
//  Created by Amoson on 16/7/19.
//  Copyright © 2016年 Amoson. All rights reserved.
//

#import "ContanctModel.h"

@implementation ContanctModel

-(instancetype)initWithName:(NSString*)name phone:(NSString*)phone titleHeader:(NSString*)title{
    self = [super init];
    if (self) {
        _name = name;
        _phone = phone;
        _titleHeader = title;
    }
    return self;
}


@end
