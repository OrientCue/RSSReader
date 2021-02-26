//
//  AtomItemTableViewCell.m
//  RSSReader
//
//  Created by Arseniy Strakh on 18.11.2020.
//

#import "AtomItemTableViewCell.h"

@interface AtomItemTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *pubDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) AtomFeedItem *item;
@property (assign, nonatomic) NSInteger row;
@end

@implementation AtomItemTableViewCell

#pragma mark - Interface

- (void)configureWithItem:(AtomFeedItem *)item
                indexPath:(NSIndexPath *)indexPath
                 expanded:(BOOL)isExpanded {
    self.item = item;
    self.row = indexPath.row;
    self.descriptionLabel.hidden = !isExpanded;
    self.descriptionLabel.text = self.item.articleDescription;
    self.titleLabel.text = self.item.title;
    self.pubDateLabel.text = self.item.pubDateString;
}
#pragma mark - IBAction

- (IBAction)annotationButtonDidTap:(UIButton *)sender {
    [self.delegate row:self.row expandedState:self.descriptionLabel.isHidden];
}

@end
