//
//  UIBarButtonItem+ASBlockInit.m
//  RSSReader
//
//  Created by Arseniy Strakh on 22.02.2021.
//

#import "UIBarButtonItem+ASBlockInit.h"
#import <objc/runtime.h>

void *kActionHandlerContext = &kActionHandlerContext;

@implementation UIBarButtonItem (ASBlockInit)

+ (instancetype)systemItem:(UIBarButtonSystemItem)systemItem withAction:(ActionHandler)action {
    return [[[UIBarButtonItem alloc] initWithSystemItem:systemItem action:action] autorelease];
}

- (instancetype)initWithSystemItem:(UIBarButtonSystemItem)systemItem action:(ActionHandler)action {
    if (self = [self initWithBarButtonSystemItem:systemItem
                                          target:nil
                                          action:@selector(invoke)]) {
        objc_setAssociatedObject(self, kActionHandlerContext, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
        self.target = objc_getAssociatedObject(self, kActionHandlerContext);
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style action:(ActionHandler)action {
    if (self = [self initWithTitle:title
                             style:style
                            target:nil
                            action:@selector(invoke)]) {
        objc_setAssociatedObject(self, kActionHandlerContext, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
        self.target = objc_getAssociatedObject(self, kActionHandlerContext);
    }
    return self;
}

@end
