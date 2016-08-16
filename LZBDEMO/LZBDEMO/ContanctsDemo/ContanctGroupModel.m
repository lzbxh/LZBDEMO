//
//  ContanctGroupModel.m
//  Contances
//
//  Created by Amoson on 16/7/19.
//  Copyright © 2016年 Amoson. All rights reserved.
//

#import "ContanctGroupModel.h"
#import "ContanctModel.h"


@implementation ContanctGroupModel

+ (instancetype)getGroupsWithArray:(NSMutableArray*)dataArray groupTitle:(NSString*)title
{
    NSMutableArray *tempArray = [NSMutableArray array];
    ContanctGroupModel *group = [[ContanctGroupModel alloc] init];
    for (ContanctModel *model in dataArray)
    {
        if ([model.titleHeader isEqualToString:title])
        {
            
            [tempArray addObject:model];
        }
    }
    group.groupTitle = title;
    group.array = tempArray;
    return group;
}


@end
