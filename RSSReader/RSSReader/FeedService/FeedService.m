//
//  FeedService.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedService.h"
#import "NetworkServiceType.h"

@implementation FeedService

#pragma mark - NSObject

- (instancetype)initWith:(id<NetworkServiceType>)networkService {
  if (self = [super init]) {
    _network = [networkService retain];
  }
  return self;
}

- (void)dealloc {
  [_network release];
  [super dealloc];
}

#pragma mark - FeedServiceType

- (void)fetchFeed:(FeedServiceCompletion)completion {
  NSURL *rssUrl = [NSURL URLWithString:@"https://news.tut.by/rss/index.rss"];
  [self.network fetchFeedFromUrl:rssUrl
                      completion:^(NSArray<Article *> *articles, NSError *error) {
    NSLog(@"%@", error.localizedDescription);
    completion(articles);
  }];
}

@end
