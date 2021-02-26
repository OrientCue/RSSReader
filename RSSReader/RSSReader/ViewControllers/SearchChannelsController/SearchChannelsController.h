//
//  SearchChannelsController.h
//  RSSReader
//
//  Created by Arseniy Strakh on 23.11.2020.
//

#import <UIKit/UIKit.h>
#import "SearchChannelsViewType.h"

@class RSSChannel;
@protocol SearchChannelsPresenterType;

@interface SearchChannelsController : UIViewController <SearchChannelsViewType>
- (instancetype)initWithPresenter:(id<SearchChannelsPresenterType>)presenter;
@end
