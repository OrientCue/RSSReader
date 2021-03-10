//
//  ChannelTableViewCell.m
//  RSSReader
//
//  Created by Arseniy Strakh on 20.12.2020.
//

#import "ChannelTableViewCell.h"

@interface ChannelTableViewCell ()
@property (nonatomic, strong) RSSChannel *channel;
@end

@implementation ChannelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

#pragma mark - Interface

- (void)configureWithChannel:(RSSChannel *)channel {
    self.channel = channel;
    self.textLabel.text = self.channel.title;
    self.detailTextLabel.text = self.channel.link.absoluteString;
}

@end
