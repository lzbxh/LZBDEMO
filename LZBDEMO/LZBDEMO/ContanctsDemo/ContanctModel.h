//
//  ContanctModel.h
//  Contances
//
//  Created by Amoson on 16/7/19.
//  Copyright © 2016年 Amoson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContanctModel : NSObject

@property(nonatomic,strong)NSString * name;

@property(nonatomic,strong)NSString * phone;

@property(nonatomic,strong)NSString * titleHeader;

-(instancetype)initWithName:(NSString*)name phone:(NSString*)phone titleHeader:(NSString*)title;

@end
