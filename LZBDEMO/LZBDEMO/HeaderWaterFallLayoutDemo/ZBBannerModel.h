//
//  ZBBannerModel.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBBannerModel : NSObject

//"banner_id":"banner广告ID",
//"img_url":"图片链接",
//"type":"广告类型",  1.网页广告  2.推荐活动  3.推荐模特卡
//（类型为1时跳转到网页，为2时跳转到活动 ，为3时跳转到模特卡）
//"url":"网页广告url链接",
//"id":"活动或模特卡对应ID",
//"form_user_id":"活动或模特卡对应用户ID",
//title 网页头部的title

@property (nonatomic,copy) NSString *banner_id;         //banner广告ID
@property (nonatomic,copy) NSString *img_url;           //图片链接
@property (nonatomic,copy) NSString *type;              //广告类型
@property (nonatomic,copy) NSString *url;               //网页广告url链接
@property (nonatomic,copy) NSString *form_id;           //活动或模特卡对应ID
@property (nonatomic,copy) NSString *form_user_id;      //活动或模特卡对应用户ID
@property (nonatomic,copy) NSString *title;             //网页头部的title

+(instancetype)initBannerWithDict:(NSDictionary *)dict;


@end
