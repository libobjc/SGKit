//
//  UIColor+SGExtension.h
//  SGKit
//
//  Created by Single on 2016/11/6.
//  Copyright © 2016年 single. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SGExtension)

+ (instancetype)sg_randomColor;
+ (instancetype)sg_colorWithRGB:(NSInteger)RGB;
+ (instancetype)sg_colorWithRGB:(NSInteger)RGB alpha:(CGFloat)alpha;
+ (instancetype)sg_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (instancetype)sg_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

@end
