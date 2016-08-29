//
//  ZBNoHeaderNoFooterViewController.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBNoHeaderNoFooterViewController.h"
#import "ZBStickHeaderWaterFallLayout.h"
#import "MJExtension.h"
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "ZBBannerModel.h"
#import "MBProgressHUD.h"
#import "ZBHomePageCollectionViewCell.h"
#import "ZBBaseRequest.h"

@interface ZBNoHeaderNoFooterViewController ()

@end

@implementation ZBNoHeaderNoFooterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:NSStringFromClass([self class])];
    /*返回*/
    UIButton  * backBut = [[UIButton   alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBut addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //    [backBut setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    [backBut setTitle:@"返回" forState:UIControlStateNormal];
    [backBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBut setImageEdgeInsets:UIEdgeInsetsMake(10, 6, 10, 14)];
    [self setNavigationBarLeftButton:backBut];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}


@end
