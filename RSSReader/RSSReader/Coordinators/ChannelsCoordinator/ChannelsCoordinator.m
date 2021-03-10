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
@property (nonatomic, strong) UIViewController<ChannelsViewType> *channelsViewController;
@end

@implementation ChannelsCoordinator

#pragma mark -Coordinator Type

- (void)launch {
    self.channelsViewController = [self makeChannelsViewController];
    [self.navigationController pushViewController:self.channelsViewController
                                         animated:false];
}

#pragma mark - Factory

- (ChannelsViewController *)makeChannelsViewController {
    ChannelsPresenter *presenter = [[ChannelsPresenter alloc] initWithLocalStorageService:ChannelsLocalStorageService.shared];
    ChannelsViewController *channelsViewController = [[ChannelsViewController alloc] initWithPresenter:presenter];
    __weak typeof(self) weakSelf = self;
    channelsViewController.didSelectChannelHandler = ^(RSSChannel *channel) {
        [weakSelf.splitCoordinator didSelectChannel:channel];
    };
    channelsViewController.didTapAddButtonHandler = ^{
        [weakSelf.splitCoordinator didTapAddButton];
    };
    return channelsViewController;
}

@end
