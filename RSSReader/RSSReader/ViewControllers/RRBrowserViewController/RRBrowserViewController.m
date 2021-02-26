//
//  RRBrowserViewController.m
//  RSSReader
//
//  Created by Arseniy Strakh on 04.12.2020.
//

#import "RRBrowserViewController.h"
#import "UIBarButtonItem+ASBlockInit.h"
#import <WebKit/WebKit.h>

void *kEstimatedProgressContext = &kEstimatedProgressContext;

@interface RRBrowserViewController () <WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *back;
@property (nonatomic, strong) UIBarButtonItem *forward;
@property (nonatomic, strong) UIBarButtonItem *reload;
@property (nonatomic, strong) UIBarButtonItem *stop;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic) CGFloat contentOffsetLastY;
@end

@implementation RRBrowserViewController

#pragma mark - Object Lifecycle

- (instancetype)initWithUrl:(NSURL *)url {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _url = url;
    }
    return self;
}

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAppearance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObservers];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeObservers];
}

#pragma mark - Layout

- (void)setupAppearance {
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }
    [self layoutWebView];
    [self layoutProgressView];
    [self setupToolbar];
}

- (void)layoutWebView {
    [self.view addSubview:self.webView];
    [NSLayoutConstraint activateConstraints:@[
        [self.webView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.webView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.webView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.webView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}

- (void)layoutProgressView {
    [self.view addSubview:self.progressView];
    [NSLayoutConstraint activateConstraints:@[
        [self.progressView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.progressView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.progressView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
    ]];
}

#pragma mark - Setup Toolbar

- (void)setupToolbar {
    UIBarButtonItem *spacer = [UIBarButtonItem systemItem:UIBarButtonSystemItemFlexibleSpace
                                               withAction:nil];

    __weak typeof(self) weakSelf = self;
    UIBarButtonItem *safari = [UIBarButtonItem systemItem:UIBarButtonSystemItemAction
                                               withAction:^{
        [UIApplication.sharedApplication openURL:weakSelf.webView.URL
                                         options:@{}
                               completionHandler:nil];
    }];

    UIBarButtonItem *reload = [UIBarButtonItem systemItem:UIBarButtonSystemItemRefresh
                                               withAction:^{
        [weakSelf.webView reload];
    }];

    self.toolbarItems = @[self.back, spacer, self.forward, spacer, reload, spacer, self.stop, spacer, safari];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.title = webView.title;
    self.stop.enabled = false;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [self.progressView setProgress:0 animated:false];
    self.back.enabled = webView.canGoBack;
    self.forward.enabled = webView.canGoForward;
    self.stop.enabled = true;
}

#pragma mark - WKUIDelegate

/// open any links which have target="_blank" a.k.a. 'Open in new Window' attribute in their HTML <`a href`>-Tag.
- (WKWebView *)webView:(WKWebView *)webView
createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
   forNavigationAction:(WKNavigationAction *)navigationAction
        windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - KVO

- (void)addObservers {
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                      options:NSKeyValueObservingOptionNew
                      context:kEstimatedProgressContext];
}

- (void)removeObservers {
    [self.webView removeObserver:self
                      forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == kEstimatedProgressContext) {
        [self.progressView setProgress:(float)self.webView.estimatedProgress animated:true];
        self.progressView.hidden = self.webView.estimatedProgress >= 1.0;
        if (self.progressView.hidden) { self.progressView.progress = 0.0; }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Lazy Properties

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _progressView;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [WKWebView new];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.delegate = self;
        _webView.allowsBackForwardNavigationGestures = true;
        _webView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _webView;
}

- (UIBarButtonItem *)back {
    if (!_back) {
        _back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
                                                              target:self.webView
                                                              action:@selector(goBack)];
        _back.enabled = false;
    }
    return _back;
}

- (UIBarButtonItem *)forward {
    if (!_forward) {
        _forward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                 target:self.webView
                                                                 action:@selector(goForward)];
        _forward.enabled = false;
    }
    return _forward;
}

- (UIBarButtonItem *)stop {
    if (!_stop) {
        _stop = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                              target:self.webView
                                                              action:@selector(stopLoading)];
        _stop.enabled = false;
    }
    return _stop;
}

#pragma mark - UIScrollViewDelegate Methods
/// Fixes hidesBarsOnSwipe showing bars with view attached to safeAreaLayoutGuide.topAnchor

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.contentOffsetLastY = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    BOOL shouldHide = scrollView.contentOffset.y > self.contentOffsetLastY;
    [self.navigationController setNavigationBarHidden:shouldHide animated:true];
    [self.navigationController setToolbarHidden:shouldHide animated:true];
}

@end
