//
//  FeedService.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedService.h"
#import "NetworkServiceType.h"

NSString *const kRssURLString = @"https://news.tut.by/rss/index.rss";

@interface FeedService ()
@property (nonatomic, copy) FeedServiceCompletion completion;
@end

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
  [_completion release];
  [super dealloc];
}

#pragma mark - FeedServiceType

- (void)fetchFeed:(FeedServiceCompletion)completion {
  assert(completion);
  NSURL *rssUrl = [NSURL URLWithString:kRssURLString];
  self.completion = completion;
  __block typeof(self) weakSelf = self;
  [self.network fetchFeedFromUrl:rssUrl
                      completion:^(NSArray<AtomFeedItem *> *items, NSError *error) {
    if (error) {
      NSLog(@"%@", error.localizedDescription);
    }
    weakSelf.completion(items);
  }];
}

@end
