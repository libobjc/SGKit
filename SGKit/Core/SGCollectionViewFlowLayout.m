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

@implementation SGCollectionViewFlowLayout

+ (Class)layoutAttributesClass
{
    return [SGCollectionViewLayoutAttributes class];
}

- (void)prepareLayout
{
    [super prepareLayout];
    [self registerClass:[SGCollectionReusableView class] forDecorationViewOfKind:DecorationReuseIdentifier];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray * attributes = [super layoutAttributesForElementsInRect:rect];
    if (![self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:backgroundColorForSectionAtIndex:)]) return attributes;
    
    NSMutableArray * allAttributes = [NSMutableArray arrayWithArray:attributes];
    for (UICollectionViewLayoutAttributes * attribute in attributes)
    {
        // Look for the first item in a row
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
        {
            self.sectionInset = [((id <UICollectionViewDelegateFlowLayout>) self.collectionView.delegate)
                                 collectionView:self.collectionView layout:self insetForSectionAtIndex:attribute.indexPath.section];
        }
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)])
        {
            self.minimumLineSpacing = [((id <UICollectionViewDelegateFlowLayout>) self.collectionView.delegate) collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:attribute.indexPath.section];
        }
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)])
        {
            self.itemSize = [((id <UICollectionViewDelegateFlowLayout>) self.collectionView.delegate) collectionView:self.collectionView layout:self sizeForItemAtIndexPath:attribute.indexPath];
        }
        if (attribute.representedElementKind == UICollectionElementCategoryCell
            && roundl(attribute.frame.origin.x) == roundl(self.sectionInset.left))
        {
            // Create decoration attributes
            SGCollectionViewLayoutAttributes * decorationAttributes =
            [SGCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:DecorationReuseIdentifier withIndexPath:attribute.indexPath];
            decorationAttributes.frame = CGRectMake(0, attribute.frame.origin.y - (self.sectionInset.top),self.collectionViewContentSize.width, self.itemSize.height + (self.minimumLineSpacing + self.sectionInset.top + self.sectionInset.bottom));
            
            // Set the zIndex to be behind the item
            decorationAttributes.zIndex = attribute.zIndex-1;
            decorationAttributes.color = [(id <SGCollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self backgroundColorForSectionAtIndex:attribute.indexPath.section];
            [allAttributes addObject:decorationAttributes];
        }
    }
    return allAttributes;
}

@end
