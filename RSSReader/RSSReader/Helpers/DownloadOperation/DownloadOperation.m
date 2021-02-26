//
//  DownloadOperation.m
//  RSSReader
//
//  Created by Arseniy Strakh on 21.12.2020.
//

#import "DownloadOperation.h"

@interface DownloadOperation ()
@property (nonatomic, retain) NSURLSession *session;
@property (nonatomic, retain) NSURLSessionDataTask *dataTask;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSData *downloaded;
@property (nonatomic, retain) NSError *error;
@end

@implementation DownloadOperation

#pragma mark - Object Lifecycle

- (instancetype)initWithURLSession:(NSURLSession *)session url:(NSURL *)url {
    if (self = [super init]) {
        _session = [session retain];
        _url = [url retain];
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url {
    return [self initWithURLSession:NSURLSession.sharedSession url:url];
}

- (void)dealloc {
    [_session release];
    [_dataTask release];
    [_url release];
    [_downloaded release];
    [_error release];
    [super dealloc];
}

#pragma mark - AsyncOperation

- (void)main {
    __block typeof(self) weakSelf = self;
    self.dataTask = [self.session dataTaskWithURL:self.url
                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (weakSelf.isCancelled) {
            weakSelf.error = error;
            [weakSelf finishOperation];
            return;
        }
        weakSelf.downloaded = data;
        weakSelf.error = error;
        [weakSelf finishOperation];
    }];
    [self.dataTask resume];
}

- (void)cancel {
    [self.dataTask cancel];
    [super cancel];
}

@end
