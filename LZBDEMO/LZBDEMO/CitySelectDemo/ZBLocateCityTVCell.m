//
//  ZBLocateCityTVCell.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/17.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBLocateCityTVCell.h"

@interface ZBLocateCityTVCell ()

@property(strong ,nonatomic)UILabel  *titleLabel;
@property(strong ,nonatomic)UIButton *currentCityBtn;

@end

@implementation ZBLocateCityTVCell

lazyLoad(UILabel, titleLabel)
lazyLoad(UIButton, currentCityBtn)

-(void)initUI {
    self.titleLabel.text = @"当前定位城市：";
    self.currentCityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.currentCityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.currentCityBtn];
}

-(void)setLocateCityName:(NSString *)locateCityName {
    _locateCityName = locateCityName;
    [self.currentCityBtn setTitle:locateCityName forState:UIControlStateNormal];
    [self layoutIfNeeded];
}

-(void)layoutSubviews {
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.frame = CGRectMake(0, 0, [self.titleLabel.text obtainWidthWithFixHeight:44 andFontSize:14], 44);
    self.currentCityBtn.frame = CGRectMake([self.titleLabel.text obtainWidthWithFixHeight:44 andFontSize:14], 0, [self.locateCityName obtainWidthWithFixHeight:44 andFontSize:14], 44);
}

@end
