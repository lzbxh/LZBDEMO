//
//  ZBClipImageViewController.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/18.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBClipImageViewController.h"
#import "ZBImageCliper.h"

@interface ZBClipImageViewController ()<UIScrollViewDelegate>

@property(strong ,nonatomic)ZBImageCliper *imgCliper;
@property(strong ,nonatomic)UIButton *clipBtn;
@property(strong ,nonatomic)UIImageView *resultImgIV;

@end

@implementation ZBClipImageViewController

lazyLoad(ZBImageCliper, imgCliper)
lazyLoad(UIButton, clipBtn)
lazyLoad(UIImageView, resultImgIV)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initUI {
    [self.view addSubview:self.imgCliper];
    CGRect frame = self.imgCliper.frame;
    frame.origin.y = Content_Y;
    self.imgCliper.frame = frame;
    self.imgCliper.backgroundColor = [UIColor lightGrayColor];
    
    self.clipBtn.frame = CGRectMake(0, ZBSCREENHEIGHT - 50, ZBSCREENWIDTH, 50);
    self.clipBtn.backgroundColor = [UIColor lightGrayColor];
    [self.clipBtn setTitle:@"截图" forState:UIControlStateNormal];
    [self.clipBtn addTarget:self action:@selector(clipAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clipBtn];
    
    self.resultImgIV.frame = CGRectMake(0, self.imgCliper.frame.origin.y + self.imgCliper.frame.size.height + 10, ZBSCREENWIDTH, self.imgCliper.frame.size.height);
    self.resultImgIV.contentMode = UIViewContentModeScaleAspectFit;
    self.resultImgIV.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.resultImgIV];
}

-(void)clipAction {
    UIImage *result = [self.imgCliper clipImage];
    self.resultImgIV.image = result;
}

@end
