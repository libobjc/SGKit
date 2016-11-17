//
//  SGPageView.h
//  opera
//
//  Created by Single on 16/6/11.
//  Copyright © 2016年 HL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGPageView;

@protocol SGPageViewDelegate <NSObject>

- (NSInteger)numberOfPagesInPageView:(SGPageView *)pageView;
- (UIView *)pageView:(SGPageView *)pageView viewAtIndex:(NSInteger)index;
- (void)pageView:(SGPageView *)pageView didScrollToIndex:(NSInteger)index;

@end

@interface SGPageView : UIView

@property (nonatomic, weak) id <SGPageViewDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger index;
@property (nonatomic, assign) NSInteger defaultIndex;   // default is 0

- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

@end
