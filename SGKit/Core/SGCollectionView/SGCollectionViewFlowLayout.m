//
//  SGCollectionViewFlowLayout.m
//  SGKit
//
//  Created by Single on 2016/11/5.
//  Copyright © 2016年 single. All rights reserved.
//

#import "SGCollectionViewFlowLayout.h"
#import "SGCollectionViewLayoutAttributes.h"
#import "SGCollectionReusableView.h"

static NSString * const DecorationReuseIdentifier = @"DecorationReuseIdentifier";

@interface SGCollectionViewFlowLayout ()

@property (nonatomic, strong) NSMutableArray <SGCollectionViewLayoutAttributes *> * decorationAttributesArray;

@end

@implementation SGCollectionViewFlowLayout

+ (Class)layoutAttributesClass
{
    return [SGCollectionViewLayoutAttributes class];
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    if (![self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:backgroundColorForSectionAtIndex:)]) return;
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    if (!sectionCount) return;
    
    [self registerClass:[SGCollectionReusableView class] forDecorationViewOfKind:DecorationReuseIdentifier];
    [self.decorationAttributesArray removeAllObjects];
    for (NSInteger i = 0; i < sectionCount; i++)
    {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        if (!itemCount) continue;
        
        UICollectionViewLayoutAttributes * first = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        UICollectionViewLayoutAttributes * last = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:itemCount-1 inSection:i]];
        
        UIEdgeInsets sectionInset = self.sectionInset;
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            sectionInset = [(id <UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:i];
        }
        
        CGRect sectionFrame = CGRectUnion(first.frame, last.frame);
        sectionFrame.origin.x -= sectionInset.left;
        sectionFrame.origin.y -= sectionInset.top;
        
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            sectionFrame.size.width += sectionInset.left + sectionInset.right;
            sectionFrame.size.height = self.collectionView.frame.size.height;
        } else {
            sectionFrame.size.width = self.collectionView.frame.size.width;
            sectionFrame.size.height += sectionInset.top + sectionInset.bottom;
        }
        
        SGCollectionViewLayoutAttributes * attributes = [SGCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:DecorationReuseIdentifier withIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        attributes.frame = sectionFrame;
        attributes.zIndex = -1;
        attributes.color = [(id <SGCollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self backgroundColorForSectionAtIndex:0];
        [self.decorationAttributesArray addObject:attributes];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray * attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray * allAttributes = [NSMutableArray arrayWithArray:attributes];
    for (SGCollectionViewLayoutAttributes * obj in self.decorationAttributesArray) {
        if (CGRectIntersectsRect(rect, obj.frame)) {
            [allAttributes addObject:obj];
        }
    }
    return allAttributes;
}

- (NSMutableArray<SGCollectionViewLayoutAttributes *> *)decorationAttributesArray
{
    if (!_decorationAttributesArray) {
        _decorationAttributesArray = [NSMutableArray array];
    }
    return _decorationAttributesArray;
}

@end
