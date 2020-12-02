//
//  FeedNetworkService.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import "FeedNetworkServiceType.h"

@protocol DownloaderType, FeedParserType;

@interface FeedNetworkService : NSObject <FeedNetworkServiceType>
- (instancetype)initWithDownloader:(id<DownloaderType>)downloader
                            parser:(id<FeedParserType>)parser;
@end
