//
//  FeedCoordinator.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedCoordinator.h"
#import "FeedTableViewController.h"
#import "FeedPresenter.h"
#import "FeedNetworkService.h"
#import "AtomParser.h"

@interface FeedCoordinator ()
@property (nonatomic, assign) UINavigationController *navigationController;
@end

@implementation FeedCoordinator

+ (instancetype)coordinatorWithNavigationController:(UINavigationController *)navigationController {
  FeedCoordinator *coordinator = [FeedCoordinator new];
  coordinator.navigationController = navigationController;
  return [coordinator autorelease];
}

#pragma mark - CoordinatorType

- (void)launch {
  __block typeof(self) weakSelf = self;
  FeedTableViewController *feed = [self makeFeedTableViewControllerWithDisplayURLHandler:^(NSURL *url) {
    [weakSelf displayURL:url];
  }];
  [self.navigationController pushViewController:feed animated:false];
}

#pragma mark - DisplayURL

- (void)displayURL:(NSURL *)url {
  [[UIApplication sharedApplication] openURL:url
                                     options:@{}
                           completionHandler:^(BOOL success) {
    NSLog(@"%@", success ? @"success" : @"failure");
  }];
}

#pragma mark - Factory

- (FeedTableViewController *)makeFeedTableViewControllerWithDisplayURLHandler:(DisplayURLHandler)displayURLHandler {
  AtomParser *parser = [[AtomParser new] autorelease];
  FeedNetworkService *networkService = [[[FeedNetworkService alloc] initWithParser:parser] autorelease];
  FeedPresenter *feedPresenter = [[[FeedPresenter alloc] initWithNetworkService:networkService] autorelease];
  FeedTableViewController *view = [[FeedTableViewController alloc] initWithPresenter:feedPresenter
                                                                   displayURLHandler:displayURLHandler];
  return [view autorelease];
}

@end
