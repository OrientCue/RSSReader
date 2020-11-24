//
//  FeedCoordinatorFactory.h
//  RSSReader
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import <Foundation/Foundation.h>
#import "FeedCoordinator.h"

@interface FeedCoordinatorFactory : NSObject
+ (FeedCoordinator *)makeCoordinator;
@end

