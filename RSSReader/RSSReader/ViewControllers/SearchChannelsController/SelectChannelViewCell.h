//
//  SelectChannelViewCell.h
//  RSSReader
//
//  Created by Arseniy Strakh on 22.12.2020.
//

#import <UIKit/UIKit.h>
#import "RSSChannel.h"

@interface SelectChannelViewCell : UITableViewCell
- (void)configureWithChannel:(RSSChannel *)channel alreadyAdded:(BOOL)alreadyAdded;
@end
