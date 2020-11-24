//
//  UITableView+RegisterCell.m
//  RSSReader
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import "UITableView+RegisterCell.h"
#import "AtomItemTableViewCell.h"

@implementation UITableView (RegisterCell)

- (void)registerAtomItemTableViewCell {
  UINib *nib = [UINib nibWithNibName:NSStringFromClass([AtomItemTableViewCell class]) bundle:nil];
  [self registerNib:nib forCellReuseIdentifier:AtomItemTableViewCell.identifier];
}

@end
