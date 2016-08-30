//
//  ZBHomePageCollectionViewCell.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBHomeModel.h"

@interface ZBHomePageCollectionViewCell : UICollectionViewCell

@property(strong ,nonatomic)ZBHomeModel *shop;

@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingNameLableConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationNameConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationIconConstraint;


@end
