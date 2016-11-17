//
//  SGImagePlayer.m
//  imv_ios_v3
//
//  Created by Single on 16/1/18.
//  Copyright © 2016年 YYT. All rights reserved.
//

#import "SGImagePlayer.h"

/** ImageViewTag */
#define kImageViewBaseTag 190027000   // 作者QQ/微信号

/** 自动滚动间隔 */
#define kAnimationDuration 2

/** ---------- Page尺寸 ---------- */
#define kPageWidth self.bounds.size.width
#define kPageHeight self.bounds.size.height

#define kPageControlHeight 25
#define kPageControlHorizontalMargin 10
#define kPageControlVerticalMargin 3

#define kPageControlNumberFontSize 10

@interface SGImagePlayer () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

{
    /** Image总数 */
    NSInteger _pageCount;
    
    /** 当前Image索引 */
    NSInteger _currentPage;
    
    /** 是否需要刷新数据 */
    BOOL _needReload;
}

/** 自动滚动定时器 */
@property (nonatomic, weak) NSTimer * timer;

/** 循环ScrollView */
@property (nonatomic, strong) UIScrollView * scrollView;

/** PageControl */
// System
@property (nonatomic, strong) UIPageControl * pageSystem;
// Number
@property (nonatomic, strong) UILabel * pageNumber;
// 背景阴影
@property (nonatomic, strong) UIImageView * bannerImageView;

@end

@implementation SGImagePlayer

- (void)setPageControlStyle:(SGPageControlStyle)style position:(SGPageControlPosition)position
{
    _pageControlStyle = style;
    _pageControlPosition = position;
    [self setupPageControl];
}

- (void)setPageControlMarginHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical
{
    _pageControlHorizontalMargin = horizontal;
    _pageControlVerticalMargin = vertical;
    [self refreshPageControlPosition];
}

- (void)reloadData
{
    if (self.scrolling) {
        _needReload = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _needReload = NO;
            [self setupLayout];
            [self setupTimer];
            [self setupPageControl];
            
            if ([self.delegate respondsToSelector:@selector(imagePlayerDidFinishLoad:currentIndex:)]) {
                [self.delegate imagePlayerDidFinishLoad:self currentIndex:_currentPage];
            }
        });
    } else {
        [self setupLayout];
        [self setupTimer];
        [self setupPageControl];
        
        if ([self.delegate respondsToSelector:@selector(imagePlayerDidFinishLoad:currentIndex:)]) {
            [self.delegate imagePlayerDidFinishLoad:self currentIndex:_currentPage];
        }
    }
}

- (void)setupLayout
{
    [self clearScrollView];
    [self configPageInfo];
    [self configScrollView];
    [self refresh];
}

- (void)setupTimer
{
    [self releaseTimer];
    [self configTimer];
}

- (void)setupPageControl
{
    [self clearPageControl];
    [self configPageControl];
}

#pragma mark
#pragma mark - 布局

/**
 *  清除ScrollView子视图
 */
- (void)clearScrollView
{
    [self.scrllView.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * stop) {
        
        if ([obj isKindOfClass:[UIImageView class]]) {
            [obj.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subObj, NSUInteger subIdx, BOOL * _Nonnull subStop) {
                [subObj removeFromSuperview];
            }];
        }
        [obj removeFromSuperview];
    }];
}

/**
 *  配置PageInfo
 */
- (void)configPageInfo
{
    _pageCount = [self.delegate numberOfImagesInImagePlayer:self];
    _currentPage = 0;
}

/**
 *  配置ScrollView
 */
- (void)configScrollView
{
    if (_pageCount == 0) return;
    
    self.scrllView.contentSize = CGSizeMake(kPageWidth * (_pageCount == 1 ? 1 : 3), kPageHeight);
    self.scrllView.contentOffset = CGPointMake(kPageWidth * (_pageCount != 1), 0);
    
    for (NSInteger i = 0; i < (_pageCount==1 ? 1 : 3); i++)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPageWidth * i, 0, kPageWidth, kPageHeight)];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.userInteractionEnabled = YES;
        imageView.tag = kImageViewBaseTag + i;
        [self.scrllView addSubview:imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewLongPress:)];
        
        tap.delegate = self;
        longPress.delegate = self;
        [imageView addGestureRecognizer:tap];
        [imageView addGestureRecognizer:longPress];
    }
}

