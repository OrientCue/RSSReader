//
//  FeedServiceType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

typedef void(^FeedServiceCompletion)(NSArray<Article *> *articles);

@protocol FeedServiceType <NSObject>

- (void)fetchFeed:(FeedServiceCompletion)completion;

@end
