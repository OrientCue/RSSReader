//
//  FeedPresenter.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedPresenter.h"

@interface FeedPresenter ()

@property (nonatomic, retain) id<FeedServiceType> service;

@end

@implementation FeedPresenter

#pragma mark - NSObject

- (instancetype)initWith:(id<FeedServiceType>)service {
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
  __block typeof(self) weakSelf = self;
  [self.service fetchFeed:^(NSArray<AtomFeedItem *> *items) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.view hideLoading];
      [weakSelf.view appendItems:items];
    });
  }];
}

@end
