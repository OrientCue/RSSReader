//
//  SplitCoordinator.h
//  RSSReader
//
//  Created by Arseniy Strakh on 16.12.2020.
//

#import <Foundation/Foundation.h>
#import "CoordinatorType.h"

@class RSSChannel;

@interface SplitCoordinator : NSObject <CoordinatorType>
@property (nonatomic, strong, readonly) UISplitViewController *splitViewController;
+ (instancetype)coordinator;
- (void)didSelectChannel:(RSSChannel *)channel;
- (void)didTapAddButton;
@end
