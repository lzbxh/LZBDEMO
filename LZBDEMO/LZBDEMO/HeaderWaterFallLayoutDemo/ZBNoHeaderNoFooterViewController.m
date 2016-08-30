//
//  ZBNoHeaderNoFooterViewController.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#define KFileName @"ZBNoHeaderNoFooterViewController.plist"

static NSString* const WaterfallCellIdentifier = @"WaterfallCell";
static NSString* const WaterfallHeaderIdentifier = @"WaterfallHeader";

#import "ZBNoHeaderNoFooterViewController.h"
#import "ZBStickHeaderWaterFallLayout.h"
#import "MJExtension.h"
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "ZBBannerModel.h"
#import "MBProgressHUD.h"
#import "ZBHomePageHeadView.h"
#import "ZBHomePageCollectionViewCell.h"
#import "BaseRequest.h"
#import "ZBHomeModel.h"
#import "ZBBannerModel.h"
#import "UIView+SDExtension.h"
#import "ZBHomeRequest.h"
#import "ZBHomeBannerRequest.h"

@interface ZBNoHeaderNoFooterViewController ()<UICollectionViewDataSource ,UICollectionViewDelegate ,UIScrollViewDelegate ,ZBStickHeaderWaterFallLayoutDelegate> {
    NSInteger _showPage;
    ZBHomePageHeadView *_headView;
}

@property(strong ,nonatomic)UIScrollView *baseScrollView;
@property(strong ,nonatomic)UICollectionView *collectionView;
@property(strong ,nonatomic)NSMutableArray *shops;
@property(strong ,nonatomic)NSMutableArray *banners;
@property(strong ,nonatomic)NSMutableDictionary *optionalParam;

@end

@implementation ZBNoHeaderNoFooterViewController

lazyLoad(NSMutableArray, banners)
lazyLoad(NSMutableArray, shops)
lazyLoad(NSMutableDictionary, optionalParam)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI {
    [self setTitle:NSStringFromClass([self class])];
    /*返回*/
    UIButton  * backBut = [[UIButton   alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBut addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //    [backBut setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    [backBut setTitle:@"返回" forState:UIControlStateNormal];
    [backBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBut setImageEdgeInsets:UIEdgeInsetsMake(10, 6, 10, 14)];
    [self setNavigationBarLeftButton:backBut];
    
    [self initCollectionView];
    [self initRefresh];
    [self initData];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//初始化ColllectionView
-(void)initCollectionView {
    ZBStickHeaderWaterFallLayout *layout = [[ZBStickHeaderWaterFallLayout alloc]init];
    layout.delegate = self;
    layout.isStickyHeader = YES;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, Content_Y, ZBSCREENWIDTH, Content_Height) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZBHomePageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:WaterfallCellIdentifier];
    
    [self.collectionView registerClass:[ZBHomePageHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WaterfallHeaderIdentifier];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _showPage++;
        NSString *page = [NSString stringWithFormat:@"%ld" ,(long)_showPage];
        [self requestHomePageList:page refreshType:@"footer"];
    }];
}

//初始化刷新控件
-(void)initRefresh
{
    UIImage *imgR1 = [UIImage imageNamed:@"shuaxin1"];
    
    UIImage *imgR2 = [UIImage imageNamed:@"shuaxin2"];
    
    //    UIImage *imgR3 = [UIImage imageNamed:@"cameras_3"];
    
    NSArray *reFreshone = [NSArray arrayWithObjects:imgR1, nil];
    
    NSArray *reFreshtwo = [NSArray arrayWithObjects:imgR2, nil];
    
    NSArray *reFreshthree = [NSArray arrayWithObjects:imgR1,imgR2, nil];
    
    MJRefreshGifHeader  *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [self requestHomePageList:@"1" refreshType:@"header"];
        
    }];
    
    [header setImages:reFreshone forState:MJRefreshStateIdle];
    
    [header setImages:reFreshtwo forState:MJRefreshStatePulling];
    [header setImages:reFreshthree duration:0.5 forState:MJRefreshStateRefreshing];
    //    [header setImages:reFreshthree forState:MJRefreshStateRefreshing];
    
    header.lastUpdatedTimeLabel.hidden  = YES;
    
    //    header.stateLabel.hidden            = YES;
    
    self.collectionView.mj_header   = header;
}

//获得文件路径
-(NSString *)dataFilePath{
    //检索Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);//备注1
    NSString *documentsDirectory = [paths objectAtIndex:0];//备注2
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",KFileName]];
}

