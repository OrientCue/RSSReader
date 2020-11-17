//
//  MainCoordinator.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
//#import "ContainerViewControllerType.h"
#import <UIKit/UIKit.h>

@interface MainCoordinator : NSObject
//@property (nonatomic, retain) id<ContainerViewControllerType> container;
//- (instancetype)initWith:(id<ContainerViewControllerType>)container;
@property (nonatomic, retain) UINavigationController *navigation;
- (instancetype)initWithNavigation:(UINavigationController *)navigation;
- (void)start;
- (void)displayURL:(NSURL *)url;
@end
