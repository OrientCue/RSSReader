//
//  AtomItemTableViewCell.m
//  RSSReader
//
//  Created by Arseniy Strakh on 18.11.2020.
//

#import "AtomItemTableViewCell.h"

@interface AtomItemTableViewCell ()
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *pubDateLabel;
@property (retain, nonatomic) AtomFeedItem *item;
@end

@implementation AtomItemTableViewCell

- (void)configureWithItem:(AtomFeedItem *)item {
  self.item = item;
  self.titleLabel.text = self.item.title;
  self.pubDateLabel.text = self.item.pubDateString;
}

- (void)dealloc {
  [_item release];
  [_titleLabel release];
  [_pubDateLabel release];
  [super dealloc];
}

@end
