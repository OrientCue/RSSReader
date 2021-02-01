//
//  URLValidator.m
//  RSSReader
//
//  Created by Arseniy Strakh on 18.12.2020.
//

#import "URLValidator.h"

NSErrorDomain const RRSiteValidatorErrorDomain = @"RRSiteValidatorErrorDomain";

NSString *const kRRSiteValidatorErrorNilSite = @"Attempt to validate nil site argument.";
NSString *const kRRSiteValidatorErrorEmptySite = @"Site string is empty!";
NSString *const kRRSiteValidatorErrorForbiddenCharacters = @"Can't form url from site string. String contains forbidden characters.";
NSString *const kRRSiteValidatorErrorCantFormURL = @"Can't form url from site string.";

NSString *const kForbiddenCharacters = @"\t ()@[]/";

NSString *const kHTTPSScheme = @"https";
NSString *const kHTTPScheme = @"http";

@implementation URLValidator

#pragma mark -

- (NSURL *)validateSite:(NSString *)site error:(NSError **)error {
  if (!site) {
    if (error) { *error = [self errorNilString]; }
    return nil;
  }
  if (!site.length) {
    if (error) { *error = [self errorEmptyString]; }
    return nil;
  }
  NSString *trimmed = [site stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
  NSURL *url = [NSURL URLWithString:trimmed];
  if (url.scheme && url.host) {
    if ([url.scheme isEqualToString:kHTTPScheme]) {
      NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:false];
      components.scheme = kHTTPSScheme;
      return components.URL;
    }
    return url;
  }
  if (!url.scheme && !url.host && url.path) {
    if (url.query || [self containsForbiddenCharsIn:url.path]) {
      if (error) { *error = [self errorForbiddenCharactersInString]; }
      return nil;
    }
    NSURLComponents *components = [[NSURLComponents new] autorelease];
    components.scheme = kHTTPSScheme;
    components.host = url.path;
    return components.URL;
  }
  if (error) { *error = [self errorCantFormURL]; }
  return nil;
}

- (NSURL *)validateLink:(NSString *)link error:(NSError **)error {
  if (!link) {
    if (error) { *error = [self errorNilString]; }
    return nil;
  }
  if (!link.length) {
    if (error) { *error = [self errorEmptyString]; }
    return nil;
  }
  NSString *trimmed = [link stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
  NSURL *url = [NSURL URLWithString:trimmed];
  if (url) {
    return url;
  } else {
    if (error) { *error = [self errorCantFormURL]; }
    return nil;
  }
}

#pragma mark - Errors

- (NSError *)errorNilString {
  return [NSError errorWithDomain:RRSiteValidatorErrorDomain
                            code:0
                        userInfo:@{NSLocalizedDescriptionKey: kRRSiteValidatorErrorNilSite}];
}

- (NSError *)errorEmptyString {
  return [NSError errorWithDomain:RRSiteValidatorErrorDomain
                            code:1
                         userInfo:@{NSLocalizedDescriptionKey: kRRSiteValidatorErrorEmptySite}];
}

- (NSError *)errorForbiddenCharactersInString {
  return [NSError errorWithDomain:RRSiteValidatorErrorDomain
                            code:2
                         userInfo:@{NSLocalizedDescriptionKey: kRRSiteValidatorErrorForbiddenCharacters}];
}

- (NSError *)errorCantFormURL {
  return [NSError errorWithDomain:RRSiteValidatorErrorDomain
                            code:3
                         userInfo:@{NSLocalizedDescriptionKey: kRRSiteValidatorErrorCantFormURL}];
}

#pragma mark - Private

/// ()#%/:<>?@[]\\^
- (BOOL)containsForbiddenCharsIn:(NSString *)string {
  NSCharacterSet *forbidden = [NSCharacterSet characterSetWithCharactersInString:kForbiddenCharacters];
  return [string rangeOfCharacterFromSet:forbidden].location != NSNotFound;
}

@end
