//
//  SGPageTitleItem.h
//  SGKit
//
//  Created by Single on 2016/11/17.
//  Copyright © 2016年 single. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGPageTitleItem : UIView

@property (nonatomic, assign) CGFloat itemWidth;     // default is 80;
@property (nonatomic, assign) CGFloat bottomLineWidth;      // default is 80;

- (void)normalStyle;
- (void)selectedStyle;

@end
