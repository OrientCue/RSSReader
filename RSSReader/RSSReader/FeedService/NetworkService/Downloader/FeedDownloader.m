//
//  FeedDownloader.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedDownloader.h"

@interface FeedDownloader ()

@property (nonatomic, retain) NSURLSession *session;
@property (nonatomic, copy) FeedDownloaderCompletion completion;

@end

@implementation FeedDownloader

- (instancetype)initWithURLSession:(NSURLSession *)session {
  if (self = [super init]) {
    _session = [session retain];
  }
  return self;
}

- (instancetype)init {
  return [self initWithURLSession:NSURLSession.sharedSession];
}

- (void)dealloc {
  [_session release];
  [_completion release];
  [super dealloc];
}

#pragma mark - FeedDownloaderType

- (void)downloadFromUrl:(NSURL *)url completion:(FeedDownloaderCompletion)completion {
  self.completion = completion;
  __block typeof(self) weakSelf = self;
  NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url
                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    [weakSelf retain];
    if (error) {
      weakSelf.completion(nil, error);
      [weakSelf release];
      return;
    }
    weakSelf.completion(data, nil);
    [weakSelf release];
  }];
  [dataTask resume];
}

@end
