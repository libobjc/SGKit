//
//  SGCollectionViewFlowLayout.h
//  SGKit
//
//  Created by Single on 2016/11/5.
//  Copyright © 2016年 single. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGCollectionViewFlowLayout;

@protocol SGCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(SGCollectionViewFlowLayout *)collectionViewLayout backgroundColorForSectionAtIndex:(NSInteger)section;

@end

@interface SGCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
