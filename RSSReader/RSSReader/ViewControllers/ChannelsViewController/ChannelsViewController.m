//
//  ChannelsViewController.m
//  RSSReader
//
//  Created by Arseniy Strakh on 19.12.2020.
//

#import "ChannelsViewController.h"
#import "ChannelTableViewCell.h"
#import "RSSChannel.h"

@interface ChannelsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, readonly, retain) id<ChannelsPresenterType> presenter;
@property (nonatomic, retain) NSArray<RSSChannel *> *channels;
@property (nonatomic, retain) UITableView *tableView;
@end

@implementation ChannelsViewController

static NSString *const kChannelsViewControllerTitle = @"Channels";

#pragma mark - Object Lifecycle

- (instancetype)initWithPresenter:(id<ChannelsPresenterType>)presenter {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _presenter = [presenter retain];
    _presenter.view = self;
  }
  return self;
}

- (void)dealloc {
  [_tableView release];
  [_channels release];
  [_didSelectChannelHandler release];
  [_didTapAddButtonHandler release];
  [_displayErrorHandler release];
  [_presenter release];
  [super dealloc];
}

#pragma mark - Lazy Properties

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.tableFooterView = [[UIView new] autorelease];
    _tableView.translatesAutoresizingMaskIntoConstraints = false;
    [_tableView registerClass:[ChannelTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ChannelTableViewCell class])];
  }
  return _tableView;
}

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = kChannelsViewControllerTitle;
  [self layoutTableView];
  self.navigationItem.rightBarButtonItem = [self addChannelButtonItem];
  [self.presenter setup];
  [self.presenter loadFromLocalStorage];
}

#pragma mark - Layout

- (void)layoutTableView {
  [self.view addSubview:self.tableView];
  [NSLayoutConstraint activateConstraints:@[
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
  ]];
}

#pragma mark - Add Channels

- (UIBarButtonItem *)addChannelButtonItem {
  return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonDidTap)] autorelease];
}

- (void)addButtonDidTap {
  if (self.didTapAddButtonHandler) {
    self.didTapAddButtonHandler();
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChannelTableViewCell class])];
  [cell configureWithChannel:self.channels[indexPath.row]];
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.presenter updateStorageWithSelectedIndex:indexPath.row];
  if (self.didSelectChannelHandler) {
    self.didSelectChannelHandler(self.channels[indexPath.row]);
  }
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.presenter removeChannelFromLocalStorage:self.channels[indexPath.row]];
  }
}

#pragma mark - ChannelsViewType

- (void)displayFeedForChannels:(NSArray<RSSChannel *> *)channels selected:(NSUInteger)selected {
  self.channels = [[channels mutableCopy] autorelease];
  [self.tableView reloadData];
  if (selected >= 0 && selected < self.channels.count && self.didSelectChannelHandler) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selected inSection:0];
    if (![self.tableView.indexPathForSelectedRow isEqual:indexPath]) {
      self.didSelectChannelHandler(self.channels[selected]);
    }
    [self.tableView selectRowAtIndexPath:indexPath
                                animated:true
                          scrollPosition:UITableViewScrollPositionNone];
  }
}

- (void)update:(NSArray<RSSChannel *> *)channels selected:(NSUInteger)selected {
  self.channels = channels;
  [self.tableView reloadData];
  if (selected >= 0 && selected < self.channels.count && self.channels) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selected inSection:0];
      [self.tableView selectRowAtIndexPath:indexPath
                                animated:true
                          scrollPosition:UITableViewScrollPositionNone];
  }
}

- (void)displayError:(NSError *)error {
  [self showEmptyFeed];
  if (self.displayErrorHandler) {
    self.displayErrorHandler(error);
  }
}

- (void)showEmptyFeed {
  self.channels = @[];
  [self.tableView reloadData];
}

@end
