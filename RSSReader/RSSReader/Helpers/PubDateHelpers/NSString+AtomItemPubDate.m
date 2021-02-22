//
//  NSString+AtomItemPubDate.m
//  RSSReader
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import "NSString+AtomItemPubDate.h"
#import "NSDateFormatter+AtomItemPubDate.h"

@implementation NSString (AtomItemPubDate)

- (NSDate *)dateForPubDateString {
    return [NSDateFormatter.sharedFormatterForPubDateInput dateFromString:self];
}

@end
