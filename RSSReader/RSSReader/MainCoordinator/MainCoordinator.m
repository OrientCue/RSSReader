//
//  MainCoordinator.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "MainCoordinator.h"
#import "FeedViewControllerFactory.h"

@implementation MainCoordinator

#pragma mark - NSObject

- (instancetype)initWithNavigation:(UINavigationController *)navigation {
  if (self = [super init]) {
    _navigation = [navigation retain];
  }
  return self;
}

- (void)dealloc {
  [_navigation release];
  [super dealloc];
}

#pragma mark - Coordinator

- (void)start {
  FeedTableViewController *feed = [FeedViewControllerFactory make];
  feed.coordinator = self;
  [self.navigation pushViewController:feed animated:false];
}

#pragma mark - DisplayURLProtocol

- (void)displayURL:(NSURL *)url {
  [[UIApplication sharedApplication] openURL:url
                                     options:@{}
                           completionHandler:^(BOOL success) {
    NSLog(@"%@", success ? @"success" : @"failure");
  }];
}

@end
