//
//  SGCollectionReusableView.m
//  SGKit
//
//  Created by Single on 2016/11/5.
//  Copyright © 2016年 single. All rights reserved.
//

#import "SGCollectionReusableView.h"
#import "SGCollectionViewLayoutAttributes.h"

@implementation SGCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:[SGCollectionViewLayoutAttributes class]]) {
        self.backgroundColor = [(SGCollectionViewLayoutAttributes *)layoutAttributes color];
        self.backgroundView = [(SGCollectionViewLayoutAttributes *)layoutAttributes backgroundView];
    }
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    if (_backgroundView != backgroundView) {
        if (_backgroundView && _backgroundView.superview == self) {
            [_backgroundView removeFromSuperview];
        }
        _backgroundView = backgroundView;
        if (backgroundView) {
            [self addSubview:backgroundView];
            backgroundView.frame = self.bounds;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
}

@end
