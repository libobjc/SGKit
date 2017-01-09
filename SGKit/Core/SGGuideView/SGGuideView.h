//
//  GuideView.h
//  opera
//
//  Created by Single on 15/12/20.
//  Copyright © 2015年 single. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGGuideView : UIView

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

+ (instancetype)guideViewWithImageNames:(NSArray <NSString *> *)imageNames;

@property (nonatomic, strong, readonly) UIImageView * backgroundImageView;
@property (nonatomic, assign) BOOL pageControlHidden;

@end
