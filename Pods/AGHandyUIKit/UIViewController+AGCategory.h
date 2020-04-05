//
//  UIViewController+AGCategory.h
//  AGHandyUIKit
//
//  Created by Agenric on 2016/12/25.
//  Copyright © 2016年 Agenric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (VisibleController)

/**
 获取当前显示的ViewController

 @return 当前显示的ViewController
 */
+ (UIViewController *)currentVisibleViewController;
@end
