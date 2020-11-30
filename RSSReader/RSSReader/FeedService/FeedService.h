//
//  FeedService.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import "FeedServiceType.h"

@protocol NetworkServiceType;

@interface FeedService : NSObject <FeedServiceType>
- (instancetype)initWith:(id<NetworkServiceType>)networkService;
@end
