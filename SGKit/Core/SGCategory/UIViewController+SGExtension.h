//
//  UIViewController+SGExtension.h
//  SGKit
//
//  Created by Single on 2016/11/6.
//  Copyright © 2016年 single. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIViewController *(^SGBootViewControllerBlock)();

@interface UIViewController (SGExtension)

+ (void)sg_setBootViewControllerBlock:(SGBootViewControllerBlock)bootViewControllerBlock;
+ (UIViewController *)sg_topViewController; // 使用前先设置 bootViewControllerBlock

@end
