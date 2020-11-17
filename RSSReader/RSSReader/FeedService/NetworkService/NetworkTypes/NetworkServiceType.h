//
//  NetworkServiceType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

@class AtomFeedItem;
typedef void(^NetworkServiceCompletion)(NSArray<AtomFeedItem *> *items, NSError *error);

@protocol NetworkServiceType <NSObject>

- (void)fetchFeedFromUrl:(NSURL *)url completion:(NetworkServiceCompletion)completion;

@end
