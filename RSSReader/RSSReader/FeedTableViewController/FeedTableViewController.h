//
//  FeedTableViewController.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <UIKit/UIKit.h>
#import "FeedViewType.h"

typedef void(^DisplayURLHandler)(NSURL *url);
typedef void(^DisplayErrorHandler)(NSError *error, UIBarButtonItem *barButtonItem);

@protocol FeedPresenterType;
@class AtomFeedItem;

@interface FeedTableViewController : UIViewController <FeedViewType>

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter
                displayURLHandler:(DisplayURLHandler)displayURLHandler
              displayErrorHandler:(DisplayErrorHandler)displayErrorHandler;
@end
