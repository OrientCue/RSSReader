//
//  Downloader.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "Downloader.h"

@interface Downloader ()
@property (nonatomic, retain) NSURLSession *session;
@property (nonatomic, copy) DownloaderCompletion completion;
@end

@implementation Downloader

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

- (void)downloadFromUrl:(NSURL *)url completion:(DownloaderCompletion)completion {
  assert(completion);
  self.completion = completion;
  __block typeof(self) weakSelf = self;
  NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url
                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    weakSelf.completion(data, error);
  }];
  [dataTask resume];
}

@end
