//
//  NavigationCoordinator.m
//  RSSReader
//
//  Created by Arseniy Strakh on 19.02.2021.
//

#import "NavigationCoordinator.h"

@interface NavigationCoordinator () <UINavigationControllerDelegate>
@property (nonatomic, strong) UINavigationController *navigationController;
@end

@implementation NavigationCoordinator

#pragma mark - Lazy Properties

- (UINavigationController *)navigationController {
    if (!_navigationController) {
        _navigationController = [UINavigationController new];
        _navigationController.delegate = self;
    }
    return _navigationController;
}

/// Base class does nothing
- (void)launch { }

@end
