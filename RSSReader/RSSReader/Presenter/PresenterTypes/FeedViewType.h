//
//  FeedViewType.h
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import <Foundation/Foundation.h>

@class Article;

@protocol FeedViewType <NSObject>

- (void)appendArticles:(NSArray<Article *> *)articles;
- (void)showLoading;
- (void)hideLoading;

@end
