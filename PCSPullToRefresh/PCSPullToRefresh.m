//
//  PCSPullToRefresh.m
//  PCSPullToRefreshExample
//
//  Created by Peter Chen on 2/21/14.
//  Copyright (c) 2014 Peter Chen. All rights reserved.
//

#import "PCSPullToRefresh.h"
#import <objc/runtime.h>

static const int kHeight = 100;
static const int kPullOffsetThreshold = 50;
static NSString *kUIScrollViewPCSRefreshControlKey = @"kUIScrollViewPCSRefreshControlKey";

typedef NS_ENUM(int, PCSPullToRefreshState) {
   PCSPullToRefreshStateIdle,
   PCSPullToRefreshStateRelease,
   PCSPullToRefreshStateRefreshing,
};


@interface PCSPullToRefresh()

@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, assign) PCSPullToRefreshState refreshState;
@property (nonatomic, readonly) UIScrollView *parentScrollView;

@end

@implementation PCSPullToRefresh

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:CGRectMake(0, -kHeight, 100, kHeight)];
   if (self) {
      self.refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20)];
      self.refreshLabel.textAlignment = NSTextAlignmentCenter;
      self.refreshLabel.font = [UIFont boldSystemFontOfSize:15];
      self.refreshLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      [self addSubview:self.refreshLabel];
      
      self.pullMessage = @"Pull to Refresh";
      self.releaseMessage = @"Release to Refresh";
      self.refreshingMessage = @"Refreshing...";
      
      self.refreshState = PCSPullToRefreshStateIdle;
   }
   return self;
}

- (void)dealloc {
   [self.superview removeObserver:self forKeyPath:@"contentOffset"];
}

- (UIScrollView *)parentScrollView {
   return (UIScrollView *) self.superview;
}

- (void)setupWithScrollView:(UIScrollView *)scrollView {
   CGRect frame = self.frame;
   frame.size.width = scrollView.frame.size.width;
   self.frame = frame;
   self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
   
   [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setRefreshState:(PCSPullToRefreshState)refreshState {
   _refreshState = refreshState;
   
   if (PCSPullToRefreshStateIdle == refreshState)
      self.refreshLabel.text = self.pullMessage;
   else if (PCSPullToRefreshStateRelease == refreshState)
      self.refreshLabel.text = self.releaseMessage;
   else
      self.refreshLabel.text = self.refreshingMessage;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
   if ([keyPath isEqualToString:@"contentOffset"]) {
      int offsetY = self.parentScrollView.contentOffset.y + self.parentScrollView.contentInset.top;
      BOOL isContentOffstePastThreshold = offsetY < -kPullOffsetThreshold;
      
      if (self.refreshState == PCSPullToRefreshStateIdle) {
         if (self.parentScrollView.dragging && isContentOffstePastThreshold)
            self.refreshState = PCSPullToRefreshStateRelease;
      }
      else if (self.refreshState == PCSPullToRefreshStateRelease) {
         if (self.parentScrollView.dragging) {
            if (! isContentOffstePastThreshold)
               self.refreshState = PCSPullToRefreshStateIdle;
         }
         else {
            self.refreshState = PCSPullToRefreshStateRefreshing;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
         }
      }
   }
}

- (BOOL)refreshing {
   return self.state == PCSPullToRefreshStateRefreshing;
}

- (void)beginRefreshing {
   self.refreshState = PCSPullToRefreshStateRefreshing;
}

- (void)endRefreshing {
   self.refreshState = PCSPullToRefreshStateIdle;
}

@end

//==================================================
#pragma mark - UIScrollView (PCSPullToRefresh)
//==================================================

@implementation UIScrollView (PCSPullToRefresh)

- (PCSPullToRefresh *)pcsRefreshControl {
   return objc_getAssociatedObject(self, &kUIScrollViewPCSRefreshControlKey);
}

- (void)setPcsRefreshControl:(PCSPullToRefresh *)pcsRefreshControl {
   objc_setAssociatedObject(self, &kUIScrollViewPCSRefreshControlKey, pcsRefreshControl, OBJC_ASSOCIATION_RETAIN);
   [self addSubview:pcsRefreshControl];
   [pcsRefreshControl setupWithScrollView:self];
}

@end