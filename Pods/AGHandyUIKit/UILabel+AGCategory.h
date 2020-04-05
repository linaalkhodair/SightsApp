//
//  UILabel+AGCategory.h
//  AGHandyUIKit
//
//  Created by Agenric on 2016/12/25.
//  Copyright © 2016年 Agenric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (AttributedText)

/**
 获取文本所在范围

 @param text 文本内容
 @return 文本所在范围
 */
- (NSRange)rangeWithText:(NSString *)text;

/**
 设置颜色和字体大小

 @param color 颜色
 @param font 字体
 */
- (void)setColor:(UIColor *)color font:(UIFont *)font;

/**
 设置富文本的颜色字体大小

 @param text 富文本的文字内容
 @param font 富文本文字的字体
 */
- (void)setAttributedText:(NSString *)text font:(UIFont *)font;

/**
 设置富文本的颜色字体大小

 @param text 富文本的文字内容
 @param fontSize 富文本文字的字体大小（默认字体）
 */
- (void)setAttributedText:(NSString *)text fontSize:(NSInteger)fontSize;

/**
 设置富文本的颜色字体大小

 @param text 富文本的文字内容
 @param color 富文本字体的颜色
 */
- (void)setAttributedText:(NSString *)text withColor:(UIColor *)color;

/**
 设置富文本的颜色字体大小

 @param text 富文本的文字内容
 @param color 富文本字体的颜色
 @param font 富文本文字的字体
 */
- (void)setAttributedText:(NSString *)text withColor:(UIColor *)color font:(UIFont *)font;

/**
 设置富文本的颜色字体大小

 @param text 富文本的文字内容
 @param color 富文本字体的颜色
 @param fontSize 富文本文字的字体大小（默认字体）
 */
- (void)setAttributedText:(NSString *)text withColor:(UIColor *)color fontSize:(NSInteger)fontSize;

@end
