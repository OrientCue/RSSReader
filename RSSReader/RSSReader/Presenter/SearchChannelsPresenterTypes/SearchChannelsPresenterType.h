//
//  SearchChannelsPresenterType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 23.11.2020.
//

#import <Foundation/Foundation.h>

@protocol SearchChannelsViewType;
@class RSSChannel;

@protocol SearchChannelsPresenterType <NSObject>
@property (nonatomic, assign) id<SearchChannelsViewType> view;
- (void)searchChannelsForSiteName:(NSString *)siteName;
- (void)searchChannelForLinkString:(NSString *)linkString;
- (void)addChannelsToLocalStorage:(NSArray<RSSChannel *> *)channels;
- (void)cancelSearch;
@end
