//
//  UIColor+AGCategory.m
//  AGHandyUIKit
//
//  Created by Agenric on 2016/12/25.
//  Copyright © 2016年 Agenric. All rights reserved.
//

#import "UIColor+AGCategory.h"

@implementation UIColor (HexColor)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSMutableString *mHexColor = [NSMutableString stringWithString:hexString];
    if ([hexString hasPrefix:@"#"]) {
        [mHexColor replaceCharactersInRange:[hexString rangeOfString:@"#" ] withString:@"0x"];
    }
    long colorLong = strtoul([mHexColor cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    // 通过位与方法获取三色值
    int R = (colorLong & 0xFF0000) >> 16;
    int G = (colorLong & 0x00FF00) >> 8;
    int B = colorLong & 0x0000FF;
    
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
}

+ (UIColor *)colorAlphaWithHexString:(NSString *)hexString {
    NSString *realHexString = [hexString hasPrefix:@"#"] ? [hexString substringFromIndex:1] : hexString;
    unsigned long colorLong = strtoul([realHexString cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    
    // 通过位与方法获取三色值
    unsigned int B = colorLong & 0xff;
    unsigned int G = (colorLong = colorLong >> 8) & 0xff;
    unsigned int R = (colorLong = colorLong >> 8) & 0xff;
    unsigned int A = (colorLong = colorLong >> 8) & 0xff;
    
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A/255.0];
}

@end
