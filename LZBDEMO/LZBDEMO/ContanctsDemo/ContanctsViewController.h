//
//  ContanctsViewController.h
//  Contances
//
//  Created by Amoson on 16/7/19.
//  Copyright © 2016年 Amoson. All rights reserved.
//

#import "ZBBaseViewController.h"
#import "ContanctModel.h"

typedef void(^ContanctBlock)(ContanctModel * model);
@interface ContanctsViewController : ZBBaseViewController

@property(nonatomic,strong)ContanctBlock contanctBlock;

@end
