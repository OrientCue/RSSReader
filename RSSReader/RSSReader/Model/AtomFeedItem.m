//
//  AtomFeedItem.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "AtomFeedItem.h"

NSString *const kItemKey = @"item";
NSString *const kTitleKey = @"title";
NSString *const kEnclosureKey = @"enclosure";
NSString *const kDescriptionKey = @"description";
NSString *const kURLKey = @"url";
NSString *const kLinkKey = @"link";
NSString *const kPubDateKey = @"pubDate";

@implementation AtomFeedItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (!dictionary || !dictionary.count) { return nil; }
  if (self = [super init]) {
    _title = [dictionary[kTitleKey] copy];
    _articleDescription = [dictionary[kDescriptionKey] copy];
    _link = [[NSURL URLWithString:dictionary[kLinkKey]] retain];
    _pubDate = [[self dateFrom:dictionary[kPubDateKey]] retain];
  }
  return self;
}

- (void)dealloc {
  [_title release];
  [_articleDescription release];
  [_link release];
  [_pubDate release];
  [super dealloc];
}

#pragma mark - Private Methods

- (NSDate *)dateFrom:(NSString *)string {
  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = @"EE, d MMM yyyy HH:mm:ss Z";
  NSDate *date = [df dateFromString:string];
  [df release];
  return date;
}

@end
