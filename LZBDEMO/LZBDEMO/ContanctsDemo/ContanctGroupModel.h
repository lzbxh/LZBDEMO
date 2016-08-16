//
//  ContanctGroupModel.h
//  Contances
//
//  Created by Amoson on 16/7/19.
//  Copyright © 2016年 Amoson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContanctGroupModel : NSObject

@property(nonatomic,strong)NSArray * array;

@property (nonatomic,copy) NSString *groupTitle;


+ (instancetype)getGroupsWithArray:(NSMutableArray*)dataArray groupTitle:(NSString*)title;

@end
