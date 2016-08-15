//
//  ZBNavigationController.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/12.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#define ZBOFFSETFLOAT        0.65        //拉伸系数
#define ZBOFFSETDISTANCE     100         //最小回弹距离

#import "ZBNavigationController.h"

@interface ZBNavigationController()

@property(assign ,nonatomic)CGPoint         mStartPoint;
//给截屏的那个View垫着的
@property(strong ,nonatomic)UIImageView     *mLastScreenShotView;
//初始化的时候是个纯黑的view，上面添加了mLastScreenShotView
@property(strong ,nonatomic)UIView          *mBgView;
//截屏，就是把当前屏幕装入数组中
@property(strong ,nonatomic)NSMutableArray  *mScreenShots;

@property(assign ,nonatomic)BOOL            mIsMoving;

@end

@implementation ZBNavigationController

lazyLoad(NSMutableArray, mScreenShots);

-(instancetype)init {
    if (self = [super init]) {
        self.isDragBack = YES;      //默认支持右滑返回
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    //做个阴影效果
    self.view.layer.shadowOffset = CGSizeMake(0, 10);
    self.view.layer.shadowOpacity = 0.8;
    self.view.layer.shadowRadius = 10;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didHandlePanGesture:)];
    //避免手势误操作，要等到没有控件响应了才使用这个手势
    [panGR delaysTouchesBegan];
    [self.view addGestureRecognizer:panGR];
}

-(void)initViews {
    if (!self.mBgView) {
        self.mBgView = [[UIView alloc]initWithFrame:self.view.bounds];
        self.mBgView.backgroundColor = [UIColor blackColor];
        //这个superview是UIWindow
//        NSLog(@"self.view.superview:%@" ,self.view.superview);
        [self.view.superview insertSubview:self.mBgView belowSubview:self.view];
    }
    self.mBgView.hidden = NO;
    if (self.mLastScreenShotView) {
        [self.mLastScreenShotView removeFromSuperview];
    }
    //取出最后一张截屏，刷新截图，并放置在底部
    UIImage *lastScreenShot = [self.mScreenShots lastObject];
    self.mLastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
    self.mLastScreenShotView.frame = (CGRect){-(ZBSCREENWIDTH * ZBOFFSETFLOAT) ,0 ,ZBSCREENWIDTH ,ZBSCREENHEIGHT};
    [self.mBgView addSubview:self.mLastScreenShotView];
}

//设置状态栏风格
-(UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

//========push========
//重写push方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        [self.mScreenShots addObject:[self capture]];
    }
    [super pushViewController:viewController animated:animated];
}

//转场动画
-(void)pushAnimation:(UIViewController *)viewController {
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.2];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [super pushViewController:viewController animated:NO];
    [self.view.layer addAnimation:animation forKey:nil];
}

//========pop========
//重写pop方法
-(UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (animated) {
        [self popAnimation];
        return nil;
    }else {
        return [super popViewControllerAnimated:animated];
    }
}

-(void)popAnimation {
    if (self.viewControllers.count == 1) {
        return;
    }
    [self initViews];
    [UIView animateWithDuration:0.4 animations:^{
        [self doMoveViewWithX:ZBSCREENWIDTH];
    } completion:^(BOOL finished) {
        [self completionPanBackAnimation];
    }];
}

//截屏
-(UIImage *)capture {
    UIGraphicsBeginImageContextWithOptions(self.view.superview.bounds.size, self.view.superview.opaque, 0.0);
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark ------UIPanGRRecognizer------
-(void)didHandlePanGesture:(UIPanGestureRecognizer *)recoginzer {
    if (self.viewControllers.count <= 1 && !self.isDragBack) { return; }
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication] keyWindow]];
    CGFloat offsetX = touchPoint.x - self.mStartPoint.x;
//    NSLog(@"offsetX:%f" ,offsetX);
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        [self initViews];
        self.mIsMoving = YES;
        self.mStartPoint = touchPoint;
        offsetX = 0;
    }
    if (recoginzer.state == UIGestureRecognizerStateEnded) {        //滑动结束
        if (offsetX > ZBOFFSETDISTANCE) {        //大于最小回弹距离，做动画
            [UIView animateWithDuration:0.3 animations:^{
                [self doMoveViewWithX:ZBSCREENWIDTH];
            } completion:^(BOOL finished) {
                [self completionPanBackAnimation];
                self.mIsMoving = NO;
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                [self doMoveViewWithX:0];
            } completion:^(BOOL finished) {
                self.mIsMoving = NO;
                self.mBgView.hidden = YES;
            }];
        }
        self.mIsMoving = NO;
    }
    
    if (recoginzer.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.3 animations:^{
            [self doMoveViewWithX:0];
        } completion:^(BOOL finished) {
            self.mIsMoving = NO;
            self.mBgView.hidden = YES;
        }];
    }
    
    if (self.mIsMoving) {
        [self doMoveViewWithX:offsetX];
    }
}
#pragma mark ------UIPanGRRecognizer------

-(void)doMoveViewWithX:(CGFloat)x {
    x = x > ZBSCREENWIDTH ? ZBSCREENWIDTH : x;
    x = x < 0 ? 0 : x;
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    self.mLastScreenShotView.frame = (CGRect){-(ZBSCREENWIDTH * ZBOFFSETFLOAT) + x * ZBOFFSETFLOAT ,0 ,ZBSCREENWIDTH ,ZBSCREENHEIGHT};
}

-(void)completionPanBackAnimation {
    [self.mScreenShots removeLastObject];
    [super popViewControllerAnimated:NO];
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    self.view.frame = frame;
    self.mBgView.hidden = YES;
}

@end


























