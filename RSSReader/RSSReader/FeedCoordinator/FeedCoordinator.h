//
//  FeedCoordinator.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import "CoordinatorType.h"

@interface FeedCoordinator : NSObject <CoordinatorType>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)coordinatorWithNavigationController:(UINavigationController *)navigationController;
@end
