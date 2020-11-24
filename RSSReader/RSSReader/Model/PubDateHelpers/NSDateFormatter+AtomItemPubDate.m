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

+ (instancetype)formatterWithDateFormat:(NSString *)dateFormat {
  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = dateFormat;
  return [df autorelease];
}

+ (NSDateFormatter *)formatterForPubDateOutput {
  NSString *localizedDateFormat = [self dateFormatFromTemplate:kDateFormatAtomOutput
                                                       options:0
                                                        locale:NSLocale.currentLocale];
  return [self formatterWithDateFormat:localizedDateFormat];
}

+ (NSDateFormatter *)formatterForPubDateInput {
  return [self formatterWithDateFormat:kDateFormatAtomInput];
}

@end
