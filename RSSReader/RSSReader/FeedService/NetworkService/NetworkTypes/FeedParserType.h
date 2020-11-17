//
//  FeedParserType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

@class Article;
typedef void(^FeedParserCompletion)(NSArray<Article *> *articles, NSError *error);

@protocol FeedParserType <NSObject>
- (void)parse:(NSData *)data completion:(FeedParserCompletion)completion;
@end
