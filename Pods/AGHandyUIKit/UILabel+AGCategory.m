//
//  UILabel+AGCategory.m
//  AGHandyUIKit
//
//  Created by Agenric on 2016/12/25.
//  Copyright © 2016年 Agenric. All rights reserved.
//

#import "UILabel+AGCategory.h"

@implementation UILabel (AttributedText)
- (NSRange)rangeWithText:(NSString *)text {
    if ([self.text length] <= 0 || [text length] <= 0) {
        return NSMakeRange(0, 0);
    } else {
        NSRange range = [self.text rangeOfString:text];
        return range;
    }
}

- (void)setColor:(UIColor *)color font:(UIFont *)font {
    self.textColor = color;
    self.font = font;
}

- (void)setAttributedText:(NSString *)text withColor:(UIColor *)color {
    [self setAttributedText:text withColor:color fontSize:0];
}

- (void)setAttributedText:(NSString *)text fontSize:(NSInteger)fontSize {
    [self setAttributedText:text withColor:nil fontSize:fontSize];
}

- (void)setAttributedText:(NSString *)text font:(UIFont *)font {
    [self setAttributedText:text withColor:nil font:font];
}

- (void)setAttributedText:(NSString *)text withColor:(UIColor *)color fontSize:(NSInteger)fontSize {
    if (self.text.length > 0 || self.attributedText.length > 0) {
        NSMutableAttributedString *attStr = nil;
        if (self.attributedText.length > 0) {
            attStr = [self.attributedText mutableCopy];
        } else {
            if (self.text.length > 0) {
                attStr = [[NSMutableAttributedString alloc] initWithString:self.text];
            }
        }
        if (color && text) {
            [attStr addAttribute:NSForegroundColorAttributeName value:color range:[self rangeWithText:text]];
        }
        if (fontSize > 0 && text){
            [attStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.font.fontName size:fontSize] range:[self rangeWithText:text]];
        }
        self.attributedText = attStr;
        [self setNeedsDisplay];
    }
}

- (void)setAttributedText:(NSString *)text withColor:(UIColor *)color font:(UIFont *)font {
    if (self.text.length > 0 || self.attributedText.length > 0) {
        NSMutableAttributedString *attStr=nil;
        if (self.attributedText.length > 0) {
            attStr = [self.attributedText mutableCopy];
        } else {
            if (self.text.length > 0) {
                attStr = [[NSMutableAttributedString alloc] initWithString:self.text];
            }
        }
        if (color && text) {
            [attStr addAttribute:NSForegroundColorAttributeName value:color range:[self rangeWithText:text]];
        }
        if (font && text){
            [attStr addAttribute:NSFontAttributeName value:font range:[self rangeWithText:text]];
        }
        self.attributedText = attStr;
        [self setNeedsDisplay];
    }
}

@end
