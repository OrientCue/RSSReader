//
//  NSArray+RRValidateIndex.m
//  RSSReader
//
//  Created by Arseniy Strakh on 19.02.2021.
//

#import "NSArray+RRValidateIndex.h"

@implementation NSArray (RRValidateIndex)
- (BOOL)isValidIndex:(NSUInteger)index {
  return index >= 0 && index < self.count;
}
@end
