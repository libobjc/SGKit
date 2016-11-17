//
//  SGPageTitleView.m
//  SGKit
//
//  Created by Single on 2016/11/17.
//  Copyright © 2016年 single. All rights reserved.
//

#import "SGPageTitleView.h"
#import "SGPageView.h"

static CGFloat const SGPageTitleWidth = 80;

@interface SGPageTitleView () <UIScrollViewDelegate>

@property (nonatomic, weak) SGPageView * pageView;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSArray <SGPageTitleItem *> * titleItems;

@end

@implementation SGPageTitleView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self UILayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self UILayout];
    }
    return self;
}

- (void)UILayout
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollView];
}

- (void)scrollToIndex:(NSInteger)index
{
    [self scrollToIndex:index animated:YES];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated
{
    [self selectedIndexDidChange];
}

- (void)selectedIndexDidChange
{
    [self.titleItems enumerateObjectsUsingBlock:^(SGPageTitleItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.pageView.index == idx) {
            [obj selectedStyle];
        } else {
            [obj normalStyle];
        }
    }];
}

- (void)reloadData
{
    [self.titleItems enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.titleItems = nil;
    
    NSMutableArray <UIView *> * titleViewsTemp = [NSMutableArray arrayWithCapacity:self.pageView.numberOfPage];
    
    NSMutableArray <SGPageTitleItem *> * titleItemsTemp = [NSMutableArray arrayWithCapacity:self.pageView.numberOfPage];
    for (NSInteger i = 0; i < self.pageView.numberOfPage; i++) {
        SGPageTitleItem * item = [self.pageView.delegate pageView:self.pageView pageTitleView:self titleItemAtIndex:i];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageTitleItemTapAction:)];
        [item addGestureRecognizer:tap];
        [titleItemsTemp addObject:item];
        [self.scrollView addSubview:item];
    }
    self.titleItems = titleItemsTemp;
    
    [self resetLayout];
    [self selectedIndexDidChange];
}

- (void)pageTitleItemTapAction:(UITapGestureRecognizer *)tap
{
    [self.pageView scrollToIndex:[self.titleItems indexOfObject:tap.view]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self resetLayout];
}

- (void)resetLayout
{
    self.scrollView.frame = self.bounds;
    
    __block CGFloat left = 0;
    [self.titleItems enumerateObjectsUsingBlock:^(SGPageTitleItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(left, 0, obj.itemWidth, CGRectGetHeight(self.bounds));
        left += obj.itemWidth;
    }];
    
    self.scrollView.contentSize = CGSizeMake(left, CGRectGetHeight(self.bounds));
    [self scrollToIndex:self.pageView.index animated:NO];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end
