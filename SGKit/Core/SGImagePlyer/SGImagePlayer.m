//
//  SGImagePlayer.m
//  imv_ios_v3
//
//  Created by Single on 16/1/18.
//  Copyright © 2016年 YYT. All rights reserved.
//

#import "SGImagePlayer.h"

static CGFloat const SGImagePlayerAnimationDuration = 2;
static CGFloat const SGImagePlayerPageControlHorizontalMargin = 10;
static CGFloat const SGImagePlayerPageControlVerticalMargin = 3;
static CGFloat const SGImagePlayerPageControlHeight = 25;

@interface SGImagePlayer () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) NSTimer * timer;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSArray <UIImageView *> * imageViews;

@property (nonatomic, strong) UIPageControl * pageSystem;
@property (nonatomic, strong) UILabel * pageNumber;

@property (nonatomic, assign) BOOL scrolling;
@property (nonatomic, assign) BOOL needReload;
@property (nonatomic, assign) NSInteger numberOfImage;
@property (nonatomic, assign) NSInteger currentImage;

@end

@implementation SGImagePlayer

- (void)pause
{
    [self pauseTimer];
}

- (void)resume
{
    [self resumTimer];
}

- (void)reloadData
{
    if (self.scrolling) {
        self.needReload = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.needReload = NO;
            [self doReloadData];
        });
    } else {
        [self doReloadData];
    }
}

- (void)doReloadData
{
    [self setupScrollView];
    [self setupTimer];
    [self setupPageControl];
    [self refresh];
    
    if ([self.delegate respondsToSelector:@selector(imagePlayerDidFinishLoad:currentIndex:)]) {
        [self.delegate imagePlayerDidFinishLoad:self currentIndex:self.currentImage];
    }
}

- (void)setupScrollView
{
    [self clearScrollView];
    
    self.numberOfImage = [self.delegate numberOfImagesInImagePlayer:self];
    self.currentImage = 0;
    
    if (self.numberOfImage == 0) return;
    
    self.scrllView.contentSize = CGSizeMake(self.frame.size.width * (self.numberOfImage == 1 ? 1 : 3), self.frame.size.height);
    self.scrllView.contentOffset = CGPointMake(self.frame.size.width * (self.numberOfImage != 1), 0);
    
    NSMutableArray * temp = [NSMutableArray arrayWithCapacity:self.numberOfImage];
    for (NSInteger i = 0; i < (self.numberOfImage==1 ? 1 : 3); i++)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.userInteractionEnabled = YES;
        [self.scrllView addSubview:imageView];
        [temp addObject:imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewLongPress:)];
        
        tap.delegate = self;
        longPress.delegate = self;
        [imageView addGestureRecognizer:tap];
        [imageView addGestureRecognizer:longPress];
    }
    self.imageViews = temp;
}

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
    self.imageViews = nil;
}

- (void)pauseTimer
{
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)resumTimer
{
    if (self.needReload) return;
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.animationDuration];
}

- (void)setupTimer
{
    [self clearTimer];
    
    if (self.autoScroll) {
        if (self.numberOfImage > 1) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
            self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.animationDuration];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)clearTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)handleTimer
{
    [self.scrllView setContentOffset:CGPointMake(self.scrllView.contentSize.width - self.frame.size.width, 0) animated:YES];
}

- (void)setupPageControl
{
    [self clearPageControl];
    
    switch (self.pageControlStyle)
    {
        case SGPageControlStyleNone:
            break;
        case SGPageControlStyleSystem:
        {
            self.pageSystem = [[UIPageControl alloc] init];
            [self refreshPageControlPosition];
            self.pageSystem.hidesForSinglePage = YES;
            self.pageSystem.numberOfPages = self.numberOfImage;
            self.pageSystem.currentPage = self.currentImage;
            [self addSubview:self.pageSystem];
            if ([self.delegate respondsToSelector:@selector(ImagePlayer:editPageControlSystem:)]) {
                [self.delegate ImagePlayer:self editPageControlSystem:self.pageSystem];
            }
        }
            break;
        case SGPageControlStyleNumber:
        {
            self.pageNumber = [[UILabel alloc] init];
            [self refreshPageControlPosition];
            self.pageNumber.font = [UIFont systemFontOfSize:10];
            self.pageNumber.textColor = [UIColor whiteColor];
            [self refreshPageNumber];
            [self addSubview:self.pageNumber];
            if ([self.delegate respondsToSelector:@selector(imagePlayer:editPageControlNumber:)]) {
                [self.delegate imagePlayer:self editPageControlNumber:self.pageNumber];
            }
        }
            break;
    }
}

