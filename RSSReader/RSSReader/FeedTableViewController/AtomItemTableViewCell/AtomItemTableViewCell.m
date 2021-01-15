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
@property (retain, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (retain, nonatomic) AtomFeedItem *item;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic, getter=isExpanded) BOOL expanded;
@end

@implementation AtomItemTableViewCell

#pragma mark - Interface

- (void)configureWithItem:(AtomFeedItem *)item
                indexPath:(NSIndexPath *)indexPath
                 expanded:(BOOL)isExpanded {
  self.item = item;
  self.row = indexPath.row;
  self.expanded = isExpanded;
  self.descriptionLabel.text = self.item.articleDescription;
  self.descriptionLabel.hidden = !self.isExpanded;
  self.titleLabel.text = self.item.title;
  self.pubDateLabel.text = self.item.pubDateString;
}
#pragma mark - IBAction

- (IBAction)annotationButtonDidTap:(UIButton *)sender {
  self.expanded = !self.isExpanded;
  [self.delegate row:self.row expandedState:self.isExpanded];
}

#pragma mark -

- (void)dealloc {
  [_item release];
  [_titleLabel release];
  [_pubDateLabel release];
  [_descriptionLabel release];
  [super dealloc];
}

@end
