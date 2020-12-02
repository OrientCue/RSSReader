//
//  FeedPresenter.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedPresenter.h"
#import "FeedViewType.h"
#import "FeedNetworkServiceType.h"

NSString *const kRssURLString = @"https://news.tut.by/rss/index.rss";

@interface FeedPresenter ()
@property (nonatomic, retain) id<FeedNetworkServiceType> service;
@end

@implementation FeedPresenter

#pragma mark - NSObject

- (instancetype)initWith:(id<FeedNetworkServiceType>)service {
  if (self = [super init]) {
    _service = [service retain];
  }
  return self;
}

- (void)dealloc {
  [_service release];
  [super dealloc];
}

#pragma mark - FeedPresenterType

- (void)fetch {
  [self.view showLoading];
  NSURL *rssUrl = [NSURL URLWithString:kRssURLString];
  __block typeof(self) weakSelf = self;
  [self.service fetchFeedFromUrl:rssUrl completion:^(NSArray<AtomFeedItem *> *items, NSError *error) {
    if (error) {
      NSLog(@"%@", error.localizedDescription);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.view hideLoading];
      [weakSelf.view appendItems:items];
    });
  }];
}

@end
