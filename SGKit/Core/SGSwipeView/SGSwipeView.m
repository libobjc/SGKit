//
//  SGSwipeView.m
//  SGKit
//
//  Created by Single on 2016/11/18.
//  Copyright © 2016年 single. All rights reserved.
//

#import "SGSwipeView.h"

@interface SGSwipeView ()

{
    dispatch_once_t _loadDataToken;
}

@property (nonatomic, strong) SGPageView * pageView;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) CGFloat pageTitleViewHeight;
@property (nonatomic, assign) CGFloat topMargin;

@property (nonatomic, strong) NSArray <UIScrollView *> * scrollViews;
@property (nonatomic, strong) UIScrollView * currentScrollView;
@property (nonatomic, assign) CGFloat contentViewTopDistant;
@property (nonatomic, assign, readonly) CGFloat scrollViewContentInsetHeight;


@end

@implementation SGSwipeView

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
}

- (void)reloadData
{
    [self.pageView removeFromSuperview];
    self.pageView = nil;
    [self.headerView removeFromSuperview];
    self.headerView = nil;
    [self.pageView.pageTitleView removeFromSuperview];
    [self clearScrollViews];
    
    self.contentViewTopDistant = 0;
    self.pageView = [self.delegate pageViewInSwipeView:self];
    [self addSubview:self.pageView];
    self.headerView = [self.delegate headerViewInSwipeView:self];
    [self addSubview:self.headerView];
    self.headerViewHeight = [self.delegate headerViewHeightInSwipeView:self];
    if ([self.delegate respondsToSelector:@selector(topMarginInSwipeView:)]) {
        self.topMargin = [self.delegate topMarginInSwipeView:self];
        if (self.topMargin < 0) self.topMargin = 0;
    } else {
        self.topMargin = 0;
    }
    [self.pageView reloadData];
    if (self.pageView.pageTitleView) {
        [self addSubview:self.pageView.pageTitleView];
        self.pageTitleViewHeight = [self.delegate pageTitleViewHeightInSwipeView:self];
    }
    
    NSMutableArray * scrollViewsTemp = [NSMutableArray array];
    [self.pageView.pages enumerateObjectsUsingBlock:^(UIView <SGPageItemDelegate> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(scrollViewInPageItem:)]) {
            UIScrollView * scrollView = [obj scrollViewInPageItem:obj];
            [scrollViewsTemp addObject:scrollView];
            scrollView.contentInset = UIEdgeInsetsMake(self.scrollViewContentInsetHeight, 0, 0, 0);
            [scrollView setContentOffset:CGPointMake(0, -self.scrollViewContentInsetHeight) animated:NO];
            [scrollView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
            [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        }
    }];
    self.scrollViews = scrollViewsTemp;
    
    [self resetLayout];
}

- (void)clearScrollViews
{
    [self.scrollViews enumerateObjectsUsingBlock:^(UIScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
        [obj removeObserver:self forKeyPath:@"contentOffset"];
    }];
    self.scrollViews = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self resetLayout];
}

- (void)resetLayout
{
    self.pageView.frame = self.bounds;
    [self resetHeaderAndTitleViewLayout];
}

- (CGFloat)scrollViewContentInsetHeight
{
    return self.headerViewHeight + self.pageTitleViewHeight;
}

- (void)setContentViewTopDistant:(CGFloat)contentViewTopDistant
{
    if (_contentViewTopDistant != contentViewTopDistant) {
        
        CGFloat preContentViewTopDistant = _contentViewTopDistant;
        _contentViewTopDistant = contentViewTopDistant;
        
        [self.scrollViews enumerateObjectsUsingBlock:^(UIScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj != self.currentScrollView) {
                [obj setContentOffset:CGPointMake(0, obj.contentOffset.y-(_contentViewTopDistant-preContentViewTopDistant)) animated:NO];
            }
        }];
        
        [self resetHeaderAndTitleViewLayout];
        
        CGFloat scale = (-_contentViewTopDistant / (self.headerViewHeight-self.topMargin));
        if ([self.delegate respondsToSelector:@selector(swipeView:didChangeOffsetScale:)]) {
            [self.delegate swipeView:self didChangeOffsetScale:scale];
        }
    }
}

- (void)resetHeaderAndTitleViewLayout
{
    self.headerView.frame = CGRectMake(0, self.contentViewTopDistant, CGRectGetWidth(self.frame), self.headerViewHeight);
    self.pageView.pageTitleView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), CGRectGetWidth(self.frame), self.pageTitleViewHeight);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"])
    {
        self.currentScrollView = (UIScrollView *)[(UIGestureRecognizer *)object view];
    }
    else if ([keyPath isEqualToString:@"contentOffset"])
    {
        if (object == self.currentScrollView)
        {
            CGFloat contentHeight = self.currentScrollView.contentSize.height - CGRectGetHeight(self.currentScrollView.frame);
            if (contentHeight < CGRectGetHeight(self.currentScrollView.frame)) {
                contentHeight = CGRectGetHeight(self.currentScrollView.frame);
            }
            CGFloat oldOffsetY          = [change[NSKeyValueChangeOldKey] CGPointValue].y;
            CGFloat newOffsetY          = [change[NSKeyValueChangeNewKey] CGPointValue].y;
            
            if (oldOffsetY == newOffsetY) return;
            if (oldOffsetY > contentHeight && newOffsetY > contentHeight) return;
            if (oldOffsetY < -self.scrollViewContentInsetHeight && newOffsetY < -self.scrollViewContentInsetHeight) return;
            
            if (oldOffsetY > contentHeight) oldOffsetY = contentHeight;
            if (newOffsetY > contentHeight) newOffsetY = contentHeight;
            
            if (oldOffsetY < -self.scrollViewContentInsetHeight) oldOffsetY = -self.scrollViewContentInsetHeight;
            if (newOffsetY < -self.scrollViewContentInsetHeight) newOffsetY = -self.scrollViewContentInsetHeight;
            
            CGFloat deltaY = newOffsetY - oldOffsetY;
            if (deltaY == 0) return;
            
            if (deltaY > 0 || (deltaY < 0 && newOffsetY < -(self.topMargin + self.pageTitleViewHeight)))
            {
                CGFloat topOffset = self.contentViewTopDistant - deltaY;
                
                if (topOffset < -(self.headerViewHeight - self.topMargin)) {
                    topOffset = -(self.headerViewHeight - self.topMargin);
                }
                if (topOffset > 0) {
                    topOffset = 0;
                }
                
                self.contentViewTopDistant = topOffset;
            }
        }
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    dispatch_once(&_loadDataToken, ^{
        [self reloadData];
    });
}

- (void)dealloc
{
    [self clearScrollViews];
}

@end
