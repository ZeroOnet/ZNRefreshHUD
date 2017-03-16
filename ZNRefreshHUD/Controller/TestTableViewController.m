//
//  TestTableViewController.m
//  ZNRefreshHUD
//
//  Created by FunctionMaker on 2017/3/13.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import "TestTableViewController.h"
#import "UIScrollView+ZNRefreshHUD.h"
#import "ZNRefreshHUD.h"
#import "RefreshingCallBack.h"

static NSString *const testID = @"TEST_CEll";

@interface TestTableViewController () <RefreshingCallBack>

@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"table";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:testID];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.ZNHeader = [ZNRefreshHUD refreshHUD];
    self.tableView.ZNHeader.callBackDelegate = self;
}

#pragma mark - Table view data souce

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:testID];
    cell.textLabel.text = @"cell";
    return cell;
}

#pragma mark - Refresh call back

- (void)RefreshingShouldCallBack {
    sleep(3);
    
    NSLog(@"刷新完毕");
    
    [self.tableView.ZNHeader finishRefreshing];
}

@end
