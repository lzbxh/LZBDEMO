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
#import "ContanctsViewController.h"     //通讯录选择器
#import "ZBCitySelectViewController.h"  //城市选择器
#import "ZBClipImageViewController.h"   //图片剪切

@interface ZBEntryViewController ()

@property(strong ,nonatomic)NSMutableArray<NSDictionary *> *demoArray;

@end

@implementation ZBEntryViewController

lazyLoad(NSMutableArray, demoArray);

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"LZBDemo"];
    
    //TODO:创建一个Demo，就在这添加一个
    //通讯录Demo
    NSString *contanctsDemoClassStr = NSStringFromClass([ContanctsViewController class]);
    NSString *contanctsDemoNameStr  = [NSString stringWithFormat:@"通讯录Demo"];
    NSDictionary *contanctsDemoDic  = @{CLASSNAMESTR : contanctsDemoClassStr ,DEMONAMESTR : contanctsDemoNameStr};
    [self.demoArray addObject:contanctsDemoDic];
    
    //城市选择器
    NSString *citySelectDemoClassStr = NSStringFromClass([ZBCitySelectViewController class]);
    NSString *citySelectDemoNameStr  = [NSString stringWithFormat:@"城市选择器Demo"];
    NSDictionary *citySelectDemoDic  = @{CLASSNAMESTR : citySelectDemoClassStr ,DEMONAMESTR : citySelectDemoNameStr};
    [self.demoArray addObject:citySelectDemoDic];
    
    //图片剪切
    NSString *clipImgDemoClassStr = NSStringFromClass([ZBClipImageViewController class]);
    NSString *clipImgDemoNameStr  = [NSString stringWithFormat:@"图片剪切Demo"];
    NSDictionary *clipImgDemoDic  = @{CLASSNAMESTR : clipImgDemoClassStr ,DEMONAMESTR : clipImgDemoNameStr};
    [self.demoArray addObject:clipImgDemoDic];
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
