//
//  FeedTableViewController.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <UIKit/UIKit.h>
#import "FeedViewType.h"
#import "FeedPresenterType.h"
#import "DisplayURLProtocol.h"

@class AtomFeedItem;
@interface FeedTableViewController : UITableViewController <FeedViewType>
@property (nonatomic, retain) NSArray<AtomFeedItem *> *items;
@property (nonatomic, retain) id<FeedPresenterType> presenter;
@property (nonatomic, assign) id<DisplayURLProtocol> coordinator;

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter;
@end
