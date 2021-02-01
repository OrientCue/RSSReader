//
//  ChannelsCoordinator.h
//  RSSReader
//
//  Created by Arseniy Strakh on 29.12.2020.
//

#import <Foundation/Foundation.h>
#import "CoordinatorType.h"
#import "SplitCoordinator.h"
#import "ChannelsViewType.h"

@interface ChannelsCoordinator : NSObject <CoordinatorType>
@property (nonatomic, assign, readonly) UIViewController<ChannelsViewType> *channelsViewController;
@property (nonatomic, assign, readonly) UINavigationController *navigationController;
@property (nonatomic, assign) SplitCoordinator *splitCoordinator;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)coordinatorWithNavigationController:(UINavigationController *)navigationController;
@end
