//
//  SGPageItem.h
//  SGKit
//
//  Created by Single on 2016/11/18.
//  Copyright © 2016年 single. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGPageView.h"

@interface SGPageItem : UIView <SGPageItemDelegate>

@property (nonatomic, strong) UIView * contentView;

@end
