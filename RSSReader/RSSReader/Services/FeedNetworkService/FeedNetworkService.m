//
//  FeedNetworkService.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedNetworkService.h"
#import "DownloadOperation.h"
#import "FeedParserType.h"

@interface FeedNetworkService ()
@property (nonatomic, readonly, retain) id<FeedParserType> parser;
@property (nonatomic, copy) FeedNetworkServiceCompletion completion;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, getter=isInflight) BOOL inflight;
@end

@implementation FeedNetworkService

#pragma mark - NSObject

- (instancetype)initWithParser:(id<FeedParserType>)parser {
  if (self = [super init]) {
    _parser = [parser retain];
  }
  return self;
}

- (void)dealloc {
  [_queue release];
  [_parser release];
  [_completion release];
  [super dealloc];
}

#pragma mark - Lazy Properties

- (NSOperationQueue *)queue {
  if (!_queue) {
    _queue = [NSOperationQueue new];
  }
  return _queue;
}

#pragma mark - NetworkServiceType

- (void)fetchFeedFromUrl:(NSURL *)url completion:(FeedNetworkServiceCompletion)completion {
  if (self.isInflight) {
    [self cancelFetch];
  }
  self.completion = completion;
  __block typeof(self) weakSelf = self;
  DownloadOperation *operation = [[DownloadOperation alloc] initWithURL:url];
  __block typeof(operation) weakOperation = operation;
  operation.completionBlock = ^{
    if (weakOperation.isCancelled) {
      weakSelf.inflight = false;
      return;
    }
    if (weakOperation.error) {
      if (weakSelf.completion) {
        weakSelf.completion(nil, weakOperation.error);
      }
    } else {
      [weakSelf.parser parse:weakOperation.downloaded
                  completion:weakSelf.completion];
    }
    weakSelf.inflight = false;
  };
  self.inflight = true;
  [self.queue addOperation:operation];
  [operation release];
}

- (void)cancelFetch {
  self.completion = nil;
  [self.queue cancelAllOperations];
}

@end
