//
//  UIColor+SGExtension.h
//  SGKit
//
//  Created by Single on 2016/11/6.
//  Copyright © 2016年 single. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SGExtension)

+ (instancetype)sg_randomColor; // 随机颜色
+ (instancetype)sg_colorWithRGB:(NSInteger)RGB; // 16进制RGB
+ (instancetype)sg_colorWithRGB:(NSInteger)RGB alpha:(CGFloat)alpha;
+ (instancetype)sg_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue; // 0~255
+ (instancetype)sg_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

+ (instancetype)sg_redColor;
+ (instancetype)sg_greenColor;
+ (instancetype)sg_grayColor;

@end
