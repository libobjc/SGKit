//
//  SGPageTitleItem.h
//  SGKit
//
//  Created by Single on 2016/11/17.
//  Copyright © 2016年 single. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGPageTitleItem : UIView

@property (nonatomic, assign, readonly) BOOL selected;
@property (nonatomic, assign) CGFloat itemWidth;     // default is 80;
@property (nonatomic, assign) CGFloat bottomLineWidth;      // default is 80;

// subclass override
- (void)normalStyle;
- (void)selectedStyle;

@end

@interface SGPageTitleLabelItem : SGPageTitleItem

@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) UIFont * normalFont;        // default is system font 14
@property (nonatomic, copy) UIFont * selectedFont;      // default is system font 14
@property (nonatomic, copy) UIColor * normalColor;      // default is blackColor
@property (nonatomic, copy) UIColor * selectedColor;    // default is blackColor

@end
