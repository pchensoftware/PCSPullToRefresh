//
//  PCSPullToRefresh.h
//  PCSPullToRefreshExample
//
//  Created by Peter Chen on 2/21/14.
//  Copyright (c) 2014 Peter Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

// UIControlEventValueChanged will be sent when the pull and release past the threshold occurs.
// Set hidden=YES to hide AND disable the control.

@interface PCSPullToRefresh : UIControl

@property (nonatomic, readonly) BOOL refreshing;
@property (nonatomic, readonly) UILabel *refreshLabel;

@property (nonatomic, strong) NSString *pullMessage;       // Defaults to @"Pull to Refresh"
@property (nonatomic, strong) NSString *releaseMessage;    // Defaults to @"Release to Refresh"
@property (nonatomic, strong) NSString *refreshingMessage; // Defaults to @"Refreshing..."

@property (nonatomic, assign) int pullOffsetThreshold; // defaults to 50

- (void)beginRefreshing;
- (void)endRefreshing;

@end

@interface UIScrollView (PCSPullToRefresh)

@property (nonatomic, strong) PCSPullToRefresh *pcsRefreshControl; // top
@property (nonatomic, strong) PCSPullToRefresh *pcsRefreshControlBottom;

@end
