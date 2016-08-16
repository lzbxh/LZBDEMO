//
//  ZBEntryViewController.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/12.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBEntryViewController.h"
#import "ContanctsViewController.h"

@interface ZBEntryViewController ()

@property(strong ,nonatomic)NSMutableArray<NSString *> *demoArray;

@end

@implementation ZBEntryViewController

lazyLoad(NSMutableArray, demoArray);

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"LZBDemo"];
    
    //通讯录Demo
    NSString *contanctsDemoStr = NSStringFromClass([ContanctsViewController class]);
    [self.demoArray addObject:contanctsDemoStr];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.demoArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *currentDemoClassStr = self.demoArray[indexPath.row];
    Class currentClass = NSClassFromString(currentDemoClassStr);
    UIViewController *currentDemoVC = [[currentClass alloc]init];
    [self.navigationController pushViewController:currentDemoVC animated:YES];
}

@end
