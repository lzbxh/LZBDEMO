//
//  ZBHomePageCollectionViewCell.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBHomePageCollectionViewCell.h"

@implementation ZBHomePageCollectionViewCell

-(instancetype)init {
    if (self = [super init]) {
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

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    self.backgroundColor = [UIColor lightGrayColor];
}

-(void)setShop:(ZBHomeModel *)shop {
    
}

@end
