//
//  SettingsStoreTests.m
//  RSSReaderTests
//
//  Created by Arseniy Strakh on 22.12.2020.
//

#import <XCTest/XCTest.h>
#import "SettingsStore.h"
#import "RSSChannel.h"

@interface SettingsStoreTests : XCTestCase {
  NSError *error;
}
@end

@implementation SettingsStoreTests

- (void)setUp {
  self.continueAfterFailure = false;
  error = nil;
}

- (void)tearDown {
  error = nil;
}

- (NSArray *)oneChannel {
  return @[
    [[[RSSChannel alloc] initWithTitle:@"Tut.by"
                                  link:
      [NSURL URLWithString:@"https://news.tut.by/rss/index.rss"]] autorelease]
  ];
}

- (NSArray *)fourChannels {
  return @[
    [[[RSSChannel alloc] initWithTitle:@"Tut.by"
                                  link:
      [NSURL URLWithString:@"https://news.tut.by/rss/index.rss"]] autorelease],
    
    [[[RSSChannel alloc] initWithTitle:@"Onliner"
                                  link:
      [NSURL URLWithString:@"https://onliner.by/feed"]] autorelease],
    
    [[[RSSChannel alloc] initWithTitle:@"New York Times"
                                  link:
      [NSURL URLWithString:@"https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"]] autorelease],
    
    [[[RSSChannel alloc] initWithTitle:@"Meduza"
                                  link:
      [NSURL URLWithString:@"https://meduza.io/rss2/all"]] autorelease]
  ];
}

- (void)test {
  [self archiveUnarchiveTest:@[]
             selectedChannel:0];
  [self archiveUnarchiveTest:[self oneChannel]
             selectedChannel:(NSInteger)arc4random_uniform(1)];
  [self archiveUnarchiveTest:[self fourChannels]
             selectedChannel:(NSInteger)arc4random_uniform(4)];
}

- (void)archiveUnarchiveTest:(NSArray *)channels selectedChannel:(NSInteger)selectedChannel {
  SettingsStore *store = [SettingsStore new];
  store.channels = channels;
  store.selectedChannel = selectedChannel;
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:store
                                       requiringSecureCoding:true
                                                       error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(data);
  SettingsStore *unarchived = [NSKeyedUnarchiver unarchivedObjectOfClass:[SettingsStore class]
                                                                fromData:data
                                                                   error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(unarchived);
  XCTAssertEqualObjects(unarchived.channels, channels);
  XCTAssertEqual(unarchived.selectedChannel, selectedChannel);
  [store release];
}

@end
