//
//  NetworkServiceType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

@class Article;
typedef void(^NetworkServiceCompletion)(NSArray<Article *> *articles, NSError *error);

@protocol NetworkServiceType <NSObject>

- (void)fetchFeedFromUrl:(NSURL *)url completion:(NetworkServiceCompletion)completion;

@end
