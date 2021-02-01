//
//  SearchChannelsViewType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 23.11.2020.
//

#import <Foundation/Foundation.h>

@class RSSChannel;
@protocol SearchChannelsViewType <NSObject>
- (void)showLoading;
- (void)hideLoading;
- (void)applyChannels:(NSArray<RSSChannel *> *)channels alreadyAdded:(NSIndexSet *)alreadyAdded;
@end
