//
//  TableView.m
//  ScrollDemo
//
//  Created by Single on 2016/10/27.
//  Copyright © 2016年 single. All rights reserved.
//

#import "SGTableViewExample.h"

@interface SGTableViewExample () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) NSInteger number;

@end

@implementation SGTableViewExample

- (UIScrollView *)scrollViewInPageItem:(UIView *)pageItem
{
    return self.tableView;
}

- (instancetype)initWithNumber:(NSInteger)number
{
    if (self = [super initWithFrame:CGRectZero])
    {
        self.number = number;
        [self UILayout];
    }
    return self;
}

- (void)UILayout
{
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self addSubview:self.tableView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行", indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
