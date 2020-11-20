//
//  FeedTableViewController.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedTableViewController.h"
#import "AtomFeedItem.h"
#import "AtomItemTableViewCell.h"

NSString *const kFeedTitle = @"Tut.by";

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
  self.title = kFeedTitle;
  [self configureTableView];
  [self.presenter fetch];
}

#pragma mark - Configure Table View

- (void)configureTableView {
  UINib *nib = [UINib nibWithNibName:NSStringFromClass([AtomItemTableViewCell class]) bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:AtomItemTableViewCell.identifier];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 60.0;
  self.tableView.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AtomItemTableViewCell *cell = (AtomItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AtomItemTableViewCell.identifier
                                                                                         forIndexPath:indexPath];
  [cell configureWithItem:self.items[indexPath.row]];
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.coordinator displayURL:self.items[indexPath.row].link];
}

#pragma mark - FeedViewType

- (void)appendItems:(NSArray<AtomFeedItem *> *)items {
  dispatch_async(dispatch_get_main_queue(), ^{
    self.items = items;
    [self.tableView reloadData];
  });
}

- (void)hideLoading {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)showLoading {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
