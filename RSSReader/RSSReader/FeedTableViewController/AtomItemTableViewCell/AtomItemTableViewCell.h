//
//  AtomItemTableViewCell.h
//  RSSReader
//
//  Created by Arseniy Strakh on 18.11.2020.
//

#import <UIKit/UIKit.h>
#import "AtomFeedItem.h"

@interface AtomItemTableViewCell : UITableViewCell
- (void)configureWithItem:(AtomFeedItem *)item;
@end