#pragma mark
#pragma mark - 手势

- (void)imageViewTap:(UITapGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateEnded:
        {
            if ([self.delegate respondsToSelector:@selector(imagePlayer:didTapAtIndex:)])
            {
                [self.delegate imagePlayer:self didTapAtIndex:_currentPage];
            }
            [self resumTimer];
        }
            break;
        default:
        {
            [self resumTimer];
        }
            break;
    }
}

- (void)imageViewLongPress:(UILongPressGestureRecognizer *)recognizer
{
    
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            if ([self.delegate respondsToSelector:@selector(imagePlayer:didLongPressAtIndex:)])
            {
                [self.delegate imagePlayer:self didLongPressAtIndex:_currentPage];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
            break;
        default:
        {
            [self resumTimer];
        }
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self pauseTimer];
    return YES;
}

#pragma mark
#pragma mark - Timer

/**
 *  配置定时器
 */
- (void)configTimer
{
    if (self.autoScroll)
    {
        if (self.timer)
        {
            [self releaseTimer];
        }
        if (_pageCount > 1)
        {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
            self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.animationDuration];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
}

/**
 *  定时器Action
 */
- (void)handleTimer
{
    [self.scrllView setContentOffset:CGPointMake(self.scrllView.contentSize.width - kPageWidth, 0) animated:YES];
}

- (void)pause
{
    [self pauseTimer];
}

- (void)pauseTimer
{
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)resume
{
    [self resumTimer];
}

- (void)resumTimer
{
    if (_needReload) return;
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.animationDuration];
}

- (void)releaseTimer
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark
#pragma mark - PageControl

- (void)clearPageControl
{
    if (self.pageSystem)
    {
        [self.pageSystem removeFromSuperview];
    }
    if (self.pageNumber)
    {
        [self.pageNumber removeFromSuperview];
    }
}

- (void)configPageControl
{
    switch (self.pageControlStyle)
    {
        case SGPageControlStyleNone:
            break;
        case SGPageControlStyleSystem:
        {
            self.pageSystem = [[UIPageControl alloc] init];
            [self refreshPageControlPosition];
            self.pageSystem.hidesForSinglePage = YES;
            self.pageSystem.numberOfPages = _pageCount;
            self.pageSystem.currentPage = _currentPage;
            [self addSubview:self.pageSystem];
            if ([self.delegate respondsToSelector:@selector(ImagePlayer:editPageControlSystem:)])
            {
                [self.delegate ImagePlayer:self editPageControlSystem:self.pageSystem];
            }
        }
            break;
        case SGPageControlStyleNumber:
        {
            self.pageNumber = [[UILabel alloc] init];
            [self refreshPageControlPosition];
            self.pageNumber.font = [UIFont systemFontOfSize:kPageControlNumberFontSize];
            self.pageNumber.textColor = [UIColor whiteColor];
            [self refreshPageNumber];
            [self addSubview:self.pageNumber];
            if ([self.delegate respondsToSelector:@selector(imagePlayer:editPageControlNumber:)])
            {
                [self.delegate imagePlayer:self editPageControlNumber:self.pageNumber];
            }
        }
            break;
    }
}



#pragma mark
#pragma mark - 滚动刷新数据

/**
 *  刷新所有数据
 */
- (void)refresh
{
    if (_needReload) return;
    [self refreshImageView];
    [self refreshLocation];
    [self refreshPageControl];
}

/**
 *  刷新imageView数据
 */
- (void)refreshImageView
{
    for (NSInteger i = 0; i < (_pageCount>1 ? 3 : _pageCount); i++)
    {
        [self.delegate imagePlayer:self imageView:[self.scrllView viewWithTag:kImageViewBaseTag+i] atIndex:[self indexTransform:i]];
    }
}

/**
 *  刷新scrollView位置
 */
