//
//  AutodiscoveryRSS.m
//  RSSReader
//
//  Created by Arseniy Strakh on 18.12.2020.
//

#import "AutodiscoveryRSS.h"
#import "AutodiscoveryHTMLParserRuntime.h"
#import "DownloadOperation.h"
#import "RSSChannelParser.h"
#import "URLValidator.h"

@class RSSChannel;

@interface AutodiscoveryRSS ()
@property (nonatomic, strong) URLValidator *validator;
@property (nonatomic, strong) id<AutodiscoveryHTMLParserType> htmlParser;
@property (nonatomic, strong) RSSChannelParser *channelParser;
@property (nonatomic, copy) SearchSiteNameCompletion searchSiteCompletion;
@property (nonatomic, copy) SearchLinkCompletion searchLinkCompletion;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, getter=isInflight) BOOL inflight;
@end

@implementation AutodiscoveryRSS

#pragma mark - Initialize

+ (void)initialize {
    if (self == [AutodiscoveryRSS class]) {
        registerHTMLParserClass();
    }
}

#pragma mark - Lazy Properties

- (id<AutodiscoveryHTMLParserType>)htmlParser {
    if (!_htmlParser) {
        _htmlParser = [AutodiscoveryHTMLParserRuntime new];
    }
    return _htmlParser;
}

- (RSSChannelParser *)channelParser {
    if (!_channelParser) {
        _channelParser = [RSSChannelParser new];
    }
    return _channelParser;
}

- (URLValidator *)validator {
    if (!_validator) {
        _validator = [URLValidator new];
    }
    return _validator;
}

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [NSOperationQueue new];
    }
    return _queue;
}

#pragma mark - Interface

- (void)searchChannelsForSiteName:(NSString *)siteName completion:(SearchSiteNameCompletion)completion {
    NSError *error = nil;
    NSURL *url = [self.validator validateSite:siteName error:&error];
    if (error && completion) {
        completion(nil, error);
        return;
    }
    if (self.isInflight) {
        [self cancelSearch];
    }
    self.searchSiteCompletion = completion;
    __weak typeof(self) weakSelf = self;
    DownloadOperation *operation = [[DownloadOperation alloc] initWithURL:url];
    __weak typeof(operation) weakOperation = operation;
    operation.completionBlock = ^{
        if (weakOperation.isCancelled) {
            weakSelf.inflight = false;
            return;
        }
        if (weakOperation.error && weakSelf.searchSiteCompletion) {
            weakSelf.searchSiteCompletion(nil, weakOperation.error);
        } else if (weakSelf.searchSiteCompletion) {
            NSArray<RSSChannel *> *channels = [self.htmlParser parseChannelsFromHTML:weakOperation.downloaded
                                                                             baseURL:url];
            weakSelf.searchSiteCompletion(channels, nil);
        }
        weakSelf.inflight = false;
    };
    self.inflight = true;
    [self.queue addOperation:operation];
}

- (void)searchChannelForLinkString:(NSString *)urlString
                        completion:(SearchLinkCompletion)completion {
    if (self.isInflight) {
        [self cancelSearch];
    }
    NSError *error = nil;
    NSURL *url = [self.validator validateLink:urlString error:&error];
    if (error && completion) {
        completion(nil, error);
        return;
    }
    self.searchLinkCompletion = completion;
    __weak typeof(self) weakSelf = self;
    DownloadOperation *operation = [[DownloadOperation alloc] initWithURL:url];
    __weak typeof(operation) weakOperation = operation;
    operation.completionBlock = ^{
        if (weakOperation.isCancelled) {
            weakSelf.inflight = false;
            return;
        }
        if (weakOperation.error && weakSelf.searchLinkCompletion) {
            weakSelf.searchLinkCompletion(nil, weakOperation.error);
        } else {
            [weakSelf.channelParser parse:weakOperation.downloaded
                                  baseURL:url
                               completion:weakSelf.searchLinkCompletion];
        }
        weakSelf.inflight = false;
    };
    self.inflight = true;
    [self.queue addOperation:operation];
}

- (void)cancelSearch {
    self.searchSiteCompletion = nil;
    self.searchLinkCompletion = nil;
    [self.queue cancelAllOperations];
}

@end