- (void)clearPageControl
{
    if (self.pageSystem) {
        [self.pageSystem removeFromSuperview];
    }
    if (self.pageNumber) {
        [self.pageNumber removeFromSuperview];
    }
}

- (void)refresh
{
    if (self.needReload) return;
    [self refreshImageView];
    [self refreshLocation];
    [self refreshPageControl];
}

- (void)refreshImageView
{
    for (NSInteger i = 0; i < (self.numberOfImage>1 ? 3 : self.numberOfImage); i++) {
        [self.delegate imagePlayer:self imageView:[self.imageViews objectAtIndex:i] atIndex:[self indexTransform:i]];
    }
}

- (void)refreshLocation
{
    self.scrllView.contentOffset = CGPointMake(self.frame.size.width * (self.numberOfImage != 1), 0);
}

- (void)refreshPageControl
{
    switch (self.pageControlStyle)
    {
        case SGPageControlStyleNone:
            return;
        case SGPageControlStyleSystem:
        {
            self.pageSystem.currentPage = self.currentImage;
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
    self.pageNumber.hidden = self.numberOfImage <= 1;
    self.pageNumber.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.currentImage + 1, (long)self.numberOfImage];
}

- (void)refreshPageControlPosition
{
    CGFloat x, y, w, h = SGImagePlayerPageControlHeight;
    if (self.pageControlStyle == SGPageControlStyleSystem)
    {
        switch (self.pageControlPosition) {
            case SGPageControlPositionTopLeft:
                x = self.pageControlHorizontalMargin;
                y = self.pageControlVerticalMargin;
                w = [self.pageSystem sizeForNumberOfPages:self.numberOfImage].width;
                break;
            case SGPageControlPositionTopCenter:
                x = 0;
                y = self.pageControlVerticalMargin;
                w = self.frame.size.width;
                break;
            case SGPageControlPositionTopRight:
                y = self.pageControlVerticalMargin;
                w = [self.pageSystem sizeForNumberOfPages:self.numberOfImage].width;
                x = (self.frame.size.width - w - self.pageControlHorizontalMargin);
                break;
            case SGPageControlPositionBottomLeft:
                x = self.pageControlHorizontalMargin;
                y = (self.frame.size.height - SGImagePlayerPageControlHeight - self.pageControlVerticalMargin);
                w = [self.pageSystem sizeForNumberOfPages:self.numberOfImage].width;
                break;
            case SGPageControlPositionBottomCenter:
                x = 0;
                y = (self.frame.size.height - SGImagePlayerPageControlHeight - self.pageControlVerticalMargin);
                w = self.frame.size.width;
                break;
            case SGPageControlPositionBottomRight:
                y = (self.frame.size.height - SGImagePlayerPageControlHeight - self.pageControlVerticalMargin);
                w = [self.pageSystem sizeForNumberOfPages:self.numberOfImage].width;
                x = (self.frame.size.width - w - self.pageControlHorizontalMargin);
                break;
        }
        self.pageSystem.frame = CGRectMake(x, y, w, h);
    }
    else if (self.pageControlStyle == SGPageControlStyleNumber)
    {
        x = self.pageControlHorizontalMargin; w = self.frame.size.width - 2*self.pageControlHorizontalMargin;
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
                y = (self.frame.size.height - SGImagePlayerPageControlHeight - self.pageControlVerticalMargin);
                self.pageNumber.textAlignment = NSTextAlignmentLeft;
                break;
            case SGPageControlPositionBottomCenter:
                y = (self.frame.size.height - SGImagePlayerPageControlHeight - self.pageControlVerticalMargin);
                self.pageNumber.textAlignment = NSTextAlignmentCenter;
                break;
            case SGPageControlPositionBottomRight:
                y = (self.frame.size.height - SGImagePlayerPageControlHeight - self.pageControlVerticalMargin);
                self.pageNumber.textAlignment = NSTextAlignmentRight;
                break;
        }
        self.pageNumber.frame = CGRectMake(x, y, w, h);;
    }
}

- (void)refreshLayout
{
    self.scrollView.frame = self.bounds;
    self.scrllView.contentSize = CGSizeMake(self.frame.size.width * (self.numberOfImage == 1 ? 1 : 3), self.frame.size.height);
    self.scrllView.contentOffset = CGPointMake(self.frame.size.width * (self.numberOfImage != 1), 0);
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(self.frame.size.width * idx, 0, self.frame.size.width, self.frame.size.height);
    }];
    [self refreshPageControlPosition];
    [self resumTimer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self refreshLayout];
}

