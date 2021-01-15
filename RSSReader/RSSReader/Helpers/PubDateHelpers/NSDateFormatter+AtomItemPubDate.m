//
//  NSDateFormatter+AtomItemPubDate.m
//  RSSReader
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import "NSDateFormatter+AtomItemPubDate.h"

NSString *const kDateFormatAtomOutput = @"dd.MM.yyyy HH:mm";
NSString *const kDateFormatAtomInput = @"EE, d MMM yyyy HH:mm:ss Z";

@implementation NSDateFormatter (AtomItemPubDate)

+ (NSDateFormatter *)sharedFormatterForPubDateOutput {
  static NSDateFormatter *sharedDateFormatter = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *localizedDateFormat = [self dateFormatFromTemplate:kDateFormatAtomOutput
                                                         options:0
                                                          locale:NSLocale.currentLocale];
    sharedDateFormatter = [NSDateFormatter new];
    sharedDateFormatter.dateFormat = localizedDateFormat;
  });
  return sharedDateFormatter;
}

+ (NSDateFormatter *)sharedFormatterForPubDateInput {
  static NSDateFormatter *sharedDateFormatter = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedDateFormatter = [NSDateFormatter new];
    sharedDateFormatter.dateFormat = kDateFormatAtomInput;
  });
  return sharedDateFormatter;
}

@end
