//
//  SGPageTitleItem.m
//  SGKit
//
//  Created by Single on 2016/11/17.
//  Copyright © 2016年 single. All rights reserved.
//

#import "SGPageTitleItem.h"

@implementation SGPageTitleItem

{
    CGFloat width;
}

- (void)normalStyle
{
    self.backgroundColor = [UIColor redColor];
}

- (void)selectedStyle
{
    self.backgroundColor = [UIColor cyanColor];
}

- (CGFloat)itemWidth
{
    if (width <= 0) {
        width = arc4random() % 100 + 100;
    }
    return width;
}

@end
