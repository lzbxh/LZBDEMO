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
    _nameLabelWidthConstraint.constant = ZBSCREENWIDTH/2 -50 -38 -7.5;
    _leadingNameLableConstraint.constant = -(ZBSCREENWIDTH/2 -50 -38 -7.5) -38;
    _nameLabelConstraint.constant = -8;
    _locationIconConstraint.constant = -27;
    _locationNameConstraint.constant = -32;
    _shop = shop;
    self.vImageView.hidden = YES;
    [self.shopImage sd_setImageWithURL:[NSURL URLWithString:_shop.model_img] placeholderImage:[UIImage imageNamed:@"pic_loading.pdf"]];
    //    [self insertColorGradientByUIImageView:self.shopImage];
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.contentMode =UIViewContentModeScaleAspectFill;
//    self.shopName.text = _shop.city;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_shop.user_img] placeholderImage:[UIImage imageNamed:@"head.pdf"]];
    [self.shopImage addSubview:self.avatarImageView];
    if ([_shop.is_verify isEqualToString:@"1"]) {
        self.vImageView.hidden = NO;
        
    }
    [self.shopImage addSubview:self.vImageView];
    [self.nameLabel setText:_shop.nick_name];
    [self.shopImage addSubview:self.nameLabel];
    [self.shopImage addSubview:self.locationImageView];
    [self.locationLabel setText:_shop.city];
    [self.shopImage addSubview:self.locationLabel];
}

@end
