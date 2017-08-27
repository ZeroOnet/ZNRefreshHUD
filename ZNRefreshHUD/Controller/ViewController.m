//
//  ViewController.m
//  ZNRefreshHUD
//
//  Created by FunctionMaker on 2017/3/8.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+ZNRefreshHUD.h"
#import "ZNRefreshHUD.h"
#import "RefreshingCallBack.h"
#import "TestTableViewController.h"

static NSString * const ID = @"TIME_CELL";

@interface ViewController () <RefreshingCallBack>

@property (strong, nonatomic) NSMutableArray<NSDate *> *dates;

@end

@implementation ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"home";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor orangeColor];
    self.tableView.ZNHeader = [ZNRefreshHUD refreshHUD];
    self.tableView.ZNHeader.callBackDelegate = self;
    
    //self.tableView.ZNHeader.circleStrokeColor = [UIColor grayColor].CGColor;//default is orange color
}

#pragma mark - Table view dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.textLabel.text = [self.dates[indexPath.row] descriptionWithLocale:[NSLocale systemLocale]];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.tintColor = [UIColor orangeColor];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[TestTableViewController alloc] init] animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Scorll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [super scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - Refreshing call back

- (void)RefreshingShouldCallBack {
    [self simulateNetworkLoading];
    
    NSDate *date = [NSDate date];
    [self.dates addObject:date];
    
    [self.tableView reloadData];
    
    [self.tableView.ZNHeader finishRefreshing];
}

#pragma mark - Private method

- (void)simulateNetworkLoading {
    sleep(3);
}

#pragma mark - Getter

- (NSMutableArray<NSDate *> *)dates {
    if (!_dates) {
        _dates = [NSMutableArray array];
    }
    
    return _dates;
}

@end
