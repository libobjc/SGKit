//
//  SGPageViewExample.m
//  SGDemo
//
//  Created by Single on 2016/11/17.
//  Copyright © 2016年 single. All rights reserved.
//

#import "SGPageViewExample.h"
#import <SGKit/SGKit.h>
#import "SGTableViewExample.h"

@interface SGPageViewExample () <SGPageViewDelegate>

@property (nonatomic, strong) SGPageView * pageView;
@property (nonatomic, strong) SGPageTitleView * pageTitleView;

@end

@implementation SGPageViewExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self UILayout];
}

- (void)UILayout
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pageView = [[SGPageView alloc] initWithFrame:CGRectZero];
    self.pageView.delegate = self;
    self.pageView.defaultIndex = 2;
    
    self.pageTitleView = [[SGPageTitleView alloc] initWithFrame:CGRectZero];
    self.pageTitleView.bottomLineColor = [UIColor sg_colorWithRed:242 green:167 blue:151];
    self.pageTitleView.bottomBoardColor = [UIColor sg_colorWithRed:242 green:167 blue:151];
    self.pageTitleView.showBottomLine = YES;
    self.pageTitleView.leftMargin = 100;
    self.pageTitleView.rightMargin = 50;
    self.pageTitleView.showBottomBoard = YES;
    
    [self.view addSubview:self.pageView];
    [self.view addSubview:self.pageTitleView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.pageTitleView.frame = CGRectMake(0, 70, CGRectGetWidth(self.view.bounds), 44);
    self.pageView.frame = CGRectMake(0,
                                     CGRectGetMaxY(self.pageTitleView.frame),
                                     CGRectGetWidth(self.view.bounds),
                                     CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.pageTitleView.frame));
    
}

- (NSInteger)numberOfPagesInPageView:(SGPageView *)pageView
{
    return 5;
}

- (UIView *)pageView:(SGPageView *)pageView viewAtIndex:(NSInteger)index
{
    SGTableViewExample * view = [[SGTableViewExample alloc] initWithNumber:100];
    view.backgroundColor = [UIColor sg_randomColor];
    return view;
}

- (void)pageView:(SGPageView *)pageView didScrollToIndex:(NSInteger)index
{
    NSLog(@"scroll to index : %ld", index);
}

- (SGPageTitleView *)pageTitleViewInPageView:(SGPageView *)pageView
{
    return self.pageTitleView;
}

- (SGPageTitleItem *)pageView:(SGPageView *)pageView pageTitleView:(SGPageTitleView *)pageTitleView titleItemAtIndex:(NSInteger)index
{
    SGPageTitleLabelItem * item = [[SGPageTitleLabelItem alloc] initWithFrame:CGRectZero];
    item.text = [NSString stringWithFormat:@"%ld", index];
    item.selectedColor = [UIColor sg_colorWithRed:242 green:167 blue:151];
    item.selectedFont = [UIFont systemFontOfSize:16];
    item.itemWidth = 100;
    return item;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.pageView reloadData];
}

@end
