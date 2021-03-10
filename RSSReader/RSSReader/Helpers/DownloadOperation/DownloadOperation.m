//
//  DownloadOperation.m
//  RSSReader
//
//  Created by Arseniy Strakh on 21.12.2020.
//

#import "DownloadOperation.h"

@interface DownloadOperation ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSData *downloaded;
@property (nonatomic, strong) NSError *error;
@end

@implementation DownloadOperation

#pragma mark - Object Lifecycle

- (instancetype)initWithURLSession:(NSURLSession *)session url:(NSURL *)url {
    if (self = [super init]) {
        _session = session;
        _url = url;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url {
    return [self initWithURLSession:NSURLSession.sharedSession url:url];
}

#pragma mark - AsyncOperation

- (void)main {
    __weak typeof(self) weakSelf = self;
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
