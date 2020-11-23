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
#import "FeedDownloader.h"
#import "AtomParser.h"

@implementation FeedViewControllerFactory

+ (FeedTableViewController *)controllerWithCoordinator:(id<DisplayURLProtocol>)coordinator {
  FeedDownloader *downloader = [FeedDownloader new];
  AtomParser *parser = [AtomParser new];
  NetworkService *network = [[NetworkService alloc] initWithDownloader:downloader
                                                                parser:parser];
  [downloader release];
  [parser release];
  FeedService *service = [[FeedService alloc] initWith:network];
  [network release];
  FeedPresenter *presenter = [[FeedPresenter alloc] initWith:service];
  [service release];
  FeedTableViewController *view = [[FeedTableViewController alloc] initWithPresenter:presenter];
  [presenter release];
  presenter.view = view;
  view.coordinator = coordinator;
  return [view autorelease];
}

@end
