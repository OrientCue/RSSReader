//
//  FeedCoordinator.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import "NavigationCoordinator.h"
#import "FeedViewType.h"
#import "SplitCoordinator.h"

@interface FeedCoordinator : NavigationCoordinator
@property (nonatomic, retain, readonly) UIViewController<FeedViewType> *feedController;
@end
