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
@property (nonatomic, readonly, retain) id<DownloaderType> downloader;
- (instancetype)initWithParser:(id<FeedParserType>)parser;
@end
