//
//  FeedCoordinator.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import "CoordinatorType.h"
#import "FeedViewType.h"

@interface FeedCoordinator : NSObject <CoordinatorType>
@property (nonatomic, assign, readonly) UIViewController<FeedViewType> *feedController;
@property (nonatomic, assign, readonly) UINavigationController *navigationController;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)coordinatorWithNavigationController:(UINavigationController *)navigationController;
@end
