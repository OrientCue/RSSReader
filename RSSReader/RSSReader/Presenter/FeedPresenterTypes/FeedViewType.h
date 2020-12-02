//
//  FeedViewType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

@class AtomFeedItem;

@protocol FeedViewType <NSObject>
- (void)appendItems:(NSArray<AtomFeedItem *> *)items;
- (void)showLoading;
- (void)hideLoading;
- (void)displayError:(NSError *)error;
@end
