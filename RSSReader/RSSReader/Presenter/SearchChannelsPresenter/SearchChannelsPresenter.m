//
//  SearchChannelsPresenter.m
//  RSSReader
//
//  Created by Arseniy Strakh on 20.12.2020.
//

#import "SearchChannelsPresenter.h"
#import "ChannelsLocalStorageService.h"

@interface SearchChannelsPresenter ()
@property (nonatomic, retain) id<SearchChannelsServiceType> service;
@property (nonatomic, retain) id<ChannelsLocalStorageServiceType> localStorage;
@end

@implementation SearchChannelsPresenter

#pragma mark - Object Lifecycle

- (instancetype)initWithService:(id<SearchChannelsServiceType>)service {
  if (self = [super init]) {
    _service = [service retain];
    _localStorage = ChannelsLocalStorageService.shared;
  }
  return self;
}

- (void)dealloc {
  [_service release];
  [_localStorage release];
  [super dealloc];
}

#pragma mark -

- (void)searchChannelsForSiteName:(NSString *)siteName {
  [self.view showLoading];
  __block typeof(self) weakSelf = self;
  [self.service searchChannelsForSiteName:siteName completion:^(NSArray<RSSChannel *> *channels, NSError *error) {
    if (error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.view displayError:error];
        [weakSelf.view hideLoading];
      });
    } else {
      NSIndexSet *alreadyAdded = [weakSelf alreadyAddedChannelsIndexesForChannels:channels];
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.view applyChannels:channels alreadyAdded:alreadyAdded];
        [weakSelf.view hideLoading];
      });
    }
  }];
}

- (void)searchChannelForLinkString:(NSString *)linkString {
  [self.view showLoading];
  __block typeof(self) weakSelf = self;
  [self.service searchChannelForLinkString:linkString
                                completion:^(RSSChannel *channel, NSError *error) {
    if (error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.view displayError:error];
        [weakSelf.view hideLoading];
      });
    } else {
      NSIndexSet *alreadyAdded = [weakSelf alreadyAddedChannelsIndexesForChannels:@[channel]];
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.view applyChannels:@[channel] alreadyAdded:alreadyAdded];
        [weakSelf.view hideLoading];
      });
    }
  }];
}

- (void)cancelSearch {
  [self.service cancelSearch];
  [self.view hideLoading];
}

- (void)addChannelsToLocalStorage:(NSArray<RSSChannel *> *)channels {
  NSError *error = nil;
  [self.localStorage addChannels:channels lastSelected:true error:&error];
  if (error) {
    NSLog(@"%@", error.localizedDescription);
  }
}

#pragma mark - Private

- (NSIndexSet *)alreadyAddedChannelsIndexesForChannels:(NSArray<RSSChannel *> *)channels {
  NSMutableIndexSet *alreadyAdded = [NSMutableIndexSet indexSet];
  [channels enumerateObjectsUsingBlock:^(RSSChannel *obj, NSUInteger idx, BOOL *stop) {
    if ([self.localStorage containsChannel:obj]) {
      [alreadyAdded addIndex:idx];
    }
  }];
  return [[alreadyAdded copy] autorelease];
}

@end
