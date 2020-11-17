//
//  FeedDownloaderType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

typedef void(^FeedDownloaderCompletion)(NSData *data, NSError *error);

@protocol FeedDownloaderType <NSObject>
- (void)downloadFromUrl:(NSURL *)url completion:(FeedDownloaderCompletion)completion;
@end
