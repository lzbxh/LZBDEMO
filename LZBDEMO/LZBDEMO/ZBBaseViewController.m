//
//  ZBBaseViewController.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/12.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBBaseViewController.h"
#import "ZBNavigationController.h"

@implementation ZBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarBackgroundColor:RGBAColor(255, 255, 255, 0.7f)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];     //默认隐藏系统自带导航栏，用自定义的导航替换
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)loadView{
    [super loadView];
    _barView = [[ZBNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, NavigationBarWidth, NavigationBarHeight)];
    _barView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_barView];
}

-(void)setTitle:(NSString *)title{
    [_barView setTitle:title];
}

- (void)setTitleWithAttributedString:(NSAttributedString*)title
{
    [_barView setTitleWithAttributedString:title];
}

-(void)setNavigationBarTitleView:(UIView *)view{
    [_barView setTitleView:view];
}

-(UIView *)getNavigationBarTitleView
{
    return [_barView getTitleView];
}

-(void)setNavigationBarLeftButton:(UIButton *)button{
    [_barView setLeftButton:button];
}

-(void)setNavigationBarRightButton:(UIButton *)button{
    [_barView setRightButton:button];
}

-(UIButton *)getNavigationBarRightButton
{
    return [_barView getRightButton];
}

-(void)setNavigationBarLeftView:(UIView *)view{
    [_barView setLeftView:view];
}

-(void)setNavigationBarRightView:(UIView *)view{
    [_barView setRightView:view];
}

-(void)hideNavigationBar:(BOOL)hide{
    _barView.hidden = hide;
}

-(void)hideNavigationBar:(BOOL)hide animation:(BOOL)animation{
    if (animation)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1];
        if (hide)
        {
            [_barView setAlpha:0.0f];
        }
        else
        {
            [_barView setAlpha:1];
        }
        [UIView commitAnimations];
    }
    else
    {
        _barView.hidden = hide;
        [_barView setAlpha:1];
    }
}

// 是否可右滑返回
- (void)navigationCanDragBack:(BOOL)bCanDragBack
{
    if (self.navigationController)
    {
        ((ZBNavigationController *)(self.navigationController)).isDragBack = bCanDragBack;
    }
}

-(void)setNavigationBarBackgroundColor:(UIColor*)color
{
    _barView.backgroundColor = color;
}

- (void)bringBarViewToFront
{
    [self.view bringSubviewToFront:_barView];
}

-(void)setNavigationBarAlph:(CGFloat)alph
{
    [_barView setAlpha:alph];
}


-(void)setTabbarHidden:(BOOL)hide{
    [self.navigationController.tabBarController.tabBar setHidden:hide];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
