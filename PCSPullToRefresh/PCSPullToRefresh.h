//
//  PCSPullToRefresh.h
//  PCSPullToRefreshExample
//
//  Created by Peter Chen on 2/21/14.
//  Copyright (c) 2014 Peter Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCSPullToRefresh : UIControl

@property (nonatomic, readonly) BOOL refreshing;
@property (nonatomic, readonly) UILabel *refreshLabel;

@property (nonatomic, strong) NSString *pullMessage;       // Defaults to @"Pull to Refresh"
@property (nonatomic, strong) NSString *releaseMessage;    // Defaults to @"Release to Refresh"
@property (nonatomic, strong) NSString *refreshingMessage; // Defaults to @"Refreshing..."

- (void)beginRefreshing;
- (void)endRefreshing;

@end

@interface UIScrollView (PCSPullToRefresh)

@property (nonatomic, strong) PCSPullToRefresh *pcsRefreshControl;

@end
