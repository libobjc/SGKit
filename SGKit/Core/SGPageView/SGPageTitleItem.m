//
//  SGPageTitleItem.m
//  SGKit
//
//  Created by Single on 2016/11/17.
//  Copyright © 2016年 single. All rights reserved.
//

#import "SGPageTitleItem.h"

@implementation SGPageTitleItem

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self UILayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self UILayout];
    }
    return self;
}

- (void)UILayout
{
    self.itemWidth = 80;
}

- (void)normalStyle
{
    self.backgroundColor = [UIColor blackColor];
}

- (void)selectedStyle
{
    self.backgroundColor = [UIColor cyanColor];
}

@end
