//
//  SGTransformViewExample.m
//  SGDemo
//
//  Created by Single on 19/12/2016.
//  Copyright © 2016 single. All rights reserved.
//

#import "SGTransformViewExample.h"
#import <SGKit/SGKit.h>

@interface SGTransformViewExample () <SGTransformViewDelegate>

@property (nonatomic, strong) SGTransformView * transformView;

@end

@implementation SGTransformViewExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.transformView = [[SGTransformView alloc] initWithFrame:CGRectMake(50, 150, 200, 100)];
    self.transformView.backgroundColor = [UIColor yellowColor];
    self.transformView.delegate = self;
    [self.view addSubview:self.transformView];
}

/*
- (CGPoint)transformView:(SGTransformView *)transformView needChangeCenterByMoveAction:(CGPoint)center
{
    CGFloat minCenterX = transformView.frame.size.width / 2;
    CGFloat maxCenterX = [UIScreen mainScreen].bounds.size.width - minCenterX;
    
    if (center.x < minCenterX) {
        return CGPointMake(minCenterX, center.y);
    } else if (center.x > maxCenterX) {
        return CGPointMake(maxCenterX, center.y);
    }
    
    return center;
}
 */

@end
