//
//  NetworkService.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import "NetworkServiceType.h"
#import "FeedDownloaderType.h"
#import "FeedParserType.h"

@interface NetworkService : NSObject <NetworkServiceType>
@property (nonatomic, retain) id<FeedDownloaderType> downloader;
@property (nonatomic, retain) id<FeedParserType> parser;
- (instancetype)initWithDownloader:(id<FeedDownloaderType>)downloader
                            parser:(id<FeedParserType>)parser;
@end
