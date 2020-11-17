//
//  FeedDownloader.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedDownloader.h"

@implementation FeedDownloader

- (void)downloadFromUrl:(NSURL *)url completion:(FeedDownloaderCompletion)completion {
  dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url
                                         options:NSDataReadingMappedIfSafe
                                           error:&error];
    if (error) {
      completion(nil, error);
      return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      completion(data, nil);
    });
  });
}

@end
