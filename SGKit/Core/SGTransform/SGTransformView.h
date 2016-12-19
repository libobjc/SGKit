//
//  SGTransformView.h
//  SGKit
//
//  Created by Single on 19/12/2016.
//  Copyright © 2016 single. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGTransformView;

extern CGFloat const TranslateControlViewWidth;
extern CGFloat const TranslateControlViewHeight;

@protocol SGTransformViewDelegate <NSObject>

@optional
- (void)transformViewStartTranslate:(SGTransformView *)transformView;
- (void)transformViewStopTranslate:(SGTransformView *)transformView;
- (void)transformViewTranslating:(SGTransformView *)transformView;
- (CGRect)transformView:(SGTransformView *)transformView needChangeFrameByTranslateAction:(CGRect)frame currentTransform:(CGAffineTransform)transform;

- (void)transformViewStartMove:(SGTransformView *)transformView;
- (void)transformViewStopMove:(SGTransformView *)transformView;
- (void)transformViewMoving:(SGTransformView *)transformView;
- (CGPoint)transformView:(SGTransformView *)transformView needChangeCenterByMoveAction:(CGPoint)center;

@end

@interface SGTransformView : UIView

@property (nonatomic, weak) id <SGTransformViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIView * contentView;
@property (nonatomic, strong, readonly) UIView * translateControlView;
@property (nonatomic, assign) BOOL translateControlEnable;     // default is YES;
@property (nonatomic, assign) CGSize translateControlViewSize;  // defalut wdith is TranslateViewWidth, default height is TranslateViewHeight.

@property (nonatomic, assign) CGFloat aspect;       // if frame.size is't CGRectZero whern init, defalut value is width/height, else default value is equal to translateView's width/height.
@property (nonatomic, assign) CGSize minSize;       // default is equal to translateView's size.

@end
