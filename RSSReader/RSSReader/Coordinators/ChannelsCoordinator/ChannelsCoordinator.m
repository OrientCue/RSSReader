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
@property (nonatomic, retain) UIViewController<ChannelsViewType> *channelsViewController;
@end

@implementation ChannelsCoordinator

- (void)dealloc {
  [_channelsViewController release];
  [super dealloc];
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
  return [channelsViewController autorelease];
}

@end
