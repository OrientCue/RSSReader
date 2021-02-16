//
//  AutodiscoveryRSS.m
//  RSSReader
//
//  Created by Arseniy Strakh on 18.12.2020.
//

#import "AutodiscoveryRSS.h"
#import "DownloadOperation.h"
#import "URLValidator.h"
#import "AutodiscoveryHTMLParser.h"
#import "RSSChannelParser.h"

@class RSSChannel;

@interface AutodiscoveryRSS ()
@property (nonatomic, retain) URLValidator *validator;
@property (nonatomic, retain) AutodiscoveryHTMLParser *htmlParser;
@property (nonatomic, retain) RSSChannelParser *channelParser;
@property (nonatomic, copy) SearchSiteNameCompletion searchSiteCompletion;
@property (nonatomic, copy) SearchLinkCompletion searchLinkCompletion;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, getter=isInflight) BOOL inflight;
@end

@implementation AutodiscoveryRSS

#pragma mark - Object Lifecycle

- (void)dealloc {
  [_validator release];
  [_htmlParser release];
  [_channelParser release];
  [_searchSiteCompletion release];
  [_searchLinkCompletion release];
  [_queue release];
  [super dealloc];
}

#pragma mark -

- (AutodiscoveryHTMLParser *)htmlParser {
  if (!_htmlParser) {
    _htmlParser = [AutodiscoveryHTMLParser new];
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

#pragma mark -

- (void)searchChannelsForSiteName:(NSString *)siteName completion:(SearchSiteNameCompletion)completion {
  
  NSError *error = nil;
  NSURL *url = [self.validator validateSite:siteName error:&error];
  if (error) {
    if (completion) { completion(nil, error); }
    return;
  }
  
  if (self.isInflight) {
    [self cancelSearch];
  }
  self.searchSiteCompletion = completion;
  __block typeof(self) weakSelf = self;
  DownloadOperation *operation = [[DownloadOperation alloc] initWithURL:url];
  __block typeof(operation) weakOperation = operation;
  operation.completionBlock = ^{
    if (weakOperation.isCancelled) {
      weakSelf.inflight = false;
      return;
    }
    if (weakOperation.error) {
      if (weakSelf.searchSiteCompletion) { weakSelf.searchSiteCompletion(nil, weakOperation.error); }
    } else {
      if (weakSelf.searchSiteCompletion) {
        NSArray<RSSChannel *> *channels = [self.htmlParser parseChannelsFromHTML:weakOperation.downloaded
                                                                         baseURL:url];
        weakSelf.searchSiteCompletion(channels, nil);
      }
    }
    weakSelf.inflight = false;
  };
  self.inflight = true;
  [self.queue addOperation:operation];
  [operation release];
}

- (void)searchChannelForLinkString:(NSString *)urlString
                        completion:(SearchLinkCompletion)completion {
  if (self.isInflight) {
    [self cancelSearch];
  }
  NSError *error = nil;
  NSURL *url = [self.validator validateLink:urlString error:&error];
  if (error) {
    if (completion) { completion(nil, error); }
    return;
  }
  self.searchLinkCompletion = completion;
  __block typeof(self) weakSelf = self;
  DownloadOperation *operation = [[DownloadOperation alloc] initWithURL:url];
  __block typeof(operation) weakOperation = operation;
  operation.completionBlock = ^{
    if (weakOperation.isCancelled) {
      weakSelf.inflight = false;
      return;
    }
    if (weakOperation.error) {
      if (weakSelf.searchLinkCompletion) {
        weakSelf.searchLinkCompletion(nil, weakOperation.error);
      }
    } else {
      [weakSelf.channelParser parse:weakOperation.downloaded
                            baseURL:url
                         completion:weakSelf.searchLinkCompletion];
    }
    weakSelf.inflight = false;
  };
  self.inflight = true;
  [self.queue addOperation:operation];
  [operation release];
}

- (void)cancelSearch {
  self.searchSiteCompletion = nil;
  self.searchLinkCompletion = nil;
  [self.queue cancelAllOperations];
}

@end
