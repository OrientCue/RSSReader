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
@property (nonatomic, assign) id<ChannelsViewType> view;
@property (nonatomic, retain, readonly) id<ChannelsLocalStorageServiceType> service;
@end
