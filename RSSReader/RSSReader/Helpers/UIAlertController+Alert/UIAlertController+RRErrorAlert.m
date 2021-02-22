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

+ (void)showError:(NSError *)error sourceViewController:(UIViewController *)viewController handler:(void (^)(UIAlertAction *action))handler {
    UIAlertController *alertController = [UIAlertController rr_errorAlertWithMessage:error.localizedDescription handler:handler];
    [viewController presentViewController:alertController
                                 animated:YES
                               completion:^{
        [alertController rr_autoHideWithDelay];
    }];
}

+ (instancetype)rr_errorAlertWithMessage:(NSString *)message handler:(void (^)(UIAlertAction *action))handler {
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:NSLocalizedString(kAlertErrorTitle, nil)
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle:NSLocalizedString(kAlertOkButtonTitle, nil)
                             style:UIAlertActionStyleCancel
                           handler:handler];
    [alertController addAction:okAction];
    return alertController;
}

- (void)rr_autoHideWithDelay {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kDeltaHideErrorAlert), dispatch_get_main_queue(), ^{
        [weakSelf dismissViewControllerAnimated:true completion:nil];
    });
}

@end
