//
//  ContanctsViewController.m
//  Contances
//
//  Created by Amoson on 16/7/19.
//  Copyright © 2016年 Amoson. All rights reserved.
//

#import "ContanctsViewController.h"
#import <AddressBook/AddressBook.h>
#import "ContanctGroupModel.h"
#import "NSMutableArray+FilterElement.h"
#import "POAPinyin.h"
#import "pinyin.h"


@interface ContanctsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * contantDataArray;

@property(nonatomic,strong)NSMutableDictionary * contanctMutDic;

@property(nonatomic,strong)NSMutableArray * sectionIndexs;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)NSMutableArray * searchDataArray;


@property(nonatomic,strong)UILabel * countLable;

@property(nonatomic,strong)UISearchBar * searchBar;

@property(nonatomic,assign)BOOL isSearching;

@property(nonatomic,strong)NSMutableDictionary * phoneDic;

@property(nonatomic,strong)NSMutableDictionary * sectionDic;

@property(nonatomic,strong)UIActivityIndicatorView * activeView;


@end

@implementation ContanctsViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initNavgationBar];
    //加载所有联系人
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.countLable];
    [self.view addSubview:self.activeView];
    

    [self performSelector:@selector(loadAllContancts) withObject:nil];
    


}

-(void)initNavgationBar{
    [self setTitle:@"所有联系人"];
    /*返回*/
    UIButton  * backBut = [[UIButton   alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBut addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBut setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    [backBut setImageEdgeInsets:UIEdgeInsetsMake(10, 6, 10, 14)];
    [self setNavigationBarLeftButton:backBut];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableArray*)contantDataArray{
    if (!_contantDataArray) {
        _contantDataArray = [NSMutableArray array];
    }
    return _contantDataArray;
}

-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray*)searchDataArray{
    if (!_searchDataArray) {
        _searchDataArray = [NSMutableArray array];
    }
    return _searchDataArray;
}

-(NSMutableDictionary*)phoneDic{
    if (!_phoneDic) {
        _phoneDic = [NSMutableDictionary dictionary];
    }
    return _phoneDic;
}

-(NSMutableDictionary*)sectionDic{
    if (!_sectionDic) {
        _sectionDic = [NSMutableDictionary dictionary];
    }
    return _sectionDic;
}

-(UIActivityIndicatorView*)activeView{
    if (!_activeView) {
        _activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activeView.frame = CGRectMake(0, 0, 60, 60);
        _activeView.center = self.view.center;
        [_activeView startAnimating];
    }
    return _activeView;
}

-(UILabel*)countLable{
    if (!_countLable) {
        _countLable = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-55, [UIScreen mainScreen].bounds.size.width, 55)];
        _countLable.backgroundColor = [UIColor whiteColor];
        _countLable.textAlignment = NSTextAlignmentCenter;
        _countLable.font = [UIFont systemFontOfSize:15];
        _countLable.textColor = [UIColor lightGrayColor];
    }
    return _countLable;
}

-(UISearchBar*)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 64)];
        [_searchBar setPlaceholder:@"搜索"];
        _searchBar.delegate = self;
        
    }
    return _searchBar;
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64*2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64*2-55) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


-(void)loadAllContancts{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            [self copyAddressBook:addressBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        [self copyAddressBook:addressBook];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            NSLog(@"没有获取通讯录权限");
        });
    }
    if (addressBookRef) {
        CFRelease(addressBookRef);
    }
    
  
}

- (void)copyAddressBook:(ABAddressBookRef)myAddressBook{
    
    [_contantDataArray removeAllObjects];
    [_searchDataArray removeAllObjects];
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(myAddressBook);
    CFMutableArrayRef mresults=CFArrayCreateMutableCopy(kCFAllocatorDefault,
                                                        CFArrayGetCount(results),
                                                        results);
    //遍历所有联系人
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int k=0;k<CFArrayGetCount(mresults);k++) {
            
            ABRecordRef aPerson = CFArrayGetValueAtIndex(mresults, (CFIndex)k);
            ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(aPerson, kABPersonPhoneProperty);
            NSString *fullName = (__bridge NSString *)ABRecordCopyCompositeName(aPerson);
            
            for (int i = 0; i<ABMultiValueGetCount(phoneMulti); i++)
            {
                NSString *aPhone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i);
                
                
                NSLog(@"fullname:%@===firstS:%@",fullName,[self getfirstCharact:fullName]);
                
                NSString * firstCharact = [self getfirstCharact:fullName];
                ContanctModel * model = [[ContanctModel alloc]initWithName:fullName phone:aPhone titleHeader:firstCharact];
                [self.contantDataArray addObject:model];
                
                [self.phoneDic setObject:(__bridge id _Nonnull)(aPerson) forKey:[NSString stringWithFormat:@"%@",fullName]];
                NSLog(@"phoneDic:%@",_phoneDic);
            }
            
        }
        

        [self filterHeader:_contantDataArray];
    });

    
}

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
    if (!((ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z') )) {
        return @"#";
    }
    return firstCharacter;
}


-(void)filterHeader:(NSArray*)dataArray{
    self.sectionIndexs = [NSMutableArray array];
    NSMutableArray *tempArray = [NSMutableArray array];

    for (ContanctModel * model in self.contantDataArray) {
        
        [self.sectionIndexs addObject:model.titleHeader];
    }

    // 去除数组中相同的元素
    self.sectionIndexs = [self.sectionIndexs filterTheSameElement];
    // 数组排序
    [self.sectionIndexs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *string1 = obj1;
        NSString *string2 = obj2;
        return [string1 compare:string2];
    }];
    
    for (NSString * key in self.sectionIndexs) {
        [self.sectionDic setObject:[NSMutableArray array] forKey:key];
    }
    
    for (ContanctModel * model in  self.contantDataArray) {
        
        [[self.sectionDic objectForKey:model.titleHeader]addObject:model];

    }
    

    // 将排序号的首字母数组取出 分成一个个组模型 和组模型下边的一个个 item
    for (NSString *string in self.sectionIndexs) {
        ContanctGroupModel *group = [ContanctGroupModel getGroupsWithArray:self.contantDataArray groupTitle:string];
        if ([group.groupTitle isEqualToString:@"#"]) {
            // 默认 #开头的放在数组的最前边 后边才是 A-Z
            [tempArray insertObject:group atIndex:0];
        }else{
            [tempArray addObject:group];
        }
    }
    self.dataArray = [tempArray mutableCopy];

    
    
    NSLog(@"%@===%@",self.sectionIndexs,self.dataArray);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
     self.countLable.text = [NSString stringWithFormat:@"%ld位联系人",self.contantDataArray.count];
        [self.activeView stopAnimating];
    });


}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isSearching) {
        return 1;
    }
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSearching) {
        return self.searchDataArray.count;
    }
    ContanctGroupModel *group = self.dataArray[section];

    NSLog(@"groupArray:%@",group.array);
    return group.array.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FollwTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_isSearching) {
        ContanctModel * model = self.searchDataArray[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }
    ContanctGroupModel *group = self.dataArray[indexPath.section];
    ContanctModel *followM = group.array[indexPath.row];
    cell.textLabel.text  = followM.name;
    return cell;
}


- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    if (_isSearching) {
        return nil;
    }
    return self.sectionIndexs;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContanctModel *followM;
    if (_isSearching) {
        followM = self.searchDataArray[indexPath.row];

    }else{
        ContanctGroupModel *group = self.dataArray[indexPath.section];
        followM = group.array[indexPath.row];

    }
    NSLog(@"name==%@  phone==%@",followM.name,followM.phone);
    self.contanctBlock?self.contanctBlock(followM):nil;

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_isSearching) {
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isSearching) {
        return 0.1;
    }
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    [self searchWithString:searchText];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"取消");

    searchBar.text = @"";
    [self.searchDataArray removeAllObjects];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.countLable.hidden = NO;

    [searchBar resignFirstResponder];
    _isSearching = NO;
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];

    _isSearching = YES;
    self.countLable.hidden = YES;
    [self.tableView reloadData];
}


-(void)searchWithString:(NSString *)searchString
{
    [self.searchDataArray removeAllObjects];
    [self.tableView reloadData];
    NSString * regex        = @"(^[0-9]+$)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([searchString length]!=0) {
        if ([pred evaluateWithObject:searchString]) { //判断是否是数字
            NSArray *phones=[self.phoneDic allKeys];
            NSLog(@"phoneDic==%@,phoneKeys==%@",self.phoneDic,[self.phoneDic allKeys]);
            for (NSString *phone in phones) {
                if ([self searchResult:phone searchText:searchString]) {
                    ABRecordRef person=(__bridge ABRecordRef)([_phoneDic objectForKey:phone]);
                    
                    NSString *name=(__bridge NSString *)ABRecordCopyCompositeName(person);
                    ContanctModel * model = [[ContanctModel alloc]initWithName:name phone:phone titleHeader:@""];
                    [self.searchDataArray addObject:model];
                    NSLog(@"%@",self.searchDataArray);
                    [self.tableView reloadData];
                }
            }
        }
        else {
            
            NSString * firstCharat = [self getfirstCharact:searchString];
            NSArray * data = [self.sectionDic objectForKey:firstCharat];
            NSLog(@"firstCharat==%@ data ===%@",firstCharat,data);

            if (data) {
                for (int i = 0; i<data.count; i++) {
                    ContanctModel * model = data[i];
                   
                        if ([self searchResult:model.name searchText:searchString]) {
                            
                            [self.searchDataArray addObject:model];
                            [self.tableView reloadData];

                        }else{
                            
                            //按拼音搜索
                            NSString *string = @"";
                            NSString *firststring=@"";
                            for (int i = 0; i < [model.name length]; i++)
                            {
                                if([string length] < 1)
                                    string = [NSString stringWithFormat:@"%@",
                                              [POAPinyin quickConvert:[model.name substringWithRange:NSMakeRange(i,1)]]];
                                else
                                    string = [NSString stringWithFormat:@"%@%@",string,
                                              [POAPinyin quickConvert:[model.name substringWithRange:NSMakeRange(i,1)]]];
                                if([firststring length] < 1){
                                    
                                    firststring = [[NSString stringWithFormat:@"%c",
                                                   pinyinFirstLetter([model.name characterAtIndex:i])]lowercaseString];
                                }else{
                                    if ([model.name characterAtIndex:i]!=' ') {
                                        firststring = [[NSString stringWithFormat:@"%@%c",firststring,
                                                       pinyinFirstLetter([model.name characterAtIndex:i])]lowercaseString];
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
    }



-(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
    NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame)
        return YES;
    else
        return NO;
}


@end
