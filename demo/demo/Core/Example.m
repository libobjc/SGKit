//
//  Example.m
//  SGDemo
//
//  Created by Single on 2016/11/17.
//  Copyright © 2016年 single. All rights reserved.
//

#import "Example.h"

@interface Example () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation Example

- (NSArray<NSString *> *)classNames
{
    return @[@"SGSwipeViewExample",
             @"SGPageViewExample",
             @"SGTransformViewExample",
             @"SGCollectionViewFlowLayoutExample",
             @"SGImagePlayerExample",
             @"SGGuideViewExample"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"SGKit";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateLayout];
}

- (void)updateLayout
{
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [self.classNames objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class class = NSClassFromString([self.classNames objectAtIndex:indexPath.row]);
    UIViewController * example = [[class alloc] init];
    example.title = [self.classNames objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:example animated:YES];
}

@end
