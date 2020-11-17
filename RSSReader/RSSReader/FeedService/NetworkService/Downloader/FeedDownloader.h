//
//  FeedDownloader.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import "FeedDownloaderType.h"

@interface FeedDownloader : NSObject <FeedDownloaderType>

- (instancetype)initWithURLSession:(NSURLSession *)session NS_DESIGNATED_INITIALIZER;

/// Downloader with URLSession.sharedSession
- (instancetype)init;

@end
