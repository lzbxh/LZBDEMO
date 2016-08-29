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

@property (strong, nonatomic) UIImageView *shopImage;
@property (strong, nonatomic) UILabel *shopName;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIImageView *vImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *locationImageView;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UIImageView *markImageView;

@end
