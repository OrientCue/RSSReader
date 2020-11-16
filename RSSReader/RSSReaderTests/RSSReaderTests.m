//
//  RSSReaderTests.m
//  RSSReaderTests
//
//  Created by Arseniy Strakh on 16.11.2020.
//

#import <XCTest/XCTest.h>

@interface RSSReaderTests : XCTestCase

@end

@implementation RSSReaderTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
  NSDictionary *plist = [NSBundle.mainBundle infoDictionary];
  XCTAssertEqual([plist[@"DTXcode"] intValue], 1220);
}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
