//
//  AtomItemTableViewCell.m
//  RSSReader
//
//  Created by Arseniy Strakh on 18.11.2020.
//

#import "AtomItemTableViewCell.h"

@implementation AtomItemTableViewCell

+ (NSString *)identifier {
  return NSStringFromClass(self);
}

- (void)configureWithItem:(AtomFeedItem *)item {
  self.item = item;
  self.titleLabel.text = item.title;
  self.pubDateLabel.text = [item pubDateString];
}

- (void)dealloc {
  [_item release];
  [_titleLabel release];
  [_pubDateLabel release];
  [super dealloc];
}
@end
