//
//  FeedViewType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

@class AtomFeedItem, RSSChannel;

@protocol FeedViewType <NSObject>
- (void)feedForChannel:(RSSChannel *)channel;
- (void)appendItems:(NSArray<AtomFeedItem *> *)items;
- (void)showEmptyFeed;
- (void)showLoading;
- (void)hideLoading;
- (void)displayError:(NSError *)error;
@end
