//
//  ChannelTableViewCell.h
//  RSSReader
//
//  Created by Arseniy Strakh on 20.12.2020.
//

#import <UIKit/UIKit.h>
#import "RSSChannel.h"

@interface ChannelTableViewCell : UITableViewCell
  
- (void)configureWithChannel:(RSSChannel *)channel;

@end
