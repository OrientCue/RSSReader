//
//  FeedPresenter.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import "FeedPresenterType.h"
#import "FeedViewType.h"
#import "FeedServiceType.h"

@interface FeedPresenter : NSObject <FeedPresenterType>

@property (nonatomic, assign) id<FeedViewType> view;

- (instancetype)initWith:(id<FeedServiceType>)service;

@end
