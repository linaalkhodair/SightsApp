//
//  UIView+AGCategory.m
//  AGHandyUIKit
//
//  Created by Agenric on 2016/12/25.
//  Copyright © 2016年 Agenric. All rights reserved.
//

#import "UIView+AGCategory.h"

@implementation UIView (XibConfiguration)

// LayerColor
-(UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
-(void)setLayerColor:(UIColor *)LayerColor_ {
    self.layer.borderColor = LayerColor_.CGColor;
}
- (UIColor *)LayerColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

// LayerWidth
- (void)setLayerWidth:(CGFloat)LayerWidth_ {
    self.layer.borderWidth = LayerWidth_;
    self.layer.allowsEdgeAntialiasing = YES;// 解决layer.border.width随着view的放大，会出现锯齿化的问题（iOS7.0）
}
- (CGFloat)LayerWidth {
    return self.layer.borderWidth;
}

// LayerRadius
- (void)setLayerRadius:(CGFloat)LayerRadius_ {
    self.layer.cornerRadius = LayerRadius_;
}
- (CGFloat)LayerRadius {
    return self.layer.cornerRadius;
}

// LayerShadowOffset
- (void)setShadowOffset:(CGSize)ShadowOffset_ {
    self.layer.shadowOffset = ShadowOffset_;
}
- (CGSize)ShadowOffset {
    return self.layer.shadowOffset;
}

// LayerShadowRadius
- (void)setShadowRadius:(CGFloat)ShadowRadius_ {
    self.layer.shadowRadius = ShadowRadius_;
}
- (CGFloat)ShadowRadius {
    return self.layer.shadowRadius;
}

// LayerShadowOpacity
- (void)setShadowOpacity:(CGFloat)ShadowOpacity_ {
    self.layer.shadowOpacity = ShadowOpacity_;
}
- (CGFloat)ShadowOpacity {
    return self.layer.shadowOpacity;
}

// LayerShadowColor
- (void)setShadowColor:(UIColor *)ShadowColor_ {
    self.layer.shadowColor = ShadowColor_.CGColor;
}
- (UIColor *)ShadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

@end

@implementation UIView (LayoutMethods)

- (CGFloat)top {
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}
- (CGFloat)bottom {
    return self.top + self.height;
}
- (void)setBottom:(CGFloat)bottom {
    self.top = bottom - self.height;
}
- (CGFloat)left {
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
- (CGFloat)right {
    return self.left + self.width;
}
- (void)setRight:(CGFloat)right {
    self.left = right - self.width;
}


- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


- (CGFloat)centerX {
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.centerY);
}
- (CGFloat)centerY {
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.centerX, centerY);
}



- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

@end
