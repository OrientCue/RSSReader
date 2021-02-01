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
#import "RRBrowserViewController.h"

@interface FeedCoordinator () <UINavigationControllerDelegate>
@property (nonatomic, assign) UIViewController<FeedViewType> *feedController;
@property (nonatomic, assign) UINavigationController *navigationController;
@end

@implementation FeedCoordinator

+ (instancetype)coordinatorWithNavigationController:(UINavigationController *)navigationController {
  FeedCoordinator *coordinator = [FeedCoordinator new];
  coordinator.navigationController = navigationController;
  coordinator.navigationController.delegate = coordinator;
  return [coordinator autorelease];
}

#pragma mark - CoordinatorType

- (void)launch {
  __block typeof(self) weakSelf = self;
  self.feedController = [self makeFeedTableViewControllerWithDisplayURLHandler:^(NSURL *url) {
    [weakSelf displayURL:url];
  } displayErrorHandler:^(NSError *error) {
    [weakSelf.splitCoordinator displayError:error];
  }];
  [self.navigationController pushViewController:self.feedController animated:false];
}

#pragma mark - DisplayURL

- (void)displayURL:(NSURL *)url {
  RRBrowserViewController *browser = [[[RRBrowserViewController alloc] initWithUrl:url] autorelease];
  [self.navigationController pushViewController:browser animated:true];
}

#pragma mark - Factory

- (FeedTableViewController *)makeFeedTableViewControllerWithDisplayURLHandler:(DisplayURLHandler)displayURLHandler
                                                          displayErrorHandler:(DisplayErrorHandler)displayErrorHandler {
  AtomParser *parser = [[AtomParser new] autorelease];
  FeedNetworkService *networkService = [[[FeedNetworkService alloc] initWithParser:parser] autorelease];
  FeedPresenter *feedPresenter = [[[FeedPresenter alloc] initWithNetworkService:networkService] autorelease];
  FeedTableViewController *view = [[FeedTableViewController alloc] initWithPresenter:feedPresenter
                                                                   displayURLHandler:displayURLHandler
                                                                 displayErrorHandler:displayErrorHandler];
  return [view autorelease];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
  self.navigationController.toolbarHidden = ![viewController isKindOfClass:[RRBrowserViewController class]];
}

@end
