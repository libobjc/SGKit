//
//  UIScreen+SGExtension.m
//  SGKit
//
//  Created by Single on 2016/11/6.
//  Copyright © 2016年 single. All rights reserved.
//

#import "UIScreen+SGExtension.h"

@implementation UIScreen (SGExtension)

+ (SGScreenSizeType)sg_screenSizeType
{
    if (![UIScreen instancesRespondToSelector:@selector(currentMode)]) return SGScreenSizeTypeUnknown;
    
    CGSize size = [UIScreen mainScreen].currentMode.size;
    if (CGSizeEqualToSize(size, CGSizeMake(1242, 2208)))
    {
        return SGScreenSizeType55;
    }
    else if (CGSizeEqualToSize(size, CGSizeMake(750, 1334)))
    {
        return SGScreenSizeType47;
    }
    else if (CGSizeEqualToSize(size, CGSizeMake(640, 1136)))
    {
        return SGScreenSizeType40;
    }
    else if (CGSizeEqualToSize(size, CGSizeMake(640, 960)))
    {
        return SGScreenSizeType35;
    }
    return SGScreenSizeTypeUnknown;
}

+ (UIImage *)sg_snapshot
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow * window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width * [[window layer] anchorPoint].x, -[window bounds].size.height * [[window layer] anchorPoint].y);
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
            CGContextRestoreGState(context);
        }
    }
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (CGRect)sg_bounds
{
    return [UIScreen mainScreen].bounds;
}

+ (CGSize)sg_size
{
    return [self sg_bounds].size;
}

+ (CGPoint)sg_origin
{
    return [self sg_bounds].origin;
}

+ (CGFloat)sg_x
{
    return [self sg_origin].x;
}

+ (CGFloat)sg_y
{
    return [self sg_origin].y;
}

+ (CGFloat)sg_width
{
    return [self sg_size].width;
}

+ (CGFloat)sg_height
{
    return [self sg_size].height;
}

@end
