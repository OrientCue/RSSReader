//
//  FeedPresenterType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

@protocol FeedViewType;

@protocol FeedPresenterType <NSObject>
@property (nonatomic, assign) id<FeedViewType> view;
- (void)fetchFeedFromURL:(NSURL *)url;
- (void)cancelFetch;
@end
