//
//  UITableView+AGCategory.h
//  AGHandyUIKit
//
//  Created by Agenric on 2016/12/25.
//  Copyright © 2016年 Agenric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CellReuse)

/**
 根据Nib名称获取Cell

 @param nibName Nib名称
 @return 对应的Cell
 */
- (UITableViewCell *)cellWithCellNibName:(NSString *)nibName;

/**
 根据Nib名称和对应类名获取Cell

 @param nibName Nib名称
 @param className 对应类名
 @return 对应的Cell
 */
- (UITableViewCell *)cellWithCellNibName:(NSString *)nibName className:(NSString *)className;

/**
 根据Nib名称和对应类名获取携带block的Cell

 @param nibName Nib名称
 @param className 对应类名
 @param block block参数
 @return 对应的Cell
 */
- (UITableViewCell *)cellWithCellNibName:(NSString *)nibName className:(NSString *)className block:(void (^)(UITableViewCell *reuseCell))block;

/**
 根据Nib名称获取携带block的Cell

 @param nibName Nib名称
 @param block block参数
 @return 对应的Cell
 */
- (UITableViewCell *)cellWithCellNibName:(NSString *)nibName block:(void (^)(UITableViewCell *reuseCell))block;

/**
 根据Nib名称和复用标示获取Cell

 @param nibName Nib名称
 @param identifierName 复用标示
 @param block block参数
 @return 对应的Cell
 */
- (UITableViewCell *)cellWithCellNibName:(NSString *)nibName identifierName:(NSString *)identifierName block:(void (^)(UITableViewCell *reuseCell))block;

/**
 根据Nib名称、复用标示和对应类名获取携带block的Cell

 @param nibName Nib名称
 @param identifierName 复用标示
 @param className 对应类名
 @param block block参数
 @return 对应的Cell
 */
- (UITableViewCell *)cellWithCellNibName:(NSString *)nibName identifierName:(NSString *)identifierName className:(NSString *)className block:(void (^)(UITableViewCell *reuseCell))block;
@end
