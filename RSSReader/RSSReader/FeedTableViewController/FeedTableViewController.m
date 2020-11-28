//
//  FeedTableViewController.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedTableViewController.h"
#import "AtomFeedItem.h"
#import "AtomItemTableViewCell.h"
#import "UITableView+RegisterCell.h"

NSString *const kFeedTitle = @"Tut.by";
CGFloat const kEstimatedRowHeight = 60.0;

@interface FeedTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray<AtomFeedItem *> *items;
@end

@implementation FeedTableViewController

#pragma mark - NSObject

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _presenter = [presenter retain];
  }
  return self;
}

- (void)dealloc {
  [_presenter release];
  [_items release];
  [_tableView release];
  [super dealloc];
}

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = kFeedTitle;
  [self layoutTableView];
  [self.presenter fetch];
}

#pragma mark - Layout

- (void)layoutTableView {
  [self.view addSubview:self.tableView];
  [NSLayoutConstraint activateConstraints:@[
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
  ]
   ];
}

#pragma mark - Lazy Properties

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = kEstimatedRowHeight;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.translatesAutoresizingMaskIntoConstraints = false;
    [_tableView registerNibForCellClasses:@[[AtomItemTableViewCell class]]];
  }
  return _tableView;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AtomItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AtomItemTableViewCell.identifier
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
