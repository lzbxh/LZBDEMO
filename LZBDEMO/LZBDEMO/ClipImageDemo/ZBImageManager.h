//
//  ZBImageManager.h
//  LZBDEMO
//
//  Created by 刘智滨 on 16/8/19.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

typedef NS_ENUM(NSUInteger ,IMGSTATE) {
    IMGSTATE_FIX,                   //正好合适
    IMGSTATE_LRSPACE_IMGBIG,        //左右留边，图片较大
    IMGSTATE_LRSPACE_IMGSMALL,      //左右留边，图片较小
    IMGSTATE_TBSPACE_IMGBIG,        //上下留边，图片较大
    IMGSTATE_TBSPACE_IMGSMALL       //上下留边，图片较小
};

#import <Foundation/Foundation.h>

@interface ZBImageManager : NSObject

-(instancetype)initWithImage:(UIImage *)img andViewSize:(CGSize)size;

@property(strong ,nonatomic)UIImage *oriImg;

//图片状态
@property(assign ,nonatomic)IMGSTATE imgState;

//scale == 1 时图片四边相对于view的空白区域，可能为0
@property(assign ,nonatomic)CGFloat topSpace;
@property(assign ,nonatomic)CGFloat leftSpace;
@property(assign ,nonatomic)CGFloat bottomSpace;
@property(assign ,nonatomic)CGFloat rightSpace;

//图片相对于IV的缩放比例
@property(assign ,nonatomic)CGFloat widthZoom;
@property(assign ,nonatomic)CGFloat heightZoom;
@property(assign ,nonatomic)CGFloat minZoom;
@property(assign ,nonatomic)CGFloat imgWHScale;

@end
