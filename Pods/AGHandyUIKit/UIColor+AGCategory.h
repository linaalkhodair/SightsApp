//
//  UIColor+AGCategory.h
//  AGHandyUIKit
//
//  Created by Agenric on 2016/12/25.
//  Copyright © 2016年 Agenric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

/**
 16进制转化RGB

 @param hexString 16进制色值
 @return 转换后的色值
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 16进制转化RGB
 
 @param hexString 16进制色值
 @return 转换后的色值
 */
+ (UIColor *)colorAlphaWithHexString:(NSString *)hexString;
@end
