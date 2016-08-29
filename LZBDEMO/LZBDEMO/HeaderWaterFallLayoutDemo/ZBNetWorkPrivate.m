//
//  ZBNetWorkPrivate.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/29.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBNetWorkPrivate.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ZBNetWorkPrivate

+(BOOL)checkJson:(id)json withValidator:(id)validatorJson {
    if ([json isKindOfClass:[NSDictionary class]] && [validatorJson isKindOfClass:[NSDictionary class]]) {          //如果都是字典
        NSDictionary *dict = json;
        NSDictionary *validator = validatorJson;
        BOOL result = YES;
        NSEnumerator *enumerator = [validatorJson keyEnumerator];
        NSString *key;
        //枚举所有的key value
        while (key = [enumerator nextObject]) {
            id value = dict[key];
            id format = validator[key];     //格式？
            if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                //递归取得json
                result = [self checkJson:value withValidator:format];
                if (!result) {
                    break;
                }
            } else {
                if ([value isKindOfClass:format] == NO || [value isKindOfClass:[NSNull class]] == NO) {
                    result = NO;
                    break;
                }
            }
        }
        return result;
    } else if ([json isKindOfClass:[NSArray class]] && [validatorJson isKindOfClass:[NSArray class]]) {         //如果都是数组
        NSArray *validatorArray = (NSArray *)validatorJson;
        if (validatorArray.count > 0) {
            NSArray *array = json;
            NSDictionary *validator = validatorJson[0];
            for (id item in array) {
                BOOL result = [self checkJson:item withValidator:validator];
                if (!result) {
                    return NO;
                }
            }
        }
        return YES;
    } else if ([json isKindOfClass:validatorJson]) {
        return YES;
    } else {
        return NO;
    }
}

//拼接参数
+ (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters {
    NSMutableString *urlParametersString = [[NSMutableString alloc] initWithString:@""];
    if (parameters && parameters.count > 0) {
        for (NSString *key in parameters) {
            NSString *value = parameters[key];
            value = [NSString stringWithFormat:@"%@",value];
            value = [self urlEncode:value];
            [urlParametersString appendFormat:@"&%@=%@", key, value];
        }
    }
    return urlParametersString;
}

//GET URL拼接参数
+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters {
    NSString *filteredUrl = originUrlString;
    NSString *paraUrlString = [self urlParametersStringFromParameters:parameters];
    if (paraUrlString && paraUrlString.length > 0) {
        if ([originUrlString rangeOfString:@"?"].location != NSNotFound) {
            filteredUrl = [filteredUrl stringByAppendingString:paraUrlString];
        } else {
            filteredUrl = [filteredUrl stringByAppendingFormat:@"?%@", [paraUrlString substringFromIndex:1]];
        }
        return filteredUrl;
    } else {
        return originUrlString;
    }
}

//URL编码
+ (NSString*)urlEncode:(NSString*)str {
    //different library use slightly different escaped and unescaped set.
    //below is copied from AFNetworking but still escaped [] as AF leave them for Rails array parameter which we don't use.
    //https://github.com/AFNetworking/AFNetworking/pull/555
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    return result;
}

//不备份这个url的资源
+ (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    
    /*      NSURLIsExcludedFromBackupKey
            Key for determining whether the resource is excluded from all backups of app data, returned as a Boolean NSNumber object (read-write).
        
            You can use this property to exclude cache and other app support files which are not needed in a backup. Some operations commonly made to user documents cause this property to be reset to false; consequently, do not use this property on user documents.
     */
            
    if (error) {
        LOG(@"error to set do not backup attribute, error = %@", error);
    }
}

//MD5
+ (NSString *)md5StringFromString:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString *)appVersionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end

@implementation ZBBaseRequest(RequestAccessory)

//装载一些装饰类，执行一些代理方法
- (void)toggleAccessoriesWillStartCallBack {
    for ( id<RequestAccescory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestWillStart:)]) {
            [accessory requestWillStart:self];
        }
    }
}

-(void)toggleAccessoriesWillStopCallBack {
    for ( id<RequestAccescory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestWillStop:)]) {
            [accessory requestWillStop:self];
        }
    }
}

-(void)toggleAccessoriesDidStopCallBack {
    for ( id<RequestAccescory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestDidStop:)]) {
            [accessory requestDidStop:self];
        }
    }
}

@end

