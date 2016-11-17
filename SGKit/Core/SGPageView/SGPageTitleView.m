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
@property (nonatomic, strong) UIView * bottomLineView;

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
    
    self.bottomLineHeight = 2;
    self.bottomLineColor = [UIColor redColor];
    self.bottomLineAnimatedDuration = 0.25;
}

- (void)scrollToIndex:(NSInteger)index
{
    [self scrollToIndex:index animated:YES];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated
{
    [self selectedIndexDidChange];
    [self resetBottomLineViewLocation:animated];
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
        [self.scrollView insertSubview:item atIndex:0];
    }
    self.titleItems = titleItemsTemp;
    
    [self resetLayout];
    [self selectedIndexDidChange];
    [self resetBottomLineViewLocation:NO];
}

- (void)pageTitleItemTapAction:(UITapGestureRecognizer *)tap
{
    [self.pageView scrollToIndex:[self.titleItems indexOfObject:tap.view]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self resetLayout];
    [self resetBottomLineViewLocation:NO];
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

- (void)resetBottomLineViewLocation:(BOOL)animated
{
    if (!self.bottomLineView) return;
    if (self.bottomLineAnimatedDuration <= 0.03) animated = NO;
    
    CGRect selectedItemFrame = [self.titleItems objectAtIndex:self.pageView.index].frame;
    CGRect frame = CGRectMake(selectedItemFrame.origin.x, CGRectGetHeight(self.bounds) - self.bottomLineHeight, CGRectGetWidth(selectedItemFrame), self.bottomLineHeight);
    if (animated) {
        [UIView animateWithDuration:self.bottomLineAnimatedDuration animations:^{
            self.bottomLineView.frame = frame;
        }];
    } else {
        self.bottomLineView.frame = frame;
    }
}

- (void)setupBottomLineView
{
    if (self.showBottomLine) {
        if (!self.bottomLineView) {
            self.bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
            [self.scrollView addSubview:self.bottomLineView];
        }
        self.bottomLineView.backgroundColor = self.bottomLineColor;
        [self resetBottomLineViewLocation:NO];
    } else {
        [self.bottomLineView removeFromSuperview];
        self.bottomLineView = nil;
    }
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

- (void)setShowBottomLine:(BOOL)showBottomLine
{
    if (_showBottomLine != showBottomLine) {
        _showBottomLine = showBottomLine;
        [self setupBottomLineView];
    }
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor
{
    if (_bottomLineColor != bottomLineColor) {
        _bottomLineColor = bottomLineColor;
        [self setupBottomLineView];
    }
}

- (void)setBottomLineHeight:(CGFloat)bottomLineHeight
{
    if (_bottomLineHeight != bottomLineHeight) {
        _bottomLineHeight = bottomLineHeight;
        [self resetBottomLineViewLocation:NO];
    }
}

@end
