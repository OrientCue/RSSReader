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
#import "ChannelsLocalStorageService.h"

@interface SearchChannelsPresenter : NSObject <SearchChannelsPresenterType>
@property (nonatomic, weak) id<SearchChannelsViewType> view;
- (instancetype)initWithSearchService:(id<SearchChannelsServiceType>)searchService
                         localStorage:(id<ChannelsLocalStorageServiceType>)localStorage;
@end
