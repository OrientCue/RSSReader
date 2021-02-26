//
//  ChannelsCoordinator.h
//  RSSReader
//
//  Created by Arseniy Strakh on 29.12.2020.
//

#import <Foundation/Foundation.h>
#import "NavigationCoordinator.h"
#import "SplitCoordinator.h"
#import "ChannelsViewType.h"

@interface ChannelsCoordinator : NavigationCoordinator
@property (nonatomic, strong, readonly) UIViewController<ChannelsViewType> *channelsViewController;
@property (nonatomic, weak) SplitCoordinator *splitCoordinator;
@end
