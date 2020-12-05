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
#import "UIAlertController+RRErrorAlert.h"

int64_t const kDeltaHideErrorActionSheet = 5 * NSEC_PER_SEC;

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
  } displayErrorHandler:^(NSError *error) {
    [weakSelf displayError:error];
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

#pragma mark - DisplayError

- (void)displayError:(NSError *)error {
  UIAlertController *alertController =
  [UIAlertController rr_actionSheetErrorWithMessage:error.localizedDescription];
  [self.navigationController presentViewController:alertController
                                          animated:YES
                                        completion:^{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kDeltaHideErrorActionSheet), dispatch_get_main_queue(), ^{
      [alertController dismissViewControllerAnimated:true completion:nil];
    });
  }];
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

@end