- (void)refreshLocation
{
    // 防止调用didscroll
//    [self.scrllView setContentOffset:CGPointMake(kPageWidth * (_pageCount != 1), 0) animated:_scrolling];
    self.scrllView.contentOffset = CGPointMake(kPageWidth * (_pageCount != 1), 0);
}

/**
 *  刷新PageControl
 */
- (void)refreshPageControl
{
    switch (self.pageControlStyle)
    {
        case SGPageControlStyleNone:
            return;
        case SGPageControlStyleSystem:
        {
            self.pageSystem.currentPage = _currentPage;
        }
            break;
        case SGPageControlStyleNumber:
        {
            [self refreshPageNumber];
        }
            break;
    }
}

- (void)refreshPageNumber
{
    self.pageNumber.hidden = _pageCount <= 1;
    self.pageNumber.text = [NSString stringWithFormat:@"%ld/%ld", _currentPage + 1, _pageCount];
}

/**
 *  刷新PageControl位置
 */
- (void)refreshPageControlPosition
{
    CGFloat x, y, w, h = kPageControlHeight;
    if (self.pageControlStyle == SGPageControlStyleSystem)
    {
        switch (self.pageControlPosition) {
            case SGPageControlPositionTopLeft:
                x = self.pageControlHorizontalMargin;
                y = self.pageControlVerticalMargin;
                w = [self.pageSystem sizeForNumberOfPages:_pageCount].width;
                break;
            case SGPageControlPositionTopCenter:
                x = 0;
                y = self.pageControlVerticalMargin;
                w = kPageWidth;
                break;
            case SGPageControlPositionTopRight:
                y = self.pageControlVerticalMargin;
                w = [self.pageSystem sizeForNumberOfPages:_pageCount].width;
                x = (kPageWidth - w - self.pageControlHorizontalMargin);
                break;
            case SGPageControlPositionBottomLeft:
                x = self.pageControlHorizontalMargin;
                y = (kPageHeight - kPageControlHeight - self.pageControlVerticalMargin);
                w = [self.pageSystem sizeForNumberOfPages:_pageCount].width;
                break;
            case SGPageControlPositionBottomCenter:
                x = 0;
                y = (kPageHeight - kPageControlHeight - self.pageControlVerticalMargin);
                w = kPageWidth;
                break;
            case SGPageControlPositionBottomRight:
                y = (kPageHeight - kPageControlHeight - self.pageControlVerticalMargin);
                w = [self.pageSystem sizeForNumberOfPages:_pageCount].width;
                x = (kPageWidth - w - self.pageControlHorizontalMargin);
                break;
        }
        self.pageSystem.frame = CGRectMake(x, y, w, h);
    }
    else if (self.pageControlStyle == SGPageControlStyleNumber)
    {
        x = self.pageControlHorizontalMargin; w = kPageWidth - 2*self.pageControlHorizontalMargin;
        switch (self.pageControlPosition) {
            case SGPageControlPositionTopLeft:
                y = self.pageControlVerticalMargin;
                self.pageNumber.textAlignment = NSTextAlignmentLeft;
                break;
            case SGPageControlPositionTopCenter:
                y = self.pageControlVerticalMargin;
                self.pageNumber.textAlignment = NSTextAlignmentCenter;
                break;
            case SGPageControlPositionTopRight:
                y = self.pageControlVerticalMargin;
                self.pageNumber.textAlignment = NSTextAlignmentRight;
                break;
            case SGPageControlPositionBottomLeft:
                y = (kPageHeight - kPageControlHeight - self.pageControlVerticalMargin);
                self.pageNumber.textAlignment = NSTextAlignmentLeft;
                break;
            case SGPageControlPositionBottomCenter:
                y = (kPageHeight - kPageControlHeight - self.pageControlVerticalMargin);
                self.pageNumber.textAlignment = NSTextAlignmentCenter;
                break;
            case SGPageControlPositionBottomRight:
                y = (kPageHeight - kPageControlHeight - self.pageControlVerticalMargin);
                self.pageNumber.textAlignment = NSTextAlignmentRight;
                break;
        }
        self.pageNumber.frame = CGRectMake(x, y, w, h);;
    }
}

