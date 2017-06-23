//
//  ZXYUtility.h
//  iiappleSDK
//
//  Created by stefan on 14-7-9.
//  Copyright (c) 2014年 stefan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZXYAES.h"

@interface ZXYUtility : NSObject

+ (NSString *)AESStingWithString:(NSString *)str;
+ (NSString *)stringWithAESString:(NSString *)aesStr;

@end