- (NSInteger)indexTransform:(NSInteger)imageViewIndex
{
    switch (imageViewIndex)
    {
        case 0:
            return (self.currentImage-1)<0 ? self.numberOfImage-1 : self.currentImage-1;
        case 1:
            return self.currentImage;
        default:
            return (self.currentImage+1)>(self.numberOfImage-1) ? 0 : self.currentImage+1;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.scrolling && [self.delegate respondsToSelector:@selector(imagePlayer:didBeginScroll:)]) {
        [self.delegate imagePlayer:self didBeginScroll:self.currentImage];
    }
    
    self.scrolling = YES;
    
    if (self.scrllView.contentOffset.x == 0)
    {
        self.currentImage = (self.currentImage-1)<0 ? self.numberOfImage-1 : self.currentImage-1;
        self.scrolling = NO;
        [self refresh];
    }
    else if (self.scrllView.contentOffset.x == self.frame.size.width * 2)
    {
        self.currentImage = (self.currentImage+1)>(self.numberOfImage-1) ? 0 : self.currentImage+1;
        self.scrolling = NO;
        [self refresh];
    }
    [self pauseTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.scrolling = NO;
    [self didEndScroll];
    [self resumTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.scrolling = NO;
    [self didEndScroll];
    [self resumTimer];
}

- (void)didEndScroll
{
    if (self.needReload) return;
    if ([self.delegate respondsToSelector:@selector(imagePlayer:didEndScroll:)]) {
        [self.delegate imagePlayer:self didEndScroll:self.currentImage];
    }
}

- (void)imageViewTap:(UITapGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateEnded:
        {
            if ([self.delegate respondsToSelector:@selector(imagePlayer:didTapAtIndex:)]) {
                [self.delegate imagePlayer:self didTapAtIndex:self.currentImage];
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
            if ([self.delegate respondsToSelector:@selector(imagePlayer:didLongPressAtIndex:)]) {
                [self.delegate imagePlayer:self didLongPressAtIndex:self.currentImage];
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
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrllView];
    
    self.autoScroll = YES;
    self.autoPauseAndResumeWhenMoveToWindow = YES;
    self.animationDuration = SGImagePlayerAnimationDuration;
    self.pageControlStyle = SGPageControlStyleSystem;
    self.pageControlPosition = SGPageControlPositionBottomCenter;
    self.pageControlHorizontalMargin = SGImagePlayerPageControlHorizontalMargin;
    self.pageControlVerticalMargin = SGImagePlayerPageControlVerticalMargin;
}

- (UIScrollView *)scrllView
{
    if (!_scrollView) {
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

- (void)setDelegate:(id<SGImagePlayerDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        [self reloadData];
    }
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    if (_autoScroll != autoScroll) {
        _autoScroll = autoScroll;
        if (autoScroll) {
            [self setupTimer];
        } else {
            [self clearTimer];
        }
    }
}

- (void)setPageControlStyle:(SGPageControlStyle)pageControlStyle
{
    if (_pageControlStyle != pageControlStyle) {
        _pageControlStyle = pageControlStyle;
        [self setupPageControl];
    }
}

- (void)setPageControlPosition:(SGPageControlPosition)pageControlPosition
{
    if (_pageControlPosition != pageControlPosition) {
        _pageControlPosition = pageControlPosition;
        [self refreshPageControlPosition];
    }
}

- (void)setPageControlHorizontalMargin:(CGFloat)pageControlHorizontalMargin
{
    if (_pageControlHorizontalMargin != pageControlHorizontalMargin) {
        _pageControlHorizontalMargin = pageControlHorizontalMargin;
        [self refreshPageControlPosition];
    }
}

- (void)setPageControlVerticalMargin:(CGFloat)pageControlVerticalMargin
{
    if (_pageControlVerticalMargin != pageControlVerticalMargin) {
        _pageControlVerticalMargin = pageControlVerticalMargin;
        [self refreshPageControlPosition];
    }
}

- (void)removeFromSuperview
{
    if (self.timer) {
        [self clearTimer];
    }
    [super removeFromSuperview];
}

- (void)didMoveToWindow
{
    if (self.autoPauseAndResumeWhenMoveToWindow) {
        if (self.window) {
            [self resume];
        } else {
            [self pause];
        }
    }
}

@end
