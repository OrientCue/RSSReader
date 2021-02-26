//
//  AtomItemTableViewCell.h
//  RSSReader
//
//  Created by Arseniy Strakh on 18.11.2020.
//

#import <UIKit/UIKit.h>
#import "AtomFeedItem.h"
#import "AtomItemCellDelegate.h"

@interface AtomItemTableViewCell : UITableViewCell
@property (weak, nonatomic) id<AtomItemCellDelegate> delegate;
- (void)configureWithItem:(AtomFeedItem *)item
                indexPath:(NSIndexPath *)indexPath
                 expanded:(BOOL)isExpanded;
@end
