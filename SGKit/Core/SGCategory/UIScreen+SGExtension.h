//
//  UIScreen+SGExtension.h
//  SGKit
//
//  Created by Single on 2016/11/6.
//  Copyright © 2016年 single. All rights reserved.
//

#import <UIKit/UIKit.h>

// 屏幕尺寸
typedef NS_ENUM(NSUInteger, SGScreenSizeType)
{
    SGScreenSizeTypeUnknown,
    SGScreenSizeType35,   // 3.5寸
    SGScreenSizeType40,   // 4.0寸
    SGScreenSizeType47,   // 4.7寸
    SGScreenSizeType55,   // 5.5寸
};

@interface UIScreen (SGExtension)

+ (SGScreenSizeType)sg_screenSizeType;
+ (UIImage *)sg_snapshot;

+ (CGRect)sg_bounds;
+ (CGSize)sg_size;
+ (CGPoint)sg_origin;
+ (CGFloat)sg_x;
+ (CGFloat)sg_y;
+ (CGFloat)sg_width;
+ (CGFloat)sg_height;

@end
