//
//  ZBTableViewController.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/12.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBTableViewController.h"

@implementation ZBTableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = CGRectMake(0, Content_Y, ZBSCREENWIDTH, Content_Height);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.navigationController setNavigationBarHidden:YES];     //默认隐藏系统自带导航栏，用自定义的导航替换
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

@end
