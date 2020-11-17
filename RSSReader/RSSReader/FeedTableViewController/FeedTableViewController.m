//
//  FeedTableViewController.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedTableViewController.h"

@interface FeedTableViewController ()

@end

@implementation FeedTableViewController

#pragma mark - NSObject

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter {
  if (self = [super initWithStyle:UITableViewStylePlain]) {
    _presenter = [presenter retain];
  }
  return self;
}

- (void)dealloc {
  [_presenter release];
  [_articles release];
  [super dealloc];
}

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = UIColor.yellowColor;
  self.title = @"Tut.by rss feed";
  [self.presenter fetch];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];

  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)appendArticles:(NSArray<Article *> *)articles {
  self.articles = articles;
  [self.tableView reloadData];
}

- (void)hideLoading {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)showLoading {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
