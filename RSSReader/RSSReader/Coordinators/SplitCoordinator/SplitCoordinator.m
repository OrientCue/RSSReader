//
//  SplitCoordinator.m
//  RSSReader
//
//  Created by Arseniy Strakh on 16.12.2020.
//

#import "SplitCoordinator.h"
#import "FeedCoordinator.h"
#import "ChannelsCoordinator.h"

#import "SearchChannelsController.h"
#import "AutodiscoveryRSS.h"
#import "SearchChannelsPresenter.h"

@interface SplitCoordinator () <UISplitViewControllerDelegate>
@property (nonatomic, assign) UISplitViewController *splitViewController;
@property (nonatomic, retain) FeedCoordinator *feedCoordinator;
@property (nonatomic, retain) ChannelsCoordinator *channelsCoordinator;
@end

@implementation SplitCoordinator

static const CGFloat kPreferredPrimaryColumnWidthFraction = 0.5;

#pragma mark - Object Lifecycle

+ (instancetype)coordinatorWithSplitViewController:(UISplitViewController *)splitViewController {
  SplitCoordinator *coordinator = [SplitCoordinator new];
  coordinator.splitViewController = splitViewController;
  return [coordinator autorelease];
}

- (void)dealloc {
  [_feedCoordinator release];
  [_channelsCoordinator release];
  [super dealloc];
}

#pragma mark - Coordinator Type

- (void)launch {
  UINavigationController *channelsNavigationController = [[UINavigationController new] autorelease];
  self.channelsCoordinator = [ChannelsCoordinator coordinatorWithNavigationController:channelsNavigationController];
  self.channelsCoordinator.splitCoordinator = self;
  [self.channelsCoordinator launch];
  
  UINavigationController *feedNavigationController = [[UINavigationController new] autorelease];
  self.feedCoordinator = [FeedCoordinator coordinatorWithNavigationController:feedNavigationController];
  [self.feedCoordinator launch];
  
  self.splitViewController.viewControllers = @[channelsNavigationController, feedNavigationController];
  self.splitViewController.preferredPrimaryColumnWidthFraction = kPreferredPrimaryColumnWidthFraction;
  self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
  
  UINavigationItem *navigationItem = feedNavigationController.topViewController.navigationItem;
  navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
  navigationItem.leftItemsSupplementBackButton = true;
  [self.channelsCoordinator.channelsViewController loadViewIfNeeded];
}

#pragma mark -

- (void)didSelectChannel:(RSSChannel *)channel {
  if (self.splitViewController.traitCollection.userInterfaceIdiom != UIUserInterfaceIdiomPad) {
    [self.splitViewController showDetailViewController:self.feedCoordinator.navigationController sender:nil];
  }
  [self.feedCoordinator.feedController feedForChannel:channel];
}

- (void)didTapAddButton {
  SearchChannelsController *searchViewController = [self makeSearchChannelsController];
  UINavigationController *searchNavigationController = [[[UINavigationController alloc] initWithRootViewController:searchViewController] autorelease];
  [self.splitViewController presentViewController:searchNavigationController
                                         animated:true
                                       completion:nil];
}

#pragma mark - Factory

- (SearchChannelsController *)makeSearchChannelsController {
  AutodiscoveryRSS *service = [[AutodiscoveryRSS new] autorelease];
  SearchChannelsPresenter *presenter = [[[SearchChannelsPresenter alloc] initWithService:service] autorelease];
  return [[[SearchChannelsController alloc] initWithPresenter:presenter] autorelease];
}

@end
