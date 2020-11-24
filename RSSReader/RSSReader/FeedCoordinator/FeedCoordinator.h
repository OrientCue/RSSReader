//
//  FeedCoordinator.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DisplayURLProtocol.h"

@interface FeedCoordinator : NSObject <DisplayURLProtocol>
@property (nonatomic, retain) UINavigationController *navigationController;
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;
- (void)start;
@end
