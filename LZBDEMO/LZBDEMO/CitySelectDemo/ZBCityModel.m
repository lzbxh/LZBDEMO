//
//  ZBCityModel.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/16.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBCityModel.h"
#import "POAPinyin.h"
#import "pinyin.h"

@implementation ZBCityModel

-(instancetype)initWithCityName:(NSString *)cityName {
    if (self = [super init]) {
        _cityName = cityName;
        _titleHeader = [self getfirstCharact:cityName];
    }
    return self;
}

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


@end
