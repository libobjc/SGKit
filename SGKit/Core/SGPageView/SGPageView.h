//
//  SGPageView.h
//  opera
//
//  Created by Single on 16/6/11.
//  Copyright © 2016年 HL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGPageTitleView.h"
#import "SGPageTitleItem.h"

@class SGPageView;

@protocol SGPageViewDelegate <NSObject>

- (NSInteger)numberOfPagesInPageView:(SGPageView *)pageView;
- (UIView *)pageView:(SGPageView *)pageView viewAtIndex:(NSInteger)index;
- (void)pageView:(SGPageView *)pageView didScrollToIndex:(NSInteger)index;

@optional
- (SGPageTitleView *)pageTitleViewInPageView:(SGPageView *)pageView;
- (SGPageTitleItem *)pageView:(SGPageView *)pageView pageTitleView:(SGPageTitleView *)pageTitleView titleItemAtIndex:(NSInteger)index;

@end

@protocol SGPageItemDelegate <NSObject>
@optional
- (UIScrollView *)scrollViewInPageItem:(UIView *)pageItem;
@end

@interface SGPageView : UIView

@property (nonatomic, weak) id <SGPageViewDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger index;
@property (nonatomic, assign) NSInteger defaultIndex;   // default is 0
@property (nonatomic, assign, readonly) NSInteger numberOfPage;
@property (nonatomic, strong, readonly) SGPageTitleView * pageTitleView;
@property (nonatomic, strong, readonly) NSArray <UIView <SGPageItemDelegate> *> * pages;

- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

@end
