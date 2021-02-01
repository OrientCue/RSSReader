//
//  URLValidator.h
//  RSSReader
//
//  Created by Arseniy Strakh on 18.12.2020.
//

#import <Foundation/Foundation.h>

@interface URLValidator : NSObject
- (NSURL *)validateSite:(NSString *)site error:(NSError **)error;
- (NSURL *)validateLink:(NSString *)link error:(NSError **)error;
@end
