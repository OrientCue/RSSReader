//
//  UIAlertController+RRErrorAlert.m
//  RSSReader
//
//  Created by Arseniy Strakh on 25.11.2020.
//

#import "UIAlertController+RRErrorAlert.h"

NSString *const kAlertErrorTitle = @"Error";
NSString *const kAlertOkButtonTitle = @"OK";

@implementation UIAlertController (RRErrorAlert)

+ (instancetype)rr_actionSheetErrorWithMessage:(NSString *)message
                                 barButtonItem:(UIBarButtonItem *)barButtonItem {
  UIAlertController *alertController =
  [UIAlertController alertControllerWithTitle:kAlertErrorTitle
                                       message:message
                                preferredStyle:UIAlertControllerStyleActionSheet];
  alertController.popoverPresentationController.barButtonItem = barButtonItem;
  UIAlertAction *okAction =
  [UIAlertAction actionWithTitle:kAlertOkButtonTitle
                           style:UIAlertActionStyleCancel
                         handler:nil];
  [alertController addAction:okAction];
  return alertController;
}

@end
