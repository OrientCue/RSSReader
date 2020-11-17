//
//  MainCoordinator.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "MainCoordinator.h"
#import "FeedViewControllerFactory.h"

@implementation MainCoordinator
//
//- (instancetype)initWith:(id<ContainerViewControllerType>)container {
//  if (self = [super init]) {
//    _container = [container retain];
//  }
//  return self;
//}


- (instancetype)initWithNavigation:(UINavigationController *)navigation {
  if (self = [super init]) {
    _navigation = [navigation retain];
  }
  return self;
}

- (void)start {
  FeedTableViewController *feed = [FeedViewControllerFactory make];
  feed.coordinator = self;
  [self.navigation pushViewController:feed animated:false];
}


- (void)displayURL:(NSURL *)url {
  [[UIApplication sharedApplication] openURL:url
                                     options:@{}
                           completionHandler:^(BOOL success) {
    NSLog(@"%@", success ? @"success" : @"failure");
  }];
}

- (void)dealloc {
  [_navigation release];
  [super dealloc];
}

@end
