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
    }
}

@end
