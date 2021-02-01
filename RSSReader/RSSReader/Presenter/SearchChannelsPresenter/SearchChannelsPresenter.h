//
//  SearchChannelsPresenter.h
//  RSSReader
//
//  Created by Arseniy Strakh on 20.12.2020.
//

#import <Foundation/Foundation.h>
#import "SearchChannelsPresenterType.h"
#import "SearchChannelsServiceType.h"
#import "SearchChannelsViewType.h"

@interface SearchChannelsPresenter : NSObject <SearchChannelsPresenterType>
@property (nonatomic, assign) id<SearchChannelsViewType> view;
- (instancetype)initWithService:(id<SearchChannelsServiceType>)service;
@end
