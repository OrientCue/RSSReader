//
//  FeedPresenter.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedPresenter.h"
#import "FeedViewType.h"
#import "FeedNetworkServiceType.h"

@interface FeedPresenter ()
@property (nonatomic, retain) id<FeedNetworkServiceType> service;
@end

@implementation FeedPresenter

#pragma mark - NSObject

- (instancetype)initWithNetworkService:(id<FeedNetworkServiceType>)service {
    if (self = [super init]) {
        _service = [service retain];
    }
    return self;
}

- (void)dealloc {
    [_service release];
    [super dealloc];
}

#pragma mark - FeedPresenterType

- (void)fetchFeedFromURL:(NSURL *)url {
    if (!url) {
        [self.view showEmptyFeed];
        return;
    }
    [self.view showLoading];
    __block typeof(self) weakSelf = self;
    [self.service fetchFeedFromUrl:url completion:^(NSArray<AtomFeedItem *> *items, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view displayError:error];
                [weakSelf.view hideLoading];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view appendItems:items];
                [weakSelf.view hideLoading];
            });
        }
    }];
}

- (void)cancelFetch {
    [self.service cancelFetch];
    [self.view hideLoading];
}

@end
