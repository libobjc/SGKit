//
//  SGSwipeView.h
//  SGKit
//
//  Created by Single on 2016/11/18.
//  Copyright © 2016年 single. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGPageView.h"

@class SGSwipeView;

@protocol SGSwipeViewDelegate <NSObject>

- (SGPageView *)pageViewInSwipeView:(SGSwipeView *)swipeView;
- (UIView *)headerViewInSwipeView:(SGSwipeView *)swipeView;
- (CGFloat)headerViewHeightInSwipeView:(SGSwipeView *)swipeView;

@optional
- (CGFloat)pageTitleViewHeightInSwipeView:(SGSwipeView *)swipeView;
- (void)swipeView:(SGSwipeView *)swipeView didChangeOffsetScale:(CGFloat)scale;

@end

@interface SGSwipeView : UIView

@property (nonatomic, weak) id <SGSwipeViewDelegate> delegate;
@property (nonatomic, strong, readonly) SGPageView * pageView;
@property (nonatomic, strong, readonly) UIView * headerView;
@property (nonatomic, assign, readonly) CGFloat headerViewHeight;
@property (nonatomic, assign, readonly) CGFloat pageTitleViewHeight;
@property (nonatomic, assign) CGFloat topMargin;

- (void)reloadData;

@end
