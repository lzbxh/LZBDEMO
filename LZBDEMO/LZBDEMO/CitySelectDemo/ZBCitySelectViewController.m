//
//  ZBCitySelectViewController.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/16.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#define SEARCHBARHEIGHT 44

#import "ZBCitySelectViewController.h"
#import "NSMutableArray+FilterElement.h"
#import "POAPinyin.h"
#import "pinyin.h"

@interface ZBCitySelectViewController ()<UISearchBarDelegate ,UITableViewDataSource ,UITableViewDelegate>

@property(strong ,nonatomic)UISearchBar *searchBar;
#warning 等我完成功能了再优化
@property(strong ,nonatomic)UISearchDisplayController *searchDisplayer;
@property(strong ,nonatomic)UITableView *tableView;
@property(strong ,nonatomic)NSMutableArray *sectionIndexs;

//所有城市model Array
@property(strong ,nonatomic)NSMutableArray *allCityDataArray;
//根据城市拼音首字母分组过后的城市dic
@property(strong ,nonatomic)NSMutableDictionary *groupCityDic;
 //tableView数据源
@property(strong ,nonatomic)NSMutableArray *dataArray;
//搜索结果
@property(strong ,nonatomic)NSMutableArray *searchDataArray;

@end

@implementation ZBCitySelectViewController

lazyLoad(UITableView, tableView)
lazyLoad(UISearchBar, searchBar)
lazyLoad(NSMutableArray, allCityDataArray)
lazyLoad(NSMutableArray, dataArray)
lazyLoad(NSMutableArray, searchDataArray)
lazyLoad(NSMutableDictionary, groupCityDic)

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"城市选择器Demo"];
    NSArray *cityDemoData = [NSArray arrayWithObjects:@"北京市", @"天津市" ,@"石家庄市" ,@"唐山市" ,@"秦皇岛市" ,@"邯郸市" ,@"邢台市" ,@"保定市" ,@"张家口市" ,@"承德市" ,@"沧州市" ,@"廊坊市" ,@"衡水市" ,@"太原市" ,@"大同市" ,@"阳泉市" ,@"长治市" ,@"晋城市" ,@"朔州市" ,@"晋中市" ,@"运城市" ,@"忻州市" ,@"临汾市" ,@"吕梁市" ,@"呼和浩特市" ,@"包头市" ,nil];
    for (NSString *cityName in cityDemoData) {
        ZBCityModel *model = [[ZBCityModel alloc]initWithCityName:cityName];
        LOG(@"%@" ,model.cityName);
        LOG(@"%@" ,model.titleHeader);
        [self.allCityDataArray addObject:model];
    }
    [self filterHeader];
}

-(void)initUI {
    //tableView
    self.tableView.frame = CGRectMake(0, Content_Y, ZBSCREENWIDTH, Content_Height);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //searchBar
    self.searchBar.frame = CGRectMake(0, 0, ZBSCREENWIDTH, SEARCHBARHEIGHT);
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    self.tableView.tableHeaderView = self.searchBar;
    
    //searchDisplayer
    self.searchDisplayer = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayer.searchResultsDataSource = self;
    self.searchDisplayer.searchResultsDelegate = self;
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchDataArray.count;
    }
    ZBCityGroupModel *groupModel = self.dataArray[section];
    return groupModel.cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    //搜索
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        ZBCityModel *model = self.searchDataArray[indexPath.row];
        cell.textLabel.text = model.cityName;
        return cell;
    }
    
    ZBCityGroupModel *groupModel = self.dataArray[indexPath.section];
    ZBCityModel *cityModel = groupModel.cityArray[indexPath.row];
    cell.textLabel.text = cityModel.cityName;
    
    return cell;
}

//分区相关
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0.0f;
    }
    return 20.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }

    // 背景图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    // 显示分区的 label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width-40, 20)];
    label.text = self.sectionIndexs[section];
    label.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:label];
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZBCityModel *model = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        model = self.searchDataArray[indexPath.row];
        
    }else{
        ZBCityGroupModel *group = self.dataArray[indexPath.section];
        model = group.cityArray[indexPath.row];
    }
    
    LOG(@"当前选择的城市：%@" ,model.cityName);

}


//添加索引列
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //搜索框不需要索引
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }

    return self.sectionIndexs;
}

//索引列点击事件
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    NSLog(@"===%@  ===%ld",title,(long)index);
    
    //点击索引，列表跳转到对应索引的行
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //弹出首字母提示
    //[self showLetter:title ];
    
    return index;
}

#pragma mark ----UISearchBarDelegate----
//搜索框相关
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    NSLog(@"搜索Begin");
    //调整整个tableview的位置
    [self hideNavigationBar:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.frame = CGRectMake(0, 0, ZBSCREENWIDTH, ZBSCREENHEIGHT);
    }];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
//    NSLog(@"搜索End");
    //还原整个tableview的位置
    [self hideNavigationBar:NO];
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.frame = CGRectMake(0, Content_Y, ZBSCREENWIDTH, Content_Height);
    }];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    LOG(@"searchText:%@" ,searchText);
    [self searchWithString:searchText];
}

