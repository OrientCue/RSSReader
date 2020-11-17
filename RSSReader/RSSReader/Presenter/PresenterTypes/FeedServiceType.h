//
//  FeedServiceType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

@class AtomFeedItem;
typedef void(^FeedServiceCompletion)(NSArray<AtomFeedItem *> *items);

@protocol FeedServiceType <NSObject>

- (void)fetchFeed:(FeedServiceCompletion)completion;

@end
