//
//  FeedTableViewController.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <UIKit/UIKit.h>
#import "FeedViewType.h"
#import "FeedPresenterType.h"
#import "FeedCoordinatorType.h"

@class AtomFeedItem;
@interface FeedTableViewController : UIViewController <FeedViewType>
@property (nonatomic, readonly, retain) id<FeedPresenterType> presenter;
@property (nonatomic, readonly, assign) id<FeedCoordinatorType> coordinator;

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter
                      coordinator:(id<FeedCoordinatorType>)coordinator;
@end
