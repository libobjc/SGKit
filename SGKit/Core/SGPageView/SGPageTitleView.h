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
@property (nonatomic, assign) CGFloat bottomLineHeight;     // default is 2
@property (nonatomic, copy) UIColor * bottomLineColor;      // default is red;
@property (nonatomic, assign) CGFloat bottomLineAnimatedDuration;       // default is 0.25s

@end