-(void)searchWithString:(NSString *)searchString {
    [self.searchDataArray removeAllObjects];
    [self.tableView reloadData];

    if ([searchString length] != 0) {
        //1.按照输入字符得到拼音首字母
        NSString *firstCharat = [self getfirstCharact:searchString];
 
        //2.取出分组dic中对应的array
        NSArray *cityArray = [self.groupCityDic objectForKey:firstCharat];
        
        LOG(@"=======根据拼音首字母得到的结果=======");
        for (ZBCityModel *model in cityArray) {
            LOG(@"%@" ,model.cityName);
        }
        LOG(@"=======根据拼音首字母得到的结果=======");
        
        //3.根据汉字过滤结果
        if (cityArray) {
            for (int i = 0; i<cityArray.count; i++) {
                ZBCityModel * model = cityArray[i];
                
                if ([self searchResult:model.cityName searchText:searchString]) {
                    
                    [self.searchDataArray addObject:model];
                    [self.tableView reloadData];
                    
                }else{
                    
                    //按拼音搜索
                    NSString *string = @"";
                    NSString *firststring=@"";
                    for (int i = 0; i < [model.cityName length]; i++)
                    {
                        if([string length] < 1)
                            string = [NSString stringWithFormat:@"%@",
                                      [POAPinyin quickConvert:[model.cityName substringWithRange:NSMakeRange(i,1)]]];
                        else
                            string = [NSString stringWithFormat:@"%@%@",string,
                                      [POAPinyin quickConvert:[model.cityName substringWithRange:NSMakeRange(i,1)]]];
                        if([firststring length] < 1){
                            
                            firststring = [[NSString stringWithFormat:@"%c",
                                            pinyinFirstLetter([model.cityName characterAtIndex:i])]lowercaseString];
                        }else{
                            if ([model.cityName characterAtIndex:i]!=' ') {
                                firststring = [[NSString stringWithFormat:@"%@%c",firststring,
                                                pinyinFirstLetter([model.cityName characterAtIndex:i])]lowercaseString];
                            }
                            
                        }
                    }
                    if ([self searchResult:string searchText:searchString]
                        ||[self searchResult:firststring searchText:searchString])
                    {
                        [self.searchDataArray addObject:model];
                        NSLog(@"121212====%@",self.searchDataArray);
                        [self.tableView reloadData];
                        
                        
                    }
                }
            }
        }
    }
    
}

-(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
    NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame)
        return YES;
    else
        return NO;
}


#pragma mark ----UISearchBarDelegate----

//得到汉字的拼音首字母
-(NSString * )getfirstCharact:(NSString*)str{
    //将OC字符串转化为C字符串
    CFStringRef stringRef = CFStringCreateWithCString( kCFAllocatorDefault, [str UTF8String], kCFStringEncodingUTF8);
    //将C不可变字符串转化为可变字符串
    CFMutableStringRef mutableStringRef = CFStringCreateMutableCopy(NULL, 0, stringRef);
    //将汉字转化为拼音
    CFStringTransform(mutableStringRef, NULL, kCFStringTransformMandarinLatin, NO);
    //去掉拼音中的声调
    CFStringTransform(mutableStringRef, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSString *mutableString = (__bridge NSString *)mutableStringRef;
    NSString *firstCharacter = [[mutableString substringToIndex:1] uppercaseString];
    unichar ch = [firstCharacter characterAtIndex:0];
    //解析不出来的用#处理
    if (!((ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z') )) {
        return @"#";
    }
    return firstCharacter;
}

#pragma mark ------创建索引------
-(void)filterHeader {
    self.sectionIndexs = [NSMutableArray array];
    //将所有城市首字母放入索引数组中
    for (ZBCityModel *model in self.allCityDataArray) {
        [self.sectionIndexs addObject:model.titleHeader];
    }
    //过滤掉相同元素
    [self.sectionIndexs filterTheSameElement];
    
    //对索引数组进行排序
    // 数组排序
    [self.sectionIndexs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *string1 = obj1;
        NSString *string2 = obj2;
        return [string1 compare:string2];
    }];
    
    //对城市进行分组操作
    for (NSString *key in self.sectionIndexs) {
        [self.groupCityDic setObject:[NSMutableArray array] forKey:key];
    }
    for (ZBCityModel *model in self.allCityDataArray) {
        [[self.groupCityDic objectForKey:model.titleHeader]addObject:model];
    }

    //组装groupModel
    for (NSString *string in self.sectionIndexs) {
        NSArray *cityArray = [self.groupCityDic objectForKey:string];
        ZBCityGroupModel *group = [[ZBCityGroupModel alloc]initWithGroupWithCityArray:cityArray andGroupTitle:string];
        if ([group.titleHeader isEqualToString:@"#"]) {     //出现#号的数据放置到最前面
            [self.dataArray insertObject:group atIndex:0];
        }else {
            [self.dataArray addObject:group];
        }
    }
    
    //刷新tableView
    [self.tableView reloadData];
}
#pragma mark ------创建索引------

@end






