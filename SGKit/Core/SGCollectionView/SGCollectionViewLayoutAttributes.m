//
//  SGCollectionViewLayoutAttributes.m
//  SGKit
//
//  Created by Single on 2016/11/5.
//  Copyright © 2016年 single. All rights reserved.
//

#import "SGCollectionViewLayoutAttributes.h"

@implementation SGCollectionViewLayoutAttributes

- (id)copyWithZone:(NSZone *)zone
{
    SGCollectionViewLayoutAttributes * obj = [super copyWithZone:zone];
    obj.color = [self.color copyWithZone:zone];
    obj.backgroundView = self.backgroundView;
    return obj;
}

@end
