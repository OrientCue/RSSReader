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
@property (nonatomic, retain) id<DownloaderType> downloader;
@property (nonatomic, retain) id<FeedParserType> parser;
- (instancetype)initWithDownloader:(id<DownloaderType>)downloader
                            parser:(id<FeedParserType>)parser;
@end
