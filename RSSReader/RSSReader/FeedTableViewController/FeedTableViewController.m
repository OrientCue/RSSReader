//
//  FeedTableViewController.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedTableViewController.h"
#import "AtomFeedItem.h"
#import "AtomItemTableViewCell.h"

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
  [_items release];
  [super dealloc];
}

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  UINib *nib = [UINib nibWithNibName:NSStringFromClass([AtomItemTableViewCell class]) bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:AtomItemTableViewCell.identifier];
  self.title = @"Tut.by";
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 60.0;
  self.tableView.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
  [self.presenter fetch];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AtomItemTableViewCell *cell = (AtomItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AtomItemTableViewCell.identifier
                                                                                         forIndexPath:indexPath];
  AtomFeedItem *item = self.items[indexPath.row];
  [cell configureWithItem:item];
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.coordinator displayURL:self.items[indexPath.row].link];
}

#pragma mark - FeedViewType

- (void)appendItems:(NSArray<AtomFeedItem *> *)items {
  self.items = items;
  [self.tableView reloadData];
}

- (void)hideLoading {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)showLoading {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
