//
//  AppDelegate.m
//  RSSReader
//
//  Created by Arseniy Strakh on 16.11.2020.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
  self.window = window;
  [window release];
  ViewController *vc = [ViewController new];
  vc.view.backgroundColor = UIColor.grayColor;
  self.window.rootViewController = vc;
  [vc release];
  [self.window makeKeyAndVisible];
  return YES;
}

#pragma mark -

- (void)dealloc {
  [_window release];
  [super dealloc];
}

@end
