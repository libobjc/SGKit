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
@optional
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(SGCollectionViewFlowLayout *)collectionViewLayout backgroundColorForSectionAtIndex:(NSInteger)section;
@end

// 不支持 collectionView delete/insert 操作，会导致未知错误
@interface SGCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
