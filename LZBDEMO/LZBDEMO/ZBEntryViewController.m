//
//  ZBEntryViewController.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/12.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#define CLASSNAMESTR @"className"
#define DEMONAMESTR  @"demoName"

#import "ZBEntryViewController.h"
#import "ContanctsViewController.h"

@interface ZBEntryViewController ()

@property(strong ,nonatomic)NSMutableArray<NSDictionary *> *demoArray;

@end

@implementation ZBEntryViewController

lazyLoad(NSMutableArray, demoArray);

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"LZBDemo"];
    
    //创建一个Demo，就在这添加一个
    //通讯录Demo
    NSString *contanctsDemoClassStr = NSStringFromClass([ContanctsViewController class]);
    NSString *contanctsDemoNameStr = [NSString stringWithFormat:@"通讯录Demo"];
    NSDictionary *dic = @{CLASSNAMESTR : contanctsDemoClassStr ,DEMONAMESTR : contanctsDemoNameStr};
    [self.demoArray addObject:dic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dic = self.demoArray[indexPath.row];
    cell.textLabel.text = dic[DEMONAMESTR];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.demoArray[indexPath.row];
    NSString *currentDemoClassStr = dic[CLASSNAMESTR];
    Class currentClass = NSClassFromString(currentDemoClassStr);
    UIViewController *currentDemoVC = [[currentClass alloc]init];
    [self.navigationController pushViewController:currentDemoVC animated:YES];
}

@end
