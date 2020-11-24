//
//  NSDateFormatter+AtomItemPubDate.m
//  RSSReader
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import "NSDateFormatter+AtomItemPubDate.h"

@implementation NSDateFormatter (AtomItemPubDate)

+ (NSDateFormatter *)formatterForPubDateOutput {
  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = @"MM.dd.yyyy HH:mm";
  return [df autorelease];
}

+ (NSDateFormatter *)formatterForPubDateInput {
  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = @"EE, d MMM yyyy HH:mm:ss Z";
  return [df autorelease];
}

@end
