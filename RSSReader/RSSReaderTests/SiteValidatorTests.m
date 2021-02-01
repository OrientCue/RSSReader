//
//  SiteValidatorTests.m
//  RSSReaderTests
//
//  Created by Arseniy Strakh on 18.12.2020.
//

#import <XCTest/XCTest.h>
#import "URLValidator.h"

FOUNDATION_EXPORT NSErrorDomain const RRSiteValidatorErrorDomain;

@interface SiteValidatorTests : XCTestCase {
  NSError *error;
}
@property (nonatomic, retain) URLValidator *sut;
@end

@implementation SiteValidatorTests

- (void)setUp {
  self.continueAfterFailure = false;
  _sut = [URLValidator new];
}

- (void)tearDown {
  _sut = nil;
  error = nil;
}

- (void)testValidate_nilSite_expectError {
  XCTAssertNil([self.sut validateSite:nil error:&error]);
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
}

- (void)testValidate_siteEmptyString_expectError {
  NSError *error = nil;
  XCTAssertNil([self.sut validateSite:@"" error:&error]);
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
}

- (void)testValidate_siteValidURL1 {
  NSURL *resultURL = [self.sut validateSite:@"https://tut.by" error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(resultURL);
  XCTAssertEqualObjects(resultURL.absoluteString, @"https://tut.by");
}

- (void)testValidate_siteValidURL2 {
  NSURL *resultURL = [self.sut validateSite:@"tut.by" error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(resultURL);
  XCTAssertEqualObjects(resultURL.absoluteString, @"https://tut.by");
}

- (void)testValidate_siteValidURL3 {
  NSURL *resultURL = [self.sut validateSite:@"www.tut.by" error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(resultURL);
  XCTAssertEqualObjects(resultURL.absoluteString, @"https://www.tut.by");
}

- (void)testValidate_siteValidURL5 {
  NSURL *resultURL = [self.sut validateSite:@" Tut " error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(resultURL);
  XCTAssertEqualObjects(resultURL.absoluteString, @"https://Tut");
}

- (void)testValidate_siteValidURL6 {
  NSURL *resultURL = [self.sut validateSite:@"http://tut.by" error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(resultURL);
  XCTAssertEqualObjects(resultURL.absoluteString, @"https://tut.by");
}

- (void)testValidate_siteInvalidURL1 {
  NSURL *resultURL = [self.sut validateSite:@"https://" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL3 {
  NSURL *resultURL = [self.sut validateSite:@"tut.by)" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL4 {
  NSURL *resultURL = [self.sut validateSite:@"(tut.by" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL5 {
  NSURL *resultURL = [self.sut validateSite:@"tu\t.by" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL6 {
  NSURL *resultURL = [self.sut validateSite:@"tut .by" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL7 {
  NSURL *resultURL = [self.sut validateSite:@"#tut.by" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL8 {
  NSURL *resultURL = [self.sut validateSite:@"tu%t.by" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL9 {
  NSURL *resultURL = [self.sut validateSite:@"tut/.by" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL10 {
  NSURL *resultURL = [self.sut validateSite:@"tut:.by" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL11 {
  NSURL *resultURL = [self.sut validateSite:@"<tut.by" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL12 {
  NSURL *resultURL = [self.sut validateSite:@"tut.by>" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL13 {
  NSURL *resultURL = [self.sut validateSite:@"tut?.by" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL14 {
  NSURL *resultURL = [self.sut validateSite:@"tut@by" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL15 {
  NSURL *resultURL = [self.sut validateSite:@"tut.[by" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL16 {
  NSURL *resultURL = [self.sut validateSite:@"tut.by]" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL17 {
  NSURL *resultURL = [self.sut validateSite:@"\"tut.by" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL18 {
  NSURL *resultURL = [self.sut validateSite:@"tut.by\\" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

- (void)testValidate_siteInvalidURL19 {
  NSURL *resultURL = [self.sut validateSite:@"tut.by^" error:&error];
  XCTAssertNotNil(error);
  XCTAssertEqualObjects(error.domain, RRSiteValidatorErrorDomain);
  XCTAssertNil(resultURL);
}

@end
