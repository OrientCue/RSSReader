//
//  FeedParserType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

@class AtomFeedItem;
typedef void(^FeedParserCompletion)(NSArray<AtomFeedItem *> *items, NSError *error);

@protocol FeedParserType <NSObject>
- (void)parse:(NSData *)data completion:(FeedParserCompletion)completion;
@end
