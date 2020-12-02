//
//  DownloaderType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

typedef void(^DownloaderCompletion)(NSData *data, NSError *error);

@protocol DownloaderType <NSObject>
- (void)downloadFromUrl:(NSURL *)url completion:(DownloaderCompletion)completion;
@end
