//
//  LoadingView.m
//  RSSReader
//
//  Created by Arseniy Strakh on 22.12.2020.
//

#import "LoadingView.h"

@interface LoadingView ()
@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) UILabel *loadingLabel;
@end

@implementation LoadingView

static NSString *const kLoadingText = @"Loading";
static CGFloat const kStackViewSpacing = 5.0;
static CGFloat const kLabelFontSize = 10.0;
static CGFloat const kViewFadeAnimationDuration = 0.25;

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (void)commonInit {
  if (@available(iOS 13.0, *)) {
    self.backgroundColor = UIColor.systemBackgroundColor;
  } else {
    self.backgroundColor = UIColor.whiteColor;
  }
  
  UIStackView *loadingStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.loadingIndicator, self.loadingLabel]];
  loadingStackView.axis = UILayoutConstraintAxisVertical;
  loadingStackView.distribution = UIStackViewDistributionEqualSpacing;
  loadingStackView.alignment = UIStackViewAlignmentCenter;
  loadingStackView.spacing = kStackViewSpacing;
  
  loadingStackView.translatesAutoresizingMaskIntoConstraints = false;
  [self addSubview:loadingStackView];
  [NSLayoutConstraint activateConstraints: @[
    [loadingStackView.centerXAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.centerXAnchor],
    [loadingStackView.centerYAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.centerYAnchor],
  ]];
  [loadingStackView release];
  self.alpha = 0.0;
}

- (void)dealloc {
  [_loadingIndicator release];
  [_loadingLabel release];
  [super dealloc];
}

#pragma mark -

- (UILabel *)loadingLabel {
  if (!_loadingLabel) {
    _loadingLabel = [UILabel new];
    _loadingLabel.text = NSLocalizedString(kLoadingText, nil);
    _loadingLabel.font = [UIFont systemFontOfSize:kLabelFontSize weight:UIFontWeightMedium];
    if (@available(iOS 13.0, *)) {
      _loadingLabel.textColor = UIColor.labelColor;
    } else {
      _loadingLabel.textColor = UIColor.blackColor;
    }
  }
  return _loadingLabel;
}

- (UIActivityIndicatorView *)loadingIndicator {
  if (!_loadingIndicator) {
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    if (@available(iOS 13.0, *)) {
      _loadingIndicator.color = UIColor.secondaryLabelColor;
    } else {
      _loadingIndicator.color = UIColor.darkGrayColor;
    }
    _loadingIndicator.hidesWhenStopped = false;
  }
  return _loadingIndicator;
}

#pragma mark -

- (void)showLoading {
  [self.loadingIndicator startAnimating];
  [UIView animateWithDuration:kViewFadeAnimationDuration animations:^{
    self.alpha = 1.0;
  }];
}

- (void)hideLoading {
  [self.loadingIndicator stopAnimating];
  [UIView animateWithDuration:kViewFadeAnimationDuration animations:^{
    self.alpha = 0.0;
  }];
}

@end
