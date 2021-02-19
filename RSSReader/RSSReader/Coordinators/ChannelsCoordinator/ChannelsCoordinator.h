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
@property (nonatomic, retain, readonly) UINavigationController *navigationController;
@property (nonatomic, assign) SplitCoordinator *splitCoordinator;
@end
