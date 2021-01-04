//
//  FeedTableViewController.m
//  RSSReader
//
//  Created by Arseniy Strakh on 17.11.2020.
//

#import "FeedTableViewController.h"
#import "FeedPresenterType.h"
#import "AtomFeedItem.h"
#import "AtomItemTableViewCell.h"
#import "UITableView+RegisterCell.h"

NSString *const kFeedTitle = @"Tut.by";
CGFloat const kEstimatedRowHeight = 60.0;

@interface FeedTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, readonly, retain) id<FeedPresenterType> presenter;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray<AtomFeedItem *> *items;
@property (nonatomic, copy) DisplayURLHandler displayURLHandler;
@property (nonatomic, copy) DisplayErrorHandler displayErrorHandler;
@property (nonatomic, retain) UIBarButtonItem *refreshButton;
@end

@implementation FeedTableViewController

#pragma mark - Lifecycle

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter
                displayURLHandler:(DisplayURLHandler)displayURLHandler
              displayErrorHandler:(DisplayErrorHandler)displayErrorHandler {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _presenter = [presenter retain];
    _presenter.view = self;
    _displayURLHandler = [displayURLHandler copy];
    _displayErrorHandler = [displayErrorHandler copy];
  }
  return self;
}

- (void)dealloc {
  [_presenter release];
  [_items release];
  [_tableView release];
  [_displayURLHandler release];
  [_displayErrorHandler release];
  [_refreshButton release];
  [super dealloc];
}

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = kFeedTitle;
  [self layoutTableView];
  self.navigationItem.rightBarButtonItem = self.refreshButton;
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
    _tableView.tableFooterView = [[UIView new] autorelease];
    _tableView.translatesAutoresizingMaskIntoConstraints = false;
    [_tableView registerNibForCellClasses:@[[AtomItemTableViewCell class]]];
  }
  return _tableView;
}

- (UIBarButtonItem *)refreshButton {
  if (!_refreshButton) {
    _refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                   target:self.presenter
                                                                   action:@selector(fetch)];
  }
  return _refreshButton;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AtomItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AtomItemTableViewCell class])
                                                                forIndexPath:indexPath];
  [cell configureWithItem:self.items[indexPath.row]];
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.displayURLHandler) {
    self.displayURLHandler(self.items[indexPath.row].link);
  }
}

#pragma mark - FeedViewType

- (void)appendItems:(NSArray<AtomFeedItem *> *)items {
  self.items = items;
  [self.tableView reloadData];
}

- (void)hideLoading {
  UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
}

- (void)showLoading {
  UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
}

- (void)displayError:(NSError *)error {
  if (self.displayErrorHandler) {
    self.displayErrorHandler(error);
  }
}

@end
