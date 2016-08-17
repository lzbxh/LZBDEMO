//
//  NSString+ZBNSString.h
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/17.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(ZBNSString)

//规则A
//根据时间戳获取日期字符串
//时间显示规则:
//1天内显示具体时间 XX：XX
//昨天的显示：昨天XX:XX
//当年的显示：月[月]日 XX:XX
//跨年的显示：年[年]月[月]日[日]
+(NSString *)getDateStringWithTimeStampString:(NSString *)timeStampStr;

//规则B : 当天:hh:mm   昨天：昨天 hh:mm  隔天:月[月] 日[日] hh:mm 跨年:年[年] 月[月] 日[日] hh:mm
+(NSString *)getBRuleDateStringWithTimeStampString:(NSString *)timeStampStr;

//规则C : 年[年] 月[月] 日[日]
+(NSString *)getCRuleDateStringWithTimeStampString:(NSString *)timeStampStr;

//房源时间戳
+(NSString *)getReportHousingDateStringWithTimeStampString:(NSString *)timeStampStr;

//获取午夜时间 YYYY-MM-DD
+(NSString *)getDayStringWithTimeStampString:(NSString *)timeStampStr;

//获取今天的日期 YYYY-MM-DD
+(NSString *)getTodayString;

//获取设备型号和版本
+(void)getPlatform:(NSString **)platForm andDeviceVersion:(NSString **)deviceVersion;

//限定高度获得宽度
-(CGFloat)obtainWidthWithFixHeight:(CGFloat)height andFontSize:(CGFloat)fontSize;

//限定宽度获得高度
-(CGFloat)obtainHeightWithFixWidth:(CGFloat)width andFontSize:(CGFloat)fontSize;

@end
