//
//  SGSwipeViewExample.m
//  SGDemo
//
//  Created by Single on 2016/11/18.
//  Copyright © 2016年 single. All rights reserved.
//

#import "SGSwipeViewExample.h"
#import <SGKit/SGKit.h>
#import "SGTableViewExample.h"

@interface SGSwipeViewExample () <SGSwipeViewDelegate, SGPageViewDelegate>

@property (nonatomic, strong) SGSwipeView * swipeView;
@property (nonatomic, strong) SGPageView * pageView;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) SGPageTitleView * pageTitleView;

@end

@implementation SGSwipeViewExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self UILayout];
}

- (void)UILayout
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pageView = [[SGPageView alloc] initWithFrame:CGRectZero];
    self.pageView.delegate = self;
    
    self.pageTitleView = [[SGPageTitleView alloc] initWithFrame:CGRectZero];
    self.pageTitleView.showBottomLine = YES;
    self.pageTitleView.leftMargin = 100;
    self.pageTitleView.rightMargin = 50;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.headerView.backgroundColor = [UIColor yellowColor];
    
    self.swipeView = [[SGSwipeView alloc] initWithFrame:self.view.bounds];
    self.swipeView.delegate = self;

    [self.view addSubview:self.swipeView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.swipeView.frame = self.view.bounds;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        self.swipeView.topMargin = 30;
    } else {
        self.swipeView.topMargin = 64;
    }
}


#pragma mark - SGSwipeViewDelegate

- (SGPageView *)pageViewInSwipeView:(SGSwipeView *)swipeView
{
    return self.pageView;
}

- (UIView *)headerViewInSwipeView:(SGSwipeView *)swipeView
{
    return self.headerView;
}

- (CGFloat)headerViewHeightInSwipeView:(SGSwipeView *)swipeView
{
    return 180;
}

- (CGFloat)pageTitleViewHeightInSwipeView:(SGSwipeView *)swipeView
{
    return 44;
}


#pragma SGPageViewDelegate

- (NSInteger)numberOfPagesInPageView:(SGPageView *)pageView
{
    return 5;
}

- (UIView <SGPageItemDelegate> *)pageView:(SGPageView *)pageView viewAtIndex:(NSInteger)index
{
    UIView <SGPageItemDelegate> * view;
    if (index == 0) {
        view = (UIView <SGPageItemDelegate> *)[[UIView alloc] init];
        UIView * label = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 200, 80)];
        label.backgroundColor = [UIColor cyanColor];
        view.backgroundColor = [UIColor redColor];
        [view addSubview:label];
        return view;
    } else if (index == 1) {
        view = [[SGTableViewExample alloc] initWithNumber:10];
    } else {
        view = [[SGTableViewExample alloc] initWithNumber:100];
    }
    return view;
}

- (void)pageView:(SGPageView *)pageView didScrollToIndex:(NSInteger)index
{
    
}

- (SGPageTitleView *)pageTitleViewInPageView:(SGPageView *)pageView
{
    return self.pageTitleView;
}

- (SGPageTitleItem *)pageView:(SGPageView *)pageView pageTitleView:(SGPageTitleView *)pageTitleView titleItemAtIndex:(NSInteger)index
{
    SGPageTitleLabelItem * item = [[SGPageTitleLabelItem alloc] initWithFrame:CGRectZero];
    item.text = [NSString stringWithFormat:@"%ld", index];
    item.selectedColor = [UIColor redColor];
    item.selectedFont = [UIFont systemFontOfSize:16];
    item.itemWidth = arc4random()%100 + 50;
    return item;
}

@end
