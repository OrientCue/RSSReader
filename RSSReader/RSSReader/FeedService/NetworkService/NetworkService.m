//
//  NetworkService.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "NetworkService.h"

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
  [super dealloc];
}

#pragma mark - NetworkServiceType

- (void)fetchFeedFromUrl:(NSURL *)url completion:(NetworkServiceCompletion)completion {
  __weak typeof(self) weakSelf = self;
  [self.downloader downloadFromUrl:url
                        completion:^(NSData *data, NSError *error) {
    if (error) {
      completion(nil, error);
      return;
    }
    [weakSelf.parser parse:data completion:^(NSArray<Article *> *articles, NSError *err) {
      if (err) {
        completion(nil, err);
        return;
      }
      completion(articles, nil);
    }];
  }];
}

@end
