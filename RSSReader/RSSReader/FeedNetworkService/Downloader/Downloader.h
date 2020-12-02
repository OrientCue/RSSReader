//
//  Downloader.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import "DownloaderType.h"

@interface Downloader : NSObject <DownloaderType>

- (instancetype)initWithURLSession:(NSURLSession *)session NS_DESIGNATED_INITIALIZER;

/// Downloader with URLSession.sharedSession
- (instancetype)init;

@end
