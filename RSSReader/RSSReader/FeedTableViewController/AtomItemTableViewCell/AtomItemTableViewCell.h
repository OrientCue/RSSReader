//
//  AtomItemTableViewCell.h
//  RSSReader
//
//  Created by Arseniy Strakh on 18.11.2020.
//

#import <UIKit/UIKit.h>
#import "AtomFeedItem.h"

@interface AtomItemTableViewCell : UITableViewCell
@property (nonatomic, class, readonly) NSString *identifier;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *pubDateLabel;
@property (retain, nonatomic) AtomFeedItem *item;

- (void)configureWithItem:(AtomFeedItem *)item;
@end
