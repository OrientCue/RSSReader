//
//  FeedViewControllerFactory.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedViewControllerFactory.h"
#import "FeedPresenter.h"
#import "FeedNetworkService.h"
#import "Downloader.h"
#import "AtomParser.h"

@implementation FeedViewControllerFactory

+ (FeedTableViewController *)controllerWithCoordinator:(id<FeedCoordinatorType>)coordinator {
  FeedPresenter *feedPresenter = [self makeFeedPresenter];
  FeedTableViewController *view = [[FeedTableViewController alloc] initWithPresenter:feedPresenter
                                                                         coordinator:coordinator];
  return [view autorelease];
}

+ (FeedPresenter *)makeFeedPresenter {
  Downloader *downloader = [[Downloader new] autorelease];
  AtomParser *parser = [[AtomParser new] autorelease];
  FeedNetworkService *networkService = [[[FeedNetworkService alloc] initWithDownloader:downloader
                                                                 parser:parser] autorelease];
  FeedPresenter *feedPresenter = [[FeedPresenter alloc] initWith:networkService];
  return [feedPresenter autorelease];
}

@end
