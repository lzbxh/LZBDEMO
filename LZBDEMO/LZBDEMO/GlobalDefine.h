//
//  GlobalDefine.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/12.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h

//==========常用宏定义放置在这个文件中==========

//屏幕宽高
#define ZBSCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define ZBSCREENWIDTH  [UIScreen mainScreen].bounds.size.width

//懒加载便利方法  仅用于初始化为 alloc init这种的
#define lazyLoad(__TYPE__ ,__INSTANCENAME__) \
-(__TYPE__ *)__INSTANCENAME__ { \
if (!_##__INSTANCENAME__) { \
_##__INSTANCENAME__ = [[__TYPE__ alloc]init]; \
} \
return _##__INSTANCENAME__; \
}

//随机颜色
#define RANDOMCOLOR [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1]

//根据图片名获得图片便利方法
#define GETIMAGEWITHNAME(__IMAGENAME__) [UIImage imageNamed:__IMAGENAME__]

//常用宏
#ifdef DEBUG
#define LOG(...) NSLog(__VA_ARGS__);
#define LOG_METHOD NSLog(@"%s", __func__);
#else
#define LOG(...);
#define LOG_METHOD;
#endif

#define WS(weakSelf)  __weak typeof(&*self)weakSelf = self

#define sizeWithText(text,attribute,maxSize) [text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size

#define RGBColor(r,g,b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#endif /* GlobalDefine_h */