-(void)initData{
    NSString *filePath = [self dataFilePath];
    NSLog(@"filePath=%@",filePath);
    
    //从文件中读取数据，首先判断文件是否存在
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        //        NSArray *array = [[NSArray alloc]initWithContentsOfFile:filePath];
        //因为直接写入不成功，所以序列化一下,这里反序列化取出
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        for (int i =0; i<[array count]; i++) {
            [_shops addObject:[ZBHomeModel initHomeModelWithDict:array[i]]];
            //                        ShowCell *cell = [[ShowCell alloc]initShowCell];
            //                        [_allCells addObject:cell];
        }
        //                    }if (showPage%2 ==0) {
        //                        [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
        //                    }
        
        //先加载缓存数据
        [self.collectionView reloadData];
    }
    //后加载新数据
    [self.collectionView.mj_header performSelector:@selector(beginRefreshing) withObject:nil];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -collectionViewDataSource & collectionViewDelegate-

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger itemCount;
    if (section ==0) {
        if (self.shops.count ==0) {
            itemCount = 1;
        }else
        {
            itemCount = self.shops.count;
        }
        
        
    }
    return itemCount;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        ZBHomePageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:WaterfallCellIdentifier forIndexPath:indexPath];
        //            cell.backgroundColor = listBgColor;
        if (indexPath.item < self.shops.count) {
            cell.shop = self.shops[indexPath.item];
        } else {
            cell.shop = nil;
        }
//        UITapGestureRecognizer *personalGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageGesture:)];
        //            personalGesture.cancelsTouchesInView = NO;
        cell.markImageView.userInteractionEnabled = YES;
//        [cell.markImageView addGestureRecognizer:personalGesture];
        return cell;
        
    }
    return nil;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -END_collectionViewDataSource & collectionViewDelegate_END-

#pragma mark -请求-

-(void)requestHomePageList:(NSString *)page refreshType:(NSString *)type {
    ZBHomeRequest *homeRequest = [[ZBHomeRequest alloc]initRequestWithPageLine:10 pageNum:[page integerValue]];
    [homeRequest startWithCompletionBlockWithSuccess:^(__kindof BaseRequest *request, id obj) {
        LOG(@"%@" ,obj);
        if ([obj objectForKey:@"data"] == [NSNull null]) {
            if ([page isEqualToString:@"1"]) {
                [_shops removeAllObjects];
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView reloadData];
                return ;
            } else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"就这么多了";
                hud.margin = 10.0f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                [self.collectionView.mj_footer endRefreshing];
                return;
            }
        }
        
        NSArray *dataArray = [obj objectForKey:@"data"];
        NSString *status = [NSString stringWithFormat:@"%@" ,[obj objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            if ([page isEqualToString:@"1"]) {
                [_shops removeAllObjects];
                _showPage = 1;
            }
            for (int i = 0; i < [dataArray count]; i++) {
                [_shops addObject:[ZBHomeModel initHomeModelWithDict:dataArray[i]]];
            }
            
            if ([type isEqualToString:@"header"]) {
                [self.collectionView.mj_header endRefreshing];
            } else if ([type isEqualToString:@"footer"]) {
                [self.collectionView.mj_footer endRefreshing];
            }
            
            [self.collectionView reloadData];
        }
    } failure:^(__kindof BaseRequest *request, id obj) {
        if (self.view.superview) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"网络不给力";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
        
        if ([type isEqualToString:@"header"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView.mj_header endRefreshing];
            });
        } else if ([type isEqualToString:@"footer"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView.mj_footer endRefreshing];
            });
        }
    }];
}
#pragma mark -END_请求_END-

#pragma mark -ZBStickHeaderWaterFallLayoutDelegate-
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(ZBStickHeaderWaterFallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight;
    if (indexPath.section ==0) {
        if (self.shops.count ==0) {
            cellHeight = ZBSCREENHEIGHT - 64;
        }else
        {
            ZBHomeModel * shop;
            
            //        if (indexPach.item ==nil) {
            //            shop = self.shops[0];
            //
            //        }else
            //        {
            shop = self.shops[indexPath.item];
            
            //        }
            
            //        cell.s
            
            cellHeight =  shop.height/shop.width*(ZBSCREENWIDTH/2-7.5);
        }
        
        
        
    }
    return cellHeight;
}


- (CGFloat)collectionView:(nonnull UICollectionView *)collectionView
                   layout:(nonnull ZBStickHeaderWaterFallLayout *)collectionViewLayout
    widthForItemInSection:( NSInteger )section
{
    
    return (ZBSCREENWIDTH-15)/2;
    
}

#pragma mark -END_ZBStickHeaderWaterFallLayoutDelegate_END-

@end




















