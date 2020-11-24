//
//  NetworkService.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "NetworkService.h"

@interface NetworkService ()

@property (nonatomic, copy) NetworkServiceCompletion completion;

@end

@implementation NetworkService

#pragma mark - NSObject

- (instancetype)initWithDownloader:(id<FeedDownloaderType>)downloader
                            parser:(id<FeedParserType>)parser {
  if (self = [super init]) {
    _downloader = [downloader retain];
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

- (void)fetchFeedFromUrl:(NSURL *)url completion:(NetworkServiceCompletion)completion {
  assert(completion);
  self.completion = completion;
  __block typeof(self) weakSelf = self;
  [self.downloader downloadFromUrl:url
                        completion:^(NSData *data, NSError *error) {
    if (error) {
      weakSelf.completion(nil, error);
      return;
    }
    [weakSelf.parser parse:data
                completion:^(NSArray<AtomFeedItem *> *items, NSError *err) {
      if (err) {
        weakSelf.completion(nil, err);
        return;
      }
      weakSelf.completion(items, nil);
    }];
  }];
}

@end
