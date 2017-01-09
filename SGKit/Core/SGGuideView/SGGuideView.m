//
//  GuideView.m
//  opera
//
//  Created by Single on 15/12/20.
//  Copyright © 2015年 single. All rights reserved.
//

#import "SGGuideView.h"

@interface SGGuideView () <UIScrollViewDelegate>

{
    dispatch_once_t onceToken;
}

@property (nonatomic, strong) NSArray <NSString *> * imageNames;
@property (nonatomic, strong) NSArray <UIImageView *> * imageViews;

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIImageView * backgroundImageView;
@property (nonatomic, strong) UIPageControl * pageControl;

@end

@implementation SGGuideView

+ (instancetype)guideViewWithImageNames:(NSArray<NSString *> *)imageNames
{
    return [[self alloc] initWithImageNames:imageNames];
}

- (instancetype)initWithImageNames:(NSArray<NSString *> *)imageNames
{
    if (self = [super initWithFrame:CGRectZero])
    {
        self.imageNames = imageNames;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor =[UIColor whiteColor];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.scrollView addSubview:obj];
    }];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    self.backgroundImageView.frame = frame;
    self.scrollView.frame = frame;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(frame) * self.imageNames.count, CGRectGetHeight(frame));
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 40, CGRectGetWidth(frame), 20);
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(CGRectGetWidth(frame) * idx, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    }];
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self insertSubview:_backgroundImageView atIndex:0];
    }
    return _backgroundImageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        
        _pageControl.numberOfPages = self.imageNames.count;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPage = 0;
        _pageControl.backgroundColor = [UIColor clearColor];
    }
    return _pageControl;
}

- (void)setPageControlHidden:(BOOL)pageControlHidden
{
    self.pageControl.hidden = pageControlHidden;
}

- (BOOL)pageControlHidden
{
    return self.pageControl.hidden;
}

- (NSArray<UIImageView *> *)imageViews
{
    if (!_imageViews) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:self.imageNames.count];
        for (int i = 0; i < self.imageNames.count; i++)
        {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = [UIImage imageNamed:[self.imageNames objectAtIndex:i]];
            imageView.clipsToBounds = YES;
            
            [array addObject:imageView];
            
            if (i == self.imageNames.count - 1) {
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesLastImage)];
                [imageView addGestureRecognizer:tap];
            }
        }
        _imageViews = array;
    }
    return _imageViews;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.pageControl.currentPage = page;
    
    if ((self.scrollView.contentOffset.x > ((self.imageNames.count - 1) * self.frame.size.width + 50))) {
        [self touchesLastImage];
    }
}

#pragma mrak - DataSource

- (void)touchesLastImage
{
    dispatch_once(&onceToken, ^{
        [UIView animateWithDuration:1.0f animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
    });
}

- (void)dealloc
{
    NSLog(@"SGGuideView release");
}

@end
