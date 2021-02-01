//
//  ChannelsViewType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 19.12.2020.
//

#import <Foundation/Foundation.h>

@class RSSChannel;

@protocol ChannelsViewType <NSObject>
- (void)displayFeedForChannels:(NSArray<RSSChannel *> *)channels selected:(NSUInteger)selected;
- (void)update:(NSArray<RSSChannel *> *)channels selected:(NSUInteger)selected;
@end
