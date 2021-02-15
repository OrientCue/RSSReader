//
//  FeedNetworkService.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import "FeedNetworkServiceType.h"

@protocol FeedParserType;

@interface FeedNetworkService : NSObject <FeedNetworkServiceType>
- (instancetype)initWithParser:(id<FeedParserType>)parser;
@end
