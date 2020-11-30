//
//  FeedViewControllerFactory.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedViewControllerFactory.h"
#import "FeedPresenter.h"
#import "FeedService.h"
#import "NetworkService.h"
#import "Downloader.h"
#import "AtomParser.h"

@implementation FeedViewControllerFactory

+ (FeedTableViewController *)controllerWithCoordinator:(id<FeedCoordinatorType>)coordinator {
  FeedPresenter *presenter = [self makeFeedPresenter];
  FeedTableViewController *view = [[FeedTableViewController alloc] initWithPresenter:presenter
                                                                         coordinator:coordinator];
  return [view autorelease];
}

+ (FeedPresenter *)makeFeedPresenter {
  Downloader *downloader = [[Downloader new] autorelease];
  AtomParser *parser = [[AtomParser new] autorelease];
  NetworkService *network = [[[NetworkService alloc] initWithDownloader:downloader
                                                                 parser:parser] autorelease];
  FeedService *service = [[[FeedService alloc] initWith:network] autorelease];
  FeedPresenter *presenter = [[FeedPresenter alloc] initWith:service];
  return [presenter autorelease];
}

@end
