//
//  SearchChannelsServiceType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 23.11.2020.
//

#import <Foundation/Foundation.h>

@class RSSChannel;
typedef void(^SearchSiteNameCompletion)(NSArray<RSSChannel *> *channels, NSError *error);
typedef void(^SearchLinkCompletion)(RSSChannel *channel, NSError *error);

@protocol SearchChannelsServiceType <NSObject>
- (void)searchChannelsForSiteName:(NSString *)siteName completion:(SearchSiteNameCompletion)completion;
- (void)searchChannelForLinkString:(NSString *)urlString
                        completion:(SearchLinkCompletion)completion;
- (void)cancelSearch;
@end
