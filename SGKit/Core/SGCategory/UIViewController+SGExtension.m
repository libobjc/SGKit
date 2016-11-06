//
//  UIViewController+SGExtension.m
//  SGKit
//
//  Created by Single on 2016/11/6.
//  Copyright © 2016年 single. All rights reserved.
//

#import "UIViewController+SGExtension.h"

@implementation UIViewController (SGExtension)

static SGBootViewControllerBlock bootViewControllerBlock = nil;

+ (void)sg_setBootViewControllerBlock:(SGBootViewControllerBlock)block
{
    bootViewControllerBlock = [block copy];
}

+ (UIViewController *)sg_topViewController
{
    if (!bootViewControllerBlock) return nil;
    UIViewController * viewController = bootViewControllerBlock();
    return [self topViewControllerWithViewController:viewController];
}

+ (UIViewController *)topViewControllerWithViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController * obj = (UINavigationController *)viewController;
        return [self topViewControllerWithViewController:obj.visibleViewController];
    }
    return viewController;
}

@end
