//
//  NSString+SGSize.m
//  SGKit
//
//  Created by Single on 01/12/2016.
//  Copyright © 2016 single. All rights reserved.
//

#import "NSString+SGSize.h"

@implementation NSString (SGSize)

- (CGFloat)sg_widthOfFont:(UIFont *)font
{
    NSDictionary * attribute = @{NSFontAttributeName : font};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attribute
                                     context:nil];
    return rect.size.width;
}

- (CGFloat)sg_heightOfFont:(UIFont *)font
{
    NSDictionary * attribute = @{NSFontAttributeName : font};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attribute
                                     context:nil];
    return rect.size.height;
}

@end
