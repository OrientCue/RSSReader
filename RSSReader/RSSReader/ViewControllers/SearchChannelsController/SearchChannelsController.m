//
//  SearchChannelsController.m
//  RSSReader
//
//  Created by Arseniy Strakh on 23.11.2020.
//

#import "SearchChannelsController.h"
#import "SearchChannelsPresenterType.h"
#import "SelectChannelViewCell.h"
#import "LoadingView.h"
#import "ChannelsLocalStorageService.h"

NSString *const kScopeBarTitleWebsite = @"website";
NSString *const kScopeBarTitleRSSLink = @"rss link";

typedef NS_ENUM(NSUInteger, ScopesSearchBarType) {
  ScopesSearchBarWebsite,
  ScopesSearchBarRSSLink,
};

void *kTableViewSelectedRowsCountContext = &kTableViewSelectedRowsCountContext;

@interface SearchChannelsController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, readonly, retain) id<SearchChannelsPresenterType> presenter;
@property (nonatomic, retain) NSArray<RSSChannel *> *channels;
@property (nonatomic, readonly) NSArray<RSSChannel *> *selectedChannels;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) LoadingView *loadingView;
@property (nonatomic, retain) NSIndexSet *alreadyAdded;
@property (nonatomic, retain) UIBarButtonItem *cancelBarButton;
@property (nonatomic, retain) UIBarButtonItem *addBarButton;
@property (nonatomic, copy) DisplayErrorHandler displayErrorHandler;
@end

@implementation SearchChannelsController
static NSString *const kSearchBarPlaceHolder = @"example.com";
static NSString *const kAddBarButtonTitle = @"   Add  ";

#pragma mark - Lifecycle

- (instancetype)initWithPresenter:(id<SearchChannelsPresenterType>)presenter
              displayErrorHandler:(DisplayErrorHandler)displayErrorHandler {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _presenter = [presenter retain];
    _presenter.view = self;
    _displayErrorHandler = [displayErrorHandler copy];
  }
  return self;
}

- (void)dealloc {
  [_presenter release];
  [_tableView release];
  [_searchBar release];
  [_channels release];
  [_loadingView release];
  [_alreadyAdded release];
  [_cancelBarButton release];
  [_addBarButton release];
  [_displayErrorHandler release];
  [super dealloc];
}

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self layoutTableView];
  [self layoutLoadingView];
  self.navigationItem.titleView = self.searchBar;
  self.navigationItem.rightBarButtonItem = self.cancelBarButton;
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.presenter cancelSearch];
}
#pragma mark - Layout

- (void)layoutTableView {
  [self.view addSubview:self.tableView];
  [NSLayoutConstraint activateConstraints:@[
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
  ]];
}

- (void)layoutLoadingView {
  [self.view addSubview:self.loadingView];
  [NSLayoutConstraint activateConstraints:@[
    [self.loadingView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
    [self.loadingView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
    [self.loadingView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
    [self.loadingView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
  ]];
}

#pragma mark - Lazy Properties

- (UISearchBar *)searchBar {
  if (!_searchBar) {
    _searchBar = [UISearchBar new];
    _searchBar.delegate = self;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.placeholder = kSearchBarPlaceHolder;
    _searchBar.showsCancelButton = false;
    _searchBar.showsScopeBar = true;
    _searchBar.scopeButtonTitles = @[kScopeBarTitleWebsite, kScopeBarTitleRSSLink];
  }
  return _searchBar;
}

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView new] autorelease];
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.translatesAutoresizingMaskIntoConstraints = false;
    _tableView.allowsMultipleSelection = true;
    [_tableView registerClass:[SelectChannelViewCell class] forCellReuseIdentifier:NSStringFromClass([SelectChannelViewCell class])];
    ;
  }
  return _tableView;
}

- (LoadingView *)loadingView {
  if (!_loadingView) {
    _loadingView = [LoadingView new];
    _loadingView.translatesAutoresizingMaskIntoConstraints = false;
    [_loadingView hideLoading];
  }
  return _loadingView;
}

- (UIBarButtonItem *)cancelBarButton {
  if (!_cancelBarButton) {
    _cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                     target:self
                                                                     action:@selector(cancelButtonClicked)];
  }
  return _cancelBarButton;
}

- (UIBarButtonItem *)addBarButton {
  if (!_addBarButton) {
    _addBarButton = [[UIBarButtonItem alloc] initWithTitle:kAddBarButtonTitle
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(addButtonClicked)];
  }
  return _addBarButton;
}

- (NSArray<RSSChannel *> *)selectedChannels {
  NSMutableIndexSet *selectedIndexes = [NSMutableIndexSet indexSet];
  for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
    [selectedIndexes addIndex:indexPath.row];
  }
  return [self.channels objectsAtIndexes:selectedIndexes];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SelectChannelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectChannelViewCell class])];
  [cell configureWithChannel:self.channels[indexPath.row]
                alreadyAdded:[self.alreadyAdded containsIndex:indexPath.row]];
  return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  self.navigationItem.rightBarButtonItem = tableView.indexPathsForSelectedRows.count ? self.addBarButton : self.cancelBarButton;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  self.navigationItem.rightBarButtonItem = tableView.indexPathsForSelectedRows.count ? self.addBarButton : self.cancelBarButton;
}

#pragma mark - SearchResultsViewType

- (void)applyChannels:(NSArray<RSSChannel *> *)channels alreadyAdded:(NSIndexSet *)alreadyAdded {
  self.alreadyAdded = alreadyAdded;
  self.channels = channels;
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
  if (self.displayErrorHandler) {
    self.displayErrorHandler(error);
  }
}

#pragma mark - UISearchBar Delegate

- (void)cancelButtonClicked {
  [self.searchBar resignFirstResponder];
  [self dismissViewControllerAnimated:true completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder];
  switch (searchBar.selectedScopeButtonIndex) {
    case ScopesSearchBarWebsite:
      [self.presenter searchChannelsForSiteName:searchBar.text];
      break;
    case ScopesSearchBarRSSLink:
      [self.presenter searchChannelForLinkString:searchBar.text];
    default:
      break;
  }
}

- (void)addButtonClicked {
  [self.presenter addChannelsToLocalStorage:self.selectedChannels];
  [self dismissViewControllerAnimated:true completion:nil];
}

@end
