//
//  DownloaderNSThread.m
//  RSSReader
//
//  Created by Arseniy Strakh on 19.11.2020.
//

#import "DownloaderNSThread.h"

@interface DownloaderNSThread ()
@property (nonatomic, copy) DownloaderCompletion completion;
@property (nonatomic, retain) NSURL *url;
@end

@implementation DownloaderNSThread

#pragma mark - NSObject

- (void)dealloc {
  [_completion release];
  [_url release];
  [super dealloc];
}

#pragma mark - FeedDownloaderType

- (void)downloadFromUrl:(NSURL *)url completion:(DownloaderCompletion)completion {
  assert(completion);  // Completion will be called later, therefore it should not be nil.
  assert(url); // Can't download for nil url.
  self.completion = completion;
  self.url = url;
  [self detachThreadWithDownloadSEL];
}

#pragma mark - Private Methods

- (void)detachThreadWithDownloadSEL {
  [NSThread detachNewThreadSelector:@selector(download)
                           toTarget:self
                         withObject:nil];
}

- (void)download {
  @autoreleasepool {
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:self.url
                                         options:NSDataReadingMappedAlways
                                           error:&error];
    self.completion(data, error);
  }
}

@end
