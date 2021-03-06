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
@property (nonatomic, strong) UISplitViewController *splitViewController;
@property (nonatomic, strong) FeedCoordinator *feedCoordinator;
@property (nonatomic, strong) ChannelsCoordinator *channelsCoordinator;
@end

@implementation SplitCoordinator

static const CGFloat kPreferredPrimaryColumnWidthFraction = 0.5;

#pragma mark - Object Lifecycle

+ (instancetype)coordinator {
    return [SplitCoordinator new];
}

#pragma mark - Lazy Properties

- (UISplitViewController *)splitViewController {
    if (!_splitViewController) {
        _splitViewController = [UISplitViewController new];
    }
    return _splitViewController;
}

- (FeedCoordinator *)feedCoordinator {
    if (!_feedCoordinator) {
        _feedCoordinator = [FeedCoordinator new];
        [_feedCoordinator launch];
    }
    return _feedCoordinator;
}

- (ChannelsCoordinator *)channelsCoordinator {
    if (!_channelsCoordinator) {
        _channelsCoordinator = [ChannelsCoordinator new];
        _channelsCoordinator.splitCoordinator = self;
        [_channelsCoordinator launch];
    }
    return _channelsCoordinator;
}


#pragma mark - Coordinator Type

- (void)launch {
    [self configureSplitViewController];
    
    UINavigationItem *navigationItem = self.feedCoordinator.feedController.navigationItem;
    navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    navigationItem.leftItemsSupplementBackButton = true;
    
    [self.channelsCoordinator.channelsViewController loadViewIfNeeded];
}

#pragma mark - Private Methods

- (void)configureSplitViewController {
    self.splitViewController.viewControllers = @[
        self.channelsCoordinator.navigationController,
        self.feedCoordinator.navigationController
    ];
    self.splitViewController.preferredPrimaryColumnWidthFraction = kPreferredPrimaryColumnWidthFraction;
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
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
    UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self.splitViewController presentViewController:searchNavigationController
                                           animated:true
                                         completion:nil];
}

#pragma mark - Factory

- (SearchChannelsController *)makeSearchChannelsController {
    AutodiscoveryRSS *service = [AutodiscoveryRSS new];
    SearchChannelsPresenter *presenter = [[SearchChannelsPresenter alloc] initWithSearchService:service
                                                                                   localStorage:ChannelsLocalStorageService.shared];
    return [[SearchChannelsController alloc] initWithPresenter:presenter];
}

@end
