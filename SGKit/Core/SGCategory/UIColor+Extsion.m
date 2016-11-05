//
//  UIColor+Extsion.m
//  SGKit
//
//  Created by Single on 2016/11/5.
//  Copyright © 2016年 single. All rights reserved.
//

#import "UIColor+Extsion.h"

@implementation UIColor (Extsion)

+ (instancetype)randomColor
{
    return [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
}

@end
