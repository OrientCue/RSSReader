//
//  UIBarButtonItem+ASBlockInit.h
//  RSSReader
//
//  Created by Arseniy Strakh on 22.02.2021.
//

#import <UIKit/UIKit.h>

typedef void(^ActionHandler)(void);

@interface UIBarButtonItem (ASBlockInit)
+ (instancetype)systemItem:(UIBarButtonSystemItem)systemItem withAction:(ActionHandler)action;
- (instancetype)initWithSystemItem:(UIBarButtonSystemItem)systemItem action:(ActionHandler)action;
- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style action:(ActionHandler)action;
@end
