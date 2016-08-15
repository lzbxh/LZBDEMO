//
//  ZBTableViewController.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/12.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBBaseViewController.h"

@interface ZBTableViewController : ZBBaseViewController<UITableViewDelegate ,UITableViewDataSource>

@property(strong ,nonatomic)UITableView *tableView;

@end
