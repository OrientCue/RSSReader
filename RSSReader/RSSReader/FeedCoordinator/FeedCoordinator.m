//
//  FeedCoordinator.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedCoordinator.h"
#import "FeedViewControllerFactory.h"

@implementation FeedCoordinator

#pragma mark - NSObject

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
  if (self = [super init]) {
    _navigationController = [navigationController retain];
  }
  return self;
}

- (void)dealloc {
  [_navigationController release];
  [super dealloc];
}

#pragma mark - Coordinator

- (void)start {
  FeedTableViewController *feed = [FeedViewControllerFactory controllerWithCoordinator:self];
  [self.navigationController pushViewController:feed animated:false];
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
