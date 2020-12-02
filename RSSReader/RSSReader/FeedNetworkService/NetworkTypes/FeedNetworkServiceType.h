//
//  FeedNetworkServiceType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

@class AtomFeedItem;
typedef void(^NetworkServiceCompletion)(NSArray<AtomFeedItem *> *items, NSError *error);

@protocol FeedNetworkServiceType <NSObject>
- (void)fetchFeedFromUrl:(NSURL *)url completion:(NetworkServiceCompletion)completion;
@end
