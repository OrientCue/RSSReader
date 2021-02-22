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
#import "AtomItemCellDelegate.h"
#import "LoadingView.h"
#import "RSSChannel.h"
#import "UIAlertController+RRErrorAlert.h"

CGFloat const kEstimatedRowHeight = 60.0;

@interface FeedTableViewController () <UITableViewDelegate, UITableViewDataSource, AtomItemCellDelegate>
@property (nonatomic, readonly, retain) id<FeedPresenterType> presenter;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray<AtomFeedItem *> *items;
@property (nonatomic, retain) NSMutableIndexSet *expandedIndexSet;
@property (nonatomic, copy) DisplayURLHandler displayURLHandler;
@property (nonatomic, retain) UIBarButtonItem *refreshButton;
@property (nonatomic, retain) LoadingView *loadingView;
@property (nonatomic, retain) RSSChannel *channel;
@end

@implementation FeedTableViewController

#pragma mark - Lifecycle

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter
                displayURLHandler:(DisplayURLHandler)displayURLHandler {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _presenter = [presenter retain];
        _presenter.view = self;
        _displayURLHandler = [displayURLHandler copy];
        _expandedIndexSet = [NSMutableIndexSet new];
    }
    return self;
}

- (void)dealloc {
    [_presenter release];
    [_items release];
    [_tableView release];
    [_displayURLHandler release];
    [_refreshButton release];
    [_expandedIndexSet release];
    [_loadingView release];
    [_channel release];
    [super dealloc];
}

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutTableView];
    [self layoutLoadingView];
    self.navigationItem.rightBarButtonItem = self.refreshButton;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.presenter cancelFetch];
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
- (void)layoutLoadingView {
    [self.view addSubview:self.loadingView];
    [NSLayoutConstraint activateConstraints:@[
        [self.loadingView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.loadingView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.loadingView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.loadingView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
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
                                                                       target:self
                                                                       action:@selector(refreshFeed)];
    }
    return _refreshButton;
}

- (LoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [LoadingView new];
        _loadingView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _loadingView;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AtomItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AtomItemTableViewCell class])
                                                                  forIndexPath:indexPath];
    [cell configureWithItem:self.items[indexPath.row]
                  indexPath:indexPath
                   expanded:[self.expandedIndexSet containsIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (self.displayURLHandler) {
        self.displayURLHandler(self.items[indexPath.row].link);
    }
}

#pragma mark - FeedViewType

- (void)feedForChannel:(RSSChannel *)channel {
    self.channel = channel;
    self.title = channel.title;
    [self.presenter fetchFeedFromURL:channel.link];
}

- (void)appendItems:(NSArray<AtomFeedItem *> *)items {
    self.items = items;
    [self.expandedIndexSet removeAllIndexes];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:true];
}

- (void)showEmptyFeed {
    self.items = @[];
    [self.expandedIndexSet removeAllIndexes];
    [self.tableView reloadData];
}

- (void)hideLoading {
    UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
    [self.loadingView hideLoading];
}

- (void)showLoading {
    UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
    [self.loadingView showLoading];
}

- (void)displayError:(NSError *)error {
    [self showEmptyFeed];
    [UIAlertController showError:error sourceViewController:self handler:nil];
}

- (void)refreshFeed {
    [self.presenter fetchFeedFromURL:self.channel.link];
}

#pragma mark - AtomItemCellDelegate

- (void)row:(NSInteger)row expandedState:(BOOL)isExpanded {
    isExpanded ? [self.expandedIndexSet addIndex:row] : [self.expandedIndexSet removeIndex:row];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
