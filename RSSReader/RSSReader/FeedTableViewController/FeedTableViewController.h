//
//  FeedTableViewController.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <UIKit/UIKit.h>
#import "FeedViewType.h"
#import "FeedPresenterType.h"

@class Article;
@interface FeedTableViewController : UITableViewController <FeedViewType>
@property (nonatomic, retain) NSArray<Article *> *articles;
@property (nonatomic, retain) id<FeedPresenterType> presenter;
@property (nonatomic, assign) id coordinator;

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter;
@end
