//
//  FeedCoordinator.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import "CoordinatorType.h"
#import "FeedViewType.h"
#import "SplitCoordinator.h"

@interface FeedCoordinator : NSObject <CoordinatorType>
@property (nonatomic, assign, readonly) UIViewController<FeedViewType> *feedController;
@property (nonatomic, retain, readonly) UINavigationController *navigationController;
@property (nonatomic, assign) SplitCoordinator *splitCoordinator;
@end
