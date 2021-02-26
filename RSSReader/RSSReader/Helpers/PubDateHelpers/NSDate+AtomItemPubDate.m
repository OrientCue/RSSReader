//
//  NSDate+AtomItemPubDate.m
//  RSSReader
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import "NSDate+AtomItemPubDate.h"
#import "NSDateFormatter+AtomItemPubDate.h"

@implementation NSDate (AtomItemPubDate)

- (NSString *)stringForPubDate {
    return [NSDateFormatter.sharedFormatterForPubDateOutput stringFromDate:self];
}

@end
