//
//  DownloadOperation.h
//  RSSReader
//
//  Created by Arseniy Strakh on 21.12.2020.
//

#import "AsyncOperation.h"

@interface DownloadOperation : AsyncOperation
@property (nonatomic, retain, readonly) NSURLSession *session;
@property (nonatomic, retain, readonly) NSData *downloaded;
@property (nonatomic, retain, readonly) NSError *error;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithURLSession:(NSURLSession *)session url:(NSURL *)url NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithURL:(NSURL *)url;
@end
