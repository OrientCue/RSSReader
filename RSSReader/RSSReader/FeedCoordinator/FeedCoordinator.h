//
//  FeedCoordinator.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FeedCoordinatorType.h"

@interface FeedCoordinator : NSObject <FeedCoordinatorType>
@property (nonatomic, readonly, retain) UINavigationController *navigationController;
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;
@end
