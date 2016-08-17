//
//  ZBBaseViewController.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/12.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBNavigationBarView.h"

@interface ZBBaseViewController : UIViewController

@property(strong ,nonatomic)ZBNavigationBarView *barView;

-(void)setTitle:(NSString *)title;
- (void)setTitleWithAttributedString:(NSAttributedString*)title;

-(void)setNavigationBarLeftButton:(UIButton *)button;

-(UIButton *)getNavigationBarRightButton;
-(void)setNavigationBarRightButton:(UIButton *)button;

-(void)setNavigationBarLeftView:(UIView *)view;

-(void)setNavigationBarRightView:(UIView *)view;

-(void)setNavigationBarTitleView:(UIView *)view;

-(UIView *)getNavigationBarTitleView;

-(void)hideNavigationBar:(BOOL)hide;

-(void)setNavigationBarBackgroundColor:(UIColor*)color;

-(void)hideNavigationBar:(BOOL)hide animation:(BOOL)animation;

// 是否可右滑返回
- (void)navigationCanDragBack:(BOOL)bCanDragBack;

- (void)bringBarViewToFront;

-(void)setNavigationBarAlph:(CGFloat)alph;

-(void)setTabbarHidden:(BOOL)hide;

//子类复写点
//初始化UI
-(void)initUI;

@end
