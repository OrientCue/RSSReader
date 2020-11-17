//
//  FeedViewControllerFactory.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import "FeedTableViewController.h"

@interface FeedViewControllerFactory : NSObject

+ (FeedTableViewController *)make;

@end
