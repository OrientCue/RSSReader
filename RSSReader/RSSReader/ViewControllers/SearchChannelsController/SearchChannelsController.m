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
#import "UIAlertController+RRErrorAlert.h"
#import "UIBarButtonItem+ASBlockInit.h"

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
@property (nonatomic, retain) NSIndexSet *alreadyAddedChannelsIndexes;
@property (nonatomic, retain) UIBarButtonItem *cancelBarButton;
@property (nonatomic, retain) UIBarButtonItem *addBarButton;
@end

@implementation SearchChannelsController
static NSString *const kSearchBarPlaceHolder = @"example.com";
static NSString *const kAddBarButtonTitle = @"   Add  ";

#pragma mark - Lifecycle

- (instancetype)initWithPresenter:(id<SearchChannelsPresenterType>)presenter {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _presenter = [presenter retain];
        _presenter.view = self;
    }
    return self;
}

- (void)dealloc {
    [_presenter release];
    [_tableView release];
    [_searchBar release];
    [_channels release];
    [_loadingView release];
    [_alreadyAddedChannelsIndexes release];
    [_cancelBarButton release];
    [_addBarButton release];
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
        _searchBar.scopeButtonTitles = @[
            NSLocalizedString(kScopeBarTitleWebsite, nil),
            NSLocalizedString(kScopeBarTitleRSSLink, nil)
        ];
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
    }
    return _loadingView;
}

- (UIBarButtonItem *)cancelBarButton {
    if (!_cancelBarButton) {
        __block typeof(self) weakSelf = self;
        _cancelBarButton = [[UIBarButtonItem alloc] initWithSystemItem:UIBarButtonSystemItemCancel
                                                                action:^{
            [weakSelf.searchBar resignFirstResponder];
            [weakSelf dismissViewControllerAnimated:true completion:nil];
        }];
    }
    return _cancelBarButton;
}

- (UIBarButtonItem *)addBarButton {
    if (!_addBarButton) {
        __block typeof(self) weakSelf = self;
        _addBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(kAddBarButtonTitle, nil)
                                                         style:UIBarButtonItemStylePlain
                                                        action:^{
            [weakSelf.presenter addChannelsToLocalStorage:weakSelf.selectedChannels];
            [weakSelf dismissViewControllerAnimated:true completion:nil];
        }];
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
                  alreadyAdded:[self.alreadyAddedChannelsIndexes containsIndex:indexPath.row]];
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
    self.alreadyAddedChannelsIndexes = alreadyAdded;
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
    [self showEmptyFeed];
    [UIAlertController showError:error sourceViewController:self handler:nil];
}

- (void)showEmptyFeed {
    self.channels = @[];
    self.alreadyAddedChannelsIndexes = [NSIndexSet indexSet];
}

#pragma mark - UISearchBar Delegate

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

@end
