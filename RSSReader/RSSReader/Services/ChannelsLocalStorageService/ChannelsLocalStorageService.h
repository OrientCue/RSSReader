//
//  ChannelsLocalStorageService.h
//  RSSReader
//
//  Created by Arseniy Strakh on 19.12.2020.
//

#import <Foundation/Foundation.h>
#import "ChannelsLocalStorageServiceType.h"

@interface ChannelsLocalStorageService : NSObject <ChannelsLocalStorageServiceType>
@property (class, readonly, retain) ChannelsLocalStorageService *shared;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)alloc NS_UNAVAILABLE;
@end
