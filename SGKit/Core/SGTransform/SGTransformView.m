//
//  SGTransformView.m
//  SGKit
//
//  Created by Single on 19/12/2016.
//  Copyright © 2016 single. All rights reserved.
//

#import "SGTransformView.h"

CGFloat const TranslateControlViewWidth = 40;
CGFloat const TranslateControlViewHeight = TranslateControlViewWidth;

@interface SGTransformView ()

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIView * translateControlView;

@property (nonatomic, assign) CGPoint translateStartPoint;
@property (nonatomic, assign) CGPoint translateStartCenter;

@property (nonatomic, assign) CGPoint moveStartPoint;
@property (nonatomic, assign) CGAffineTransform moveStartTransform;

@end

@implementation SGTransformView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    if (width > 0 && height > 0) {
        self.aspect = width / height;
    } else {
        self.aspect = TranslateControlViewWidth / TranslateControlViewHeight;
    }
    self.minSize = CGSizeMake(TranslateControlViewWidth, TranslateControlViewWidth);
    self.translateControlEnable = YES;
    
    [self superUILayout];
    [self setupGestureRecongizer];
}

- (void)superUILayout
{
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.contentView];
    
    self.translateControlView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - TranslateControlViewWidth, CGRectGetHeight(self.frame) - TranslateControlViewHeight, TranslateControlViewWidth, TranslateControlViewHeight)];
    self.translateControlView.backgroundColor = [UIColor cyanColor];
    [self addSubview:self.translateControlView];
}

- (void)setupGestureRecongizer
{
    UIPanGestureRecognizer * moveGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGestureRecognizerAction:)];
    [self addGestureRecognizer:moveGestureRecognizer];
    
    UIPanGestureRecognizer * translateGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(translateGestureRecognizerAction:)];
    [self.translateControlView addGestureRecognizer:translateGestureRecognizer];
}

- (void)settranslateControlEnable:(BOOL)translateControlEnable
{
    if (_translateControlEnable != translateControlEnable) {
        _translateControlEnable = translateControlEnable;
        self.translateControlView.hidden = !_translateControlEnable;
    }
}

- (void)translateGestureRecognizerAction:(UIPanGestureRecognizer *)pan
{
    switch (pan.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.translateStartCenter = self.center;
            self.translateStartPoint = [pan locationInView:self.translateControlView];
            [self startTranslateAction];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint location = [pan locationInView:self.superview];
            
            CGPoint point = CGPointMake(
                                        CGRectGetWidth(self.translateControlView.frame) - self.translateStartPoint.x + location.x,
                                        CGRectGetHeight(self.translateControlView.frame) - self.translateStartPoint.y + location.y
                                        );
            
            CGPoint center = self.translateStartCenter;
            
            CGFloat a = point.x - center.x;
            CGFloat b = point.y - center.y;
            CGFloat c = sqrtf(a*a + b*b);
            
            CGFloat height = sqrtf(c*c / (1+self.aspect*self.aspect));
            CGFloat width = height * self.aspect;
            
            if (height > self.minSize.height/2 && width > self.minSize.width/2)
            {
                CGRect frame = CGRectMake(center.x - width, center.y - height, width * 2, height * 2);
                
                if ([self.delegate respondsToSelector:@selector(transformView:needChangeFrameByTranslateAction:currentTransform:)]) {
                    frame = [self.delegate transformView:self needChangeFrameByTranslateAction:frame currentTransform:self.transform];
                }
                
                self.frame = frame;
            }
            
            float ang = atan2(point.y - center.y, point.x - center.x);
            self.transform = CGAffineTransformMakeRotation(ang - self.atan2);
            
            [self translatingAction];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [self stopTranslateAction];
        }
            break;
        default:
            break;
    }
}

- (void)startTranslateAction
{
    if ([self.delegate respondsToSelector:@selector(transformViewStartTranslate:)]) {
        [self.delegate transformViewStartTranslate:self];
    }
}

- (void)stopTranslateAction
{
    if ([self.delegate respondsToSelector:@selector(transformViewStopTranslate:)]) {
        [self.delegate transformViewStopTranslate:self];
    }
}

- (void)translatingAction
{
    if ([self.delegate respondsToSelector:@selector(transformViewTranslating:)]) {
        [self.delegate transformViewTranslating:self];
    }
}

- (void)moveGestureRecognizerAction:(UIPanGestureRecognizer *)pan
{
    switch (pan.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.moveStartPoint = [pan locationInView:self.superview];
            self.moveStartTransform = self.transform;
            [self startMoveAction];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [pan locationInView:self.superview];
            
            CGPoint newCenter = CGPointMake(self.center.x + point.x - self.moveStartPoint.x, self.center.y + point.y - self.moveStartPoint.y);
            
            if ([self.delegate respondsToSelector:@selector(transformView:needChangeCenterByMoveAction:)])
            {
                newCenter = [self.delegate transformView:self needChangeCenterByMoveAction:newCenter];
            }
            
            self.transform = CGAffineTransformMakeRotation(0);
            self.center = newCenter;
            self.transform = self.moveStartTransform;
            
            self.moveStartPoint = point;
            
            [self movingAction];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [self stopMoveAction];
        }
            break;
        default:
            break;
    }
}

- (void)startMoveAction
{
    if ([self.delegate respondsToSelector:@selector(transformViewStartMove:)]) {
        [self.delegate transformViewStartMove:self];
    }
}

- (void)stopMoveAction
{
    if ([self.delegate respondsToSelector:@selector(transformViewStopMove:)]) {
        [self.delegate transformViewStopMove:self];
    }
}

- (void)movingAction
{
    if ([self.delegate respondsToSelector:@selector(transformViewMoving:)]) {
        [self.delegate transformViewMoving:self];
    }
}

- (CGFloat)atan2
{
    return atan2f(CGRectGetHeight(self.frame), CGRectGetWidth(self.frame));
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.moveStartTransform = self.transform;
    self.transform = CGAffineTransformMakeRotation(0);
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    self.contentView.frame = self.bounds;
    self.translateControlView.frame = CGRectMake(width - TranslateControlViewWidth, height - TranslateControlViewHeight, TranslateControlViewWidth, TranslateControlViewHeight);
    
    self.aspect = width / height;
    
    self.transform = self.moveStartTransform;
}

- (void)setFrame:(CGRect)frame
{
    CGAffineTransform transform = self.transform;
    self.transform = CGAffineTransformMakeRotation(0);
    [super setFrame:frame];
    self.transform = transform;
}

@end
