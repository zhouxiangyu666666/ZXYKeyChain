//
//  ZXYUtility.m
//  iiappleSDK
//
//  Created by stefan on 14-7-9.
//  Copyright (c) 2014年 stefan. All rights reserved.
//

#import "ZXYUtility.h"
#define IA_NETWORK_KEY "c6*#e2&(g*UjX!h*"
@implementation ZXYUtility

+ (NSString *)AESStingWithString:(NSString *)str {
    ZXYAES *aes = [[ZXYAES alloc] initWithKey:IA_NETWORK_KEY];
    const char *strChar = [str UTF8String];
    NSString *encryptString = [aes Encryption:strChar
                                          len:strlen(strChar)];
    return encryptString;
}

+ (NSString *)stringWithAESString:(NSString *)aesStr {
    if(aesStr.length==0||aesStr==nil)
    {
        return @"";
    }
    ZXYAES *aes = [[ZXYAES alloc] initWithKey:IA_NETWORK_KEY];
    const char *strChar = [aesStr UTF8String];
    NSString *decryptString = [aes Decryption:strChar
                                          len:strlen(strChar)];
    return decryptString;
}

@end
