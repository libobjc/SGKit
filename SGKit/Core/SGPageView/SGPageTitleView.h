//
//  SGPageTitleView.h
//  SGKit
//
//  Created by Single on 2016/11/17.
//  Copyright © 2016年 single. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGPageView;

@interface SGPageTitleView : UIView

@property (nonatomic, weak, readonly) SGPageView * pageView;

@property (nonatomic, assign) CGFloat leftMargin;   // default is 0
@property (nonatomic, assign) CGFloat rightMargin;  // default is 0

@property (nonatomic, assign) BOOL showBottomLine;  // default is NO
@property (nonatomic, assign) CGFloat bottomLineHeight;     // default is 3
@property (nonatomic, copy) UIColor * bottomLineColor;      // default is red;
@property (nonatomic, assign) CGFloat bottomLineAnimatedDuration;       // default is 0.25s

@property (nonatomic, assign) BOOL showBottomBoard;     // default is NO
@property (nonatomic, assign) CGFloat bottomBoardHeight;        // default is 1
@property (nonatomic, copy) UIColor * bottomBoardColor;     // default is red;

@end
