//
//  ChannelsCoordinator.m
//  RSSReader
//
//  Created by Arseniy Strakh on 29.12.2020.
//

#import "ChannelsCoordinator.h"
#import "ChannelsPresenter.h"
#import "ChannelsViewController.h"
#import "ChannelsLocalStorageService.h"

@interface ChannelsCoordinator ()
@property (nonatomic, assign) UINavigationController *navigationController;
@property (nonatomic, assign) UIViewController<ChannelsViewType> *channelsViewController;
@end

@implementation ChannelsCoordinator

#pragma mark - Object Lifecycle

+ (instancetype)coordinatorWithNavigationController:(UINavigationController *)navigationController {
  ChannelsCoordinator *coordinator = [ChannelsCoordinator new];
  coordinator.navigationController = navigationController;
  return [coordinator autorelease];
}

#pragma mark -Coordinator Type

- (void)launch {
  self.channelsViewController = [self makeChannelsViewController];
  [self.navigationController pushViewController:self.channelsViewController
                                       animated:false];
}

#pragma mark - Factory

- (ChannelsViewController *)makeChannelsViewController {
  ChannelsPresenter *presenter = [[[ChannelsPresenter alloc] initWithLocalStorageService:ChannelsLocalStorageService.shared] autorelease];
  ChannelsViewController *channelsViewController = [[ChannelsViewController alloc] initWithPresenter:presenter];
  __block typeof(self) weakSelf = self;
  channelsViewController.didSelectChannelHandler = ^(RSSChannel *channel) {
    [weakSelf.splitCoordinator didSelectChannel:channel];
  };
  channelsViewController.didTapAddButtonHandler = ^{
    [weakSelf.splitCoordinator didTapAddButton];
  };
  channelsViewController.displayErrorHandler = ^(NSError *error) {
    [weakSelf.splitCoordinator displayError:error];
  };
  return [channelsViewController autorelease];
}

@end
