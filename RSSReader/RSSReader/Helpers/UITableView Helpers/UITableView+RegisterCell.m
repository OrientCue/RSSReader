//
//  UITableView+RegisterCell.m
//  RSSReader
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import "UITableView+RegisterCell.h"

@implementation UITableView (RegisterCell)

- (void)registerNibForCellClasses:(NSArray<Class> *)cellClasses {
    for (Class cellClass in cellClasses) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:NSStringFromClass(cellClass)];
    }
}

@end
