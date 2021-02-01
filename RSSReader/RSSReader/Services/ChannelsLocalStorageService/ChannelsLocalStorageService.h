//
//  ChannelsLocalStorageService.h
//  RSSReader
//
//  Created by Arseniy Strakh on 19.12.2020.
//

#import <Foundation/Foundation.h>
#import "ChannelsLocalStorageServiceType.h"

@interface ChannelsLocalStorageService : NSObject <ChannelsLocalStorageServiceType>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)shared;
@end
