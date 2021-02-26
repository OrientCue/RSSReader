//
//  NavigationCoordinator.h
//  RSSReader
//
//  Created by Arseniy Strakh on 19.02.2021.
//

#import <Foundation/Foundation.h>
#import "CoordinatorType.h"

/// Base class
@interface NavigationCoordinator : NSObject <CoordinatorType>
@property (nonatomic, strong, readonly) UINavigationController *navigationController;
@end
