//
//  ZBHomeRequest.h
//  LZBDEMO
//
//  Created by 刘智滨 on 16/8/30.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBBaseRequest.h"

@interface ZBHomeRequest : ZBBaseRequest

@property (nonatomic,assign)NSInteger pageLine;
@property (nonatomic,assign)NSInteger pageNum;
-(instancetype)initRequestWithPageLine:(NSInteger )pageLine pageNum:(NSInteger )pageNum;

@end
