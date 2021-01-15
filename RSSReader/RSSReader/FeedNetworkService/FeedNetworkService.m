//
//  FeedNetworkService.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedNetworkService.h"
#import "DownloaderNSThread.h"
#import "FeedParserType.h"

@interface FeedNetworkService ()
@property (nonatomic, readonly, retain) id<FeedParserType> parser;
@property (nonatomic, copy) FeedNetworkServiceCompletion completion;
@end

@implementation FeedNetworkService

#pragma mark - NSObject

- (instancetype)initWithParser:(id<FeedParserType>)parser {
  if (self = [super init]) {
    _downloader = [DownloaderNSThread new];
    _parser = [parser retain];
  }
  return self;
}

- (void)dealloc {
  [_downloader release];
  [_parser release];
  [_completion release];
  [super dealloc];
}

#pragma mark - NetworkServiceType

- (void)fetchFeedFromUrl:(NSURL *)url completion:(FeedNetworkServiceCompletion)completion {
  assert(completion); // Completion will be called later, therefore it should not be nil.
  self.completion = completion;
  __block typeof(self) weakSelf = self;
  [self.downloader downloadFromUrl:url
                        completion:^(NSData *data, NSError *error) {
    if (error) {
      weakSelf.completion(nil, error);
      return;
    }
    [weakSelf.parser parse:data
                completion:weakSelf.completion];
  }];
}

@end
