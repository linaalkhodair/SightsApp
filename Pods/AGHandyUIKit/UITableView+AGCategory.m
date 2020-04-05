//
//  UITableView+AGCategory.m
//  AGHandyUIKit
//
//  Created by Agenric on 2016/12/25.
//  Copyright © 2016年 Agenric. All rights reserved.
//

#import "UITableView+AGCategory.h"

@implementation UITableView (CellReuse)

- (UITableViewCell *)cellWithCellNibName:(NSString *)nibName {
    return [self cellWithCellNibName:nibName block:nil];
}

- (UITableViewCell *)cellWithCellNibName:(NSString *)nibName className:(NSString *)className {
    return [self cellWithCellNibName:nibName identifierName:className className:className block:nil];
}

- (UITableViewCell *)cellWithCellNibName:(NSString *)nibName className:(NSString *)className block:(void (^)(UITableViewCell *reuseCell))block {
    return [self cellWithCellNibName:nibName identifierName:className className:className block:block];
}

- (UITableViewCell *)cellWithCellNibName:(NSString *)nibName block:(void (^)(UITableViewCell *reuseCell))block {
    return [self cellWithCellNibName:nibName identifierName:nil block:block];
}

- (UITableViewCell *)cellWithCellNibName:(NSString *)nibName identifierName:(NSString *)identifierName block:(void (^)(UITableViewCell *reuseCell))block {
    return [self cellWithCellNibName:nibName identifierName:identifierName className:nil block:block];
}

- (UITableViewCell *)cellWithCellNibName:(NSString *)nibName identifierName:(NSString *)identifierName className:(NSString *)className block:(void (^)(UITableViewCell *reuseCell))block {
    if ([identifierName length] <= 0) identifierName = nibName;
    if ([className length] <=0 ) className = identifierName;
    
    id cell = (UITableViewCell *)[self dequeueReusableCellWithIdentifier:identifierName];
    if (!cell) {
        if ([[nibName uppercaseString] isEqualToString:@"UITABLEVIEWCELL"]) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierName];
        } else {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:NSClassFromString(className)]) {
                    cell = oneObject;
                }
            }
        }
    }
    
    if (block) block(cell);
    
    return cell;
}

@end
