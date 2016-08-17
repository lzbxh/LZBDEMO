//
//  NSString+ZBNSString.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/17.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "NSString+ZBNSString.h"
#import <sys/sysctl.h>

@implementation NSString(ZBNSString)

//时间显示规则:
//1天内显示具体时间 XX：XX
//昨天的显示：昨天XX:XX
//当年的显示：月[月]日 XX:XX
//跨年的显示：年[年]月[月]日[日]
+(NSString *)getDateStringWithTimeStampString:(NSString *)timeStampStr {
    if (timeStampStr == nil || [timeStampStr isEqualToString:@""]) {
        return @"";
    }
    //    NSLog(@"========%@" ,timeStampStr);
    //string转date
    NSInteger num = [timeStampStr integerValue] / 1000;
    if (num == 0) {
        return @"";
    }
    //    NSLog(@"===========%lu" ,num);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:num];      //服务器给北京时间
    NSDate *localDate = [self localDateWithDate:date];              //从系统中取的时间是+0时区的时间
    //    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    //    NSLog(@"%@" ,confromTimespStr);
    
    //NSDate转String
    //    NSDate *datenow = [NSDate date];
    //    NSString *timeSp = [NSString stringWithFormat:@"%d", (long)[datenow timeIntervalSince1970]];
    
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    today = [self localDateWithDate:today];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    
    //    NSLog(@"11111-%@,%@" ,[today description] ,[yesterday description]);
    //    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[localDate description] substringToIndex:10];
    //    NSLog(@"22222-%@,%@" ,dateString ,[date description]);
    
    if ([dateString isEqualToString:todayString])
    {
        [formatter setDateFormat:@"HH:mm"];
        NSString *timeStr = [formatter stringFromDate:date];
        return timeStr;
    } else if ([dateString isEqualToString:yesterdayString])
    {
        [formatter setDateFormat:@"HH:mm"];
        NSString *timeStr = [formatter stringFromDate:date];
        NSString *str = [NSString stringWithFormat:@"昨天 %@" ,timeStr];
        return str;
    }
    //    else if ([dateString isEqualToString:tomorrowString])
    //    {
    //        return @"明天";
    //    }
    //今年的
    else
    {
        //今年之内的
        [formatter setDateFormat:@"YYYY"];
        NSString *thisYearStr = [formatter stringFromDate:today];
        NSString *yearStr = [formatter stringFromDate:date];
        
        if ([thisYearStr isEqualToString:yearStr]) {        //今年
            [formatter setDateFormat:@"MM月dd日"];
        }else {     //前几年
            [formatter setDateFormat:@"YYYY年MM月dd日"];
        }
        NSString *timeStr = [formatter stringFromDate:date];
        return timeStr;
    }
}

//规则B : 当天:hh:mm   昨天：昨天 hh:mm  隔天:月[月] 日[日] hh:mm 跨年:年[年] 月[月] 日[日] hh:mm
+(NSString *)getBRuleDateStringWithTimeStampString:(NSString *)timeStampStr {
    if (timeStampStr == nil || [timeStampStr isEqualToString:@""]) {
        return @"";
    }
    NSInteger num = [timeStampStr integerValue] / 1000;
    if (num == 0) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:num];      //服务器给北京时间
    NSDate *localDate = [self localDateWithDate:date];              //从系统中取的时间是+0时区的时间
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    today = [self localDateWithDate:today];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    
    NSString * dateString = [[localDate description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        [formatter setDateFormat:@"HH:mm"];
        NSString *timeStr = [formatter stringFromDate:date];
        return timeStr;
    } else if ([dateString isEqualToString:yesterdayString]) {
        [formatter setDateFormat:@"HH:mm"];
        NSString *timeStr = [formatter stringFromDate:date];
        NSString *str = [NSString stringWithFormat:@"昨天 %@" ,timeStr];
        return str;
    } else {
        //今年之内的
        [formatter setDateFormat:@"YYYY"];
        NSString *thisYearStr = [formatter stringFromDate:today];
        NSString *yearStr = [formatter stringFromDate:date];
        
        if ([thisYearStr isEqualToString:yearStr]) {        //今年
            [formatter setDateFormat:@"MM月dd日 hh:mm"];
        }else {     //跨年
            [formatter setDateFormat:@"YYYY年MM月dd日 hh:mm"];
        }
        NSString *timeStr = [formatter stringFromDate:date];
        return timeStr;
    }
}

//规则C : 年[年] 月[月] 日[日]
+(NSString *)getCRuleDateStringWithTimeStampString:(NSString *)timeStampStr {
    if (timeStampStr == nil || [timeStampStr isEqualToString:@""]) {
        return @"";
    }
    NSInteger num = [timeStampStr integerValue] / 1000;
    if (num == 0) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:num];      //服务器给北京时间
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

//真实房源时间
+(NSString *)getReportHousingDateStringWithTimeStampString:(NSString *)timeStampStr {
    if (timeStampStr == nil || [timeStampStr isEqualToString:@""]) {
        return @"";
    }
    if ([timeStampStr containsString:@"/"]) {   //判断是否包含 / ，兼容老时间
        return timeStampStr;
    }
    //string转date
    NSInteger num = [timeStampStr integerValue] / 1000;
    if (num == 0) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:num];      //服务器给北京时间
    
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

//用当前时区返回时间
+ (NSDate *)localDateWithDate:(NSDate *)date
{
    //    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    //    NSLog(@"%@", localeDate);
    
    return localeDate;
}

+(NSString *)getDayStringWithTimeStampString:(NSString *)timeStampStr {
    if (timeStampStr == nil || [timeStampStr isEqualToString:@""]) {
        return @"";
    }
    //    NSLog(@"========%@" ,timeStampStr);
    //string转date
    NSInteger num = [timeStampStr integerValue] / 1000;
    if (num == 0) {
        return @"";
    }
    //    NSLog(@"===========%lu" ,num);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:num];      //服务器给北京时间
    
    NSString * dateString = [[date description]substringToIndex:10];
    
    return dateString;
}

//获取今天的日期 YYYY-MM-DD
+(NSString *)getTodayString {
    NSDate *now = [[NSDate alloc]init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *dateStr = [[now description]substringToIndex:10];
    
    return dateStr;
}

+ (NSString*)getDeviceVersion
{
    size_t size;
    
    sysctlbyname("hw.machine",NULL, &size, NULL,0);
    
    char *machine = (char*)malloc(size);
    
    sysctlbyname("hw.machine", machine, &size,NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    //NSString *platform = [NSStringstringWithUTF8String:machine];二者等效
    
    free(machine);
    
    return platform;
}

+(void)getPlatform:(NSString **)platForm andDeviceVersion:(NSString **)deviceVersion {
    *platForm = [UIDevice currentDevice].model;
    NSString *dv = [self getDeviceVersion];
    if ([dv isEqualToString:@"iPhone Simulator"] || [dv isEqualToString:@"x86_64"] || [dv isEqualToString:@"i386"]) {
        dv = @"Simulator";
    }
    *deviceVersion = dv;
}

//限定高度获得 宽度
-(CGFloat)obtainWidthWithFixHeight:(CGFloat)height andFontSize:(CGFloat)fontSize {
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize strSize = sizeWithText(self, attributes, CGSizeMake(MAXFLOAT, height));
    return ceilf(strSize.width);
}

//限定宽度获得高度
-(CGFloat)obtainHeightWithFixWidth:(CGFloat)width andFontSize:(CGFloat)fontSize {
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize strSize = sizeWithText(self, attributes, CGSizeMake(width, MAXFLOAT));
    return ceilf(strSize.height);
}

@end
