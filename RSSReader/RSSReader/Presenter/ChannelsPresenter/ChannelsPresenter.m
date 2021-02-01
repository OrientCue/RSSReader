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
@property (nonatomic, retain) id<ChannelsLocalStorageServiceType> service;
@end

@implementation ChannelsPresenter

#pragma mark - Object Lifecycle

- (instancetype)init {
  if (self = [super init]) {
    _service = ChannelsLocalStorageService.shared;
  }
  return self;
}

- (void)dealloc {
  [_service release];
  [super dealloc];
}

- (void)setup {
  __block typeof(self) weakSelf = self;
  [self.service addListenerHandler:^{
    [weakSelf updateFromLocalStorage];
  }];
}

#pragma mark -

- (void)loadFromLocalStorage {
  NSError *error = nil;
  SettingsStore *store = [self.service loadSavedStoreError:&error];
  if (error) {
    NSLog(@"%@", error.localizedDescription);
  }
  [self.view displayFeedForChannels:store.channels selected:store.selectedChannel];
}

- (void)updateFromLocalStorage {
  NSError *error = nil;
  SettingsStore *store = [self.service loadSavedStoreError:&error];
  if (error) {
    NSLog(@"%@", error.localizedDescription);
  }
  [self.view update:store.channels selected:store.selectedChannel];
}

- (void)removeChannelFromLocalStorage:(RSSChannel *)channel {
  NSError *error = nil;
  [self.service removeChannel:channel error:&error];
  if (error) {
    NSLog(@"%@", error.localizedDescription);
  }
}

- (void)updateStorageWithSelectedIndex:(NSUInteger)index {
  NSError *error = nil;
  [self.service updateStoreWithSelected:index error:&error];
  if (error) {
    NSLog(@"%@", error.localizedDescription);
  }
}

@end
