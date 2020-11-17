//
//  ContainerViewControllerType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ContainerViewControllerType <NSObject>
- (void)display:(__kindof UIViewController *)viewController;
@end
