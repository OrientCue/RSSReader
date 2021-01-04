//
//  UIAlertController+RRErrorAlert.h
//  RSSReader
//
//  Created by Arseniy Strakh on 25.11.2020.
//

#import <UIKit/UIKit.h>

typedef void(^AlertControllerPresentCompletion)(void);

@interface UIAlertController (RRErrorAlert)
+ (instancetype)rr_errorAlertWithMessage:(NSString *)message;
- (AlertControllerPresentCompletion)autoHideCompletion;
@end
