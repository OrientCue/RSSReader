//
//  FeedCoordinatorFactory.m
//  RSSReader
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import "FeedCoordinatorFactory.h"

@implementation FeedCoordinatorFactory

+ (FeedCoordinator *)makeCoordinator {
  UINavigationController *navigationController = [[UINavigationController new] autorelease];
  FeedCoordinator *coordinator = [[FeedCoordinator alloc] initWithNavigationController:navigationController];
  return [coordinator autorelease];
}

@end
