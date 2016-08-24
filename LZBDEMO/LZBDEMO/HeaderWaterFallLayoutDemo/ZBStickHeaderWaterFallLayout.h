//
//  ZBStickHeaderWaterFallLayout.h
//  LZBDEMO
//
//  Created by 刘智滨 on 16/8/24.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBStickHeaderWaterFallLayout;

typedef NS_ENUM(NSUInteger ,ZBStickHeaderAlignment) {
    ZBStickHeaderAlignmentLeft = 0,
    ZBStickHeaderAlignmentCenter
};

@protocol ZBStickHeaderWaterFallLayoutDelegate <NSObject>

//返回所在section的每一个item的width
- (CGFloat)collectionView:(nonnull UICollectionView *)collectionView
                  layout:(nonnull ZBStickHeaderWaterFallLayout *)collectionViewLayout
   widthForItemInSection:(NSInteger)section;

//返回所在indexpath的每个item的height
-(CGFloat)collectionView:(nonnull UICollectionView *)collectionView
                  layout:(nonnull ZBStickHeaderWaterFallLayout *)collectionViewLayout
heightForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;

@optional

//返回所在indexPath的header的height
-(CGFloat)collectionView:(nonnull UICollectionView *)collectionView
                  layout:(nonnull ZBStickHeaderWaterFallLayout *)collectionViewLayout
heightForHeaderAtIndexPath:(nonnull NSIndexPath *)indexPath;

//返回所在indexPath的footer的height
-(CGFloat)collectionView:(nonnull UICollectionView *)collectionView
                  layout:(nonnull UICollectionViewLayout *)collectionViewLayout
heightForFooterAtIndexPath:(nonnull NSIndexPath *)indexPath;

//返回所在section与上一个section的间距
-(CGFloat)collectionView:(nonnull UICollectionView *)collectionView
                  layout:(nonnull ZBStickHeaderWaterFallLayout *)collectionViewLayout
            topInSection:(NSInteger)section;

//返回所在section与下一个section的间距
-(CGFloat)collectionView:(nonnull UICollectionView *)collectionView
                  layout:(nonnull ZBStickHeaderWaterFallLayout *)collectionViewLayout
         bottomInSection:(NSInteger)section;

//返回所在section的header停留时与顶部的距离（如果设置isTopForHeader = YES，则距离会叠加）
-(CGFloat)collectionView:(nonnull UICollectionView *)collectionView
                  layout:(nonnull ZBStickHeaderWaterFallLayout *)collectionViewLayout
    headerToTopInSection:(NSInteger)section;

@end

@interface ZBStickHeaderWaterFallLayout : UICollectionViewLayout

@property (nonatomic, assign,nonnull)  id<ZBStickHeaderWaterFallLayoutDelegate> delegate;

//使用UINavgationController 和 UITabbarViewController并设置一些属性时。
//collectionview的展示视图的坐标y会变得很奇怪，那就在此修正,默认64
@property(assign ,nonatomic)CGFloat fixTop;

//对齐方式一个是靠最左边，一个是靠中间
@property(nonatomic,assign) ZBStickHeaderAlignment headAlignment;

//是否设置sectionHeader停留,默认YES
@property (nonatomic) BOOL isStickyHeader;

//section停留的位置是否包括原来设置的top，默认NO
@property (nonatomic) BOOL isTopForHeader;

@property (nonatomic) BOOL isStickyFooter;

@end














