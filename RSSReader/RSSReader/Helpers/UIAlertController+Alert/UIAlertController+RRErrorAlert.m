//
//  UIAlertController+RRErrorAlert.m
//  RSSReader
//
//  Created by Arseniy Strakh on 25.11.2020.
//

#import "UIAlertController+RRErrorAlert.h"

NSString *const kAlertErrorTitle = @"Error";
NSString *const kAlertOkButtonTitle = @"OK";

int64_t const kDeltaHideErrorAlert = 5 * NSEC_PER_SEC;

@implementation UIAlertController (RRErrorAlert)

+ (instancetype)rr_errorAlertWithMessage:(NSString *)message {
  UIAlertController *alertController =
  [UIAlertController alertControllerWithTitle:kAlertErrorTitle
                                      message:message
                               preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okAction =
  [UIAlertAction actionWithTitle:kAlertOkButtonTitle
                           style:UIAlertActionStyleCancel
                         handler:nil];
  [alertController addAction:okAction];
  return alertController;
}

- (void)autoHideWithDelay {
  __weak typeof(self) weakSelf = self;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kDeltaHideErrorAlert), dispatch_get_main_queue(), ^{
      [weakSelf dismissViewControllerAnimated:true completion:nil];
  });
}

@end
