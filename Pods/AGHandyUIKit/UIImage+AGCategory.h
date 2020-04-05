//
//  UIImage+AGCategory.h
//  AGHandyUIKit
//
//  Created by Agenric on 2016/12/25.
//  Copyright © 2016年 Agenric. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 压缩图片
 
 @param image 需要压缩的图片
 @param compressRatio 压缩比例
 @param imagePickerImageSize 压缩的最大尺寸，单位kb
 @return 压缩后的图片
 */
static inline NSData * CompressImage(UIImage *image, CGFloat compressRatio, CGFloat imagePickerImageSize) {
    //压缩系数
    CGFloat scaleValue = compressRatio;
    NSData* imageData = nil;
    
    NSData* imageScaleData = UIImageJPEGRepresentation(image, scaleValue);
    
    for (NSInteger i = 0; i < 5/*只给5次压缩机会*/ && imageScaleData.length > imagePickerImageSize * 1024; i++ ) {
        scaleValue -= 0.1;
        imageScaleData = UIImageJPEGRepresentation(image, scaleValue);
    }
    imageData = imageScaleData;
    
    return imageData;
}

@interface UIImage (Gradient)

/**
 根据给出的 尺寸＋起始颜色＋结束颜色 返回一个渐变的图片

 @param size 即将生成的图片的尺寸
 @param startColor 起始渐变色
 @param endColor 结束渐变色
 @return 渐变图片
 */
+ (UIImage*)imageWithSize:(CGSize)size startColor:(UIColor*)startColor endColor:(UIColor*)endColor;

@end

@interface UIImage (InsetSettings)

/**
 设置图片颜色和大小

 @param color 图片颜色
 @param size 图片大小
 @return 所得图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
@end
