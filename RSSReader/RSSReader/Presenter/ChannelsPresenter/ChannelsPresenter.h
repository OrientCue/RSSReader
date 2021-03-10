//
//  ChannelsPresenter.h
//  RSSReader
//
//  Created by Arseniy Strakh on 19.12.2020.
//

#import <Foundation/Foundation.h>
#import "ChannelsPresenterType.h"
#import "ChannelsLocalStorageServiceType.h"

@interface ChannelsPresenter : NSObject <ChannelsPresenterType>
@property (nonatomic, weak) id<ChannelsViewType> view;
@property (nonatomic, strong, readonly) id<ChannelsLocalStorageServiceType> service;
- (instancetype)initWithLocalStorageService:(id<ChannelsLocalStorageServiceType>)service;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
