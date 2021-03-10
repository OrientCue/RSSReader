//
//  ChannelsPresenter.m
//  RSSReader
//
//  Created by Arseniy Strakh on 19.12.2020.
//

#import "ChannelsPresenter.h"
#import "ChannelsViewType.h"
#import "ChannelsLocalStorageService.h"
#import "SettingsStore.h"

@interface ChannelsPresenter ()
@property (nonatomic, strong) id<ChannelsLocalStorageServiceType> service;
@end

@implementation ChannelsPresenter

#pragma mark - Object Lifecycle

- (instancetype)initWithLocalStorageService:(id<ChannelsLocalStorageServiceType>)service {
    if (self = [super init]) {
        _service = service;
    }
    return self;
}

#pragma mark -

- (void)setup {
    __weak typeof(self) weakSelf = self;
    [self.service addListenerHandler:^{
        [weakSelf updateFromLocalStorage];
    }];
}

#pragma mark - ChannelsPresenterType

- (void)loadFromLocalStorage {
    NSError *error = nil;
    SettingsStore *store = [self.service loadSavedStoreError:&error];
    if (error) {
        [self.view displayError:error];
    } else {
        [self.view displayFeedForChannels:store.channels selected:store.selectedChannel];
    }
}

- (void)updateFromLocalStorage {
    NSError *error = nil;
    SettingsStore *store = [self.service loadSavedStoreError:&error];
    if (error) {
        [self.view displayError:error];
    } else {
        [self.view update:store.channels selected:store.selectedChannel];
    }
}

- (void)removeChannelFromLocalStorage:(RSSChannel *)channel {
    NSError *error = nil;
    [self.service removeChannel:channel error:&error];
    if (error) {
        [self.view displayError:error];
    }
}

- (void)updateStorageWithSelectedIndex:(NSUInteger)index {
    NSError *error = nil;
    [self.service updateStoreWithSelected:index error:&error];
    if (error) {
        [self.view displayError:error];
    }
}

@end
