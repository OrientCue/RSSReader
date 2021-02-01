//
//  HTMLDataMock.m
//  RSSReaderTests
//
//  Created by Arseniy Strakh on 18.12.2020.
//

#import "HTMLDataMock.h"

@interface HTMLDataMock ()
@property (nonatomic, retain) NSBundle *bundle;
@end

@implementation HTMLDataMock

#pragma mark - Object Lifecycle

- (instancetype)init {
  if (self = [super init]) {
    _bundle = [NSBundle bundleForClass:[self class]];
  }
  return self;
}

- (void)dealloc {

  [super dealloc];
}

#pragma mark -

- (NSData *)meduza_io {
  return [self htmlData:@"withoutTags"];
}

- (NSData *)tut_by {
  return [self htmlData:@"tut.by"];
}

- (NSData *)onliner_by {
  return [self htmlData:@"onliner.by"];
}

- (NSData *)nytimes_com {
  return [self htmlData:@"nytimes.com"];
}

#pragma mark -

- (NSData *)htmlData:(NSString *)filename {
  NSURL *fileUrl = [self.bundle URLForResource:filename withExtension:@"html"];
  NSData *data = [NSData dataWithContentsOfURL:fileUrl];
  return data;
}

@end
