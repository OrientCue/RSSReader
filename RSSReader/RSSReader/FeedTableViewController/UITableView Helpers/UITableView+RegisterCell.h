//
//  UITableView+RegisterCell.h
//  RSSReader
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import <UIKit/UIKit.h>

@interface UITableView (RegisterCell)

/// Register Nibs for cell classes array, where Nib name and cell reuse identifier equal class name.
/// @param cellClasses NSArray of classes for register
- (void)registerNibForCellClasses:(NSArray<Class> *)cellClasses;

@end