/**
 *  索引转换
 *
 *  @param imageViewIndex ImageView的index
 *
 *  @return 当前Page在DataSource的index
 */
- (NSInteger)indexTransform:(NSInteger)imageViewIndex
{
    switch (imageViewIndex)
    {
        case 0:
            return (_currentPage-1)<0 ? _pageCount-1 : _currentPage-1;
        case 1:
            return _currentPage;
        default:
            return (_currentPage+1)>(_pageCount-1) ? 0 : _currentPage+1;
    }
}

#pragma mark
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_scrolling && [self.delegate respondsToSelector:@selector(imagePlayer:didBeginScroll:)])
    {
        [self.delegate imagePlayer:self didBeginScroll:_currentPage];
    }
    
    _scrolling = YES;
    
    // 刷新条件判断
    if (self.scrllView.contentOffset.x == 0)
    {
        _currentPage = (_currentPage-1)<0 ? _pageCount-1 : _currentPage-1;
        _scrolling = NO;
        [self refresh];
    }
    else if (self.scrllView.contentOffset.x == kPageWidth * 2)
    {
        _currentPage = (_currentPage+1)>(_pageCount-1) ? 0 : _currentPage+1;
        _scrolling = NO;
        [self refresh];
    }
    [self pauseTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _scrolling = NO;
    [self didEndScroll];
    [self resumTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _scrolling = NO;
    [self didEndScroll];
    [self resumTimer];
}

- (void)didEndScroll
{
    if (_needReload) return;
    if ([self.delegate respondsToSelector:@selector(imagePlayer:didEndScroll:)])
    {
        [self.delegate imagePlayer:self didEndScroll:_currentPage];
    }
}

#pragma mark
#pragma mark - Setter/Getter

- (void)setDelegate:(id<SGImagePlayerDelegate>)delegate
{
    if (_delegate != delegate)
    {
        _delegate = delegate;
        [self reloadData];
    }
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    if (_autoScroll != autoScroll)
    {
        _autoScroll = autoScroll;
        
        if (!autoScroll)
        {
            [self releaseTimer];
        }
        else
        {
            [self setupTimer];
        }
    }
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    if (_animationDuration != animationDuration)
    {
        _animationDuration = animationDuration;
        
        if (animationDuration == 0)
        {
            self.autoScroll = NO;
        }
        else
        {
            [self setupTimer];
        }
    }
}

- (void)setPageControlType:(SGPageControlStyle)pageControlType
{
    if (_pageControlStyle != pageControlType)
    {
        _pageControlStyle = pageControlType;
        
        [self setupPageControl];
    }
}

- (void)setPageControlPosition:(SGPageControlPosition)pageControlPosition
{
    if (_pageControlPosition != pageControlPosition)
    {
        _pageControlPosition = pageControlPosition;
        
        [self refreshPageControlPosition];
    }
}

- (void)setPageControlHorizontalMargin:(CGFloat)pageControlHorizontalMargin
{
    if (_pageControlHorizontalMargin != pageControlHorizontalMargin)
    {
        _pageControlHorizontalMargin = pageControlHorizontalMargin;
        
        [self refreshPageControlPosition];
    }
}

- (void)setPageControlVerticalMargin:(CGFloat)pageControlVerticalMargin
{
    if (_pageControlVerticalMargin != pageControlVerticalMargin)
    {
        _pageControlVerticalMargin = pageControlVerticalMargin;
        
        [self refreshPageControlPosition];
    }
}

- (UIScrollView *)scrllView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.clipsToBounds = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (void)_init
{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.scrllView];
    [self addSubview:self.bannerImageView];
    
    self.autoScroll = YES;
    self.animationDuration = kAnimationDuration;
    self.pageControlStyle = SGPageControlStyleSystem;
    self.pageControlPosition = SGPageControlPositionBottomCenter;
    self.pageControlHorizontalMargin = kPageControlHorizontalMargin;
    self.pageControlVerticalMargin = kPageControlVerticalMargin;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self _init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self _init];
    }
    return self;
}

- (void)removeFromSuperview
{
    if (self.timer)
    {
        [self releaseTimer];
    }
    [super removeFromSuperview];
}

@end
