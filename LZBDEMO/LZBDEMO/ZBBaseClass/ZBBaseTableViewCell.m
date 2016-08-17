//
//  ZBBaseTableViewCell.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/17.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBBaseTableViewCell.h"

@implementation ZBBaseTableViewCell

-(instancetype)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initUI];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    //TODO
}

@end
