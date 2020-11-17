//
//  AppDelegate.m
//  RSSReader
//
//  Created by Arseniy Strakh on 16.11.2020.
//

#import "AppDelegate.h"
#import "MainCoordinator.h"

@interface AppDelegate ()
@property (nonatomic, retain) MainCoordinator *coordinator;
@end

@implementation AppDelegate

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
  self.window = window;
  [window release];
  UINavigationController *navigationController = [UINavigationController new];
  MainCoordinator *coordinator = [[MainCoordinator alloc] initWithNavigation:navigationController];
  self.coordinator = coordinator;
  [coordinator release];
  [navigationController release];
  self.window.rootViewController = navigationController;
  [self.coordinator start];
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
