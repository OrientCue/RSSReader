//
//  ChannelsLocalStorageServiceType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 19.12.2020.
//

#import <Foundation/Foundation.h>

typedef void(^LocalStorageUpdateListenerHandler)(void);

@class RSSChannel;
@class SettingsStore;

@protocol ChannelsLocalStorageServiceType <NSObject>
- (SettingsStore *)loadSavedStoreError:(NSError **)error;
- (BOOL)removeChannel:(RSSChannel *)channel error:(NSError **)error;
- (BOOL)addChannels:(NSArray<RSSChannel *> *)channels lastSelected:(BOOL)selected error:(NSError **)error;
- (BOOL)containsChannel:(RSSChannel *)channel;
- (BOOL)updateStoreWithSelected:(NSUInteger)index error:(NSError **)error;

- (void)addListenerHandler:(LocalStorageUpdateListenerHandler)handler;
@end
