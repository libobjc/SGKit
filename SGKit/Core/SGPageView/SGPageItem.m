//
//  SGPageItem.m
//  SGKit
//
//  Created by Single on 2016/11/18.
//  Copyright © 2016年 single. All rights reserved.
//

#import "SGPageItem.h"

@interface SGPageItem ()

@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation SGPageItem

- (void)setContentView:(UIView *)contentView
{
    if (_contentView != contentView) {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        contentView.frame = self.bounds;
        [self.scrollView addSubview:contentView];
        self.scrollView = contentView.backgroundColor;
    }
}

- (UIScrollView *)scrollViewInPageItem:(UIView *)pageItem
{
    return self.scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self superUILayout];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self superUILayout];
    }
    return self;
}

- (void)superUILayout
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = self.bounds.size;
    self.contentView.frame = self.bounds;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.contentSize = self.bounds.size;
    }
    return _scrollView;
}

@end
