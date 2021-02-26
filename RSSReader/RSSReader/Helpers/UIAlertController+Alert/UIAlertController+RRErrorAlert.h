//
//  UIAlertController+RRErrorAlert.h
//  RSSReader
//
//  Created by Arseniy Strakh on 25.11.2020.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (RRErrorAlert)
+ (void)showError:(NSError *)error sourceViewController:(UIViewController *)viewController
          handler:(void (^)(UIAlertAction *action))handler ;
@end
