//
//  SGImagePlayer.h
//  imv_ios_v3
//
//  Created by Single on 16/1/18.
//  Copyright © 2016年 YYT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGImagePlayer;

// pageControl style
typedef NS_ENUM(NSUInteger, SGPageControlStyle) {
    SGPageControlStyleNone,
    SGPageControlStyleSystem,   // default
    SGPageControlStyleNumber,
};

// pageControl position
typedef NS_ENUM(NSUInteger, SGPageControlPosition) {
    SGPageControlPositionTopLeft,
    SGPageControlPositionTopCenter,
    SGPageControlPositionTopRight,
    SGPageControlPositionBottomLeft,
    SGPageControlPositionBottomCenter,  // default
    SGPageControlPositionBottomRight,
};

@protocol SGImagePlayerDelegate <NSObject>

- (NSInteger)numberOfImagesInImagePlayer:(SGImagePlayer *)imagePlayer;
- (void)imagePlayerDidFinishLoad:(SGImagePlayer *)imagePlayer currentIndex:(NSInteger)index;
- (void)imagePlayer:(SGImagePlayer *)imagePlayer imageView:(UIImageView *)imageView atIndex:(NSInteger)index;

@optional
- (void)imagePlayer:(SGImagePlayer *)imagePlayer didBeginScroll:(NSInteger)index;
- (void)imagePlayer:(SGImagePlayer *)imagePlayer didEndScroll:(NSInteger)index;
- (void)imagePlayer:(SGImagePlayer *)imagePlayer didTapAtIndex:(NSInteger)index;
- (void)imagePlayer:(SGImagePlayer *)imagePlayer didLongPressAtIndex:(NSInteger)index;

// pageControl style
- (void)ImagePlayer:(SGImagePlayer *)imagePlayer editPageControlSystem:(UIPageControl *)pageControlSystem;
- (void)imagePlayer:(SGImagePlayer *)imagePlayer editPageControlNumber:(UILabel *)pageControlNumber;

@end

@interface SGImagePlayer : UIView

@property (nonatomic, weak) id <SGImagePlayerDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL scrolling;
@property (nonatomic, assign) BOOL autoScroll; // defautl is YES
@property (nonatomic, assign) BOOL autoPauseAndResumeWhenMoveToWindow;   // default is YES
@property (nonatomic, assign) NSTimeInterval animationDuration; // default is 2s

- (void)resume;
- (void)pause;
- (void)reloadData;

- (void)clearTimer;   // auto execute when removeFromSuperView

// pageControl
@property (nonatomic, assign) SGPageControlStyle pageControlStyle; // default is SGPageControlStyleSystem
@property (nonatomic, assign) SGPageControlPosition pageControlPosition; // default is SGPageControlPositionBottomCenter
@property (nonatomic, assign) CGFloat pageControlHorizontalMargin; // default is 10
@property (nonatomic, assign) CGFloat pageControlVerticalMargin; // default is 3

@end


