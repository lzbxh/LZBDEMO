//
//  ZBWaterFallLayoutDemoViewController.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBWaterFallLayoutDemoViewController.h"
#import "ZBNoHeaderNoFooterViewController.h"

@interface ZBWaterFallLayoutDemoViewController ()

@property(strong ,nonatomic)NSMutableArray<NSString *> *demoArray;

@end

@implementation ZBWaterFallLayoutDemoViewController

lazyLoad(NSMutableArray, demoArray)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"WaterFallLayoutDemo"];
    /*返回*/
    UIButton  * backBut = [[UIButton   alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBut addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //    [backBut setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    [backBut setTitle:@"返回" forState:UIControlStateNormal];
    [backBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBut setImageEdgeInsets:UIEdgeInsetsMake(10, 6, 10, 14)];
    [self setNavigationBarLeftButton:backBut];
    
    [self.demoArray addObject:@"ZBNoHeaderNoFooterViewController"];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.demoArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectClassStr = self.demoArray[indexPath.row];
    Class selectClass = NSClassFromString(selectClassStr);
    ZBBaseViewController *selectVC = [[selectClass alloc]init];
    [self.navigationController pushViewController:selectVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
