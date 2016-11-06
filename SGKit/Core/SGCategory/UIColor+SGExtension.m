//
//  UIColor+SGExtension.m
//  SGKit
//
//  Created by Single on 2016/11/6.
//  Copyright © 2016年 single. All rights reserved.
//

#import "UIColor+SGExtension.h"

@implementation UIColor (SGExtension)

+ (instancetype)sg_randomColor
{
    return [self sg_colorWithRGB:arc4random() % 0xFFFFFF];
}

+ (instancetype)sg_colorWithRGB:(NSInteger)RGB
{
    return [self sg_colorWithRGB:RGB alpha:1.0];
}

+ (instancetype)sg_colorWithRGB:(NSInteger)RGB alpha:(CGFloat)alpha
{
    NSInteger red = (RGB & 0xFF0000) >> 16;
    NSInteger green = (RGB & 0xFF00) >> 8;
    NSInteger blue = RGB & 0xFF;
    return [self sg_colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (instancetype)sg_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    return [self sg_colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (instancetype)sg_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

@end
