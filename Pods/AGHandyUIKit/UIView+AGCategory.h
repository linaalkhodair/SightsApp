//
//  UIView+AGCategory.h
//  AGHandyUIKit
//
//  Created by Agenric on 2016/12/25.
//  Copyright © 2016年 Agenric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XibConfiguration)

@property (nonatomic, assign) IBInspectable UIColor *LayerColor;
@property (nonatomic, assign) IBInspectable CGFloat  LayerWidth;
@property (nonatomic, assign) IBInspectable CGFloat  LayerRadius;

@property (nonatomic, assign) IBInspectable CGSize   ShadowOffset;
@property (nonatomic, assign) IBInspectable CGFloat  ShadowRadius;
@property (nonatomic, assign) IBInspectable CGFloat  ShadowOpacity;
@property (nonatomic, assign) IBInspectable UIColor *ShadowColor;

@end

@interface UIView (LayoutMethods)

@property CGFloat top;
@property CGFloat bottom;
@property CGFloat left;
@property CGFloat right;

@property CGSize size;
@property CGPoint origin;

@property CGFloat centerX;
@property CGFloat centerY;

@property CGFloat height;
@property CGFloat width;

@end
