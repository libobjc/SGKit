//
//  SGPageItem.h
//  SGKit
//
//  Created by Single on 2016/11/18.
//  Copyright © 2016年 single. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SGPageItemDelegate <NSObject>
@optional
- (UIScrollView *)scrollViewInPageItem:(UIView *)pageItem;
@end

@interface SGPageItem : UIView <SGPageItemDelegate>

@property (nonatomic, strong) UIView * contentView;

@end
