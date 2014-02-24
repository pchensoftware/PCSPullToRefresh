//
//  MyController.m
//  PCSPullToRefreshExample
//
//  Created by Peter Chen on 2/21/14.
//  Copyright (c) 2014 Peter Chen. All rights reserved.
//

#import "MyController.h"
#import "PCSPullToRefresh.h"

@interface MyController ()

@end

@implementation MyController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   if (self) {
      // Custom initialization
   }
   return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   self.title = @"Pull to Refresh";
   
   self.tableView.pcsRefreshControl = [[PCSPullToRefresh alloc] init];
   [self.tableView.pcsRefreshControl addTarget:self action:@selector(_refreshDidBegin) forControlEvents:UIControlEventValueChanged];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
   if (! cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
   }
   cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
   return cell;
}

- (void)_refreshDidBegin {
   [self.tableView.pcsRefreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:2];
}

@end
