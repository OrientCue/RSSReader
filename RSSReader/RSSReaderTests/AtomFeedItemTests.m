//
//  AtomFeedItemTests.m
//  RSSReaderTests
//
//  Created by Arseniy Strakh on 24.11.2020.
//

#import <XCTest/XCTest.h>
#import "AtomFeedItem.h"

@interface AtomFeedItemTests : XCTestCase

@end

@implementation AtomFeedItemTests

- (void)testItemFromDictionary_nilDictionary_raiseExeption {
    XCTAssertThrowsSpecificNamed([AtomFeedItem itemFromDictionary:nil],
                                 NSException,
                                 NSInvalidArgumentException);
}

- (void)testItemFromDictionary_emptyDictionary_raiseExeption {
    XCTAssertThrowsSpecificNamed([AtomFeedItem itemFromDictionary:@{}],
                                 NSException,
                                 NSInvalidArgumentException);
}

@end
