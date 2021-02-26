//
//  ChannelsPresenterType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 19.12.2020.
//

#import <Foundation/Foundation.h>

@protocol ChannelsViewType;
@class RSSChannel;

@protocol ChannelsPresenterType <NSObject>
@property (nonatomic, assign) id<ChannelsViewType> view;
- (void)setup;
- (void)updateStorageWithSelectedIndex:(NSUInteger)index;
- (void)loadFromLocalStorage;
- (void)updateFromLocalStorage;
- (void)removeChannelFromLocalStorage:(RSSChannel *)channel;
@end
