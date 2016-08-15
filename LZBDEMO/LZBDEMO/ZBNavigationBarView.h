//
//  ZBNavigationBarView.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/12.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

//bar
#define NavigationBarColor [UIColor blackColor]
#define NavigationBarShadowColor [UIColor blackColor]
#define NavigationBarWidth [UIScreen mainScreen].bounds.size.width
#define NavigationBarHeight 64
#define NavigationTitleTextColor [UIColor blackColor]

#define NavigationBarTitleFont [UIFont systemFontOfSize:17]
#define NavigationBarTitleColor BlackCustomColor

#define Content_Y 64
#define Content_Height [[UIScreen mainScreen] bounds].size.height-64

#define TabBar_Height 50

#import <UIKit/UIKit.h>

@interface ZBNavigationBarView : UIView

-(void)setTitle:(NSString *)string;
-(void)setTitleWithAttributedString:(NSAttributedString*)string;//包含富文本的标题

-(void)setLeftButton:(UIButton *)button;

-(void)setRightButton:(UIButton *)button;
-(UIButton *)getRightButton;

-(void)setLeftView:(UIView *)view;

-(void)setRightView:(UIView *)view;

-(void)setTitleView:(UIView *)view;

-(UIView *)getTitleView;

-(void)isDisShadowLine:(BOOL)isDis;


@end
