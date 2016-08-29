//
//  ZBHomeModel.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBHomeModel : NSObject

@property (nonatomic,copy)NSString *user_id;            //用户ID
@property (nonatomic,copy)NSString *user_name;          //用户名
@property (nonatomic,copy)NSString *nick_name;          //用户昵称
@property (nonatomic,copy)NSString *user_img;           //用户头像
@property (nonatomic,copy)NSString *card_id;            //模特卡ID
@property (nonatomic,copy)NSString *model_img;          //图片链接
@property (nonatomic,assign)CGFloat width;              //图片宽度
@property (nonatomic,assign)CGFloat height;             //图片高度
@property (nonatomic,copy)NSString *city;               //城市
@property (nonatomic,copy)NSString *is_verify;          //是否实名认证 - 0.否 1.是
+(instancetype)initHomeModelWithDict:(NSDictionary *)dict;

//"user_id":"用户ID",
//"user_name":"用户名",
//"nick_name":"用户昵称",
//"user_img":"用户头像",
//"model_id":"模特卡ID",
//"model_img":"图片链接",
//"width":"图片宽度",
//"height":"图片高度",
//"city":"城市",
//"is_verify":"是否实名认证",  0.否   1.是

@end
