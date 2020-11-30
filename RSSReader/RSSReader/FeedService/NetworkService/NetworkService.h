//
//  NetworkService.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import "NetworkServiceType.h"
#import "DownloaderType.h"
#import "FeedParserType.h"

@interface NetworkService : NSObject <NetworkServiceType>
- (instancetype)initWithDownloader:(id<DownloaderType>)downloader
                            parser:(id<FeedParserType>)parser;
@end
