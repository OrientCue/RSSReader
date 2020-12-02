//
//  FeedPresenter.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import "FeedPresenterType.h"

@protocol FeedNetworkServiceType, FeedViewType;

@interface FeedPresenter : NSObject <FeedPresenterType>
@property (nonatomic, assign) id<FeedViewType> view;
- (instancetype)initWith:(id<FeedNetworkServiceType>)service;
@end
