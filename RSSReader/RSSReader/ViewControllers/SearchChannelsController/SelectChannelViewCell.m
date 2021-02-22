//
//  SelectChannelViewCell.m
//  RSSReader
//
//  Created by Arseniy Strakh on 22.12.2020.
//

#import "SelectChannelViewCell.h"

@interface SelectChannelViewCell ()
@property (nonatomic, retain) RSSChannel *channel;
@property (nonatomic, getter=isAlreadyAddedChannel) BOOL alreadyAddedChannel;
@end

@implementation SelectChannelViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

- (void)dealloc {
    [_channel release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.alreadyAddedChannel) {
        [super setSelected:!selected animated:animated];
    } else {
        [super setSelected:selected animated:animated];
        self.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
}

#pragma mark - Interface

- (void)configureWithChannel:(RSSChannel *)channel alreadyAdded:(BOOL)alreadyAdded{
    self.channel = channel;
    self.textLabel.text = self.channel.title;
    self.detailTextLabel.text = self.channel.link.absoluteString;
    self.alreadyAddedChannel = alreadyAdded;
    self.accessoryType = self.isAlreadyAddedChannel ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

@end
