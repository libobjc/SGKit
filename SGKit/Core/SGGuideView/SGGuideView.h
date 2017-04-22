//
//  GuideView.h
//  opera
//
//  Created by Single on 15/12/20.
//  Copyright © 2015年 single. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGGuideView;

@protocol SGGuideViewDelegate <NSObject>

- (void)guideViewWillDisapper:(SGGuideView *)guideView;
- (void)guideViewDidDisapper:(SGGuideView *)guideView;

@end

@interface SGGuideView : UIView

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

+ (instancetype)guideViewWithImageNames:(NSArray <NSString *> *)imageNames;

@property (nonatomic, weak) id <SGGuideViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIImageView * backgroundImageView;
@property (nonatomic, assign) UIViewContentMode imageViewsContentMode;          // default is UIViewContentModeScaleAspectFill.
@property (nonatomic, assign) BOOL pageControlHidden;                           // default is NO.

@end
