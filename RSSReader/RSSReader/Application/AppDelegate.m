//
//  AppDelegate.m
//  RSSReader
//
//  Created by Arseniy Strakh on 16.11.2020.
//

#import "AppDelegate.h"
#import "FeedCoordinator.h"

@interface AppDelegate ()
@property (nonatomic, retain) id<CoordinatorType> coordinator;
@end

@implementation AppDelegate

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds] autorelease];
  UINavigationController *navigationController = [[UINavigationController new] autorelease];
  self.window.rootViewController = navigationController;
  self.coordinator = [FeedCoordinator coordinatorWithNavigationController:navigationController];
  [self.coordinator launch];
  [self.window makeKeyAndVisible];
  return YES;
}

#pragma mark -

- (void)dealloc {
  [_window release];
  [_coordinator release];
  [super dealloc];
}

@end
