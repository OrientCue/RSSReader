//
//  DisplayURLProtocol.h
//  RSSReader
//
//  Created by Arseniy Strakh on 18.11.2020.
//

#import <Foundation/Foundation.h>

@protocol DisplayURLProtocol <NSObject>
- (void)displayURL:(NSURL *)url;
@end
