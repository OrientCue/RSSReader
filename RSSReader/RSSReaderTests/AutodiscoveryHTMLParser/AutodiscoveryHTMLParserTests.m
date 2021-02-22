//
//  AutodiscoveryHTMLParserTests.m
//  RSSReaderTests
//
//  Created by Arseniy Strakh on 18.12.2020.
//

#import <XCTest/XCTest.h>
#import "AutodiscoveryHTMLParser.h"
#import "HTMLDataMock.h"

@interface AutodiscoveryHTMLParserTests : XCTestCase
@property (nonatomic, retain) AutodiscoveryHTMLParser *sut;
@property (nonatomic, retain) HTMLDataMock *dataMock;
@end

@implementation AutodiscoveryHTMLParserTests

#pragma mark - XCTest

- (void)setUp {
    self.continueAfterFailure = false;
    _sut = [AutodiscoveryHTMLParser new];
    _dataMock = [HTMLDataMock new];
}

- (void)tearDown {
    _sut = nil;
    _dataMock = nil;
}

#pragma mark -

- (void)testParseNilData_expectNilResult {
    XCTAssertNil([self.sut parseHTML:nil]);
}

- (void)testParseEmptyData_expectNilResult {
    XCTAssertNil([self.sut parseHTML:[[NSData new] autorelease]]);
}

- (void)testParseDataMeduza_expectEmptyResult {
    NSArray *result = [self.sut parseHTML:[self.dataMock meduza_io]];
    XCTAssertEqual(result.count, 0);
}

#pragma mark - Tut.by html

- (void)testParseTutBy_expect3Channels {
    NSArray *result = [self.sut parseHTML:[self.dataMock tut_by]];
    XCTAssertEqual(result.count, 3);
}

- (void)testParseTutBy_title0 {
    NSArray *result = [self.sut parseHTML:[self.dataMock tut_by]];
    NSString *resultTitle = result[0][kRSSChannelTitleKey];
    NSString *expectedTitle = @"TUT.BY - Главные новости недели";
    XCTAssertEqualObjects(resultTitle, expectedTitle);
}

- (void)testParseTutBy_title1 {
    NSArray *result = [self.sut parseHTML:[self.dataMock tut_by]];
    NSString *resultTitle = result[1][kRSSChannelTitleKey];
    NSString *expectedTitle = @"TUT.BY - Все новости за день";
    XCTAssertEqualObjects(resultTitle, expectedTitle);
}

- (void)testParseTutBy_title2 {
    NSArray *result = [self.sut parseHTML:[self.dataMock tut_by]];
    NSString *resultTitle = result[2][kRSSChannelTitleKey];
    NSString *expectedTitle = @"TUT.BY - Новости компаний";
    XCTAssertEqualObjects(resultTitle, expectedTitle);
}

- (void)testParseTutBy_href0 {
    NSArray *result = [self.sut parseHTML:[self.dataMock tut_by]];
    NSString *resultHref = result[0][kRSSChannelHrefKey];
    NSString *expectedHref = @"https://news.tut.by/rss/index.rss";
    XCTAssertEqualObjects(resultHref, expectedHref);
}

- (void)testParseTutBy_href1 {
    NSArray *result = [self.sut parseHTML:[self.dataMock tut_by]];
    NSString *resultHref = result[1][kRSSChannelHrefKey];
    NSString *expectedHref = @"https://news.tut.by/rss/all.rss";
    XCTAssertEqualObjects(resultHref, expectedHref);
}

- (void)testParseTutBy_href2 {
    NSArray *result = [self.sut parseHTML:[self.dataMock tut_by]];
    NSString *resultHref = result[2][kRSSChannelHrefKey];
    NSString *expectedHref = @"https://news.tut.by/rss/press.rss";
    XCTAssertEqualObjects(resultHref, expectedHref);
}

#pragma mark - Onliner.by html

- (void)testParseOnlinerBy_expect5Channels {
    NSArray *result = [self.sut parseHTML:[self.dataMock onliner_by]];
    XCTAssertEqual(result.count, 5);
}

- (void)testParseOnlinerBy_title {
    NSArray *result = [self.sut parseHTML:[self.dataMock onliner_by]];
    NSString *resultTitle = result[0][kRSSChannelTitleKey];
    NSString *expectedTitle = @"Onliner";
    XCTAssertEqualObjects(resultTitle, expectedTitle);
}

- (void)testParseOnlinerBy_href0 {
    NSArray *result = [self.sut parseHTML:[self.dataMock onliner_by]];
    NSString *resultHref = result[0][kRSSChannelHrefKey];
    NSString *expectedHref = @"/feed";
    XCTAssertEqualObjects(resultHref, expectedHref);
}

- (void)testParseOnlinerBy_href1 {
    NSArray *result = [self.sut parseHTML:[self.dataMock onliner_by]];
    NSString *resultHref = result[1][kRSSChannelHrefKey];
    NSString *expectedHref = @"https://people.onliner.by/feed";
    XCTAssertEqualObjects(resultHref, expectedHref);
}

- (void)testParseOnlinerBy_href2 {
    NSArray *result = [self.sut parseHTML:[self.dataMock onliner_by]];
    NSString *resultHref = result[2][kRSSChannelHrefKey];
    NSString *expectedHref = @"https://auto.onliner.by/feed";
    XCTAssertEqualObjects(resultHref, expectedHref);
}

- (void)testParseOnlinerBy_href3 {
    NSArray *result = [self.sut parseHTML:[self.dataMock onliner_by]];
    NSString *resultHref = result[3][kRSSChannelHrefKey];
    NSString *expectedHref = @"https://tech.onliner.by/feed";
    XCTAssertEqualObjects(resultHref, expectedHref);
}

- (void)testParseOnlinerBy_href4 {
    NSArray *result = [self.sut parseHTML:[self.dataMock onliner_by]];
    NSString *resultHref = result[4][kRSSChannelHrefKey];
    NSString *expectedHref = @"https://realt.onliner.by/feed";
    XCTAssertEqualObjects(resultHref, expectedHref);
}

#pragma mark - NYTimes html

- (void)testParseNytimesCom_expect1Channel {
    NSArray *result = [self.sut parseHTML:[self.dataMock nytimes_com]];
    XCTAssertEqual(result.count, 1);
}

- (void)testParseNytimesCom_title {
    NSArray *result = [self.sut parseHTML:[self.dataMock nytimes_com]];
    NSString *resultTitle = result[0][kRSSChannelTitleKey];
    NSString *expectedTitle = @"RSS";
    XCTAssertEqualObjects(resultTitle, expectedTitle);
}

- (void)testParseNytimesCom_href {
    NSArray *result = [self.sut parseHTML:[self.dataMock nytimes_com]];
    NSString *resultHref = result[0][kRSSChannelHrefKey];
    NSString *expectedHref = @"https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml";
    XCTAssertEqualObjects(resultHref, expectedHref);
}
@end
